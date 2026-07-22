{ config
, pkgs
, ...
}:
let
  user = "charon-zulip-bot";
  stateDirectory = "charon-zulip-bot";
  workerPrefix = "charon-zulip-bot-worker-";

  update = pkgs.writeShellApplication {
    name = "update-charon-zulip-bot";
    runtimeInputs = with pkgs; [
      coreutils
      git
      gnugrep
      jq
      nix
      openssh
      systemd
    ];
    text = ''
      state_directory=/var/lib/${stateDirectory}
      releases_directory="$state_directory/releases"
      current_file="$state_directory/current"
      repository=$(jq --exit-status --raw-output \
        '.repository | select(type == "string")' "$CREDENTIALS_DIRECTORY/repository")
      branch=$(jq --exit-status --raw-output \
        '.branch | select(type == "string")' "$CREDENTIALS_DIRECTORY/repository")
      if [[ ! "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
        echo "The Charon bot repository must have the form OWNER/REPOSITORY" >&2
        exit 1
      fi
      if [[ ! "$branch" =~ ^[A-Za-z0-9._/-]+$ ]]; then
        echo "The Charon bot repository branch contains unsupported characters" >&2
        exit 1
      fi

      ssh_repository="ssh://git@github.com/$repository.git"
      ssh_command="ssh -i $CREDENTIALS_DIRECTORY/repository-key -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=/etc/ssh/ssh_known_hosts"

      mkdir -p "$releases_directory"

      start_worker() {
        local revision=$1
        local release=$2
        local worker_unit=${workerPrefix}$revision.service

        if systemctl is-active --quiet "$worker_unit"; then
          return 0
        fi

        local load_state
        load_state=$(systemctl show --property=LoadState --value "$worker_unit" 2>/dev/null || true)
        if [[ "$load_state" == loaded ]]; then
          systemctl reset-failed "$worker_unit" || true
          if ! systemctl start "$worker_unit"; then
            return 1
          fi
        elif ! systemd-run \
          --collect \
          --unit="$worker_unit" \
          --description="Charon Zulip bot ($revision)" \
          --service-type=notify \
          --uid=${user} \
          --gid=${user} \
          --property=NotifyAccess=main \
          --property=Restart=always \
          --property=RestartSec=5s \
          --property=StartLimitIntervalSec=0 \
          --property=TimeoutStartSec=2min \
          --property=TimeoutStopSec=1min \
          --property=KillMode=mixed \
          --property=UMask=0077 \
          --property=NoNewPrivileges=yes \
          --property=PrivateDevices=yes \
          --property=PrivateTmp=yes \
          --property=ProtectControlGroups=yes \
          --property=ProtectHome=yes \
          --property=ProtectKernelModules=yes \
          --property=ProtectKernelTunables=yes \
          --property=ProtectSystem=strict \
          --property=RestrictSUIDSGID=yes \
          --property='RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6' \
          "$release/bin/charon-zulip-bot" ${config.age.secrets.charon-bot.path}
        then
          return 1
        fi

        systemctl is-active --quiet "$worker_unit"
      }

      stop_other_workers() {
        local current_unit=$1
        while read -r old_unit; do
          if [[ "$old_unit" != "$current_unit" ]]; then
            echo "Stopping superseded $old_unit"
            systemctl stop "$old_unit"
          fi
        done < <(
          systemctl list-units --all --type=service --no-legend --plain \
            | grep -oE '${workerPrefix}[0-9a-f]{40}\.service' \
            | sort -u
        )
      }

      previous_revision=
      if [[ -f "$current_file" ]]; then
        read -r previous_revision < "$current_file"
      fi
      if [[ "$previous_revision" =~ ^[0-9a-f]{40}$ ]]; then
        previous_link="$releases_directory/$previous_revision"
        previous_unit=${workerPrefix}$previous_revision.service
        if previous_release=$(readlink -e "$previous_link"); then
          if ! start_worker "$previous_revision" "$previous_release"; then
            echo "The previous Charon Zulip bot failed to become ready" >&2
            systemctl stop "$previous_unit" || true
          fi
        fi
      else
        previous_revision=
      fi

      remote_line=$(git -c core.sshCommand="$ssh_command" ls-remote \
        --exit-code "$ssh_repository" "refs/heads/$branch")
      read -r revision remote_ref <<< "$remote_line"
      if [[ ! "$revision" =~ ^[0-9a-f]{40}$ ]] || [[ "$remote_ref" != "refs/heads/$branch" ]]; then
        echo "Could not resolve the Charon bot repository branch $branch" >&2
        exit 1
      fi

      worker_unit=${workerPrefix}$revision.service
      release_link="$releases_directory/$revision"

      if [[ "$revision" == "$previous_revision" ]] && systemctl is-active --quiet "$worker_unit"; then
        stop_other_workers "$worker_unit"
        exit 0
      fi

      echo "Building Charon Zulip bot at $revision"
      GIT_SSH_COMMAND="$ssh_command" nix --extra-experimental-features 'nix-command flakes' build \
        --no-write-lock-file \
        --out-link "$release_link" \
        "git+$ssh_repository?ref=$branch&rev=$revision#zulip_bot"
      release=$(readlink -e "$release_link")

      if ! start_worker "$revision" "$release"; then
        echo "$worker_unit did not become ready; keeping the previous bot" >&2
        systemctl stop "$worker_unit" || true
        exit 1
      fi

      temporary_current=$(mktemp "$state_directory/.current.XXXXXX")
      printf '%s\n' "$revision" > "$temporary_current"
      mv -f "$temporary_current" "$current_file"

      # The new process has registered its Zulip queue. Stopping the old unit
      # now sends SIGTERM only to the bot process, which drains its current
      # message before exiting. systemd will force-kill its cgroup on timeout.
      stop_other_workers "$worker_unit"

      # Keep the current and immediately previous builds as GC roots. Older
      # store paths can be collected by the machine's normal Nix GC policy.
      for link in "$releases_directory"/*; do
        [[ -L "$link" ]] || continue
        link_revision=''${link##*/}
        if [[ "$link_revision" != "$revision" && "$link_revision" != "$previous_revision" ]]; then
          rm -f -- "$link"
        fi
      done
    '';
  };
in
{
  config = {
    users.groups.${user} = { };
    users.users.${user} = {
      isSystemUser = true;
      group = user;
    };

    age.secrets = {
      charon-bot = {
        file = ./secrets/charon-bot.age;
        owner = user;
        group = user;
        mode = "0400";
      };
      charon-bot-repo-key.file = ./secrets/charon-bot-repo-key.age;
      charon-bot-repo.file = ./secrets/charon-bot-repo.age;
    };

    programs.ssh.knownHosts."github.com" = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };

    systemd.services.charon-zulip-bot-update = {
      description = "Update the Charon Zulip bot";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "nix-daemon.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${update}/bin/update-charon-zulip-bot";
        LoadCredential = [
          "repository-key:${config.age.secrets.charon-bot-repo-key.path}"
          "repository:${config.age.secrets.charon-bot-repo.path}"
        ];
        StateDirectory = stateDirectory;
        StateDirectoryMode = "0755";
        TimeoutStartSec = "1h";
      };
    };

    systemd.timers.charon-zulip-bot-update = {
      description = "Poll GitHub for Charon Zulip bot updates";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "3min";
        OnUnitInactiveSec = "3min";
        AccuracySec = "10s";
        Persistent = true;
        Unit = "charon-zulip-bot-update.service";
      };
    };
  };
}
