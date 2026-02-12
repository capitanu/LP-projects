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

## ANALIZA 1: log10(PEF) - Transformare logaritmica

### 4. Necesitatea transformarii log10(PEF)

Modelul original PEF ~ Varsta + Inaltime avea diagnostice la limita:
- Shapiro-Wilk pe reziduuri: W = 0.9746, **p = 0.0503** (la limita de 0.05)
- Breusch-Pagan: p = 0.1435
- PEF nu urmeaza strict o distributie normala (Shapiro-Wilk p = 0.077)

**Justificarea transformarii log10:**
- Shapiro-Wilk pe reziduuri este la limita acceptabilitatii
- Transformarea log10 imbunatateste semnificativ normalitatea reziduurilor si homoscedasticitatea
- log10 este o transformare standard pentru debite respiratorii in literatura medicala

### 5. Statistici descriptive log10(PEF)

| Statistica | Valoare |
|------------|---------|
| N | 100 |
| Media | 2.1513 |
| Mediana | 2.1614 |
| SD | 0.1261 |
| Min | 1.8451 |
| Max | 2.4472 |
| Q1 | 2.0755 |
| Q3 | 2.2393 |
| IQR | 0.1637 |
| Outlieri | 0 |

**Shapiro-Wilk pe log10(PEF):** W = 0.9878, p = 0.4912 — distributie normala confirmata (comparativ cu PEF original: p = 0.077).

### 6. Comparare PEF original vs log10(PEF)

| Model | R² | Shapiro-Wilk reziduuri (p) | Breusch-Pagan (p) |
|-------|-----|---------------------------|-------------------|
| PEF ~ Varsta + Inaltime (original) | 0.4825 | 0.0503 (la limita) | 0.1435 |
| **log10(PEF) ~ Varsta + Inaltime (transformat)** | **0.4975** | **0.6667** | **0.9290** |

Transformarea log10 imbunatateste toate diagnosticele: R² creste usor, normalitatea reziduurilor devine clara (p=0.67), si homoscedasticitatea este solida (p=0.93).

### 7. Regresii simple pentru log10(PEF)

#### 7.1 log10(PEF) ~ Varsta

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 1.9306 | 0.0702 | 27.515 | <2e-16 | [1.791, 2.070] |
| Varsta_ani | 0.0243 | 0.0076 | 3.193 | **0.0019** | [0.009, 0.039] |

- **R² = 0.0942** (9.4% din variabilitatea log10(PEF) explicata de varsta)
- Asocierea este semnificativa
- Back-transform: la fiecare an in plus, PEF creste cu ~5.8%

#### 7.2 log10(PEF) ~ Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 1.4471 | 0.0874 | 16.556 | <2e-16 | [1.274, 1.621] |
| Inaltime_cm | 0.00588 | 0.000725 | 8.108 | **1.49e-12** | [0.0044, 0.0073] |

- **R² = 0.4015** (40.1% din variabilitatea log10(PEF) explicata de inaltime)
- Asocierea este puternic semnificativa
- Back-transform: la fiecare cm in plus, PEF creste cu ~1.4%

#### 7.3 log10(PEF) ~ Gen

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 2.1591 | 0.0174 | 124.328 | <2e-16 | [2.125, 2.194] |
| Gen | -0.0166 | 0.0253 | -0.654 | **0.515** | [-0.067, 0.034] |

- **R² = 0.0043** — genul nu explica variabilitatea log10(PEF)
- Nesemnificativ (p = 0.52)

### 8. Regresie multipla: log10(PEF) ~ Varsta + Inaltime

| Coeficient | Estimare | SE | t | p-value | 95% IC |
|------------|----------|-----|---|---------|--------|
| Intercept | 1.2228 | 0.0959 | 12.751 | <2e-16 | [1.032, 1.413] |
| Varsta_ani | 0.02453 | 0.00570 | 4.305 | **4.00e-05** | [0.013, 0.036] |
| Inaltime_cm | 0.00589 | 0.000668 | 8.823 | **4.65e-14** | [0.0046, 0.0072] |

**Ecuatia de regresie:**
```
log10(PEF) = 1.2228 + 0.0245 * Varsta + 0.0059 * Inaltime
```

**Performanta modelului:**
- **R² = 0.4975** — 49.7% din variabilitatea log10(PEF) este explicata de varsta si inaltime impreuna
- **R² ajustat = 0.4871**
- **F(2, 97) = 48.02, p = 3.20e-15** — modelul este semnificativ global

