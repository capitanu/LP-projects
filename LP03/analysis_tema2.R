# =============================================================================
# LP03 - Modelul unifactorial de regresie liniara simpla
# Variabila dependenta: IMC (kg/m2)
# Variabila independenta: Durata_somnului_h (ore)
# =============================================================================

library(car)     # Durbin-Watson, Breusch-Pagan
library(lmtest)  # bptest

# --- Citire date ---
data <- read.csv("data.csv", stringsAsFactors = FALSE)
cat("=== Structura datelor ===\n")
str(data)
cat("n =", nrow(data), "\n\n")

# =============================================================================
# 1. Specificarea variabilelor
# =============================================================================
cat("===========================================================================\n")
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("===========================================================================\n\n")
cat("Variabila dependenta (outcome): IMC (kg/m2) - variabila cantitativa continua\n")
cat("Variabila independenta (explicativa): Durata_somnului_h (ore) - variabila cantitativa continua\n\n")

# =============================================================================
# 2. Analiza descriptiva
# =============================================================================
cat("===========================================================================\n")
cat("2. ANALIZA DESCRIPTIVA\n")
cat("===========================================================================\n\n")

# IMC
cat("--- IMC (kg/m2) ---\n")
cat("  N:        ", length(data$IMC), "\n")
cat("  NA:       ", sum(is.na(data$IMC)), "\n")
cat("  Media:    ", sprintf("%.2f", mean(data$IMC, na.rm = TRUE)), "\n")
cat("  Mediana:  ", sprintf("%.2f", median(data$IMC, na.rm = TRUE)), "\n")
cat("  SD:       ", sprintf("%.2f", sd(data$IMC, na.rm = TRUE)), "\n")
cat("  Min:      ", sprintf("%.2f", min(data$IMC, na.rm = TRUE)), "\n")
cat("  Max:      ", sprintf("%.2f", max(data$IMC, na.rm = TRUE)), "\n")
q_imc <- quantile(data$IMC, c(0.25, 0.75), na.rm = TRUE)
iqr_imc <- IQR(data$IMC, na.rm = TRUE)
cat("  Q1:       ", sprintf("%.2f", q_imc[1]), "\n")
cat("  Q3:       ", sprintf("%.2f", q_imc[2]), "\n")
cat("  IQR:      ", sprintf("%.2f", iqr_imc), "\n")
lower_imc <- q_imc[1] - 1.5 * iqr_imc
upper_imc <- q_imc[2] + 1.5 * iqr_imc
outliers_imc <- data$IMC[data$IMC < lower_imc | data$IMC > upper_imc]
cat("  Outliers (Q1-1.5*IQR / Q3+1.5*IQR): ", length(outliers_imc), "\n")
if (length(outliers_imc) > 0) cat("    Valori:", outliers_imc, "\n")
cat("\n")

# Durata somnului
cat("--- Durata somnului (ore) ---\n")
cat("  N:        ", length(data$Durata_somnului_h), "\n")
cat("  NA:       ", sum(is.na(data$Durata_somnului_h)), "\n")
cat("  Media:    ", sprintf("%.2f", mean(data$Durata_somnului_h, na.rm = TRUE)), "\n")
cat("  Mediana:  ", sprintf("%.2f", median(data$Durata_somnului_h, na.rm = TRUE)), "\n")
cat("  SD:       ", sprintf("%.2f", sd(data$Durata_somnului_h, na.rm = TRUE)), "\n")
cat("  Min:      ", sprintf("%.2f", min(data$Durata_somnului_h, na.rm = TRUE)), "\n")
cat("  Max:      ", sprintf("%.2f", max(data$Durata_somnului_h, na.rm = TRUE)), "\n")
q_sleep <- quantile(data$Durata_somnului_h, c(0.25, 0.75), na.rm = TRUE)
iqr_sleep <- IQR(data$Durata_somnului_h, na.rm = TRUE)
cat("  Q1:       ", sprintf("%.2f", q_sleep[1]), "\n")
cat("  Q3:       ", sprintf("%.2f", q_sleep[2]), "\n")
cat("  IQR:      ", sprintf("%.2f", iqr_sleep), "\n")
lower_sleep <- q_sleep[1] - 1.5 * iqr_sleep
upper_sleep <- q_sleep[2] + 1.5 * iqr_sleep
outliers_sleep <- data$Durata_somnului_h[data$Durata_somnului_h < lower_sleep | data$Durata_somnului_h > upper_sleep]
cat("  Outliers (Q1-1.5*IQR / Q3+1.5*IQR): ", length(outliers_sleep), "\n")
if (length(outliers_sleep) > 0) cat("    Valori:", outliers_sleep, "\n")
cat("\n")

