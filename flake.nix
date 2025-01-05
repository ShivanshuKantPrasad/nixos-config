{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-24.11";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, stylix, kmonad, master, stable, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      commonConfig = {
        inherit system;
        config.allowUnfree = true;
      };
      # pkgs-master = import master commonConfig;
      pkgs-stable = import stable commonConfig;
      pkgs = import nixpkgs (commonConfig // {
        overlays = [
          inputs.kmonad.overlays.default
          (self: super: {
            my-emacs = super.emacs29-pgtk;
            quickemu = pkgs-stable.quickemu;
            rofi-file-browser = pkgs-stable.rofi-file-browser;
            jetbrains = pkgs-stable.jetbrains;
          })
        ];
      });

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        shivanshu = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = [
            # stylix.nixosModules.stylix
            # kmonad.nixosModules.default
            ./configuration.nix
            # ./stylix.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.shivanshu = {
                imports =
                  [ inputs.nix-index-database.hmModules.nix-index ./home.nix ];
              };
            }
          ];
        };
      };
    };
}
