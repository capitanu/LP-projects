# Examen - Regresia liniara multipla: Caracteristici demografice/antropometrice si valori spirometrice

## Descrierea studiului

**Tip studiu:** Transversal
**Esantion:** 100 copii cu varste intre 7-13 ani, din 5 scoli din Cluj-Napoca
**Obiectiv:** Testarea relatiei dintre caracteristicile demografice si antropometrice (varsta, inaltime) si valorile spirometrice (PEF, FEV1)

### Variabile

| Variabila | Tip | Descriere | Unitate |
|-----------|-----|-----------|---------|
| Gen | Calitativa dicotomica | 0 = Feminin, 1 = Masculin | - |
| Varsta_ani | Cantitativa continua | Varsta copilului | ani |
| Inaltime_cm | Cantitativa continua | Inaltimea copilului | cm |
| FEV1 | Cantitativa continua (VD) | Debitul Expirator Maxim in prima secunda | L/s |
| PEF | Cantitativa continua (VD) | Debitul Expirator Maxim de Varf | L/min |

---

## 1. Statistici descriptive

### 1.1 Distributia pe gen

| Gen | n | % |
|-----|---|---|
| Feminin | 53 | 53.0% |
| Masculin | 47 | 47.0% |

Esantionul este relativ echilibrat intre cele doua genuri.

### 1.2 Variabile cantitative

| Variabila | N | Media | Mediana | SD | Min | Max | Q1 | Q3 | IQR | Outlieri |
|-----------|---|-------|---------|-----|-----|-----|----|----|-----|----------|
| Varsta (ani) | 100 | 9.0830 | 9.0000 | 1.5925 | 5.00 | 13.10 | 8.20 | 10.03 | 1.83 | 2 (5.0, 13.1) |
| Inaltime (cm) | 100 | 119.80 | 119.00 | 13.5885 | 82.00 | 158.00 | 109.75 | 130.00 | 20.25 | 0 |
| FEV1 (L/s) | 100 | 1.3960 | 1.3800 | 0.2718 | 0.64 | 2.16 | 1.20 | 1.60 | 0.41 | 0 |
| PEF (L/min) | 100 | 147.59 | 145.00 | 42.0582 | 70.00 | 280.00 | 119.00 | 173.50 | 54.50 | 1 (280) |

**Observatii:**
- Varsta medie a copiilor este de ~9 ani, cu o deviatie standard de 1.59 ani
- Inaltimea medie este de ~120 cm, fara outlieri
- PEF are un singur outlier (280 L/min), dar nu este extrem
- FEV1 nu prezinta outlieri

### 1.3 Statistici descriptive pe gen

| Variabila | Feminin (n=53) | | Masculin (n=47) | |
|-----------|----------|------|----------|------|
| | Media | SD | Media | SD |
| Varsta (ani) | 9.1962 | 1.6422 | 8.9553 | 1.5421 |
| Inaltime (cm) | 120.36 | 15.09 | 119.17 | 11.80 |
| FEV1 (L/s) | 1.4072 | 0.3018 | 1.3834 | 0.2360 |
| PEF (L/min) | 150.62 | 43.94 | 144.17 | 40.02 |

Diferentele intre genuri sunt mici si nesemnificative statistic (vezi regresiile cu Gen mai jos).

---

## 2. Teste de normalitate (Shapiro-Wilk)

| Variabila | W | p-value | Concluzie |
|-----------|---|---------|-----------|
| Varsta (ani) | 0.9837 | 0.2569 | Distributie normala (p > 0.05) |
| Inaltime (cm) | 0.9877 | 0.4865 | Distributie normala (p > 0.05) |
| FEV1 (L/s) | 0.9877 | 0.4865 | Distributie normala (p > 0.05) |
| PEF (L/min) | 0.9769 | 0.0766 | Distributie normala (p > 0.05) |

Toate variabilele urmeaza o distributie normala (p > 0.05 la testul Shapiro-Wilk), ceea ce permite utilizarea metodelor parametrice (regresia liniara).

---

## 3. Matricea de corelatie Pearson

|  | Varsta | Inaltime | Gen | FEV1 | PEF |
|--|--------|----------|-----|------|-----|
| **Varsta** | 1.0000 | -0.0045 | -0.0759 | -0.0045 | **0.2768** |
| **Inaltime** | -0.0045 | 1.0000 | -0.0439 | **1.0000** | **0.6358** |
| **Gen** | -0.0759 | -0.0439 | 1.0000 | -0.0439 | -0.0770 |
| **FEV1** | -0.0045 | **1.0000** | -0.0439 | 1.0000 | **0.6358** |
| **PEF** | **0.2768** | **0.6358** | -0.0770 | **0.6358** | 1.0000 |

### Teste de semnificatie

| Pereche | r | t | df | p-value | Semnificativ? |
|---------|---|---|----|---------|----|
| Varsta vs PEF | 0.2768 | 2.8517 | 98 | 0.0053 | **Da** |
| Inaltime vs PEF | 0.6358 | 8.1548 | 98 | 1.18e-12 | **Da** |
| Gen vs PEF | -0.0770 | -0.7641 | 98 | 0.4466 | Nu |
| Varsta vs FEV1 | -0.0045 | -0.0450 | 98 | 0.9642 | Nu |
| Inaltime vs FEV1 | **1.0000** | **Inf** | 98 | <2.2e-16 | **Da** |
| Gen vs FEV1 | -0.0439 | -0.4347 | 98 | 0.6648 | Nu |
| Varsta vs Inaltime | -0.0045 | -0.0450 | 98 | 0.9642 | Nu |

