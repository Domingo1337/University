#lang racket

;; expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

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
        [(eq? op '/) /]))

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
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

(define (arith/let-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith/let-expr? (op-args t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def-expr (let-def t))))
      (var? t)))

;; let-lifted expressions

(define (arith-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith-expr? (op-args t)))
      (var? t)))

(define (let-lifted-expr? t)
  (or (and (let? t)
           (let-lifted-expr? (let-expr t))
           (arith-expr? (let-def-expr (let-def t))))
      (arith-expr? t)))

;; generating a symbol using a counter

(define (number->symbol i)
  (string->symbol (string-append "x" (number->string i))))

;; environments (could be useful for something)

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; the let-lift procedure

(define (let-lift e)
  ;;funkcje pomocnicze
  (define (rev-append xs ys)
    (if (null? xs) ys
        (rev-append (cdr xs) (cons (car xs) ys))))
  (define (reverse xs)
    (rev-append xs '()))
  
  ;; reprezentacja wewnetrzna
  (define (return expr counter lets)
    (list expr counter lets))
  (define ret-expr first)
  (define ret-counter second)
  (define ret-lets third)
  
  ;; glowna funkcja
  (define (lift e i lets env)
    (define (op-iter done rest i lets env)
      (if (null? rest) (return (reverse done) i lets)
          (let ((current (lift (car rest) i lets env)))
            (op-iter (cons (ret-expr current) done)
                     (cdr rest)
                     (ret-counter current)
                     (ret-lets current)
                     env))))
    (cond [(const? e) (return e i lets)]
          [(var? e) (return (find-in-env (var-var e) env) i lets)]
          [(op? e)  (let ((args (op-iter '() (op-args e) i lets env)))
                      (return (cons (op-op e) (ret-expr args))
                              (ret-counter args)
                              (ret-lets args)))]
          [(let? e) (let* ((def (lift (let-def-expr (let-def e)) i '() env))
                           (new-lets (cons (let-def-cons (number->symbol (ret-counter def))
                                                         (ret-expr def))
                                           (append (ret-lets def) lets)))
                           (new-env (add-to-env (let-def-var (let-def e))
                                                (number->symbol (ret-counter def))
                                                env)))
                      (lift (let-expr e) (+ 1 (ret-counter def)) new-lets new-env))]))
  
  ;; budowanie let-wyrażeń z reprezentacji wewnetrznej
  (define (aux lets expr)
    (if (null? lets) expr
        (aux (cdr lets) (let-cons (car lets) expr))))
  (let ((lifted (lift e 0 '() empty-env)))
    (aux (ret-lets lifted) (ret-expr lifted))))


(define (test)
  (define (lift-test expr i)
    ;; ewaluator z wykładu 
    (define empty-env
      null)

    (define (add-to-env x v env)
      (cons (list x v) env))

    (define (find-in-env x env)
      (cond [(null? env) (error "undefined variable" x)]
            [(eq? x (caar env)) (cadar env)]
            [else (find-in-env x (cdr env))]))

    (define (eval-env e env)
      (cond [(const? e) e]
            [(op? e)
             (apply (op->proc (op-op e)) (map (lambda (x) (eval-env x env)) (op-args e)))]
            [(let? e)
             (eval-env
              (let-expr e)
              (env-for-let (let-def e) env))]
            [(var? e) (find-in-env (var-var e) env)]))

    (define (env-for-let def env)
      (add-to-env
       (let-def-var def)
       (eval-env (let-def-expr def) env)
       env))

    (define (eval e)
      (eval-env e empty-env))
  
    ;; funkcja testujaca 
    (let ((lifted (let-lift expr)))
      (and (fprintf (current-output-port)
                    "Test #~a:\n~s\nAnswer:\n~v\n"
                    i expr lifted)
           (or (let-lifted-expr? lifted)
               (display "did not pass let-lifted-expr? predicate\n"))
           (or (= (eval lifted) (eval expr)) 
               (not (display "was evaluated to wrong value\n")))
           (display "passed the test successfully\n\n")
           true)))
  ;; iterator po testach
  (define (aux tests counter answr)
    (if (null? tests) answr
        (aux (cdr tests) (+ 1 counter) (cons (lift-test (car tests) counter) answr))))
  ;; testy
  (let ((tests '((let (x (+ 2 (let (z 4) (let (d (+ z 1)) (- d 1))) (let (y 2) (+ 1 y)))) (+ (let (z 3) (+ 1 (let (y (+ z (let (ż 4) ż))) (* y z)))) 1 x))
                 (let (x (let (x 4) x)) (let (x 4) (+ x (* x 2))))
                 (let (g 1) (let (v (let (v 4) v)) (let (m 3) (let (p 1) (let (s 5) 1337)))))
                 (let (x 3) (let (y 7) (+ x 43 3 x y x x y 3)))
                 (let (x (+ 2 (let (z 4) (let (d (+ z 1)) (- d 1))) (let (y 2) (+ 1 y)))) (+ (let (z 3) (+ 1 (let (y (+ z 4)) (* y z)))) 1 x))
                 (let (x (let (y (* 4 5 6)) (- y y y))) (+ x (* x (let (x (let (x (* 9 8 7)) (+ x 2 x))) (* x (+ x (let (x 3) (- 1 x))))))))
                 (let (x (let (t 8) t)) (let (y (let (z (+ x (let (a x) (+ a x)))) (let (baba 8) (let (jaga 8) (* baba jaga (- x baba)))))) (/ y x)))
                 (* (let (x (+ (let (y 4) y) (let (x 3) (- 1 x)))) x) (- (let (y 14) (let (x (- 1 y)) (* 1 2 3 x))) (let (t 1) 1)) (let (x (let (y (let (z 1) 2)) y)) x))
                 )))
    ;; zwraca true gdy wszystkie testy przeszly pomyslnie, false wpp.
    (andmap identity (aux tests 1 '()))))
    