# =============================================================================
# Grafice descriptive - Boxplots
# =============================================================================
png("boxplot_imc.png", width = 600, height = 500, res = 150)
boxplot(data$IMC, main = "Boxplot - IMC (kg/m2)", ylab = "IMC (kg/m2)",
        col = "lightblue", border = "darkblue")
dev.off()
cat("Salvat: boxplot_imc.png\n")

png("boxplot_sleep.png", width = 600, height = 500, res = 150)
boxplot(data$Durata_somnului_h, main = "Boxplot - Durata somnului (ore)",
        ylab = "Durata somnului (ore)", col = "lightyellow", border = "orange")
dev.off()
cat("Salvat: boxplot_sleep.png\n")

# Histograme
png("hist_imc.png", width = 600, height = 500, res = 150)
hist(data$IMC, main = "Histograma - IMC (kg/m2)", xlab = "IMC (kg/m2)",
     col = "lightblue", border = "darkblue", breaks = 15)
dev.off()
cat("Salvat: hist_imc.png\n")

png("hist_sleep.png", width = 600, height = 500, res = 150)
hist(data$Durata_somnului_h, main = "Histograma - Durata somnului (ore)",
     xlab = "Durata somnului (ore)", col = "lightyellow", border = "orange", breaks = 15)
dev.off()
cat("Salvat: hist_sleep.png\n\n")

# =============================================================================
# 3. Scatter plot
# =============================================================================
png("scatter_sleep_imc.png", width = 700, height = 600, res = 150)
plot(data$Durata_somnului_h, data$IMC,
     main = "Relația dintre durata somnului și IMC",
     xlab = "Durata somnului (ore)", ylab = "IMC (kg/m2)",
     pch = 19, col = rgb(0.2, 0.4, 0.8, 0.6))
abline(lm(IMC ~ Durata_somnului_h, data = data), col = "red", lwd = 2)
dev.off()
cat("Salvat: scatter_sleep_imc.png\n\n")

# =============================================================================
# 4. Modelul de regresie liniara simpla
# =============================================================================
cat("===========================================================================\n")
cat("4. MODELUL DE REGRESIE LINIARA SIMPLA\n")
cat("===========================================================================\n\n")

model <- lm(IMC ~ Durata_somnului_h, data = data)
s <- summary(model)
print(s)
cat("\n")

# Coeficienti
b0 <- coef(model)[1]
b1 <- coef(model)[2]
cat("Ecuatia de regresie: IMC = ", sprintf("%.4f", b0), " + (",
    sprintf("%.4f", b1), ") * Durata_somnului_h\n\n")

# =============================================================================
# 5. Testarea semnificatiei coeficientului β1
# =============================================================================
cat("===========================================================================\n")
cat("5. TESTAREA SEMNIFICATIEI COEFICIENTULUI β1\n")
cat("===========================================================================\n\n")

coef_table <- summary(model)$coefficients
t_val <- coef_table["Durata_somnului_h", "t value"]
p_val <- coef_table["Durata_somnului_h", "Pr(>|t|)"]
n <- nrow(data)
k <- 1  # numar variabile independente
df <- n - k - 1

cat("Formularea ipotezelor:\n")
cat("  H0: β1 = 0 (nu exista relatie liniara intre durata somnului si IMC)\n")
cat("  H1: β1 ≠ 0 (exista relatie liniara intre durata somnului si IMC)\n\n")
cat("Statistica test: t =", sprintf("%.4f", t_val), "\n")
cat("df = n - k - 1 =", n, "-", k, "- 1 =", df, "\n")
cat("p-value =", format.pval(p_val, digits = 4), "\n\n")

