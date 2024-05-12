# Tema 3

**Suricatele responsabile**
- Teodor Teugea
- Florin Postolache
- Radu Mantu
- Cristian Lazar
- Valentin-Razvan Bogdan

După ce și-a făcut atâția prieteni în cadrul temei 2, suricata Zoly 
a efectuat un audit se securitate al rețelelor clanurilor cărora 
s-a alăturat și și-a dat seama că nu există nicio măsură adecvată
de securitate. Astfel, ea dorește să își creeze propriul sistem
de detecție si prevenire a intruziunilor in rețea, si vă
roagă să o ajutați cu implementarea unor componente ale acestuia.

## Task 1

Sistemul se bazează pe anumite reguli care trebuie scrise intr-un
fișier de configurare.
Un aspect important al verificării acestor reguli este parantezarea
diferitelor elemente ale regulii.

În acest task va trebui să implementați o funcție care verifică
dacă un șir de paranteze formează o parantezare corectă, adică
dacă toate parantezele deschise sunt inchise corespunzător.

De exemplu, șirul "()()" este o parantezare corectă, dar
"{{}" nu este, pentru ca se închide doar o paranteză,
și nici "{[}]" nu este, pentru că parantezele nu sunt
închise corespunzător.

Funcția pe care o veți implementa va returna 0 daca nu sunt probleme
de parantezare (dacă sunt parantezele puse bine) si 1 altfel.

## Task 2 - Divide et impera

În acest task veți implementa doi algoritmi bine cunoscuți (sperăm noi):
*quick sort* și *binary search*.

*Note:* ambele implementări trebuie să fie recursive, NU iterative.

Pentru a rula toate testele, rulați executabilul generat fară niciun
argument. Pentru a rula un singur test, pasati unul dintre keyword-urile
`qsort` și `bsearch` ca prim argument, urmat de numărul testului.
De exemplu:

```bash
# rulează toate testele
$ ./checker

# tulează un singur test
$ ./checker qsort 3
$ ./checker bsearch 10
```

---

### Exercițiul 1

Pentru acest exercițiu aveți de implementat funcția `quick_sort()` în fișierul
`subtask_1.asm`.

Această funcție are semnătura de mai jos. În urma rulării ei, numerele stocate
în `buff` vor fi sortate crescător. `start` și `end` reprezintă indexul
primului, respectiv ultimului element (începând de la 0).

```c
void quick_sort(int32_t *buff, uint32_t start, uint32_t end);
```

---

### Exercițiul 2

În acest exercițiu va trebui sa implementați funcția `binary_search()` în
fișierul `subtask_2.asm`.

Această funcție va returna poziția elementului `needle` in cadrul array-ului
`buff`. Căutarea va avea loc între elementele indexate `start` și `end`
(inclusiv). Dacă `needle` nu se găsește în `buff`, funcția va returna `-1`.
Este garantat faptul că elementele din `buff` sunt sortate crescător.

