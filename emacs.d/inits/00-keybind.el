;; ;; C-h をバックスペースに。
(global-set-key "\C-h" 'backward-delete-char)

;; M-backspace で1単語削除
(global-set-key (kbd "C-M-h") 'backward-kill-word)

;; mark-ring // enable to pop `mark-ring' repeatedly like C-u C-SPC C-SPC ...
(setq set-mark-command-repeat-pop t)

;;--------------------
;; ウィンドウ移動
;;--------------------
;; 反対側のｳｨﾝﾄﾞｳにいけるように
(setq windmove-wrap-around t)
;; C-M-{p,n,f,b}でｳｨﾝﾄﾞｳ間を移動
(define-key global-map (kbd "C-M-p") 'windmove-up)
(define-key global-map (kbd "C-M-n") 'windmove-down)
(define-key global-map (kbd "C-M-f") 'windmove-right)
(define-key global-map (kbd "C-M-b") 'windmove-left)
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window  1))) ; ctrl押しっぱなしでも移動可能
(global-set-key (kbd "C-x C-n") (lambda () (interactive) (other-window  1))) ; ctrl押しっぱなしでも移動可能
(global-set-key (kbd "C-x C-p") (lambda () (interactive) (other-window -1))) ; 逆方向の移動



;;--------------------
;; 行の複製
;;--------------------
(defun duplicate-line() "キルバッファを使わない一行複製"
    (interactive)
    (save-excursion
        (let (a)
            (setq a (buffer-substring (line-beginning-position) (line-beginning-position 2)))
            (next-line)
            (move-beginning-of-line nil)
            (insert a)
            (message "Line duplicated")
        )
    )
)
(global-set-key (kbd "C-x y") 'duplicate-line)
