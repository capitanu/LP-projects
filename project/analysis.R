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

cat("=== Structura datelor ===\n")
str(data)
cat("\n")

# Subgrupuri
with_hd <- data %>% filter(heart_disease == "1")
without_hd <- data %>% filter(heart_disease == "0")
cat("Cu boală cardiacă: n =", nrow(with_hd), "\n")
cat("Fără boală cardiacă: n =", nrow(without_hd), "\n\n")

# =============================================================================
# TABLE 1: Participant Characteristics
# =============================================================================
cat("===========================================================================\n")
cat("TABLE 1: Participants' characteristics with and without heart disease\n")
cat("===========================================================================\n\n")

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

# --- Age ---
cat("Age (years), median (IQR):\n")
cat("  With HD:    ", median_iqr(with_hd$age), "\n")
cat("  Without HD: ", median_iqr(without_hd$age), "\n")
age_test <- wilcox.test(age ~ heart_disease, data = data)
cat("  P-value:    ", format.pval(age_test$p.value, digits = 3), "\n\n")

# --- Smoking (replacing Female since no sex variable exists) ---
cat("Smoking, n (%):\n")
cat("  With HD:    ", n_pct(with_hd$smoking_status), "\n")
cat("  Without HD: ", n_pct(without_hd$smoking_status), "\n")
smoking_table <- table(data$heart_disease, data$smoking_status)
smoking_test <- chisq.test(smoking_table)
cat("  P-value:    ", format.pval(smoking_test$p.value, digits = 3), "\n\n")

# --- Comorbidities ---
cat("Comorbidities:\n")

# Hypertension
cat("  Hypertension, n (%):\n")
cat("    With HD:    ", n_pct(with_hd$hypertension), "\n")
cat("    Without HD: ", n_pct(without_hd$hypertension), "\n")
ht_table <- table(data$heart_disease, data$hypertension)
ht_test <- chisq.test(ht_table)
cat("    P-value:    ", format.pval(ht_test$p.value, digits = 3), "\n")

# Diabetes
cat("  Diabetes, n (%):\n")
cat("    With HD:    ", n_pct(with_hd$diabetes), "\n")
cat("    Without HD: ", n_pct(without_hd$diabetes), "\n")
diab_table <- table(data$heart_disease, data$diabetes)
diab_test <- chisq.test(diab_table)
cat("    P-value:    ", format.pval(diab_test$p.value, digits = 3), "\n")

# Obesity
cat("  Obesity, n (%):\n")
cat("    With HD:    ", n_pct(with_hd$obesity), "\n")
cat("    Without HD: ", n_pct(without_hd$obesity), "\n")
ob_table <- table(data$heart_disease, data$obesity)
ob_test <- chisq.test(ob_table)
cat("    P-value:    ", format.pval(ob_test$p.value, digits = 3), "\n\n")

# --- Laboratory data ---
cat("Laboratory data:\n")

# Variable 1 = LDL
cat("  LDL cholesterol (mg/dL), median (IQR):\n")
cat("    With HD:    ", median_iqr(with_hd$ldl_cholesterol), "\n")
cat("    Without HD: ", median_iqr(without_hd$ldl_cholesterol), "\n")
ldl_test <- wilcox.test(ldl_cholesterol ~ heart_disease, data = data)
cat("    P-value:    ", format.pval(ldl_test$p.value, digits = 3), "\n")

# Variable 2 = Ferritin
cat("  Ferritin (ng/mL), median (IQR):\n")
cat("    With HD:    ", median_iqr(with_hd$ferritin), "\n")
cat("    Without HD: ", median_iqr(without_hd$ferritin), "\n")
fer_test <- wilcox.test(ferritin ~ heart_disease, data = data)
cat("    P-value:    ", format.pval(fer_test$p.value, digits = 3), "\n\n")


# =============================================================================
# TABLE 2 & FIGURES 1-2: ROC Analysis
# =============================================================================
cat("===========================================================================\n")
cat("TABLE 2: ROC Curves Classification\n")
cat("===========================================================================\n\n")

# Variabila dependentă numerică pentru pROC
hd_numeric <- as.numeric(as.character(data$heart_disease))

# --- ROC for LDL ---
roc_ldl <- roc(hd_numeric, data$ldl_cholesterol, quiet = TRUE)
auc_ldl <- auc(roc_ldl)
ci_ldl <- ci.auc(roc_ldl)

# Optimal cutoff (Youden)
coords_ldl <- coords(roc_ldl, "best", best.method = "youden", ret = c("threshold", "sensitivity", "specificity"))

