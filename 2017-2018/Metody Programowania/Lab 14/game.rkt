#lang racket

;;; ---------------------------------------------------------------------------
;;; Prosty system obiektowy z dziedziczeniem

(define (ask object message . args)
  (let ((method (get-method object message)))
    (if (method? method)
	(apply method (cons object args))
	(error "Brak metody" message (cadr method)))))

(define (get-method object message)
  (object message))

(define (no-method name)
  (list 'no-method name))

(define (method? x)
  (not (no-method? x)))

(define (no-method? x)
  (if (pair? x)
      (eq? (car x) 'no-method)
      false))

;;; ----------------------------------------------------------------------------
;;; Osoby, miejsca i rzeczy są nazwanymi obiektami

(define (make-named-object name)
  (lambda (message) 
    (cond ((eq? message 'name) (lambda (self) name))
	  (else (no-method name)))))

;;; Osoby i rzeczy są mobilne, ich miejsce może ulec zmianie

(define (make-mobile-object name location)
  (let ((named-obj (make-named-object name)))
    (lambda (message)
      (cond ((eq? message 'place)    (lambda (self) location))
	    ((eq? message 'install)
	     (lambda (self)
	       (ask location 'add-thing self)))
	    ;; Poniższa metoda nie powinna być wołana przez użytkownika
	    ;; Zobacz change-place
	    ((eq? message 'set-place)
	     (lambda (self new-place)
	       (set! location new-place)
	       'place-set))
	    (else (get-method named-obj message))))))

(define (make&install-mobile-object name place)
  (let ((mobile-obj (make-mobile-object name place)))
    (ask mobile-obj 'install)
    mobile-obj))

;;; Rzecz to coś, co może mieć właściciela

(define (make-thing name birthplace)
  (let ((owner     'nobody)
	(mobile-obj (make-mobile-object name birthplace)))
    (lambda (message)
      (cond ((eq? message 'owner)    (lambda (self) owner))
	    ((eq? message 'ownable?) (lambda (self) true))
	    ((eq? message 'owned?)
	     (lambda (self)
	       (not (eq? owner 'nobody))))
	    ;; Poniższa metoda nie powinna być wołana przez użytkownika
	    ;; Zobacz take i lose
	    ((eq? message 'set-owner)
	     (lambda (self new-owner)
	       (set! owner new-owner)
	       'owner-set))
	    (else (get-method mobile-obj message))))))

(define (make&install-thing name birthplace)	
  (let ((thing  (make-thing name birthplace)))
    (ask thing 'install)
    thing))

;;; Implementacja miejsc

(define (make-place name)
  (let ((neighbor-map '())		
	(things       '())
	(named-obj (make-named-object name)))
    (lambda (message)
      (cond ((eq? message 'things) (lambda (self) things))
	    ((eq? message 'neighbors)
	     (lambda (self) (map cdr neighbor-map)))
	    ((eq? message 'exits)
	     (lambda (self) (map car neighbor-map)))
	    ((eq? message 'neighbor-towards)
	     (lambda (self direction)
	       (let ((places (assq direction neighbor-map)))
		 (if places
		     (cdr places)
		     false))))
            ((eq? message 'add-neighbor)
             (lambda (self direction new-neighbor)
               (cond ((assq direction neighbor-map)
                      (display-message (list "Kierunek już przypisany"
					      direction name))
		      false)
                     (else
                      (set! neighbor-map
                            (cons (cons direction new-neighbor) neighbor-map))
		      true))))
	    ((eq? message 'accept-person?)
	     (lambda (self person)
	       true))
 
	    ;; Poniższe metody nie powinny być wołane przez użytkownika
	    ;; Zobacz change-place
            ((eq? message 'add-thing)
             (lambda (self new-thing)
               (cond ((memq new-thing things)
                      (display-message (list (ask new-thing 'name)
					     "już jest w" name))
		      false)
                     (else (set! things (cons new-thing things))
			   true))))
            ((eq? message 'del-thing)
             (lambda (self thing)
               (cond ((not (memq thing things))
                      (display-message (list (ask thing 'name)
					     "nie jest w" name))
		      false)
                     (else (set! things (delq thing things))
			   true))))

            (else (get-method named-obj message))))))

;;; ----------------------------------------------------------------------------
;;; Implementacja osób
;; funkcja pomocnicza
(define (cons-n n sym list)
  (if (< n 1) list
      (cons sym (cons-n (- n 1) sym list))))

(define (make-person name birthplace threshold [affection 0])
  (let ((possessions '())
	(mobile-obj  (make-mobile-object name birthplace)))
    (lambda (message)
      (cond ((eq? message 'person?)     (lambda (self) true))
	    ((eq? message 'possessions) (lambda (self) possessions))
	    ((eq? message 'list-possessions)
	     (lambda (self)
	       (ask self 'say
		    (cons "Mam"
			  (if (null? possessions)
			      '("nic")
			      (map (lambda (p) (ask p 'name))
				      possessions))))
	       possessions))
            ((eq? message 'print-affection)
             (lambda (self)
               (if (< affection 3) null (display "Brawo, udało ci się uwieść "))
               (for-each (lambda (s) (display s) (display " "))
                         (cons (ask self 'name)
                               (cons ':
                                     (if (< affection 0) (list '💔)
                                         (cons-n affection '🖤 '())))))
               (newline)))
	    ((eq? message 'say)
	     (lambda (self list-of-stuff)
	       (display-message
		 (append (list "W miejscu" (ask (ask self 'place) 'name)
			       ":"  name "mówi --")
			 (if (null? list-of-stuff)
			     '("Nieważne.")
			     list-of-stuff)))
	       'said))
	    ((eq? message 'have-fit)
	     (lambda (self)
	       (ask self 'say '("Bardzo proszę."))
	       'I-feel-better-now))
	    ((eq? message 'look-around)
	     (lambda (self)
	       (let ((other-things
		       (map (lambda (thing) (ask thing 'name))
                               (delq self
                                     (ask (ask self 'place)
                                          'things)))))
                 (ask self 'say (cons "Widzę" (if (null? other-things)
						  '("nic")
						  other-things)))
		 other-things)))
            ((eq? message 'give)
             (lambda (self thing)
               (if (and 
                    (let ((things-at-place (ask (ask self 'place) 'things)))
                      (memq thing things-at-place))
                    (ask thing 'owned?)
                    (eq? (ask (ask thing 'owner) 'name) 'student))
                   (and (set! affection (+ 1 affection))
                        (ask self 'take thing)
                        (newline)
                        (ask self 'print-affection)
                        #t)
                   (and (ask self 'say (list "Nie możesz mi dać"
                                             (ask thing 'name)))
                        #f))))
            ((eq? message 'take)
	     (lambda (self thing)
	       (cond ((memq thing possessions)
		      (ask self 'say
			   (list "Już mam" (ask thing 'name)))
		      true)
		     ((and (let ((things-at-place (ask (ask self 'place) 'things)))
			     (memq thing things-at-place))
			   (is-a thing 'ownable?))
		      (if (ask thing 'owned?)
			  (let ((owner (ask thing 'owner)))
			    (ask owner 'lose thing)
			    (ask owner 'have-fit))
			  'unowned)

		      (ask thing 'set-owner self)
		      (set! possessions (cons thing possessions))
		      (ask self 'say
			   (list "Biorę" (ask thing 'name)))
		      true)
		     (else
		      (display-message
		       (list "Nie możesz wziąć" (ask thing 'name)))
		      false))))
	    ((eq? message 'lose)
	     (lambda (self thing)
	       (cond ((eq? self (ask thing 'owner))
		      (set! possessions (delq thing possessions))
		      (ask thing 'set-owner 'nobody) 
		      (ask self 'say
			   (list "Tracę" (ask thing 'name)))
		      true)
		     (else
		      (display-message (list name "nie ma"
					     (ask thing 'name)))
		      false))))
	    ((eq? message 'move)
	     (lambda (self)
               (cond ((and (> threshold 0) (= (random threshold) 0))
		      (ask self 'act)
		      true))))
	    ((eq? message 'act)
	     (lambda (self)
	       (let ((new-place (random-neighbor (ask self 'place))))
		 (if new-place
		     (ask self 'move-to new-place)
		     false))))

	    ((eq? message 'move-to)
	     (lambda (self new-place)
	       (let ((old-place (ask self 'place)))
		 (cond ((eq? new-place old-place)
			(display-message (list name "już jest w"
					       (ask new-place 'name)))
			false)
		       ((ask new-place 'accept-person? self)
			(change-place self new-place)
			(for-each (lambda (p) (change-place p new-place))
				  possessions)
			(display-message
			  (list name "idzie z"    (ask old-place 'name)
				     "do"         (ask new-place 'name)))
			(greet-people self (other-people-at-place self new-place))
			true)
		       (else
			(display-message (list name "nie może iść do"
					       (ask new-place 'name))))))))
	    ((eq? message 'go)
	     (lambda (self direction)
	       (let ((old-place (ask self 'place)))
		 (let ((new-place (ask old-place 'neighbor-towards direction)))
		   (cond (new-place
			  (ask self 'move-to new-place))
			 (else
			  (display-message (list "Nie możesz pójść" direction
						 "z" (ask old-place 'name)))
			  false))))))
	    ((eq? message 'install)
	     (lambda (self)
	       (add-to-clock-list self)
	       ((get-method mobile-obj 'install) self)))
	    (else (get-method mobile-obj message))))))
  
(define (make&install-person name birthplace threshold [affection 0])
  (let ((person (make-person name birthplace threshold affection)))
    (ask person 'install)
    person))

;;; Łazik umie sam podnosić rzeczy

(define (make-rover name birthplace threshold)
  (let ((person (make-person name birthplace threshold)))
    (lambda (message)
      (cond ((eq? message 'act)
	     (lambda (self)
	       (let ((possessions (ask self 'possessions)))
                 (if (null? possessions)
                     (ask self 'grab-something)
                     (ask self 'lose (car possessions))))))
            ((eq? message 'grab-something)
	     (lambda (self)
	       (let* ((things (ask (ask self 'place) 'things))
                      (fthings
                       (filter (lambda (thing) (is-a thing 'ownable?))
                               things)))
		 (if (not (null? fthings))
		     (ask self 'take (pick-random fthings))
		     false))))
	    ((eq? message 'move-arm)
	     (lambda (self)
               (display-message (list name "rusza manipulatorem"))
	       '*bzzzzz*))
	    (else (get-method person message))))))

(define (make&install-rover name birthplace threshold)
  (let ((rover  (make-rover name birthplace threshold)))
    (ask rover 'install)
    rover))

;; TODO: nowe rodzaje przedmiotów lub postaci

;;; --------------------------------------------------------------------------
;;; Obsługa zegara

(define *clock-list* '())
(define *the-time* 0)

(define (initialize-clock-list)
  (set! *clock-list* '())
  'initialized)

(define (add-to-clock-list person)
  (set! *clock-list* (cons person *clock-list*))
  'added)

(define (remove-from-clock-list person)
  (set! *clock-list* (delq person *clock-list*))
  'removed)

(define (clock)
  (newline)
  (display "---Tick---")
  (set! *the-time* (+ *the-time* 1))
  (for-each (lambda (person) (ask person 'move))
	    *clock-list*)
  'tick-tock)
	     

(define (current-time)
  *the-time*)

(define (run-clock n)
  (cond ((zero? n) 'done)
	(else (clock)
	      (run-clock (- n 1)))))

;;; --------------------------------------------------------------------------
;;; Różne procedury

(define (is-a object property)
  (let ((method (get-method object property)))
    (if (method? method)
	(ask object property)
	false)))

(define (change-place mobile-object new-place)
  (let ((old-place (ask mobile-object 'place)))
    (ask mobile-object 'set-place new-place)
    (ask old-place 'del-thing mobile-object))
  (ask new-place 'add-thing mobile-object)
  'place-changed)

(define (other-people-at-place person place)
  (filter (lambda (object)
	    (if (not (eq? object person))
		(is-a object 'person?)
		false))
	  (ask place 'things)))

(define (greet-people person people)
  (if (not (null? people))
      (ask person 'say
	   (cons "Cześć"
		 (map (lambda (p) (ask p 'name))
			 people)))
      'sure-is-lonely-in-here))

(define (display-message list-of-stuff)
  (newline)
  (for-each (lambda (s) (display s) (display " "))
	    list-of-stuff)
  'message-displayed)

(define (random-neighbor place)
  (pick-random (ask place 'neighbors)))

(define (filter predicate lst)
  (cond ((null? lst) '())
	((predicate (car lst))
	 (cons (car lst) (filter predicate (cdr lst))))
	(else (filter predicate (cdr lst)))))

(define (pick-random lst)
  (if (null? lst)
      false
      (list-ref lst (random (length lst)))))  ;; See manual for LIST-REF

(define (delq item lst)
  (cond ((null? lst) '())
	((eq? item (car lst)) (delq item (cdr lst)))
	(else (cons (car lst) (delq item (cdr lst))))))

;;------------------------------------------
;; Od tego miejsca zaczyna się kod świata

(initialize-clock-list)

;; Tu definiujemy miejsca w naszym świecie
;;------------------------------------------

(define hol              (make-place 'hol))
(define piętro-wschód    (make-place 'piętro-wschód))
(define piętro-zachód    (make-place 'piętro-zachód))
(define ksi              (make-place 'ksi))
(define continuum        (make-place 'continuum))
(define plastyczna       (make-place 'plastyczna))
(define wielka-wschodnia (make-place 'wielka-wschodnia))
(define wielka-zachodnia (make-place 'wielka-zachodnia))
(define kameralna-wschodnia (make-place 'kameralna-wschodnia))
(define kameralna-zachodnia (make-place 'kameralna-zachodnia))
(define schody-parter    (make-place 'schody-parter))
(define schody-piętro    (make-place 'schody-piętro))

;; nowe lokacje
(define nadodrze (make-place 'nadodrze))
(define dziekanat (make-place 'dziekanat))
(define uniradio (make-place 'uni-radio))

;; Połączenia między miejscami w świecie
;;------------------------------------------------------

(define (can-go from direction to)
  (ask from 'add-neighbor direction to))

(define (can-go-both-ways from direction reverse-direction to)
  (can-go from direction to)
  (can-go to reverse-direction from))

(can-go-both-ways schody-parter 'góra 'dół schody-piętro)
(can-go-both-ways hol 'zachód 'wschód wielka-zachodnia)
(can-go-both-ways hol 'wschód 'zachód wielka-wschodnia)
(can-go-both-ways hol 'południe 'północ schody-parter)
(can-go-both-ways piętro-wschód 'południe 'wschód schody-piętro)
(can-go-both-ways piętro-zachód 'południe 'zachód schody-piętro)
(can-go-both-ways piętro-wschód 'zachód 'wschód piętro-zachód)
(can-go-both-ways piętro-zachód 'północ 'południe kameralna-zachodnia)
(can-go-both-ways piętro-wschód 'północ 'południe kameralna-wschodnia)
(can-go-both-ways schody-parter 'wschód 'zachód plastyczna)
(can-go-both-ways hol 'północ 'południe ksi)
(can-go-both-ways piętro-zachód 'zachód 'wschód continuum)

;; połączenia dla nowych lokacji
(can-go-both-ways wielka-wschodnia 'południe 'północ dziekanat)
(can-go-both-ways plastyczna 'południe 'północ nadodrze)
(can-go-both-ways uniradio 'północ 'południe schody-piętro)

;; Osoby dramatu
;;---------------------------------------

(define student   (make&install-person 'student hol 0))
(define fsieczkowski (make&install-person 'fsieczkowski wielka-wschodnia 3 1))
(define mpirog    (make&install-person 'mpirog wielka-wschodnia 3))
(define mmaterzok (make&install-person 'mmaterzok wielka-wschodnia 3))
(define jma       (make&install-person 'jma piętro-wschód 2 -99))
(define klo       (make&install-person 'klo kameralna-wschodnia 2 -99))
(define ref       (make&install-person 'ref ksi 0))
(define aleph1    (make&install-rover 'aleph1 continuum 3))

(define słój-pacholskiego (make&install-thing 'słój-pacholskiego schody-piętro))
(define trytytki     (make&install-thing 'trytytki continuum))
(define cążki-boczne (make&install-thing 'cążki-boczne continuum))

;; dodatkowe osoby i przedmioty
(define twi               (make&install-person 'twi kameralna-wschodnia 0 -99))
(define dziennikarka      (make&install-person 'dziennikarka kameralna-zachodnia 1 2))
(define dziennikarz       (make&install-person 'dziennikarz uniradio 2))
(define studentka         (make&install-person 'studentka plastyczna 3 1))
(define pani-z-dziekanatu (make&install-person 'pani-z-dziekanatu dziekanat 0 1))

(define mio-mio-mate       (make&install-thing 'mio-mio-mate plastyczna))
(define kwiaty             (make&install-thing 'kwiaty nadodrze))
(define kanapka            (make&install-thing 'kanapka wielka-wschodnia))
(define czekolada          (make&install-thing 'czekolada kameralna-wschodnia))
(define kawa               (make&install-thing 'kawa kameralna-zachodnia))
(define indeks             (make&install-thing 'indeks dziekanat))
(define piosenka-o-miłości (make&install-thing 'piosenka-o-miłości uniradio))
;; Polecenia dla gracza
;;------------------------------------------------

(define *player-character* student)

(define (look-around)
  (ask *player-character* 'look-around)
  #t)
(define (go direction)
  (ask *player-character* 'go direction)
  (clock)
  #t)

(define (exits)
  (display-message (ask (ask *player-character* 'place) 'exits))
  #t)

;; dodatkowe polecenia dla gracza

(define (grab)
  (let* ((things (ask (ask *player-character* 'place) 'things))
         (fthings (filter (lambda (thing) (not (ask thing 'owned?)))
                          (filter (lambda (thing) (is-a thing 'ownable?))
                                  things))))
    (if (not (null? fthings))
        (and (ask *player-character* 'take (pick-random fthings))
             (clock))
        false)))
(define (check-inventory)
  (ask *player-character* 'list-possessions))
(define (give person thing)
  (ask person 'give thing))
(define (show-stats)
  (let ((people (list fsieczkowski mpirog mmaterzok jma klo ref aleph1
                      twi dziennikarka dziennikarz studentka pani-z-dziekanatu)))
    (and (map (lambda (person) (not (ask person 'print-affection))) people))
    (display "")))

(display "Cel gry: znaleźć co najmniej jedną drugą połówkę")
