#lang racket
;;;;;;;;;;;;;;;;;;;;;;
;; zad1
(define/contract (suffixes xs)
    (let ([a (new-∀/c 'a)])
    (-> (listof a) (listof (listof a))))
  (if (null? xs)
      xs
      (cons xs (suffixes (cdr xs)))))

(define/contract (square x)
  (->i ([x number?])
        [result (x) positive?])
  (* x x))

(require racket/contract)

(define/contract foo number? 42)

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

;(->i ((x predykat1)
;      (y predykat2))
;     (result (x y) predykat3))
;;;;;;;;;;;;;;;;;;;;;;;
;; zad2
(define/contract (sqrt x)
  (->i ([x positive?])
       [result (x) (and/c positive?
                          (lambda (y) (< (dist (square y) x) 0.0001)))])
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zad 3
(define/contract (filter2 f xs)
  (let ([a (new-∀/c 'a)])
    (-> (-> a boolean?) (listof a) (listof a)))  
  (if (null? xs)
      null
      (if (f (car xs))
          (cons (car xs) (filter2 f (cdr xs)))
          (filter2 f (cdr xs)))))

;;; drzewa różane

(define (leaf? x)
  (eq? x 'leaf))
(define (tree? x)
  (and (list? x)
  (eq? (car x) 'node)))
  
(define leaf 'leaf)

(define (node-val x)
  (cadr x))

(define (make-node v children)
  (list 'node v children))

(define (node-children x)
  (third x))

(define (preorder t xs)
  (define (pre-children todo xs)
    (cond [(null? todo) xs]
          [(leaf? (car todo)) (pre-children (cdr todo) xs)]
          [else (preorder (car todo) (pre-children (cdr todo) xs))]))
  (cond [(leaf? t) xs]
        [(tree? t) (cons (node-val t) (pre-children (node-children t) xs))]))