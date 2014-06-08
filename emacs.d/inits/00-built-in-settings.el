;; 行末の空白を保存時に削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 外部でファイルが変更された時にバッファを再読み込みする
(global-auto-revert-mode)

;; 文字コード
(set-language-environment "japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; コマンド履歴の保存 http://qiita.com/akisute3@github/items/4b489c0abbb39a5dcc45
(setq desktop-globals-to-save '(extended-command-history))

;;
;; recentf and recentf-ext.el の設定
;;
(require 'recentf)
(setq recentf-save-file "~/.emacs.d/.recentf")
(setq recentf-max-saved-items 500)            ;; recentf に保存するファイルの数
(setq recentf-auto-cleanup 10)                ;; 保存する内容を整理
(run-with-idle-timer 30 t 'recentf-save-list) ;; 30秒ごとに .recentf を保存
(require 'recentf-ext)
