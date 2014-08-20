;; gopathをshellから引き継ぐ
(require 'exec-path-from-shell)
(let ((envs '("PATH" "GOPATH")))
  (exec-path-from-shell-copy-envs envs))

(add-to-list 'load-path "~/.golang/src/github.com/nsf/gocode/emacs")

(add-hook 'before-save-hook 'gofmt-before-save) ;; 保存時にgo fmt

(eval-after-load "go-mode"
  '(progn
     (require 'go-autocomplete)))

(require 'auto-complete-config)

(add-hook 'go-mode-hook
          '(lambda()
             (local-set-key (kbd "M-." 'godef-jump)
             (define-key ac-mode-map (kbd "M-SPC") 'auto-complete))
          )
