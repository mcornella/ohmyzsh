# Main settings

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exist, or else we will use the default custom/
: ${ZSH_CUSTOM:="$ZSH/custom"}

# Set ZSH_CACHE_DIR to the path where cache files should be
# created, or else we will use the default cache/
: ${ZSH_CACHE_DIR:="$ZSH/cache"}

# Figure out the SHORT hostname
SHORT_HOST="${(%):-%m}"
# Save the location of the current completion dump file.
: ${ZSH_COMPDUMP:="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"}

## Load core files
for file in "$ZSH"/core/*.zsh; do
    source "$file"
done

## Load lib files
for file in "$ZSH"/lib/*.zsh; do
    custom_file="${ZSH_CUSTOM}/lib/${file:t}"
    [[ -f "$custom_file" ]] && file="$custom_file"
    source "$file"
done

## Load plugins
for plugin in $plugins; do
    if [[ -f "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh" ]]; then
        source "$ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh"
    elif [[ -f "$ZSH/plugins/$plugin/$plugin.plugin.zsh" ]]; then
        source "$ZSH/plugins/$plugin/$plugin.plugin.zsh"
    fi
done

## Load custom configurations
for file in "$ZSH_CUSTOM"/*.zsh(N); do
    source "$file"
done

## Load theme
if [[ -n "$ZSH_THEME" ]]; then
    if [[ -f "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme" ]]; then
        source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
    elif [[ -f "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme" ]]; then
        source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
    else
        source "$ZSH/themes/$ZSH_THEME.zsh-theme"
    fi
fi

unset file custom_file plugin
