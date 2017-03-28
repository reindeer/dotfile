# To prevert tmux launching run shell as "ENTRANCE=1 zsh"
#
if [ -z "$TMUX" -a -z "$ENTRANCE" ]; then
	( (tmux has-session -t remote && tmux attach-session -t remote) || (tmux new-session -s remote) ) && exit 0
	echo "tmux failed to start"
fi
fpath=(~/.zsh/functions $fpath)
autoload _known_hosts _ssh

# Environment and shell options.
#
 
zmodload zsh/complist
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE HIST_NO_STORE HIST_VERIFY
setopt EXTENDED_HISTORY HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS APPEND_HISTORY
setopt CORRECT MENU_COMPLETE ALL_EXPORT COMPLETE_IN_WORD
setopt   notify globdots pushdtohome cdablevars autolist
setopt   autocd longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

#correctall correct 

# Modules
#
# Set hsitory stuff.
#
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# Key-bindings.
#

autoload -U compinit
compinit
bindkey -v
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" yank
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" up-line-or-history
bindkey "\e[6~" down-line-or-history
bindkey "\e[A"  history-beginning-search-backward ## up arrow for back-history-search
bindkey "\e[B" history-beginning-search-forward ## down arrow for fwd-history-search
bindkey "^[OA"  history-beginning-search-backward ## up arrow for back-history-search
bindkey "^[OB" history-beginning-search-forward ## down arrow for fwd-history-search
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey -M menuselect "^M" .accept-line
bindkey -M menuselect " " accept-line
bindkey -M menuselect "/" accept-and-infer-next-history
bindkey "^R" history-incremental-search-backward
[[ -z "$terminfo[kpp]" ]] || bindkey -M menuselect "$terminfo[kpp]" vi-backward-word
[[ -z "$terminfo[kdp]" ]] || bindkey -M menuselect "$terminfo[kdp]" vi-forward-word
bindkey -M menuselect "\x7f" undo

# Auto-completion settings.
#
_force_rehash() {
	(( CURRENT == 1 )) && rehash
		return 1
}
#eval `dircolors`
LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"
zstyle ':completion:*' menu select interactive #_complete #_ignored
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*::::' completer _expand _complete _ignored _force_rehash
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:(ssh|scp):*' tag-order '! users'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 

# Set up must-have aliases and alias file.
#
if [ -n $ITERM_SESSION_ID ]; then
	alias ls='ls -hG'
	alias vim='open -a MacVim'
	chpwd() {ls -hG}
else
	alias ls='ls -h --color=auto'
	alias vim='vim -p'
	chpwd() {ls -h --color=auto}
fi
alias sudo='sudo -E'
alias grep='grep --color=auto'
export GREP_COLOR='1;33'
[[ -f $(which grc) ]] &&
	for cmd in ping ping6 traceroute traceroute6 diff netstat nmap tail; do
		alias $cmd="grc --colour=auto $cmd";
	done
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias rm='nocorrect rm'
[ -f ~/.profile ] && source ~/.profile

case $TERM in
	screen)
		precmd () { print -Pn "\033k%~\033\\" }
		preexec () { print -Pn "\033k$1\033\\" }
	;;
esac

autoload -U colors

# See if we can use colors.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done

PR_NO_COLOUR="%{$terminfo[sgr0]%}"

local host_color=$PR_WHITE
local path_p="$PR_BLUE%~$PR_NO_COLOUR%b"
local user_host="$host_color%n@%m$PR_NO_COLOUR"
local root_host="$PR_RED%m$PR_NO_COLOUR"
local date_prompt="[%D{%Y-%m-%d %H:%M:%S}]"
if [[ ${EUID} == 0 ]] ; then
	PROMPT="$root_color${(r:$COLUMNS::—:)}"$'\n'"${user_host} ${date_prompt}"$'\n'"${path_p} $PR_BLUE"$'\n'"$PR_NO_COLOUR# "
	#PROMPT="${root_host} ${date_prompt} $host_color${(r:$COLUMNS/2::—:)}"$'\n'"${path_p} $PR_BLUE"$'\n'"$PR_NO_COLOUR# "
else
	PROMPT="$host_color${(r:$COLUMNS::—:)}"$'\n'"${user_host} ${date_prompt}"$'\n'"${path_p} $PR_BLUE"$'\n'"$PR_NO_COLOUR$ "
	#PROMPT="${user_host} ${date_prompt} $host_color${(r:$COLUMNS/2::—:)}"$'\n'"${path_p} $PR_BLUE"$'\n'"$PR_NO_COLOUR$ "
fi
