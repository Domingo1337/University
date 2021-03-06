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

;; reprezentacja danych wejściowych (z ćwiczeń)
(define (var? x)
  (symbol? x))

(define (var x)
  x)

(define (var-name x)
  x)

;; przydatne predykaty na zmiennych
(define (var<? x y)
  (symbol<? x y))

(define (var=? x y)
  (eq? x y))

(define (literal? x)
  (and (tagged-tuple? 'literal 3 x)
       (boolean? (cadr x))
       (var? (caddr x))))

(define (literal pol x)
  (list 'literal pol x))

(define (literal-pol x)
  (cadr x))

(define (literal-var x)
  (caddr x))

(define (clause? x)
  (and (tagged-list? 'clause x)
       (andmap literal? (cdr x))))

(define (clause . lits)
  (cons 'clause lits))

(define (clause-lits c)
  (cdr c))

(define (cnf? x)
  (and (tagged-list? 'cnf x)
       (andmap clause? (cdr x))))

(define (cnf . cs)
    (cons 'cnf cs))

(define (cnf-clauses x)
  (cdr x))

;; oblicza wartość formuły w CNF z częściowym wartościowaniem. jeśli zmienna nie jest
;; zwartościowana, literał jest uznawany za fałszywy.
(define (valuate-partial val form)
  (define (val-lit l)
    (let ((r (assoc (literal-var l) val)))
      (cond
       [(not r)  false]
       [(cadr r) (literal-pol l)]
       [else     (not (literal-pol l))])))
  (define (val-clause c)
    (ormap val-lit (clause-lits c)))
  (andmap val-clause (cnf-clauses form)))

;; reprezentacja dowodów sprzeczności

(define (axiom? p)
  (tagged-tuple? 'axiom 2 p))

(define (proof-axiom c)
  (list 'axiom c))

(define (axiom-clause p)
  (cadr p))

(define (res? p)
  (tagged-tuple? 'resolve 4 p))

(define (proof-res x pp pn)
  (list 'resolve x pp pn))

(define (res-var p)
  (cadr p))

(define (res-proof-pos p)
  (caddr p))

(define (res-proof-neg p)
  (cadddr p))

;; sprawdza strukturę, ale nie poprawność dowodu
(define (proof? p)
  (or (and (axiom? p)
           (clause? (axiom-clause p)))
      (and (res? p)
           (var? (res-var p))
           (proof? (res-proof-pos p))
           (proof? (res-proof-neg p)))))

;; procedura sprawdzająca poprawność dowodu
(define (check-proof pf form)
  (define (run-axiom c)
    (displayln (list 'checking 'axiom c))
    (and (member c (cnf-clauses form))
         (clause-lits c)))
  (define (run-res x cpos cneg)
    (displayln (list 'checking 'resolution 'of x 'for cpos 'and cneg))
    (and (findf (lambda (l) (and (literal-pol l)
                                 (eq? x (literal-var l))))
                cpos)
         (findf (lambda (l) (and (not (literal-pol l))
                                 (eq? x (literal-var l))))
                cneg)
         (append (remove* (list (literal true x))  cpos)
                 (remove* (list (literal false x)) cneg))))
  (define (run-proof pf)
    (cond
     [(axiom? pf) (run-axiom (axiom-clause pf))]
     [(res? pf)   (run-res (res-var pf)
                           (run-proof (res-proof-pos pf))
                           (run-proof (res-proof-neg pf)))]
     [else        false]))
  (null? (run-proof pf)))


;; reprezentacja wewnętrzna

;; sprawdza posortowanie w porządku ściśle rosnącym, bez duplikatów
(define (sorted? vs)
  (or (null? vs)
      (null? (cdr vs))
      (and (var<? (car vs) (cadr vs))
           (sorted? (cdr vs)))))

(define (sorted-varlist? x)
  (and (list? x)
       (andmap (var? x))
       (sorted? x)))

;; klauzulę reprezentujemy jako parę list — osobno wystąpienia pozytywne i negatywne. Dodatkowo
;; pamiętamy wyprowadzenie tej klauzuli (dowód) i jej rozmiar.
(define (res-clause? x)
  (and (tagged-tuple? 'res-int 5 x)
       (sorted-varlist? (second x))
       (sorted-varlist? (third x))
       (= (fourth x) (+ (length (second x)) (length (third x))))
       (proof? (fifth x))))

(define (res-clause pos neg proof)
  (list 'res-int pos neg (+ (length pos) (length neg)) proof))

(define (res-clause-pos c)
  (second c))

(define (res-clause-neg c)
  (third c))

(define (res-clause-size c)
  (fourth c))

(define (res-clause-proof c)
  (fifth c))

;; przedstawia klauzulę jako parę list zmiennych występujących odpowiednio pozytywnie i negatywnie
(define (print-res-clause c)
  (list (res-clause-pos c) (res-clause-neg c)))

;; sprawdzanie klauzuli sprzecznej
(define (clause-false? c)
  (and (null? (res-clause-pos c))
       (null? (res-clause-neg c))))

;; pomocnicze procedury: scalanie i usuwanie duplikatów z list posortowanych
(define (merge-vars xs ys)
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(var<? (car xs) (car ys))
         (cons (car xs) (merge-vars (cdr xs) ys))]
        [(var<? (car ys) (car xs))
         (cons (car ys) (merge-vars xs (cdr ys)))]
        [else (cons (car xs) (merge-vars (cdr xs) (cdr ys)))]))

(define (remove-duplicates-vars xs)
  (cond [(null? xs) xs]
        [(null? (cdr xs)) xs]
        [(var=? (car xs) (cadr xs)) (remove-duplicates-vars (cdr xs))]
        [else (cons (car xs) (remove-duplicates-vars (cdr xs)))]))

(define (rev-append xs ys)
  (if (null? xs) ys
      (rev-append (cdr xs) (cons (car xs) ys))))

;; funkcje pomocnicze
(define (first-shared xs ys)
  (cond [(null? xs) false]
        [(null? ys) false]
        [(var<? (car xs) (car ys)) (first-shared (cdr xs) ys)]
        [(var<? (car ys) (car xs)) (first-shared xs (cdr ys))]
        [else (car xs)]))

(define (easier? c1 c2)
  (define (contains? xs ys)
    (cond [(null? xs) true]
          [(null? ys) false]        
          [(var<? (car xs) (car ys))
           false]
          [(var<? (car ys) (car xs))
           (contains? xs (cdr ys))]
          [else (contains? (cdr xs) (cdr ys))]))
  (and (contains? (res-clause-pos c2) (res-clause-pos c1))
       (contains? (res-clause-neg c2) (res-clause-neg c1))))
;;;;;;;;

(define (clause-trivial? c)
  (first-shared (res-clause-pos c)
                (res-clause-neg c)))

(define (resolve c1 c2)
  (define (helper c1 c2)
    (let ((res (first-shared (res-clause-pos c1)
                             (res-clause-neg c2))))
      (and res
          (res-clause (remove res (merge-vars  (res-clause-pos c1)
                                               (res-clause-pos c2)))
                      (remove res (merge-vars  (res-clause-neg c1)
                                               (res-clause-neg c2)))
                      (proof-res  res
                                  (res-clause-proof c1)
                                  (res-clause-proof c2))))))
  (or (helper c1 c2)
      (helper c2 c1)))

(define (resolve-single-prove s-clause checked pending)
  (define (resolve-split resolved not-resolvable clauses)
    (if (null? clauses) (cons resolved not-resolvable)
        (let ((res (resolve (car clauses) s-clause)))
          (if res
              (resolve-split (cons res resolved) not-resolvable (cdr clauses))
              (resolve-split resolved (cons (car clauses) not-resolvable) (cdr clauses))))))
  (let ((clauses (resolve-split null null checked)))
    (subsume-add-prove (sort-clauses (cons s-clause (cdr clauses)))
                       pending
                       (sort-clauses (car clauses)))))

;; wstawianie klauzuli w posortowaną względem rozmiaru listę klauzul
(define (insert nc ncs)
  (cond
   [(null? ncs)                     (list nc)]
   [(< (res-clause-size nc)
       (res-clause-size (car ncs))) (cons nc ncs)]
   [else                            (cons (car ncs) (insert nc (cdr ncs)))]))

;; sortowanie klauzul względem rozmiaru (funkcja biblioteczna sort)
(define (sort-clauses cs)
  (sort cs < #:key res-clause-size))

;; główna procedura szukająca dowodu sprzeczności
;; zakładamy że w checked i pending nigdy nie ma klauzuli sprzecznej
(define (resolve-prove checked pending)
  (cond
   ;; jeśli lista pending jest pusta, to checked jest zamknięta na rezolucję czyli spełnialna
   [(null? pending) (generate-valuation (sort-clauses checked))]
   ;; jeśli klauzula ma jeden literał, to możemy traktować łatwo i efektywnie ją przetworzyć
   [(= 1 (res-clause-size (car pending)))
    (resolve-single-prove (car pending) checked (cdr pending))]
   ;; w przeciwnym wypadku wykonujemy rezolucję z wszystkimi klauzulami już sprawdzonymi, a
   ;; następnie dodajemy otrzymane klauzule do zbioru i kontynuujemy obliczenia
   [else
    (let* ((next-clause  (car pending))
           (rest-pending (cdr pending))
           (resolvents   (filter-map (lambda (c) (resolve c next-clause))
                                     checked))
           (sorted-rs    (sort-clauses resolvents)))
      (subsume-add-prove (cons next-clause checked) rest-pending sorted-rs))]))

;; procedura upraszczająca stan obliczeń biorąc pod uwagę świeżo wygenerowane klauzule i
;; kontynuująca obliczenia. Do uzupełnienia.
(define (subsume-add-prove checked pending new)
  (cond
   [(null? new)                 (resolve-prove checked pending)]
   ;; jeśli klauzula do przetworzenia jest sprzeczna to jej wyprowadzenie jest dowodem sprzeczności
   ;; początkowej formuły
   [(clause-false? (car new))   (list 'unsat (res-clause-proof (car new)))]
   ;; jeśli klauzula jest trywialna to nie ma potrzeby jej przetwarzać
   [(clause-trivial? (car new)) (subsume-add-prove checked pending (cdr new))]
   [(ormap (lambda (x) (easier? (car new) x)) checked) (subsume-add-prove checked pending (cdr new))]
   [(ormap (lambda (x) (easier? (car new) x)) pending) (subsume-add-prove checked pending (cdr new))]
   [else
    (subsume-add-prove (filter (lambda (x) (not (easier? x (car new)))) checked)
                       (insert (car new) (filter (lambda (x) (not (easier? x (car new))))pending))
                       (cdr new))
    ]))

(define (generate-valuation resolved)
  (define (shorten-pos var clauses)
    (map (lambda (c)
           (if (member var (res-clause-neg c))
               (res-clause (res-clause-pos c)
                           (remove var (res-clause-neg c))
                           null)
                c))
         (filter (lambda (c) (not (member var (res-clause-pos c)))) clauses)))
  (define (shorten-neg var clauses)
    (map (lambda (c)
           (if (member var (res-clause-pos c))
               (res-clause (remove var (res-clause-pos c))
                           (res-clause-neg c)
                           null)
               c))
         (filter (lambda (c) (not (member var (res-clause-neg c)))) clauses)))
  (define (iter clauses vals)
    (if (null? clauses)
        vals
        (let ((clause (car clauses))
              (rest (cdr clauses)))
          (cond [(not (null? (res-clause-pos clause)))
                 (iter (shorten-pos (car (res-clause-pos clause)) rest)
                       (cons (list (car (res-clause-pos clause)) #t) vals))]
                [(not (null? (res-clause-neg clause)))
                 (iter (shorten-neg (car (res-clause-neg clause)) rest)
                       (cons (list (car (res-clause-neg clause)) #f) vals))]
                [else (iter rest vals)]))))
  (cons 'sat (list (iter resolved null))))

;; procedura przetwarzające wejściowy CNF na wewnętrzną reprezentację klauzul
(define (form->clauses f)
  (define (conv-clause c)
    (define (aux ls pos neg)
      (cond
       [(null? ls)
        (res-clause (remove-duplicates-vars (sort pos var<?))
                    (remove-duplicates-vars (sort neg var<?))
                    (proof-axiom c))]
       [(literal-pol (car ls))
        (aux (cdr ls)
             (cons (literal-var (car ls)) pos)
             neg)]
       [else
        (aux (cdr ls)
             pos
             (cons (literal-var (car ls)) neg))]))
    (aux (clause-lits c) null null))
  (map conv-clause (cnf-clauses f)))

(define (prove form)
  (let* ((clauses (form->clauses form)))
    (subsume-add-prove '() '() clauses)))

;; procedura testująca: próbuje dowieść sprzeczność formuły i sprawdza czy wygenerowany
;; dowód/waluacja są poprawne. Uwaga: żeby działała dla formuł spełnialnych trzeba umieć wygenerować
;; poprawną waluację.
(define (prove-and-check form)
  (let* ((res (prove form))
         (sat (car res))
         (pf-val (cadr res)))
    (if (eq? sat 'sat)
        (valuate-partial pf-val form)
        (check-proof pf-val form))))

;; testy:
;; x1 = (p ∨ q) ∧ (¬p ∨ q) ∧ (p ∨ ¬q) ∧ (¬p ∨ ¬q)
(define x1 '(cnf (clause (literal #t p) (literal #t q))
                 (clause (literal #f p) (literal #t q))
                 (clause (literal #t p) (literal #f q))
                 (clause (literal #f p) (literal #f q))))
;; x2 = (p ∨ q ∨ r) ∧ (¬r ∨ ¬q ∨ ¬p) ∧ (¬q ∨ r) ∧ (¬r ∨ p)
(define x2 '(cnf (clause (literal #t p) (literal #t q) (literal #t r))
                 (clause (literal #f p) (literal #f q) (literal #f r))
                 (clause (literal #f q) (literal #t r))
                 (clause (literal #t p) (literal #f r))))
;; x3 = p ∧ (q ∨ r) ∧ (¬p ∨ q ∨ r ∨ s) ∧ (p ∨ ¬q ∨ s )
(define x3 '(cnf (clause (literal #t p))
                 (clause (literal #t q) (literal #t r))
                 (clause (literal #f p) (literal #t q) (literal #t r) (literal #t s))
                 (clause (literal #t p) (literal #f q) (literal #t s))))
;; x4 = p ∧ ¬p
(define x4 '(cnf (clause (literal #f p)) (clause (literal #t p))))
;; x5 = ¬p ∧ p
(define x5 '(cnf (clause (literal #t p)) (clause (literal #f p))))

(display "Testing: ") x1
(display "Result: ") (prove x1)
(display "Proof-check: ") (prove-and-check x1)
(newline)
(display "Testing: ") x2
(display "Result: ") (prove x2)
(display "Proof-check: ") (prove-and-check x2)
(newline)
(display "Testing: ") x3
(display "Result: ") (prove x3)
(display "Proof-check: ") (prove-and-check x3)
(newline)
(display "Testing: ") x4
(display "Result: ") (prove x4)
(display "Proof-check: ") (prove-and-check x4)
(newline)
(display "Testing: ") x5
(display "Result: ") (prove x5)
(display "Proof-check: ") (prove-and-check x5)
