{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
    launch-terminal = lib.getExe inputs.self.packages.${pkgs.system}.launch-terminal;
  in {
    wayland.windowManager.hyprland.settings.bindd = [
      # Web applications
      "SUPER SHIFT, M, Gmail, exec, ${launch-webapp} \"https://mail.google.com\""
      "SUPER SHIFT, C, Google Calendar, exec, ${launch-webapp} \"https://calendar.google.com\""
      "SUPER SHIFT, Y, YouTube, exec, ${launch-webapp} \"https://youtube.com\""
      "SUPER SHIFT, N, NotebookLM, exec, ${launch-webapp} \"https://notebooklm.google.com\""
      "SUPER SHIFT, R, Readwise Reader, exec, ${launch-webapp} \"https://read.readwise.io\""
      "SUPER SHIFT, P, p5.js Editor, exec, ${launch-webapp} \"https://editor.p5js.org\""
      "SUPER SHIFT, G, Google Drive, exec, ${launch-webapp} \"https://drive.google.com\""
      "SUPER SHIFT, A, Open Claude webapp, exec, ${launch-webapp} \"https://claude.ai\""

      # Native applications
      "SUPER SHIFT, S, Spotify, exec, ${pkgs.spotify}/bin/spotify"
      "SUPER SHIFT, D, LazyDocker, exec, ${launch-terminal} -e lazydocker"
    ];
  };
}
