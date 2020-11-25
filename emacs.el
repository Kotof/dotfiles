;;;; -*- lexical-binding: t-*-

;; Enables basic packaging support
(require 'package)
;;
;; Adds the Melpa archive to the list of available repositories
(setq package-archives
      `(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))

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
;; Mouse wheel settings
(use-package mwheel
  :custom
  (mouse-wheel-scroll-amount '(2
                               ((shift) . 5)
                               ((control))))
  (mouse-wheel-progressive-speed nil))


(use-package olivetti
  :ensure t
  :custom
  (olivetti-body-width 95))


;; Date/Time
(use-package time
  :ensure t
  :custom
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  (calendar-week-start-day 1)
  (calendar-date-style 'european))

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
  ;; :config
  ;; (elpy-company-backend "jedi")
  )

;; Black formatting on save
(use-package blacken :ensure t)

;; Tool for dependency management and packaging in Python
(use-package poetry :ensure t)

;; ==========================================
;;  >>>>>>>>>>>>>>> Linters <<<<<<<<<<<<<<<

;;;; Flycheck
(use-package flycheck
  :ensure t
  :diminish "Ⓕ"
  :custom
  (flycheck-check-syntax-automatically
   '(save mode-enabled))
  :bind
  (:map
   flycheck-mode-map
   ("<f5>" . flycheck-buffer))
  :hook
  (prog-mode . flycheck-mode))

(use-package flycheck-color-mode-line
  :ensure t
  :after (flycheck)
  :hook
  (flycheck-mode . flycheck-color-mode-line-mode))

;;;; Clojure linter
(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))


;; ==========================================
;;  >>>>>>>>>>>>>>> LSP-mode <<<<<<<<<<<<<<<

(use-package lsp-mode
  :hook
  ((python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))  
  :commands lsp  
  :config
  (setq lsp-signature-auto-activate nil
	lsp-ui-doc-show-with-cursor nil
	lsp-signature-auto-activate nil
	lsp-diagnostics-provider :flycheck))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))  ; or lsp-deferred

;; (use-package lsp-jedi
;;   :ensure t
;;   :config
;;   (with-eval-after-load "lsp-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     (add-to-list 'lsp-enabled-clients 'jedi)))

;; ===========================================
;;  >>>>>>>>>>>>>>>> Clojure <<<<<<<<<<<<<<<<

(use-package cider
  :ensure t)


;; ===========================================
;;  >>>>>>>>>>>>>>>> ??????? <<<<<<<<<<<<<<<<

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

(use-package company-quickhelp
  :ensure t
  :after (company)

  :diminish company-quickhelp-mode

  :bind
  (:map
   company-active-map
   ("C-h" . company-quickhelp-manual-begin)))

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
     treemacs-width 25)))

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


(use-package writegood-mode
  :defer t
  :ensure t)

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


;;--------------------------------------------

;; ;; ===================================================
;; ;;  -------------- Basic Customization --------------
;; ;; ===================================================




;; ;; Use REPL
;; (setq python-shell-interpreter "python"
;;       python-shell-interpreter-args "-i")
;; 
