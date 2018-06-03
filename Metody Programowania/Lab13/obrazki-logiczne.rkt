#lang racket

(require racklog)
(use-occurs-check? #t)

;; transpozycja tablicy zakodowanej jako lista list
(define (transpose xss)
  (cond [(null? xss) xss]
        ((null? (car xss)) (transpose (cdr xss)))
        [else (cons (map car xss)
                    (transpose (map cdr xss)))]))

;; procedura pomocnicza
;; tworzy listę n-elementową zawierającą wyniki n-krotnego
;; wywołania procedury f
(define (repeat-fn n f)
  (if (eq? 0 n) null
      (cons (f) (repeat-fn (- n 1) f))))

;; tworzy tablicę n na m elementów, zawierającą świeże
;; zmienne logiczne
(define (make-rect n m)
  (repeat-fn m (lambda () (repeat-fn n _))))

;; predykat binarny
;; (%row-ok xs ys) oznacza, że xs opisuje wiersz (lub kolumnę) ys
(define %row-ok
  (%rel (xs ys zs a b)
        [(null null)]
        [('(1)  '(*))]
        [((cons 1 xs) (cons '* (cons '_ ys)))
         (%row-ok xs ys)]
        [((cons a xs) (cons '* (cons '* ys)))
         (%is b (- a 1))
         (%row-ok (cons b xs) (cons '* ys))]
        [(xs (cons '_ ys))
         (%row-ok xs ys)]
        ))

(define %rows-ok
  (%rel (xs xss ys yss)
        [(null null)]
        [((cons xs xss) (cons ys yss))
         (%row-ok xs ys)
         (%rows-ok xss yss)]))
;; funkcja rozwiązująca zagadkę
(define (solve rows cols)
  (define board (make-rect (length cols) (length rows)))
  (define tboard (transpose board))
  (define ret (%which (xss yss) 
                      (%= xss board)
                      (%rows-ok rows xss)
                      (%is yss (transpose xss))
                      (%rows-ok cols yss)))
  (and ret (cdar ret)))

;; testy
(equal? (solve '((2) (1) (1)) '((1 1) (2)))
        '((* *)
          (_ *)
          (* _)))

(equal? (solve '((2) (2 1) (1 1) (2)) '((2) (2 1) (1 1) (2)))
        '((_ * * _)
          (* * _ *)
          (* _ _ *)
          (_ * * _)))
(equal? 
 (solve '((1 1 3) (1 1 1) (3 3) (1 1) (1 3))
        '((3) (1) (5) () (1 3) (1 1 1) (3 1)))
 '((* _ * _ * * *)
   (* _ * _ _ _ *)
   (* * * _ * * *)
   (_ _ * _ * _ _)
   (_ _ * _ * * *)))