**Observatii cheie:**
- **PEF** se coreleaza semnificativ cu Inaltimea (r = 0.64, corelatie moderata-puternica) si cu Varsta (r = 0.28, corelatie slaba)
- **FEV1** are o corelatie **perfecta** cu Inaltimea (r = 1.000) — FEV1 este calculat exact din Inaltime prin formula FEV1 = -1 + 0.02 * Inaltime
- **Gen** nu se coreleaza semnificativ cu niciuna dintre variabilele spirometrice
- **Varsta si Inaltimea** nu sunt corelate intre ele (r = -0.005), ceea ce e neobisnuit si indica probabil un esantion cu variabilitate mare la inaltime pentru fiecare varsta

---

## ANALIZA 1: PEF (Debitul Expirator Maxim de Varf)

### 4. Regresii simple pentru PEF

#### 4.1 PEF ~ Varsta

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 81.19 | 23.64 | 3.435 | 0.00087 | [34.28, 128.09] |
| Varsta_ani | 7.31 | 2.56 | 2.852 | **0.0053** | [2.22, 12.40] |

- **R² = 0.0766** (7.7% din variabilitatea PEF explicata de varsta)
- Asocierea este semnificativa dar slaba
- La fiecare an in plus, PEF creste cu ~7.3 L/min

#### 4.2 PEF ~ Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | -88.17 | 29.09 | -3.030 | 0.0031 | [-145.90, -30.43] |
| Inaltime_cm | 1.97 | 0.24 | 8.155 | **1.18e-12** | [1.49, 2.45] |

- **R² = 0.4043** (40.4% din variabilitatea PEF explicata de inaltime)
- Asocierea este puternic semnificativa
- La fiecare cm in plus, PEF creste cu ~1.97 L/min
- Inaltimea este cel mai bun predictor individual al PEF

#### 4.3 PEF ~ Gen

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 150.62 | 5.79 | 26.017 | <2e-16 | [139.13, 162.11] |
| Gen | -6.45 | 8.45 | -0.764 | 0.4466 | [-23.21, 10.31] |

- **R² = 0.0059** (0.6% — practic zero)
- Genul nu este un predictor semnificativ al PEF (p = 0.45)

### 5. Regresie multipla: PEF ~ Varsta + Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | -155.73 | 32.47 | -4.796 | 5.84e-06 | [-220.18, -91.29] |
| Varsta_ani | 7.39 | 1.93 | 3.829 | **0.000228** | [3.56, 11.22] |
| Inaltime_cm | 1.97 | 0.23 | 8.722 | **7.67e-14** | [1.52, 2.42] |

**Ecuatia de regresie:**
```
PEF = -155.73 + 7.39 * Varsta + 1.97 * Inaltime
```

**Performanta modelului:**
- **R² = 0.4825** — 48.2% din variabilitatea PEF este explicata de varsta si inaltime impreuna
- **R² ajustat = 0.4718**
- **F(2, 97) = 45.22, p = 1.33e-14** — modelul este semnificativ global

**Interpretare coeficienti:**
- **Varsta (b1 = 7.39):** La cresterea varstei cu 1 an, PEF creste cu 7.39 L/min, controlind pentru inaltime
- **Inaltime (b2 = 1.97):** La cresterea inaltimii cu 1 cm, PEF creste cu 1.97 L/min, controlind pentru varsta
- Ambii predictori sunt semnificativi (p < 0.001)

**Observatie importanta:** R² creste de la 0.4043 (doar Inaltime) la 0.4825 (Inaltime + Varsta), deci adaugarea Varstei aduce o imbunatatire de ~7.8 puncte procentuale. Acest lucru se intimpla desi Varsta si Inaltimea nu sunt corelate (r ≈ 0), ceea ce inseamna ca cele doua variabile capteaza aspecte independente ale variabilitatii PEF.

### 6. Modelul cu Gen: PEF ~ Varsta + Inaltime + Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -153.66 | 33.07 | -4.647 | 1.07e-05 |
| Varsta_ani | 7.33 | 1.94 | 3.772 | 0.00028 |
| Inaltime_cm | 1.97 | 0.23 | 8.658 | 1.13e-13 |
| Gen | -2.35 | 6.18 | -0.380 | **0.7046** |

- **R² = 0.4833**, R² ajustat = 0.4671
- **ANOVA comparativa:** F = 0.1446, p = 0.7046
- **Concluzie:** Adaugarea genului **NU** imbunatateste semnificativ modelul. Genul nu este un predictor relevant al PEF dupa ce se controleaza pentru varsta si inaltime.

### 7. Diagnostice model PEF (Varsta + Inaltime)

| Test | Statistica | p-value | Concluzie |
|------|-----------|---------|-----------|
| Shapiro-Wilk (normalitate reziduuri) | W = 0.9746 | 0.0503 | Reziduurile sunt normal distribuite (la limita) |
| Breusch-Pagan (homoscedasticitate) | BP = 3.8829 | 0.1435 | Homoscedasticitate respectata |
| Durbin-Watson (independenta erorilor) | DW = 1.7959 | 0.1513 | Erorile sunt independente |

**Observatii puncte influentiale:**
- Cook's D > 4/n: 7 observatii (niciuna cu Cook's D > 0.5, maxim = 0.1562)
- Reziduuri standardizate |> 2|: 7 observatii

**VIF (Variance Inflation Factor):**
| Variabila | VIF |
|-----------|-----|
| Varsta_ani | 1.000 |
| Inaltime_cm | 1.000 |

VIF ≈ 1 pentru ambii predictori — **nu exista multicoliniaritate**. Acest lucru era de asteptat dat fiind ca Varsta si Inaltimea nu sunt corelate (r = -0.005).

**Concluzie diagnostice:** Toate conditiile regresiei liniare sunt indeplinite:
1. Normalitatea reziduurilor (Shapiro-Wilk p = 0.05, la limita dar acceptabil)
2. Homoscedasticitate (Breusch-Pagan p = 0.14)
3. Independenta erorilor (Durbin-Watson p = 0.15)
4. Absenta multicoliniaritatii (VIF = 1.0)

### 8. Modele cu interactiuni pentru PEF

#### 8.1 PEF ~ Varsta * Inaltime

