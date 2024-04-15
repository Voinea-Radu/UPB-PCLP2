## Task 1 - Permissions

Pentru a strânge niște bani de buzunar și de călătorie, Zoly a acceptat un job la negru de la vecinele sale furnicile.

<div align="center">
    <img title="IDS" alt="IDS" src="../images/suricata-task-1.webp" width="300" height="300">
</div>

Job-ul constă în crearea unei funcții care verifică dacă o anumită furnică-angajat are voie să rezerve sălile din mușuroi pe care le dorește.
Funcția va returna `0` dacă furnica cu id-ul `i` nu are voie să rezerve una sau mai multe din sălile pe care le dorește, respectiv `1` dacă aceasta poate rezerva toate sălile cerute.

Mușuroiul are 24 de săli, numerotate de la 1 la 24.

Pentru a-i ușura treaba lui Zoly, furnica-arhitect i-a dat o listă în care se specifică sălile pe care fiecare furnică-angajat le poate rezerva.
Lista este reprezentată de vectorul global de întregi `employee_permissions[]`, aflat în `constants.h`. Acesta poate fi accesat și din fișierul `check_permission.asm` cu ajutorul label-ului `employee_permissions`.
Elementul de la poziția `i` reprezintă lista de săli pe care furnica cu id-ul `i` le poate accesa.
Atunci când bitul `j` are valoarea `1` în elementul de la poziția `i`, furnica cu id-ul `i` poate accesa sala `j + 1`. 

**Observație** Din moment ce avem doar 24 de săli, asta înseamnă că cei mai semnificativi 8 biți ai fiecărui element din `employee_permissions[]` vor fi mereu 0.

Funcția pe care Zoly trebuie să o implementeze primește doi parametri. 
Primul argument este un număr pe 32 de biți. 
Primii 8 cei mai semnificativi biți din cadrul numărului reprezintă identificatorul `i` al furnicii.
Restul de 24 de biți au următoarea semnificație: bitul `j` ne spune dacă furnica `i` dorește să rezerve sala `j + 1`.
O furnică poate cere să rezerve mai multe săli simultan.
Funcția returnează rezultatul verificării în cel de-al doilea argument (0 sau 1)
Funcția trebuie completată în cadrul fișierului `check_permission.asm`.

Mai jos este un exemplu de input:

<div align="center">
    <img title="IDS" alt="IDS" src="../images/Schema_task1.png" >
</div>

Antetul funcției este următorul:
```c
void check_permission(unsigned int n, unsigned int* res);
```

Semnificația argumentelor este:
- **n**: numărul ce înglobează ID furnică și listă săli cerute
- **res**: adresa variabilei in care se scrie rezultatul verificării