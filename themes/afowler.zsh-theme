### omz:start
## Create a git repository in ~/code/redcar
#% git init ~/code/redcar
#% cd ~/code/dotfiles
## Create a ruby project inside
#% mkdir -p bin lib plugins share tasks vendor
#% touch CHANGES Gemfile{,.lock} LICENSE Rakefile README.md
#% git add -A; git commit -m 'Initial commit'
## These are commands that will appear in the screenshot
#$ ls
#$ pwd
## Add an empty #$ line to show an empty prompt
#$
### omz:end

if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%m %{${fg_bold[blue]}%}:: %{$reset_color%}%{${fg[green]}%}%3~ $(git_prompt_info)%{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%} '

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
