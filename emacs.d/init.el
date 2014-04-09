;; ========================================
;; package.el
;; ========================================
(require 'package)
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;; ;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
;; 初期化
(package-initialize)

;; ========================================
;; setting
;; ========================================
;; 対応する括弧を強調
(show-paren-mode t)
;; 入力キー表示速度を早くする
(setq echo-keystrokes 0.1)
;; ;; C-h をバックスペースに。
(global-set-key "\C-h" 'backward-delete-char)
;; 行末の空白を保存時に削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; ; タブ幅
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil) ; 空白でインデント
(defun indent-set ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset   2  ) ; ブロック内のインデント数
  (setq tab-width        2  ) ; タブのインデント数
)
;; 文字コード
(set-language-environment "japanese")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; ファイル名が重複した時に、バッファ名にディレクトリまで含める
(require 'uniquify)
;;(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-buffer-name-style 'forward)
;;--------------------
;; タブ, 全角スペース, 行末空白表示
;;--------------------
(require 'whitespace)
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

;; ========================================
;; helm
;; ========================================
(require 'helm-config)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(helm-mode 1)

;; ========================================
;; auto-complete
;; ========================================
(require 'auto-complete)
(global-auto-complete-mode t)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20140322.321/dict")
(ac-config-default)
;; C-n/C-pで候補選択
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
;; ========================================
;; popwin
;; ========================================
(require 'popwin)
(popwin-mode 1)

;; ========================================
;; 言語ごと設定
;; ========================================
(setq sh-basic-offset 2)
(setq sh-indentation 2)


;; ========================================
;; rails
;; ========================================
;; erbのシンタックス
(require 'rhtml-mode)
;; coffee scriptのシンタックス
(require 'coffee-mode)
;; --------------------
;; projectile-rails    a replacement of rinari
;; --------------------
(require 'projectile)
(projectile-global-mode)
(require 'projectile-rails)
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; use grizzle to select something
(setq projectile-completion-system 'grizzl)
;; emmet-mode
;; --------------------
(require 'emmet-mode)
;; --------------------
;; emmet-helm installed by mannualy
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
