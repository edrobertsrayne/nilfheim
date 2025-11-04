{inputs, ...}: {
  flake.modules.homeManager.webapps = {
    pkgs,
    lib,
    ...
  }: let
    launch-webapp = lib.getExe inputs.self.packages.${pkgs.system}.launch-webapp;
    launch-terminal = lib.getExe inputs.self.packages.${pkgs.system}.launch-terminal;
  in {
    # Desktop entries for web applications
    xdg.desktopEntries = {
      gmail = {
        name = "Gmail";
        comment = "Google Mail";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://mail.google.com";
        icon = ./../../assets/icons/gmail.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      youtube = {
        name = "YouTube";
        comment = "Watch and share videos";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://youtube.com";
        icon = ./../../assets/icons/youtube.png;
        categories = ["AudioVideo"];
        terminal = false;
        type = "Application";
      };

      claude = {
        name = "Claude (Web)";
        comment = "AI assistant by Anthropic";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://claude.ai";
        icon = ./../../assets/icons/claude-ai.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      google-calendar = {
        name = "Google Calendar";
        comment = "Google Calendar";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://calendar.google.com";
        icon = ./../../assets/icons/google-calendar.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      google-drive = {
        name = "Google Drive";
        comment = "Google Drive cloud storage";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://drive.google.com";
        icon = ./../../assets/icons/google-drive.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      notebooklm = {
        name = "NotebookLM";
        comment = "AI-powered note taking and research assistant";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://notebooklm.google.com";
        icon = ./../../assets/icons/notebooklm.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      readwise = {
        name = "Readwise Reader";
        comment = "Read and annotate articles, PDFs, and more";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://read.readwise.io";
        icon = ./../../assets/icons/readwise.png;
        categories = ["Office"];
        terminal = false;
        type = "Application";
      };

      p5js = {
        name = "p5.js Editor";
        comment = "Creative coding web editor";
        exec = "${pkgs.firefox}/bin/firefox --new-window https://editor.p5js.org";
        icon = ./../../assets/icons/p5js.png;
        categories = ["Development"];
        terminal = false;
        type = "Application";
      };
    };

    # Hyprland keybinds (co-located with desktop entries!)
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

      # Native applications (keybinds only - .desktop entries are in their own modules)
      "SUPER SHIFT, S, Spotify, exec, ${pkgs.spotify}/bin/spotify"
      "SUPER SHIFT, D, LazyDocker, exec, ${launch-terminal} -e lazydocker"
    ];
  };
}
