# Requirements

[[ -o interactive ]] || return

zmodload zsh/datetime || { print "bgnotify: can't load zsh/datetime"; return }

# default 5 seconds
: ${bgnotify_threshold:=5}


## definitions ##

if ! (( $+functions[bgnotify_formatted] )); then ## allow custom function override
  function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$(( $3 / 60 % 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [[ $1 -eq 0 ]] && bgnotify "#win (took $elapsed)" "$2" || bgnotify "#fail (took $elapsed)" "$2"
  }
fi

currentWindowId () {
  if (( $+commands[osascript] )); then # macOS
    osascript -e 'tell application (path to frontmost application as text) to id of front window' 2> /dev/null || echo "0"
  elif (( $+commands[notify-send] )) || (( $+commands[kdialog] )); then # Linux
    xprop -root 2> /dev/null | awk '/NET_ACTIVE_WINDOW/{print $5;exit} END{exit !$5}' || echo "0"
  else
    echo $EPOCHSECONDS # fallback for Windows
  fi
}

bgnotify () { ## args: (title, subtitle)
  if (( $+commands[terminal-notifier] )); then # macOS
    case "$TERM_PROGRAM" in
      iTerm.app) term_id='com.googlecode.iterm2' ;;
      Apple_Terminal) term_id='com.apple.terminal' ;;
    esac

    if [[ -z "$term_id" ]]; then
      terminal-notifier -message "$2" -title "$1" > /dev/null
    else
      terminal-notifier -message "$2" -title "$1" -activate "$term_id" -sender "$term_id" > /dev/null
    fi
  elif (( $+commands[growlnotify] )); then # macOS growl
    growlnotify -m "$1" "$2"
  elif (( $+commands[notify-send] )); then # Gnome
    notify-send "$1" "$2"
  elif (( $+commands[kdialog] )); then # KDE
    kdialog --title "$1" --passivepopup  "$2" 5
  elif (( $+commands[notifu] )); then # Windows
    notifu /m "$2" /p "$1"
  fi
}


## Zsh hooks ##

bgnotify_begin() {
  bgnotify_timestamp=$EPOCHSECONDS
  bgnotify_lastcmd="$1"
  bgnotify_windowid=$(currentWindowId)
}

bgnotify_end() {
  didexit=$?
  elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))
  if (( bgnotify_timestamp > 0 )) && (( elapsed >= bgnotify_threshold )); then
    if [[ $(currentWindowId) != "$bgnotify_windowid" ]]; then
      print -n "\a"
      bgnotify_formatted "$didexit" "$bgnotify_lastcmd" "$elapsed"
    fi
  fi
  bgnotify_timestamp=0 #reset it to 0!
}

## only enable on a local (non-ssh) connection
if [[ -z "$SSH_CLIENT" && -z "$SSH_TTY" ]]; then
  preexec_functions+=(bgnotify_begin)
  precmd_functions+=(bgnotify_end)
fi
