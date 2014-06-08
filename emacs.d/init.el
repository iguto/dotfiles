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
