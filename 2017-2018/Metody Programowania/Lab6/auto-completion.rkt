#lang racket

(define (const? t)
  (number? t))

(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))

(define (binop-op e)
  (car e))

(define (binop-left e)
  (cadr e))

(define (binop-right e)
  (caddr e))

(define (binop-cons op l r)
  (list op l r))

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

(define (hole? t)
  (eq? t 'hole))

(define (arith/let/holes? t)
  (or (hole? t)
      (const? t)
      (and (binop? t)
           (arith/let/holes? (binop-left  t))
           (arith/let/holes? (binop-right t)))
      (and (let? t)
           (arith/let/holes? (let-expr t))
           (arith/let/holes? (let-def-expr (let-def t))))
      (var? t)))

(define (num-of-holes t)
  (cond [(hole? t) 1]
        [(const? t) 0]
        [(binop? t)
         (+ (num-of-holes (binop-left  t))
            (num-of-holes (binop-right t)))]
        [(let? t)
         (+ (num-of-holes (let-expr t))
            (num-of-holes (let-def-expr (let-def t))))]
        [(var? t) 0]))

(define (arith/let/hole-expr? t)
  (and (arith/let/holes? t)
       (= (num-of-holes t) 1)))

(define (hole-context e)
  (define (iter var-list e todo)
    (cond [(hole? e) var-list]
          [(let? e)  (iter var-list (let-def e) (cons (let-expr e) todo))]
          [(let-def? e) (iter var-list (let-def-expr e) (cons (let-def-var e) todo))]
          ;; zdecydowałem się na fałsz jako reprezentację wyrażenia bez dziur,
          ;; żeby móc użyć w tym miejscu or'a zamiast kilku let'ów i if'ów,
          ;; co według mnie jest bardziej eleganckim rozwiązaniem
          [(binop? e) (or (iter var-list (binop-left e) null)
                          (iter var-list (binop-right e) null)
                          (if (null? todo)
                              #f
                              (iter var-list (car todo) (cdr todo))))]
          [(var? e) (if (null? todo)
                        #f
                        (iter (if (member e var-list)
                                  var-list
                                  (cons e var-list))
                              (car todo) (cdr todo)))]
          [(const? e) (if (null? todo)
                          #f
                          (iter var-list (car todo) (cdr todo)))]))
  (or (iter '() e '())
      null))


(define (test)
  ;; funkcje pomocnicze
  (define (eq-list? xs ys)
    (cond [(null? xs) (null? ys)]
          [(null? ys) #f]
          [(eq? (car xs) (car ys)) (eq-list? (cdr xs) (cdr ys))]
          [else #f]))
  (define (display-false-result expr rslt)
    (display "hole-context of '") (display expr)
    (display " should be '") (display rslt)
    (display ", but '") (display (hole-context expr))
    (display " was returned instead.") (newline))
  ;;funkcja testujaca:
  (define (test-check tests)
    (andmap identity
            (map
             (lambda (x) (if (eq-list? (sort (hole-context (first x)) symbol<?)
                                       (sort (second x) symbol<?))
                             #t
                             (not (display-false-result (first x) (second x)))))
             tests)))
  ;testy jako lista list 2-elementowych '(wejscie wyjscie)
  (test-check '(((+ 3 hole)                         ())
                ((let (x 3) (let (y 7) (+ x hole))) (y x))
                ((let (x 3) (let (y hole) (+ x 3))) (x))
                ((let (x hole) (let (y 7) (+ x 3))) ())
                ((let (kotek 7) (let (piesek 9)     (let (chomik 5) hole))) (chomik kotek piesek))
                ((+ (let (x 4) 5) hole)             ()) 
                )))
(test)
