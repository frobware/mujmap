{
  description = "Bridge for synchronizing email and tags between JMAP and notmuch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=e12483116b3b51a185a33a272bf351e357ba9a99";
  };

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = nixpkgs.legacyPackages;

    makeDevShellForSystem = system: {
      default = pkgsFor.${system}.mkShell {
        packages = with pkgsFor.${system}; [
          cargo
          crate2nix
          rust-analyzer
          rustc
          rustfmt
        ];
      };
    };
  in {
    packages = forAllSystems (system: {
      default = pkgsFor.${system}.callPackage ./package.nix { };
    });

    devShells = nixpkgs.lib.genAttrs supportedSystems makeDevShellForSystem;
  };
}