Testam daca efectul varstei asupra PEF difera in functie de inaltime (si invers).

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -452.43 | 195.21 | -2.318 | 0.0226 |
| Varsta_ani | 39.76 | 21.09 | 1.885 | 0.0625 |
| Inaltime_cm | 4.43 | 1.61 | 2.748 | 0.0072 |
| Varsta:Inaltime | -0.27 | 0.17 | -1.541 | **0.1266** |

- **R² = 0.4950**, R² ajustat = 0.4792
- **ANOVA comparativa vs model fara interactiune:** F = 2.3747, p = 0.1266
- **Concluzie:** Interactiunea Varsta * Inaltime **NU** este semnificativa (p = 0.13). Efectul varstei asupra PEF nu depinde semnificativ de inaltime.

#### 8.2 PEF ~ Varsta * Gen

Testam daca efectul varstei asupra PEF difera intre baieti si fete.

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 83.65 | 32.31 | 2.589 | 0.0111 |
| Varsta_ani | 7.28 | 3.46 | 2.105 | 0.0379 |
| Gen | -2.96 | 48.07 | -0.062 | 0.9510 |
| Varsta:Gen | -0.19 | 5.23 | -0.037 | **0.9704** |

- **R² = 0.0798**, R² ajustat = 0.0510
- **ANOVA comparativa vs PEF ~ Varsta:** F = 0.1649, p = 0.8482
- **Concluzie:** Interactiunea Varsta * Gen **NU** este semnificativa (p = 0.97). Relatia dintre varsta si PEF este similara la baieti si fete.

#### 8.3 PEF ~ Inaltime * Gen

Testam daca efectul inaltimii asupra PEF difera intre baieti si fete.

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -79.67 | 36.65 | -2.174 | 0.0322 |
| Inaltime_cm | 1.91 | 0.30 | 6.332 | 7.77e-09 |
| Gen | -20.42 | 61.36 | -0.333 | 0.7400 |
| Inaltime:Gen | 0.14 | 0.51 | 0.267 | **0.7899** |

- **R² = 0.4071**, R² ajustat = 0.3886
- **ANOVA comparativa vs PEF ~ Inaltime:** F = 0.231, p = 0.7942
- **Concluzie:** Interactiunea Inaltime * Gen **NU** este semnificativa (p = 0.79). Relatia dintre inaltime si PEF este similara la baieti si fete.

#### 8.4 Model complet cu toate interactiunile

PEF ~ Varsta + Inaltime + Gen + Varsta:Inaltime + Varsta:Gen + Inaltime:Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -450.73 | 204.84 | -2.200 | 0.0303 |
| Varsta_ani | 39.53 | 21.68 | 1.823 | 0.0715 |
| Inaltime_cm | 4.40 | 1.70 | 2.593 | 0.0110 |
| Gen | 10.86 | 67.65 | 0.161 | 0.8728 |
| Varsta:Inaltime | -0.26 | 0.18 | -1.466 | 0.1461 |
| Varsta:Gen | -0.98 | 3.95 | -0.247 | 0.8055 |
| Inaltime:Gen | -0.03 | 0.48 | -0.067 | 0.9470 |

- **R² = 0.4958**, R² ajustat = 0.4633
- **ANOVA comparativa vs model Varsta+Inaltime (fara interactiuni):** F = 0.6143, p = 0.6534
- **Concluzie:** Adaugarea tuturor interactiunilor **NU** imbunatateste semnificativ modelul (p = 0.65). Modelul aditiv simplu (PEF ~ Varsta + Inaltime) este suficient.

#### Sumar interactiuni PEF

| Model | R² | Adj R² | ANOVA p vs model de baza |
|-------|-----|--------|--------------------------|
| PEF ~ Varsta + Inaltime (aditiv) | 0.4825 | 0.4718 | - |
| + Varsta:Inaltime | 0.4950 | 0.4792 | 0.1266 |
| + Varsta:Gen (vs PEF~Varsta) | 0.0798 | 0.0510 | 0.8482 |
| + Inaltime:Gen (vs PEF~Inaltime) | 0.4071 | 0.3886 | 0.7942 |
| Toate interactiunile | 0.4958 | 0.4633 | 0.6534 |

**Niciuna** dintre interactiuni nu este semnificativa. Efectele varstei si inaltimii asupra PEF sunt aditive si nu depind de gen. Modelul optim ramine **PEF ~ Varsta + Inaltime** fara interactiuni.

---

## ANALIZA 2: log10(FEV1) - Transformare logaritmica

### 8. Necesitatea transformarii log10(FEV1)

Modelul original FEV1 ~ Inaltime_cm produce un **fit perfect** (R² = 1.000000) deoarece FEV1 este calculat exact din Inaltime prin formula determinista:

```
FEV1 = -1 + 0.02 * Inaltime_cm
```

Aceasta relatie nu este statistica, ci **matematica**. Diagnosticele pe modelul original esueaza:
- Shapiro-Wilk pe reziduuri: W = 0.9418, p = 0.0002 (reziduurile sunt erori de rotunjire, nu erori statistice reale)
- R a emis avertismentul: "essentially perfect fit: summary may be unreliable"

**Justificarea transformarii log10:**
- FEV1 are o relatie determinista cu Inaltimea — diagnosticele nu sunt interpretabile
- Transformarea log10 produce un model cu reziduuri reale, permitind evaluarea conditiilor regresiei
- log10 este o transformare standard pentru volume/debite respiratorii in literatura medicala

### 9. Statistici descriptive log10(FEV1)

| Statistica | Valoare |
|------------|---------|
| N | 100 |
| Media | 0.1364 |
| Mediana | 0.1399 |
| SD | 0.0881 |
| Min | -0.1938 |
| Max | 0.3345 |
| Q1 | 0.0774 |
| Q3 | 0.2041 |
| IQR | 0.1268 |
| Outlieri | 2 (-0.194, -0.119) |

