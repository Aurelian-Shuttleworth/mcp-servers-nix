{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  linkedin-scraper = python3.pkgs.buildPythonPackage {
    pname = "linkedin-scraper";
    version = "2.11.2"; # Estimated/Dummy version, verification needed or fetch from git tag if available
    pyproject = true;

    src = fetchFromGitHub {
      owner = "stickerdaniel";
      repo = "linkedin_scraper";
      rev = "30f448df90af834bafb7d9e4caebfd0032605163";
      hash = "sha256-g6yTWPnvYDly7P4Ji2Hn84st7peqSVN57ZTmkKB+46E="; # updated sri
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail "selenium>=4.33.0" "selenium>=4.29.0"
    '';

    build-system = [
      python3.pkgs.hatchling
    ];

    dependencies = with python3.pkgs; [
      lxml
      python-dotenv
      requests
      selenium
    ];
  };

in
python3.pkgs.buildPythonApplication rec {
  pname = "linkedin-mcp-server";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stickerdaniel";
    repo = "linkedin-mcp-server";
    tag = "v${version}";
    hash = "sha256-QaohUnB+aZlmRBhOPHX6J5fRKc+C07l/iBbx8JliS14=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    fastmcp
    inquirer
    keyring
    pyperclip
    linkedin-scraper
  ];

  meta = {
    description = "MCP server for LinkedIn profile, company, and job scraping";
    homepage = "https://github.com/stickerdaniel/linkedin-mcp-server";
    license = lib.licenses.mit; # Check license in repo
    maintainers = [ ];
    mainProgram = "linkedin-mcp-server";
  };
}
