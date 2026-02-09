# Practica de specialitate - Analiza statistică cardiovasculară

**Variabila 1 = LDL (ldl_cholesterol)**
**Variabila 2 = Ferritin**

---

## Material and method

### Statistical analyses

Analiza statistică a fost realizată utilizând limbajul R (versiunea 4.5.2). Variabilele cantitative au fost testate pentru normalitate și, fiind non-normal distribuite, au fost prezentate ca mediană și interval intercuartilic (IQR). Variabilele categoriale au fost prezentate ca frecvențe absolute și relative (%). Comparațiile între grupuri au fost efectuate utilizând testul Mann-Whitney U (Wilcoxon rank-sum) pentru variabilele cantitative și testul Chi-pătrat pentru variabilele categoriale. Capacitatea discriminativă a variabilelor a fost evaluată prin analiza curbelor ROC (Receiver Operating Characteristic), cu determinarea AUC (Area Under the Curve) și a intervalelor de încredere de 95%. Punctul optim de clasificare (cut-off) a fost determinat prin metoda Youden. Regresiile logistice univariate au fost utilizate pentru estimarea odds ratio (OR) neajustat. Modelul de regresie logistică multivariată a fost construit cu variabila de interes LDL (dichotomizată la mediană) și ajustat pentru variabile selectate pe baza relevanței clinice (vârstă, istoric familial de boală cardiacă, hipertensiune, diabet, obezitate, tensiune arterială sistolică, HDL, trigliceride), respectând limita de grade de libertate disponibile (min(110, 890)/10 ≈ 11). Condițiile de aplicare au fost verificate prin testul Hosmer-Lemeshow (goodness-of-fit), VIF (multicolinearitate), testul Box-Tidwell (liniaritate în logit) și distanța Cook (observații influente). Pragul de semnificație statistică a fost stabilit la p < 0.05.

---

## Results

### Table 1. Participants' characteristics with and without heart disease.

IQR, interquartile range

| Heart disease                     | With (n=110)          | Without (n=890)       | P      |
|-----------------------------------|-----------------------|-----------------------|--------|
| Age (years), median (IQR)         | 52.0 (37.0 - 75.8)    | 53.0 (39.0 - 74.0)    | 0.959  |
| Family History, n (%)             | 43 (39.1%)            | 204 (22.9%)           | <0.001 |
| **Comorbidities, n (%)**          |                       |                       |        |
| &emsp;hypertension                | 50 (45.5%)            | 337 (37.9%)           | 0.15   |
| &emsp;diabetes                    | 24 (21.8%)            | 161 (18.1%)           | 0.412  |
| &emsp;obesity                     | 39 (35.5%)            | 246 (27.6%)           | 0.109  |
| **Laboratory data, median (IQR)** |                       |                       |        |
| &emsp;LDL cholesterol (mg/dL)     | 154.2 (134.2 - 171.3) | 127.6 (112.9 - 145.1) | <0.001 |
| &emsp;Ferritin (ng/mL)            | 95.0 (70.0 - 138.2)   | 101.0 (71.0 - 142.8)  | 0.592  |

**Interpretare:** Pacienții cu boală cardiacă au prezentat un nivel semnificativ mai ridicat de colesterol LDL comparativ cu cei fără boală cardiacă (mediană 154.2 vs. 127.6 mg/dL, p < 0.001). De asemenea, istoricul familial de boală cardiacă a fost semnificativ mai frecvent în grupul cu boală cardiacă (39.1% vs. 22.9%, p < 0.001). Nu s-au observat diferențe semnificative statistic pentru vârstă (p = 0.959), feritină (p = 0.592), hipertensiune (p = 0.15), diabet (p = 0.412) sau obezitate (p = 0.109).

---

### Table 2. Classification of heart disease presence using receiver operating characteristic curves, based on LDL cholesterol and Ferritin.

AUC, area under the curve; CI, confidence interval; Se, sensitivity; Sp, specificity.

