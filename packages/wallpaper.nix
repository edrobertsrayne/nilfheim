{
  pkgs,
  inputs,
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "wallpaper";
  src = "${inputs.wallpapers}/images";
  timestamp = builtins.toString builtins.currentTime;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    wallpapers=($(find $src -type f -name "*.jpg" -o -name "*.png" -o -name "*.jpeg"))
    cp "''${wallpapers[RANDOM % ''${#wallpapers[@]}]}" $out/current-wallpaper.jpg
  '';
}