**Shapiro-Wilk pe log10(FEV1):** W = 0.9697, p = 0.0211 — distributia nu este strict normala (p < 0.05), dar transformarea a rezolvat problema fitului perfect.

### 10. Comparare FEV1 original vs log10(FEV1)

| Model | R² | Shapiro-Wilk reziduuri (W) | Shapiro-Wilk p | Concluzie |
|-------|-----|---------------------------|----------------|-----------|
| FEV1 ~ Inaltime (original) | 1.000000 | 0.9418 | 0.0002 | Fit perfect — diagnostic imposibil |
| log10(FEV1) ~ Inaltime (transformat) | **0.9762** | 0.5841 | 2.17e-15 | Model realist, cu reziduuri reale |

Transformarea log10 a eliminat relatia determinista: R² a scazut de la 1.0000 la 0.9762, generind reziduuri interpretabile statistic.

### 11. Regresii simple pentru log10(FEV1)

#### 11.1 log10(FEV1) ~ Varsta

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 0.1414 | 0.0515 | 2.745 | 0.0072 | [0.039, 0.244] |
| Varsta_ani | -0.0006 | 0.0056 | -0.100 | **0.9207** | [-0.012, 0.011] |

- **R² = 0.0001** — varsta nu explica variabilitatea log10(FEV1)
- Asocierea este complet nesemnificativa (p = 0.92)

#### 11.2 log10(FEV1) ~ Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | -0.6310 | 0.0122 | -51.82 | <2e-16 | [-0.655, -0.607] |
| Inaltime_cm | 0.00641 | 0.000101 | 63.42 | **<2e-16** | [0.0062, 0.0066] |

- **R² = 0.9762** — inaltimea explica 97.6% din variabilitatea log10(FEV1)
- Asocierea este extrem de puternica si semnificativa
- La fiecare cm in plus, log10(FEV1) creste cu 0.0064

#### 11.3 log10(FEV1) ~ Gen

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 0.1379 | 0.0122 | 11.338 | <2e-16 | [0.114, 0.162] |
| Gen | -0.0032 | 0.0177 | -0.182 | **0.856** | [-0.038, 0.032] |

- **R² = 0.0003** — genul nu explica variabilitatea log10(FEV1)
- Nesemnificativ (p = 0.86)

### 12. Regresie multipla: log10(FEV1) ~ Varsta + Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | -0.6282 | 0.0146 | -43.114 | <2e-16 | [-0.657, -0.599] |
| Varsta_ani | -0.0003 | 0.0009 | -0.357 | **0.722** | [-0.002, 0.001] |
| Inaltime_cm | 0.00641 | 0.0001 | 63.134 | **<2e-16** | [0.0062, 0.0066] |

**Ecuatia de regresie:**
```
log10(FEV1) = -0.6282 + (-0.0003) * Varsta + 0.0064 * Inaltime
```

**Performanta modelului:**
- **R² = 0.9762** — 97.6% din variabilitatea log10(FEV1) este explicata de varsta si inaltime
- **R² ajustat = 0.9758**
- **F(2, 97) = 1993.17, p < 2.2e-16** — modelul este semnificativ global

**Interpretare coeficienti (pe scala log10 — back-transform):**
- **Varsta (b1 = -0.0003):** La cresterea varstei cu 1 an, FEV1 se multiplica cu 0.9993 (factor multiplicativ), adica o modificare de -0.07% — practic nesemnificativa (p = 0.722)
- **Inaltime (b2 = 0.0064):** La cresterea inaltimii cu 1 cm, FEV1 se multiplica cu 1.0149, adica o crestere de **1.49%**, controlind pentru varsta
- La cresterea inaltimii cu **10 cm**, FEV1 se multiplica cu **1.1589** (crestere de 15.89%)

**Observatie:** Inaltimea ramine singurul predictor semnificativ. Varsta nu aduce informatie suplimentara (p = 0.722), ceea ce confirma ca FEV1 depinde in principal de inaltime.

### 13. Modelul cu Gen: log10(FEV1) ~ Varsta + Inaltime + Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -0.6320 | 0.0147 | -43.116 | <2e-16 |
| Varsta_ani | -0.0002 | 0.0009 | -0.238 | 0.813 |
| Inaltime_cm | 0.00641 | 0.0001 | 63.634 | <2e-16 |
| Gen | 0.0043 | 0.0027 | 1.586 | **0.116** |

- **R² = 0.9769**, R² ajustat = 0.9761
- **ANOVA comparativa:** F = 2.5166, p = 0.1159
- **Concluzie:** Adaugarea genului **NU** imbunatateste semnificativ modelul (p = 0.12). Genul nu este un predictor relevant al log10(FEV1).

### 14. Diagnostice model log10(FEV1) (Varsta + Inaltime)

| Test | Statistica | p-value | Concluzie |
|------|-----------|---------|-----------|
| Shapiro-Wilk (normalitate reziduuri) | W = 0.5902 | **2.81e-15** | Reziduurile NU sunt normal distribuite |
| Breusch-Pagan (homoscedasticitate) | BP = 5.3078 | 0.0704 | Homoscedasticitate respectata (la limita) |
| Durbin-Watson (independenta erorilor) | DW = 1.9326 | 0.366 | Erorile sunt independente |

**Observatii puncte influentiale:**
- Cook's D > 4/n: 6 observatii
- Cook's D maxim: 1.5568 (o observatie cu influenta mare)
- Reziduuri standardizate |> 2|: 4 observatii

**VIF (Variance Inflation Factor):**
| Variabila | VIF |
|-----------|-----|
| Varsta_ani | 1.000 |
| Inaltime_cm | 1.000 |

VIF ≈ 1 — **nu exista multicoliniaritate**.

