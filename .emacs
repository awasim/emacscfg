(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Latin-1")
 '(custom-safe-themes
   '("57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "2dff5f0b44a9e6c8644b2159414af72261e38686072e063aa66ee98a2faecf0e" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "28caf31770f88ffaac6363acfda5627019cac57ea252ceb2d41d98df6d87e240" "f357d72451c46d51219c3afd21bb397a33cb059e21db1f4adeffe5b8a9093537" "8dc7f4a05c53572d03f161d82158728618fb306636ddeec4cce204578432a06d" "0dd2666921bd4c651c7f8a724b3416e95228a13fca1aa27dc0022f4e023bf197" "b73a23e836b3122637563ad37ae8c7533121c2ac2c8f7c87b381dd7322714cd0" "af4dc574b2f96f5345d55b98af024e2db9b9bbf1872b3132bc66dffbf5e1ba1d" "28bf1b0a72e3a1e08242d776c5befc44ba67a36ced0e55df27cfc7ae6be6c24d" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))
 '(default-input-method "latin-1-prefix")
 '(global-font-lock-mode t nil (font-lock))
 '(load-home-init-file t t)
 '(org-agenda-files '("~/docs/2020.org"))
 '(package-selected-packages
   '(lsp-ui marginalia orderless vertico rjsx-mode csharp-mode lsp-mode toxi-theme afternoon-theme solarized-theme expand-region rainbow-delimiters go-mode dracula-theme rope-read-mode jedi org-bullets which-key js2-mode rust-mode night-owl-theme calmer-forest-theme powerline octicons elpy try use-package))
 '(show-paren-mode t nil (paren))
 '(size-indication-mode t)
 '(text-mode-hook '(turn-on-auto-fill text-mode-hook-identify))
 '(tool-bar-mode nil))

(setq frame-inhibit-implied-resize t)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))

(set-cursor-color "#ff6961")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack NF" :foundry "outline" :slant normal :weight normal :height 120 :width normal))))
 '(mode-line ((t (:background "grey75" :foreground "black" :box nil :slant normal :weight normal :height 98 :width normal :foundry "outline" :family "Hack NF")))))
(set-face-attribute 'mode-line nil :font "Hack NF-10")
(size-1)
