;;;; package.lisp

(defpackage #:abcl-ethereum-utils
  (:use #:cl)
  (:export #:query-erc20
           #:*provider-url*))
