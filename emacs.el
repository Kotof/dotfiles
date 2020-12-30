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
  (add-hook 'before-save-hook 'delete-trailing-whitespace)  ;; Delete trailing spaces on save

  :config
  (setq require-final-newline t)        ;; Add new line in the end of a file on save
  ;; (scroll-bar-mode -1)
  (setq initial-scratch-message "")
  (setq-default scroll-bar-width 4)
  (set-window-scroll-bars (minibuffer-window) nil nil)
  (column-number-mode t)
  (delete-selection-mode t)
  (global-linum-mode -1)                ;; Enable line numbers globall
  (set-language-environment "UTF-8")    ;; For cyrillic chars
  (setq-default cursor-type 'bar)       ;; Thin cursor
  (global-hl-line-mode 1)               ;; Highlighting the active line
  (show-paren-mode t)                   ;; Highlight matching paranthesis

  :custom
  (indent-tabs-mode nil "Spaces!")
  (tab-width 4)
  (inhibit-startup-message t)           ;; Hide the startup message
  (inhibit-startup-screen t)            ;; or screen
  (cursor-in-non-selected-windows t)    ;; Hide the cursor in inactive windows
  ;; (echo-keystrokes 0.1)
  )

;; Show full path in the title bar.
(global-visual-line-mode t)
(setq-default frame-title-format "%b (%f)")

(use-package ibuffer
  :ensure t
  :bind
  ([remap list-buffers] . ibuffer))


;; (use-package ace-window
;;   :ensure t
;;   :config
;;   (setq aw-scope 'frame) ;; was global
;;   (global-set-key (kbd "C-x O") 'other-frame)
;;   (global-set-key [remap other-window] 'ace-window)
;;   )

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

;;;; Themes
(use-package espresso-theme :ensure t)           ; Light theme
(use-package parchment-theme :ensure t)          ; Light theme
(use-package cloud-theme :ensure t)              ; Light theme
;; (load-theme 'tsdh-light)                      ; Light theme
(use-package flatland-theme :ensure t)           ; Dark theme
(use-package jetbrains-darcula-theme :ensure t)  ; Dark theme
(use-package srcery-theme :ensure t)             ; Dark theme
(use-package nord-theme :ensure t)               ; Dark theme
;; (load-theme 'misterioso)                      ; Dark theme
;; (set-face-background 'hl-line "#434a43")


(use-package poet-theme                          ; Dark/light theme
  :ensure t
  :init
  ;; (load-theme 'poet t)
  (load-theme 'poet-monochrome t)
  :config
  (setq initial-frame-alist '((background-color . "#e8e5d9")))
  (setq default-frame-alist initial-frame-alist)
  (set-face-background 'hl-line "#dbd8ce")
  :custom-face
  (font-lock-variable-name-face ((t (:foreground "#3d3d3d"))))
  (font-lock-type-face ((t (:foreground "#286b82"))))
  (font-lock-constant-face ((t (:foreground "#47371f"))))
  (font-lock-keyword-face ((t (:foreground "#3d3d3d"))))
  (font-lock-builtin-face ((t (:foreground "#286b82"))))
  (font-lock-function-name-face ((t (:foreground "#3d3d3d"))))  ;; "#474747"
  (font-lock-string-face ((t (:foreground "#396b48"))))   ;; "#515c4b", "#556e48" "#4e5c47", "4c5c44"
  (font-lock-comment-face ((t (:foreground "#9e9e9e"))))  ;; "#8f8f8f", "8f8577"
  (header-line
   ((t (:background "#e0e0e0" :box (:color "#e0e0e0") :underline nil))))
  (mode-line
   ((t (:background "#bfbfbf" :box (:line-width 1 :color "#efefef")))))  ;; "#efefef"
  (mode-line-inactive
   ((t (:box (:color "#efefef" :line-width 1))))))


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
  (setq doom-modeline-bar-width 1
        doom-modeline-height 37))


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
  (org-roam-directory "c:/Users/Elena/Dropbox/Emacs/org-roam/")
  (org-roam-db-location "c:/Users/Elena/Dropbox/Emacs/org-roam/db/org-roam.db")
  (org-directory "c:/Users/Elena/Dropbox/Emacs/org/")
  (org-hide-emphasis-markers t)
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
  :custom
  (cider-repl-result-prefix ";; => "))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))


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

;; (use-package rainbow-mode
;;   :ensure t
;;   :hook '(prog-mode help-mode))
