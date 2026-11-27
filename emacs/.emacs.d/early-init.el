;;; early-init.el -*- lexical-binding: t; -*-
;; Runs before the first frame exists.  Paint it in gruber-darker's colours so
;; there is no white flash while init.el loads.  Change these with the theme.
(push '(background-color . "#181818") default-frame-alist)
(push '(foreground-color . "#e4e4ef") default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
