{
    description = "DB Challenge 1";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        pyproject-nix = {
          url = "github:nix-community/pyproject.nix";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, flake-utils, pyproject-nix, ... }: 
      flake-utils.lib.eachDefaultSystem (system: 
        let 
            pkgs = import nixpkgs { inherit system; };
            python = pkgs.python313.withPackages(p: with p; [
                      argon2-cffi
                      psycopg2
                      flask
                      python-dotenv
                    ]);
            pack = [
              pkgs.postgresql
              pkgs.libargon2
              python
            ];
            fhs = pkgs.buildFHSEnv {
                name = "dbch1-env";
                targetPkgs = _: pack;
            };
        in
        {
          devShell = fhs.env;

          packages.default = python.pkgs.buildPythonPackage rec {
            name = "dbch1";
            pname = "dbch1-test";
            version = "1.0.0";
            src = pkgs.nix-gitignore.gitignoreSource [ ./.gitignore ] ./.;
            propagatedBuildInputs = pack;
          };
        }
    );
}