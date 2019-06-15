;;; cfml-mode.el --- Emacs mode for editing CFML files

;; Copyright 2017 Andrew Myers

;; Author: Andrew Myers <am2605@gmail.com>
;; URL: https://github.com/am2605/cfml-mode
;; Version: 1.1.0
;; Package-Requires: ((emacs "25") (mmm-mode "0.5.4"))

;;{{{ GPL

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;}}}

;;; Commentary:

;; This file contains definitions of CFML submode classes.

;; Usage:

;; Install the cfml-mode package.  CFML files should now open in cfml-mode

;;; Code:

(defgroup cfml nil
  "Major mode for cfml files"
  :prefix "cfml-"
  :group 'languages
  :link '(url-link :tag "Github" "https://github.com/am2605/cfml-mode")
  :link '(emacs-commentary-link :tag "Commentary" "cfml-mode"))

(defcustom cfml-tab-width 4
  "Tab width for cfml-mode."
  :group 'cfml
  :type 'integer)

(defcustom cfml-extra-indent 0
  "The number of columns added to every line's indentation."
  :group 'cfml
  :type 'integer)

(defconst cfml-html-empty-tags
	      '("area" "base" "basefont" "br" "col" "frame" "hr" "img" "input"
		"isindex" "link" "meta" "param" "wbr"))

(defconst cfml-html-unclosed-tags 
	'("body" "colgroup" "dd" "dt" "head" "html" "li" "option"
		"p" "tbody" "td" "tfoot" "th" "thead" "tr"))

(defconst cfml-empty-tags
	'("cfargument" "cfdump" "cfinclude" "cfparam" "cfqueryparam" "cfset" "cfsetting" "cfthrow" ))
	
(defconst cfml-unclosed-tags
	'("cfelse" "cfelseif"))

(defun cfml-last-line-p ()
  "Return whether point is on the last line in the buffer."
  (save-excursion (= (line-number-at-pos) (line-number-at-pos (point-max)))))

(defun cfml-line-empty-p ()
  "Return whether point is on an empty line."
  (string-match-p "^\s*$" (buffer-substring (point-at-bol) (point-at-eol))))

(defun cfml-get-previous-indentation ()
  "Get the column of the previous indented line"
  (interactive)
  (save-excursion
    (progn
      (move-beginning-of-line nil)
      (skip-chars-backward "\n \t")
      (back-to-indentation))
    (current-column)))

(defconst cfml-outdent-regexp
	"\\(<cfelse\\(if[^>]+\\)?>\\)"
)

(defun cfml-indent ()
  (interactive)
  (save-excursion
	(beginning-of-line)
	(skip-chars-forward " \t")
	(cond
	  ((looking-at cfml-outdent-regexp) (indent-line-to (max 0 (- (cfml-get-previous-indentation) cfml-tab-width))))
	  (t (sgml-indent-line)))))
	 
;;;###autoload
(define-derived-mode cfml-script-mode js-mode "cfscript"
  (add-to-list 'mmm-save-local-variables 'js--quick-match-re)
  (add-to-list 'mmm-save-local-variables 'js--quick-match-re-func))

;;;###autoload
(define-derived-mode cfml-tag-mode html-mode "CFML"
  "Major mode for tag based cfml."
  (setq-local sgml-empty-tags (append cfml-html-empty-tags cfml-empty-tags))
  (setq-local sgml-unclosed-tags (append cfml-html-unclosed-tags cfml-unclosed-tags))
  (setq tab-width cfml-tab-width)
  (setq indent-line-function #'cfml-indent)
)

(with-no-warnings
  (require 'mmm-mode))

;;;###autoload
(add-to-list 'magic-mode-alist
             '("<cfcomponent" . cfml-tag-mode))
;;;###autoload
(add-to-list 'magic-mode-alist
             '("<!---" . cfml-tag-mode))
;;;###autoload
(add-to-list 'auto-mode-alist
             '("\\.cfm\\'" . cfml-tag-mode))
;;;###autoload
(add-to-list 'auto-mode-alist
             '("\\.cfc\\'" . cfml-script-mode))

(setq mmm-global-mode 'maybe)
;;;###autoload
(mmm-add-mode-ext-class nil "\\.cfm\\'" 'cfml-tag)
;;;###autoload
(mmm-add-mode-ext-class nil "\\.cfc\\'" 'cfml-tag)
;;;###autoload
(mmm-add-mode-ext-class nil "\\.cfm\\'" 'cfml-script)
(setq mmm-submode-decoration-level 0)

(mmm-add-classes
 '((cfml-tag
    :submode cfml-script-mode
    :front "<cfscript>"
    :back "[ \t]*</cfscript>")))

(mmm-add-classes
 '((cfml-script
    :submode js-mode
    :front "<script[^>]*>[ \t]*\n?"
    :back "[ \t]*</script>")))

(provide 'cfml-mode)

;;; cfml-mode.el ends here
