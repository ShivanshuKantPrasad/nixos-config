;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))

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
;; (setq doom-font (font-spec :family "VictorMono Nerd Font Mono" :size 16))
;; (setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 16))
(setq doom-font (font-spec :family "Comic Code Ligatures" :size 16))
;; (setq doom-font (font-spec :family "Comic Mono" :size 16))
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
(setq org-directory "~/Notes/")
(setq org-agenda-files '("~/Notes/"))
(setq org-roam-directory "~/Notes/")
(setq org-roam-dailies-directory "~/Notes/journal/")

;; (use-package! org-super-agenda
;;   :after org-agenda
;;   :init
;;   (setq org-agenda-skip-scheduled-if-done t
;;       org-habit-show-habits-only-for-today nil
;;       org-habit-show-all-today t
;;       org-agenda-skip-deadline-if-done t
;;       org-agenda-include-deadlines t
;;       org-agenda-block-separator nil
;;       org-agenda-compact-blocks t
;;       org-agenda-start-day nil ;; i.e. today
;;       org-agenda-span 1
;;       org-agenda-start-on-weekday nil)
;;   (setq org-agenda-custom-commands
;;         '(("c" "Super view"
;;            ((agenda "" ((org-agenda-overriding-header "")
;;                         (org-super-agenda-groups
;;                               '((:name "College"
;;                                         :and (:time-grid t
;;                                               :date today
;;                                               :tag "College"))))))))))
;;   :config
;;   (org-super-agenda-mode))

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
  (setq lsp-inlay-hint-enable t))

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

;; (map! :after image-roll
;;       :map pdf-view-roll-minor-mode-map
;;       "j" #'pdf-view-next-line-or-next-page)

;; (setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet))
(set-frame-parameter nil 'alpha-background 50)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


(use-package! kbd-mode)

(setq org-element-use-cache nil)

(use-package! all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package! ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

(use-package! rustic
  :custom
  (rustic-lsp-client 'eglot)
  (rustic-analyzer-command '("/etc/profiles/per-user/shivanshu/bin/rust-analyzer"))
  (rustic-enable-detached-file-support t)) ;; enable this until we figure out how to get rust-analyzer to autodetect the workspace

(cmake-ide-setup)

(load! "dired+.el")
(use-package! dired+)
                                        ;(diredp-toggle-find-file-reuse-dir)
                                        ;
(setq +latex-viewers '(pdf-tools))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      (lambda ()
                        (TeX-command-run-all nil)) ; <- call with arg
                      nil t)))