Observați în cadrul semnăturii funcției atributul
[fastcall](https://gcc.gnu.org/onlinedocs/gcc-4.7.0/gcc/Function-Attributes.html).
Acesta va modifica calling convention-ul utilizat in `check.c`. Țineți cont de
acest lucru când implementați funcția (și când faceți apelurile recursive).

```c
int32_t __attribute__((fastcall))
binary_search(int32_t *buff, uint32_t needle, uint32_t start, uint32_t end);
```

## Task 3 - Depth first search

Pentru ca Zoly să verifice că drumul pe care e transmis un pachet este legitim, se va realiza o cautare in topologia rețelei. Protocolul de comunicație garantează trimiterea pachetelor folosind algoritmul de căutare în adâncime. Astfel, știind sursa pachetului, putem găsi calea legitimă către toate celelalte gazde din rețea.

În acest task veți implementa algoritmul cunoscut de la SDA de cautare pe grafuri, depth first search.

### Algoritmul dfs

Precum sunteți deja familiari, depth first search implică cautare în adâncime pe grafuri, pornind de la un nod sursă dat. Algoritmul marchează nodul inițial ca fiind visitat și se aplică recursiv pe toți vecini lui. Algoritmul va continua, evitând nodurile marcate ca vizitate.

Luăm graful următor ca exemplu:

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Directed_graph_no_background.svg/1280px-Directed_graph_no_background.svg.png" alt="err" width="300"/>

Dacă nodul sursă este 1, atunci o posibilă cautare dfs ar fi urmatoarea:

* Nodul 1 este vizitat.
* Nodul 2 este vizitat.
* Nodul 2 nu are vecini, ne întoarcem la nodul 1.
* Nodul 3 este vizitat.
* Nodul 2 a fost deja vizitat, vizitam nodul 4.
* Nodul 3 a fost deja vizitat, iar nodul 4 nu mai are vecini, deci ne întoarcem la nodul 3.
* Nodul 3 nu mai are vecini, ne întoarcem la nodul 1.
* Nodul 1 nu mai are vecini, se încheie căutarea.

Dfs-ul poate avea mai multe căutari valide, în funcție de ordinea în care alegem să vizităm vecinii. În cazul nostru, celelalte posibilități de căutare ar fi {1, 3, 2, 4} și {1, 3, 4, 2}.

### API

În cadrul task-ului, nodurile sunt reprezentate sub forma unui id de tip `uint32_t` (unsigned int).
Pentru a obține vecinii unui nod, se apelează funcția `expand` cu următoarea semnătură:

```c
neighbours_t expand(uint32_t node);
```

Aceasta returnează **adresa** unei structuri care conține vecinii nodului în felul următor:

```x86asm
struc neighbours_t
    .num_neighs resd 1  ; Numărul de vecini.
    .neighs resd 1      ; Adresa vectorul cu `num_neighs` vecini.
endstruc
```

### Cerința

Vi se cere să implementați funcția `dfs()` din fișierul `dfs.asm`, care are următoarea semnătură:

```c
void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node));
```

Aceasta primește ca parametru nodul sursă și adresa funcției `expand` și se cere să implementați algoritmul de dfs și să printați nodurile în momentul în care le viziați.

Printarea se va realiza prin apelara funcției `printf`. Se depunctează folosirea macro-ului `PRINTF32`.
Implementarea trebuie să fie recursivă, **NU** iterativă.

## Bonus

Acum ca Zoly și-a scris sistemul de detecție a intruziunilor
și își poate apăra toți prietenii pe care și i-a facut în tema 2,
se poate întoarce la marea ei pasiune: programarea funcțională.

Totodată, spre deosebire de echipa de PCLP2, ea a înțeles că în
prezent se folosesc sisteme pe 64 de biți, iar cele pe 32 de biți
sunt foarte rare. Astfel, ea dorește să implementeze funcțiile
`map` și `reduce` în assembly pe 64 de biți si folosim și numere
pe 64 de biți. Stiți de la
[tema 1](https://gitlab.cs.pub.ro/iocla/tema-1-2024) ce sunt fiecare.

## Map

Antet map:
```c
void map(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t(*f)(int64_t));
```

Antet functie ce poate fi folosita pentru map:
```c
int64_t map_func1(int64_t curr_elem);
```

Pseudocod map:
```
map(dst, src, n, to_apply):
	for i de la 0 la n:
		dst[i] = to_apply(src[i])
```

## Reduce

Antet reduce:
```c
int64_t reduce(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t accumulator_initial_value, int64_t(*f)(int64_t, int64_t));
```

Antet functie ce poate fi folosita pentru reduce:
```c
int64_t reduce_func1(int64_t accumulator, int64_t current_elem);
```

Pseudocod reduce:
```
reduce(src, n, accumulator_initial, to_apply):
	acc = accumulator_initial
	for i de la 0 la n:
		acc = to_apply(acc, src[i])
	return acc
```

