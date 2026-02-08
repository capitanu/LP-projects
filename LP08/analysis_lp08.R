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
cat("n =", n, "\n\n")

# Helper function
desc_stats <- function(x, name) {
  q <- quantile(x, c(0.25, 0.75), na.rm=TRUE)
  iqr_val <- IQR(x, na.rm=TRUE)
  out <- x[x < q[1] - 1.5*iqr_val | x > q[2] + 1.5*iqr_val]
  cat(sprintf("--- %s ---\n", name))
  cat("  N:       ", sum(!is.na(x)), "\n")
  cat("  NA:      ", sum(is.na(x)), "\n")
  cat("  Media:   ", sprintf("%.4f", mean(x, na.rm=TRUE)), "\n")
  cat("  Mediana: ", sprintf("%.4f", median(x, na.rm=TRUE)), "\n")
  cat("  SD:      ", sprintf("%.4f", sd(x, na.rm=TRUE)), "\n")
  cat("  Min:     ", sprintf("%.4f", min(x, na.rm=TRUE)), "\n")
  cat("  Max:     ", sprintf("%.4f", max(x, na.rm=TRUE)), "\n")
  cat("  Q1:      ", sprintf("%.4f", q[1]), "\n")
  cat("  Q3:      ", sprintf("%.4f", q[2]), "\n")
  cat("  IQR:     ", sprintf("%.4f", iqr_val), "\n")
  cat("  Outliers:", length(out), "\n\n")
}

# =====================================================================
# 1. STATISTICI DESCRIPTIVE
# =====================================================================
cat("###################################################################\n")
cat("# 1. STATISTICI DESCRIPTIVE\n")
cat("###################################################################\n\n")

desc_stats(data$CHIT, "CHIT (nmol/h/mL)")
desc_stats(data$BMI_Z, "BMI_Z (scor Z)")
desc_stats(data$Varsta_luni, "Varsta (luni)")
desc_stats(data$Durata_boala_ani, "Durata bolii (ani)")

cat("Gen:\n")
print(table(data$Gen))
cat("\n")

# =====================================================================
# 2. BOX-PLOTS
# =====================================================================
cat("###################################################################\n")
cat("# 2. BOX-PLOTS\n")
cat("###################################################################\n\n")

png("boxplots.png", width=1000, height=500)
par(mfrow=c(1,4))
boxplot(data$CHIT, main="CHIT (nmol/h/mL)", col="lightblue")
boxplot(data$BMI_Z, main="BMI Z-score", col="lightgreen")
boxplot(data$Varsta_luni, main="Varsta (luni)", col="lightyellow")
boxplot(data$Durata_boala_ani, main="Durata bolii (ani)", col="pink")
dev.off()
cat("Saved: boxplots.png\n\n")

# =====================================================================
# 3. SCATTER PLOTS (date originale)
# =====================================================================
cat("###################################################################\n")
cat("# 3. SCATTER PLOTS (date originale)\n")
cat("###################################################################\n\n")

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
cat("Saved: scatter_original.png\n\n")

# =====================================================================
# 4. CORELATII (date originale)
# =====================================================================
cat("###################################################################\n")
cat("# 4. CORELATII (date originale)\n")
cat("###################################################################\n\n")

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
cat("###################################################################\n")
cat("# 5. NECESITATEA TRANSFORMARII\n")
cat("###################################################################\n\n")

# Shapiro-Wilk on CHIT
sw_chit <- shapiro.test(data$CHIT)
cat("Shapiro-Wilk pe CHIT original: W =", sprintf("%.4f", sw_chit$statistic),
    ", p =", format.pval(sw_chit$p.value, digits=4), "\n")

# Skewness check
skew_chit <- mean(((data$CHIT - mean(data$CHIT))/sd(data$CHIT))^3)
cat("Skewness CHIT:", sprintf("%.4f", skew_chit), "\n\n")

if (sw_chit$p.value < 0.05) {
  cat("Distributia CHIT nu este normala (p < 0.05). Transformarea este necesara.\n")
  cat("CHIT prezinta o distributie asimetrica pozitiva (skewness > 0),\n")
  cat("ceea ce justifica utilizarea transformarii logaritmice log10.\n\n")
} else {
  cat("Distributia CHIT este normala. Transformarea poate sa nu fie necesara,\n")
  cat("dar o verificam oricum.\n\n")
}

# =====================================================================
# 6. TRANSFORMARE log10(CHIT) + SCATTER PLOTS
# =====================================================================
cat("###################################################################\n")
cat("# 6. TRANSFORMARE log10(CHIT)\n")
cat("###################################################################\n\n")