cat("Variable 1 - LDL:\n")
cat("  AUC: ", sprintf("%.3f", auc_ldl),
    " (95% CI: ", sprintf("%.3f", ci_ldl[1]), " - ", sprintf("%.3f", ci_ldl[3]), ")\n", sep = "")
cat("  Sensitivity: ", sprintf("%.3f", coords_ldl$sensitivity), "\n")
cat("  Specificity: ", sprintf("%.3f", coords_ldl$specificity), "\n")
cat("  Optimal Cut-off: ", sprintf("%.1f", coords_ldl$threshold), "\n\n")

# --- ROC for Ferritin ---
roc_fer <- roc(hd_numeric, data$ferritin, quiet = TRUE)
auc_fer <- auc(roc_fer)
ci_fer <- ci.auc(roc_fer)

coords_fer <- coords(roc_fer, "best", best.method = "youden", ret = c("threshold", "sensitivity", "specificity"))

cat("Variable 2 - Ferritin:\n")
cat("  AUC: ", sprintf("%.3f", auc_fer),
    " (95% CI: ", sprintf("%.3f", ci_fer[1]), " - ", sprintf("%.3f", ci_fer[3]), ")\n", sep = "")
cat("  Sensitivity: ", sprintf("%.3f", coords_fer$sensitivity), "\n")
cat("  Specificity: ", sprintf("%.3f", coords_fer$specificity), "\n")
cat("  Optimal Cut-off: ", sprintf("%.1f", coords_fer$threshold), "\n\n")

# --- Figure 1: ROC curve for LDL ---
png("figure1_roc_ldl.png", width = 800, height = 700, res = 150)
plot(roc_ldl,
     main = "ROC Curve - LDL Cholesterol",
     col = "blue", lwd = 2,
     print.auc = TRUE, print.auc.x = 0.4, print.auc.y = 0.2,
     print.thres = TRUE, print.thres.best.method = "youden",
     legacy.axes = TRUE,
     xlab = "1 - Specificity", ylab = "Sensitivity")
legend("bottomright",
       legend = paste0("AUC = ", sprintf("%.3f", auc_ldl),
                       " (", sprintf("%.3f", ci_ldl[1]), "-", sprintf("%.3f", ci_ldl[3]), ")"),
       col = "blue", lwd = 2, bty = "n")
dev.off()
cat("Figure 1 saved: figure1_roc_ldl.png\n")

# --- Figure 2: ROC curve for Ferritin ---
png("figure2_roc_ferritin.png", width = 800, height = 700, res = 150)
plot(roc_fer,
     main = "ROC Curve - Ferritin",
     col = "red", lwd = 2,
     print.auc = TRUE, print.auc.x = 0.4, print.auc.y = 0.2,
     print.thres = TRUE, print.thres.best.method = "youden",
     legacy.axes = TRUE,
     xlab = "1 - Specificity", ylab = "Sensitivity")
legend("bottomright",
       legend = paste0("AUC = ", sprintf("%.3f", auc_fer),
                       " (", sprintf("%.3f", ci_fer[1]), "-", sprintf("%.3f", ci_fer[3]), ")"),
       col = "red", lwd = 2, bty = "n")
dev.off()
cat("Figure 2 saved: figure2_roc_ferritin.png\n\n")


# =============================================================================
# TABLE 3: Univariate Logistic Regressions
# =============================================================================
cat("===========================================================================\n")
cat("TABLE 3: Univariate Logistic Regressions Predicting Heart Disease\n")
cat("===========================================================================\n\n")

# Lista de variabile pentru regresii univariate
univar_vars <- c("age", "smoking_status", "ldl_cholesterol", "ferritin",
                 "family_history", "high_stress", "hypertension", "diabetes",
                 "obesity", "systolic_bp", "diastolic_bp", "bmi",
                 "glucose", "hba1c", "triglycerides", "hdl",
                 "total_cholesterol", "waist_circumference", "resting_heart_rate")

cat(sprintf("%-25s %12s   %-20s   %8s\n", "Variable", "OR", "95% CI", "p-value"))
cat(paste(rep("-", 75), collapse = ""), "\n")

univar_results <- data.frame()