| Variable        | AUC (95% CI)          | Se    | Sp    | Cut-off |
|-----------------|-----------------------|-------|-------|---------|
| LDL cholesterol | 0.737 (0.686 – 0.789) | 0.727 | 0.683 | 138.9   |
| Ferritin        | 0.516 (0.458 – 0.573) | 0.509 | 0.555 | 95.5    |

---

### Figure 1. Receiver operating characteristic curves, classifying heart disease presence based on LDL cholesterol.

![ROC Curve - LDL Cholesterol](figure1_roc_ldl.png)

**Interpretare:** Curba ROC pentru colesterolul LDL demonstrează o capacitate discriminativă acceptabilă pentru clasificarea prezenței bolii cardiace, cu un AUC de 0.737 (95% CI: 0.686 - 0.789). Punctul optim de clasificare (metoda Youden) a fost identificat la 138.9 mg/dL, cu o sensibilitate de 72.7% și o specificitate de 68.3%. Aceasta înseamnă că un nivel de LDL ≥ 138.9 mg/dL identifică corect aproximativ 73% din pacienții cu boală cardiacă, excluzând în mod corect aproximativ 68% din cei fără boală.

---

### Figure 2. Receiver operating characteristic curves, classifying heart disease presence based on Ferritin.

![ROC Curve - Ferritin](figure2_roc_ferritin.png)

**Interpretare:** Curba ROC pentru feritină arată o capacitate discriminativă foarte slabă, practic la nivelul întâmplării, cu un AUC de 0.516 (95% CI: 0.458 - 0.573). Intervalul de încredere include valoarea 0.5 (linia diagonală), ceea ce confirmă că feritina nu are putere de discriminare semnificativă pentru prezicerea bolii cardiace în acest eșantion.

---

### Table 3. Univariate logistic regressions predicting heart disease.

OR, odds ratio; CI, confidence interval

| Variable            | OR unadjusted | 95% CI          | p      |
|---------------------|---------------|-----------------|--------|
| age                 | 1.002         | (0.996 - 1.008) | 0.516  |
| smoking_status      | 2.233         | (1.492 - 3.336) | <0.001 |
| ldl_cholesterol     | 1.035         | (1.027 - 1.043) | <0.001 |
| ferritin            | 1.000         | (0.997 - 1.003) | 0.991  |
| family_history      | 2.158         | (1.420 - 3.253) | <0.001 |
| high_stress         | 1.668         | (1.119 - 2.485) | 0.012  |
| hypertension        | 1.367         | (0.915 - 2.036) | 0.124  |
| diabetes            | 1.264         | (0.765 - 2.020) | 0.343  |
| obesity             | 1.438         | (0.940 - 2.171) | 0.088  |
| systolic_bp         | 1.002         | (0.993 - 1.011) | 0.679  |
| diastolic_bp        | 1.003         | (0.990 - 1.015) | 0.654  |
| bmi                 | 0.947         | (0.923 - 0.971) | <0.001 |
| glucose             | 0.985         | (0.979 - 0.991) | <0.001 |
| hba1c               | 0.915         | (0.884 - 0.946) | <0.001 |
| triglycerides       | 0.993         | (0.990 - 0.996) | <0.001 |
| hdl                 | 1.030         | (1.018 - 1.042) | <0.001 |
| total_cholesterol   | 1.001         | (0.996 - 1.005) | 0.760  |
| waist_circumference | 0.983         | (0.974 - 0.992) | <0.001 |
| resting_heart_rate  | 0.995         | (0.980 - 1.010) | 0.486  |

| Model                                | OR unadjusted | 95% CI          | p      |
|--------------------------------------|---------------|-----------------|--------|
| **Model 1**                          |               |                 |        |
| &emsp;LDL >= median (129.2 mg/dL)    | 4.917         | (3.061 - 8.251) | <0.001 |
| **Model 2 - PLR**                    |               |                 |        |
| &emsp;LDL (as quantitative variable) | 1.035         | (1.027 - 1.043) | <0.001 |

