## Task 3

Tot cutrierând pe la porțile difertor animale, Suricata noastră a devenit destul
de sceptică că datele din valiza sa ar putea să fie furate în timp ce doarme.
Din această cauză, ea dorește să cripteze tot ce deține folosind un [block cipher](https://en.wikipedia.org/wiki/Block_cipher),
însă vrea ca acesta să fie cât mai simplu.

<div align="center">
    <img title="IDS" alt="IDS" src="../images/suricata_crypto.webp" width="300" height="300">
</div>

După mai multe nopți nedormite de gândire, aceasta se decide asupra cifrului [Treyfer](https://en.wikipedia.org/wiki/Treyfer),
care pentru a cripta un bloc de **8 bytes** de date după următoarea schemă:

<div align="center">
    <img title="schema" alt="schema" src="../images/schema_crypto.png" width="60%" height="60%">
</div>
<div align="center">
<em>Sursă: A. Kircanski and A. M. Youssef, "A Related-Key Attack on TREYFER"</em>
</div>

În figura de mai sus, `P0` până la `P7` reprezintă cei 8 bytes din bloc,
`SK0` până la `SK7` reprezintă cei 8 bytes din cheia secretă, iar `<<<`
reprezintă operația de rotație la dreapta. Acestă operație
se poate repeta de un număr `n` de runde.

Întrucât schema de mai sus poate să fie neintuitivă, descriem și în limbaj natural atât procdeura de **criptare** cât și de **decriptare**.

Pentru **criptare** se pornește cu o variabilă pe 8 biți `t`, ce reprezintă starea
criptării. Inițial, aceasta este primul byte al blocului de criptat.

La fiecare rundă, pentru fiecare byte de pe poziția `i` din blocul de criptat:
1. Se adună la variabila de stare byte-ul corespunzător din **cheia secretă**
2. Se substituie variabila de stare cu corespondentul acesteia într-un [S-Box](https://en.wikipedia.org/wiki/S-box), definit în scheletul temei.
3. Se adună **următorul** byte din bloc. Dacă vorbim de ultimul byte, atunci următorul byte va fi cel de pe poziția 0. 
4. Variabila de stare suferă o rotație la stânga cu 1 bit.
5. Byte-ul de pe poziția `(i + 1) % 8` din bloc va fi actualizat cu valoarea variabilei de stare.

Pentru **decriptare**, vom parcurge blocul **în sens invers**  la fiecare rundă
și vom efectua următoarele operații:
1. Luăm byte-ul curent din bloc și adunăm byte-ul corespondent din cheia secretă
2. Aplicăm același `S-box` pe byte-ul nou format. Notăm acest rezultat cu `top`.
3. Luăm byte-ul următor din bloc (poziția `(i + 1) % 8`) și îi aplicăm o rotire la dreapta cu 1 bit. Notăm acest rezultat cu `bottom`.
4.  Byte-ul de pe poziția `(i + 1) % 8` din bloc va fi actualizat cu diferența `bottom - top`.

Pentru o înțelegere mai bună a procesului de criptare/decriptare, Zoly s-a gândit
la următorul exemplu ce ilustrează **o rundă** de criptare pentru blocuri de **2 bytes**
(procedeul este similar pentru dimensiunea reală a blocului, **8 bytes**):

**Criptarea** textului "mo" cu cheia "da" folosind **S-Box**-ul din scheletul temei:

**Starea inițială (0)**
```
text:   m   o
ascii:  109 111
stare(t): 109
```

**Pasul 1**:
1. Adunăm byte-ul corespunzător al cheii (`'d' = 100`): `t = 109 + 100 = 209`
2. Facem substituția t = sbox[t], în cazul nostru `sbox[209] = 135`
3. Adunăm următorul byte din bloc ('o' = 111): `t = 135 + 111 = 246`
4. Aplicăm o rotație la stânga pe t: `t = 246 <<< 1 = 237`
5. Actualizăm byte-ul de pe poziția 1 cu valoarea lui t, ajungând la următoarea stare:
    ```
    ascii: 109 237
    stare (t): 237
    ```

**Pasul 2**:
1. Adunăm byte-ul corespunzător al cheii (`'a' = 97`): `t = 237 + 97 = 78` (luând în considerare overflowul pe 1 byte)
2. Facem substituția t = sbox[t], în cazul nostru `sbox[78] = 169`
3. Adunăm următorul byte din bloc (`109`): `t = 169 + 109 = 22` (după overflow)
4. Aplicăm o rotație la stânga pe t: `t = 22 <<< 1 = 44`
5. Actualizăm byte-ul de pe poziția 0 cu valoarea lui t, ajungând la următoarea stare:
    ```
    ascii: 44 237
    stare (t): 44
    ```

Pentru **decriptare**, vom porni de la starea tocmai criptată și vom folosi aceeași cheie secretă:
```
ascii: 44 237
```

**Pasul 1**:
1. Luăm byte-ul de pe ultima poziție și adunăm byte-ul corespondent al cheii (`'a' = 97`) => `237 + 97 = 78`
2. Întrucât `sbox[78] = 169`, notăm `top = 169`
3. Rotim byte-ul următor din bloc (în cazul nostru poziția 0) la dreapta: `44 >>> 1 = 22`, deci `bottom = 22`
4. Calculăm rezultatul `bottom - top = 22 - 169 = 109` (după underflow) și actualizăm byte-ul de pe poziția 0, ajungând la starea:
    ```
    ascii: 109 237
    ```

**Pasul 2**:
1. Luăm byte-ul de pe prima poziție și adunăm byte-ul corespondent al cheii (`'d' = 100`) => `109 + 100 = 209`
2. Întrucât `sbox[209] = 135`, notăm `top = 135`
3. Rotim byte-ul următor din bloc (în cazul nostru poziția 1) la dreapta: `237 >>> 1 = 246`, deci `bottom = 246`
4. Calculăm rezultatul `bottom - top = 246 - 135 = 111` și actualizăm byte-ul de pe poziția 0, ajungând la starea inițială:
    ```
    ascii:  109  111
    text:   m    o
    ```

Sarcina voastră este să o ajutați pe Zoly să implementeze metode de criptare și
decriptare pentru acest cifru, în cazul cu `10` runde de criptare și dimensiunea blocului de `8` bytes.
Mai precis, va trebui să implementați funcțiile:

```c
void treyfer_crypt(uint8_t text[8], uint8_t key[8]);
void treyfer_dcrypt(uint8_t text[8], uint8_t key[8]);
```
Aceste funcții vor modifica **in-place** blocul de criptat/decriptat. Astfel,
veți modifica în mod direct memoria din array-ul `text` dat ca parametru cu rezultatul criptării/decriptării.

---
