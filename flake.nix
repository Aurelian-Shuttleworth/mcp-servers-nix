{
  inputs.git-hooks.url = "github:cachix/git-hooks.nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      lib = import ./lib;

      packages = forAllSystems (
        system: (import ./. { pkgs = import nixpkgs { inherit system; }; }).packages
      );

      overlays.default = import ./overlays;

      checks = lib.foldr (x: acc: lib.recursiveUpdate x acc) { } [
        (forAllSystems (system: import ./tests { pkgs = import nixpkgs { inherit system; }; }))
        (forAllSystems (
          system:
          import ./examples {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        ))
        (forAllSystems (system: {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              statix.enable = true;
              deadnix.enable = true;
              black.enable = true;
              isort.enable = true;
              shellcheck.enable = true;
              shfmt.enable = true;
            };
          };
        }))
        self.packages
      ];

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          };
        }
      );
    };
}
