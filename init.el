;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
;;    zenburn-theme                  ;; Theme
;;    birds-of-paradise-plus-theme
    elpy
    helm
    evil
    flycheck
    golden-ratio
    py-autopep8
    ;; ein
    ;;for JS
;;    company-tern
    js2-mode
    flycheck
    web-beautify 
    cider
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(jdee-server-dir "/home/dietpi/.emacs.d/jdee-server")
 '(package-selected-packages
   (quote
    (pug-mode spinner queue clojure-mode cider yaml-tomato yasnippet-snippets web-mode vue-mode cl-lib ac-html evil eclim jdee virtualenv docker-compose-mode popup zzz-to-char go-guru neotree flymake-go go-autocomplete go-mode golden-ratio auto-complete yaml-mode paredit dockerfile-mode helm zenburn-theme restart-emacs better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(global-linum-mode t)
(golden-ratio-mode 1)
(setq bird-theme  "/home/dietpi/.emacs.d/birds-of-paradise-plus-theme.el")
(add-to-list 'load-path bird-theme)
(add-to-list 'custom-theme-load-path bird-theme)
(require 'birds-of-paradise-plus-theme)
(load-theme 'birds-of-paradise-plus t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; HELM

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
(ac-config-default)
;; (menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(recentf-mode 1)
(global-set-key (kbd "M-r") 'recentf-open-files)
(global-set-key (kbd "C-ç") 'comment-or-uncomment-region)


(defun simplified-beginning-of-buffer ()
  "Move point to the beginning of the buffer;
leave mark at previous position."
  (interactive)
  (push-mark)
  (goto-char (point-min)))

(global-set-key (kbd "C-x C-d") 'simplified-beginning-of-buffer)


;; Anaconda-mode
;;(setq path-anaconda "/home/dietpi/ETC/GIT/anaconda-mode")
;;(add-to-list 'load-path path-anaconda)
;;(add-hook 'python-mode-hook 'anaconda-mode)
;;(add-hook 'python-mode-hook 'anaconda-eldoc-mode)


;; ====================================
;; Development Setup
;; ====================================
;; PYTHON


;; Enable elpy
(elpy-enable)
(load "elpy")
(load "elpy-rpc")
(load "elpy-shell")
(load "elpy-profile")
(load "elpy-refactor")
(load "elpy-django")
(setq elpy-rpc-virtualenv-path "~/.emacs.d/virtualenv/for-emacs") 
;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
;; Use IPython for REPL
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "ipython3")


;;GOLANG
;;(add-to-list 'load-path "~/.emacs.d/lisp/")
;;
;;;; Snag the user's PATH and GOPATH
;;(when (memq window-system '(mac ns))
;;  (exec-path-from-shell-initialize)
;;  (exec-path-from-shell-copy-env "GOPATH"))
;;
;;;; Define function to call when go-mode loads
;;(defun my-go-mode-hook ()
;;  (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
;;  (setq gofmt-command "goimports")                ; gofmt uses invokes goimports
;;  (if (not (string-match "go" compile-command))   ; set compile command default
;;      (set (make-local-variable 'compile-command)
;;           "go build -v && go test -v && go vet"))
;;
;;  ;; guru settings
;;  (go-guru-hl-identifier-mode)                    ; highlight identifiers
;;  
;;  ;; Key bindings specific to go-mode
;;  (local-set-key (kbd "M-.") 'godef-jump)         ; Go to definition
;;  (local-set-key (kbd "M-*") 'pop-tag-mark)       ; Return from whence you came
;;  (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
;;  (local-set-key (kbd "M-P") 'recompile)          ; Redo most recent compile cmd
;;  (local-set-key (kbd "M-]") 'next-error)         ; Go to next error (or msg)
;;  (local-set-key (kbd "M-[") 'previous-error)     ; Go to previous error or msg
;;
;;  ;; Misc go stuff
;;  (auto-complete-mode 1))                         ; Enable auto-complete mode
;;
;;(require 'go-autocomplete)
;;(require 'auto-complete-config)
;;(ac-config-default)
;;;; Connect go-mode-hook with the function we just defined
;;(add-hook 'go-mode-hook 'my-go-mode-hook)
;;
;;;; Ensure the go specific autocomplete is active in go-mode.
;;(with-eval-after-load 'go-mode
;;   (require 'go-autocomplete))
;;
;;;; If the go-guru.el file is in the load path, this will load it.
;;(require 'go-guru)




;;Evil-mode
(setq evil-path "~/.backdoor/ETC/GIT/evil")
(add-to-list 'load-path evil-path)
(require 'evil)
(global-set-key (kbd "C-x v l") 'evil-mode)
;(evil-mode t)


;;Yassnippet
(setq yassnippet-path "~/.emacs.d/plugins/yasnippet")
(add-to-list 'load-path
              yassnippet-path)
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")


;;Web-mode
(setq web-mode-path "~/.emacs.d/plugins/web-mode")
(add-to-list 'load-path
              web-mode-path)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.api\\'" . web-mode))
(add-to-list 'auto-mode-alist '("/some/react/path/.*\\.js[x]?\\'" . web-mode))

(setq web-mode-content-types-alist
  '(("json" . "/some/path/.*\\.api\\'")
    ("xml"  . "/other/path/.*\\.api\\'")
    ("jsx"  . "/some/react/path/.*\\.js[x]?\\'")))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-block-face t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;Emmet-mode
(add-to-list 'load-path "~/.emacs.d/plugins/emmet-mode")
(require 'emmet-mode)
(emmet-mode t)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'web-mode 'emmet-mode)  ;; Emrah test auto start on html modes
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indent-after-insert nil)))
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent 2 spaces.
(setq emmet-move-cursor-between-quotes t) ;; default nil
;;(setq emmet-expand-jsx-className? t) ;; default nil
(setq emmet-self-closing-tag-style " /") ;; default "/"
(add-hook 'web-mode 'emmet-mode)


;;(add-hook 'web-mode 'js2-mode)
;;(defun my-paredit-nonlisp ()
;;  "Turn on paredit mode for non-lisps."
;;  (interactive)
;;  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
;;       '((lambda (endp delimiter) nil)))
;;  (paredit-mode 1))


(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)

;;js-mode kanca at
;;(add-hook 'js2-mode-hook 'my-paredit-nonlisp) ;use with the above function
;;(add-hook 'js2-mode-hook 'esk-paredit-nonlisp) ;for emacs starter kit

;;key map için anahtar oluştur
;;(setq js-mode-map (make-sparse-keymap))
;; key-map tanımla
;;(define-key js-mode-map "{" 'paredit-open-curly)
;;(define-key js-mode-map "}" 'paredit-close-curly-and-newline)
