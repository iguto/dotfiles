#====================================================================
# widget
#====================================================================
function _chdir_parent_dir() {
  builtin cd ..
  zle accept-line
}
zle -N _chdir_parent_dir
bindkey '^W' _chdir_parent_dir

#===========================================================
# URLを自動でクオート処理
#===========================================================
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

## smart insert word
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match \
  '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'

#===========================================================
# peco利用のwidget
#===========================================================

#
# github cloned repository list widget.
#
function repository-list () {
  which ghq peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install ghq and peco" > /dev/stderr
    return 1
  fi
  local selected_dir=$(ghq list -p | peco)
  if [ -z $selected_dir ]; then
    return 0
  fi
  BUFFER="cd $selected_dir"
  zle accept-line
  #zle clear-screen
}
zle -N repository-list
bindkey "r" repository-list


function list-directories() {
  which ghq peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install ghq and peco" > /dev/stderr
    return 1
  fi
  directories=$(find -type d -maxdepth 1 -mindepth 1 | sed 's/\.\///' | sort)
  if [ -z $directories ]; then
    echo "directory does not exist."
    return 2
  fi
  directory=$(echo $directories | peco)
  [ $? -eq 1 ] && return 0
  BUFFER="cd $directory"
  cd $directory
  zle accept-line
  list-directories
}
zle -N list-directories
bindkey "d" list-directories

function peco-git-recent-branches () {
  local selected_branch=$( git for-each-ref --format='%(refname)' --sort=-committerdate  refs/heads | ruby -pne '$_.gsub!(/refs\/(heads|remotes)\//, "")' | peco )
  if [ -n "$selected_branch" ]; then
    BUFFER="git checkout $selected_branch"
    zle accept-line
  fi
  #zle clear-screen
}
zle -N peco-git-recent-branches
bindkey '^xb' peco-git-recent-branches


function peco-tmux-session() {
  which tmux peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and tmux"
    return 1
  fi
  sessions=$(tmux ls | ruby -ane 'name,*other=$_.split(" "); puts ("%-20s" % name) + other.join(" ")')
  echo $sessions
  local selected=$(echo $sessions | peco | cut -d: -f 1)
  if [ -z $selected ]; then
    zle clear-screen
    return 0
  fi
  BUFFER="tmux attach -t $selected"
  zle accept-line
}
zle -N peco-tmux-session
bindkey '^s' peco-tmux-session

function peco-git-issue() 
{
  which git-issue peco > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install git-issue and peco"
    return 1
  fi
  local issue=$(git issue | peco | awk '{ print $1 }' | sed 's/#//')
  if [ -z "$issue" ]; then
    zle clear-screen
    return 0
  fi
  BUFFER="git issue $issue"
  zle accept-line
}
zle -N peco-git-issue
bindkey '^Xi' peco-git-issue


