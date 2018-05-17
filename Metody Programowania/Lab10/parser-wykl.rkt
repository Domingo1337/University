#lang racket

(require "calc.rkt")

(define (def-name p)
  (car p))

(define (def-prods p)
  (cdr p))

(define (rule-name r)
  (car r))

(define (rule-body r)
  (cdr r))

(define (lookup-def g nt)
  (cond [(null? g) (error "unknown non-terminal" g)]
        [(eq? (def-name (car g)) nt) (def-prods (car g))]
        [else (lookup-def (cdr g) nt)]))

(define parse-error 'PARSEERROR)

(define (parse-error? r) (eq? r 'PARSEERROR))

(define (res v r)
  (cons v r))

(define (res-val r)
  (car r))

(define (res-input r)
  (cdr r))

;;

(define (token? e)
  (and (list? e)
       (> (length e) 0)
       (eq? (car e) 'token)))

(define (token-args e)
  (cdr e))

(define (nt? e)
  (symbol? e))

;;

(define (parse g e i)
  (cond [(token? e) (match-token (token-args e) i)]
        [(nt? e) (parse-nt g (lookup-def g e) i)]))

(define (parse-nt g ps i)
  (if (null? ps)
      parse-error
      (let ([r (parse-many g (rule-body (car ps)) i)])
        (if (parse-error? r)
            (parse-nt g (cdr ps) i)
            (res (cons (rule-name (car ps)) (res-val r))
                 (res-input r))))))

(define (parse-many g es i)
  (if (null? es)
      (res null i)
      (let ([r (parse g (car es) i)])
        (if (parse-error? r)
            parse-error
            (let ([rs (parse-many g (cdr es) (res-input r))])
              (if (parse-error? rs)
                  parse-error
                  (res (cons (res-val r) (res-val rs))
                       (res-input rs))))))))

(define (match-token xs i)
  (if (and (not (null? i))
           (member (car i) xs))
      (res (car i) (cdr i))
      parse-error))

;;

(define num-grammar
  '([digit {DIG (token #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)}]
    [numb {MANY digit numb}
          {SINGLE digit}]))

(define (node-name t)
  (car t))

(define (c->int c)
  (- (char->integer c) (char->integer #\0)))

(define (walk-tree-acc t acc)
  (cond [(eq? (node-name t) 'MANY)
         (walk-tree-acc
          (third t)
          (+ (* 10 acc) (c->int (second (second t)))))]
        [(eq? (node-name t) 'SINGLE)
         (+ (* 10 acc) (c->int (second (second t))))]))

(define (walk-tree t)
  (walk-tree-acc t 0))

;;

(define arith-grammar
  (append num-grammar
     '([add-expr {ADD-MANY   mult-expr (token #\+) add-expr}
                 {SUB        mult-expr (token #\-) add-expr}
                 {ADD-SINGLE mult-expr}]
       [mult-expr {MULT-MANY   base-expr (token #\*) mult-expr}
                  {DIV         base-expr (token #\/) mult-expr}
                  {MULT-SINGLE base-expr}]
       [base-expr {BASE-NUM numb}
                  {PARENS (token #\() add-expr (token #\))}])))

(define (arith-walk-tree t)
  (cond [(eq? (node-name t) 'ADD-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'MULT-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'ADD-MANY)
         (binop-cons
          '+
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'SUB)
         (let* ((right (fourth t))
                (oper (node-name right)))
           (if (or (eq? oper 'ADD-MANY)
                   (eq? oper 'SUB))
               (arith-walk-tree
                (list oper
                      (list 'SUB (second t) 'token (second right))
                      'token
                      (fourth right)))
               (binop-cons
                '-
                (arith-walk-tree (second t))
                (arith-walk-tree right))))]
        [(eq? (node-name t) 'MULT-MANY)
         (binop-cons
          '*
          (arith-walk-tree (second t))
          (arith-walk-tree (fourth t)))]
        [(eq? (node-name t) 'DIV)
         (let* ((right (fourth t))
                (oper (node-name right)))
           (if (or (eq? oper 'MULT-MANY)
                   (eq? oper 'DIV))
               (arith-walk-tree
                (list oper
                      (list 'DIV (second t) 'token (second right))
                      'token
                      (fourth right)))
               (binop-cons
                '/
                (arith-walk-tree (second t))
                (arith-walk-tree right))))]
        [(eq? (node-name t) 'BASE-NUM)
         (walk-tree (second t))]
        [(eq? (node-name t) 'PARENS)
         (arith-walk-tree (third t))]))

(define (calc s)
 (eval
  (arith-walk-tree
   (car
    (parse
       arith-grammar
       'add-expr
       (string->list s))))))

(define (test)
  (define (test-aux xs ys)
    (cond [(null? xs) #t]
          [(= (calc (car xs)) (car ys)) (test-aux (cdr xs) (cdr ys))]
          [else (fprintf (current-output-port)
                         "Fail: ~a was evaluated to ~s instead of ~v.\n"
                         (car xs) (calc (car xs)) (car ys))
                (and (test-aux (cdr xs) (cdr ys)) #f)]))
  (let ((tests (list "1-2" "1/2" "1/2/3*3*2" "1-2-3-4" "1/2/3/4" "0-1+2/3"))
        (answers (list -1 0.5 1 (calc "((1-2)-3)-4") (calc "((1/2)/3)/4") (calc "0+2/3-1"))))
    (and (test-aux tests answers)
         (display "All tests passed succesfully.\n")
         #t)))
(test)
