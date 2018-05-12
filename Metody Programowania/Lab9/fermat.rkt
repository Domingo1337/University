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
;; WHILE
;;

; memory

(define empty-mem
  null)

(define (set-mem x v m)
  (cond [(null? m)
         (list (cons x v))]
        [(eq? x (caar m))
         (cons (cons x v) (cdr m))]
        [else
         (cons (car m) (set-mem x v (cdr m)))]))

(define (get-mem x m)
  (cond [(null? m) 0]
        [(eq? x (caar m)) (cdar m)]
        [else (get-mem x (cdr m))]))

; arith and bool expressions: syntax and semantics

(define (const? t)
  (number? t))

(define (true? t)
  (eq? t 'true))

(define (false? t)
  (eq? t 'false))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= not and or mod))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]
        [(eq? op '=) =]
        [(eq? op '>) >]
        [(eq? op '>=) >=]
        [(eq? op '<)  <]
        [(eq? op '<=) <=]
        [(eq? op 'not) not]
        [(eq? op 'and) (lambda x (andmap identity x))]
        [(eq? op 'or) (lambda x (ormap identity x))]
        [(eq? op 'mod) modulo]))

(define (var? t)
  (symbol? t))

(define (eval-arith e m)
  ;; funkcje pomocnicze
  (define (reverse xs)
    (define (rev-append xs ys)
      (if (null? xs) ys
          (rev-append (cdr xs) (cons (car xs) ys))))
    (rev-append xs '()))

  (define (eval-op proc done todo m)
    (if (null? todo)
        (res (apply proc (reverse done)) m)
        (let ((current (eval-arith (car todo) m)))
          (eval-op proc (cons (res-val current) done) (cdr todo) (res-state current)))))
        
  (cond [(true? e) (res true m)]
        [(false? e) (res false m)]
        [(var? e) (res (get-mem e m) m)]
        [(rand? e) (let* ((r-max (eval-arith (rand-max e) m))
                          (r ((rand (res-val r-max)) (get-mem '_seed (res-state r-max)))))
                     (res (res-val r) (set-mem '_seed (res-state r) (res-state r-max))))]
        [(op? e)
         (eval-op  (op->proc (op-op e)) '() (op-args e) m)]
      
        [(const? e) (res e m)]))

;; syntax of commands

(define (assign? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (second t) ':=)))

(define (assign-var e)
  (first e))

(define (assign-expr e)
  (third e))

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

(define (while? t)
  (tagged-tuple? 'while 3 t))

(define (while-cond t)
  (second t))

(define (while-expr t)
  (third t))

(define (block? t)
  (list? t))

;; state

(define (res v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;; psedo-random generator

(define initial-seed
  123456789)

(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res (modulo v max) v))))

(define (rand? t)
  (tagged-tuple? 'rand 2 t))

(define (rand-max e)
  (second e))

;; WHILE interpreter



(define (eval e m [seed initial-seed])
  ;; zdecydowałem się trzymać seed w pamięci, rozszerzając procedurę eval-arith
  ;; co pozwala użytkownikowi WHILE na jego zmianę
  (define (eval-aux e m)
  (cond [(assign? e)
         (let ((r (eval-arith (assign-expr e) m)))
           (set-mem
            (assign-var e)
            (res-val r)
            (res-state r)))]
        [(if? e)
         (let ((cond-res (eval-arith (if-cond e) m)))
           (if (res-val cond-res)
               (eval-aux (if-then e) (res-state cond-res))
               (eval-aux (if-else e) (res-state cond-res))))]
        [(while? e)
         (let ((cond-res (eval-arith (while-cond e) m)))
           (if (res-val cond-res)
               (eval-aux e (eval-aux (while-expr e) (res-state cond-res)))
               (res-state cond-res)))]
        [(block? e)
         (if (null? e)
             m
             (eval-aux (cdr e) (eval-aux (car e) m)))]))
  (eval-aux e (set-mem '_seed seed m)))

(define (run e)
  (eval e empty-mem initial-seed))

;;

(define fermat-test
  '{(i := 0)
    (composite := false)
    (while (and (< i k) (not composite))
           {(a := (+ 2 (rand (- n 4))))
            (m := (- n 1))
            (b := 1)
            (while (> m 0)
                   {(if (= 0 (mod m 2))
                        ((m := (/ m 2))
                         (a := (mod (* a a) n)))
                        ((m := (- m 1))
                         (b := (mod (* a b) n))))
                   })
            (if (= b 1)
                (i := (+ i 1))
                (composite := true)) 
           })
    })

(define (probably-prime? n k) ; check if a number n is prime using
                              ; k iterations of Fermat's primality
                              ; test
  (let ([memory (set-mem 'k k
                (set-mem 'n n empty-mem))])
    (not (get-mem
           'composite
           (eval fermat-test memory initial-seed)))))

(define (test-fermat)
  (let ((primes (list 5 17 2137 6263 70001 100057  99996899 100000007))
        (composites (list 6 18 42 6262 70000 100064 99999999 1000000000)))
    (and (andmap (lambda (x) (probably-prime? x 1000)) primes)
         (not (ormap (lambda (x) (probably-prime? x 1000)) composites)))))

(define (test-random)
  (let ((test1 '( (x1 := (rand 10000))
                  (x2 := (rand 10000))
                  (x3 := (rand 10000))
                  (x := (rand 10000))))
        (test2 '( (x1 := (+ (rand 10000) (rand 10000) (rand 10000)))
                  (x := (rand 10000)))))
    (and  (= (get-mem 'x (eval test1 empty-mem initial-seed))
             (get-mem 'x (eval test2 empty-mem initial-seed)))
          (= (get-mem 'x (eval test1 empty-mem (res-val ((rand 100000) initial-seed))))
             (get-mem 'x (eval test2 empty-mem (res-val ((rand 100000) initial-seed)))))
          (not (= (get-mem 'x (eval test1 empty-mem 42))
                  (get-mem 'x (eval test1 empty-mem 2137)))))))

(test-random)
(test-fermat)
