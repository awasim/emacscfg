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

; list the packages you want
(setq package-list '(elpy octicons powerline dracula-theme night-owl-theme rust-mode js2-mode rainbow-delimiters))

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(use-package which-key
:ensure t
:config (which-key-mode))

(use-package rainbow-delimiters
:ensure t
:config 
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'font-lock)
(setq-default font-lock-maximum-decoration t)

(add-to-list 'default-frame-alist '(height . 45))
(add-to-list 'default-frame-alist '(width . 115))
(defun size-1 ()
(interactive)
(set-frame-size (selected-frame) 115 50)
(set-frame-position (selected-frame) 20 20))

(defun size-2 ()
(interactive)
(set-frame-size (selected-frame) 185 50)
(set-frame-position (selected-frame) 20 20))

(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
			  scroll-down-aggressively 0.01)

(global-set-key [f7] 'previous-buffer)
(global-set-key [f8] 'next-buffer)
(global-set-key [f6] 'other-window)
(global-set-key [f5] 'size-1)
(global-set-key [f9] 'size-2)
(global-set-key (kbd "C-q") 'global-visual-line-mode)
(global-set-key (kbd "C-c d") 'insert-date)
(global-set-key (kbd "C-c e") 'insert-time)
(global-set-key (kbd "C-c y") 'new-day)
(global-set-key [f4] 'eval-buffer)
(global-set-key [C-f1] 'show-file-name) ; Or any other key you want
(global-set-key [C-f2] 'open-daily-log)
(global-set-key [C-f3] 'open-work-log)
(global-set-key [C-f4] 'open-config)

(defun set-light-theme ()
    "Set the light theme with some customization if needed."
    (interactive)
    (load-theme 'dracula t))

  (defun set-dark-theme ()
    "Set the dark theme with some customization if needed."
    (interactive)
    (load-theme 'night-owl t))

  (defun theme-switcher ()
    (let ((current-hour (string-to-number (format-time-string "%H"))))
      (if (or (< current-hour 9) (> current-hour 18)) (set-dark-theme) (set-light-theme))))

  ;; (let ((current-hour (string-to-number (format-time-string "%H"))))
  ;;  (if (or (< current-hour 6) (> current-hour 20)) (set-light-theme) (set-dark-theme)))

  ;; Run at every 3600 seconds, after 0s delay
  ;;(run-with-timer 0 3600 'theme-switcher)
  ;;(load-theme 'afternoon t)
(load-theme 'toxi t)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; Org buffers only
(font-lock-add-keywords 'org-mode
                        '(("^ +\\([-*]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "ï¿½"))))))
(add-hook 'org-mode-hook (lambda () (linum-mode 0)))
(use-package org-bullets
:ensure t
:config
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(setq gc-cons-threshold (* 511 1024 1024))
(setq gc-cons-percentage 0.5)
(run-with-idle-timer 5 t #'garbage-collect)
(setq garbage-collection-messages t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(defun transparent(alpha-level no-focus-alpha-level)
  "Let's you make the window transparent"
  (interactive "nAlpha level (0-100): \nnNo focus alpha level (0-100): ")
  (set-frame-parameter (selected-frame) 'alpha (list alpha-level no-focus-alpha-level))
  (add-to-list 'default-frame-alist `(alpha ,alpha-level)))
(transparent 90 85)
(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
	(set-face-background 'default "unspecified-bg" frame)))

(add-hook 'after-make-frame-functions 'on-frame-open)

; Insert Date
(defun idate()
  "Insert a time stamp without org bullet point"
  (interactive)
  (insert (format-time-string "%a, %e %b %Y, %k:%M" (current-time))))

(defun insert-date()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "** %a, %e %b %Y, %k:%M" (current-time))))

(defun insert-time()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "*** %l:%M:%S %p -> " (current-time))))

;;;enable narrowing- C-x n n to enable -  C-x n w to end.
(put 'narrow-to-region 'disabled nil)

(defun new-day ()
  "Insert new date and underline"
  (interactive)
  (insert-date)
  (insert "\n--------------------------\n\n"))

(if (eq system-type 'windows-nt) 
	; Windows stuff goes here
	(progn
	   (global-set-key [f12] 'explorer)  
	   (global-set-key [f11] 'fullscreen)
	   (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
	   (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
	   (global-set-key (kbd "S-C-<down>") 'shrink-window)
	   (global-set-key (kbd "S-C-<up>") 'enlarge-window)
	   )
)

(if (eq system-type 'gnu/linux)
	 (progn
	   ;; (set-default-font "-*-Monospace-*-*-*-*-12-*-*-*-*-*-iso8859-1")
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
;;	 (defun on-after-init ()
;;	   (unless (display-graphic-p (selected-frame))
;;		 (set-face-background 'default "unspecified-bg" (selected-frame))))
;;
;;	 (add-hook 'window-setup-hook 'on-after-init)

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

(defun rutf8-shell()
  "Create a shell that supports UTF-8, and rename buffer"
  (interactive)
  (set-default-coding-systems 'utf-8)
  (shell)
  (rename-buffer (read-string "Enter buffer name:")))

;;(elpy-enable)
(setq python-indent 4)

(use-package rust-mode
:ensure t)

(require 'octicons)

(make-face 'octicons-mode-line)
(set-face-attribute 'octicons-mode-line nil
                    :inherit 'mode-line
                    :inherit 'octicons)

(setq-default mode-line-format (list
    " "
    '(:eval (if (vc-backend buffer-file-name)
                (list
                 (propertize octicon-octoface 'face 'octicons-modeline)
                 (propertize " "              'face 'mode-line))))
   mode-line-mule-info
   'mode-line-modified
   "-  "
   'mode-line-buffer-identification
   "  (%l, %c)  "
   'mode-line-modes
   " -- "
   `(vc-mode vc-mode)
))

(require 'powerline)
(powerline-default-theme)
(setq powerline-text-scale-factor 0.8)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [C-f1] 'show-file-name) ; Or any other key you want

; Open daily log
; (switch-to-buffer (find-file-noselect "c:/Users/wasim/Documents/writing/daily_log/2022.org" nil nil nil))
; Open App ideas file
; (switch-to-buffer (find-file-noselect "c:/Users/wasim/Documents/writing/Notes/Ideas/app_ideas.org" nil nil nil))
; Open Work Log
; (switch-to-buffer (find-file-noselect "c:/Users/wasim/Documents/writing/daily_log/blizzard.org" nil nil nil))
; Open config
(defun open-config()
  "Open the config org file"
  (interactive)
  (switch-to-buffer (find-file-noselect "c:/Users/wasim/emacscfg/.emacs.d/myinit.org" nil nil nil)))
; Open daily log
(defun open-daily-log ()
  "Open the daily log file for editing."
  (interactive)
  (switch-to-buffer (find-file-noselect "c:/Users/wasim/Documents/writing/daily_log/2022.org" nil nil nil)))
; Open work log
(defun open-work-log ()
  "Open the work log file for editing."
  (interactive)
  (switch-to-buffer (find-file-noselect "c:/Users/wasim/Documents/writing/daily_log/blizzard.org" nil nil nil)))

(use-package lsp-mode
  :hook ((c++-mode python-mode js-mode csharp-mode) . lsp-deferred)
  :commands lsp)
(use-package lsp-ui
  :commands lsp-ui-mode)