for (var in univar_vars) {
  formula <- as.formula(paste("heart_disease ~", var))
  model <- glm(formula, data = data, family = binomial)
  tidied <- tidy(model, conf.int = TRUE, exponentiate = TRUE)

  # Extragem coeficientul variabilei (nu interceptul)
  coef_row <- tidied[nrow(tidied), ]

  or_val <- coef_row$estimate
  ci_low <- coef_row$conf.low
  ci_high <- coef_row$conf.high
  p_val <- coef_row$p.value

  cat(sprintf("%-25s %12.3f   (%.3f - %.3f)   %s\n",
              var, or_val, ci_low, ci_high,
              format.pval(p_val, digits = 3)))

  univar_results <- rbind(univar_results, data.frame(
    Variable = var, OR = or_val, CI_low = ci_low, CI_high = ci_high, p = p_val
  ))
}
cat("\n")

# Model 1: LDL >= median (dichotomizat)
ldl_median <- median(data$ldl_cholesterol, na.rm = TRUE)
cat("Median LDL cholesterol:", ldl_median, "mg/dL\n\n")
data$ldl_high <- ifelse(data$ldl_cholesterol >= ldl_median, 1, 0)
data$ldl_high <- as.factor(data$ldl_high)

model1 <- glm(heart_disease ~ ldl_high, data = data, family = binomial)
tidied1 <- tidy(model1, conf.int = TRUE, exponentiate = TRUE)
cat("Model 1 - LDL >= median (univariate):\n")
print(tidied1)

# Model 2 - PLR: LDL as quantitative
model2 <- glm(heart_disease ~ ldl_cholesterol, data = data, family = binomial)
tidied2 <- tidy(model2, conf.int = TRUE, exponentiate = TRUE)
cat("\nModel 2 - PLR (LDL as quantitative variable):\n")
print(tidied2)
cat("\n")


# =============================================================================
# TABLE 4: Multivariate Logistic Regression
# =============================================================================
cat("===========================================================================\n")
cat("TABLE 4: Multivariate Logistic Regression\n")
cat("===========================================================================\n\n")

# --- Strategia de selecție a variabilelor ---
# Selectăm variabilele pe baza:
# 1. Relevanței clinice/fiziopatologice pentru bolile cardiovasculare
# 2. Rezultatelor din analiza univariată (p < 0.2 ca screening)
# 3. Limitării gradelor de libertate: min(110, 890)/10 ≈ 11 g.d.l.
#
# Variabila de interes: ldl_high (LDL >= median, dihotomială) - 1 g.d.l.
# Variabile de ajustare selectate:
# - age: factor de risc major cardiovascular, variabilă cantitativă - 1 g.d.l.
# - smoking_status: factor de risc comportamental - 1 g.d.l.
# - hypertension: comorbiditate majoră CV - 1 g.d.l.
# - diabetes: comorbiditate metabolică - 1 g.d.l.
# - obesity: factor de risc metabolic - 1 g.d.l.
# - systolic_bp: indicator clinic important - 1 g.d.l.
# - hdl: factor protector cardiovascular - 1 g.d.l.
# - triglycerides: marker metabolic - 1 g.d.l.
# Total: 9 g.d.l. (< 11 permise)

cat("Strategia de selecție a variabilelor:\n")
cat("- Variabila de interes: LDL >= median (dihotomială)\n")
cat("- Variabile de ajustare selectate pe baza relevanței clinice\n")
cat("  și a numărului de grade de libertate disponibile:\n")
cat("  min(110, 890) / 10 ≈ 11 grade de libertate permise\n")
cat("- Variabile: age, smoking_status, hypertension, diabetes,\n")
cat("  obesity, systolic_bp, hdl, triglycerides\n")
cat("  Total: 9 g.d.l. (< 11 permise)\n\n")

# Modelul multivariat
multi_model <- glm(heart_disease ~ ldl_high + age + smoking_status +
                     hypertension + diabetes + obesity +
                     systolic_bp + hdl + triglycerides,
                   data = data, family = binomial)

cat("--- Rezultate model multivariat ---\n")
summary_multi <- summary(multi_model)
print(summary_multi)

# OR cu CI
cat("\n--- Odds Ratios cu intervale de încredere ---\n")
tidied_multi <- tidy(multi_model, conf.int = TRUE, exponentiate = TRUE)
print(tidied_multi)
cat("\n")

# =============================================================================
# Verificarea condițiilor de aplicare ale modelului
# =============================================================================
cat("===========================================================================\n")
cat("VERIFICAREA CONDIȚIILOR DE APLICARE\n")
cat("===========================================================================\n\n")

# 1. Hosmer-Lemeshow goodness-of-fit test
cat("1. Testul Hosmer-Lemeshow (goodness-of-fit):\n")
hl_test <- hoslem.test(as.numeric(as.character(data$heart_disease)),
                        fitted(multi_model), g = 10)
