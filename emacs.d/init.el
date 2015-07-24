;; (setq user-emacs-directory "~/.ghq/github.com/iguto/dotfiles/emacs.d/")

(require 'package)
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
;; init-loader
;; ========================================
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")

;; ========================================
;; 言語ごと設定
;; ========================================
(setq sh-basic-offset 2)
(setq sh-indentation 2)

(require 'undo-tree)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(c-default-style (quote ((c-mode . "linux") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(c-tab-always-indent (quote other))
 '(custom-enabled-themes (quote (manoj-dark)))
 '(js2-basic-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
