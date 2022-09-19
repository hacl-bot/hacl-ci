 { config, pkgs, ... }:
 let
   hydra-package = pkgs.hydra.overrideAttrs (_: {
     patches = [
       ./hydra-patches/eval-badly-locked-flakes.diff
       ./hydra-patches/gh-webhook.diff
       ./hydra-patches/disable-restrict-eval.diff
       ./hydra-patches/status-override.diff
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
         jobs = comparse:.*
         excludeBuildFromContext = 1
         useShortContext = 1
       </githubstatus>
       <githubstatus>
         jobs = hacl-star:.*:hacl.x86_64-linux
         excludeBuildFromContext = 1
         overrideOwner = hacl-star
         overrideRepo = hacl-star
         context = Hydra
       </githubstatus>
       <githubstatus>
         jobs = hacl-nix:.*:hacl.x86_64-linux
         excludeBuildFromContext = 1
         overrideOwner = hacl-star
         overrideRepo = hacl-nix
         context = Hydra
       </githubstatus>
       <githubstatus>
         jobs = comparse:.*:comparse-tests.x86_64-linux
       </githubstatus>
       <githubstatus>
         jobs = mls-star:.*:mls-tests.x86_64-linux
       </githubstatus>
       Include ${config.age.secrets.github-token-hydra.path}
     '';
   };

   services.declarative-hydra = {
     enable = true;
     usersFile = config.age.secrets.hydra-users.path;
     hydraNixConf = ''
       include ${config.age.secrets.github-token-nix-conf.path}
     '';
     sshKeys = {
       privateKeyFile = config.age.secrets.hydra-privateKey.path;
       publicKeyFile = ./secrets/id_ed25519.pub;
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
               "nixexprinput": "hacl-nix",
               "nixexprpath": "hydra-helpers/generate-jobsets.nix",
               "checkinterval": 3600,
               "schedulingshares": 100,
               "enableemail": true,
               "emailoverride": "",
               "keepnr": 3,
               "inputs": {
                 "hacl-nix": {
                   "type": "git",
                   "value": "https://github.com/hacl-star/hacl-nix.git main"
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
     };
   };
 }