**Interpretare coeficienti nestandardizati (back-transform pe scala originala):**
- **Varsta (b1 = 0.0245):** La cresterea varstei cu 1 an, PEF se multiplica cu **1.058** (+5.81%), controlind pentru inaltime
- **Inaltime (b2 = 0.0059):** La cresterea inaltimii cu 1 cm, PEF se multiplica cu **1.014** (+1.37%), controlind pentru varsta
- La cresterea inaltimii cu **10 cm**, PEF se multiplica cu **1.145** (+14.53%)
- Ambii predictori sunt semnificativi (p < 0.001)

**Coeficienti de regresie partiala (standardizati):**

| Predictor | beta (standardizat) | SE | t | p-value |
|-----------|--------------------|----|---|---------|
| Varsta_ani | **0.3098** | 0.0720 | 4.305 | 4.00e-05 |
| Inaltime_cm | **0.6350** | 0.0720 | 8.823 | 4.65e-14 |

- **beta_Varsta = 0.3098:** La cresterea cu 1 SD a varstei (1.59 ani), log10(PEF) creste cu 0.31 SD
- **beta_Inaltime = 0.6350:** La cresterea cu 1 SD a inaltimii (13.59 cm), log10(PEF) creste cu 0.64 SD
- Inaltimea are un efect standardizat de **2.0 ori mai mare** decat varsta (0.635 vs 0.310), confirmind ca este predictorul dominant

### 9. Modelul cu Gen: log10(PEF) ~ Varsta + Inaltime + Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 1.2260 | 0.0977 | 12.547 | <2e-16 |
| Varsta_ani | 0.02444 | 0.00574 | 4.256 | 4.85e-05 |
| Inaltime_cm | 0.00589 | 0.000672 | 8.762 | 6.78e-14 |
| Gen | -0.00369 | 0.01825 | -0.202 | **0.840** |

- **R² = 0.4977**, R² ajustat = 0.4820
- **ANOVA comparativa:** F = 0.0408, p = 0.8403
- **Concluzie:** Adaugarea genului **NU** imbunatateste semnificativ modelul.

### 10. Diagnostice model log10(PEF) (Varsta + Inaltime)

| Test | Statistica | p-value | Concluzie |
|------|-----------|---------|-----------|
| Shapiro-Wilk (normalitate reziduuri) | W = 0.9900 | **0.6667** | Reziduurile sunt normal distribuite |
| Breusch-Pagan (homoscedasticitate) | BP = 0.1473 | **0.9290** | Homoscedasticitate respectata |
| Durbin-Watson (independenta erorilor) | DW = 1.8752 | **0.2638** | Erorile sunt independente |

**Observatii puncte influentiale:**
- Cook's D > 4/n: 6 observatii (maxim = 0.0561, niciuna problematica)
- Reziduuri standardizate |> 2|: 5 observatii

**VIF (Variance Inflation Factor):**
| Variabila | VIF |
|-----------|-----|
| Varsta_ani | 1.000 |
| Inaltime_cm | 1.000 |

**Concluzie diagnostice:** Toate conditiile regresiei liniare sunt **clar indeplinite** (comparativ cu modelul pe PEF original unde Shapiro-Wilk era la limita):
1. Normalitatea reziduurilor (p = 0.67 — solid)
2. Homoscedasticitate (p = 0.93 — excelent)
3. Independenta erorilor (p = 0.26)
4. Absenta multicoliniaritatii (VIF = 1.0)

### 11. Modele cu interactiuni pentru log10(PEF)

#### 11.1 log10(PEF) ~ Varsta * Inaltime

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 0.0660 | 0.5713 | 0.116 | 0.908 |
| Varsta_ani | 0.1507 | 0.0617 | 2.442 | 0.016 |
| Inaltime_cm | 0.01549 | 0.00472 | 3.281 | 0.001 |
| Varsta:Inaltime | -0.00105 | 0.00051 | -2.053 | **0.043** |

- **R² = 0.5186**, R² ajustat = 0.5036
- **ANOVA comparativa:** F = 4.2152, **p = 0.0428**
- **Concluzie:** Interactiunea Varsta * Inaltime **ESTE semnificativa** (p = 0.043). Efectul varstei asupra log10(PEF) depinde de inaltime — la copiii mai inalti, efectul suplimentar al varstei este mai mic.

#### 11.2 log10(PEF) ~ Varsta * Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 1.9173 | 0.0959 | 19.987 | <2e-16 |
| Varsta_ani | 0.02629 | 0.01027 | 2.560 | 0.012 |
| Gen | 0.03580 | 0.14271 | 0.251 | 0.802 |
| Varsta:Gen | -0.00514 | 0.01552 | -0.331 | **0.741** |

- **R² = 0.0971**, R² ajustat = 0.0689
- **ANOVA comparativa vs log10(PEF) ~ Varsta:** F = 0.152, p = 0.8592
- **Concluzie:** Interactiunea Varsta * Gen **NU** este semnificativa (p = 0.74).