**Concluzie diagnostice:**
- Normalitatea reziduurilor nu este respectata (Shapiro-Wilk p < 0.001) — acest lucru este datorat relatiei quasi-deterministe intre FEV1 si Inaltime, chiar si dupa transformare log10
- Homoscedasticitate respectata (la limita, p = 0.07)
- Independenta erorilor respectata (DW = 1.93, p = 0.37)
- Absenta multicoliniaritatii (VIF = 1.0)
- Exista o observatie cu Cook's D = 1.56 (puternic influentala), dar modelul ramine stabil

### 15. Modele cu interactiuni pentru log10(FEV1)

#### 15.1 log10(FEV1) ~ Varsta * Inaltime

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -0.5995 | 0.0886 | -6.764 | 1.05e-09 |
| Varsta_ani | -0.0034 | 0.0096 | -0.359 | 0.721 |
| Inaltime_cm | 0.0062 | 0.0007 | 8.421 | 3.63e-13 |
| Varsta:Inaltime | 0.0000 | 0.0001 | 0.328 | **0.744** |

- **R² = 0.9763**, R² ajustat = 0.9755
- **ANOVA comparativa:** F = 0.1075, p = 0.7437
- **Concluzie:** Interactiunea **NU** este semnificativa (p = 0.74).

#### 15.2 log10(FEV1) ~ Varsta * Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 0.1635 | 0.0705 | 2.320 | 0.0225 |
| Varsta_ani | -0.0028 | 0.0075 | -0.369 | 0.713 |
| Gen | -0.0477 | 0.1048 | -0.455 | 0.650 |
| Varsta:Gen | 0.0049 | 0.0114 | 0.429 | **0.669** |

- **R² = 0.0024**, R² ajustat = -0.0288
- **ANOVA comparativa vs log10(FEV1) ~ Varsta:** F = 0.1098, p = 0.8961
- **Concluzie:** Interactiunea **NU** este semnificativa (p = 0.67).

#### 15.3 log10(FEV1) ~ Inaltime * Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | -0.6375 | 0.0152 | -42.05 | <2e-16 |
| Inaltime_cm | 0.00644 | 0.000125 | 51.53 | <2e-16 |
| Gen | 0.0145 | 0.0254 | 0.570 | 0.570 |
| Inaltime:Gen | -0.0001 | 0.0002 | -0.400 | **0.690** |

- **R² = 0.9769**, R² ajustat = 0.9762
- **ANOVA comparativa vs log10(FEV1) ~ Inaltime:** F = 1.376, p = 0.2575
- **Concluzie:** Interactiunea **NU** este semnificativa (p = 0.69).

#### Sumar interactiuni log10(FEV1)

| Model | R² | Adj R² | ANOVA p vs model de baza |
|-------|-----|--------|--------------------------|
| log10(FEV1) ~ Varsta + Inaltime (aditiv) | 0.9762 | 0.9758 | - |
| + Varsta:Inaltime | 0.9763 | 0.9755 | 0.7437 |
| + Varsta:Gen (vs log10(FEV1)~Varsta) | 0.0024 | -0.0288 | 0.8961 |
| + Inaltime:Gen (vs log10(FEV1)~Inaltime) | 0.9769 | 0.9762 | 0.2575 |

**Niciuna** dintre interactiuni nu este semnificativa. Modelul optim ramine **log10(FEV1) ~ Varsta + Inaltime** (dar numai Inaltime este semnificativ).

---

## Sumar general

| Model | R² | R² ajustat | F | p-value |
|-------|-----|------------|---|---------|
| **PEF ~ Varsta + Inaltime** | **0.4825** | **0.4718** | 45.22 | 1.33e-14 |
| **log10(FEV1) ~ Varsta + Inaltime** | **0.9762** | **0.9758** | 1993.17 | <2.2e-16 |

### Concluzii

1. **Modelul PEF** este un model valid din punct de vedere statistic:
   - 48.2% din variabilitatea PEF este explicata de varsta si inaltime impreuna
   - Ambii predictori sunt semnificativi independent: inaltimea (p < 10^-13) si varsta (p = 0.0002)
   - Inaltimea este predictorul dominant (R² simplu = 0.40 vs R² simplu varsta = 0.08)
   - Genul nu aduce informatie suplimentara semnificativa
   - Toate conditiile de validitate ale regresiei sunt indeplinite

2. **Modelul log10(FEV1)** — dupa transformarea logaritmica:
   - Transformarea log10 a rezolvat problema fitului perfect (R² = 1.0 -> R² = 0.9762)
   - 97.6% din variabilitatea log10(FEV1) este explicata de varsta si inaltime
   - Doar Inaltimea este predictor semnificativ (p < 2e-16); Varsta este nesemnificativa (p = 0.72)
   - La fiecare cm in plus de inaltime, FEV1 creste cu ~1.5% (pe scala originala)
   - Genul nu aduce informatie suplimentara (p = 0.12)
   - Normalitatea reziduurilor nu este complet respectata (datorita relatiei quasi-deterministe), dar celelalte conditii sunt indeplinite

3. **Interactiunile** nu sunt semnificative pentru niciunul dintre modele:
   - Varsta * Inaltime: p = 0.13 (PEF); p = 0.74 (log10(FEV1))
   - Varsta * Gen: p = 0.97 (PEF); p = 0.67 (log10(FEV1))
   - Inaltime * Gen: p = 0.79 (PEF); p = 0.69 (log10(FEV1))
   - Efectele variabilelor sunt aditive

4. **Genul** nu este un predictor semnificativ pentru niciunul dintre parametrii spirometrici, nici individual, nici in combinatie cu celelalte variabile, nici prin interactiuni.

5. **Varsta si Inaltimea** sunt aproape complet necorelate in acest esantion (r = -0.005), ceea ce le face predictori ortogonali ideali in modelul multiplu.

---

## Figuri generate

