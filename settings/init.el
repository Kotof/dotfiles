;; .emacs.d/init.el


;; ===================================================
;;  ------------- MELPA Package Support -------------
;; ===================================================

;; Initializes the package infrastructure
(package-initialize)

;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    elpy                            ;; Emacs Lisp Python Environment
    flycheck                        ;; On the fly syntax checking
    flycheck-clj-kondo              ;; Clojure linter
    py-autopep8                     ;; Run autopep8 on save
    blacken                         ;; Black formatting on save
    cider                           ;; Clojure
    rainbow-delimiters              ;; Rainnbow brackets
    treemacs                        ;; Tree layout file explorer
    smartparens                     ;; Deals with parens pairs and tries to be smart about it
    avy                             ;; For jumping to visible text
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


;; ===================================================
;;  -------------- Basic Customization --------------
;; ===================================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(load-theme 'solarized-light t)     ;; Load solarized theme
(global-linum-mode t)               ;; Enable line numbers globally


;; ===================================================
;;  --------------- Development Setup ---------------
;; ===================================================

;; Enable elpy
(elpy-enable)

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable clj-kondo
(require 'flycheck-clj-kondo)

;; Enable Cider autocomlete
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; Use REPL
(setq python-shell-interpreter "python"
      python-shell-interpreter-args "-i")
(setq elpy-rpc-python-command "python")

;;Parentheses
;;
;; Rainbow brackets
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;Smart parentheses
(smartparens-global-mode t)

(show-paren-mode t)  ;; highlight matching paranthesis
;; (setq show-paren-style 'expression)
(global-hl-line-mode 1)
(setq-default cursor-type 'bar)

;;Search
;;
;;Avy
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)

;; Fonts
(set-language-environment "UTF-8")

;;----------------------------------------------------------------
;; User-Defined init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-clj-kondo treemacs solarized-theme smartparens rainbow-delimiters py-autopep8 material-theme flycheck fira-code-mode elpy cider blacken better-defaults)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 143 :width normal :style "Light")))))