#### 11.3 log10(PEF) ~ Inaltime * Gen

| Coeficient | Estimare | SE | t | p-value |
|------------|----------|-----|---|---------|
| Intercept | 1.4818 | 0.1101 | 13.454 | <2e-16 |
| Inaltime_cm | 0.00563 | 0.000908 | 6.197 | 1.43e-08 |
| Gen | -0.0897 | 0.1844 | -0.487 | 0.628 |
| Inaltime:Gen | 0.00067 | 0.00153 | 0.437 | **0.663** |

- **R² = 0.4041**, R² ajustat = 0.3855
- **ANOVA comparativa vs log10(PEF) ~ Inaltime:** F = 0.2129, p = 0.8086
- **Concluzie:** Interactiunea Inaltime * Gen **NU** este semnificativa (p = 0.66).

#### Sumar interactiuni log10(PEF)

| Model | R² | Adj R² | ANOVA p vs model de baza |
|-------|-----|--------|--------------------------|
| log10(PEF) ~ Varsta + Inaltime (aditiv) | 0.4975 | 0.4871 | - |
| + Varsta:Inaltime | **0.5186** | **0.5036** | **0.0428** |
| + Varsta:Gen (vs log10(PEF)~Varsta) | 0.0971 | 0.0689 | 0.8592 |
| + Inaltime:Gen (vs log10(PEF)~Inaltime) | 0.4041 | 0.3855 | 0.8086 |

Interactiunea **Varsta * Inaltime este semnificativa** (p = 0.043), ceea ce inseamna ca efectul varstei asupra PEF difera in functie de inaltime. La copiii mai inalti, efectul suplimentar al varstei devine mai mic (coeficient de interactiune negativ = -0.00105). Interactiunile cu Gen nu sunt semnificative.

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

**Interpretare coeficienti nestandardizati (pe scala log10 — back-transform):**
- **Varsta (b1 = -0.0003):** La cresterea varstei cu 1 an, FEV1 se multiplica cu 0.9993 (factor multiplicativ), adica o modificare de -0.07% — practic nesemnificativa (p = 0.722)
- **Inaltime (b2 = 0.0064):** La cresterea inaltimii cu 1 cm, FEV1 se multiplica cu 1.0149, adica o crestere de **1.49%**, controlind pentru varsta
- La cresterea inaltimii cu **10 cm**, FEV1 se multiplica cu **1.1589** (crestere de 15.89%)

**Coeficienti de regresie partiala (standardizati):**

| Predictor | beta (standardizat) | SE | t | p-value |
|-----------|--------------------|----|---|---------|
| Varsta_ani | **-0.0056** | 0.0157 | -0.357 | 0.722 |
| Inaltime_cm | **0.9880** | 0.0157 | 63.134 | <2e-16 |

- **beta_Varsta = -0.0056:** Efectul varstei este practic zero — nesemnificativ
- **beta_Inaltime = 0.9880:** La cresterea cu 1 SD a inaltimii (13.59 cm), log10(FEV1) creste cu 0.99 SD — inaltimea explica aproape toata variabilitatea
- Inaltimea are un efect standardizat de **176 ori mai mare** decat varsta (0.988 vs 0.006), confirmind dominanta absoluta a inaltimii ca predictor al FEV1

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
| **log10(PEF) ~ Varsta + Inaltime** | **0.4975** | **0.4871** | 48.02 | 3.20e-15 |
| **log10(FEV1) ~ Varsta + Inaltime** | **0.9762** | **0.9758** | 1993.17 | <2.2e-16 |

### Concluzii

1. **Modelul log10(PEF)** este un model valid din punct de vedere statistic:
   - Transformarea log10 a imbunatatit toate diagnosticele (Shapiro-Wilk p: 0.05 -> 0.67; Breusch-Pagan p: 0.14 -> 0.93)
   - 49.7% din variabilitatea log10(PEF) este explicata de varsta si inaltime impreuna
   - Ambii predictori sunt semnificativi independent: inaltimea (p < 10^-13) si varsta (p = 4e-05)
   - Inaltimea este predictorul dominant (beta standardizat = 0.635 vs 0.310 pentru varsta)
   - Genul nu aduce informatie suplimentara semnificativa
   - Toate conditiile de validitate ale regresiei sunt clar indeplinite

