# =============================================================================
# LP04 - Regresia liniara simpla cu variabila explicativa de tip calitativ
# VD: IMC (kg/m2)
# VI Case II: Durata_somunului_2cat (0 = >=7h, 1 = <7h)
# VI Case III: Durata_somunului_3cat (0 = optim 7-9h, 1 = scurt <7h, 2 = lung >9h)
# =============================================================================

library(car)
library(lmtest)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
n <- nrow(data)
cat("n =", n, "\n\n")

# =====================================================================
#                      CAZUL II
#   VI = Durata_somunului_2cat (calitativa dihotomiala)
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL II - VARIABILA INDEPENDENTA CALITATIVA DIHOTOMIALA\n")
cat("###################################################################\n\n")

# Factor cu referinta 0 (>=7h)
data$sleep_2cat <- factor(data$Durata_somunului_2cat, levels = c(0, 1),
                          labels = c(">=7h", "<7h"))

# --- 1. Specificarea variabilelor ---
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: IMC_kg_m2 - cantitativa continua - variabila dependenta\n")
cat("VI: Durata_somunului_2cat - calitativa dihotomiala - variabila independenta\n")
cat("   0 = durata somn >= 7 ore (referinta); 1 = durata somn < 7 ore\n\n")

# --- 2. Analiza descriptiva ---
cat("2. ANALIZA DESCRIPTIVA\n\n")

# IMC global
cat("--- IMC (kg/m2) - global ---\n")
cat("  N:       ", length(data$IMC_kg_m2), "\n")
cat("  NA:      ", sum(is.na(data$IMC_kg_m2)), "\n")
cat("  Media:   ", sprintf("%.2f", mean(data$IMC_kg_m2)), "\n")
cat("  Mediana: ", sprintf("%.2f", median(data$IMC_kg_m2)), "\n")
cat("  SD:      ", sprintf("%.2f", sd(data$IMC_kg_m2)), "\n")
cat("  Min:     ", sprintf("%.2f", min(data$IMC_kg_m2)), "\n")
cat("  Max:     ", sprintf("%.2f", max(data$IMC_kg_m2)), "\n")
q_imc <- quantile(data$IMC_kg_m2, c(0.25, 0.75))
iqr_imc <- IQR(data$IMC_kg_m2)
cat("  Q1:      ", sprintf("%.2f", q_imc[1]), "\n")
cat("  Q3:      ", sprintf("%.2f", q_imc[2]), "\n")
cat("  IQR:     ", sprintf("%.2f", iqr_imc), "\n")
out_imc <- data$IMC_kg_m2[data$IMC_kg_m2 < q_imc[1] - 1.5*iqr_imc | data$IMC_kg_m2 > q_imc[2] + 1.5*iqr_imc]
cat("  Outliers:", length(out_imc), "\n\n")

# IMC per grup
cat("--- IMC per grup ---\n")
for (lev in levels(data$sleep_2cat)) {
  sub <- data$IMC_kg_m2[data$sleep_2cat == lev]
  cat(sprintf("  Grup %s (n=%d): Media=%.2f, SD=%.2f, Mediana=%.2f\n",
              lev, length(sub), mean(sub), sd(sub), median(sub)))
}
cat("\n")

# Durata_somunului_2cat
cat("--- Durata_somunului_2cat ---\n")
print(table(data$sleep_2cat))
cat("\n")

# Boxplots
png("caso2_boxplot_imc.png", width = 600, height = 500, res = 150)
boxplot(data$IMC_kg_m2, main = "Boxplot - IMC (kg/m2)", ylab = "IMC (kg/m2)",
        col = "lightblue")
dev.off()

png("caso2_boxplot_imc_by_sleep.png", width = 700, height = 500, res = 150)
boxplot(IMC_kg_m2 ~ sleep_2cat, data = data,
        main = "IMC in functie de durata somnului (2 categorii)",
        xlab = "Durata somnului", ylab = "IMC (kg/m2)",
        col = c("lightgreen", "salmon"))
dev.off()
cat("Salvat: caso2_boxplot_imc.png, caso2_boxplot_imc_by_sleep.png\n\n")

# --- 4. Modelul de regresie ---
cat("4. MODELUL DE REGRESIE LINIARA SIMPLA (CAZUL II)\n\n")

model2 <- lm(IMC_kg_m2 ~ sleep_2cat, data = data)
s2 <- summary(model2)
print(s2)

b0 <- coef(model2)[1]
b1 <- coef(model2)[2]
cat("\nEcuatia: IMC =", sprintf("%.4f", b0), "+ (", sprintf("%.4f", b1), ") * sleep_2cat<7h\n")
cat("  b0 =", sprintf("%.4f", b0), "= media IMC in grupul de referinta (>=7h)\n")
cat("  b1 =", sprintf("%.4f", b1), "= diferenta de medie IMC intre <7h si >=7h\n\n")

