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

;; self-evaluating expressions

(define (const? t)
  (or (number? t)
      (my-symbol? t)
      (eq? t 'true)
      (eq? t 'false)))

;; arithmetic expressions

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= eq?))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op args)
  (cons op args))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]
        [(eq? op '=)  (compose bool->val =)]
        [(eq? op '>)  (compose bool->val >)]
        [(eq? op '>=) (compose bool->val >=)]
        [(eq? op '<)  (compose bool->val <)]
        [(eq? op '<=) (compose bool->val <=)]
        [(eq? op 'eq?) (lambda (x y)
                         (bool->val (eq? (symbol-symbol x)
                                         (symbol-symbol y))))]))

;; symbols

(define (my-symbol? e)
  (and (tagged-tuple? 'quote 2 e)
       (symbol? (second e))))

(define (symbol-symbol e)
  (second e))

(define (symbol-cons s)
  (list 'quote s))

;; lets

(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

(define (let-def-var e)
  (car e))

(define (let-def-expr e)
  (cadr e))

(define (let-def-cons x e)
  (list x e))

(define (let? t)
  (and (tagged-tuple? 'let 3 t)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

;; lazy-lets

(define (lazy-let? t)
  (and (tagged-tuple? 'lazy-let 3 t)
       (let-def? (cadr t))))
(define (lazy? e)
  (tagged-tuple? 'lazy 3 e))
(define (lazy-cons expr env)
  (list 'lazy expr env))
(define lazy-expr second)
(define lazy-env third)


;; consts

(define (const?? e)
  (tagged-tuple? 'const? 2 e))
(define const-expr second)

;; variables

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

;; pairs

(define (cons? t)
  (tagged-tuple? 'cons 3 t))

(define (cons-fst e)
  (second e))

(define (cons-snd e)
  (third e))

(define (cons-cons e1 e2)
  (list 'cons e1 e2))

(define (car? t)
  (tagged-tuple? 'car 2 t))

(define (car-expr e)
  (second e))

(define (cdr? t)
  (tagged-tuple? 'cdr 2 t))

(define (cdr-expr e)
  (second e))

(define (pair?? t)
  (tagged-tuple? 'pair? 2 t))

(define (pair?-expr e)
  (second e))

(define (pair?-cons e)
  (list 'pair? e))


;; if

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cons b t f)
  (list 'let b t f))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

;; cond

(define (cond-clause? t)
  (and (list? t)
       (= (length t) 2)))

(define (cond-clause-cond c)
  (first c))

(define (cond-clause-expr c)
  (second c))

(define (cond-claue-cons b e)
  (list b e))

(define (cond? t)
  (and (tagged-list? 'cond t)
       (andmap cond-clause? (cdr t))))

(define (cond-clauses e)
  (cdr e))

(define (cond-cons cs)
  (cons 'cond cs))

;; lists

(define (my-null? t)
  (eq? t 'null))

(define (null?? t)
  (tagged-tuple? 'null? 2 t))

(define (null?-expr e)
  (second e))

(define (null?-cons e)
  (list 'null? e))

(define (list?? e)
  (and (eq? (car e) 'list)
       (list? e)))

(define (list-cons e)
  (define (rec xs)
    (if (null? xs) 'null
        (cons-cons (car xs) (rec (cdr xs)))))
  (rec (cdr e)))

;; lambdas

(define (lambda? t)
  (and (tagged-tuple? 'lambda 3 t)
       (or (and (list? (cadr t))
                (andmap symbol? (cadr t)))
           (symbol? (cadr t)))))

(define (lambda-cons vars e)
  (list 'lambda vars e))

(define (lambda-vars e)
  (cadr e))

(define (lambda-expr e)
  (caddr e))

;; lambda-rec

(define (lambda-rec? t)
  (and (tagged-tuple? 'lambda-rec 3 t)
       (list? (cadr t))
       (>= (length (cadr t)) 1)
       (andmap symbol? (cadr t))))

(define (lambda-rec-cons vars e)
  (list 'lambda-rec vars e))

(define (lambda-rec-expr e)
  (third e))

(define (lambda-rec-name e)
  (car (second e)))

(define (lambda-rec-vars e)
  (cdr (second e)))

;; applications

(define (app? t)
  (and (list? t)
       (> (length t) 0)))

(define (app-cons proc args)
  (cons proc args))

(define (app-proc e)
  (car e))

(define (app-args e)
  (cdr e))

;; expressions

(define (expr? t)
  (or (const? t)
      (and (op? t)
           (andmap expr? (op-args t)))
      (and (let? t)
           (expr? (let-expr t))
           (expr? (let-def-expr (let-def t))))
      (and (cons? t)
           (expr? (cons-fst t))
           (expr? (cons-snd t)))
      (and (car? t)
           (expr? (car-expr t)))
      (and (cdr? t)
           (expr? (cdr-expr t)))
      (and (pair?? t)
           (expr? (pair?-expr t)))
      (and (null?? t)
           (expr? (null?-expr t)))
      (and (if? t)
           (expr? (if-cond t))
           (expr? (if-then t))
           (expr? (if-else t)))
      (and (cond? t)
           (andmap (lambda (c)
                     (and (expr? (cond-clause-cond c))
                          (expr? (cond-clause-expr c))))
                   (cond-clauses t)))
      (and (lambda? t)
           (expr? (lambda-expr t)))
      (var? t)
      (and (app? t)
           (expr? (app-proc t))
           (andmap expr? (app-args t)))))

;; environments

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (let ((y (cadar env)))
                              (if (lazy? y)
                                  (eval-env (lazy-expr y) (lazy-env y))
                                  y))]
        [else (find-in-env x (cdr env))]))

;; closures

(define (closure-cons xs expr env)
  (list 'closure xs expr env))

(define (closure-list-cons xs expr env)
  (list 'closure-list xs expr env))
(define (closure-list? c)
  (and (list? c)
       (= (length c) 4)
       (eq? (car c) 'closure-list)))

(define (closure? c)
  (and (list? c)
       (= (length c) 4)
       (eq? (car c) 'closure)))

(define (closure-vars c)
  (cadr c))

(define (closure-expr c)
  (caddr c))

(define (closure-env c)
  (cadddr c))

;; closure-rec

(define (closure-rec? t)
  (tagged-tuple? 'closure-rec 5 t))

(define (closure-rec-name e)
  (second e))

(define (closure-rec-vars e)
  (third e))

(define (closure-rec-expr e)
  (fourth e))

(define (closure-rec-env e)
  (fifth e))

(define (closure-rec-cons f xs e env)
  (list 'closure-rec f xs e env))

;; evaluator

(define (bool->val b)
  (if b 'true 'false))

(define (val->bool s)
  (cond [(eq? s 'true)  true]
        [(eq? s 'false) false]
        [else (error "could not convert symbol to bool")]))

(define (eval-env e env)
  (cond [(const? e)
         e]
        [(op? e)
         (apply (op->proc (op-op e))
                (map (lambda (a) (eval-env a env))
                     (op-args e)))]
        [(let? e)
         (eval-env (let-expr e)
                   (env-for-let (let-def e) env))]
        [(lazy-let? e)
         (eval-env (let-expr e)
                   (add-to-env
                    (let-def-var (let-def e))
                    (lazy-cons (let-def-expr (let-def e)) env)
                    env))]
        [(my-null? e)
         null]
        [(cons? e)
         (cons (eval-env (cons-fst e) env)
               (eval-env (cons-snd e) env))]
        [(car? e)
         (car (eval-env (car-expr e) env))]
        [(cdr? e)
         (cdr (eval-env (cdr-expr e) env))]
        [(pair?? e)
         (bool->val (pair? (eval-env (pair?-expr e) env)))]
        [(null?? e)
         (bool->val (null? (eval-env (null?-expr e) env)))]
        [(if? e)
         (if (val->bool (eval-env (if-cond e) env))
             (eval-env (if-then e) env)
             (eval-env (if-else e) env))]
        [(cond? e)
         (eval-cond-clauses (cond-clauses e) env)]
        [(var? e)
         (find-in-env (var-var e) env)]
        [(lambda? e)
         (if (list? (lambda-vars e))
             (closure-cons (lambda-vars e) (lambda-expr e) env)
             (closure-list-cons (list (lambda-vars e)) (lambda-expr e) env))]
        [(lambda-rec? e)
         (closure-rec-cons (lambda-rec-name e)
                           (lambda-rec-vars e)
                           (lambda-rec-expr e)
                           env)]
        [(list?? e)
         (eval-env (list-cons e) env)]
        [(const?? e)
         (bool->val (const? (eval-env (const-expr e) env)))]
        [(app? e)
         (apply-closure
          (eval-env (app-proc e) env)
          (map (lambda (a) (eval-env a env))
               (app-args e)))]))

(define (eval-cond-clauses cs env)
  (if (null? cs)
      (error "no true clause in cond")
      (let ([cond (cond-clause-cond (car cs))]
            [expr (cond-clause-expr (car cs))])
        (if (val->bool (eval-env cond env))
            (eval-env expr env)
            (eval-cond-clauses (cdr cs) env)))))

(define (apply-closure c args)
  (cond [(closure-list? c)
         (eval-env
          (closure-expr c)
          (env-for-closure
           (closure-vars c)
           (list args)
           (closure-env c)))]
        [(closure? c)
         (eval-env
          (closure-expr c)
          (env-for-closure
           (closure-vars c)
           args
           (closure-env c)))]
        [(closure-rec? c)
         (eval-env
          (closure-rec-expr c)
          (add-to-env
           (closure-rec-name c)
           c
           (env-for-closure
            (closure-rec-vars c)
            args
            (closure-rec-env c))))]))

(define (env-for-closure xs vs env)
  (cond [(and (null? xs) (null? vs)) env]
        [(and (not (null? xs)) (not (null? vs)))
         (add-to-env
          (car xs)
          (car vs)
          (env-for-closure (cdr xs) (cdr vs) env))]
        [else (error "arity mismatch")]))

(define (env-for-let def env)
  (add-to-env
   (let-def-var def)
   (eval-env (let-def-expr def) env)
   env))

(define (eval e)
  (eval-env e empty-env))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zad1:
(define (lcons x f)
  (cons x f))

(define (lhead l)
  (car l))

(define (ltail l)
  ((cdr l)))

(define (nats-from m)
  (lcons
   m
   (lambda () (nats-from (+ m 1)))))

(define nats
  (nats-from 0))

(define (take n l)
  (if (or (null? l) (= n 0))
      null
      (cons (lhead l)
            (take (- n 1) (ltail l)))))

(define (fib-from i j)
  (cons
   j
   (lambda () (fib-from j (+ i j)))))
(define (ints-from i)
  (cons
   i
   (if (> i 0) 
       (lambda () (ints-from (- i)))
       (lambda () (ints-from (+ 1 (- i)))))))

(define fib
  (fib-from 0 1))
(define ints
  (ints-from 0))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; zad2:
(define my-append '(lambda-rec (append x y)
                               (if (null? x)
                                   y
                                   (cons (car x)
                                         (append (cdr x) y)))))
(define reverse '(lambda (x)
                   ((lambda-rec (rev-app xs ys)
                                (if (null? xs)
                                    ys
                                    (rev-app (cdr xs) (cons (car xs) ys))))
                    x null)))
(define my-map '(lambda-rec (map proc list)
                            (if (null? list)
                                null
                                (cons (proc (car list))
                                      (map proc (cdr list))))))

(define (lappend xs ys)
  (if (null? xs)
      ys
      (cons (lhead xs) (lappend (ltail xs)  ys))))
(define (lmap proc . xss)
  (if (ormap null? xss)
      null
      (lcons (apply proc (map lhead xss))
             (lambda ()
               (apply lmap (cons proc (map ltail xss)))))))
(define lints (lmap (lambda (x) (if (= 1 (modulo x 2)) (/ (+ x 1) 2) (- (/ x 2)))) nats))

(define lfibs
  (lcons 1 (lambda () (lcons 1 ( lambda () (lmap + lfibs (ltail lfibs)))))))

;; pracownia 8A
(eval '(let (eval-arith
             ;; ewaluator podstawowych wyrażeń arytmetycznych racketa w rackecie w rackecie
             (lambda-rec (eval-arith x)
                         (cond ((const? x) x)
                               ((pair? x) (let (op (car x))
                                            (let (first (eval-arith (car (cdr x))))
                                              (let (second (eval-arith (car (cdr (cdr x)))))
                                                (cond ((eq? op '+) (+ first second))
                                                      ((eq? op '-) (- first second))
                                                      ((eq? op '*) (* first second))
                                                      ((eq? op '/) (/ first second))))))))))
         ;; lista testów- argumentów dla procedury 
         (list (= (- 1 2)
                  (eval-arith (list '- 1 2)))
               (= (* 6 7)
                  (eval-arith (list '* 6 7)))
               (= (+ (* (* 11 2) 3) (/ 6 7))
                  (eval-arith (list '+ (list '* (list '* 11 2) 3) (list '/ 6 7)))))))
