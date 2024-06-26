{ lib
, stdenvNoCC
, fetchurl
, jdk21_headless
, makeBinaryWrapper
}:

let
  mcVersion = "1.21";
  loaderVersion = "0.15.11";
  launcherVersion = "0.11.2";
in
stdenvNoCC.mkDerivation {
  pname = "minecraft-server";
  version = "mc.${mcVersion}-loader.${loaderVersion}-launcher.${launcherVersion}";

  src = fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${mcVersion}/${loaderVersion}/${launcherVersion}/server/jar";
    hash = "sha256-tvYlRJPtDSGCd0FiNC08DBEI5Jmi/NxXH3lQgya5hvM=";
  };

  dontUnpack = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/minecraft-server/minecraft-server.jar 
    makeWrapper ${jdk21_headless}/bin/java $out/bin/minecraft-server \
        --append-flags "-jar $out/share/minecraft-server/minecraft-server.jar --nogui"

    runHook postInstall
  '';
}
