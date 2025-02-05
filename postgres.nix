{config, pkgs, ...}: {
    # This is the Nix config for the postgres container I'm running off of

	containers.postgres = {
		autoStart = false;
		privateNetwork = true;
		hostAddress = "192.168.10.2";
		localAddress = "192.168.10.3";
		hostAddress6 = "fc00::1";
		localAddress6 = "fc00::2";

		config = {config, pkgs, lib, ... }: {
			services.postgresql = {
				package = pkgs.postgresql_17_jit;
				enable = true;
				enableTCPIP = true;
				ensureDatabases = [
                    "ch1"
				];
                ensureUsers = [
                    {
                        name = "ch1";
                        ensureDBOwnership = true;
                    }
                ];
                initialScript = pkgs.writeText "init-sql-script" ''
                    alter user ch1 with password '#####';
                '';
				authentication = pkgs.lib.mkOverride 10 ''
					#type	db	DBuser	auth-method
					host  sameuser /ch.* 192.168.10.2/32 scram-sha-256
				'';
			};

			system.stateVersion = "25.05";

			networking = {
				firewall = {
					enable = true;
					allowedTCPPorts = [
						5432
					];
				};

				useHostResolvConf = lib.mkForce false;
			};

			services.resolved.enable = true;
		};
	};
}