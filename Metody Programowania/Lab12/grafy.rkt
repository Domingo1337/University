#lang racket

;; sygnatura: grafy
(define-signature graph^
  ((contracted
    [graph        (-> list? (listof edge?) graph?)]
    [graph?       (-> any/c boolean?)]
    [graph-nodes  (-> graph? list?)]
    [graph-edges  (-> graph? (listof edge?))]
    [edge         (-> any/c any/c edge?)]
    [edge?        (-> any/c boolean?)]
    [edge-start   (-> edge? any/c)]
    [edge-end     (-> edge? any/c)]
    [has-node?    (-> graph? any/c boolean?)]
    [outnodes     (-> graph? any/c list?)]
    [remove-node  (-> graph? any/c graph?)]
    )))

;; prosta implementacja grafów
(define-unit simple-graph@
  (import)
  (export graph^)

  (define (graph? g)
    (and (list? g)
         (eq? (length g) 3)
         (eq? (car g) 'graph)))

  (define (edge? e)
    (and (list? e)
         (eq? (length e) 3)
         (eq? (car e) 'edge)))

  (define (graph-nodes g) (cadr g))

  (define (graph-edges g) (caddr g))

  (define (graph n e) (list 'graph n e))

  (define (edge n1 n2) (list 'edge n1 n2))

  (define (edge-start e) (cadr e))

  (define (edge-end e) (caddr e))

  (define (has-node? g n) (not (not (member n (graph-nodes g)))))
  
  (define (outnodes g n)
    (filter-map
     (lambda (e)
       (and (eq? (edge-start e) n)
            (edge-end e)))
     (graph-edges g)))

  (define (remove-node g n)
    (graph
     (remove n (graph-nodes g))
     (filter
      (lambda (e)
        (not (eq? (edge-start e) n)))
      (graph-edges g)))))

;; sygnatura dla struktury danych
(define-signature bag^
  ((contracted
    [bag?       (-> any/c boolean?)]
    [empty-bag  (and/c bag? bag-empty?)]
    [bag-empty? (-> bag? boolean?)]
    [bag-insert (-> bag? any/c (and/c bag? (not/c bag-empty?)))]
    [bag-peek   (-> (and/c bag? (not/c bag-empty?)) any/c)]
    [bag-remove (-> (and/c bag? (not/c bag-empty?)) bag?)])))

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)

  (define (bag? b)
    (list? b))
  
  (define (bag-empty? b)
    (null? b))
  
  (define empty-bag null)
  
  (define (bag-insert b elem)
    (cons elem b))

  (define (bag-peek b)
    (car b))

  (define (bag-remove b)
    (cdr b))
  )

;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)

  (define (fifo-cons x y) (if (null? y)
                              (cons null (reverse x))
                              (cons x y)))
  (define (fifo-left b) (car b))
  (define (fifo-rght b) (cdr b))

  (define (bag? b)
    (and (pair? b)
         (list? (car b))
         (list? (cdr b))))

  (define (bag-empty? b)
    (and (null? (car b))
         (null? (cdr b))))
  
  (define empty-bag
    (cons null null))
  
  (define (bag-insert b elem)
    (fifo-cons (cons elem (fifo-left b))
               (fifo-rght b)))

  (define (bag-peek b)
    (car (fifo-rght b)))
  
  (define (bag-remove b)
    (fifo-cons (fifo-left b) (cdr (fifo-rght b))))
  )

;; sygnatura dla przeszukiwania grafu
(define-signature graph-search^
  (search))

;; implementacja przeszukiwania grafu
;; uzależniona od implementacji grafu i struktury danych
(define-unit/contract graph-search@
  (import bag^ graph^)
  (export (graph-search^
           [search (-> graph? any/c (listof any/c))]))
  (define (search g n)
    (define (it g b l)
      (cond
        [(bag-empty? b) (reverse l)]
        [(has-node? g (bag-peek b))
         (it (remove-node g (bag-peek b))
             (foldl
              (lambda (n1 b1) (bag-insert b1 n1))
              (bag-remove b)
              (outnodes g (bag-peek b)))
             (cons (bag-peek b) l))]
        [else (it g (bag-remove b) l)]))
    (it g (bag-insert empty-bag n) '()))
  )

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))
(define test-graph-2
  (graph
   (list 1 2 3 4)
   (list (edge 1 2)
         (edge 3 4)
         (edge 4 2))))
(define test-graph-3
  (graph
   (list 'a 'b 'c 'd 'e)
   (list (edge 'a 'b)
         (edge 'b 'c)
         (edge 'c 'a)
         (edge 'd 'e)
         (edge 'e 'd))))

;; otwarcie komponentu stosu
; (define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki
 (define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol])
           (bag-empty? (bag-remove (bag-insert empty-bag s)))))

(quickcheck
 (property ([s arbitrary-symbol])
           (not (bag-empty? (bag-insert empty-bag s)))))

(quickcheck
 (property ([s arbitrary-symbol])
           (eq? s (bag-peek (bag-insert empty-bag s)))))

(quickcheck
 (property ([s arbitrary-symbol]
            [t arbitrary-symbol])
           ;; tylko stos
           ;(eq? t (bag-peek (bag-insert (bag-insert empty-bag s) t)))
           ;; tylko kolejka
           (eq? s (bag-peek (bag-insert (bag-insert empty-bag s) t))) 
           ))

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; uruchomienie przeszukiwania na przykładowym grafie
(search test-graph 1)
(search test-graph-2 3)
(search test-graph-3 'a)
(search test-graph-3 'd)
