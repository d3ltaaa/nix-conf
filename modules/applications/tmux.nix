{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    applications.configuration.tmux.enable = lib.mkEnableOption "Enables tmux module";
  };
  config = lib.mkIf config.applications.configuration.tmux.enable {
    # Home Manager as NixOS module
    home-manager.users.${config.settings.users.primary} =
      { config, ... }:
      {

        programs.tmux = {
          enable = true;
          plugins = [
            pkgs.tmuxPlugins.better-mouse-mode
            # pkgs.tmuxPlugins.catppuccin
          ];
          keyMode = "vi";
          clock24 = true;
          mouse = true;
          escapeTime = 0;
          terminal = "tmux-256color";
          prefix = "M-space";
          extraConfig = ''
            set -ag terminal-overrides ",xterm-256color:RGB"
            # default statusbar colors
            set-option -g status-bg "#${config.colorScheme.palette.base01}"  # base01 (light background)
            set-option -g status-fg "#${config.colorScheme.palette.base04}"  # base04 (dark foreground)

            # pane number display
            set-option -g display-panes-active-colour "#${config.colorScheme.palette.base0B}"  # base0B (strings, inherited class)
            set-option -g display-panes-colour "#${config.colorScheme.palette.base0A}"  # base0A (classes, search background)

            # clock
            set-window-option -g clock-mode-colour "#${config.colorScheme.palette.base0B}"  # base0B (strings)

            # bell
            set-window-option -g window-status-bell-style fg="#${config.colorScheme.palette.base01}",bg="#${config.colorScheme.palette.base08}"  # base01 (background), base08 (error highlight)

            # split panes using | and -
            unbind '"'
            unbind %

            unbind "\$" # rename-session
            unbind ,    # rename-window
            unbind %    # split-window -h
            unbind '"'  # split-window
            unbind [    # paste-buffer
            unbind ]    
            unbind "'"  # select-window
            unbind n    # next-window
            unbind p    # previous-window
            unbind l    # last-window
            unbind M-n  # next window with alert
            unbind M-p  # next window with alert
            unbind o    # focus thru panes
            unbind &    # kill-window
            unbind "#"  # list-buffer 
            unbind =    # choose-buffer
            unbind z    # zoom-pane
            unbind M-Up  # resize 5 rows up
            unbind M-Down # resize 5 rows down
            unbind M-Right # resize 5 rows right
            unbind M-Left # resize 5 rows left
            unbind c # new window

            bind -n M-O new -s ns

            bind r command-prompt -I "#{window_name}" "rename-window '%%'"
            bind R command-prompt -I "#{session_name}" "rename-session '%%'"

            bind b split-window -h -c "#{pane_current_path}"
            bind v split-window -v -c "#{pane_current_path}"

            bind -n M-v copy-mode
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
            bind P paste-buffer
            bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel



            bind Enter new-window

            bind -n M-i previous-window
            bind -n M-o next-window

            bind -n M-x kill-pane
            bind -n M-X kill-window

            bind -n M-Enter resize-pane -Z

            bind -n M-Tab last-window   # cycle thru MRU tabs

            bind -n M-J swap-pane -D
            bind -n M-K swap-pane -U

            bind -n M-C-h resize-pane -L 5
            bind -n M-C-l resize-pane -R 5
            bind -n M-C-k resize-pane -U 5
            bind -n M-C-j resize-pane -D 5

            bind -n M-h select-pane -L
            bind -n M-j select-pane -D
            bind -n M-k select-pane -U
            bind -n M-l select-pane -R

          '';
        };
      };
  };
}