# --- 5. Testarea β1 ---
cat("5. TESTAREA SEMNIFICATIEI β1\n\n")
ct <- s2$coefficients
t_val <- ct["sleep_2cat<7h", "t value"]
p_val <- ct["sleep_2cat<7h", "Pr(>|t|)"]
k <- 1
df <- n - k - 1

cat("H0: β1 = 0 (nu exista diferenta de IMC intre cele 2 grupuri)\n")
cat("H1: β1 ≠ 0 (exista diferenta de IMC intre cele 2 grupuri)\n\n")
cat("t =", sprintf("%.4f", t_val), "\n")
cat("df = n - k - 1 =", n, "-", k, "- 1 =", df, "\n")
cat("p-value =", format.pval(p_val, digits = 4), "\n\n")
if (p_val < 0.05) {
  cat("Decizia: p < 0.05, se respinge H0. Diferenta este semnificativa.\n\n")
} else {
  cat("Decizia: p >= 0.05, nu se respinge H0. Diferenta nu este semnificativa.\n\n")
}

# --- 6. IC ---
cat("6. INTERVALE DE INCREDERE\n")
ci2 <- confint(model2)
print(ci2)
cat("\n")

# --- 7. R² si F ---
cat("7. R² SI TESTUL F\n\n")
cat("R² =", sprintf("%.4f", s2$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s2$adj.r.squared), "\n\n")

f2 <- s2$fstatistic
f2_p <- pf(f2[1], f2[2], f2[3], lower.tail = FALSE)
cat("F(", f2[2], ",", f2[3], ") =", sprintf("%.4f", f2[1]), "\n")
cat("p-value =", format.pval(f2_p, digits = 4), "\n\n")

# --- 8. Diagnostic ---
cat("8. DIAGNOSTIC MODEL (CAZUL II)\n\n")

png("caso2_diagnostic.png", width = 900, height = 800, res = 150)
par(mfrow = c(2, 2))
plot(model2)
dev.off()
cat("Salvat: caso2_diagnostic.png\n")

png("caso2_residuals_vs_fitted.png", width = 700, height = 600, res = 150)
plot(model2, which = 1)
dev.off()

png("caso2_qq.png", width = 700, height = 600, res = 150)
plot(model2, which = 2)
dev.off()

png("caso2_hist_resid.png", width = 600, height = 500, res = 150)
hist(residuals(model2), main = "Histograma reziduurilor (Cazul II)",
     xlab = "Reziduuri", col = "lightgreen", breaks = 15)
dev.off()

png("caso2_scale_location.png", width = 700, height = 600, res = 150)
plot(model2, which = 3)
dev.off()

# Shapiro-Wilk
sw2 <- shapiro.test(residuals(model2))
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw2$statistic),
    ", p =", format.pval(sw2$p.value, digits = 4), "\n")
if (sw2$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

# Breusch-Pagan
bp2 <- bptest(model2)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp2$statistic),
    ", p =", format.pval(bp2$p.value, digits = 4), "\n")
if (bp2$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

# Durbin-Watson
dw2 <- durbinWatsonTest(model2)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw2$dw),
    ", p =", sprintf("%.4f", dw2$p), "\n")
if (dw2$p > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

# Cook's D
cd2 <- cooks.distance(model2)
cat("Cook's D > 4/n:", sum(cd2 > 4/n), "observatii\n")

# Standardized residuals
sr2 <- rstandard(model2)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr2) > 2), "observatii\n\n")

# --- 9. Interpretare ---
cat("9. INTERPRETARE (CAZUL II)\n\n")
cat("β1 =", sprintf("%.4f", b1), "\n")
cat("  Media IMC la cei cu somn >=7h:", sprintf("%.2f", b0), "kg/m2\n")
cat("  Media IMC la cei cu somn <7h:", sprintf("%.2f", b0 + b1), "kg/m2\n")
cat("  Diferenta:", sprintf("%.2f", b1), "kg/m2\n")
cat("R² =", sprintf("%.4f", s2$r.squared), "\n")
cat("  ", sprintf("%.2f%%", s2$r.squared * 100), "din variabilitatea IMC\n")
cat("  este explicata de durata somnului (2 categorii).\n\n")

# --- 10. Comparatie cu testul t independent ---
cat("10. COMPARATIE CU TESTUL T INDEPENDENT\n\n")
tt <- t.test(IMC_kg_m2 ~ sleep_2cat, data = data, var.equal = TRUE)
print(tt)
cat("\nComparatie:\n")
cat("  Regresie: t =", sprintf("%.4f", t_val), ", p =", format.pval(p_val, digits = 4), "\n")
cat("  Test t:   t =", sprintf("%.4f", tt$statistic), ", p =", format.pval(tt$p.value, digits = 4), "\n")
cat("  Valorile sunt identice (cu semn opus datorita ordinii grupurilor).\n")
cat("  Regresia cu variabila dihotomiala este echivalenta cu testul t.\n\n")


