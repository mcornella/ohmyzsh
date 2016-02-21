# This file integrates the zsh-history-substring-search script into oh-my-zsh.

source "${0:r:r}.zsh"

if test "$CASE_SENSITIVE" = true; then
  unset HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS
fi

if test "$DISABLE_COLOR" = true; then
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
fi

# Bind terminal-specific up and down keys
# Bind in both emacs and vi modes so it works in both, and is not
# sensitive to whether this is loaded before or after the vi-mode plugin
omz_bindkey -M emacs -t kcuu1 history-substring-search-up
omz_bindkey -M viins -t kcuu1 history-substring-search-up
omz_bindkey -M emacs -t kcud1 history-substring-search-down
omz_bindkey -M viins -t kcud1 history-substring-search-down

