{
  description = "A very basic flake";

  inputs = {
  	nixpkgs.url ="github:nixos/nixpkgs/nixos-unstable";
	home-manager = {
	url = github:nix-community/home-manager;
	inputs.nixpkgs.follows = "nixpkgs";
	};
	

};




  outputs = { self, nixpkgs, home-manager }: 
	let
		user = "loco";
		system = "x86_64-linux";
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
		lib = nixpkgs.lib;

	in{
		nixosConfigurations = {
			vostro = lib.nixosSystem {
				inherit system;
				modules = [ 
					./configuration.nix 
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.loco = {
						imports =[ ./home.nix ];
					};
					}
				];
			};
			hp = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
	};
		hmConfig = {
			loco = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.${system};
				modules = [
					./home.nix
				{
				home = {
				username = "${user}";
				homeDirectory = "/home/${user}";
				};
				}
				];
			};
		};
  };



}