# =====================================================================
#                      CAZUL III
#   VI = Durata_somunului_3cat (calitativa nominala/ordinala)
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL III - VARIABILA INDEPENDENTA CALITATIVA NOMINALA/ORDINALA\n")
cat("###################################################################\n\n")

# Factor cu referinta 0 (optim 7-9h)
data$sleep_3cat <- factor(data$Durata_somunului_3cat, levels = c(0, 1, 2),
                          labels = c("Optim(7-9h)", "Scurt(<7h)", "Lung(>9h)"))

# --- 1. Specificarea variabilelor ---
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: IMC_kg_m2 - cantitativa continua - variabila dependenta\n")
cat("VI: Durata_somunului_3cat - calitativa nominala (3 categorii) - variabila independenta\n")
cat("   0 = optim (7-9h) [referinta]; 1 = scurt (<7h); 2 = lung (>9h)\n\n")

# --- 2. Analiza descriptiva ---
cat("2. ANALIZA DESCRIPTIVA (CAZUL III)\n\n")

cat("--- IMC per grup ---\n")
for (lev in levels(data$sleep_3cat)) {
  sub <- data$IMC_kg_m2[data$sleep_3cat == lev]
  q <- quantile(sub, c(0.25, 0.75))
  iqr <- IQR(sub)
  outs <- sum(sub < q[1] - 1.5*iqr | sub > q[2] + 1.5*iqr)
  cat(sprintf("  Grup %s (n=%d): Media=%.2f, SD=%.2f, Mediana=%.2f, Q1=%.2f, Q3=%.2f, Outliers=%d\n",
              lev, length(sub), mean(sub), sd(sub), median(sub), q[1], q[2], outs))
}
cat("\n")

print(table(data$sleep_3cat))
cat("\n")

# Boxplot
png("caso3_boxplot_imc_by_sleep.png", width = 800, height = 500, res = 150)
boxplot(IMC_kg_m2 ~ sleep_3cat, data = data,
        main = "IMC in functie de durata somnului (3 categorii)",
        xlab = "Durata somnului", ylab = "IMC (kg/m2)",
        col = c("lightgreen", "salmon", "lightyellow"))
dev.off()
cat("Salvat: caso3_boxplot_imc_by_sleep.png\n\n")

# --- 4. Modelul de regresie ---
cat("4. MODELUL DE REGRESIE LINIARA (CAZUL III)\n\n")

model3 <- lm(IMC_kg_m2 ~ sleep_3cat, data = data)
s3 <- summary(model3)
print(s3)

b0_3 <- coef(model3)[1]
b1_3 <- coef(model3)[2]  # Scurt vs Optim
b2_3 <- coef(model3)[3]  # Lung vs Optim
cat("\nEcuatia: IMC =", sprintf("%.4f", b0_3), "+ (",
    sprintf("%.4f", b1_3), ") * Scurt + (",
    sprintf("%.4f", b2_3), ") * Lung\n")
cat("  b0 =", sprintf("%.4f", b0_3), "= media IMC in grupul de referinta (Optim 7-9h)\n")
cat("  b1 =", sprintf("%.4f", b1_3), "= diferenta medie IMC: Scurt(<7h) vs Optim\n")
cat("  b2 =", sprintf("%.4f", b2_3), "= diferenta medie IMC: Lung(>9h) vs Optim\n\n")

# --- 5. Testarea β1 si β2 ---
cat("5. TESTAREA SEMNIFICATIEI COEFICIENTILOR\n\n")
ct3 <- s3$coefficients
k3 <- 2  # 2 dummy variables (3 categorii - 1)
df3 <- n - k3 - 1

cat("--- β1 (Scurt vs Optim) ---\n")
cat("H0: β1 = 0 (nu exista diferenta IMC intre somn scurt si optim)\n")
cat("H1: β1 ≠ 0\n")
t1_3 <- ct3[2, "t value"]
p1_3 <- ct3[2, "Pr(>|t|)"]
cat("t =", sprintf("%.4f", t1_3), "\n")
cat("df =", df3, "\n")
cat("p-value =", format.pval(p1_3, digits = 4), "\n")
if (p1_3 < 0.05) {
  cat("Decizia: Diferenta semnificativa.\n\n")
} else {
  cat("Decizia: Diferenta nesemnificativa.\n\n")
}

