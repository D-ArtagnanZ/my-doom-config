;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
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
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
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

(setq doom-font (font-spec :family "JetBrainsMono NFM" :size 16 :weight 'regular)
      doom-big-font (font-spec :family "JetBrainsMono NFM" :size 24)
      doom-variable-pitch-font (font-spec :family "Segoe UI" :size 16)
      doom-symbol-font (font-spec :family "Segoe UI Symbol" :size 16))

(map! :g "M-0" #'treemacs-select-window)

(add-to-list 'auto-mode-alist '("\\.cppm\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ixx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cxxm\\'" . c++-mode))

(use-package! vertico-posframe
  :after vertico
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center
        vertico-posframe-border-width 2
        vertico-posframe-width 110
        vertico-posframe-min-height 15
        vertico-posframe-parameters '((left-fringe . 12)
                                      (right-fringe . 12)
                                      (internal-border-width . 10)))
  (custom-set-faces!
    '(vertico-posframe-border :background "#51afef")
    '(vertico-posframe :background "#24272e")))

(custom-set-faces!
  '(vertico-posframe-border :background "#51afef")
  '(vertico-posframe :background "#24272e"))

(use-package! which-key-posframe
  :after which-key
  :config
  (which-key-posframe-mode 1)
  (setq which-key-posframe-poshandler #'posframe-poshandler-frame-center
        which-key-posframe-border-width 2
        which-key-posframe-parameters
        '((left-fringe . 12)
          (right-fringe . 12)
          (internal-border-width . 10))))

(custom-set-faces!
  '(which-key-posframe-border :background "#51afef"))

(use-package! nerd-icons-corfu
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(setq select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t)

;; Set frame background transparency (0-100)
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

;;; GPTel configuration with Org-mode default and Magit commit generator

;; Core GPTel setup
(use-package! gptel
  :bind (("C-<f12>"   . gptel)
         ("C-M-<f12>" . gptel-menu)
         ("C-c a f"   . gptel-add-file)
         ("C-c a a"   . gptel-add))
  :hook (gptel-mode . gptel-highlight-mode)
  :config
  (setq gptel-default-mode 'markdown-mode
        gptel-model 'glm-5.2
        gptel-max-tokens 65536
        gptel-include-reasoning 'ignore
        gptel-backend (gptel-make-openai "CXMT"
                        :protocol "http"
                        :host "agi-gateway.cxmt.com"
                        :endpoint "/token/v1/chat/completions"
                        :stream t
                        :key 'gptel-api-key
                        :models '(glm-5.2
                                  deepseek-v4-pro-fp4
                                  kimi-k2.6-cloud
                                  deepseek-v4-flash))))

;; Prompts management
(use-package! gptel-prompts
  :load-path "~/.emacs.d/site-lisp/gptel-prompts"
  :after gptel
  :config
  (gptel-prompts-update)
  (gptel-prompts-add-update-watchers)
  (when-let ((prompt (cdr (assoc 'cpp-code-rule gptel-directives))))
    (setq gptel-system-prompt prompt)))

;; Streamlined Magit commit message generator
(defun my/gptel-magit-commit-message ()
  "Generate a conventional commit message from staged changes."
  (interactive)
  (require 'gptel)
  (let ((diff (magit-git-output "diff" "--staged"))
        (buf (current-buffer)))
    (when (string-empty-p diff)
      (setq diff (magit-git-output "diff" "HEAD~1")))
    (if (string-empty-p diff)
        (user-error "No changes to generate commit message")
      (message "GPTel: Generating commit message...")
      (gptel-request
       (format "Write a concise Conventional Commit message for the diff below. Output ONLY the message:\n\n%s" diff)
       :system "You are an expert developer. Generate concise conventional commit messages."
       :callback
       (lambda (resp _info)
         (when-let* ((text (if (consp resp) (cdr resp) resp))
                     (clean (string-trim (replace-regexp-in-string "^```\\(?:git\\Vert{}commit\\)?\n?\\|```$" "" text))))
           (with-current-buffer buf
             (save-excursion
               (goto-char (point-min))
               (insert clean "\n\n"))
             (message "GPTel: Commit message generated!"))))))))

(after! git-commit
  ;; Disable redundant flycheck in git commit message buffers
  (add-hook 'git-commit-mode-hook (lambda () (flycheck-mode -1)))
  (map! :map git-commit-mode-map
        :localleader
        "g" #'my/gptel-magit-commit-message))

(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq package-check-signature nil)

(after! tramp
  (setq tramp-default-method "scpx")
  (setq remote-file-name-inhibit-cache nil
	tramp-completion-reread-directory-timeout 120)
  (setq tramp-verbose 1)
  (setq tramp-use-ssh-controlmaster-options nil
	tramp-chunksize 2028)
  (setq vc-ignore-dir-regexp
	(format "%s\\|%s"
		vc-ignore-dir-regexp
		tramp-file-name-regexp))
  (setq backup-directory-alist `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms `((".*" , temporary-file-directory t))))

(setq straight-check-for-modifications nil
      straight-vc-git-auto-fast-forward nil
      straight-offline-p t)

(after! emojify
  (setq emojify-display-style 'unicode)
  (setq emojify-download-emojis-p nil)
  (set-fontset-font t 'emoji (font-spec :family "Segoe UI Emoji") nil 'prepend))

(require 'advice)

(after! persp-mode
  (setq persp-auto-save-opt 1
        persp-auto-save-persp-file (expand-file-name "persp-auto-save" doom-cache-dir)))

;; Frame geometry persistence with support for Windows coordinate list specs
(defvar my/frame-geometry-file (expand-file-name "frame-geometry" doom-cache-dir))

(defun my/sanitize-frame-pos (pos)
  "Convert frame coordinate specifications like (+ -8) or numbers into safe integers."
  (let ((val (cond
              ((numberp pos) pos)
              ((and (consp pos) (numberp (cadr pos))) (cadr pos))
              (t 0))))
    (max 0 val)))

(defun my/save-frame-geometry ()
  "Save frame dimensions, sanitized coordinates, and fullscreen status on exit."
  (with-temp-file my/frame-geometry-file
    (prin1 (list (frame-parameter nil 'width)
                 (frame-parameter nil 'height)
                 (my/sanitize-frame-pos (frame-parameter nil 'top))
                 (my/sanitize-frame-pos (frame-parameter nil 'left))
                 (frame-parameter nil 'fullscreen))
           (current-buffer))))

(defun my/restore-frame-geometry ()
  "Restore frame geometry on startup."
  (when (file-readable-p my/frame-geometry-file)
    (with-temp-buffer
      (insert-file-contents my/frame-geometry-file)
      (pcase (ignore-errors (read (current-buffer)))
        (`(,w ,h ,top ,left ,fs)
         (when (and (numberp w) (numberp h))
           (set-frame-size (selected-frame) w h))
         (when (and (numberp top) (numberp left))
           (set-frame-position (selected-frame) left top))
         (when fs
           (set-frame-parameter (selected-frame) 'fullscreen fs)))))))

(add-hook 'kill-emacs-hook #'my/save-frame-geometry)
(add-hook 'doom-init-ui-hook #'my/restore-frame-geometry)

;; Windows I/O performance and process spawning optimizations
(when (eq system-type 'windows-nt)
  (setq w32-pipe-read-delay 0
        w32-pipe-buffer-size (* 64 1024)
        vc-handled-backends '(Git)
        auto-revert-check-vc-info nil
        vc-follow-symlinks nil))

(after! ispell
  (setenv "DICTIONARY" "en_US")
  (setenv "DICPATH" "MSYS2_HOME/ucrt64/share/hunspell")
  (setq ispell-program-name "hunspell"
        ispell-default-dictionary "en_US"
        ispell-current-dictionary "en_US"
        ispell-dictionary-alist
        '((nil       "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)
          ("default" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)
          ("en_US"   "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

(global-visual-line-mode 1)
(add-hook! '(prog-mode-hook text-mode-hook)
           #'adaptive-wrap-prefix-mode)

(map! :desc "Goto char index (origin)" "M-g C"   #'goto-char
      :desc "Avy goto char"            "M-g c"   #'avy-goto-char
      :desc "Avy goto 2 chars"         "M-g 2"   #'avy-goto-char-2
      :desc "Avy goto char timer"      "M-g s"   #'avy-goto-char-timer
      :desc "Avy goto char timer"      "M-g SPC" #'avy-goto-char-timer
      :desc "Avy goto word"            "M-g w"   #'avy-goto-word-1
      :desc "Avy goto line"            "M-g l"   #'avy-goto-line)

(after! gptel
  (map! "M-g a" #'gptel-add
        "M-g f" #'gptel-add-file))

(after! gptel-magit
  (setq gptel-magit-commit-message-instructions
        "You are an expert Git commit message generator.
Based on the provided git diff, generate a concise and precise commit message following the Conventional Commits specification.

Strict rules:
1. Format: `<type>(<scope>): <short description>`
2. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
3. Keep the first line under 72 characters.
4. Output ONLY the raw commit message.
5. DO NOT include any reasoning, thought process, explanations, markdown fences (```), or introductory phrases.
6. The very first character of your response MUST be the start of the commit message."))

(after! ace-window
  (setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?0))
  (custom-set-faces!
    '(aw-leading-char-face
      :height 2.5
      :weight bold
      :foreground "#ff5555"))
  (setq aw-background t))

(after! apheleia
  (setq apheleia-remote-algorithm 'remote))

(after! tramp
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(setq major-mode-remap-alist
      '((c-mode        . c-ts-mode)
        (c++-mode      . c++-ts-mode)
        (c-or-c++-mode . c-or-c++-ts-mode)))

(dolist (pattern '("\\.\\(cpp\\|cxx\\|cc\\|c\\+\\+\\)\\'"
                   "\\.\\(hpp\\|hxx\\|hh\\|h\\+\\+\\|tpp\\|txx\\|ipp\\|inl\\)\\'"
                   "\\.\\(cppm\\|ixx\\|cxxm\\|ccm\\|c\\+\\+m\\|mxx\\|mpp\\)\\'"))
  (add-to-list 'auto-mode-alist (cons pattern 'c++-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.c\\'" . c-ts-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-or-c++-ts-mode))

(defun my/c-mode-setup ()
  (apheleia-mode -1)
  (set-buffer-file-coding-system 'utf-8-unix)
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

(add-hook! '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook)
           #'my/c-mode-setup)

(after! eglot
  (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider))

(setq-default c-ts-mode-indent-style 'bsd)
(setq-default c-ts-mode-indent-offset 2)

(after! corfu
  (setq corfu-preselect 'first)
  (map! :map corfu-map
        "C-n" nil
        "C-p" nil
        "RET" nil
        "<return>" nil
        "M-n" #'corfu-next
        "M-p" #'corfu-previous
        "TAB" #'corfu-insert
        "<tab>" #'corfu-insert))