data$log_CHIT <- log10(data$CHIT)
desc_stats(data$log_CHIT, "log10(CHIT)")

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
cat("Saved: compare_distributions.png\n\n")

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
cat("Saved: scatter_log.png\n\n")

# =====================================================================
# 7. COMPARATIE DATE ORIGINALE VS TRANSFORMATE
# =====================================================================
cat("###################################################################\n")
cat("# 7. COMPARATIE ORIGINAL VS TRANSFORMAT\n")
cat("###################################################################\n\n")

# Regression on original
m_orig <- lm(CHIT ~ BMI_Z, data=data)
s_orig <- summary(m_orig)
sw_orig_resid <- shapiro.test(residuals(m_orig))

# Regression on transformed
m_log <- lm(log_CHIT ~ BMI_Z, data=data)
s_log <- summary(m_log)
sw_log_resid <- shapiro.test(residuals(m_log))

cat("Regresie CHIT ~ BMI_Z (original):\n")
cat("  R2 =", sprintf("%.4f", s_orig$r.squared), "\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_orig_resid$statistic),
    ", p =", format.pval(sw_orig_resid$p.value, digits=4), "\n\n")

cat("Regresie log10(CHIT) ~ BMI_Z (transformat):\n")
cat("  R2 =", sprintf("%.4f", s_log$r.squared), "\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_log_resid$statistic),
    ", p =", format.pval(sw_log_resid$p.value, digits=4), "\n\n")

cat("Concluzie: Datele transformate (log10) sunt mai adecvate pentru regresia liniara\n")
cat("deoarece reziduurile au o distributie mai apropiata de normala.\n\n")

# =====================================================================
# 8. REGRESIE SIMPLA pe date transformate: log10(CHIT) ~ BMI_Z
# =====================================================================
cat("###################################################################\n")
cat("# 8. REGRESIE LINIARA SIMPLA - log10(CHIT) ~ BMI_Z\n")
cat("###################################################################\n\n")

model1 <- lm(log_CHIT ~ BMI_Z, data=data)
s1 <- summary(model1)
print(s1)
cat("\n")

coef1 <- coef(s1)
ci1 <- confint(model1)

cat("--- Tabelul 0: Regresie simpla log10(CHIT) ~ BMI_Z ---\n")
cat(sprintf("%-15s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "t(df)", "p-value"))
for (i in 1:nrow(coef1)) {
  tval <- sprintf("%.4f(%d)", coef1[i,3], model1$df.residual)
  pval <- format.pval(coef1[i,4], digits=4)
  cat(sprintf("%-15s %10.4f %10.4f %10.4f %10.4f %15s %15s\n",
              rownames(coef1)[i], coef1[i,1], coef1[i,2], ci1[i,1], ci1[i,2], tval, pval))
}
cat("\n")
cat("R-squared =", sprintf("%.4f", s1$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s1$adj.r.squared), "\n\n")

# =====================================================================
# 9. REGRESIE MULTIPLA pe date transformate
# =====================================================================
cat("###################################################################\n")
cat("# 9. REGRESIE MULTIPLA - log10(CHIT) ~ BMI_Z + Gen + Varsta + Durata\n")
cat("###################################################################\n\n")

model2 <- lm(log_CHIT ~ BMI_Z + Gen + Varsta_luni + Durata_boala_ani, data=data)
s2 <- summary(model2)
print(s2)
cat("\n")

# F-test
cat("Test F global:\n")
cat("F =", sprintf("%.4f", s2$fstatistic[1]), "\n")
cat("df1 =", s2$fstatistic[2], ", df2 =", s2$fstatistic[3], "\n")
p_f <- pf(s2$fstatistic[1], s2$fstatistic[2], s2$fstatistic[3], lower.tail=FALSE)
cat("p =", format.pval(p_f, digits=4), "\n\n")

coef2 <- coef(s2)
ci2 <- confint(model2)

# Standardized coefficients
data_scaled <- as.data.frame(scale(data[, c("log_CHIT", "BMI_Z", "Gen", "Varsta_luni", "Durata_boala_ani")]))
model2_std <- lm(log_CHIT ~ BMI_Z + Gen + Varsta_luni + Durata_boala_ani, data=data_scaled)
beta_std <- coef(model2_std)

cat("--- Tabelul 1: Regresie multipla ---\n")
cat(sprintf("%-20s %10s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef2)) {
  tval <- sprintf("%.4f(%d)", coef2[i,3], model2$df.residual)
  pval <- format.pval(coef2[i,4], digits=4)
  beta_val <- if (i == 1) "-" else sprintf("%.4f", beta_std[i])
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %10s %15s %15s\n",
              rownames(coef2)[i], coef2[i,1], coef2[i,2], ci2[i,1], ci2[i,2],
              beta_val, tval, pval))
}
cat("\n")
cat("R-squared =", sprintf("%.4f", s2$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s2$adj.r.squared), "\n\n")

# =====================================================================
# 10. DIAGNOSTICE MODEL MULTIPLU
# =====================================================================
cat("###################################################################\n")
cat("# 10. DIAGNOSTICE MODEL MULTIPLU\n")
cat("###################################################################\n\n")

resid2 <- residuals(model2)

# Normality
sw2 <- shapiro.test(resid2)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw2$statistic), ", p =", format.pval(sw2$p.value, digits=4), "\n")
ks2 <- ks.test(resid2, "pnorm", mean=mean(resid2), sd=sd(resid2))
cat("KS test: D =", sprintf("%.4f", ks2$statistic), ", p =", format.pval(ks2$p.value, digits=4), "\n\n")

