;;; -*- lexical-binding: t; -*-

;; Enables basic packaging support
(require 'package)
;; Adds the Melpa archive to the list of available repositories
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")
                          ;; ("marmalade" . "https://marmalade-repo.org/packages/")
                          ("org" . "https://orgmode.org/elpa/")
                          ;; ("user42" . "https://download.tuxfamily.org/user42/elpa/packages/")
                          ("emacswiki" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/emacswiki/")
                          ;; ("sunrise" . "http://joseito.republika.pl/sunrise-commander/")
                          ;; ("gnu" . "https://elpa.gnu.org/packages/")
                          ))
(customize-set-variable 'package-enable-at-startup nil)
;; Initializes the package infrastructure
(package-initialize)


;; Straight (не помню для чего нужен был...)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)

(use-package use-package-core
  :custom
  ;; (use-package-verbose t)
  ;; (use-package-minimum-reported-time 0.005)
  (use-package-enable-imenu-support t))

;; enable the Garbage Collector Magic Hack
;; https://gitlab.com/koral/gcmh
(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1))

;; Use use-package to extend its own functionality by some more useful keywords.
(use-package system-packages
  :ensure t
  :custom
  (system-packages-noconfirm t))

(use-package use-package-ensure-system-package :ensure t)


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

;; This one tries to speed up Emacs startup a little bit.
(use-package fnhh
  :quelpa
  (fnhh :repo "a13/fnhh" :fetcher github)
  :config
  (fnhh-mode 1))

;; This adds :custom-update keyword to use-package.
(use-package use-package-custom-update
  :quelpa
  (use-package-custom-update
   :repo "a13/use-package-custom-update"
   :fetcher github
   :version original))

;; Try packages without installing
(use-package try
  :ensure t
  :defer t)

;; Modernized Package Menu
;; https://github.com/Malabarba/paradox
(use-package paradox
  :ensure t
  :defer 1
  :config
  (paradox-enable))


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
  (setq initial-frame-alist '((width . 140)
                              (height . 40)
                              (tool-bar-lines . 0)
                              (bottom-divider-width . 0)
                              (right-divider-width . 1))
        default-frame-alist initial-frame-alist
        frame-inhibit-implied-resize t
        x-gtk-resize-child-frames 'resize-mode)

  :custom
  (indent-tabs-mode nil "Spaces!")
  (tab-width 4)
  (inhibit-startup-message t)           ;; Hide the startup message
  (inhibit-startup-screen t)            ;; or screen
  (cursor-in-non-selected-windows t)    ;; Hide the cursor in inactive windows
  ;; (echo-keystrokes 0.1)
  )


