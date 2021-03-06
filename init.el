(setq gc-cons-threshold (* 50 1000 1000))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ispell-dictionary nil)
 '(ivy-mode t)
 '(package-selected-packages
   '(forge evil-magit counsel-projectile magit projectile hydra evil-collection evil general helpful ivy-rich which-key rainbow-delimiters doom-themes neotree all-the-icons doom-modeline ivy command-log-mode use-package cmake-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "22:00"))

(setq inhibit-splash-screen t) ; Remove initial GNU Emacs screen
(setq initial-scratch-message "") ; Makes *scratch* empty
(global-visual-line-mode) ; Wrap long lines
(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1) ; Disable the toolbar
(tooltip-mode -1) ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1) ; Disable the menu bar
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
(kill-buffer "*scratch*") 
(setq visible-bell t) ; Set up the visible bell
(set-face-attribute 'default nil :font "Fira Code Retina" :height 120) ; Font
(column-number-mode)
(flyspell-prog-mode)
(global-display-line-numbers-mode t) ; Display line numbers
(setq org-src-tab-acts-natively t)
(setq user-full-name "Pedro Mendes"
      user-mail-address "phrmendes@tuta.io")
(setq-default delete-by-moving-to-trash t)
(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      scroll-margin 2)

(let ((backup-dir "~/tmp/emacs/backups")
      (auto-saves-dir "~/tmp/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . , backup-dir))
        auto-save-file-name-transforms `((".*" , auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . , backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks                           
      delete-old-versions t  ; Clean up the backups                             
      version-control t      ; Use version numbers on backups,                  
      kept-new-versions 5    ; keep some new versions                           
      kept-old-versions 2)   ; and some old ones, too 

(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

(use-package no-littering)
;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(defun phrmendes/org-mode-setup ()  :@home:
       (org-indent-mode))

(use-package org
  :hook (org-mode . phrmendes/org-mode-setup)
  :commands (org-capture org-agenda)
  :config
  (setq org-ellipsis " ???")
  (setq org-log-done 'time)
  (setq org-directory "~/Sync/org")
  (setq org-agenda-files '("~/Sync/org/tasks.org"
                           "~/Sync/org/agenda.org"))
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJ(p)" "NEXT(n)" "|" "DONE(d)")))

(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))))))

(setq org-tag-alist
  '((:startgroup)
     ; Put mutually exclusive tags here
     (:endgroup)
     ("@ufabc" . ?u)
     ("@pessoal" . ?P)
     ("teoriaJogos" . ?t)
     ("econometria3" . ?e)
     ("rcii" . ?r)
     ("pch" . ?p)
     ("consultas" . ?c)))

(advice-add 'save-buffer :after #'org-save-all-org-buffers) ; Auto-save buffers

(use-package magit
  :commands (magit magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/")
    (setq projectile-project-search-path '("~/Projects/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package forge
  :after magit)

(use-package all-the-icons)

(use-package treemacs)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dashboard
  :init
  (progn
    (setq dashboard-items '((recents . 3)
                            (agenda . 3)
                            (projects . 3)
                            (bookmarks . 3)))
    (setq dashboard-center-content t)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-week-agenda t)
    (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda))
  :config
  (dashboard-setup-startup-hook))

(let ((langs '("pt_BR" "en_US")))
  (setq lang-ring (make-ring (length langs)))
  (dolist (elem langs) (ring-insert lang-ring elem)))
(let ((dics '("brazilian" "american-english")))
  (setq dic-ring (make-ring (length dics)))
  (dolist (elem dics) (ring-insert dic-ring elem)))

(defun cycle-ispell-languages ()
  (interactive)
  (let (
        (lang (ring-ref lang-ring -1))
        (dic (ring-ref dic-ring -1))
        )
    (ring-insert lang-ring lang)
    (ring-insert dic-ring dic)
    (ispell-change-dictionary lang)
    (setq ispell-complete-word-dict (concat "/usr/share/dict/" dic))))

(defun phrmendes/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . phrmendes/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package dap-mode
  :commands (dap-debug))

(use-package python-mode
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 0))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp-mode)

(use-package lsp-ivy
  :after lsp-mode)

(completion-at-point)

(use-package evil-nerd-commenter
  :bind ("C-S-c" . evilnc-comment-or-uncomment-lines))

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection))
  ;; (:map lsp-mode-map
  ;;       ("<tab>" . company-indent-or-complete-common))
  :config
  (setq company-idle-delay 0
        company-minimum-prefix-length 2
        company-show-numbers 5))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *") 
  (setq vterm-shell "zsh")
  (setq vterm-max-scrollback 10000))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package drag-stuff)

(drag-stuff-global-mode 1)
(drag-stuff-define-keys)

(use-package general
  :after evil
  :config
  (general-create-definer phrmendes/leader-keys
    :keymaps '(normal insert visual emacs dired)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package hydra
  :defer t)

(general-define-key
 "<escape>" 'keyboard-escape-quit
 "C-s" 'swiper-isearch
 "M-y" 'counsel-yank-pop
 "<f1> f" 'counsel-describe-function
 "<f1> v" 'counsel-describe-variable
 "<f1> l" 'counsel-find-library
 "<f2> i" 'counsel-info-lookup-symbol
 "<f2> u" 'counsel-unicode-char
 "<f2> j" 'counsel-set-variable
 "C-x b" 'ivy-switch-buffer
 "C-c v" 'ivy-push-view
 "C-c V" 'ivy-pop-view
 "<f5>" 'cycle-ispell-languages
 "<f6>" 'org-babel-tangle)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(phrmendes/leader-keys
  "b" '(ivy-switch-buffer :which-key "switch buffer")
  "i" '(ibuffer :which-key "ibuffer-list-buffers")
  "f" '(counsel-find-file :which-key "find file")
  "c" '(org-insert-structure-template :which-key "templates")
  "k" '(kill-buffer :which-key "kill buffer")
  "g" '(magit :which-key "magit")
  "v" '(vterm :which-key "vterm")
  "d" '(dired :which-key "directory editor")
  "tf" '(treemacs :which-key "treemacs")
  "ts" '(lsp-treemacs-symbols :which-key "treemacs symbols")
  "sa" '(flyspell-mode :which-key "flyspell mode")
  "sc" '(flyspell-correct-word :which-key "flyspell correct word")
  "sb" '(flyspell-buffer :which-key "flyspell correct buffer")
  "sw" '(flyspell-word :which-key "flyspell correct word")
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "oa" '(org-agenda :which-key "org-agenda")
  "os" '(org-schedule :which-key "org-schedule")
  "od" '(org-deadline :which-key "org-deadline")
  "oc" '(org-time-stamp :which-key "org-time-stamp")
  "of" '(org-archive-subtree :which-key "org-archive")
  "ot" '(counsel-org-tag :which-key "org-tags")
  "oe" '(org-edit-src-code :which-key "org-edit-src-code")
  "ox" '(org-babel-execute-src-block :which-key "org-babel-exec-chunk")
  "ls" '(lsp :which-key "start lsp")  
  "lf" '(lsp-find-definition :which-key "lsp find definition")
  "lr" '(lsp-find-references :which-key "lsp find references")
  "le" '(lsp-rename :which-key "lsp rename")
  "ld" '(flymake-show-diagnostics-buffer :which-key "diagnostic")
  "lt" '(lsp-format-buffer :which-key "lsp format buffer")
  "li" '(lsp-ivy-workspace-symbol :which-key "ivy symbol search"))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(setq gc-cons-threshold (* 2 1000 1000))