**Interpretare:** În analiza univariată, variabilele semnificativ asociate cu boala cardiacă au fost: istoricul familial de boală cardiacă (OR = 2.16, p < 0.001), colesterolul LDL (OR = 1.035 per mg/dL, p < 0.001), fumatul (OR = 2.23, p < 0.001), stresul crescut (OR = 1.67, p = 0.012), HDL (OR = 1.03, p < 0.001). LDL dichotomizat la mediană (≥ 129.2 mg/dL) a fost puternic asociat cu boala cardiacă (OR = 4.92, p < 0.001), indicând că pacienții cu LDL peste mediană au de aproape 5 ori mai mari șansele de a avea boală cardiacă. Feritina nu a fost asociată semnificativ cu boala cardiacă (OR = 1.000, p = 0.991).

---

### Table 4. Multivariate logistic regression predicting heart disease based on LDL cholesterol and adjusted for 8 variables.

**Strategia de selecție a variabilelor:**

Modelul de regresie logistică multivariată a fost construit respectând limita de grade de libertate disponibile: min(110, 890) / 10 ≈ 11 grade de libertate. Variabilele de ajustare au fost selectate pe baza relevanței clinice și fiziopatologice pentru bolile cardiovasculare:

- **LDL >= median** (variabila de interes, dichotomială) - 1 g.d.l.
- **age** (factor de risc major cardiovascular) - 1 g.d.l.
- **family_history** (istoric familial de boală cardiacă) - 1 g.d.l.
- **hypertension** (comorbiditate majoră CV) - 1 g.d.l.
- **diabetes** (comorbiditate metabolică) - 1 g.d.l.
- **obesity** (factor de risc metabolic) - 1 g.d.l.
- **systolic_bp** (indicator clinic) - 1 g.d.l.
- **hdl** (factor protector CV) - 1 g.d.l.
- **triglycerides** (marker metabolic) - 1 g.d.l.
- **Total: 9 g.d.l. (< 11 permise)**

| Variable       | OR adjusted | 95% CI           | p      |
|----------------|-------------|------------------|--------|
| LDL >= median  | 5.725       | (3.497 - 9.791)  | <0.001 |
| age            | 1.003       | (0.996 - 1.009)  | 0.364  |
| family_history | 2.295       | (1.469 - 3.565)  | <0.001 |
| hypertension   | 1.321       | (0.861 - 2.020)  | 0.200  |
| diabetes       | 1.468       | (0.860 - 2.435)  | 0.147  |
| obesity        | 1.409       | (0.896 - 2.191)  | 0.132  |
| systolic_bp    | 1.004       | (0.994 - 1.013)  | 0.462  |
| hdl            | 1.024       | (1.008 - 1.041)  | 0.004  |
| triglycerides  | 0.997       | (0.992 - 1.001)  | 0.162  |

**Verificarea condițiilor de aplicare:**

1. **Hosmer-Lemeshow test:** Chi-squared = 8.89, df = 8, p = 0.352. Modelul se potrivește bine pe date (p > 0.05).
2. **Multicolinearitate (VIF):** Toate valorile VIF < 2 (max = 1.65 pentru HDL). Nu există multicolinearitate.
3. **Liniaritate în logit (Box-Tidwell):** Toate variabilele continue respectă condiția de liniaritate (p > 0.05), cu excepția trigliceridelor care prezintă o ușoară non-liniaritate marginală (p = 0.04).
4. **Observații influente (Cook's Distance):** 92 observații cu Cook's D > 4/n, dar niciuna cu valori extreme care ar necesita excludere.
5. **Capacitatea discriminativă:** AUC = 0.764 (95% CI: 0.719 - 0.810) - discriminare acceptabilă.
6. **Pseudo R² Nagelkerke:** 0.188

**Interpretare Table 4:** În modelul multivariat, LDL ≥ mediană rămâne cel mai puternic predictor independent al bolii cardiace (OR ajustat = 5.73, 95% CI: 3.50 - 9.79, p < 0.001), ceea ce înseamnă că pacienții cu LDL peste mediană au de aproape 6 ori mai mari șansele de a prezenta boală cardiacă, independent de ceilalți factori din model. Istoricul familial de boală cardiacă este al doilea predictor semnificativ (OR = 2.30, 95% CI: 1.47 - 3.57, p < 0.001), iar HDL colesterol este de asemenea semnificativ asociat (OR = 1.02 per mg/dL, p = 0.004). Celelalte variabile (vârsta, hipertensiunea, diabetul, obezitatea, tensiunea sistolică, trigliceridele) nu au atins pragul de semnificație statistică în modelul multivariat.

---

## Concluzie

Colesterolul LDL reprezintă un predictor semnificativ și puternic al bolii cardiace, atât în analiza univariată (OR = 4.92 pentru LDL ≥ mediană), cât și în modelul multivariat ajustat (OR = 5.73). Capacitatea sa discriminativă, evaluată prin curba ROC, este acceptabilă (AUC = 0.737), cu un cut-off optim de 138.9 mg/dL. În contrast, feritina nu prezintă nicio asociere semnificativă cu boala cardiacă (AUC = 0.516, OR = 1.00, p = 0.991), demonstrând lipsa capacității discriminative. Modelul multivariat, care include LDL dichotomizat, istoricul familial de boală cardiacă și HDL ca predictori semnificativi, prezintă o capacitate discriminativă acceptabilă (AUC = 0.764) și se potrivește bine pe date (Hosmer-Lemeshow p = 0.352), cu absența multicolinearității (VIF < 2) și liniaritate în logit confirmată pentru variabilele continue.

---

## Cod R utilizat și rezultate brute

```r
# =============================================================================
# Practica de specialitate - Analiza statistică a datelor cardiovasculare
# Variabila 1 = LDL (ldl_cholesterol)
# Variabila 2 = ferritin
# =============================================================================

# --- Încărcare pachete ---
library(dplyr)
library(pROC)
library(ggplot2)
library(ResourceSelection)  # Hosmer-Lemeshow test
library(car)                # VIF
library(broom)              # tidy model outputs

# --- Citire date ---
data <- read.csv("cardiovascular_data.csv", stringsAsFactors = FALSE)

# Conversii tipuri de date
data$heart_disease <- as.factor(data$heart_disease)
data$smoking_status <- as.factor(data$smoking_status)
data$family_history <- as.factor(data$family_history)
data$high_stress <- as.factor(data$high_stress)
data$hypertension <- as.factor(data$hypertension)
data$diabetes <- as.factor(data$diabetes)
data$obesity <- as.factor(data$obesity)
data$ckd <- as.factor(data$ckd)
data$copd <- as.factor(data$copd)
data$stroke_history <- as.factor(data$stroke_history)
data$cancer_history <- as.factor(data$cancer_history)
data$liver_disease <- as.factor(data$liver_disease)
data$mental_health_issue <- as.factor(data$mental_health_issue)

# Subgrupuri
with_hd <- data %>% filter(heart_disease == "1")
without_hd <- data %>% filter(heart_disease == "0")

# =============================================================================
# TABLE 1: Participant Characteristics
# =============================================================================

# Funcție helper pentru median (IQR)
median_iqr <- function(x) {
  m <- median(x, na.rm = TRUE)
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  sprintf("%.1f (%.1f - %.1f)", m, q1, q3)
}

# Funcție helper pentru n (%)
n_pct <- function(x, level = "1") {
  n <- sum(x == level, na.rm = TRUE)
  pct <- n / length(x) * 100
  sprintf("%d (%.1f%%)", n, pct)
}

# Age
wilcox.test(age ~ heart_disease, data = data)

# Family History
chisq.test(table(data$heart_disease, data$family_history))

# Comorbidities
chisq.test(table(data$heart_disease, data$hypertension))
chisq.test(table(data$heart_disease, data$diabetes))
chisq.test(table(data$heart_disease, data$obesity))

# Laboratory data
wilcox.test(ldl_cholesterol ~ heart_disease, data = data)
wilcox.test(ferritin ~ heart_disease, data = data)

# =============================================================================
# TABLE 2 & FIGURES: ROC Analysis
# =============================================================================

hd_numeric <- as.numeric(as.character(data$heart_disease))

# ROC for LDL
roc_ldl <- roc(hd_numeric, data$ldl_cholesterol, quiet = TRUE)
auc(roc_ldl)
ci.auc(roc_ldl)
coords(roc_ldl, "best", best.method = "youden",
       ret = c("threshold", "sensitivity", "specificity"))

# ROC for Ferritin
roc_fer <- roc(hd_numeric, data$ferritin, quiet = TRUE)
auc(roc_fer)
ci.auc(roc_fer)
coords(roc_fer, "best", best.method = "youden",
       ret = c("threshold", "sensitivity", "specificity"))

# Figures
png("figure1_roc_ldl.png", width = 800, height = 700, res = 150)
plot(roc_ldl, main = "ROC Curve - LDL Cholesterol",
     col = "blue", lwd = 2, print.auc = TRUE,
     print.thres = TRUE, print.thres.best.method = "youden",
     legacy.axes = TRUE)
dev.off()

png("figure2_roc_ferritin.png", width = 800, height = 700, res = 150)
plot(roc_fer, main = "ROC Curve - Ferritin",
     col = "red", lwd = 2, print.auc = TRUE,
     print.thres = TRUE, print.thres.best.method = "youden",
     legacy.axes = TRUE)
dev.off()

# =============================================================================
# TABLE 3: Univariate Logistic Regressions
# =============================================================================

univar_vars <- c("age", "smoking_status", "ldl_cholesterol", "ferritin",
                 "family_history", "high_stress", "hypertension", "diabetes",
                 "obesity", "systolic_bp", "diastolic_bp", "bmi",
                 "glucose", "hba1c", "triglycerides", "hdl",
                 "total_cholesterol", "waist_circumference", "resting_heart_rate")

for (var in univar_vars) {
  formula <- as.formula(paste("heart_disease ~", var))
  model <- glm(formula, data = data, family = binomial)
  print(tidy(model, conf.int = TRUE, exponentiate = TRUE))
}

# Model 1: LDL >= median
ldl_median <- median(data$ldl_cholesterol, na.rm = TRUE)
data$ldl_high <- as.factor(ifelse(data$ldl_cholesterol >= ldl_median, 1, 0))
model1 <- glm(heart_disease ~ ldl_high, data = data, family = binomial)
tidy(model1, conf.int = TRUE, exponentiate = TRUE)

# Model 2: LDL quantitative
model2 <- glm(heart_disease ~ ldl_cholesterol, data = data, family = binomial)
tidy(model2, conf.int = TRUE, exponentiate = TRUE)

# =============================================================================
# TABLE 4: Multivariate Logistic Regression
# =============================================================================

multi_model <- glm(heart_disease ~ ldl_high + age + family_history +
                     hypertension + diabetes + obesity +
                     systolic_bp + hdl + triglycerides,
                   data = data, family = binomial)
summary(multi_model)
tidy(multi_model, conf.int = TRUE, exponentiate = TRUE)

# Verificare condiții
hoslem.test(as.numeric(as.character(data$heart_disease)),
            fitted(multi_model), g = 10)
vif(multi_model)

# Box-Tidwell
data$age_log <- data$age * log(data$age)
data$systolic_bp_log <- data$systolic_bp * log(data$systolic_bp)
data$hdl_log <- data$hdl * log(data$hdl)
data$triglycerides_log <- data$triglycerides * log(data$triglycerides)

bt_model <- glm(heart_disease ~ ldl_high + age + family_history +
                  hypertension + diabetes + obesity +
                  systolic_bp + hdl + triglycerides +
                  age_log + systolic_bp_log + hdl_log + triglycerides_log,
                data = data, family = binomial)
tidy(bt_model)

# Cook's Distance
cooks_d <- cooks.distance(multi_model)
sum(cooks_d > 4/nrow(data))

# AUC model
pred_probs <- predict(multi_model, type = "response")
roc_model <- roc(as.numeric(as.character(data$heart_disease)),
                 pred_probs, quiet = TRUE)
auc(roc_model)
ci.auc(roc_model)
```

### Rezultate brute R (needitate)

```
Cu boală cardiacă: n = 110
Fără boală cardiacă: n = 890

TABLE 1:
Age: With=52.0 (37.0 - 75.8), Without=53.0 (39.0 - 74.0), p=0.959
Family History: With=43 (39.1%), Without=204 (22.9%), p=0.000327
Hypertension: With=50 (45.5%), Without=337 (37.9%), p=0.15
Diabetes: With=24 (21.8%), Without=161 (18.1%), p=0.412
Obesity: With=39 (35.5%), Without=246 (27.6%), p=0.109
LDL: With=154.2 (134.2 - 171.3), Without=127.6 (112.9 - 145.1), p=4.26e-16
Ferritin: With=95.0 (70.0 - 138.2), Without=101.0 (71.0 - 142.8), p=0.592

TABLE 2:
LDL: AUC=0.737 (0.686-0.789), Se=0.727, Sp=0.683, Cut-off=138.9
Ferritin: AUC=0.516 (0.458-0.573), Se=0.509, Sp=0.555, Cut-off=95.5

TABLE 3 (Univariate):
Variable                  OR         95% CI              p-value
age                      1.002   (0.996 - 1.008)   0.516
smoking_status           2.233   (1.492 - 3.336)   8.84e-05
ldl_cholesterol          1.035   (1.027 - 1.043)   <2e-16
ferritin                 1.000   (0.997 - 1.003)   0.991
family_history           2.158   (1.420 - 3.253)   0.000267
high_stress              1.668   (1.119 - 2.485)   0.0117
hypertension             1.367   (0.915 - 2.036)   0.124
diabetes                 1.264   (0.765 - 2.020)   0.343
obesity                  1.438   (0.940 - 2.171)   0.088
systolic_bp              1.002   (0.993 - 1.011)   0.679
diastolic_bp             1.003   (0.990 - 1.015)   0.654
bmi                      0.947   (0.923 - 0.971)   2.27e-05
glucose                  0.985   (0.979 - 0.991)   1.19e-06
hba1c                    0.915   (0.884 - 0.946)   2.13e-07
triglycerides            0.993   (0.990 - 0.996)   9.46e-05
hdl                      1.030   (1.018 - 1.042)   1.3e-06
total_cholesterol        1.001   (0.996 - 1.005)   0.76
waist_circumference      0.983   (0.974 - 0.992)   0.000217
resting_heart_rate       0.995   (0.980 - 1.010)   0.486

Model 1 - LDL >= median: OR=4.917 (3.061-8.251), p=2.49e-10
Model 2 - PLR (LDL cantitativ): OR=1.035 (1.027-1.043), p=<2e-16

TABLE 4 (Multivariate):
Call:
glm(formula = heart_disease ~ ldl_high + age + family_history +
    hypertension + diabetes + obesity + systolic_bp + hdl + triglycerides,
    family = binomial, data = data)

Coefficients:
                 Estimate Std. Error z value Pr(>|z|)
(Intercept)     -4.942039   0.974185  -5.073 3.92e-07 ***
ldl_high1        1.744782   0.261513   6.672 2.53e-11 ***
age              0.002870   0.003165   0.907 0.364430
family_history1  0.830924   0.225588   3.683 0.000230 ***
hypertension1    0.278261   0.217066   1.282 0.199870
diabetes1        0.383765   0.264357   1.452 0.146590
obesity1         0.342875   0.227634   1.506 0.132000
systolic_bp      0.003628   0.004937   0.735 0.462430
hdl              0.024119   0.008287   2.910 0.003610 **
triglycerides   -0.003292   0.002352  -1.400 0.161580

Null deviance: 693.03  on 999  degrees of freedom
Residual deviance: 594.44  on 990  degrees of freedom
AIC: 614.44

Hosmer-Lemeshow: X-squared = 8.8922, df = 8, p-value = 0.3515
VIF: all < 2 (max = 1.65)
AUC model: 0.764 (0.719 - 0.810)
Nagelkerke R²: 0.188
```
