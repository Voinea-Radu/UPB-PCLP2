# Tema 3

**Suricatele responsabile**
- Teodor Teugea
- Florin Postolache
- Radu Mantu
- Cristian Lazar
- Valentin-Razvan Bogdan

Dupa ce si-a facut atatia prieteni in cadrul temei 2, suricata Zoly
a efectuat un audit se securitate al retelelor clanurilor carora
s-a alaturat si si-a dat seama ca nu exista nicio masura adecvata
de securitate. Astfel, ea doreste sa isi creeze propriul sistem
de detectie si prevenire a intruziunilor in retea, si va
roaga sa o ajutati cu implementarea unor componente ale acestuia.

## Task 1

Sistemul se bazeaza pe anumite reguli care trebuie scrise in fisier.
Un aspect important al verificarii acestor reguli este parantezarea
diferitelor elemente ale regulii.

In acest task va trebui sa implementati o functie care verifica
daca un sir de paranteze formeaza o parantezare corecta, adica
daca toate parantezele deschise sunt inchise corespunator.

De exemplu, sirul "()()" este o parantezare corecta, dar
"{{}" nu este, pentru ca se inchide doar o paranteza,
si nici "{[}]" nu este, pentru ca parantezele nu sunt
inchise corespunzator.

Functia pe care o veti implementa va returna 0 daca nu sunt probleme
de parantezare (daca sunt parantezele puse bine) si 1 altfel.

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

În acest task veți implementa un algoritm cunoscut de la SDA de cautare pe grafuri, depth first search.

*Note:* implementarea trebuie să fie recursivă, NU iterativă.

Pentru acest task aveți de implementat funcția `dfs()` în fișierul `dfs.asm`.

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

Dfs-ul poate avea mai multe căutari valide, în funcție de ordinea în care alegem să vizităm vecinii. În cazul nostru, Celelalte posibilități de căutare ar fi {1, 3, 2, 4} și {1, 3, 4, 2}.

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
    .neighs resd 1      ; Vectorul cu `num_neighs` vecini.
endstruc
```

### Cerința

Vi se cere să implementați funcția `dfs()` din fișierul `dfs.asm`, care are următoarea semnătură:

```c
void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node));
```

Aceasta primește ca parametru nodul sursă și adresa funcției `expand` și se cere să implementați algoritmul de dfs și să printați nodurile în momentul în care le viziați.

Printarea se va realiza prin apelara funcției `printf`. Se depunctează folosirea macro-ului `PRINTF32`.


## Bonus

Acum ca Zoly si-a scris sistemul de detectie a intruziunilor
si isi poate apara toti prietenii pe care si i-a facut in tema 2,
se poate intoarce la marea ei pasiune: programarea functionala.

Totodata, spre deosebire de echipa de PCLP2, ea a inteles ca in
prezent se folosesc sisteme pe 64 de biti, iar cele pe 32 de biti
sunt foarte rare. Astfel, ea doreste sa implementeze functiile
`map` si `reduce` in assembly pe 64 de biti si folosin si numere
pe 64 de biti. Stiti de la
[tema 1](https://gitlab.cs.pub.ro/iocla/tema-1-2024) ce sunt fiecare.

## Map

Antet map:
```
void map(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t(*f)(int64_t));
```

Antet functie ce poate fi folosita pentru map:
```
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
```
int64_t reduce(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t accumulator_initial_value, int64_t(*f)(int64_t, int64_t));
```

Antet functie ce poate fi folosita pentru reduce:
```
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

