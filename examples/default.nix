{ pkgs }:
let
  inherit (pkgs) lib;
in
builtins.listToAttrs (
  map
    (
      example:
      lib.nameValuePair "example-${lib.removeSuffix ".nix" example}" (
        import (./. + "/${example}") { inherit pkgs; }
      )
    )
    (
      builtins.filter (file: (lib.hasSuffix ".nix" file) && (file != "default.nix")) (
        builtins.attrNames (builtins.readDir ./.)
      )
    )
)
