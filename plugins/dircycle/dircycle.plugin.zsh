# enables cycling through the directory stack using
# Ctrl+Shift+Left/Right
#
# left/right direction follows the order in which directories
# were visited, like left/right arrows do in a browser

# NO_PUSHD_MINUS syntax:
#  pushd +N: start counting from left of `dirs' output
#  pushd -N: start counting from right of `dirs' output

switch-to-dir () {
	[[ ${#dirstack} -eq 0 ]] && return

	while ! builtin pushd -q $1 &>/dev/null; do
		# We found a missing directory: pop it out of the dir stack
		builtin popd -q $1

		# Stop trying if there are no more directories in the dir stack
		[[ ${#dirstack} -eq 0 ]] && break
	done
}

insert-cycledleft () {
	emulate -L zsh
	setopt nopushdminus

	switch-to-dir +1
	zle reset-prompt
}
zle -N insert-cycledleft

insert-cycledright () {
	emulate -L zsh
	setopt nopushdminus

	switch-to-dir -0
	zle reset-prompt
}
zle -N insert-cycledright


omz_bindkey -c ctrl-shift left insert-cycledleft
omz_bindkey -c ctrl-shift right insert-cycledright
