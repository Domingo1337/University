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
    (define (op-iter done rest i env)
      (if (null? rest) (return (reverse (map ret-expr done))
                               i
                               (map ret-lets done))
          (let ((current (lift (car rest) i '() env)))
            (op-iter (cons current done)
                     (cdr rest)
                     (ret-counter current)
                     env))))
    (cond [(const? e) (return e i lets)]
          [(var? e) (return (find-in-env (var-var e) env) i lets)]
          [(op? e)  (let ((args (op-iter '() (op-args e) i env)))
                      (return (cons (op-op e) (ret-expr args))
                              (ret-counter args)
                              (foldl rev-append lets (ret-lets args))))]
          [(let? e) (let* ((def (lift (let-def-expr (let-def e)) i '() env))
                           (new-lets (cons (let-def-cons (number->symbol (ret-counter def))
                                                         (ret-expr def))
                                           (rev-append (ret-lets def) lets)))
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