;; .emacs.d/init.el

;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Emacs itself
(use-package emacs
  :custom
  (inhibit-startup-message t)          ;; Hide the startup messag
  :config
  (kill-buffer "*scratch*")
  (global-linum-mode t)                ;; Enable line numbers globall
  (set-language-environment "UTF-8")   ;; For cyrillic chars
  (setq-default cursor-type 'bar)      ;; Thin cursor
  (global-hl-line-mode 1)              ;; Highlighting the active line
  (show-paren-mode t))                 ;; Highlight matching paranthesis

;; Color scheme
(use-package solarized-theme
  :ensure t
  ;; :custom
  ;; (solarized-distinct-fringe-background t "Make the fringe to look distinct")
  :config
  (load-theme 'solarized-light t))

;; Popup windows manupulation
(use-package popwin
  :ensure t
  :config
  (popwin-mode))

;; Smart commenting
(use-package comment-dwim-2
  :ensure t
  :bind
  ("M-;" . comment-dwim-2))

;; Indentation
(use-package aggressive-indent
  :ensure t
  :config
  (global-aggressive-indent-mode 1))


;; ==========================================
;;  >>>>>>>>>> Python Environment <<<<<<<<<<
;; ==========================================

(use-package python
  :ensure t

  :mode
  ("\\.py\\'" . python-mode)

  :bind
  (:map
   python-mode-map
   ("C-c C-c" . compile)))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (elpy-company-backend "jedi"))

(use-package py-autopep8
  :ensure t
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;;;; Jedi
(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))

;;;; Flycheck
(use-package flycheck
  :ensure t
  :diminish "Ⓕ"
  :custom
  (flycheck-check-syntax-automatically
   '(save mode-enabled) "Only check on save")
  :bind
  (:map
   flycheck-mode-map
   ("<f5>" . flycheck-buffer)))

;;>>>>>>>>>>>>>>>>>> LSP <<<<<<<<<<<<<<<<<<<<<

;; (use-package lsp-mode
;;   :ensure t
;;   :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;          (python-mode . lsp)
;;          ;; if you want which-key integration
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands lsp)

;; (use-package lsp-ui :commands lsp-ui-mode)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; (use-package lsp-jedi
;;   :ensure t
;;   :config
;;   (with-eval-after-load "lsp-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     (add-to-list 'lsp-enabled-clients 'jedi)))

;;>>>>>>>>>>>>>>>>>> LSP <<<<<<<<<<<<<<<<<<<<<


;; Tool for dependency management and packaging in Python
(use-package poetry
  :ensure t)

;; Run Clojure
(use-package cider
  :ensure t)

;; Clojure linter
(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))


;; Black formatting on save
(use-package blacken
  :ensure t)

;; Auto complete
(use-package company
  :ensure t
  
  :bind
  ("C-c /" . company-files)
  (:map
   company-mode-map
   ("M-<tab>" . company-complete))
  (:map company-active-map
        ("C-n" . company-select-next-or-abort)
        ("C-p" . company-select-previous-or-abort))
  
  :hook
  (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 2))

;; Smart parentheses
(use-package smartparens
  :config (smartparens-global-mode 1))  ;; or t ?

;; Tree layout file explorer
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq
     treemacs-width                         25)))

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

;; For jumping to visible text
(use-package avy
  :ensure t
  :bind
  ("C-;" . 'avy-goto-char)
  ("C-'" . 'avy-goto-char-2))

;; Indentation
(use-package highlight-indentation
  :diminish highlight-indentation-mode

  :commands (highlight-indentation-mode))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; (use-package rainbow-identifiers
;;   :ensure t
;;   :custom
;;   (rainbow-identifiers-cie-l*a*b*-lightness 30)
;;   (rainbow-identifiers-cie-l*a*b*-saturation 50)
;;   (rainbow-identifiers-choose-face-function
;;    #'rainbow-identifiers-cie-l*a*b*-choose-face)
;;   :hook
;;   (emacs-lisp-mode . rainbow-identifiers-mode) ; actually, turn it off
;;   (prog-mode . rainbow-identifiers-mode))

;; (use-package rainbow-mode
;;   :ensure t
;;   :hook '(prog-mode help-mode))


;; ========================
;;  >>> For the future <<<
;; ========================

;; Make bindings that stick around
;; (use-package hydra
;;   :ensure t)

;; Display available keybindings in popup
;; (use-package which-key
;;   :ensure t)