(setq-default fringe-indicator-alist
              (assq-delete-all 'truncation fringe-indicator-alist))


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


;; (use-package display-line-numbers
;;   :straight nil
;;   :hook (prog-mode . display-line-numbers-mode)
;;   :custom
;;   (display-line-numbers-width 4)
;;   (display-line-numbers-grow-only t)
;;   (display-line-numbers-width-start t)
;;   :config
;;   (define-advice previous-line (:around (f &rest args) aorst:previous-line-margin)
;;     "The `display-line-numbers' mode affects `scroll-margin' variable.

;; This advice recalculates the amount of lines needed to scroll to
;; ensure `scroll-margin' preserved."
;;     (apply f args)
;;     (let ((diff (- scroll-margin
;;                    (- (line-number-at-pos (point))
;;                       (line-number-at-pos (window-start))))))
;;       (when (> diff 0)
;;         (scroll-down diff)))))


;; ============================================
;;  >>>>>>>>>>>>> Spell checking <<<<<<<<<<<<<

;; (use-package mule
;;   :defer 0.1
;;   :config
;;   (prefer-coding-system 'utf-8)
;;   (set-language-environment "UTF-8")
;;   (set-terminal-coding-system 'utf-8))

;; (use-package ispell
;;   :defer t
;;   :custom
;;   (ispell-local-dictionary-alist
;;    '(("russian"
;;       "[АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
;;       "[^АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
;;       "[-']"  nil ("-d" "ru_RU,en_US") nil utf-8)))
;;   (ispell-program-name "hunspell")
;;   (ispell-dictionary "russian")
;;   (ispell-really-aspell nil)
;;   (ispell-really-hunspell t)
;;   (ispell-encoding8-command t)
;;   (ispell-silently-savep t))

;; (use-package flyspell
;;   :defer t
;;   :custom
;;   (flyspell-delay 1))

;; (use-package flyspell-correct-ivy
;;   :ensure t
;;   :bind (:map flyspell-mode-map
;;               ("C-c $" . flyspell-correct-at-point)))

;; --------------
;; Spell checking requires an external command to be available. Install =aspell= on your Mac, then make it the default checker for Emacs' =ispell=. Note that personal dictionary is located at =~/.aspell.LANG.pws= by default.
(setq ispell-program-name "aspell")

;; Enable spellcheck on the fly for all text modes. This includes org, latex and LaTeX. Spellcheck current word.
(add-hook 'text-mode-hook 'flyspell-mode)
(global-set-key (kbd "C-c f") 'ispell-word)
(global-set-key (kbd "C-c j") 'flyspell-auto-correct-word)


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
  (mode-line ((t (:height 0.98 :background "#92B5D1")))))  ;; "#3681C2" "#79B9FF" "#B4CCD1" "#AEDAEB"


;; (defcustom light-theme 'doom-one-light
;;   "Light theme to use."
;;   :tag "Light theme"
;;   :type 'symbol
;;   :group 'local-config)

;; (use-package doom-themes
;;   :straight (:host github
;;                    :repo "hlissner/emacs-doom-themes")
;;   :custom
;;   (doom-themes-enable-bold t)
;;   (doom-themes-enable-italic t)
;;   :custom-face
;;   (fringe    ((t (:background nil))))
;;   (highlight ((t (:foreground unspecified
;;                               :distant-foreground unspecified
;;                               :background unspecified))))
;;   (org-block ((t (:extend t :background unspecified :inherit hl-line))))
;;   (org-block-begin-line ((t (:slant unspecified
;;                                     :weight normal
;;                                     :background unspecified
;;                                     :inherit org-block
;;                                     :extend t))))
;;   (org-block-end-line   ((t (:background unspecified
;;                                          :inherit org-block-begin-line
;;                                          :extend t))))
;;   (secondary-selection  ((t (:foreground unspecified
;;                                          :background unspecified
;;                                          :inherit region
;;                                          :extend t))))
;;   (org-level-2 ((t (:inherit outline-3))))
;;   (org-level-3 ((t (:inherit outline-4))))
;;   (org-level-4 ((t (:inherit outline-2))))
;;   (org-level-5 ((t (:inherit outline-1))))
;;   (org-level-6 ((t (:inherit outline-3))))
;;   (org-level-7 ((t (:inherit outline-4))))
;;   (org-level-8 ((t (:inherit outline-2))))
;;   (org-drawer ((t (:foreground nil :inherit shadow))))
;;   (font-lock-comment-face ((t (:background unspecified))))
;;   :config
;;   ;; (load-theme dark-theme t)
;;   (load-theme light-theme t)
;;   )


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

(use-package solaire-mode
  ;; :straight (:host github
  ;;                 :repo "hlissner/emacs-solaire-mode")
  :ensure t
  :commands (solaire-global-mode)
  :init
  (solaire-global-mode 1))

;; (straight-use-package '(nano-theme :type git :host github :repo "404cn/nano-theme.el"))


(use-package uniquify
  :straight nil
  :custom (uniquify-buffer-name-style 'forward))


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


(use-package all-the-icons
  :ensure t
  :defer t
  :config
  (setq all-the-icons-mode-icon-alist
        `(,@all-the-icons-mode-icon-alist
          (package-menu-mode all-the-icons-octicon "package" :v-adjust 0.0)
          (jabber-chat-mode all-the-icons-material "chat" :v-adjust 0.0)
          (jabber-roster-mode all-the-icons-material "contacts" :v-adjust 0.0)
          (telega-chat-mode all-the-icons-fileicon "telegram" :v-adjust 0.0
                            :face all-the-icons-blue-alt)
          (telega-root-mode all-the-icons-material "contacts" :v-adjust 0.0))))

(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode . all-the-icons-dired-mode))

(use-package all-the-icons-ivy
  :defer t
  :ensure t
  :after ivy
  :custom
  (all-the-icons-ivy-buffer-commands '() "Don't use for buffers.")
  :config
  (all-the-icons-ivy-setup))


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


;; ==========================================
;;  >>>>>>>>>> non-English layout <<<<<<<<<<

(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))


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

(use-package calendar
  :defer t
  :custom
  (calendar-week-start-day 1))

(use-package org-roam
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "c:/Users/Elena/Dropbox/Emacs/org-roam/")
  (org-roam-db-location "c:/Users/Elena/Dropbox/Emacs/org-roam/db/org-roam.db")
  (org-directory "c:/Users/Elena/Dropbox/Emacs/org/")
  ;; (org-hide-emphasis-markers t)
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
	           ("C-c n r" . org-roam-buffer-toggle-display)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(use-package org-bullets
  :ensure t
  :custom
  (org-bullets-bullet-list '("✸" "◉" "•" "•" "•" "•" "•"))
  ;; org-bullets-bullet-list
  ;; default: "◉ ○ ✸ ✿"
  ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
  ;; Small: ► • ★ ▸
  ;; (org-bullets-bullet-list '("•"))
  ;; others: ▼, ↴, ⬎, ⤵, ⤷,…, ⇳, ⇊, 🠗
  ;; (org-ellipsis "⤵")
  (org-ellipsis " ...")
  :hook
  (org-mode . org-bullets-mode))

(use-package htmlize
  :ensure t
  :defer t
  :custom
  (org-html-htmlize-output-type 'css)
  (org-html-htmlize-font-prefix "org-"))


;; ============================================
;;  >>>>>>>>>>>>>>>> Writingt <<<<<<<<<<<<<<<<

(use-package olivetti
  :ensure t
  :custom
  (olivetti-body-width 120)
  :hook
  (text-mode-hook . olivetti-mode))

;; Thesaurus
(use-package synosaurus
  :defer t
  :ensure t
  :custom
  (synosaurus-choose-method 'default)
  :config
  (synosaurus-mode))

;; Style
(use-package writegood-mode
  :defer t
  :ensure t)

(use-package flycheck-grammarly
  :quelpa
  (flycheck-grammarly :repo "jcs-elpa/flycheck-grammarly"  :fetcher github))


;; ============================================
;;  >>>>>>>>>>>>>>>>> Markup <<<<<<<<<<<<<<<<<

(use-package markdown-mode
  :ensure t
  :ensure-system-package markdown
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :custom
  (markdown-command "markdown"))


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
  :disabled t
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

(use-package company-shell
  :ensure t
  :after company
  :defer t
  :custom-update
  (company-backends '(company-shell)))

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
;; (use-package undo-fu
;;   :ensure t
;;   :bind
;;   ("C-z" . undo-fu-only-undo)
;;   ("C-S-z" . undo-fu-only-redo)
;;   ("C-/" . undo-fu-only-undo)
;;   ("C-M-/" . undo-fu-only-redo))

(use-package undo-tree
  :straight (:host gitlab
                   :repo "tsc25/undo-tree")
  :commands global-undo-tree-mode
  :bind (("C-z" . undo-tree-undo)
         ("C-S-z" . undo-tree-redo)
         ("C-/" . undo-fu-only-undo)
         ("C-M-/" . undo-fu-only-redo))
  :custom
  (undo-tree-visualizer-relative-timestamps nil)
  (undo-tree-visualizer-timestamps nil)
  (undo-tree-auto-save-history nil)
  :init (global-undo-tree-mode 1))


;; ;; Smart parentheses
(use-package smartparens
  :ensure t
  :config (smartparens-global-mode 1))

(use-package paren
  :straight nil
  :custom
  (show-paren-when-point-in-periphery t)
  (show-paren-delay 0))

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
  :when window-system
  :commands (treemacs-follow-mode
             treemacs-filewatch-mode
             treemacs-load-theme)
  ;; :config
  ;; (progn (setq treemacs-width 25))
  :bind
  ("C-c t r" . treemacs)
  :custom-face
  (treemacs-fringe-indicator-face ((t (:inherit font-lock-doc-face))))
  (treemacs-git-ignored-face ((t (:inherit (shadow)))))
  :custom
  (treemacs-width 25)
  (treemacs-is-never-other-window t)
  (treemacs-space-between-root-nodes nil)
  (treemacs-indentation 2))

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
  (("C-c C-;" . 'avy-goto-char)
   ("C-'" . 'avy-goto-char-2)
   :map goto-map
   ("M-g" . avy-goto-line)))


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


;; ==========================================
;;  >>>>>>>>>>>>> tab-line <<<<<<<<<<<<<

(use-package tab-line
  :straight nil
  :when window-system
  :hook ((after-init . global-tab-line-mode)
         ;; (aorst--theme-change . aorst/tabline-setup-faces)
         )
  :config
  (defun tab-line-close-tab (&optional e)
    "Close the selected tab.

If tab is presented in another window, close the tab by using
`bury-buffer` function.  If tab is unique to all existing
windows, kill the buffer with `kill-buffer` function.  Lastly, if
no tabs left in the window, it is deleted with `delete-window`
function."
    (interactive "e")
    (let* ((posnp (event-start e))
           (window (posn-window posnp))
           (buffer (get-pos-property 1 'tab (car (posn-string posnp)))))
      (with-selected-window window
        (let ((tab-list (tab-line-tabs-window-buffers))
              (buffer-list (flatten-list
                            (seq-reduce (lambda (list window)
                                          (select-window window t)
                                          (cons (tab-line-tabs-window-buffers) list))
                                        (window-list) nil))))
          (select-window window)
          (if (> (seq-count (lambda (b) (eq b buffer)) buffer-list) 1)
              (progn
                (if (eq buffer (current-buffer))
                    (bury-buffer)
                  (set-window-prev-buffers window (assq-delete-all buffer (window-prev-buffers)))
                  (set-window-next-buffers window (delq buffer (window-next-buffers))))
                (unless (cdr tab-list)
                  (ignore-errors (delete-window window))))
            (and (kill-buffer buffer)
                 (unless (cdr tab-list)
                   (ignore-errors (delete-window window)))))))))


  (defun tab-line-name-buffer (buffer &rest _buffers)
    "Create name for tab with padding and truncation.

If buffer name is shorter than `tab-line-tab-max-width' it gets
centered with spaces, otherwise it is truncated, to preserve
equal width for all tabs.  This function also tries to fit as
many tabs in window as possible, so if there are no room for tabs
with maximum width, it calculates new width for each tab and
truncates text if needed.  Minimal width can be set with
`tab-line-tab-min-width' variable."
    (with-current-buffer buffer
      (let ((buffer (string-trim (buffer-name)))
            (right-pad (if tab-line-close-button-show "" " ")))
        (propertize (concat " " buffer right-pad)
                    'help-echo (when-let ((name (buffer-file-name)))
                                 (abbreviate-file-name name))))))


  (setq tab-line-close-button-show t
        tab-line-new-button-show nil
        tab-line-separator ""
        tab-line-tab-name-function #'tab-line-name-buffer
        tab-line-right-button (propertize (if (char-displayable-p ?▶) " ▶ " " > ")
                                          'keymap tab-line-right-map
                                          'mouse-face 'tab-line-highlight
                                          'help-echo "Click to scroll right")
        tab-line-left-button (propertize (if (char-displayable-p ?◀) " ◀ " " < ")
                                         'keymap tab-line-left-map
                                         'mouse-face 'tab-line-highlight
                                         'help-echo "Click to scroll left")
        tab-line-close-button (propertize (if (char-displayable-p ?×) " × " " x ")
                                          'keymap tab-line-tab-close-map
                                          'mouse-face 'tab-line-close-highlight
                                          'help-echo "Click to close tab")
        tab-line-exclude-modes '(ediff-mode
                                 process-menu-mode
                                 term-mode
                                 vterm-mode
                                 treemacs-mode
                                 imenu-list-major-mode))


  (defun tabline-setup-faces ()
    (let ((bg (face-attribute 'default :background))
          (fg (face-attribute 'default :foreground))
          (dark-fg (face-attribute 'shadow :foreground))
          (overline (face-attribute 'font-lock-keyword-face :foreground))
          (base (if (and (facep 'solaire-default-face)
                         (not (eq (face-attribute 'solaire-default-face :background)
                                  'unspecified)))
                    (face-attribute 'solaire-default-face :background)
                  (face-attribute 'mode-line :background)))
          (box-width 5))
      (when (facep 'tab-line-tab-special)
        (set-face-attribute 'tab-line-tab-special nil
                            :slant 'normal))
      (set-face-attribute 'tab-line nil
                          :background "#B4CCD1"
                          :foreground dark-fg
                          :height 1.0
                          :inherit nil
                          :overline base
                          :box (when (> box-width 0)
                                 (list :line-width -1 :color "#B4CCD1")))
      (set-face-attribute 'tab-line-tab nil
                          :foreground dark-fg
                          :background bg
                          :inherit nil
                          :box (when (> box-width 0)
                                 (list :line-width box-width :color bg)))
      (set-face-attribute 'tab-line-tab-inactive nil
                          :foreground dark-fg
                          :background "#B4CCD1"
                          :inherit nil
                          :box (when (> box-width 0)
                                 (list :line-width box-width :color "#B4CCD1")))
      (set-face-attribute 'tab-line-tab-current nil
                          :foreground fg
                          :background bg
                          :inherit nil
                          :overline overline
                          :box (when (> box-width 0)
                                 (list :line-width box-width :color bg)))))

  (tabline-setup-faces)

  (define-advice tab-line-select-tab (:after (&optional e) tab-line-select-tab)
    (select-window (posn-window (event-start e)))))


;; (use-package centaur-tabs
;;   :ensure t
;;   :demand
;;   :config
;;   (centaur-tabs-mode t)
;;   (setq centaur-tabs-style "bar"
;;         centaur-tabs-height 25
;;         centaur-tabs-set-icons t
;;         centaur-tabs-set-bar 'over
;;         centaur-tabs-set-modified-marker t)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))
