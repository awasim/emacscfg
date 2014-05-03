(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(global-font-lock-mode t nil (font-lock))
 '(load-home-init-file t t)
 '(show-paren-mode t nil (paren))
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify))))

; Load Paths
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(setq load-path (cons "~/.emacs.d" load-path))
(add-to-list 'load-path "~/.emacs.d/php-mode-1.4.0")

; Fonts
(require 'font-lock)
(setq-default font-lock-maximum-decoration t)
;; (set-default-font "-*-Consolas-*-*-*-*-14-*-*-*-*-*-iso8859-1")
(set-default-font "-*-Ubuntu\ Mono-*-*-*-*-14-*-*-*-*-*-iso8859-1")

; Frame Size
(add-to-list 'default-frame-alist '(height . 35))
(add-to-list 'default-frame-alist '(width . 90))

; Server
(server-start)

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

; Keyboard 
(global-set-key [f12] 'explorer)  
(global-set-key [f11] 'fullscreen)
(global-set-key [f7] 'previous-buffer)
(global-set-key [f8] 'next-buffer)
(global-set-key [f6] 'other-window)
(global-set-key [f5] 'frame-setup)
(global-set-key (kbd "C-q") 'global-visual-line-mode)
(global-set-key (kbd "C-;") 'insert-date)
(global-set-key (kbd "C-'") 'new-day)
(global-set-key [f4] 'eval-buffer)

; Color Themes
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)

; HTML
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.asp$" . html-helper-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.phtml$" . html-helper-mode) auto-mode-alist))

; Visual Basic
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vbs\\)$" . 
                                  visual-basic-mode)) auto-mode-alist))

; JavaScript
;(autoload 'js2-mode "js2" nil t)
;(add-to-list 'auto-mode-alist '("\\.js$" js2-mode))

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

; Python 
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(add-hook 'python-mode-hook
      (lambda ()
        (set (make-variable-buffer-local 'beginning-of-defun-function)
         'py-beginning-of-def-or-class)
        (setq outline-regexp "def\\|class ")))

; PHP
(require 'php-mode)

; Ruby
(autoload 'ruby-mode "ruby-mode" "Ruby editing mode." t)
(setq auto-mode-alist  (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '("\\.rhtml$" . html-mode) auto-mode-alist))

; Explorer
(defun explorer ()  
  "Launch the windows explorer in the current directory and selects current file"  
  (interactive)  
  (w32-shell-execute  
   "open"  
   "explorer"  
   (concat "/e,/select," (convert-standard-filename buffer-file-name))))  

; Full Screen Emacs
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

; Org mode stuff
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; Org buffers only

; Transparent Window
(defun transparent(alpha-level no-focus-alpha-level)
  "Let's you make the window transparent"
  (interactive "nAlpha level (0-100): \nnNo focus alpha level (0-100): ")
  (set-frame-parameter (selected-frame) 'alpha (list alpha-level no-focus-alpha-level))
  (add-to-list 'default-frame-alist `(alpha ,alpha-level)))
(transparent 85 70)

; Insert Date
(defun insert-date()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%a, %e %b %Y, %k:%M" (current-time))))

;;;enable narrowing- C-x n n to enable -  C-x n w to end.
(put 'narrow-to-region 'disabled nil)

(defun new-day ()
  "Insert new date and underline"
  (interactive)
  (insert-date)
  (insert "\n-----------------------\n\n"))

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
