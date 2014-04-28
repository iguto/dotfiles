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
;; cask
;; ========================================
(require 'cask "~/.cask/cask.el")
(cask-initialize)

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
;; コマンド履歴の保存 http://qiita.com/akisute3@github/items/4b489c0abbb39a5dcc45
(setq desktop-globals-to-save '(extended-command-history))
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
(global-set-key (kbd "C-x C-b") 'helm-mini)
(helm-mode 1)
;; M-yでキルリングの履歴一覧を表示
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)
;; helm modeでもC-hで1文字削除
(define-key helm-map (kbd "C-h") 'delete-backward-char)
;; tabでディレクトリ移動
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; キーバインドの説明
(require 'helm-descbinds)
(helm-descbinds-mode)
;; find-file時 C-zでディレクトリ移動

;; ========================================
;; auto-complete
;; ========================================
(require 'auto-complete)
(global-auto-complete-mode t)
(require 'auto-complete-config)
(require 'fuzzy)
(ac-config-default)
;; C-n/C-pで候補選択
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
(define-key ac-mode-map (kbd "C-;") 'ac-fuzzy-complete)
(add-to-list 'ac-modes 'slim-mode 'rhtml-mode)
(setq ac-use-fuzzy t)
;; ========================================
;; popwin
;; ========================================
(require 'popwin)
(popwin-mode 1)
;; ========================================
;; gitクライアント magit
;; ========================================
(require 'magit)
;; ========================================
;; gutter
;; ========================================
(require 'git-rebase-mode)
(global-git-gutter-mode +1)
(setq git-gutter:deleted-sign "-")
(setq git-gutter:separator-sign "|")
(set-face-foreground 'git-gutter:separator "gray")
;; ========================================
;; 賢くカッコの自動挿入
;; ========================================
(require 'smartparens-config)
(smartparens-global-mode t)
;; ========================================
;; 指定したキーに続くキーバインドを表示する guide-key http://qiita.com/kbkbkbkb1/items/16bd5cb65be18e804c63
;; ========================================
(require 'guide-key)
;; (setq guide-key/guide-key-sequence '("C-x" "C-x r" "C-x 4" "C-x 5" "C-c r" "C-c p")
(setq guide-key/guide-key-sequence '("C-x" "C-c"))
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 0.3)
(guide-key-mode)
;; ========================================
;; mykie.el
;; ========================================
(require 'mykie)
(setq mykie:use-major-mode-key-override t)
(mykie:initialize)
(mykie:set-keys nil
  "M-;"
  :default (progn
             (end-of-line)
             (set-mark (line-beginning-position))
             (comment-dwim 1))
  :region  (comment-dwim 1)
  "C-w"
  :default (progn
             (kill-region (line-beginning-position) (line-end-position))
             (kill-append "\n" nil))
  :region kill-region
  "M-w"
  :default (progn
             (kill-ring-save (line-beginning-position) (line-end-position))
             (kill-append "\n" nil))
  :region kill-ring-save
  "C-y"
  :default (yank)
  :region (progn
            (kill-new beg end)

            (yank))
)
;; ========================================
;; インデントをハイライト
;; ========================================
(require 'highlight-indentation)
(highlight-indentation-current-column-mode t) ;; 現在行に関連あるインデントの表示

;; ========================================
;; 言語ごと設定
;; ========================================
(setq sh-basic-offset 2)
(setq sh-indentation 2)

;; ========================================
;; ruby
;; ========================================
(require 'ruby-block)
(require 'ruby-tools)
;; ruby-mode でencoding: utf-8 自動挿入をOFFにする
(defun ruby-mode-set-encoding () ())
;; ハイライトするファイルの種類を追加
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
;; --------------------
;; ruby-mode のインデントを綺麗にする http://willnet.in/13
;; --------------------
(setq ruby-deep-indent-paren-style nil)
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))


;; ========================================
;; rails
;; ========================================
(require 'rhtml-mode)
(require 'coffee-mode)
(require 'sass-mode)
(require 'slim-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
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

;; ========================================
;; cygwin用 キーバインド再定義
;; ========================================
; (global-set-key (kbd "[1;5r") 'set-mark-command)

;;-------------------------


;;;; for terminal key translate (only mintty?)
(unless window-system
  (define-key input-decode-map "\e[1;5k" (kbd "C-;"))
  (define-key input-decode-map "\e[1;5l" (kbd "C-,"))
  (define-key input-decode-map "\e[1;5n" (kbd "C-."))
  (define-key input-decode-map "\e[1;5q" (kbd "C-!"))
  (define-key input-decode-map "\e[1;5r" (kbd "C-@"))
  (define-key input-decode-map "\e[1;5s" (kbd "C-#"))
  (define-key input-decode-map "\e[1;5t" (kbd "C-$"))
  (define-key input-decode-map "\e[1;5u" (kbd "C-%"))
  (define-key input-decode-map "\e[1;5v" (kbd "C-&"))
  (define-key input-decode-map "\e[1;5w" (kbd "C-'"))
  (define-key input-decode-map "\e[1;5x" (kbd "C-("))
  (define-key input-decode-map "\e[1;5y" (kbd "C-)"))

  (define-key input-decode-map "\e[1;6k" (kbd "C-S-;"))
  (define-key input-decode-map "\e[1;6l" (kbd "C-S-,"))
  (define-key input-decode-map "\e[1;6m" (kbd "C-S--"))
  (define-key input-decode-map "\e[1;6n" (kbd "C-S-."))
  (define-key input-decode-map "\e[1;6q" (kbd "C-S-!"))
  (define-key input-decode-map "\e[1;6r" (kbd "C-S-@"))
  (define-key input-decode-map "\e[1;6s" (kbd "C-S-#"))
  (define-key input-decode-map "\e[1;6t" (kbd "C-S-$"))
  (define-key input-decode-map "\e[1;6u" (kbd "C-S-%"))
  (define-key input-decode-map "\e[1;6v" (kbd "C-S-&"))
  (define-key input-decode-map "\e[1;6w" (kbd "C-S-'"))
  (define-key input-decode-map "\e[1;6x" (kbd "C-S-("))

  (define-key input-decode-map "" (kbd "C-~"))
  (define-key input-decode-map "" (kbd "C-|"))
  (define-key input-decode-map "" (kbd "C-`"))
  (define-key input-decode-map "" (kbd "C-}"))

  (define-key input-decode-map "\e[1;7k" (kbd "C-M-;")))
