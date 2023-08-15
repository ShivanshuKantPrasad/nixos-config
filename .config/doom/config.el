;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Shivanshu Kant Prasad"
      user-mail-address "shivanshukantprasad@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "VictorMono Nerd Font Mono" :size 16))
(setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 16))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(after! lsp-mode
  (setq lsp-lens-enable t
        lsp-semantic-tokens-enable t
        lsp-enable-symbol-highlighting t))

(after! lsp-ui
  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  (setq lsp-rust-analyzer-inlay-hints-mode t)
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  (setq lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (setq lsp-rust-analyzer-display-chaining-hints t)
  (setq lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (setq lsp-rust-analyzer-display-closure-return-type-hints t)
  (setq lsp-rust-analyzer-display-parameter-hints nil)
  (setq lsp-rust-analyzer-display-reborrow-hints nil)


  (setq lsp-semantic-tokens-enable t))
;; (setq lsp-eldoc-render-all t)

;; (setq lsp-ui-sideline-show-hover t)
;; (setq lsp-ui-sideline-show-code-actions t)
;; (setq lsp-ui-sideline-enable nil)
;; (setq lsp-ui-doc-show-with-mouse t)
;; (setq lsp-ui-doc-enable t))

(require 'sublimity)
(require 'sublimity-scroll)
(sublimity-mode 1)
(setq sublimity-scroll-weight 5
      sublimity-scroll-drift-length 10
      sublimity-scroll-vertical-frame-delay 0.01)

(with-eval-after-load 'doom-themes
  (doom-themes-treemacs-config))
(setq doom-themes-treemacs-theme "doom-colors")

(company-quickhelp-mode)

(map!
 (:map 'override
  :v "v" #'er/expand-region
  :v "V" #'er/contract-region))

(setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet))
(set-frame-parameter nil 'alpha-background 50)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


(use-package! kbd-mode)

(use-package jupyter
  :defer t
  :ensure t
  :config
  (require 'jupyter-python))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (jupyter . t)))

(setq org-babel-default-header-args:jupyter-python '((:session . "py")
                                                    (:kernel . "python3")
                                                    (:async . "yes")
                                                    (:exports . "both")
                                                    (:results . "output")))

(setq org-element-use-cache t)
(setq org-roam-directory "~/Study")
(setq x-select-enable-clipboard nil)
