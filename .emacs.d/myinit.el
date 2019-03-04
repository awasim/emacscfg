
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
;; (setq load-path (cons "~/.emacs.d" load-path))
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20150408.1132")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-clang-20140409.52")
(add-to-list 'load-path "~/.emacs.d/elpa/autopair-20140825.427")
(add-to-list 'load-path "~/.emacs.d/elpa/popup-20150315.612")
(add-to-list 'load-path "~/.emacs.d/php-mode-1.13.1")
(add-to-list 'load-path "~/.emacs.d/python-mode.el-6.2.0")

; Misc Settings
(tool-bar-mode -1)
(setq scroll-step 1)
(setq default-tab-width 4)
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(size-indication-mode 1)
(scroll-bar-mode -1)
(global-linum-mode 1) 
(setq make-backup-files nil)
(fset 'yes-or-no-p 'y-or-n-p)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(use-package try
:ensure t)

(use-package which-key
:ensure t
:config (which-key-mode))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'font-lock)
(setq-default font-lock-maximum-decoration t)

(add-to-list 'default-frame-alist '(height . 45))
(add-to-list 'default-frame-alist '(width . 115))

(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
                          scroll-down-aggressively 0.01)

(global-set-key [f7] 'previous-buffer)
(global-set-key [f8] 'next-buffer)
(global-set-key [f6] 'other-window)
(global-set-key [f5] 'frame-setup)
(global-set-key (kbd "C-q") 'global-visual-line-mode)
(global-set-key (kbd "C-c d") 'insert-date)
(global-set-key (kbd "C-c y") 'new-day)
(global-set-key [f4] 'eval-buffer)

(require 'color-theme)
;; (color-theme-initialize)
;; (color-theme-calm-forest)
(load-theme 'solarized-dark)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

;; Use js-mode indentation in js2-mode, I don't like js2-mode's indentation
;;
;; thanks http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
;; with my own modifications
;;
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)
 
      (save-excursion
 
        (back-to-indentation)
        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation ( 4 indentation))))
 
      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))
 
(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))
 
(defun my-js2-mode-hook ()
  (require 'js)
  (setq js-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 2)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)] 
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))
 
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; Org buffers only
(font-lock-add-keywords 'org-mode
                        '(("^ +\\([-*]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) ""))))))
(add-hook 'org-mode-hook (lambda () (linum-mode 0)))
(use-package org-bullets
:ensure t
:config
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(defun transparent(alpha-level no-focus-alpha-level)
  "Let's you make the window transparent"
  (interactive "nAlpha level (0-100): \nnNo focus alpha level (0-100): ")
  (set-frame-parameter (selected-frame) 'alpha (list alpha-level no-focus-alpha-level))
  (add-to-list 'default-frame-alist `(alpha ,alpha-level)))
(transparent 85 70)
(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
        (set-face-background 'default "unspecified-bg" frame)))

(add-hook 'after-make-frame-functions 'on-frame-open)

; Insert Date
(defun insert-date()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "** %a, %e %b %Y, %k:%M" (current-time))))

;;;enable narrowing- C-x n n to enable -  C-x n w to end.
(put 'narrow-to-region 'disabled nil)

(defun new-day ()
  "Insert new date and underline"
  (interactive)
  (insert-date)
  (insert "\n--------------------------\n\n"))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(if (eq system-type 'darwin)
        ;Something for OS X goes here
        (progn
          (set-default-font "-*-Monaco-*-*-*-*-16-*-*-*-*-*-iso8859-1")
          (setq mac-option-key-is-meta nil)
          (setq mac-command-key-is-meta t)
          (setq mac-command-modifier 'meta)
          (setq mac-option-modifier nil)
          (setq server-socket-dir (format "/tmp/emacs%d" (user-uid)))
          (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
          (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
          (global-set-key (kbd "S-C-<down>") 'shrink-window)
          (global-set-key (kbd "S-C-<up>") 'enlarge-window)
          )
  )

(if (eq system-type 'windows-nt) 
        ; Windows stuff goes here
        (progn
          (set-default-font "-*-Consolas-*-*-*-*-16-*-*-*-*-*-iso8859-1")
           (global-set-key [f12] 'explorer)  
           (global-set-key [f11] 'fullscreen)
           (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
           (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
           (global-set-key (kbd "S-C-<down>") 'shrink-window)
           (global-set-key (kbd "S-C-<up>") 'enlarge-window)
                                                                                ; Visual Basic
           (autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
           (setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vbs\\)$" . 
                                                                                visual-basic-mode)) auto-mode-alist))
           )
)

(if (eq system-type 'gnu/linux)
         (progn
           (set-default-font "-*-Monospace-*-*-*-*-12-*-*-*-*-*-iso8859-1")
           (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
           (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
           (global-set-key (kbd "S-C-<down>") 'shrink-window)
           (global-set-key (kbd "S-C-<up>") 'enlarge-window))
          )


(if (eq window-system 'nil)
        (progn
         (global-set-key [f12] 'shrink-window-horizontally)
         (global-set-key [f11] 'enlarge-window-horizontally)
         (global-set-key [f10] 'shrink-window)
         (global-set-key [f9] 'enlarge-window)
         (setq linum-format "%d ")
;;       (defun on-after-init ()
;;         (unless (display-graphic-p (selected-frame))
;;               (set-face-background 'default "unspecified-bg" (selected-frame))))
;;
;;       (add-hook 'window-setup-hook 'on-after-init)

         (defun on-frame-open (&optional frame)
           "If the FRAME created in terminal don't load background color."
           (unless (display-graphic-p frame)
                 (set-face-background 'default "unspecified-bg" frame)))
         
         (add-hook 'after-make-frame-functions 'on-frame-open)
         )
  )

; Server
(server-start)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
    )

;; Enable colors for normal shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun utf8-shell()
  "Create Shell that supports UTF-8."
  (interactive)
  (set-default-coding-systems 'utf-8)
  (shell))

;; elpy
(package-initialize)
(elpy-enable)

; HTML
;; (autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
;; (setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.asp$" . html-helper-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.phtml$" . html-helper-mode) auto-mode-alist))

; JavaScript
;(autoload 'js2-mode "js2" nil t)
;(add-to-list 'auto-mode-alist '("\\.js$" js2-mode))

 
 
; Python 
;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; (add-hook 'python-mode-hook
;;       (lambda ()
;;         (set (make-variable-buffer-local 'beginning-of-defun-function)
;;          'py-beginning-of-def-or-class)
;;         (setq outline-regexp "def\\|class ")))

;; (setq py-install-directory "~/emacscfg/.emacs.d/python-mode.el-6.2.0")
;; (require 'python-mode)

; PHP
;; (require 'php-mode)

; Ruby
;; (autoload 'ruby-mode "ruby-mode" "Ruby editing mode." t)
;; (setq auto-mode-alist  (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
;; (setq auto-mode-alist  (cons '("\\.rhtml$" . html-mode) auto-mode-alist))

; Explorer
;; (defun explorer ()  
;;  "Launch the windows explorer in the current directory and selects current file"  
;;  (interactive)  
;;  (w32-shell-execute  
;;   "open"  
;;   "explorer"  
;;   (concat "/e,/select," (convert-standard-filename buffer-file-name))))  

; Full Screen Emacs
;; (defun fullscreen ()
;;   (interactive)
;;  (set-frame-parameter nil 'fullscreen
;;                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

(defun htop ()
  (interactive)
  (if (get-buffer "*htop*")
      (switch-to-buffer "*htop*")
    (ansi-term "/bin/bash" "htop")   
    (comint-send-string "*htop*" "htop\n")))
