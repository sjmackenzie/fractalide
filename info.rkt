#lang info
(define collection "fractalide")
(define deps '("base" "typed-map"))
(define build-deps '())
(define scribblings '())
(define pkg-desc "An IDE for Fractalide that enables building HyperCard-like applications. Fractalide is a free and open source service programming platform using dataflow graphs.")
(define version "0.0")
(define pkg-authors '("setori88@gmail.com"))
(define racket-launcher-names '("hyperflow"
                                "fracli"))
(define racket-launcher-libraries '("pkgs/hyperflow/hyperflow.rkt"
                                    "pkgs/hyperflow/fracli.rkt"))