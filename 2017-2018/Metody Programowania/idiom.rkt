#lang racket

;; pomocnicza funkcja dla list tagowanych o określonej długości

(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))
;;

(define (node l r)
  (list 'node l r))

(define (node? n)
  (tagged-tuple? 'node 3 n))

(define (node-left n)
  (second n))

(define (node-right n)
  (third n))

(define (leaf? n)
  (or (symbol? n)
      (number? n)
      (null? n)))

;;

(define (res v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;;

(define (rename t)
  (define (rename-st t i)
    (cond [(leaf? t) (res i (+ i 1))]
          [(node? t)
           (let* ([rl (rename-st (node-left t) i)]
                  [rr (rename-st (node-right t) (res-state rl))])
             (res (node (res-val rl) (res-val rr))
                  (res-state rr)))]))
  (res-val (rename-st t 0)))

;;

(define (reverse xs)
  (define (rev-append xs ys)
    (if (null? xs) ys
        (rev-append (cdr xs) (cons (car xs) ys))))
  (rev-append xs '()))

(define (st-app f x y)
  (lambda (i)
    (let* ([rx (x i)]
           [ry (y (res-state rx))])
      (res (f (res-val rx) (res-val ry))
           (res-state ry)))))

(define (st-app2 f . x)
  (define (aux xs vals state)
    (if (null? xs)
        (res (reverse vals) state)
        (let ((current ((car xs) state)))
          (aux (cdr xs)
               (cons (res-val current) vals)
               (res-state current)))))
  (lambda (i)
    (let ((xs (aux x '() i)))
      (res (apply f (res-val xs))
           (res-state xs)))))
          

  
(define get-st
  (lambda (i)
    (res i i)))

(define (modify-st f)
  (lambda (i)
    (res null (f i))))

;;

(define (inc n)
  (+ n 1))

(define (rename2 t)
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app2 (lambda (x y) x)
                   get-st
                   (modify-st inc))]
          [(node? t)
           (st-app2 node
                   (rename-st (node-left  t))
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) 0)))

(define (rand  max)
  (lambda (seed)
    (let ([v (modulo  (+ (*  1103515245  seed) 12345) (expt 2 32))])
      (res (modulo v max) v))))

(define (random max n [seed 3])
  (define (aux rng n state)
    (if (= n 0)
        null
        (let ((current (rng state)))
          (cons (res-val current)
                (aux rng (- n 1) (res-state current))))))
  (aux (rand max) n seed))

(define (rename-rand t max [min 0] [seed 0])
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app2 (lambda (i) (+ min i))
                    (rand max))]
          [(node? t)
           (st-app2 node
                    (rename-st (node-left  t))
                    (rename-st (node-right t)))]))
  (res-val ((rename-st t) seed)))