if (p_val < 0.05) {
  cat("Decizia: p-value < 0.05, se respinge H0.\n")
  cat("Concluzie: Exista o relatie liniara semnificativa statistic\n")
  cat("intre durata somnului si IMC (p =", format.pval(p_val, digits = 4), ").\n\n")
} else {
  cat("Decizia: p-value >= 0.05, nu se respinge H0.\n")
  cat("Concluzie: Nu exista o relatie liniara semnificativa statistic\n")
  cat("intre durata somnului si IMC (p =", format.pval(p_val, digits = 4), ").\n\n")
}

# =============================================================================
# 6. Intervale de incredere
# =============================================================================
cat("===========================================================================\n")
cat("6. INTERVALE DE INCREDERE\n")
cat("===========================================================================\n\n")

ci <- confint(model, level = 0.95)
cat("95% IC pentru β0 (intercept):", sprintf("(%.4f, %.4f)", ci[1, 1], ci[1, 2]), "\n")
cat("95% IC pentru β1 (Durata_somnului_h):", sprintf("(%.4f, %.4f)", ci[2, 1], ci[2, 2]), "\n\n")

# =============================================================================
# 7. Coeficientul de determinare R² si testul F
# =============================================================================
cat("===========================================================================\n")
cat("7. COEFICIENTUL DE DETERMINARE R² SI TESTUL F\n")
cat("===========================================================================\n\n")

r_squared <- s$r.squared
adj_r_squared <- s$adj.r.squared
cat("R² =", sprintf("%.4f", r_squared), "\n")
cat("R² ajustat =", sprintf("%.4f", adj_r_squared), "\n\n")

# Corelatie Pearson
cor_test <- cor.test(data$Durata_somnului_h, data$IMC)
cat("Coeficientul de corelatie Pearson: r =", sprintf("%.4f", cor_test$estimate), "\n")
cat("r² =", sprintf("%.4f", cor_test$estimate^2), "(= R² din model)\n")
cat("p-value corelatie:", format.pval(cor_test$p.value, digits = 4), "\n\n")

# Testul F
f_stat <- s$fstatistic
cat("Testul F al lui Fisher:\n")
cat("F(", f_stat[2], ",", f_stat[3], ") =", sprintf("%.4f", f_stat[1]), "\n")
cat("  df1 = k =", k, "\n")
cat("  df2 = n - k - 1 =", df, "\n")
f_pvalue <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)
cat("  p-value =", format.pval(f_pvalue, digits = 4), "\n\n")

# =============================================================================
# 8. Diagnosticul modelului
# =============================================================================
cat("===========================================================================\n")
cat("8. DIAGNOSTICUL MODELULUI\n")
cat("===========================================================================\n\n")

# a) Liniaritatea
cat("a) Liniaritatea: verificata prin scatter plot si graficul Residuals vs Fitted\n\n")

# b) Normalitatea erorilor
cat("b) Normalitatea erorilor:\n")

# Residuals vs Fitted
png("residuals_vs_fitted.png", width = 700, height = 600, res = 150)
plot(model, which = 1, main = "Residuals vs Fitted")
dev.off()
cat("  Salvat: residuals_vs_fitted.png\n")

# Q-Q plot
png("qq_plot.png", width = 700, height = 600, res = 150)
plot(model, which = 2, main = "Normal Q-Q Plot")
dev.off()
cat("  Salvat: qq_plot.png\n")

# Histograma reziduurilor
png("hist_residuals.png", width = 600, height = 500, res = 150)
hist(residuals(model), main = "Histograma reziduurilor", xlab = "Reziduuri",
     col = "lightgreen", border = "darkgreen", breaks = 15)
curve(dnorm(x, mean = mean(residuals(model)), sd = sd(residuals(model))) * length(residuals(model)) * diff(hist(residuals(model), plot = FALSE)$breaks[1:2]),
      add = TRUE, col = "red", lwd = 2)
