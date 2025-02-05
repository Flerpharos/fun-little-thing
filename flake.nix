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
            fhs = pkgs.buildFHSEnv {
                name = "dba1-env";
                targetPkgs = _: with pkgs; [
                    postgresql
                    libargon2
                    (python313.withPackages(p: with p; [
                      argon2-cffi
                      psycopg2
                      flask
                      python-dotenv
                    ]))
                ];
            };
            project = pyproject-nix.lib.project.loadPyproject {
              projectRoot = ./.;
            };
            python = pkgs.python313;
        in
        {
          devShell = fhs.env;

          packages.default = 
            let
              attrs = project.renderers.buildPythonPackages { inherit python; };
            in
              python.pkgs.buildPythonPackage (attrs {
              });
        }
    );
}