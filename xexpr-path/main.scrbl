#lang scribble/manual

@title{XML Expression Path Lookup}
@author{@(author+email "Jan Dvorak" "mordae@anilinux.org")}

@require[(for-label xml racket/base racket/contract "xexpr-path.rkt")]
@require[scribble/eval]

@(define xexpr-path-eval (make-base-eval))
@interaction-eval[#:eval xexpr-path-eval (require "xexpr-path.rkt")]


@defmodule[xexpr-path]

Utilities to find XML expression elements using a simple path.


@defthing[xexpr-path/c contract?]{
  Contract for XML Expression paths.

  Path is a list of components.  A valid componenet can be:

  @tabular[#:sep @hspace[1]
           (list (list @racket[symbol?]
                       @para{to match tag name, @racket['*] matches any tag})
                 (list @racket[(list/c symbol?)]
                       @para{to match an attribute})
                 (list @racket[(list/c symbol? string?)]
                       @para{to match tags with given attribute value}))]
}


@defproc[(xexpr-path-list (path xexpr-path/c) (xexpr xexpr/c))
         (listof (or/c xexpr/c string?))]{
  Look up all matching elements.

  Elements can be matched using tag names.

  @examples[#:eval xexpr-path-eval
    (xexpr-path-list '(greeting)
                     '(greetings (greeting "Hello World!")
                                 (greeting "Ahoj Světe!")))
  ]

  In some cases, it can be handy to further filter the elements by
  values of their attributes.

  @examples[#:eval xexpr-path-eval
    (xexpr-path-list '(value (type "int"))
                     '(dataset (value ((type "int")) "42")
                               (value ((type "str")) "foo")
                               (value ((type "int")) "13")))
  ]
}


@defproc[(xexpr-path-first (path xexpr-path/c) (xexpr xexpr/c))
         (or/c xexpr/c string? #f)]{
  Look up first matching element, return @racket[#f] when none match.

  @examples[#:eval xexpr-path-eval
    (xexpr-path-first '(item) '(items (item "one") (item "two")))
    (xexpr-path-first '(item) '(items))
  ]
}


@defproc[(xexpr-path-text (path xexpr-path/c) (xexpr xexpr/c))
         (or/c string? #f)]{
  Look up all matching elements, convert them to text using
  @racket[xexpr->string] and concatenate them together.

  Keep in mind that this function does not return plain string,
  but rather valid XML representation of the matched elements.

  @examples[#:eval xexpr-path-eval
    (xexpr-path-text '(prop (id "name") *)
                     '(object (prop ((id "kind")) "show")
                              (prop ((id "name")) "Lucky" 9734 "Star")))
  ]
}


@; vim:set ft=scribble sw=2 ts=2 et:
