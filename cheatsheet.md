# CHEAT SHEET - Corelație și Regresie Liniară (LP02-LP09)

---

## 1. CORELAȚIA LINIARĂ (LP02)

### Ce este?
Măsoară **intensitatea și direcția** relației liniare dintre 2 variabile cantitative.

### Coeficientul Pearson (r)
| Valoare | Interpretare |
|---|---|
| r = 0 | Fără corelație |
| 0 < \|r\| < 0.3 | Corelație slabă |
| 0.3 ≤ \|r\| < 0.7 | Corelație moderată |
| 0.7 ≤ \|r\| < 1.0 | Corelație puternică |
| r = 1 sau -1 | Corelație perfectă |
| r > 0 | Pozitivă (crește X → crește Y) |
| r < 0 | Negativă (crește X → scade Y) |

### Testul de semnificație
- **H0:** r = 0 (nu există corelație în populație)
- **H1:** r ≠ 0 (există corelație în populație)
- **Decizie:** p < 0.05 → respingem H0 → corelația e semnificativă

### Formulă interpretare:
> "Există o corelație [pozitivă/negativă] [slabă/moderată/puternică] și semnificativă statistic (r = ___, p = ___) între [X] și [Y]."

### Atenție:
- Corelație ≠ Cauzalitate!
- r de la corelatie = t de la regresia simplă → **același p-value**

---

## 2. REGRESIA LINIARĂ SIMPLĂ cu VI CANTITATIVĂ (LP03)

### Când se folosește?
- 1 VD cantitativă + 1 VI cantitativă
- Vrem să prezicem Y în funcție de X

### Modelul: Y = B0 + B1 × X + ε

| Coeficient | Ce înseamnă |
|---|---|
| B0 (intercept) | Valoarea estimată a lui Y când X = 0 |
| B1 (panta) | Cu cât se modifică Y la creșterea lui X cu 1 unitate |

### Ipoteze:
- **H0:** B1 = 0 (X nu influențează Y)
- **H1:** B1 ≠ 0 (X influențează Y)

### R² (coeficientul de determinare):
> "X explică ___% din variabilitatea lui Y."

### Formulă interpretare B1:
> "La fiecare creștere cu 1 [unitate X], [Y] crește/scade cu [B1] [unitate Y] (p = ___)."

### Exemplu (LP03):
> "La fiecare oră suplimentară de somn, IMC-ul scade cu 0.97 kg/m² (p < 0.001). Durata somnului explică 34% din variabilitatea IMC."

---

## 3. REGRESIA LINIARĂ SIMPLĂ cu VI CALITATIVĂ (LP04)

### A. VI dihotomială (2 categorii)
- Se codifică 0/1 (dummy coding)
- Categoria cu 0 = **referință**
- Echivalent cu **testul t independent**

### Modelul: Y = B0 + B1 × Grup + ε

| Coeficient | Ce înseamnă |
|---|---|
| B0 | Media lui Y la grupul de referință (cod=0) |
| B1 | Diferența de medie între grupuri |

### Formulă interpretare:
> "Grupul [1] are un [Y] cu [B1] [unități] mai mare/mic decât grupul [0] (p = ___)."

### Exemplu (LP04):
> "Persoanele cu somn <7h au un IMC cu 5.94 kg/m² mai mare decât cele cu somn ≥7h (p < 0.001)."

### B. VI cu 3+ categorii
- Se creează **k-1 variabile dummy** (k = nr categorii)
- O categorie = referință
- Echivalent cu **ANOVA one-way**

### Modelul: Y = B0 + B1 × Dummy1 + B2 × Dummy2 + ε

| Coeficient | Ce înseamnă |
|---|---|
| B0 | Media la categoria de referință |
| B1 | Diferența categoriei 1 față de referință |
| B2 | Diferența categoriei 2 față de referință |

### Post-hoc (Tukey HSD):
- Se folosește pentru a compara **fiecare pereche** de categorii
- Controlează eroarea de tip I la comparații multiple

---

## 4. REGRESIA LINIARĂ MULTIPLĂ (LP05)

### Când se folosește?
- 1 VD cantitativă + **2+ VI** (cantitative sau calitative)
- Vrem să evaluăm efectul unei VI **controlând** pentru celelalte

### Modelul: Y = B0 + B1×X1 + B2×X2 + ... + ε

### Testul F (global):
- **H0:** toți B = 0 (modelul nu e util)
- **H1:** cel puțin un B ≠ 0
- p < 0.05 → modelul e semnificativ

### Teste individuale (t):
- **H0:** Bi = 0 (Vi nu contribuie semnificativ)
- **H1:** Bi ≠ 0

### Coeficienți nestandardizați (B) vs standardizați (Beta):
| Tip | Utilizare |
|---|---|
| B (nestandardizat) | Interpretare în unități originale |
| Beta (standardizat) | Compararea importanței relative a VI |

