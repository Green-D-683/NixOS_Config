{ pkgs, inputs, ... }:

{
  #services.nix-daemon.enable = true;

  environment = {
    defaultPackages = with pkgs; [
      zed-editor
      git
      git-crypt
    ];
    shells = [
      pkgs.bash
    ];
    variables = {
      BASH_SILENCE_DEPRECATION_WARNING="1";
    };
    etc."bash.local".text = ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };

  programs.bash = {
    enable = true;
    #completion.enable = true; # Gives a load of errors, but seems to work without this set?
  };
  users.users.daniel.shell = pkgs.bash;

  system.stateVersion = 6;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    #nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
