{ pkgs ? import <nixpkgs> { } }:

let
  manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
in pkgs.rustPlatform.buildRustPackage {
  pname = manifest.name;
  version = manifest.version;
  cargoLock.lockFile = ./Cargo.lock;
  src = ./.;

  propagatedBuildInputs = with pkgs; [
    notmuch
  ];

  meta = with pkgs.lib; {
    description = "JMAP integration for notmuch mail";
    homepage = "https://github.com/elizagamedev/mujmap/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ elizagamedev ];
    mainProgram = "mujmap";
  };
}
