## emacsclient をシームレスに使うための関数
## http://k-ui.jp/?p=243
function e(){
    echo "[$0] emacsclient -c -t $*";
    (emacsclient -c -t $* ||
        (echo "[$0] emacs --daemon"; emacs --daemon &&
            (echo "[$0] emacsclient -c -t $*"; emacsclient -c -t $*)) ||
        (echo "[$0] emacs $*"; emacs $*))
}

# ソケットの場所を環境変数に覚えてもらう
# emacs のバージョンによって少し場所が違うようなので、
# *** "/tmp" を要確認 ***
export USER_ID=`id -u`
export EMACS_TMP_DIR="/tmp/emacs$USER_ID"
export EMACS_SOCK="$EMACS_TMP_DIR/server"

##  $EMACS_TMP_DIR が無いとき
if ! [ -d $EMACS_TMP_DIR ]; then

   #（socket 使わないバージョン、毎回emacs--daemonしてる。。。）
    function se(){
        if which emacsclient
        then
            echo "[$0] emacs --daemon"
            emacs --daemon
            echo "[$0] screen -t emacs emacsclient -t -c $*"
            screen -t emacs emacsclient -t -c $*
        elif which emacs
        then
            echo "[$0] screen emacs -t -c $*";
            screen emacs -t -c $*
        fi
    }
fi

