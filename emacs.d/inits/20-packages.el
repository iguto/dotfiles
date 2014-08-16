;; ========================================
;; helm
;; ========================================
(require 'helm-config)
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
;; タグジャンプをhelmで
(global-set-key (kbd "M-.") 'helm-etags-select)
;; helm occur
(global-set-key (kbd "C-M-o") 'helm-occur)
(define-key isearch-mode-map (kbd "C-o") 'helm-occur-from-isearch)

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
;; ace-jump-mode
;; ========================================
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mode-sync))
(define-key global-map (kbd "M-a") 'ace-jump-mode)