### Formulă interpretare B (multiplu):
> "La fiecare creștere cu 1 [unitate Xi], [Y] crește/scade cu [Bi] [unitate Y], **controlând pentru celelalte variabile** (p = ___)."

### R² ajustat:
- Se folosește în loc de R² simplu (penalizează nr de variabile)
- R² ajustat > R² simplu → model mai eficient

---

## 5. REGRESIA MULTIPLĂ CU INTERACȚIUNE (LP06)

### Când se folosește?
- Când efectul unei VI asupra VD **diferă** în funcție de altă VI
- VI moderatoare = modifică relația dintre altă VI și VD

### Modelul: Y = B0 + B1×X1 + B2×X2 + B3×(X1·X2) + ε

| Coeficient | Ce înseamnă |
|---|---|
| B0 | Y când X1=0 și X2=0 |
| B1 | Efectul X1 când X2=0 |
| B2 | Efectul X2 când X1=0 |
| **B3 (interacțiune)** | **Cu cât se modifică efectul lui X1 pentru fiecare unitate de X2** |

### Formulă interpretare interacțiune:
> "Efectul [X1] asupra [Y] diferă semnificativ în funcție de [X2] (B_interacțiune = ___, p = ___). Efectul [X1] la [X2=0] este [B1], iar la [X2=1] este [B1+B3]."

### Compararea modelelor nested (ANOVA):
- Model 1 (fără interacțiune) vs Model 2 (cu interacțiune)
- p < 0.05 → modelul cu interacțiune e semnificativ mai bun

### Exemplu (LP06):
> "Efectul vârstei asupra cGIM e mai mare la bărbați (0.032 mm/an) decât la femei (0.023 mm/an), interacțiune semnificativă (p = 0.026)."

---

## 6. SELECȚIA VARIABILELOR (LP07)

### Când se folosește?
- Când ai **mulți predictori** și vrei modelul optim (parsimonios)

### Metode:

| Metodă | Pornire | Direcție |
|---|---|---|
| **Backward** | Model complet → elimină pe rând | Scoate variabilele nesemnificative |
| **Forward** | Model gol → adaugă pe rând | Adaugă variabilele semnificative |
| **Stepwise** | Model gol → adaugă/elimină | Combinație |

### Criteriu de selecție: **AIC** (Akaike Information Criterion)
- AIC mai mic = model mai bun
- Echilibru între fit și complexitate

### Multicoliniaritate (VIF):
| VIF | Interpretare |
|---|---|
| VIF < 5 | Acceptabil |
| 5 ≤ VIF < 10 | Problematic |
| VIF ≥ 10 | Multicoliniaritate severă |

### Când apare multicoliniaritate:
- Variabile puternic corelate între ele (r > 0.7)
- Soluție: elimină una din variabilele corelate

---

## 7. REGRESIA PE DATE TRANSFORMATE (LP08)

### Când se folosește transformarea log?
- VD are distribuție **asimetrică pozitivă** (skewed right)
- Prezența **outlierilor** extremi
- Shapiro-Wilk respinge normalitatea pe datele brute

### Transformare: Y' = log₁₀(Y)

### Interpretare coeficienților pe scara log₁₀:
> "La fiecare creștere cu 1 unitate a Xi, Y crește cu un factor de **10^Bi** = ___."

| B (pe log10) | Factor multiplicativ | Interpretare |
|---|---|---|
| B = 0.1 | 10^0.1 = 1.26 | Y crește cu 26% |
| B = 0.05 | 10^0.05 = 1.12 | Y crește cu 12% |
| B = -0.1 | 10^-0.1 = 0.79 | Y scade cu 21% |

### Formulă interpretare:
> "La fiecare creștere cu 1 unitate a [X], [Y] crește cu un factor de [10^B] (adică cu [___]%), controlând pentru celelalte variabile."

---

## 8. VALIDAREA MODELULUI (LP09)

### A. Train/Test Split (70%/30%)

**Etape:**
1. Împarte datele: 70% antrenare, 30% testare
2. Construiește modelul pe setul de antrenare
3. Prezice pe setul de testare
4. Compară R² și RMSE pe ambele seturi

**Interpretare:**
- R² train ≈ R² test → **model stabil, fără overfitting**
- R² train >> R² test → **overfitting** (modelul memorează datele)
- RMSE train ≈ RMSE test → eroare de predicție stabilă

### B. k-fold Cross-Validation

**Etape:**
1. Împarte datele în k subseturi (k = 5 sau 10)
2. Pentru fiecare fold: antrenează pe k-1 folduri, testează pe al k-lea
3. Calculează R², RMSE pe fiecare fold
4. Media = estimarea performanței

**Avantaje vs Train/Test Split:**
- Folosește **toate** datele atât pentru antrenare cât și testare
- Estimare mai stabilă a performanței
- Mai puțin dependent de împărțirea aleatoare

