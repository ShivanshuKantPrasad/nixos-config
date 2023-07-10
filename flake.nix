{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    jetbrains-updater.url = "gitlab:genericnerdyusername/jetbrains-updater";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, hyprland, home-manager, nix-doom-emacs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          inputs.nur.overlay
          inputs.jetbrains-updater.overlay
          inputs.emacs-overlay.overlay
          inputs.kmonad.overlays.default
        ];
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        shivanshu = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = [
            inputs.kmonad.nixosModules.default
	    hyprland.nixosModules.default
	    {
	    	programs.hyprland.enable = true;
	    	programs.waybar.enable = true;
		programs.waybar.package = inputs.hyprland.packages.${system}.waybar-hyprland;
	    }
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.shivanshu = { imports = [ nix-doom-emacs.hmModule ./home.nix ]; };
            }
          ];
        };
      };
    };
}
