# cfml-mode

cfml-mode provides syntax highlighting for CFML files in Emacs.

## Download

cfml-mode is available on [melpa](https://melpa.org)

## Installation

Add the following to your init.el

```lisp
(require 'mmm-mode)
(require 'cfml-mode)

(add-to-list 'magic-mode-alist
             '("<cfcomponent" . cftag-mode))
(add-to-list 'magic-mode-alist
             '("<!---" . cftag-mode))
(add-to-list 'auto-mode-alist
             '("\\.cfm\\'" . cftag-mode))
(add-to-list 'auto-mode-alist
             '("\\.cfc\\'" . cfml-cfscript-mode))

(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.cfm\\'" 'cfml-cftag)
(mmm-add-mode-ext-class nil "\\.cfc\\'" 'cfml-cftag)

;; Optional 
(setq mmm-submode-decoration-level 0)
```