cat("--- β2 (Lung vs Optim) ---\n")
cat("H0: β2 = 0 (nu exista diferenta IMC intre somn lung si optim)\n")
cat("H1: β2 ≠ 0\n")
t2_3 <- ct3[3, "t value"]
p2_3 <- ct3[3, "Pr(>|t|)"]
cat("t =", sprintf("%.4f", t2_3), "\n")
cat("df =", df3, "\n")
cat("p-value =", format.pval(p2_3, digits = 4), "\n")
if (p2_3 < 0.05) {
  cat("Decizia: Diferenta semnificativa.\n\n")
} else {
  cat("Decizia: Diferenta nesemnificativa.\n\n")
}

# --- 6. IC ---
cat("6. INTERVALE DE INCREDERE\n")
ci3 <- confint(model3)
print(ci3)
cat("\n")

# --- 7. R² si F ---
cat("7. R² SI TESTUL F\n\n")
cat("R² =", sprintf("%.4f", s3$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s3$adj.r.squared), "\n\n")

f3 <- s3$fstatistic
f3_p <- pf(f3[1], f3[2], f3[3], lower.tail = FALSE)
cat("F(", f3[2], ",", f3[3], ") =", sprintf("%.4f", f3[1]), "\n")
cat("df1 = k =", k3, "\n")
cat("df2 = n - k - 1 =", df3, "\n")
cat("p-value =", format.pval(f3_p, digits = 4), "\n\n")

# --- 8. Diagnostic ---
cat("8. DIAGNOSTIC MODEL (CAZUL III)\n\n")

png("caso3_diagnostic.png", width = 900, height = 800, res = 150)
par(mfrow = c(2, 2))
plot(model3)
dev.off()
cat("Salvat: caso3_diagnostic.png\n")

png("caso3_residuals_vs_fitted.png", width = 700, height = 600, res = 150)
plot(model3, which = 1)
dev.off()

png("caso3_qq.png", width = 700, height = 600, res = 150)
plot(model3, which = 2)
dev.off()

png("caso3_hist_resid.png", width = 600, height = 500, res = 150)
hist(residuals(model3), main = "Histograma reziduurilor (Cazul III)",
     xlab = "Reziduuri", col = "lightyellow", breaks = 15)
dev.off()

png("caso3_scale_location.png", width = 700, height = 600, res = 150)
plot(model3, which = 3)
dev.off()

# Shapiro-Wilk
sw3 <- shapiro.test(residuals(model3))
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw3$statistic),
    ", p =", format.pval(sw3$p.value, digits = 4), "\n")
if (sw3$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

# Breusch-Pagan
bp3 <- bptest(model3)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp3$statistic),
    ", p =", format.pval(bp3$p.value, digits = 4), "\n")
if (bp3$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

# Durbin-Watson
dw3 <- durbinWatsonTest(model3)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw3$dw),
    ", p =", sprintf("%.4f", dw3$p), "\n")
if (dw3$p > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

cd3 <- cooks.distance(model3)
cat("Cook's D > 4/n:", sum(cd3 > 4/n), "observatii\n")
sr3 <- rstandard(model3)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr3) > 2), "observatii\n\n")

# --- 9. Interpretare ---
cat("9. INTERPRETARE (CAZUL III)\n\n")
cat("β1 (Scurt vs Optim) =", sprintf("%.4f", b1_3), "\n")
cat("  Media IMC Optim(7-9h):", sprintf("%.2f", b0_3), "kg/m2\n")
cat("  Media IMC Scurt(<7h):", sprintf("%.2f", b0_3 + b1_3), "kg/m2\n")
cat("  Diferenta:", sprintf("%.2f", b1_3), "kg/m2\n\n")

cat("β2 (Lung vs Optim) =", sprintf("%.4f", b2_3), "\n")
cat("  Media IMC Lung(>9h):", sprintf("%.2f", b0_3 + b2_3), "kg/m2\n")
cat("  Diferenta:", sprintf("%.2f", b2_3), "kg/m2\n\n")

cat("R² =", sprintf("%.4f", s3$r.squared), "\n")
cat("  ", sprintf("%.2f%%", s3$r.squared * 100), "din variabilitatea IMC\n")
cat("  este explicata de durata somnului (3 categorii).\n\n")

# Comparatie cu ANOVA
cat("10. COMPARATIE CU ANOVA ONE-WAY\n\n")
aov_model <- aov(IMC_kg_m2 ~ sleep_3cat, data = data)
print(summary(aov_model))
cat("\nComparatie: Testul F din regresie si cel din ANOVA sunt identice.\n")
cat("Regresia cu variabila nominala cu 3 categorii este echivalenta cu ANOVA one-way.\n\n")

# Post-hoc Tukey
cat("Post-hoc Tukey HSD:\n")
print(TukeyHSD(aov_model))

cat("\n=== ANALIZA COMPLETA ===\n")
