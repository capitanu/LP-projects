# =============================================================================
# LP08 - Regresia liniara simpla si multipla pe date transformate
# VD: CHIT (activitatea chitotriozidazei plasmatice, nmol/h/mL)
# VI simplu: BMI_Z (scor Z al IMC)
# VI multiplu: BMI_Z, Gen, Varsta_luni, Durata_boala_ani
# n = 99 copii/adolescenti supraponderali/obezi (5-18 ani)
# Transformare: log10(CHIT)
# =============================================================================

library(car)
library(lmtest)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
n <- nrow(data)
cat("=== Structura datelor ===\n")
str(data)
cat("n =", n, "\n\n")

# =====================================================================
# 1. STATISTICI DESCRIPTIVE
# =====================================================================
cat("===========================================================================\n")
cat("1. STATISTICI DESCRIPTIVE\n")
cat("===========================================================================\n\n")

# CHIT
cat("--- CHIT (nmol/h/mL) ---\n")
cat("  N:       ", sum(!is.na(data$CHIT)), "\n")
cat("  NA:      ", sum(is.na(data$CHIT)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$CHIT, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(data$CHIT, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$CHIT, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$CHIT, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$CHIT, na.rm=TRUE)), "\n")
q_chit <- quantile(data$CHIT, c(0.25, 0.75), na.rm=TRUE)
iqr_chit <- IQR(data$CHIT, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.4f", q_chit[1]), "\n")
cat("  Q3:      ", sprintf("%.4f", q_chit[2]), "\n")
cat("  IQR:     ", sprintf("%.4f", iqr_chit), "\n")
out_chit <- data$CHIT[data$CHIT < q_chit[1] - 1.5*iqr_chit | data$CHIT > q_chit[2] + 1.5*iqr_chit]
cat("  Outliers:", length(out_chit), "\n\n")

# BMI_Z
cat("--- BMI_Z (scor Z) ---\n")
cat("  N:       ", sum(!is.na(data$BMI_Z)), "\n")
cat("  NA:      ", sum(is.na(data$BMI_Z)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$BMI_Z, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(data$BMI_Z, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$BMI_Z, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$BMI_Z, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$BMI_Z, na.rm=TRUE)), "\n")
q_bmi <- quantile(data$BMI_Z, c(0.25, 0.75), na.rm=TRUE)
iqr_bmi <- IQR(data$BMI_Z, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.4f", q_bmi[1]), "\n")
cat("  Q3:      ", sprintf("%.4f", q_bmi[2]), "\n")
cat("  IQR:     ", sprintf("%.4f", iqr_bmi), "\n")
out_bmi <- data$BMI_Z[data$BMI_Z < q_bmi[1] - 1.5*iqr_bmi | data$BMI_Z > q_bmi[2] + 1.5*iqr_bmi]
cat("  Outliers:", length(out_bmi), "\n\n")

# Varsta, Durata, Gen
cat("--- Varsta_luni ---\n")
cat("  N:", sum(!is.na(data$Varsta_luni)), " Media:", sprintf("%.4f", mean(data$Varsta_luni, na.rm=TRUE)),
    " SD:", sprintf("%.4f", sd(data$Varsta_luni, na.rm=TRUE)), "\n\n")

cat("--- Durata_boala_ani ---\n")
cat("  N:", sum(!is.na(data$Durata_boala_ani)), " Media:", sprintf("%.4f", mean(data$Durata_boala_ani, na.rm=TRUE)),
    " SD:", sprintf("%.4f", sd(data$Durata_boala_ani, na.rm=TRUE)), "\n\n")

cat("Gen:\n")
print(table(data$Gen))
cat("\n")

# =====================================================================
# 2. BOX-PLOTS
# =====================================================================
cat("===========================================================================\n")
cat("2. BOX-PLOTS\n")
cat("===========================================================================\n\n")

png("boxplots.png", width=1000, height=500)
par(mfrow=c(1,4))
boxplot(data$CHIT, main="CHIT (nmol/h/mL)", col="lightblue")
boxplot(data$BMI_Z, main="BMI Z-score", col="lightgreen")
boxplot(data$Varsta_luni, main="Varsta (luni)", col="lightyellow")
boxplot(data$Durata_boala_ani, main="Durata bolii (ani)", col="pink")
dev.off()
cat("Salvat: boxplots.png\n\n")

# =====================================================================
# 3. SCATTER PLOTS (date originale)
# =====================================================================
cat("===========================================================================\n")
cat("3. SCATTER PLOTS (date originale)\n")
cat("===========================================================================\n\n")

png("scatter_original.png", width=1000, height=400)
par(mfrow=c(1,3))
plot(data$BMI_Z, data$CHIT, xlab="BMI Z-score", ylab="CHIT (nmol/h/mL)",
     main="CHIT vs BMI_Z (original)", pch=19, col=rgb(0,0,1,0.4))
abline(lm(CHIT ~ BMI_Z, data=data), col="red", lwd=2)
plot(data$Varsta_luni, data$CHIT, xlab="Varsta (luni)", ylab="CHIT",
     main="CHIT vs Varsta (original)", pch=19, col=rgb(0,0.5,0,0.4))
abline(lm(CHIT ~ Varsta_luni, data=data), col="red", lwd=2)
plot(data$Durata_boala_ani, data$CHIT, xlab="Durata bolii (ani)", ylab="CHIT",
     main="CHIT vs Durata bolii (original)", pch=19, col=rgb(0.5,0,0,0.4))
abline(lm(CHIT ~ Durata_boala_ani, data=data), col="red", lwd=2)
dev.off()
cat("Salvat: scatter_original.png\n\n")

# =====================================================================
# 4. CORELATII (date originale)
# =====================================================================
cat("===========================================================================\n")
cat("4. CORELATII (date originale)\n")
cat("===========================================================================\n\n")

iv_vars <- c("BMI_Z", "Varsta_luni", "Durata_boala_ani", "Gen")
for (v in iv_vars) {
  ct <- cor.test(data[[v]], data$CHIT)
  cat(sprintf("  CHIT vs %s: r=%.4f, t=%.4f, df=%d, p=%s\n",
              v, ct$estimate, ct$statistic, ct$parameter, format.pval(ct$p.value, digits=4)))
}
cat("\n")

# =====================================================================
# 5. NECESITATEA TRANSFORMARII
# =====================================================================
cat("===========================================================================\n")
cat("5. NECESITATEA TRANSFORMARII\n")
cat("===========================================================================\n\n")

sw_chit <- shapiro.test(data$CHIT)
cat("Shapiro-Wilk pe CHIT original: W =", sprintf("%.4f", sw_chit$statistic),
    ", p =", format.pval(sw_chit$p.value, digits=4), "\n")

skew_chit <- mean(((data$CHIT - mean(data$CHIT))/sd(data$CHIT))^3)
cat("Skewness CHIT:", sprintf("%.4f", skew_chit), "\n\n")

if (sw_chit$p.value < 0.05) {
  cat("Distributia CHIT nu este normala (p < 0.05). Transformarea este necesara.\n")
  cat("CHIT prezinta o distributie asimetrica pozitiva (skewness > 0),\n")
  cat("ceea ce justifica utilizarea transformarii logaritmice log10.\n\n")
} else {
  cat("Distributia CHIT este normala. Transformarea poate sa nu fie necesara.\n\n")
}

# =====================================================================
# 6. TRANSFORMARE log10(CHIT)
# =====================================================================
cat("===========================================================================\n")
cat("6. TRANSFORMARE log10(CHIT)\n")
cat("===========================================================================\n\n")

data$log_CHIT <- log10(data$CHIT)

cat("--- log10(CHIT) ---\n")
cat("  N:       ", sum(!is.na(data$log_CHIT)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$log_CHIT, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(data$log_CHIT, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$log_CHIT, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$log_CHIT, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$log_CHIT, na.rm=TRUE)), "\n\n")

sw_log <- shapiro.test(data$log_CHIT)
cat("Shapiro-Wilk pe log10(CHIT): W =", sprintf("%.4f", sw_log$statistic),
    ", p =", format.pval(sw_log$p.value, digits=4), "\n\n")

# Compare distributions
png("compare_distributions.png", width=800, height=400)
par(mfrow=c(1,2))
hist(data$CHIT, breaks=20, main="CHIT original", xlab="CHIT (nmol/h/mL)",
     col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(data$CHIT), sd=sd(data$CHIT)), add=TRUE, col="red", lwd=2)
hist(data$log_CHIT, breaks=20, main="log10(CHIT)", xlab="log10(CHIT)",
     col="lightgreen", probability=TRUE)
curve(dnorm(x, mean=mean(data$log_CHIT), sd=sd(data$log_CHIT)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Salvat: compare_distributions.png\n\n")

# Scatter plots with log transformed data
png("scatter_log.png", width=1000, height=400)
par(mfrow=c(1,3))
plot(data$BMI_Z, data$log_CHIT, xlab="BMI Z-score", ylab="log10(CHIT)",
     main="log10(CHIT) vs BMI_Z", pch=19, col=rgb(0,0,1,0.4))
abline(lm(log_CHIT ~ BMI_Z, data=data), col="red", lwd=2)
plot(data$Varsta_luni, data$log_CHIT, xlab="Varsta (luni)", ylab="log10(CHIT)",
     main="log10(CHIT) vs Varsta", pch=19, col=rgb(0,0.5,0,0.4))
abline(lm(log_CHIT ~ Varsta_luni, data=data), col="red", lwd=2)
plot(data$Durata_boala_ani, data$log_CHIT, xlab="Durata bolii (ani)", ylab="log10(CHIT)",
     main="log10(CHIT) vs Durata bolii", pch=19, col=rgb(0.5,0,0,0.4))
abline(lm(log_CHIT ~ Durata_boala_ani, data=data), col="red", lwd=2)
dev.off()
cat("Salvat: scatter_log.png\n\n")

# =====================================================================
# 7. COMPARATIE DATE ORIGINALE VS TRANSFORMATE
# =====================================================================
cat("===========================================================================\n")
cat("7. COMPARATIE ORIGINAL VS TRANSFORMAT\n")
cat("===========================================================================\n\n")

m_orig <- lm(CHIT ~ BMI_Z, data=data)
s_orig <- summary(m_orig)
sw_orig_resid <- shapiro.test(residuals(m_orig))

m_log <- lm(log_CHIT ~ BMI_Z, data=data)
s_log <- summary(m_log)
sw_log_resid <- shapiro.test(residuals(m_log))

cat("Regresie CHIT ~ BMI_Z (original):\n")
cat("  R² =", sprintf("%.4f", s_orig$r.squared), "\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_orig_resid$statistic),
    ", p =", format.pval(sw_orig_resid$p.value, digits=4), "\n\n")

cat("Regresie log10(CHIT) ~ BMI_Z (transformat):\n")
cat("  R² =", sprintf("%.4f", s_log$r.squared), "\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_log_resid$statistic),
    ", p =", format.pval(sw_log_resid$p.value, digits=4), "\n\n")

# =====================================================================
# 8. REGRESIE SIMPLA pe date transformate: log10(CHIT) ~ BMI_Z
# =====================================================================
cat("===========================================================================\n")
cat("8. REGRESIE LINIARA SIMPLA - log10(CHIT) ~ BMI_Z\n")
cat("===========================================================================\n\n")

model1 <- lm(log_CHIT ~ BMI_Z, data=data)
s1 <- summary(model1)
print(s1)
cat("\n")

ci1 <- confint(model1)
cat("95% IC:\n")
print(ci1)
cat("\n")

cat("R² =", sprintf("%.4f", s1$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s1$adj.r.squared), "\n\n")

cat("Ecuatia: log10(CHIT) =", sprintf("%.4f", coef(model1)[1]), "+ (",
    sprintf("%.4f", coef(model1)[2]), ") * BMI_Z\n\n")

# =====================================================================
# 9. REGRESIE MULTIPLA pe date transformate
# =====================================================================
cat("===========================================================================\n")
cat("9. REGRESIE MULTIPLA - log10(CHIT) ~ BMI_Z + Gen + Varsta + Durata\n")
cat("===========================================================================\n\n")

model2 <- lm(log_CHIT ~ BMI_Z + Gen + Varsta_luni + Durata_boala_ani, data=data)
s2 <- summary(model2)
print(s2)
cat("\n")

ci2 <- confint(model2)
cat("95% IC:\n")
print(ci2)
cat("\n")

# F-test
cat("Test F global:\n")
cat("  F =", sprintf("%.4f", s2$fstatistic[1]), "\n")
cat("  df1 =", s2$fstatistic[2], ", df2 =", s2$fstatistic[3], "\n")
p_f <- pf(s2$fstatistic[1], s2$fstatistic[2], s2$fstatistic[3], lower.tail=FALSE)
cat("  p =", format.pval(p_f, digits=4), "\n\n")

cat("R² =", sprintf("%.4f", s2$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s2$adj.r.squared), "\n\n")

# =====================================================================
# 10. DIAGNOSTICE MODEL MULTIPLU
# =====================================================================
cat("===========================================================================\n")
cat("10. DIAGNOSTICE MODEL MULTIPLU\n")
cat("===========================================================================\n\n")

resid2 <- residuals(model2)

# Normalitate
sw2 <- shapiro.test(resid2)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw2$statistic), ", p =", format.pval(sw2$p.value, digits=4), "\n")
if (sw2$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

# Homoscedasticitate
bp2 <- bptest(model2)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp2$statistic),
    ", p =", format.pval(bp2$p.value, digits=4), "\n")
