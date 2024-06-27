{ lib
, stdenvNoCC
, fetchurl
, jdk21_headless
, makeBinaryWrapper
}:

let
  mcVersion = "1.20.1";
  loaderVersion = "0.15.11";
  launcherVersion = "1.0.1";
in
stdenvNoCC.mkDerivation {
  pname = "minecraft-server";
  version = "mc.${mcVersion}-loader.${loaderVersion}-launcher.${launcherVersion}";

  src = fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${mcVersion}/${loaderVersion}/${launcherVersion}/server/jar";
    hash = "sha256-/j9wIzYSoP+ZEfeRJSsRwWhhTNkTMr+vN40UX9s+ViM=";
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
