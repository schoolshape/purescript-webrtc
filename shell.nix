let
  pkgs = import <nixpkgs> {};

  nodeEnv = with pkgs; import ./nix/node-env.nix {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs libtool;
  };

  nodePkgs = import ./nix/node-packages.nix {
    inherit (pkgs) fetchurl fetchgit;
    inherit nodeEnv;
  };

in pkgs.mkShell {
  name = "purescript-webrtc";

  buildInputs = with (pkgs); [
    purescript
  ];
}
