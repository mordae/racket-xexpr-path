#lang racket/base
;
;
;

(require "xexpr-path/main.rkt")

(define doc '(root
               (list-a
                 (item ((name "one")) "1")
                 (item ((name "two")) "2")
                 (item ((name "six")) "6"))
               (list-b
                 (foo "bar")
                 (bar "baz"))))


(xexpr-path-first '(list-b bar) doc)
; -> (bar "baz")

(xexpr-path-first '(list-a item (name "six") *) doc)
; -> "6"

(xexpr-path-list '(list-a item *) doc)
; -> ("1" "2" "6")

(xexpr-path-list '(list-a item (name)) doc)
; -> ("one" "two" "six")

; vim:set ts=2 sw=2 et:
