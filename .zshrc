function ealias {
    cond=$3
    if [ "x$cond" = "x" ]; then
        $cond=$2
    fi
    which $cond > /dev/null 2>&1
    ret=$?
    if [ $ret -eq 0 ]; then
        alias $1="$2"
    else
        echo "not found command $2"
    fi
}

autoload -U compinit
compinit 2> /dev/null
autoload -U colors
colors 2> /dev/null
autoload -Uz is-at-least
autoload -Uz vcs_info

fpath=(/usr/local/share/zsh-completions $fpath)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e

setopt auto_cd
setopt auto_pushd pushd_ignore_dups
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt nolistbeep
setopt multios
setopt brace_ccl
setopt prompt_subst
setopt transient_rprompt
setopt complete_aliases

HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt EXTENDED_HISTORY
export WORDCHARS='*?[]~=&;!#$%^(){}<>'

autoload zed

autoload history-search-end
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

autoload bashcompinit
bashcompinit

eval "$(jump shell)"

alias -g G="|grep"
alias -g L="|less -S"
alias -g H="|head"
alias -g T="|tail -f"
alias -g S="|sort"
alias -g W="|wc -l"
alias -g C="LANG=C"

alias where="command -v"
alias vi="vim"
alias ll="ls -la"

alias tailf="tail -f"

alias gp="git push origin \`git branch | grep '*' | sed -e 's/* //g'\`"

case `uname` in
Darwin)
    alias updatedb="sudo /usr/libexec/locate.updatedb"
    ;;
Linux)
    ;;
esac

local FGBLK='%{[30m%}' #black
local FGRED='%{[31m%}' #reg
local FGGRN='%{[32m%}' #green
local FGYLW='%{[33m%}' #yelow
local FGBLU='%{[34m%}' #blue
local FGMGN='%{[35m%}' #magenta
local FGCYN='%{[36m%}' #cyan
local FGWHT='%{[37m%}' #white
local BGBLK='%{[40m%}' #black
local BGRED='%{[41m%}' #red
local BGGRN='%{[42m%}' #green
local BGYLW='%{[43m%}' #yelow
local BGBLU='%{[44m%}' #blue
local BGMGN='%{[45m%}' #magenta
local BGCYN='%{[46m%}' #cyan
local BGWHT='%{[47m%}' #white
local DEF='%{[m%}' #reset color
case ${UID} in
0)
    PROMPT="%B%(?.$FGRED.$BGYLW$FGRED)%n$DEF%b %(!.#.$) "
    PROMPT2="%B$FGRED%_>$DEF%b "
    SPROMPT="correct: %R -> %r [nyae]? "
    RPROMPT="%B[$FGGRN%~$DEF]%b"
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        PROMPT="%B$FGCYN${HOST%%.*}$DEF%b ${PROMPT}"
    fi
    ;;
*)
    PROMPT="%(?.$FGRED.$BGYLW$FGRED)%n$DEF %(!.#.$) "
    PROMPT2="$FGRED%_>$DEF "
    SPROMPT="correct: %R -> %r [nyae]? "
    RPROMPT="%1(v|%F{green}%1v%f|)[$FGGRN%~$DEF]"
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        PROMPT="$FGCYN${HOST%%.*}$DEF ${PROMPT}"
    fi
    ;;
esac