| Fisier | Descriere |
|--------|-----------|
| `boxplots_all.png` | Box-plots pentru toate variabilele cantitative |
| `boxplots_by_gen.png` | Box-plots FEV1 si PEF pe gen |
| `histograme.png` | Histograme cu curba normala suprapusa |
| `scatter_plots.png` | Scatter plots (PEF/FEV1 vs Varsta/Inaltime + Inaltime vs Varsta) |
| `pef_diagnostic.png` | Grafice diagnostice (4 panouri) pentru modelul PEF |
| `pef_hist_resid.png` | Histograma reziduurilor modelului PEF |
| `fev1_transform_compare.png` | Comparare histograme: FEV1 original vs log10(FEV1) transformat |
| `fev1_diagnostic.png` | Grafice diagnostice (4 panouri) pentru modelul log10(FEV1) |
| `fev1_hist_resid.png` | Histograma reziduurilor modelului log10(FEV1) |
| `pef_interaction_varsta_gen.png` | PEF vs Varsta, separat pe gen (grafic interactiune) |
| `pef_interaction_inaltime_gen.png` | PEF vs Inaltime, separat pe gen (grafic interactiune) |
| `fev1_interaction_varsta_gen.png` | log10(FEV1) vs Varsta, separat pe gen (grafic interactiune) |
| `fev1_interaction_inaltime_gen.png` | log10(FEV1) vs Inaltime, separat pe gen (grafic interactiune) |

---

## Codul R

Codul complet se gaseste in fisierul `analysis_examen.R`. Analiza a fost realizata in R 4.5.2, folosind pachetele `car` (VIF), `lmtest` (Breusch-Pagan, Durbin-Watson).

### Output complet R

