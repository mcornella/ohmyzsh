#!/usr/bin/env zsh

start=0
end=0

while read line; do
    # match for script lines delimiters
    case $line in
    "### omz:start")
        start=1
        continue
        ;;
    "### omz:end")
        start=0
        end=1
        break
        ;;
    esac

    # if not inside script block go to next line
    (( ! $start )) && continue

    read seq command <<< "$line"
    case $seq in
    '#%') echo hidden: $command ;;
    '#$') echo prompt: $command ;;
    esac
done
