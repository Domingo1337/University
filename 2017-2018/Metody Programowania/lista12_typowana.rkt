#lang typed/racket
;;;;;;;;;;;;;;;;
;; zad 6

(: prefixes (All (A) (-> (Listof A) (Listof (Listof A)))))
(define (prefixes xs)
  (: rec (All (A) (-> (Listof A) (Listof A) (Listof (Listof A)))))
  (define (rec done todo)
    (if (null? todo)
        (list (reverse done))
        (cons (reverse done) (rec (cons (car todo) done) (cdr todo)))))
  (rec (list (car xs)) (cdr xs)))

;;;;;;;;;;;;;;;;
;; zad 7
;;; drzewa różane

(define-type Leaf 'leaf)
(define-type (Node A B) (List 'node A (Listof B)))
(define-type (Tree A) (U Leaf (Node A (Tree A))))

(define-predicate leaf? Leaf)
(define-predicate node? (Node Any Any))
(define-predicate tree? (Tree Any))

(: leaf Leaf)
(define leaf 'leaf)

(: node-val (All (A B) (-> (Node A B) A)))
(define (node-val x)
  (cadr x))

(: make-node (All (A B) (-> A (Listof B) (Node A B))))
(define (make-node v children)
  (list 'node v children))

(: node-children (All (A B) (-> (Node A B) (Listof B))))
(define (node-children x)
  (third x))

(: preorder (All (A) (-> (Tree A) (Listof A))))
(define (preorder t)
  (: helper (All (A) (-> (Tree A) (Listof A) (Listof A))))
  (define (helper t xs)
    (: children-helper (All (A) (-> (Listof (Tree A)) (Listof A) (Listof A))))
    (define (children-helper todo xs)
      (cond [(null? todo) xs]
            [(leaf? (car todo)) (children-helper (cdr todo) xs)]
            [else (helper (car todo) (children-helper (cdr todo) xs))]))
    (cond [(leaf? t) xs]
          [(tree? t) (cons (node-val t) (children-helper (node-children t) xs))]))
  (helper t '()))