if [ "$TERM" = "screen" ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
        fg)
            if (($#cmd == 1)); then
                cmd=(builtin jobs -l %+)
            else
                cmd=(builtin jobs -l $cmd[2])
            fi
            ;;
        %*)
            cmd=(builtin jobs -l $cmd[1])
            ;;
        cd)
            if (($#cmd == 2)); then
                cmd[1]=$cmd[2]
            fi
            ;&
        *)
            echo -n "k$cmd[1]:t\\"
            return
            ;;
        esac
        local -A jt; jt=(${(kv)jobtexts})
        $cmd >>(read num rest
            cmd=(${(z)${(e):-\$jt$num}})
            echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

. $(brew --prefix)/etc/profile.d/z.sh
function precmd () {
    z --add "$(pwd -P)"
}

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

function get_git_worktree_info() {
    local worktree_name=""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # worktreeのルートディレクトリを取得
        local worktree_root=$(git rev-parse --show-toplevel 2>/dev/null)
        if [[ -n "$worktree_root" ]]; then
            # worktreeの名前を取得（ディレクトリ名）
            worktree_name=$(basename "$worktree_root")
            # メインのworktreeでない場合はworktree名を表示
            local git_dir=$(git rev-parse --git-dir 2>/dev/null)
            if [[ "$git_dir" == *".git/worktrees/"* ]]; then
                echo "($worktree_name)"
            fi
        fi
    fi
}

precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    local git_info=""
    local worktree_info=$(get_git_worktree_info)
    
    if [[ -n "$vcs_info_msg_0_" ]]; then
        git_info="$vcs_info_msg_0_"
        if [[ -n "$worktree_info" ]]; then
            git_info="${git_info}${worktree_info}"
        fi
        psvar[1]="$git_info"
    fi
}

function ls_abbrev() {
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

function show_ls_gitstatus() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}

zle -N show_ls_gitstatus
alias l=show_ls_gitstatus

function cdworktree() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi
    local target_worktree_name="$1"
    local current_worktree_root=$(git rev-parse --show-toplevel)
    local current_path=$(pwd)
    local relative_path=${current_path#$current_worktree_root}
    # Get all worktrees with their paths and branch names
    local worktrees_info=$(git worktree list --porcelain)
    local target_worktree=""
    if [[ -z "$target_worktree_name" ]]; then
        # No argument provided - find the main worktree (the one without a separate .git/worktrees entry)
        local main_repo_path=$(git rev-parse --git-common-dir | sed 's|/.git$||')
        if [[ "$main_repo_path" != "$current_worktree_root" ]]; then
            target_worktree="$main_repo_path"
        else
            echo "Already in the main worktree"
            return 0
        fi
    else
        # Search for worktree by name (directory basename or branch name)
        while IFS= read -r line; do
            if [[ "$line" =~ ^worktree\ (.+)$ ]]; then
                local worktree_path="${match[1]}"
                local worktree_dir=$(basename "$worktree_path")
                # Skip current worktree
                if [[ "$worktree_path" == "$current_worktree_root" ]]; then
                    continue
                fi
                # Check if the directory name matches
                if [[ "$worktree_dir" == "$target_worktree_name" ]]; then
                    target_worktree="$worktree_path"
                    break
                fi
            elif [[ "$line" =~ ^branch\ (.+)$ ]]; then
                local branch_name="${match[1]}"
                # Check if the branch name matches
                if [[ "$branch_name" == "$target_worktree_name" || "$branch_name" == "refs/heads/$target_worktree_name" ]]; then
                    # Use the previously found worktree path
                    if [[ -n "$worktree_path" ]]; then
                        target_worktree="$worktree_path"
                        break
                    fi
                fi
            fi
        done <<< "$worktrees_info"
    fi
    if [[ -z "$target_worktree" ]]; then
        if [[ -z "$target_worktree_name" ]]; then
            echo "Error: Could not find main worktree"
        else
            echo "Error: Worktree '$target_worktree_name' not found"
        fi
        return 1
    fi
    local target_path="$target_worktree$relative_path"
    if [[ ! -d "$target_path" ]]; then
        echo "Warning: Target directory does not exist: $target_path"
        echo "Jumping to worktree root instead: $target_worktree"
        target_path="$target_worktree"
    fi
    cd "$target_path"
    echo "$target_path ($target_worktree_name)"
}
alias cdw="cdworktree"

for config in `ls $HOME/.zshrc.* 2> /dev/null`; do
    source $config
done

test -e /Users/makoto.kataigi/.iterm2_shell_integration.zsh && source /Users/makoto.kataigi/.iterm2_shell_integration.zsh || true

# Added by Antigravity
export PATH="/Users/makoto.kataigi/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