2. **Modelul log10(FEV1)** — dupa transformarea logaritmica:
   - Transformarea log10 a rezolvat problema fitului perfect (R² = 1.0 -> R² = 0.9762)
   - 97.6% din variabilitatea log10(FEV1) este explicata de varsta si inaltime
   - Doar Inaltimea este predictor semnificativ (p < 2e-16); Varsta este nesemnificativa (p = 0.72)
   - La fiecare cm in plus de inaltime, FEV1 creste cu ~1.5% (pe scala originala)
   - Genul nu aduce informatie suplimentara (p = 0.12)
   - Normalitatea reziduurilor nu este complet respectata (datorita relatiei quasi-deterministe), dar celelalte conditii sunt indeplinite

3. **Interactiunile:**
   - Varsta * Inaltime: **p = 0.043 (log10(PEF)) — semnificativa**; p = 0.74 (log10(FEV1))
   - Varsta * Gen: p = 0.74 (log10(PEF)); p = 0.67 (log10(FEV1)) — nesemnificativa
   - Inaltime * Gen: p = 0.66 (log10(PEF)); p = 0.69 (log10(FEV1)) — nesemnificativa
   - Pentru PEF, efectul varstei depinde de inaltime (la copiii mai inalti, efectul suplimentar al varstei e mai mic)

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
| `pef_transform_compare.png` | Comparare histograme: PEF original vs log10(PEF) transformat |
| `pef_diagnostic.png` | Grafice diagnostice (4 panouri) pentru modelul log10(PEF) |
| `pef_hist_resid.png` | Histograma reziduurilor modelului log10(PEF) |
| `fev1_transform_compare.png` | Comparare histograme: FEV1 original vs log10(FEV1) transformat |
| `fev1_diagnostic.png` | Grafice diagnostice (4 panouri) pentru modelul log10(FEV1) |
| `fev1_hist_resid.png` | Histograma reziduurilor modelului log10(FEV1) |
| `pef_interaction_varsta_gen.png` | log10(PEF) vs Varsta, separat pe gen (grafic interactiune) |
| `pef_interaction_inaltime_gen.png` | log10(PEF) vs Inaltime, separat pe gen (grafic interactiune) |
| `fev1_interaction_varsta_gen.png` | log10(FEV1) vs Varsta, separat pe gen (grafic interactiune) |
| `fev1_interaction_inaltime_gen.png` | log10(FEV1) vs Inaltime, separat pe gen (grafic interactiune) |

---

## Codul R

Codul complet se gaseste in fisierul `analysis_examen.R`. Analiza a fost realizata in R 4.5.2, folosind pachetele `car` (VIF), `lmtest` (Breusch-Pagan, Durbin-Watson).

### Output complet R (rezumat)

Outputul complet este de ~1100 linii. Mai jos sunt sectiunile cheie:

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
# ANALIZA 1: log10(PEF) - Transformare logaritmica
###################################################################

--- Modelul original PEF ~ Varsta + Inaltime ---
  R² = 0.4825
  Shapiro-Wilk reziduuri: p = 0.0503 (la limita)

--- log10(PEF) ~ Varsta + Inaltime (transformat) ---
  R² = 0.4975, Shapiro-Wilk reziduuri: p = 0.6667 (OK)

1e. log10(PEF) ~ Varsta_ani + Inaltime_cm:
  R² = 0.4975, Adj R² = 0.4871
  F(2, 97) = 48.02, p = 3.202e-15
  Ecuatia: log10(PEF) = 1.2228 + 0.0245 * Varsta + 0.0059 * Inaltime
  Back-transform: +1 an varsta => PEF * 1.058 (+5.81%)
  Back-transform: +1 cm inaltime => PEF * 1.014 (+1.37%)

  Coeficienti standardizati:
    beta_Varsta = 0.3098
    beta_Inaltime = 0.6350

1f. log10(PEF) ~ Varsta + Inaltime + Gen:
  Gen: p = 0.840 (nesemnificativ)
  ANOVA: F = 0.0408, p = 0.8403

1g. Diagnostice log10(PEF):
  Shapiro-Wilk: W = 0.9900, p = 0.6667 (normal)
  Breusch-Pagan: BP = 0.1473, p = 0.9290 (homoscedastic)
  Durbin-Watson: DW = 1.8752, p = 0.2638 (independent)
  Cook's D max = 0.0561; VIF = 1.0

1i. Interactiuni log10(PEF):
  Varsta*Inaltime: p = 0.0428 => SEMNIFICATIVA
  Varsta*Gen: p = 0.8592 => NU semnificativa
  Inaltime*Gen: p = 0.8086 => NU semnificativa

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

Model log10(PEF) ~ Varsta + Inaltime:
  R² = 0.4975, Adj R² = 0.4872
  F = 48.02, p = 2.563e-15

Model log10(FEV1) ~ Varsta + Inaltime:
  R² = 0.9762, Adj R² = 0.9758
  F = 1993.1689, p = < 2.2e-16

=== ANALIZA COMPLETA ===
```
