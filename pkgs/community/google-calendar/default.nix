{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "google-calendar-mcp";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "nspady";
    repo = "google-calendar-mcp";
    tag = "v${version}";
    hash = "sha256-Ts3Jn2k8ku5iHe2H/m/b9uwcyor3Qs5GU53mMoU1fNI=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-+TNb3Z9LHG09pdn6yP8nqjc6o3uLuAXbEAHgxyRFXm8=";

  meta = {
    description = "MCP integration for Google Calendar to manage events";
    homepage = "https://github.com/nspady/google-calendar-mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "google-calendar-mcp";
  };
}
