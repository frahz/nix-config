{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  websockets,
  aiohttp,
  setuptools,
  poetry-core,
  ...
}:
buildPythonPackage rec {
  pname = "smartrent-py";
  version = "v0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ZacheryThomas";
    repo = "smartrent-py";
    tag = version;
    hash = "sha256-UptzFqGpQtefvBE2X0ji1UvEOP8+f/E0w64XuVoVpSM=";
  };

  dependencies = [
    websockets
    aiohttp
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  build-system = [
    poetry-core
    setuptools
  ];

  doCheck = true;

  pythonImportsCheck = [ "smartrent" ];

  meta = with lib; {
    description = "Api for SmartRent locks, thermostats, moisture sensors and switches";
    homepage = "https://github.com/ZacheryThomas/smartrent-py";
    license = licenses.mit;
  };
}
