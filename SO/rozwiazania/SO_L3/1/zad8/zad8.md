### Zadanie 8

> Zapoznaj się z poleceniami strace i ltrace.
> Uruchom wybrany program w trybie śledzenia wywołań systemowych i wywołań
bibliotecznych.
> Podłącz się do wybranego procesu i obserwuj jego działanie.
> Jak śledzić aplikacje złożone z wielu procesów lub wątków?
> Jak zliczyć ilość wywołań systemowych, które wykonał proces w trakcie swego
wykonania?
> Jak obserwować wyłącznie pewien podzbiór wywołań systemowych, np. open,
read i write?

##### Manuale
* `man strace`
* `man ltrace`

Wielowątkowe/wieloprocesorowe aplikacje śledzimy z flagą -f.

Zliczać możemy z flagą -c (tylko zliczania na koniec)
lub -C (zliczanie dodatkowo).

Filtry robimy flagą -e z różnymi parametrami.
Np. `sudo strace -e trace=poll,recvmsg -C -p PID`

Najlepiej pokazać działanie tych narzędzi na shellu.
Gdy odpalimy ls to też odpali się nam nowy proces.