print(hl_test)
cat("   Interpretare: Dacă p > 0.05, modelul se potrivește bine pe date.\n\n")

# 2. Multicolinearitate (VIF)
cat("2. Multicolinearitate - Variance Inflation Factor (VIF):\n")
vif_values <- vif(multi_model)
print(vif_values)
cat("   Interpretare: VIF < 5 (sau < 10) indică absența multicolinearității.\n\n")

# 3. Liniaritatea între variabilele continue și logit
cat("3. Liniaritatea în logit pentru variabilele continue:\n")
# Box-Tidwell test - verificăm interacțiunile cu log
data_bt <- data
data_bt$heart_disease_num <- as.numeric(as.character(data$heart_disease))

# Testăm variabilele continue din model
cont_vars <- c("age", "systolic_bp", "hdl", "triglycerides")
for (v in cont_vars) {
  # Adăugăm termenul de interacțiune var * log(var) în model
  data_bt[[paste0(v, "_log")]] <- data_bt[[v]] * log(data_bt[[v]])
}

bt_formula <- as.formula(paste(
  "heart_disease ~ ldl_high + age + smoking_status + hypertension + diabetes + obesity +",
  "systolic_bp + hdl + triglycerides +",
  "age_log + systolic_bp_log + hdl_log + triglycerides_log"
))

bt_model <- glm(bt_formula, data = data_bt, family = binomial)
bt_tidy <- tidy(bt_model)
bt_interactions <- bt_tidy[grep("_log$", bt_tidy$term), ]
cat("   Box-Tidwell test (interacțiuni var*log(var)):\n")
cat(sprintf("   %-20s   p-value\n", "Variabilă"))
for (i in 1:nrow(bt_interactions)) {
  cat(sprintf("   %-20s   %s\n", bt_interactions$term[i],
              format.pval(bt_interactions$p.value[i], digits = 3)))
}
cat("   Interpretare: p > 0.05 indică relație liniară în logit.\n\n")

# 4. Observații influente (Cook's distance)
cat("4. Observații influente (Cook's Distance):\n")
cooks_d <- cooks.distance(multi_model)
influential <- which(cooks_d > 4 / nrow(data))
cat("   Nr. observații cu Cook's D > 4/n:", length(influential), "\n")
if (length(influential) > 0) {
  cat("   Indici:", head(influential, 20), "\n")
}
cat("   Interpretare: Observațiile cu Cook's D > 4/n pot fi influente.\n\n")

# 5. AUC al modelului multivariat
cat("5. Capacitatea discriminativă a modelului:\n")
pred_probs <- predict(multi_model, type = "response")
roc_model <- roc(as.numeric(as.character(data$heart_disease)), pred_probs, quiet = TRUE)
auc_model <- auc(roc_model)
ci_model <- ci.auc(roc_model)
cat("   AUC: ", sprintf("%.3f", auc_model),
    " (95% CI: ", sprintf("%.3f", ci_model[1]), " - ", sprintf("%.3f", ci_model[3]), ")\n", sep = "")
cat("   Interpretare: AUC > 0.7 = discriminare acceptabilă, > 0.8 = bună.\n\n")

# 6. Tabelul de clasificare
cat("6. Tabel de clasificare (cutoff = 0.5):\n")
pred_class <- ifelse(pred_probs >= 0.5, 1, 0)
conf_matrix <- table(Observed = as.numeric(as.character(data$heart_disease)),
                      Predicted = pred_class)
print(conf_matrix)

accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
cat("   Acuratețe:", sprintf("%.1f%%", accuracy * 100), "\n\n")

# 7. Nagelkerke R²
cat("7. Pseudo R² (Nagelkerke):\n")
null_model <- glm(heart_disease ~ 1, data = data, family = binomial)
ll_null <- logLik(null_model)
ll_model <- logLik(multi_model)
n <- nrow(data)
cox_snell_r2 <- 1 - exp((2/n) * (as.numeric(ll_null) - as.numeric(ll_model)))
nagelkerke_r2 <- cox_snell_r2 / (1 - exp((2/n) * as.numeric(ll_null)))
cat("   Cox & Snell R²:", sprintf("%.4f", cox_snell_r2), "\n")
cat("   Nagelkerke R²:", sprintf("%.4f", nagelkerke_r2), "\n\n")

# 8. Grafice diagnostice
png("diagnostic_cooks.png", width = 800, height = 600, res = 150)
plot(cooks_d, main = "Cook's Distance", ylab = "Cook's Distance", xlab = "Observation")
abline(h = 4/nrow(data), col = "red", lty = 2)
dev.off()
cat("Grafic diagnostic salvat: diagnostic_cooks.png\n")

