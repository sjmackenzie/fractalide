#lang racket/base

(require fractalide/modules/rkt/rkt-fbp/agent
         fractalide/modules/rkt/rkt-fbp/agents/gui/helper)


(require racket/gui/base
         racket/match
         racket/list)
(require (rename-in racket/class [send class-send]))

(define (generate input)
  (lambda (frame)
    (let* ([ph (new panel% [parent frame])])
      (send (input "acc") ph))))

(define-agent
  #:input '("in") ; in port
  #:input-array '("place")
  #:output '("out") ; out port
  #:output-array '("out")
  (fun
    (define acc (try-recv (input "acc")))
    (define msg-in (try-recv (input "in")))
    ; Init the first time
    (define ph (if acc
                   acc
                   (begin
                     (send (output "out") (cons 'init (generate input)))
                     (cons (make-immutable-hash) (recv (input "acc"))))))

    (if msg-in
        ; TRUE : A message in the input port
        (match msg-in
               [else (send-action output output-array msg-in)])
        ; FALSE : At least a message in the input array port
        ; Change the accumulator ph with set!
        (for ([(place containee) (input-array "place")])
             (define msg (try-recv containee))
             (if msg
                 (match msg
                        [(cons 'init cont)
                         (class-send (cdr ph) begin-container-sequence)
                         ; Add it
                         (cont (cdr ph))
                         ; Get back the children, but no display
                         (class-send (cdr ph) change-children
                                     (lambda (act)
                                       ; get the new one
                                       (define val (last act))
                                       ; add it in the acc
                                       (set! ph (cons (hash-set (car ph) place val)
                                                      (cdr ph)))
                                       (if (> (length act) 1)
                                           (list (car act))
                                           '())))
                         (class-send (cdr ph) end-container-sequence)]
                        ; Drop the children, but no change in display
                        [(cons 'delete #t)
                         (set! ph (cons (hash-remove (car ph) place)
                                        (cdr ph)))]
                        ; Display a new children
                        [(cons 'display #t)
                         (class-send (cdr ph) change-children
                                     (lambda (_)
                                       (list (hash-ref (car ph) place))))]
                        [else (send-action output output-array msg)])
                 void)))

    (send (output "acc") ph)))
