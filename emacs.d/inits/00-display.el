;; 対応する括弧を強調
(show-paren-mode t)

;; 入力キー表示速度を早くする
(setq echo-keystrokes 0.1)

;; ; タブ幅
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil) ; 空白でインデント
(defun indent-set ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset   2  ) ; ブロック内のインデント数
  (setq tab-width        2  ) ; タブのインデント数
)

;; ファイル名が重複した時に、バッファ名にディレクトリまで含める
(require 'uniquify)

;;(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-buffer-name-style 'forward)

;; --------------------
;; menuを隠す
;;--------------------
(cond
 (window-system (tool-bar-mode -1))
 (t (menu-bar-mode -1)))

;;--------------------
;; タブ, 全角スペース, 行末空白表示
;;--------------------
;;---
(defface my-face-b-1 '((t (:background "NavajoWhite4"))) nil) ; 全角スペース
(defface my-face-b-2 '((t (:background "gray10"))) nil) ; タブ
(defface my-face-u-1 '((t (:background "SteelBlue" :underline t))) nil) ; 行末空白表示
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
 (font-lock-add-keywords major-mode '(("\t" 0 my-face-b-2 append)
 ("　" 0 my-face-b-1 append)
 ("[ \t]+$" 0 my-face-u-1 append)
 )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; ============================================================
;; フォント
;; ============================================================
(add-to-list 'default-frame-alist '(font . "Ricty-11"))

;; ========================================
;; 24からのテーマ  M-x customize-themes
;; ========================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (manoj-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