if (bp2$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

# Durbin-Watson
dw2 <- dwtest(model2)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw2$statistic),
    ", p =", format.pval(dw2$p.value, digits=4), "\n")
if (dw2$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

# Outliers
cook2 <- cooks.distance(model2)
cat("Cook's D > 4/n:", sum(cook2 > 4/n), "observatii\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook2)), "\n")

sr2 <- rstandard(model2)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr2) > 2), "observatii\n\n")

# VIF
cat("VIF:\n")
print(vif(model2))
cat("\n")

# Diagnostic plots
png("multi_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model2)
dev.off()
cat("Salvat: multi_diagnostic.png\n\n")

# =====================================================================
# 11. INTERPRETARE
# =====================================================================
cat("===========================================================================\n")
cat("11. INTERPRETARE\n")
cat("===========================================================================\n\n")

coef2_vals <- coef(model2)
cat("Coeficienti:\n")
cat("  Intercept (b0) =", sprintf("%.4f", coef2_vals[1]), "\n")
cat("  BMI_Z (b1) =", sprintf("%.4f", coef2_vals["BMI_Z"]),
    "=> La cresterea cu 1 unitate a scorului Z BMI,\n")
cat("    log10(CHIT) creste cu", sprintf("%.4f", coef2_vals["BMI_Z"]),
    ", controlind pentru gen, varsta si durata bolii.\n")
cat("    Aceasta corespunde unei multiplicari a CHIT cu 10^",
    sprintf("%.4f", coef2_vals["BMI_Z"]), " =", sprintf("%.4f", 10^coef2_vals["BMI_Z"]), "\n")
cat("  Gen (b2) =", sprintf("%.4f", coef2_vals["Gen"]), "\n")
cat("  Varsta_luni (b3) =", sprintf("%.4f", coef2_vals["Varsta_luni"]), "\n")
cat("  Durata_boala_ani (b4) =", sprintf("%.4f", coef2_vals["Durata_boala_ani"]), "\n\n")

cat("R² =", sprintf("%.4f", s2$r.squared), "=>",
    sprintf("%.1f%%", s2$r.squared*100),
    "din variabilitatea log10(CHIT) explicata de model.\n\n")

cat("=== ANALIZA COMPLETA ===\n")
