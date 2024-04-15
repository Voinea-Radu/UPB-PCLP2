## Task 2 - Requests

Pentru a intra în tribul lui, ratonul inginer îi cere lui Zoly să implementeze un sistem de login.

<div align="center">
    <img title="IDS" alt="IDS" src="../images/racoon.webp" width="300" height="300">
</div>

Se dau structurile simplificate ale unui login request:

```c
    struct creds {
        unsigned short passkey;
        char username[51];
    };

    struct request {
        unsigned char admin;
        unsigned char prio;
        struct creds login_creds;
    };
```

### Exercitiul 1

Pentru aceasta parte a task-ului, aveti de implementat functia `sort_requests()` in fisierul *subtask1.asm*.
Această funcție va simula sortarea tuturor request-urilor de login.

Pentru a intelege mai bine cum functioneaza un login request, vom explica mai jos ce inseamna fiecare field ale structurilor:

- `admin` ne spune daca request-ul e facut de un admin
- `prio` reprezinta prioritatea pe care o poate avea un request
- `creds` reprezinta o structura de tip creds
- `passkey` reprezinta passkey-ul necesar ca login-ul sa fie realizat
- `username` reprezinta un string de identificare unic pentru fiecare request

Pentru a sorta request-urile, stabilim urmatoarele reguli:

- Request-urile trebuie sa fie sortate astfel incat request-urile facute de admini sa fie primele.
- Request-urile trebuie sortate dupa prioritate, prioritatea mai mica ca numar e mai "mare".
- Request-urile cu aceeasi prioritate trebuie apoi sortate alfabetic dupa username.

Sortarea se va face **in place**, adica vectorul `requests` prezentat mai jos va trebui, in urma apelului functiei, sa fie sortat. Antetul functiei este:

```c
void sort_requests(struct request *requests, int len);
```

Semnificatia argumentelor este:

- **requests** adresa de inceput a vectorului de request-uri
- **len** numarul de request-uri

**Atentie!** Nu puteti folosi functii externe pentru a sorta vectorul sau pentru a compara username-urile.


### Exercitiul 2

In continuarea exercitiului 1, acum trebuie sa implementati functia `check_passkeys()` in fisierul *subtask2.asm*. Această funcție va verifica daca passkey-ul din interiorul request-ului este unul corect.
Suricata Zoly s-a prins de faptul ca exista si niste hackeri care vor sa sparga sistemul, dar si de metoda
prin care vor sa pacaleasca login-ul. Acestia seteaza mereu primul bit si ultimul bit, iar pentru cei 14
biti ramasi in passkey fac urmatoarele lucruri:

- pentru cei mai putin semmnificativi 7 biti: numar par de biti de 1
- pentru cei mai semmnificativi 7 biti: numar impar de biti de 1

Exemplu:

```
    1000 1110 0110 0001 => hacker
```

Va trebui sa puneti valorile obtinute in vectorul `connected` prezentat mai jos. Veți pune 0 pentru
request-urile care nu sunt facute de hackeri, 1 altfel. Antetul functiei este:

```
void check_passkeys(struct request *requests, int len, char *connected);
```

Semnificatia argumentelor este:

- **requests** adresa de inceput a vectorului de request-uri
- **len** numarul de request-uri
- **connected** adresa de inceput a vectorului pentru conexiuni

**Se garanteaza ca toate valorile raman in limitele tipurilor de date date in structuri**

#### **Observatie**

Pentru exercitiul 2 se va folosi acelasi vector folosit si la exercitiul 1. Nu puteti face
exercitiul 2 fara sa rezolvati exercitiul 1, deoarece ordinea de parcurgere a request-urilor
trebuie sa fie cea sortata.

---