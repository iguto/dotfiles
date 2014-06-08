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
;; inf-ruby でpry
; (add-to-list 'inf-ruby-implementations '("pry" . "pry"))
; (setq inf-ruby-default-implementation "pry")

;; robe 高度な補完
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(add-hook 'ruby-mode-hook '(lambda ()
                             (require 'rcodetools)
                             (require 'anything-rcodetools)
                             (require 'myrurema)
                             (load-auto-complete)
                             (define-key ruby-mode-map "\M-c" 'rct-complete-symbol)
                             (define-key ruby-mode-map "\M-d" 'xmp)
                             (setq ruby-deep-indent-paren-style nil)))

(autoload 'robe-mode "robe" "Code navigation, documentation lookup and completion for Ruby" t nil)
(autoload 'robe-ac-setup "ac-robe" "robe auto-complete" nil nil)
(add-hook 'robe-mode-hook 'robe-ac-setup)
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
