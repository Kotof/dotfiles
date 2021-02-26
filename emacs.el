;; -*- lexical-binding: t-*-


;; ==========================================
;;  >>>>>>>>>> Package management <<<<<<<<<<

;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(setq package-archives
      `(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
;; Initializes the package infrastructure
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Quelpa is a tool to compile and install Emacs Lisp packages locally from local or remote source code
(use-package quelpa
  :ensure t
  :defer t
  :custom
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo."))

(use-package quelpa-use-package
  :init
  (setq quelpa-use-package-inhibit-loading-quelpa t)
  :ensure t)

(use-package diminish
  :ensure t)

(use-package bind-key
  :ensure t)


;; ==========================================
;;  >>>>>>>>>>>>> Emacs itself <<<<<<<<<<<<<

(use-package emacs
  :init
  (add-hook
   'before-save-hook 'delete-trailing-whitespace)       ;; Delete trailing spaces on save

  :config
  (setq require-final-newline t)                        ;; Add new line in the end of a file on save
  (scroll-bar-mode -1)
  (setq initial-scratch-message "")
  ;; (setq-default scroll-bar-width 4)                  ;; Scroll bar width
  (set-window-scroll-bars (minibuffer-window) nil nil)  ;; Hides the minibuffer scroll bar
  (column-number-mode t)                                ;; Displays column number
  (delete-selection-mode t)                             ;; Replaces the selected text by simply typing or pasting other text
  (global-linum-mode -1)                                ;; Enable line numbers globall
  (set-language-environment "UTF-8")                    ;; For cyrillic chars
  (setq-default cursor-type 'bar)                       ;; Thin cursor
  (global-hl-line-mode 1)                               ;; Highlighting the active line
  (show-paren-mode t)                                   ;; Highlight matching paranthesis
  (global-visual-line-mode t)                           ;; Show full path
  (setq-default frame-title-format "%b (%f)")           ;; in the title bar.

  :custom
  (indent-tabs-mode nil "Spaces!")
  (tab-width 4)
  (inhibit-startup-message t)           ;; Hide the startup message
  (inhibit-startup-screen t)            ;; or screen
  (cursor-in-non-selected-windows t)    ;; Hide the cursor in inactive windows
  ;; (echo-keystrokes 0.1)
  )


(use-package ibuffer
  :ensure t
  :bind
  ([remap list-buffers] . ibuffer))

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "C-x o") 'ace-window))

(use-package winner
  :config
  (winner-mode 1))

;; AWESOME:  This makes long-line buffers usable!
;; (setq-default bidi-display-reordering nil)


;; ============================================
;;  >>>>>>>>>>>> Interface tweaks <<<<<<<<<<<<

;;;; Fonts
;; (add-hook 'text-mode-hook (variable-pitch-mode 1))
(set-face-attribute 'default nil :family "Monaco")
(set-face-attribute 'fixed-pitch nil :family "Monaco")
(set-face-attribute 'variable-pitch nil :family "Monaco")

;;;; Light themes
;; (load-theme 'tsdh-light)
;; (use-package espresso-theme :ensure t :config (load-theme 'espresso t))

;; (use-package eink-theme
;;   :ensure t
;;   :init (load-theme 'eink t)
;;   :config
;;   (setq initial-frame-alist '((background-color . "#e8e5d9")))  ;; "e7e7e7"
;;   (setq default-frame-alist initial-frame-alist)
;;   (set-face-background 'hl-line "#dbd8ce")
;;   (set-fringe-mode 6)
;;   :custom-face
;;   (fringe ((t (:background "#bfbfbf" :foreground "#bfbfbf"))))
;;   (font-lock-comment-face ((t (:foreground "#636363" :weight normal))))
;;   (font-lock-doc-face ((t (:foreground "#579E5C" :weight normal))))
;;   (font-lock-string-face ((t (:foreground "#579E5C"))))
;;   (font-lock-builtin-face ((t (:weight black :background nil))))
;;   (font-lock-constant-face ((t (:foreground "#94327a"))))
;;   (font-lock-function-name-face ((t (:foreground "#285F99"))))
;;   (mode-line ((t (:background "#bfbfbf" :height 0.9)))))

(use-package cloud-theme
  :ensure t
  :config (load-theme 'cloud t)
  :custom-face
  (font-lock-keyword-face ((t (:weight normal :foreground "#8A2607"))))
  (mode-line ((t (:height 0.98)))))

;;;; Dark themes
;; (use-package nord-theme :ensure t)
;; (load-theme 'misterioso)
;; (set-face-background 'hl-line "#434a43")

;; Dark/light theme
;; (use-package poet-theme
;; :ensure t
;; :config
;; ;; (load-theme 'poet t)
;; (load-theme 'poet-monochrome t)


(use-package visual-fill-column
  :commands visual-fill-column-mode
  :hook
  (visual-fill-column-mode . visual-line-mode))

;; Date/Time
(use-package time
  :ensure t
  :custom
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  (calendar-week-start-day 1)
  (calendar-date-style 'european))

;; Mouse wheel settings
(use-package mwheel
  :custom
  (mouse-wheel-scroll-amount '(2
                               ((shift) . 5)
                               ((control))))
  (mouse-wheel-progressive-speed nil))

;;;; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-bar-width 3
        doom-modeline-height 31))


;; Popup windows manupulation
(use-package popwin
  :ensure t
  :config
  (popwin-mode))


(use-package hydra
  :ensure t)


;; Dashboard
(use-package maple-scratch
  :ensure nil
  :hook (window-setup . maple-scratch-init)
  :quelpa
  (maple-scratch :repo "honmaple/emacs-maple-scratch" :fetcher github :version original)

  :config
  (setq maple-scratch-source nil
        maple-scratch-number 5
        maple-scratch-center t
        maple-scratch-empty t
        maple-scratch-anywhere nil
        maple-scratch-write-mode 'emacs-lisp-mode
        maple-scratch-items '(maple-scratch-banner
                              maple-scratch-navbar
                              maple-scratch-default
                              maple-scratch-startup)
        maple-scratch-alist
        (append (butlast maple-scratch-alist)
                '(("Init"
                   :action 'maple/open-init-file
                   :desc "Open Init File")
                  ("Test"
                   :action 'maple/open-test-file
                   :desc "Open Test File"))
                (last maple-scratch-alist)))

  (setq maple-scratch-banner
        '(
          "          ╲╭━━━━╮╲╲╭━━╮"
          "          ╲┃╭╮╭╮┃╲╲┃BRO"
          "          ┗┫┏━━┓┣┛╲╰┳━╯"
          "          ╲┃╰━━╯┃━━━╯"
          "          ╲╰┳━━┳╯╲╲╲╲"
          "          ╲╲┛╲╲┗╲╲╲╲╲"
          ))

  (setq maple-scratch-navbar-alist
        '(("HOME"
           :action (lambda() (find-file (expand-file-name "init.el" user-emacs-directory)))
           :desc "Browse home")
          ("CAPTURE"
           :action 'org-capture
           :desc "Open Org Capture")
          ("AGENDA"
           :action 'org-agenda
           :desc "Open Org Agenda")
          ("HELP"
           :action (lambda() (find-file (expand-file-name "README.org" user-emacs-directory)))
           :desc "Emacs Help"))))


;; ===========================================
;;  >>>>>>>>>>>>>>>>> Dired <<<<<<<<<<<<<<<<<

(use-package dired-recent
  :ensure t
  ;; :bind
  ;; (:map
  ;;  dired-recent-mode-map ("C-x C-d" . nil))
  :config
  (dired-recent-mode 1))


;; ===========================================
;;  >>>>>>>>>>>>>>>>>> ORG <<<<<<<<<<<<<<<<<<

(use-package org-roam
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Dropbox/Emacs/org-roam/")
  (org-roam-db-location "~/Dropbox/Emacs/org-roam/db/org-roam.db")
  (org-directory "~/Dropbox/Emacs/org/")
  ;; (org-hide-emphasis-markers t)
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
	           ("C-c n r" . org-roam-buffer-toggle-display)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(use-package htmlize
  :ensure t)

(use-package org-bullets
  :ensure t
  :custom
  (org-bullets-bullet-list '("◉" "•" "•" "•" "•" "•" "•"))
  ;; org-bullets-bullet-list
  ;; default: "◉ ○ ✸ ✿"
  ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
  ;; Small: ► • ★ ▸
  ;; (org-bullets-bullet-list '("•"))
  ;; others: ▼, ↴, ⬎, ⤵, ⤷,…, ⇳, ⇊, 🠗
  ;; (org-ellipsis "⤵")
  (org-ellipsis "⤵")
  :hook
  (org-mode . org-bullets-mode))

(use-package olivetti
  :ensure t
  :custom
  (olivetti-body-width 95)
  :hook
  (text-mode-hook . olivetti-mode))


;; ===========================================
;;  >>>>>>>>>> Python Environment <<<<<<<<<<

(use-package python
  :ensure t
  :mode
  ("\\.py\\'" . python-mode)
  :bind
  (:map
   python-mode-map
   ("C-c C-c" . compile))
  :config
  (setq python-shell-interpreter "python"
	    ;; python-shell-interpreter-args "-i")
        ))


;; ==========================================
;;  >>>>>>>>>>> Checking/linting <<<<<<<<<<<

;;;; Flycheck
(use-package flycheck
  :ensure t
  ;; :diminish "Ⓕ"  ;; F5
  :custom
  (flycheck-check-syntax-automatically
   '(save mode-enabled))
  :bind
  (:map
   flycheck-mode-map
   ("<f5>" . flycheck-buffer))
  :hook
  (prog-mode . flycheck-mode))


;; ==========================================
;;  >>>>>>>>>>>>>>> LSP-mode <<<<<<<<<<<<<<<

(use-package lsp-mode
  :hook
  ((python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c C-l")
  :config
  (setq lsp-signature-auto-activate nil            ;; 12
        lsp-ui-doc-show-with-cursor nil            ;; 2
        lsp-ui-doc-show-with-mouse nil             ;; 2
        ;; lsp-enable-symbol-highlighting nil      ;; 1
	    ;; lsp-diagnostics-provider :flycheck)     ;; 8
	    ))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-pyright
  :ensure t
  ;; :config
  ;; (setq lsp-pyright-auto-import-completions nil
  ;;       lsp-pyright-diagnostic-mode 'openFilesOnly)
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred


;; ==========================================
;;  >>>>>>>>>>>>>>> WEB-mode <<<<<<<<<<<<<<<

(use-package web-mode
  :ensure t
  :config
  (setq-default indent-tabs-mode nil)
  :custom
  (css-indent-offset 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-enable-auto-indentation nil)
  (web-mode-enable-auto-pairing nil)
  (web-mode-engines-alist '(("django" . "\\.html\\'")))
  :mode ;; Copied from spacemacs
  (("\\.xml\\'"        . web-mode)
   ("\\.html\\'"       . web-mode)
   ("\\.htm\\'"        . web-mode)
   ("\\.djhtml\\'"     . web-mode))
  ;; :hook
  ;; (web-mode . tree-sitter-hl-mode)
  ;; (web-mode . (lambda () (fk/add-local-hook 'before-save-hook 'fk/indent-buffer)))
  )

(use-package auto-rename-tag
  :ensure t
  :hook
  (web-mode . auto-rename-tag-mode))


;; ===========================================
;;  >>>>>>>>>>>>>>>> Clojure <<<<<<<<<<<<<<<<

(use-package cider
  :ensure t
  :config
  (setq cider-show-error-buffer 'only-in-repl)
  :custom
  (cider-repl-result-prefix ";;-> "))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))


;; ===========================================
;;  >>>>>>>> Racket (Geiser), Pollen <<<<<<<<

(use-package racket-mode
  :ensure t)

(use-package geiser
  :ensure t
  :mode
  ("\\.rkt\\'" . racket-mode)
  :hook
  (racket-mode . smartparens-strict-mode))

(use-package pollen-mode
  :ensure t
  :commands (pollen-mode)
  :init
  (add-to-list 'auto-mode-alist '("\\.pm$" . pollen-mode))
  (add-to-list 'auto-mode-alist '("\\.pmd$" . pollen-mode))
  (add-to-list 'auto-mode-alist '("\\.pp$" pollen-mode t))
  (add-to-list 'auto-mode-alist '("\\.p$"  pollen-mode t)))


;; ===========================================
;;  >>>> Autocompletion and abbreviation <<<<

;; Auto complete
(use-package company
  :ensure t
  :diminish t
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
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.0)) ;; default is 0.2)

(use-package company-quickhelp
  :ensure t
  :after
  (company)
  :diminish
  company-quickhelp-mode
  :bind
  (:map
   company-active-map
   ("C-h" . company-quickhelp-manual-begin)))

(use-package company-web
  :ensure t
  :after web-mode
  :config
  (add-to-list 'company-backends '(company-web-html :with company-yasnippet)))

;; YASnippet is a template system for Emacs. It allows you to type an abbreviation and automatically expand it into function templates.
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"))
  (yas-global-mode 1))


;; ===========================================
;;  >>>>> Minibuffer (search, commands) <<<<<

(use-package ivy
  :diminish t
  :ensure t
  :bind
  ;; (:map
  ;;  ivy-minibuffer-map
  ;;  ("TAB" . ivy-partial))
  :config
  (ivy-mode t))

(use-package counsel
  :ensure t
  :diminish t
  :bind
  ([remap insert-char] . counsel-unicode-char)
  :config
  (counsel-mode 1))

(use-package swiper
  :bind
  ("M-s s" . swiper)
  (:map
   isearch-mode-map
   ("M-s s" . swiper-from-isearch)))

(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode)
  ;; :after (ivy)
  ;; :custom
  ;; (ivy-rich-path-style 'abbrev)
  ;; :hook
  ;; (ivy-mode . ivy-rich-mode)
  )


(use-package which-key
  :ensure t
  :init (which-key-mode t)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


;; ===========================================
;;  >>>>>>>>>>>>>>>> Editing <<<<<<<<<<<<<<<<

;; Regular undo-redo.
(use-package undo-fu
  :ensure t
  :bind
  ("C-z" . undo-fu-only-undo)
  ("C-S-z" . undo-fu-only-redo)
  ("C-/" . undo-fu-only-undo)
  ("C-M-/" . undo-fu-only-redo))


;; ;; Smart parentheses
(use-package smartparens
  :ensure t
  :config (smartparens-global-mode 1))

;; Smart commenting
(use-package comment-dwim-2
  :ensure t
  :bind
  ("M-;" . comment-dwim-2))

;; Indentation
(use-package aggressive-indent
  :ensure t
  :diminish
  (aggressive-indent-mode "↹")
  :config
  (global-aggressive-indent-mode 1))

;; Tree layout file explorer
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn (setq treemacs-width 25))
  :bind
  ("C-c t r" . treemacs))

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))


;; ===========================================
;;  >>>>>>>>>>>>>> Quick jumps <<<<<<<<<<<<<<

;; For jumping to visible text
(use-package avy
  :ensure t
  :bind
  ("C-;" . 'avy-goto-char)
  ("C-'" . 'avy-goto-char-2))


;; ===========================================
;;  >>>>>>>>>>>>>>>> Writing <<<<<<<<<<<<<<<<

(use-package writegood-mode
  :defer t
  :ensure t)


;; ==========================================
;;  >>>>>>>>>>>>> Highlighting <<<<<<<<<<<<<

;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

;; Highlight color
(use-package rainbow-mode
  :ensure t
  :hook '(prog-mode help-mode))

;; (use-package highlight-indent-guides
;;   :ensure t
;;   :diminish highlight-indent-guides-mode
;;   :hook (;; (python-mode . highlight-indent-guides-mode)
;;          (prog-mode . highlight-indent-guides-mode)
;;          (highlight-indent-guides-mode . (lambda ()
;;                                            (set-face-foreground 'highlight-indent-guides-character-face "#8f9091")
;;                                            (set-face-foreground 'highlight-indent-guides-top-character-face "#fe5e10"))))
;;   :config
;;   (setq highlight-indent-guides-method 'character)
;;   ;; (progn
;;   ;;   (setq highlight-indent-guides-method 'character

;;   ;;         highlight-indent-guides-character ?\┆ ;; candidates: , ⋮, ┆, ┊, ┋, ┇
;;   ;;         highlight-indent-guides-responsive 'top
;;   ;;         highlight-indent-guides-auto-enabled nil
;;   ;;         highlight-indent-guides-auto-character-face-perc 10
;;   ;;         highlight-indent-guides-auto-top-character-face-perc 20))
;;   )

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

;; ------------------------------------------------------------------
