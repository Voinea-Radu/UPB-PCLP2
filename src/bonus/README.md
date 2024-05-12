# Bonus - x64 assembly

Acum ca Zoly si-a scris sistemul de detectie a intruziunilor
si isi poate apara toti prietenii pe care si i-a facut in tema 2,
se poate intoarce la marea ei pasiune: programarea functionala.

Totodata, spre deosebire de echipa de PCLP2, ea a inteles ca in
prezent se folosesc sisteme pe 64 de biti, iar cele pe 32 de biti
sunt foarte rare. Astfel, ea doreste sa implementeze functiile
`map` si `reduce` in assembly pe 64 de biti si folosin si numere
pe 64 de biti. Stiti de la
(tema 1)[https://gitlab.cs.pub.ro/iocla/tema-1-2024] ce sunt fiecare.

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
int64_t fold(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t accumulator_initial_value, int64_t(*f)(int64_t, int64_t));
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
```
