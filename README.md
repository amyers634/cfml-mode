# cfml-mode

cfml-mode provides syntax highlighting for CFML files in Emacs.

## Download

cfml-mode is available on [melpa](https://melpa.org)

## Installation

Add the following to your init.el

```lisp
(require 'mmm-mode)
(require 'cfml-mode)

;; choose modes for CFML automatically
(add-to-list 'magic-mode-alist
             '("<cfcomponent" . cfml-mode))
(add-to-list 'magic-mode-alist
             '("<!---" . cfml-mode))
(add-to-list 'auto-mode-alist
             '("\\.cfm\\'" . cfml-mode))
(add-to-list 'auto-mode-alist
             '("\\.cfc\\'" . cfscript-mode))

;; Use mmm-mode for highlighting of cfscript blocks in cfml files
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.cfm\\'" 'html-cfm)
(mmm-add-mode-ext-class nil "\\.cfc\\'" 'html-cfm)

(setq mmm-submode-decoration-level 0)
```


