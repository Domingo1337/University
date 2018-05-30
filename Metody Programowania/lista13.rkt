#lang racket

(require racklog)
(use-occurs-check? #t)
;; predykat unarny %male reprezentuje zbiór mężczyzn
(define %male
  (%rel ()
        [('adam)]
        [('john)]
        [('joshua)]
        [('mark)]
        [('david)]))

;; predykat unarny %female reprezentuje zbiór kobiet
(define %female
  (%rel ()
        [('eve)]
        [('helen)]
        [('ivonne)]
        [('anna)]))

;; predykat binarny %parent reprezentuje relację bycia rodzicem
(define %parent
  (%rel ()
        [('adam 'helen)]
        [('adam 'ivonne)]
        [('adam 'anna)]
        [('eve 'helen)]
        [('eve 'ivonne)]
        [('eve 'anna)]
        [('john 'joshua)]
        [('helen 'joshua)]
        [('ivonne 'david)]
        [('mark 'david)]))

;; predykat binarny %sibling reprezentuje relację bycia rodzeństwem
(define %sibling
  (%rel (a b c)
        [(a b)
         (%parent c a)
         (%parent c b)]))

;; predykat binarny %sister reprezentuje relację bycia siostrą
(define %sister
  (%rel (a b)
        [(a b)
         (%sibling a b)
         (%female a)]))

;; predykat binarny %ancestor reprezentuje relację bycia przodkiem
(define %ancestor
  (%rel (a b c)
        [(a b)
         (%parent a b)]
        [(a b)
         (%parent a c)
         (%ancestor c b)]))
;; listy
(define %my-append
  (%rel (x xs ys zs)
        [(null ys ys)]
        [((cons x xs) ys (cons x zs))
         (%my-append xs ys zs)]))

(define %my-member
  (%rel (x xs y)
        [(x (cons x xs))]
        [(y (cons x xs))
         (%my-member y xs)]))

(define %select
  (%rel (x xs y ys)
        [(x (cons x xs) xs)]
        [(y (cons x xs) (cons x ys))
         (%select y xs ys)]))

;; prosta rekurencyjna definicja
(define %simple-length
  (%rel (x xs n m)
        [(null 0)]
        [((cons x xs) n)
         (%simple-length xs m)
         (%is n (+ m 1))]))

;; test w trybie +- (działa)
;(%find-all (a) (%simple-length (list 1 2) a))
;; test w trybie ++ (działa)
;(%find-all () (%simple-length (list 1 2) 2))
;; test w trybie -+ (1 odpowiedź, pętli się)
;(%which (xs) (%simple-length xs 2))
;; test w trybie -- (nieskończona liczba odpowiedzi)
;(%which (xs a) (%simple-length xs a))

;; definicja zakładająca, że długość jest znana
(define %gen-length
  (%rel (x xs n m)
        [(null 0) !]
        [((cons x xs) n)
         (%is m (- n 1))
         (%gen-length xs m)]))
;; test w trybie ++ (działa)
;(%find-all () (%gen-length (list 1 2) 2))
;; test w trybie -+ (działa)
;(%find-all (xs) (%gen-length xs 2))

;;;;;;;;;;;;;;;;;;;;;;;;
;; zad 1
(define %grandson
  (%rel (a b c)
        [(a b)
         (%male a)
         (%parent c a)
         (%parent b c)]))
(define %cousin
  (%rel (a b c)
        [(a b)
         (%ancestor c a)
         (%ancestor c b)]))
(define %is_mother
  (%rel (a b)
        [(a)
         (%female a)
         (%parent a b)]))
(define %is_father
  (%rel (a b)
        [(a)
         (%male a)
         (%parent a b)]))

;;;;;;;;;;;;;;;;;;;;;;;;
;; zad 2
;(%which () (%ancestor 'mark 'john))
;(%find-all (x y) (%and (%male y) (%cousin x y)))
;(%let (y) (%find-all (x) (%and (%male y) (%cousin x y))))

;;;;;;;;;;;;;;;;;;;;;;;
;; zad 3
(%which (x y) (%append x x y))
(%which (x) (%select x '(1 2 3 4) '(1 2 4)))
(%which (x) (%append '(1 2 3) x '(1 2 3 4 5)))

;;;;;;;;;;;;;;;;;;;;;;;
;; zad 6
#|(define (sublist? xs ys)
  (cond [(null? xs) #t]
        [(null? ys) #f]
        [else (if (eq? (car xs) (car ys))
                  (sublist? (cdr xs) (cdr ys))
                  (sublist? xs (cdr ys)))]))
|#
(define %sublist
  (%rel (x xs ys)
        [(null null)]
        [((cons x xs) (cons x ys))
         (%sublist xs ys)]
        [(xs (cons x ys))
         (%sublist xs ys)]
        ))

;;;;;;;;;;;;;;;;;;;;;;;
;; zad 7

;;tryby: ++ -+
(define %perm
  (%rel (x xs ys zs)
        [(null null)]
        [((cons x xs) ys)
         (%select x ys zs)
         (%perm xs zs)]))

;;;;;;;;;;;;;;;;;;;;;;;
;; zad 8
(define (list->num xs)
  (define (aux xs acc)
    (if (null? xs)
        acc
        (aux (cdr xs) (+ (car xs) (* 10 acc)))))
  (aux xs 0))

(define (sym->num x xs ys)
  (if (eq? (car xs) x)
      (car ys)
      (sym->num x (cdr xs)(cdr ys))))

(%let (xs a b)
(%which (d e m n o r s y)
        (%and (%sublist xs '(0 1 2 3 4 5 6 7 8 9))
              (%gen-length xs 8)
              (%perm (list d e m n o r s y) xs)
              (%=/= s 0)
              (%=/= m 0)
              (%is a (+ (list->num (list s e n d))
                        (list->num (list m o r e))))
              (%is b (list->num (list m o n e y)))
              (%= a b))))
              


        