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

(after! sublimity
  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (sublimity-mode -1))))

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

(load! "org-typst-preview.el")
(use-package! org-typst-preview)

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

(add-to-list 'load-path "/home/shivanshu/.opam/default/share/emacs/site-lisp")
(require 'ocp-indent)








;; Try to change how horizontal rules are rendered in org mode
 ;;; Org visual horizontal rule - overlays replacing ----- with a thicker colored rule
;; Usage: evaluate the file or add to your init.el. Works per-org-buffer.

(defface org-horizontal-rule-face
  '((t :foreground "DodgerBlue" :weight bold))
  "Face used for the visual horizontal rule overlay."
  :group 'org-faces)

(defvar-local org--hr-overlays nil
  "List of overlays used to display visual horizontal rules in this buffer.")

(defun org--hr-make-bar-string (&optional wind)
  "Return a horizontal-bar STRING sized to WIND's width (or current window).
Uses a heavy bar character and repeats it to fill the line visually."
  (let* ((w (or (and wind (window-width wind)) (window-width)))
         ;; Choose a thicker glyph. You can replace with \"─\" (U+2500), \"━\" (U+2501),
         ;; or \"―\" (U+2015) depending on font/glyph you prefer.
         (ch "━") ;; boxed heavy horizontal
         ;; create string a bit longer so overlay appears to span end-to-end
         (repeat-count (max 1 (- w 14))))
    (apply #'string (make-list repeat-count (string-to-char ch)))))

(defun org--hr-clear-overlays ()
  "Remove all overlays created by org visual hr in current buffer."
  (when org--hr-overlays
    (mapc #'delete-overlay org--hr-overlays)
    (setq org--hr-overlays nil)))

(defun org--hr-scan-and-make-overlays (&optional _beg _end _len)
  "Scan buffer for lines of 5+ dashes and create overlays that display a thick rule.
This is buffer-local and idempotent (clears previous overlays first).
Optional args _BEG _END _LEN are ignored but accepted for `after-change-functions`."
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (let ((inhibit-modification-hooks t)
            (win (selected-window)))
        (org--hr-clear-overlays)
        (goto-char (point-min))
        (while (re-search-forward "^-\\{5,\\}[ \t]*$" nil t)
          (let* ((b (match-beginning 0))
                 (e (match-end 0))
                 (ov (make-overlay b e (current-buffer) nil t))
                 (bar (org--hr-make-bar-string win)))
            ;; overlay display replaces the line visually
            (overlay-put ov 'display bar)
            ;; optionally keep the original text accessible to yank/copy by not modifying buffer text
            (overlay-put ov 'evaporate t)
            (overlay-put ov 'face 'org-horizontal-rule-face)
            (overlay-put ov 'category 'org-hr-overlay)
            ;; record it
            (push ov org--hr-overlays)))))))

(defun org--hr-refresh-all ()
  "Refresh overlays in all visible org-mode buffers.
Useful when window size changes so overlays can resize."
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (derived-mode-p 'org-mode)
        (org--hr-scan-and-make-overlays)))))

;; Hooks to keep overlays up-to-date
(defun org--hr-enable ()
  "Enable visual horizontal rules in this org buffer."
  (org--hr-scan-and-make-overlays)
  ;; update when text changes
  (add-hook 'after-change-functions #'org--hr-scan-and-make-overlays nil t)
  ;; update when window config/size changes so overlay width matches
  (add-hook 'window-size-change-functions (lambda (_) (org--hr-refresh-all)) nil t)
  (add-hook 'window-configuration-change-hook #'org--hr-refresh-all nil t))

(defun org--hr-disable ()
  "Disable visual horizontal rules in this org buffer."
  (org--hr-clear-overlays)
  (remove-hook 'after-change-functions #'org--hr-scan-and-make-overlays t)
  (remove-hook 'window-size-change-functions (lambda (_) (org--hr-refresh-all)) t)
  (remove-hook 'window-configuration-change-hook #'org--hr-refresh-all t))

;;;###autoload
(define-minor-mode org-visual-hr-mode
  "Minor mode: visually replace org-mode '-----' rules with a thicker colored line."
  :lighter " oHR"
  :group 'org
  (if org-visual-hr-mode
      (org--hr-enable)
    (org--hr-disable)))

;; Optional: enable automatically in org-mode buffers
;; (add-hook 'org-mode-hook #'org-visual-hr-mode)

(provide 'org-visual-hr)
