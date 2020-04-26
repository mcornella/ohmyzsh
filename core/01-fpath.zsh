is_plugin() {
  local base_dir="$1" name="$2"
  builtin test -f "$base_dir/plugins/$name/$name.plugin.zsh" \
    || builtin test -f "$base_dir/plugins/$name/_$name"
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $ZSH_CUSTOM $plugin; then
    fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $ZSH $plugin; then
    fpath=($ZSH/plugins/$plugin $fpath)
  else
    echo "[oh-my-zsh] plugin '$plugin' not found"
  fi
done
