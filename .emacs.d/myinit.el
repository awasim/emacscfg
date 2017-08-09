
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
(color-theme-initialize)
(color-theme-calm-forest)

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
