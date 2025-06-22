(load-theme 'catppuccin :no-confirm)

;; Git frontend
(require 'magit)

;; Vim bindings
(require 'evil)
(require 'evil-collection)

(setq evil-want-integration t)
(setq evil-want-keybinding nil)

(evil-mode 1)
(evil-collection-init)

(with-eval-after-load 'evil
  (evil-ex-define-cmd "W" "w")
  (evil-ex-define-cmd "Wq" "wq") 
  (evil-ex-define-cmd "WQ" "wq")
  (evil-ex-define-cmd "Q" "q")
  (evil-ex-define-cmd "Qa" "qa")
  (evil-ex-define-cmd "QA" "qa")
  (evil-ex-define-cmd "X" "x")
  (evil-ex-define-cmd "E" "e"))

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up))

;; Extra keybindings with leader
(require 'general)

(general-create-definer my-leader-def
  :prefix "SPC")

(my-leader-def
  :keymaps 'normal
  "f" 'dired-jump)

;; Language server
(require 'lsp-ui)
(require 'lsp-mode)

(define-key lsp-mode-map (kbd "K") 'lsp-describe-thing-at-point)  ; Shift-K equivalent
(define-key lsp-mode-map (kbd "g d") 'lsp-find-definition)        ; gd
(define-key lsp-mode-map (kbd "g r") 'lsp-find-references)        ; gr
(define-key lsp-mode-map (kbd "g i") 'lsp-find-implementation)    ; gi
(define-key lsp-mode-map (kbd "g t") 'lsp-find-type-definition)   ; gt
(define-key lsp-mode-map (kbd "g s") 'lsp-document-symbols)       ; gs
(define-key lsp-mode-map (kbd "g S") 'lsp-workspace-symbol)       ; gS
(define-key lsp-mode-map (kbd "g a") 'lsp-execute-code-action)    ; ga
; (define-key lsp-mode-map (kbd "g R") 'lsp-rename)

(require 'rustic)
(require 'nix-mode)
(require 'nixfmt)

;; markdown mode
(require 'evil-markdown)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))
(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(font . "Berkeley Mono Nerd Font-18"))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