```
=== Structura datelor ===
'data.frame':	100 obs. of  5 variables:
 $ Gen        : int  0 1 1 0 0 1 1 0 0 0 ...
 $ Varsta_ani : num  8.1 10 8.2 10.1 6.1 10.2 12 10.3 8.4 8.3 ...
 $ Inaltime_cm: int  102 122 127 105 117 120 124 106 107 111 ...
 $ FEV1       : num  1.04 1.44 1.54 1.1 1.34 1.4 1.48 1.12 1.14 1.22 ...
 $ PEF        : int  100 160 165 130 100 140 160 128 100 160 ...
n = 100

===========================================================================
1. STATISTICI DESCRIPTIVE
===========================================================================

--- Gen ---
 Feminin Masculin
      53       47
  Feminin: 53 ( 53.0% )
  Masculin: 47 ( 47.0% )

--- Varsta (ani) ---
  N:        100
  NA:       0
  Media:    9.0830
  Mediana:  9.0000
  SD:       1.5925
  Min:      5.0000
  Max:      13.1000
  Q1:       8.2000
  Q3:       10.0250
  IQR:      1.8250
  Outliers: 2
    Valori: 5 13.1

--- Inaltime (cm) ---
  N:        100
  NA:       0
  Media:    119.8000
  Mediana:  119.0000
  SD:       13.5885
  Min:      82.0000
  Max:      158.0000
  Q1:       109.7500
  Q3:       130.0000
  IQR:      20.2500
  Outliers: 0

--- FEV1 (L/s) ---
  N:        100
  NA:       0
  Media:    1.3960
  Mediana:  1.3800
  SD:       0.2718
  Min:      0.6400
  Max:      2.1600
  Q1:       1.1950
  Q3:       1.6000
  IQR:      0.4050
  Outliers: 0

--- PEF (L/min) ---
  N:        100
  NA:       0
  Media:    147.5900
  Mediana:  145.0000
  SD:       42.0582
  Min:      70.0000
  Max:      280.0000
  Q1:       119.0000
  Q3:       173.5000
  IQR:      54.5000
  Outliers: 1
    Valori: 280

--- Statistici descriptive pe Gen ---

  Varsta_ani la Feminin (n=53): Media=9.1962, SD=1.6422
  Varsta_ani la Masculin (n=47): Media=8.9553, SD=1.5421

  Inaltime_cm la Feminin (n=53): Media=120.3585, SD=15.0909
  Inaltime_cm la Masculin (n=47): Media=119.1702, SD=11.7978

  FEV1 la Feminin (n=53): Media=1.4072, SD=0.3018
  FEV1 la Masculin (n=47): Media=1.3834, SD=0.2360

  PEF la Feminin (n=53): Media=150.6226, SD=43.9411
  PEF la Masculin (n=47): Media=144.1702, SD=40.0219

===========================================================================
5. TESTE DE NORMALITATE
===========================================================================

  Varsta (ani): W=0.9837, p=0.2569  => Normal
  Inaltime (cm): W=0.9877, p=0.4865  => Normal
  FEV1 (L/s): W=0.9877, p=0.4865  => Normal
  PEF (L/min): W=0.9769, p=0.07664  => Normal

===========================================================================
6. MATRICEA DE CORELATIE
===========================================================================

Matricea de corelatie Pearson:
            Varsta_ani Inaltime_cm     Gen    FEV1     PEF
Varsta_ani      1.0000     -0.0045 -0.0759 -0.0045  0.2768
Inaltime_cm    -0.0045      1.0000 -0.0439  1.0000  0.6358
Gen            -0.0759     -0.0439  1.0000 -0.0439 -0.0770
FEV1           -0.0045      1.0000 -0.0439  1.0000  0.6358
PEF             0.2768      0.6358 -0.0770  0.6358  1.0000

Teste de semnificatie:

  Varsta_ani vs PEF: r=0.2768, t=2.8517, df=98, p=0.005304
  Inaltime_cm vs PEF: r=0.6358, t=8.1548, df=98, p=1.184e-12
  Gen vs PEF: r=-0.0770, t=-0.7641, df=98, p=0.4466
  Varsta_ani vs FEV1: r=-0.0045, t=-0.0450, df=98, p=0.9642
  Inaltime_cm vs FEV1: r=1.0000, t=Inf, df=98, p=< 2.2e-16
  Gen vs FEV1: r=-0.0439, t=-0.4347, df=98, p=0.6648
  Varsta_ani vs Inaltime_cm: r=-0.0045, t=-0.0450, df=98, p=0.9642

###################################################################
# ANALIZA 1: PEF (Debitul Expirator Maxim de Varf)
###################################################################

--- PEF ~ Varsta_ani ---

Call:
lm(formula = PEF ~ Varsta_ani, data = data)

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   81.190     23.636   3.435  0.00087 ***
Varsta_ani     7.310      2.564   2.852  0.00530 **

Residual standard error: 40.62 on 98 degrees of freedom
Multiple R-squared:  0.07662, Adjusted R-squared:  0.0672
F-statistic: 8.132 on 1 and 98 DF,  p-value: 0.005304

95% IC:
                2.5 %    97.5 %
(Intercept) 34.284458 128.09484
Varsta_ani   2.223167  12.39763

--- PEF ~ Inaltime_cm ---

Call:
lm(formula = PEF ~ Inaltime_cm, data = data)

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -88.1683    29.0938  -3.030  0.00312 **
Inaltime_cm   1.9679     0.2413   8.155 1.18e-12 ***

Residual standard error: 32.63 on 98 degrees of freedom
Multiple R-squared:  0.4043, Adjusted R-squared:  0.3982
F-statistic:  66.5 on 1 and 98 DF,  p-value: 1.184e-12

95% IC:
                  2.5 %     97.5 %
(Intercept) -145.904002 -30.432545
Inaltime_cm    1.489038   2.446826

--- PEF ~ Gen ---

Call:
lm(formula = PEF ~ Gen, data = data)

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  150.623      5.789  26.017   <2e-16 ***
Gen           -6.452      8.445  -0.764    0.447

Residual standard error: 42.15 on 98 degrees of freedom
Multiple R-squared:  0.005922, Adjusted R-squared:  -0.004221
F-statistic: 0.5838 on 1 and 98 DF,  p-value: 0.4466

95% IC:
                2.5 %    97.5 %
(Intercept) 139.13393 162.11135
Gen         -23.21044  10.30558

===========================================================================
1b. REGRESIE MULTIPLA: PEF ~ Varsta_ani + Inaltime_cm
===========================================================================

Call:
lm(formula = PEF ~ Varsta_ani + Inaltime_cm, data = data)

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept) -155.7349    32.4685  -4.796 5.84e-06 ***
Varsta_ani     7.3869     1.9290   3.829 0.000228 ***
Inaltime_cm    1.9719     0.2261   8.722 7.67e-14 ***

Residual standard error: 30.57 on 97 degrees of freedom
Multiple R-squared:  0.4825, Adjusted R-squared:  0.4718
F-statistic: 45.22 on 2 and 97 DF,  p-value: 1.333e-14

95% IC:
                  2.5 %     97.5 %
(Intercept) -220.175837 -91.294035
Varsta_ani     3.558311  11.215473
Inaltime_cm    1.523167   2.420569

Ecuatia: PEF = -155.7349 + (7.3869) * Varsta + (1.9719) * Inaltime

Testul F global:
  H0: beta_varsta = beta_inaltime = 0
  H1: cel putin un beta != 0
  F = 45.2185
  df1 = 2, df2 = 97
  p-value = 1.333e-14
  Decizie: Modelul este semnificativ (p < 0.05).

R² = 0.4825
R² ajustat = 0.4718
Interpretare: 48.2% din variabilitatea PEF este explicata de varsta si inaltime.

===========================================================================
1c. REGRESIE MULTIPLA: PEF ~ Varsta_ani + Inaltime_cm + Gen
===========================================================================

Call:
lm(formula = PEF ~ Varsta_ani + Inaltime_cm + Gen, data = data)

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept) -153.6614    33.0655  -4.647 1.07e-05 ***
Varsta_ani     7.3306     1.9432   3.772  0.00028 ***
Inaltime_cm    1.9680     0.2273   8.658 1.13e-13 ***
Gen           -2.3479     6.1753  -0.380  0.70464

R² = 0.4833, R² ajustat = 0.4671

Comparare model cu/fara Gen (ANOVA):
  F = 0.1446, p = 0.7046
  Adaugarea Gen NU imbunatateste semnificativ modelul.

===========================================================================
1d. DIAGNOSTICE MODEL PEF
===========================================================================

Shapiro-Wilk: W = 0.9746, p = 0.05029 => Reziduurile sunt normal distribuite.
Breusch-Pagan: BP = 3.8829, p = 0.1435 => Homoscedasticitate respectata.
Durbin-Watson: DW = 1.7959, p = 0.1513 => Erorile sunt independente.
Cook's D > 4/n: 7 observatii
Cook's D maxim: 0.1562
Reziduuri standardizate |> 2|: 7 observatii

VIF:
 Varsta_ani Inaltime_cm
   1.000021    1.000021
  Toate VIF < 5: nu exista probleme de multicoliniaritate.

===========================================================================
1f. MODELE CU INTERACTIUNI PENTRU PEF
===========================================================================

--- PEF ~ Varsta_ani * Inaltime_cm ---
  Varsta_ani:Inaltime_cm: Estimate=-0.2686, t=-1.541, p=0.1266
  R² = 0.4950, Adj R² = 0.4792
  ANOVA vs model fara interactiune: F=2.3747, p=0.1266
  Interactiunea NU este semnificativa.

--- PEF ~ Varsta_ani * Gen ---
  Varsta_ani:Gen: Estimate=-0.1942, t=-0.037, p=0.9704
  R² = 0.0798, Adj R² = 0.0510
  ANOVA vs PEF~Varsta: F=0.1649, p=0.8482
  Interactiunea NU este semnificativa.

--- PEF ~ Inaltime_cm * Gen ---
  Inaltime_cm:Gen: Estimate=0.1363, t=0.267, p=0.7899
  R² = 0.4071, Adj R² = 0.3886
  ANOVA vs PEF~Inaltime: F=0.231, p=0.7942
  Interactiunea NU este semnificativa.

--- Model complet cu toate interactiunile ---
  PEF ~ Varsta*Inaltime + Varsta*Gen + Inaltime*Gen
  R² = 0.4958, Adj R² = 0.4633
  ANOVA vs Varsta+Inaltime: F=0.6143, p=0.6534
  Interactiunile impreuna NU imbunatatesc semnificativ modelul.

###################################################################
# ANALIZA 2: log10(FEV1) - Transformare logaritmica
###################################################################

===========================================================================
2a. NECESITATEA TRANSFORMARII log10(FEV1)
===========================================================================

--- Modelul original FEV1 ~ Inaltime_cm ---

R² = 1.000000
Avertisment: 'essentially perfect fit' - R² = 1.0000
FEV1 = -1 + 0.02 * Inaltime_cm (relatie determinista)

Shapiro-Wilk pe reziduurile modelului FEV1 ~ Varsta + Inaltime:
  W = 0.9418, p = 0.0002498
  Reziduurile NU sunt normal distribuite (artefact al fitului perfect).

Justificare transformare log10:
  - FEV1 are o relatie determinista cu Inaltimea (R² = 1.0)
  - Diagnosticele nu sunt interpretabile pe date netransformate
  - Transformarea log10 va produce un model cu reziduuri reale,
    permitind evaluarea semnificativa a conditiilor regresiei
  - log10 este o transformare standard pentru volume/debite respiratorii

===========================================================================
2b. STATISTICI DESCRIPTIVE log10(FEV1)
===========================================================================

--- log10(FEV1) ---
  N:        100
  NA:       0
  Media:    0.1364
  Mediana:  0.1399
  SD:       0.0881
  Min:      -0.1938
  Max:      0.3345
  Q1:       0.0774
  Q3:       0.2041
  IQR:      0.1268
  Outliers: 2
    Valori: -0.19382 -0.1191864

Shapiro-Wilk pe log10(FEV1):
  W = 0.9697, p = 0.02112
  log10(FEV1) NU urmeaza o distributie normala.

===========================================================================
2c. COMPARARE FEV1 ORIGINAL VS log10(FEV1)
===========================================================================

--- FEV1 ~ Inaltime (original) ---
  R² = 1.000000 (fit perfect)
  Shapiro-Wilk reziduuri: W = 0.9418, p = 0.0002498 (ESEC)

--- log10(FEV1) ~ Inaltime (transformat) ---
  R² = 0.9762
  Shapiro-Wilk reziduuri: W = 0.5841, p = 2.17e-15
  Reziduurile inca nu sunt normal distribuite, dar modelul e mai realist.

===========================================================================
2d. REGRESII SIMPLE PENTRU log10(FEV1)
===========================================================================

--- log10(FEV1) ~ Varsta_ani ---
  R² = 0.0001, p = 0.9207 (nesemnificativ)

--- log10(FEV1) ~ Inaltime_cm ---
  R² = 0.9762, p < 2.2e-16 (semnificativ)
  Coeficient Inaltime: 0.00641

--- log10(FEV1) ~ Gen ---
  R² = 0.0003, p = 0.856 (nesemnificativ)

===========================================================================
2e. REGRESIE MULTIPLA: log10(FEV1) ~ Varsta_ani + Inaltime_cm
===========================================================================

  R² = 0.9762, Adj R² = 0.9758
  F(2, 97) = 1993.17, p < 2.2e-16
  Ecuatia: log10(FEV1) = -0.6282 + (-0.0003) * Varsta + (0.0064) * Inaltime

  Interpretare (back-transform):
    +1 cm inaltime => FEV1 * 1.0149 (+1.49%)
    +10 cm inaltime => FEV1 * 1.1589 (+15.89%)
    +1 an varsta => FEV1 * 0.9993 (-0.07%, nesemnificativ)

===========================================================================
2f. REGRESIE MULTIPLA: log10(FEV1) ~ Varsta_ani + Inaltime_cm + Gen
===========================================================================

  R² = 0.9769, Adj R² = 0.9761
  Gen: p = 0.116 (nesemnificativ)
  ANOVA: F = 2.5166, p = 0.1159

===========================================================================
2g. DIAGNOSTICE MODEL log10(FEV1)
===========================================================================

  Shapiro-Wilk: W = 0.5902, p = 2.813e-15 (reziduuri nenormale)
  Breusch-Pagan: BP = 5.3078, p = 0.0704 (homoscedasticitate la limita)
  Durbin-Watson: DW = 1.9326, p = 0.366 (erorile sunt independente)
  Cook's D > 4/n: 6 observatii; Cook's D maxim = 1.5568
  VIF: Varsta=1.0, Inaltime=1.0

===========================================================================
2i. MODELE CU INTERACTIUNI PENTRU log10(FEV1)
===========================================================================

--- log10(FEV1) ~ Varsta * Inaltime ---
  Varsta:Inaltime: p = 0.744
  ANOVA: F=0.1075, p=0.7437 => NU semnificativ

--- log10(FEV1) ~ Varsta * Gen ---
  Varsta:Gen: p = 0.669
  ANOVA vs log10(FEV1)~Varsta: F=0.1098, p=0.8961 => NU semnificativ

--- log10(FEV1) ~ Inaltime * Gen ---
  Inaltime:Gen: p = 0.690
  ANOVA vs log10(FEV1)~Inaltime: F=1.376, p=0.2575 => NU semnificativ

###################################################################
# SUMAR GENERAL
###################################################################

Model PEF ~ Varsta + Inaltime:
  R² = 0.4825, Adj R² = 0.4718
  F = 45.2185, p = 1.333e-14

Model log10(FEV1) ~ Varsta + Inaltime:
  R² = 0.9762, Adj R² = 0.9758
  F = 1993.1689, p = < 2.2e-16

=== ANALIZA COMPLETA ===
```
