{
  pkgs,
  lib,
}:
{
  toml-inline = _: {
    type =
      with lib.types;
      let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "TOML value with inline table";
          };
      in
      valueType;

    generate =
      name: value:
      pkgs.runCommand name
        {
          value = builtins.toJSON value;
          passAsFile = [ "value" ];
          nativeBuildInputs = with pkgs; [
            python3
            python3Packages.tomlkit
            remarshal
          ];
          preferLocalBuild = true;
        }
        ''
          json2toml "$valuePath" temp.toml
          python3 ${./toml-inline-gen.py} temp.toml > $out
        '';
  };
}