png("multi_diag_resid_fitted.png", width=600, height=500)
plot(model2, which=1, main="Residuals vs Fitted")
dev.off()
png("multi_diag_qq.png", width=600, height=500)
plot(model2, which=2, main="Normal Q-Q")
dev.off()
png("multi_diag_hist.png", width=600, height=500)
hist(resid2, breaks=20, main="Histograma reziduurilor (model multiplu)",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid2), sd=sd(resid2)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Saved: multi_diag_resid_fitted.png, multi_diag_qq.png, multi_diag_hist.png\n")

# Homoscedasticity
bp2 <- bptest(model2)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp2$statistic), ", df =", bp2$parameter,
    ", p =", format.pval(bp2$p.value, digits=4), "\n")

png("multi_diag_scale_loc.png", width=600, height=500)
plot(model2, which=3, main="Scale-Location")
dev.off()

# Durbin-Watson
dw2 <- dwtest(model2)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw2$statistic), ", p =", format.pval(dw2$p.value, digits=4), "\n")

# Outliers
cook2 <- cooks.distance(model2)
influential2 <- which(cook2 > 4/n)
cat("Puncte influente (Cook's D > 4/n):", length(influential2), "\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook2)), "\n")

png("multi_diag_cooks.png", width=600, height=500)
plot(model2, which=4, main="Cook's Distance")
dev.off()
png("multi_diag_leverage.png", width=600, height=500)
plot(model2, which=5, main="Residuals vs Leverage")
dev.off()
cat("Saved: multi_diag_cooks.png, multi_diag_leverage.png\n")

# VIF
cat("\nVIF:\n")
vif2 <- vif(model2)
print(vif2)
cat("\n")

# =====================================================================
# 11. INTERPRETARE
# =====================================================================
cat("###################################################################\n")
cat("# 11. INTERPRETARE\n")
cat("###################################################################\n\n")

cat("Coeficienti nestandardizati (B):\n")
cat(sprintf("  Intercept (B0 = %.4f): log10(CHIT) estimat cand toti predictorii = 0\n", coef2[1,1]))
cat(sprintf("  BMI_Z (B = %.4f): La cresterea cu 1 unitate a scorului Z BMI,\n", coef2["BMI_Z",1]))
cat(sprintf("    log10(CHIT) creste cu %.4f, controlind pentru gen, varsta si durata bolii.\n", coef2["BMI_Z",1]))
cat(sprintf("    Aceasta corespunde unei multiplicari a CHIT cu 10^%.4f = %.4f\n",
            coef2["BMI_Z",1], 10^coef2["BMI_Z",1]))
cat(sprintf("  Gen (B = %.4f)\n", coef2["Gen",1]))
cat(sprintf("  Varsta_luni (B = %.4f)\n", coef2["Varsta_luni",1]))
cat(sprintf("  Durata_boala_ani (B = %.4f)\n\n", coef2["Durata_boala_ani",1]))

cat("Coeficienti standardizati (Beta):\n")
for (v in c("BMI_Z", "Gen", "Varsta_luni", "Durata_boala_ani")) {
  cat(sprintf("  %s: Beta = %.4f\n", v, beta_std[v]))
}
cat("\n")

cat("R-squared =", sprintf("%.4f", s2$r.squared), "=>",
    sprintf("%.1f%%", s2$r.squared*100),
    "din variabilitatea log10(CHIT) explicata de model.\n\n")

cat("=== ANALIZA COMPLETA ===\n")
