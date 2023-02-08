 { config, pkgs, ... }:
 let
   hydra-package = pkgs.hydra.overrideAttrs (_: {
     patches = [
       ./hydra-patches/eval-badly-locked-flakes.diff
       ./hydra-patches/gh-webhook.diff
       ./hydra-patches/disable-restrict-eval.diff
       ./hydra-patches/status-override.diff
       ./hydra-patches/slack-notification.diff
     ];
     doCheck = false;
   });

 in {
   # restart hydra-queue-runner periodically
   systemd.services.hydra-queue-runner.serviceConfig = {
     Restart = "always";
     RuntimeMaxSec = "1d";
   };

   services.nginx.virtualHosts."everest-ci.paris.inria.fr" = {
     locations."/".proxyPass = "http://localhost:3000/";
   };

   users.users.hydra.packages = [ pkgs.git ];

   age.secrets.github-token-nix-conf = {
     file = ./secrets/github-token-nix-conf.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.github-token-hydra = {
     file = ./secrets/github-token-hydra.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.slack-token-hydra = {
     file = ./secrets/slack-token-hydra.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.hydra-users = {
     file = ./secrets/hydra-users.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.hydra-privateKey = {
     file = ./secrets/id_ed25519.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.hydraDeployKey1 = {
     file = ./secrets/hydra-deploy-key-1.age;
     owner = "hydra";
     mode = "0440";
   };
   age.secrets.hydraDeployKey2 = {
     file = ./secrets/hydra-deploy-key-2.age;
     owner = "hydra";
     mode = "0440";
   };

   services.hydra = {
     enable = true;
     hydraURL = "https://everest-ci.paris.inria.fr";
     notificationSender = "ci@example.org";
     minimumDiskFree = 2;
     minimumDiskFreeEvaluator = 1;
     listenHost = "localhost";
     package = hydra-package;
     useSubstitutes = true;
     extraConfig = ''
       evaluator_pure_eval = false
       <githubstatus>
         jobs = hacl-star:.*:hacl.x86_64-linux
         context = Hydra
         overrideOwner = hacl-star
         overrideRepo = hacl-star
       </githubstatus>
       <githubstatus>
         jobs = hacl-nix:.*:hacl.x86_64-linux
         context = Hydra
         overrideOwner = hacl-star
         overrideRepo = hacl-nix
       </githubstatus>
       <githubstatus>
         jobs = charon:.*:charon.x86_64-linux
         context = Charon build
         overrideOwner = aeneasverif
         overrideRepo = charon
       </githubstatus>
       <githubstatus>
         jobs = charon:.*:tests.x86_64-linux
         context = Charon tests
         overrideOwner = aeneasverif
         overrideRepo = charon
       </githubstatus>
       <githubstatus>
         jobs = charon:.*:tests-polonius.x86_64-linux
         context = Charon tests-polonius
         overrideOwner = aeneasverif
         overrideRepo = charon
       </githubstatus>
       <githubstatus>
         jobs = charon:.*:charon-ml.x86_64-linux
         context = Charon ML
         overrideOwner = aeneasverif
         overrideRepo = charon
       </githubstatus>
       <githubstatus>
         jobs = aeneas:.*:aeneas.x86_64-linux
         context = Aeneas build
         overrideOwner = aeneasverif
         overrideRepo = aeneas
       </githubstatus>
       <githubstatus>
         jobs = aeneas:.*:aeneas-tests.x86_64-linux
         context = Aeneas tests
         overrideOwner = aeneasverif
         overrideRepo = aeneas
       </githubstatus>
       <githubstatus>
         jobs = aeneas:.*:aeneas-verify-fstar.x86_64-linux
         context = Aeneas F*
         overrideOwner = aeneasverif
         overrideRepo = aeneas
       </githubstatus>
       <githubstatus>
         jobs = aeneas:.*:aeneas-verify-coq.x86_64-linux
         context = Aeneas Coq
         overrideOwner = aeneasverif
         overrideRepo = aeneas
       </githubstatus>
       Include ${config.age.secrets.github-token-hydra.path}
       Include ${config.age.secrets.slack-token-hydra.path}
     '';
   };

   services.declarative-hydra = {
     enable = true;
     usersFile = config.age.secrets.hydra-users.path;
     hydraNixConf = ''
       include ${config.age.secrets.github-token-nix-conf.path}
     '';
     sshKeys = {
       id_ed25519 = {
         privateKeyFile = config.age.secrets.hydra-privateKey.path;
         publicKeyFile = ./secrets/id_ed25519.pub;
       };
       deploy_key_1 = {
         privateKeyFile = config.age.secrets.hydraDeployKey1.path;
         publicKeyFile = ./secrets/hydra-deploy-key-1.pub;
       };
       deploy_key_2 = {
         privateKeyFile = config.age.secrets.hydraDeployKey2.path;
         publicKeyFile = ./secrets/hydra-deploy-key-2.pub;
       };
     };
     projects = let
       mkGhProject = { displayname, description, owner, repo, branch ? "master"
         , enabled ? 1, visible ? true }: {
           inherit displayname description enabled visible;
           declarative.file = "spec.json";
           declarative.type = "path";
           declarative.value = "${pkgs.writeTextDir "spec.json" ''
             { "enabled": 1,
               "hidden": false,
               "description": "Everest Jobsets",
               "nixexprinput": "hacl-ci",
               "nixexprpath": "hydra-helpers/generate-jobsets.nix",
               "checkinterval": 3600,
               "schedulingshares": 100,
               "enableemail": true,
               "emailoverride": "",
               "keepnr": 3,
               "inputs": {
                 "hacl-ci": {
                   "type": "git",
                   "value": "https://github.com/hacl-bot/hacl-ci.git main"
                 },
                 "src": {
                   "type": "git",
                   "value": "https://github.com/${owner}/${repo}.git ${branch}"
                 },
                 "prs": {
                   "type": "githubpulls",
                   "value": "${owner} ${repo}"
                 },
                 "refs": {
                   "type": "github_refs",
                   "value": "${owner} ${repo} heads - "
                 },
                 "owner": { "type": "string", "value": "${owner}" },
                 "repo": { "type": "string", "value": "${repo}" }
               }
             }
           ''}";
         };
     in {
       # fstar = mkGhProject {
       #   displayname = "F*";
       #   description = "The F* proof-oriented language";
       #   owner = "fstarlang";
       #   repo = "fstar";
       # };
       #karamel = mkGhProject {
       #  displayname = "Karamel";
       #  description = "Extract F* programs to readable C code";
       #  owner = "fstarlang";
       #  repo = "karamel";
       #};
       hacl-star = mkGhProject {
         displayname = "Hacl*";
         description =
           "A formally verified library of modern cryptographic algorithms";
         owner = "hacl-star";
         repo = "hacl-star";
         branch = "main";
       };
       hacl-nix = mkGhProject {
         displayname = "Hacl Nix";
         description =
           "A formally verified library of modern cryptographic algorithms";
         owner = "hacl-star";
         repo = "hacl-nix";
         branch = "main";
       };
       charon = mkGhProject {
         displayname = "Charon";
         description =
           "Interface with the rustc compiler for the purpose of program verification";
         owner = "aeneasverif";
         repo = "charon";
         branch = "main";
       };
       aeneas = mkGhProject {
         displayname = "Aeneas";
         description = "A verification toolchain for Rust programs";
         owner = "aeneasverif";
         repo = "aeneas";
         branch = "main";
       };
     };
   };
 }