dev.off()
cat("  Salvat: hist_residuals.png\n")

# Shapiro-Wilk test
shapiro_test <- shapiro.test(residuals(model))
cat("  Shapiro-Wilk test:\n")
cat("    W =", sprintf("%.4f", shapiro_test$statistic), "\n")
cat("    p-value =", format.pval(shapiro_test$p.value, digits = 4), "\n")
if (shapiro_test$p.value > 0.05) {
  cat("    Concluzie: Reziduurile sunt normal distribuite (p > 0.05).\n\n")
} else {
  cat("    Concluzie: Reziduurile NU sunt normal distribuite (p < 0.05).\n\n")
}

# c) Homoscedasticitatea
cat("c) Homoscedasticitatea erorilor:\n")

# Scale-Location plot
png("scale_location.png", width = 700, height = 600, res = 150)
plot(model, which = 3, main = "Scale-Location")
dev.off()
cat("  Salvat: scale_location.png\n")

# Breusch-Pagan test
bp_test <- bptest(model)
cat("  Breusch-Pagan test:\n")
print(bp_test)
if (bp_test$p.value > 0.05) {
  cat("  Concluzie: Homoscedasticitatea este respectata (p > 0.05).\n\n")
} else {
  cat("  Concluzie: Heteroscedasticitate detectata (p < 0.05).\n\n")
}

# d) Independenta erorilor - Durbin-Watson
cat("d) Independenta erorilor (Durbin-Watson):\n")
dw_test <- durbinWatsonTest(model)
print(dw_test)
if (dw_test$p > 0.05) {
  cat("  Concluzie: Erorile sunt independente (p > 0.05).\n\n")
} else {
  cat("  Concluzie: Erorile NU sunt independente (p < 0.05).\n\n")
}

# e) Outlieri si puncte influente
cat("e) Outlieri si puncte influente:\n")

# Residuals vs Leverage
png("residuals_vs_leverage.png", width = 700, height = 600, res = 150)
plot(model, which = 5, main = "Residuals vs Leverage")
dev.off()
cat("  Salvat: residuals_vs_leverage.png\n")

# Cook's distance
png("cooks_distance_tema2.png", width = 700, height = 600, res = 150)
plot(model, which = 4, main = "Cook's Distance")
dev.off()
cat("  Salvat: cooks_distance_tema2.png\n")

cooks_d <- cooks.distance(model)
influential <- which(cooks_d > 4/n)
cat("  Nr. observatii cu Cook's D > 4/n:", length(influential), "\n")
if (length(influential) > 0) {
  cat("  Indici:", influential, "\n")
}

# Standardized residuals > |2| or |3|
std_res <- rstandard(model)
outliers_std <- which(abs(std_res) > 2)
cat("  Nr. observatii cu reziduuri standardizate |> 2|:", length(outliers_std), "\n")
if (length(outliers_std) > 0) {
  cat("  Indici:", outliers_std, "\n")
}
cat("\n")

# 4-panel diagnostic
png("diagnostic_4panel.png", width = 900, height = 800, res = 150)
par(mfrow = c(2, 2))
plot(model)
dev.off()
cat("Salvat: diagnostic_4panel.png\n\n")

# =============================================================================
# 9. Interpretare finala
# =============================================================================
cat("===========================================================================\n")
cat("9. INTERPRETARE FINALA\n")
cat("===========================================================================\n\n")

cat("Coeficientul de regresie estimat β1 =", sprintf("%.4f", b1), "\n")
cat("  Interpretare: La fiecare ora in plus de somn, IMC-ul scade/creste\n")
cat("  in medie cu", sprintf("%.4f", abs(b1)), "kg/m2.\n\n")

cat("Coeficientul de determinare R² =", sprintf("%.4f", r_squared), "\n")
cat("  Interpretare:", sprintf("%.2f%%", r_squared * 100),
    "din variabilitatea IMC este explicata\n")
cat("  de durata somnului.\n\n")

cat("=== ANALIZA COMPLETA ===\n")
