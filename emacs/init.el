(require 'magit)

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

(load-theme 'catppuccin :no-confirm)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(font . "Berkeley Mono Nerd Font-18"))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
