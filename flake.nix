{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    # duodesk.url = "path:/home/shivanshu/TwinDesk";
    duodesk.url = "github:InukaAsith/TwinDesk";
    # duodesk.url = "github:0xCodez/DuoDesk";
    duodesk.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { master, stable, nixpkgs, home-manager, nix-matlab, duodesk
    , nix-index-database, ... }@inputs:
    let
      system = "x86_64-linux";
      commonConfig = {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-master = import master commonConfig;
      pkgs-stable = import stable commonConfig;
      pkgs = import nixpkgs (commonConfig // {
        overlays = [
          (self: super: {
            my-emacs = super.emacs30-pgtk;
            virtualbox = pkgs-stable.virtualbox;
          })
          nix-matlab.overlay
          duodesk.overlays.default
          # (import ./twindesk-vcam-overlay.nix)
        ];
      });

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        shivanshu = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.pkgs = pkgs; }
            nixpkgs.nixosModules.readOnlyPkgs
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = null;
              home-manager.users.shivanshu = {
                imports =
                  [ nix-index-database.homeModules.nix-index ./home.nix ];
              };
            }
          ];
        };
      };
    };
}