### Metrici de performanță:

| Metrică | Formula | Interpretare |
|---|---|---|
| **R²** | 1 - SS_res/SS_tot | % din variabilitate explicată |
| **RMSE** | √(media(rezid²)) | Eroarea medie de predicție (aceleași unități ca Y) |
| **MAE** | media(\|rezid\|) | Eroarea medie absolută |

---

## 9. DIAGNOSTICELE MODELULUI (toate LP-urile)

### Asumpțiile regresiei liniare:

| Asumpție | Test | Criteriu | Ce faci dacă e încălcată |
|---|---|---|---|
| **Liniaritate** | Grafic Residuals vs Fitted | Fără pattern sistematic | Transformare variabile, termen pătratic |
| **Normalitatea reziduurilor** | Shapiro-Wilk, Q-Q plot | p > 0.05 | Transformare log, n > 30 → robust |
| **Homoscedasticitatea** | Breusch-Pagan, Scale-Location | p > 0.05 | Transformare, robust SE |
| **Independența erorilor** | Durbin-Watson | DW ≈ 2 (p > 0.05) | Date longitudinale → alt model |
| **Fără multicoliniaritate** | VIF | VIF < 5 | Elimină variabile corelate |

### Outlieri și puncte influente:
- **Cook's Distance > 4/n** → punct potențial influent
- **Cook's D > 1** → punct foarte influent (rar)
- **Leverage** mare + reziduu mare = punct influent periculos

### Graficele de diagnostic:
1. **Residuals vs Fitted** → verifică liniaritate + homoscedasticitate
2. **Normal Q-Q** → verifică normalitatea (puncte pe linia diagonală = OK)
3. **Scale-Location** → verifică homoscedasticitatea (linie orizontală = OK)
4. **Cook's Distance** → identifică puncte influente
5. **Residuals vs Leverage** → combină leverage + reziduuri

---

## 10. TABEL SINOPTIC - CE METODĂ FOLOSESC?

| Situație | Metodă | LP |
|---|---|---|
| 1 VD cantitativă + 1 VI cantitativă | Regresie liniară simplă | LP03 |
| 1 VD cantitativă + 1 VI dihotomială | Regresie simplă (= test t) | LP04 |
| 1 VD cantitativă + 1 VI cu 3+ categorii | Regresie simplă cu dummy (= ANOVA) | LP04 |
| 1 VD cantitativă + 2+ VI cantitative | Regresie multiplă | LP05 |
| Efectul unei VI diferă pe grupuri | Regresie cu interacțiune | LP06 |
| Mulți predictori, vrei modelul optim | Selecție variabile (backward/forward) | LP07 |
| VD asimetrică, outlieri | Transformare log + regresie | LP08 |
| Vrei să verifici dacă modelul generalizează | Validare train/test, cross-validation | LP09 |

---

## 11. ȘABLOANE DE INTERPRETARE

### Corelație:
> "Există o corelație [direcție] [intensitate] și [semnificativă/nesemnificativă] (r = ___, p = ___) între [X] și [Y]."

### Regresie simplă:
> "La fiecare creștere cu 1 [unitate X], [Y] [crește/scade] cu [B1] [unitate Y] (IC 95%: [low, up], p = ___). [X] explică [R²]% din variabilitatea [Y]."

### Regresie multiplă:
> "Controlând pentru [celelalte variabile], la fiecare creștere cu 1 [unitate Xi], [Y] [crește/scade] cu [Bi] [unitate Y] (p = ___)."

### Interacțiune semnificativă:
> "Efectul [X1] asupra [Y] diferă semnificativ în funcție de [X2] (B_interacțiune = ___, p = ___). La [X2=ref], efectul e [B1]; la [X2=1], efectul e [B1+B3]."

### Validare:
> "Performanța modelului pe setul de testare (R² = ___, RMSE = ___) este [comparabilă/diferită] cu cea de pe antrenare, indicând [absența/prezența] supraajustării."

---

## 12. GREȘELI FRECVENTE DE EVITAT

1. **Corelație ≠ Cauzalitate** - doar relație, nu cauză-efect
2. **p < 0.05 ≠ efect mare** - poate fi semnificativ dar mic (R² scăzut)
3. **R² mare ≠ model bun** - verifică diagnosticele!
4. **B nestandardizat ≠ importanță** - folosește Beta pentru comparare
5. **Intercept fără sens** - când X=0 nu e plauzibil, nu interpreta B0
6. **VIF mare → nu elimina oricum** - elimină una din variabilele corelate
7. **Shapiro-Wilk p < 0.05 la n > 30** - modelul e robust (teorema limitei centrale)
8. **Variabilă nesemnificativă în model multiplu** - poate fi semnificativă univariat (confundare!)