png("roc_model_multivar.png", width = 800, height = 700, res = 150)
plot(roc_model,
     main = "ROC Curve - Multivariate Model",
     col = "darkgreen", lwd = 2,
     print.auc = TRUE, print.auc.x = 0.4, print.auc.y = 0.2,
     legacy.axes = TRUE,
     xlab = "1 - Specificity", ylab = "Sensitivity")
dev.off()
cat("Grafic ROC model salvat: roc_model_multivar.png\n\n")


# =============================================================================
# REZUMAT FINAL
# =============================================================================
cat("===========================================================================\n")
cat("REZUMAT - Toate rezultatele pentru completarea documentului Word\n")
cat("===========================================================================\n\n")

cat("--- TABLE 1 ---\n")
cat(sprintf("Heart disease: With (n=%d), Without (n=%d)\n", nrow(with_hd), nrow(without_hd)))
cat(sprintf("Age: With=%s, Without=%s, p=%s\n",
            median_iqr(with_hd$age), median_iqr(without_hd$age),
            format.pval(age_test$p.value, digits = 3)))
cat(sprintf("Smoking: With=%s, Without=%s, p=%s\n",
            n_pct(with_hd$smoking_status), n_pct(without_hd$smoking_status),
            format.pval(smoking_test$p.value, digits = 3)))
cat(sprintf("Hypertension: With=%s, Without=%s, p=%s\n",
            n_pct(with_hd$hypertension), n_pct(without_hd$hypertension),
            format.pval(ht_test$p.value, digits = 3)))
cat(sprintf("Diabetes: With=%s, Without=%s, p=%s\n",
            n_pct(with_hd$diabetes), n_pct(without_hd$diabetes),
            format.pval(diab_test$p.value, digits = 3)))
cat(sprintf("Obesity: With=%s, Without=%s, p=%s\n",
            n_pct(with_hd$obesity), n_pct(without_hd$obesity),
            format.pval(ob_test$p.value, digits = 3)))
cat(sprintf("LDL: With=%s, Without=%s, p=%s\n",
            median_iqr(with_hd$ldl_cholesterol), median_iqr(without_hd$ldl_cholesterol),
            format.pval(ldl_test$p.value, digits = 3)))
cat(sprintf("Ferritin: With=%s, Without=%s, p=%s\n\n",
            median_iqr(with_hd$ferritin), median_iqr(without_hd$ferritin),
            format.pval(fer_test$p.value, digits = 3)))

cat("--- TABLE 2 ---\n")
cat(sprintf("LDL: AUC=%.3f (%.3f-%.3f), Se=%.3f, Sp=%.3f, Cut-off=%.1f\n",
            auc_ldl, ci_ldl[1], ci_ldl[3],
            coords_ldl$sensitivity, coords_ldl$specificity, coords_ldl$threshold))
cat(sprintf("Ferritin: AUC=%.3f (%.3f-%.3f), Se=%.3f, Sp=%.3f, Cut-off=%.1f\n\n",
            auc_fer, ci_fer[1], ci_fer[3],
            coords_fer$sensitivity, coords_fer$specificity, coords_fer$threshold))

cat("--- TABLE 3 (Univariate) ---\n")
# Model 1: LDL >= median
m1_coef <- tidied1[2, ]
cat(sprintf("Model 1 - LDL >= median: OR=%.3f (%.3f-%.3f), p=%s\n",
            m1_coef$estimate, m1_coef$conf.low, m1_coef$conf.high,
            format.pval(m1_coef$p.value, digits = 3)))
# Model 2: LDL quantitative
m2_coef <- tidied2[2, ]
cat(sprintf("Model 2 - PLR (LDL cantitativ): OR=%.3f (%.3f-%.3f), p=%s\n\n",
            m2_coef$estimate, m2_coef$conf.low, m2_coef$conf.high,
            format.pval(m2_coef$p.value, digits = 3)))

cat("--- TABLE 4 (Multivariate) ---\n")
for (i in 1:nrow(tidied_multi)) {
  cat(sprintf("  %-20s OR=%.3f (%.3f-%.3f), p=%s\n",
              tidied_multi$term[i], tidied_multi$estimate[i],
              tidied_multi$conf.low[i], tidied_multi$conf.high[i],
              format.pval(tidied_multi$p.value[i], digits = 3)))
}

cat("\n=== ANALIZA COMPLETĂ ===\n")
