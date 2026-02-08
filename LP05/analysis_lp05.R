# =============================================================================
# LP05 - Regresia liniara multipla cu 2 variabile independente cantitative
# VD: Adictie_smartphone (scor SAS-SV, 10-60)
# VI1: Durata_utilizare_smartphone (ore/zi)
# VI2: Varsta_utilizare_smartphone (varsta la prima utilizare)
# n = 300 studenti
# =============================================================================

library(car)
library(lmtest)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
n <- nrow(data)
cat("n =", n, "\n\n")

# Rename for convenience
colnames(data)[colnames(data) == "Durata_utilizare_smartphone"] <- "Durata"
colnames(data)[colnames(data) == "Varsta_utilizare_smartphone"] <- "Varsta"
colnames(data)[colnames(data) == "Adictie_smartphone"] <- "Adictie"

# =====================================================================
#                      CAZUL I - REGRESIE LINIARA SIMPLA
#   VI = Durata_utilizare_smartphone → VD = Adictie_smartphone
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL I - REGRESIE LINIARA SIMPLA\n")
cat("# VI: Durata_utilizare_smartphone -> VD: Adictie_smartphone\n")
cat("###################################################################\n\n")

# --- 1. Specificarea variabilelor ---
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: Adictie_smartphone (scor SAS-SV) - cantitativa continua\n")
cat("VI: Durata_utilizare_smartphone (ore/zi) - cantitativa continua\n\n")

# --- 2. Analiza descriptiva ---
cat("2. ANALIZA DESCRIPTIVA\n\n")

desc_stats <- function(x, name) {
  q <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  iqr_val <- IQR(x, na.rm = TRUE)
  out <- x[x < q[1] - 1.5*iqr_val | x > q[2] + 1.5*iqr_val]
  cat(sprintf("--- %s ---\n", name))
  cat("  N:       ", length(x), "\n")
  cat("  NA:      ", sum(is.na(x)), "\n")
  cat("  Media:   ", sprintf("%.2f", mean(x, na.rm=TRUE)), "\n")
  cat("  Mediana: ", sprintf("%.2f", median(x, na.rm=TRUE)), "\n")
  cat("  SD:      ", sprintf("%.2f", sd(x, na.rm=TRUE)), "\n")
  cat("  Min:     ", sprintf("%.2f", min(x, na.rm=TRUE)), "\n")
  cat("  Max:     ", sprintf("%.2f", max(x, na.rm=TRUE)), "\n")
  cat("  Q1:      ", sprintf("%.2f", q[1]), "\n")
  cat("  Q3:      ", sprintf("%.2f", q[2]), "\n")
  cat("  IQR:     ", sprintf("%.2f", iqr_val), "\n")
  cat("  Outliers:", length(out), "\n\n")
}

desc_stats(data$Adictie, "Adictie_smartphone (scor SAS-SV)")
desc_stats(data$Durata, "Durata_utilizare_smartphone (ore/zi)")

# --- 3. Grafice ---
cat("3. GRAFICE\n\n")

# Boxplot Adictie
png("caso1_boxplot_adictie.png", width=600, height=400)
boxplot(data$Adictie, main="Distributia Adictie_smartphone",
        ylab="Scor SAS-SV", col="lightblue", border="darkblue")
dev.off()
cat("Saved: caso1_boxplot_adictie.png\n")

# Boxplot Durata
png("caso1_boxplot_durata.png", width=600, height=400)
boxplot(data$Durata, main="Distributia Durata_utilizare_smartphone",
        ylab="Ore/zi", col="lightgreen", border="darkgreen")
dev.off()
cat("Saved: caso1_boxplot_durata.png\n")

# Scatter plot
png("caso1_scatter.png", width=600, height=500)
plot(data$Durata, data$Adictie,
     xlab="Durata utilizare smartphone (ore/zi)",
     ylab="Adictie smartphone (scor SAS-SV)",
     main="Relatia dintre durata utilizarii si adictia la smartphone",
     pch=19, col=rgb(0,0,1,0.4))
abline(lm(Adictie ~ Durata, data=data), col="red", lwd=2)
dev.off()
cat("Saved: caso1_scatter.png\n\n")

# --- 4. Corelatia ---
cat("4. CORELATIA\n\n")
r <- cor(data$Durata, data$Adictie)
r_test <- cor.test(data$Durata, data$Adictie)
cat("  Pearson r =", sprintf("%.4f", r), "\n")
cat("  t =", sprintf("%.4f", r_test$statistic), "\n")
cat("  df =", r_test$parameter, "\n")
cat("  p-value =", format.pval(r_test$p.value, digits=4), "\n")
cat("  95% CI: [", sprintf("%.4f", r_test$conf.int[1]), ",",
    sprintf("%.4f", r_test$conf.int[2]), "]\n\n")

# --- 5. Model regresie liniara simpla ---
cat("5. MODELUL DE REGRESIE LINIARA SIMPLA\n\n")
model1 <- lm(Adictie ~ Durata, data=data)
s1 <- summary(model1)
print(s1)
cat("\n")

# Coefficients with CI
coef1 <- coef(s1)
ci1 <- confint(model1)
cat("--- Tabelul 0: Rezultate regresie simpla ---\n")
cat(sprintf("%-15s %10s %10s %10s %10s %10s %15s\n",
            "Variabila", "Coef(B)", "SE", "CI_low", "CI_up", "t(df)", "p-value"))
for (i in 1:nrow(coef1)) {
  tval <- sprintf("%.4f(%d)", coef1[i,3], model1$df.residual)
  pval <- format.pval(coef1[i,4], digits=4)
  cat(sprintf("%-15s %10.4f %10.4f %10.4f %10.4f %15s %15s\n",
              rownames(coef1)[i], coef1[i,1], coef1[i,2], ci1[i,1], ci1[i,2], tval, pval))
}
cat("\n")

# R-squared
cat("R-squared =", sprintf("%.4f", s1$r.squared), "\n")
cat("Adjusted R-squared =", sprintf("%.4f", s1$adj.r.squared), "\n")
cat("F-statistic =", sprintf("%.4f", s1$fstatistic[1]),
    "on", s1$fstatistic[2], "and", s1$fstatistic[3], "DF\n")
cat("p-value (F) =", format.pval(pf(s1$fstatistic[1], s1$fstatistic[2], s1$fstatistic[3], lower.tail=FALSE), digits=4), "\n\n")

# =====================================================================
#                      CAZUL II - REGRESIE LINIARA MULTIPLA
#   VI1 = Durata + VI2 = Varsta → VD = Adictie
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL II - REGRESIE LINIARA MULTIPLA CU 2 VI CANTITATIVE\n")
cat("# VI1: Durata_utilizare_smartphone\n")
cat("# VI2: Varsta_utilizare_smartphone\n")
cat("# VD: Adictie_smartphone\n")
cat("###################################################################\n\n")

# --- 1. Statistici descriptive ---
cat("1. STATISTICI DESCRIPTIVE\n\n")
desc_stats(data$Adictie, "Adictie_smartphone (scor SAS-SV)")
desc_stats(data$Durata, "Durata_utilizare_smartphone (ore/zi)")
desc_stats(data$Varsta, "Varsta_utilizare_smartphone (ani)")

# --- 2. Box-plots ---
cat("2. BOX-PLOTS\n\n")
png("caso2_boxplots.png", width=900, height=400)
par(mfrow=c(1,3))
boxplot(data$Adictie, main="Adictie smartphone", ylab="Scor SAS-SV", col="lightblue")
boxplot(data$Durata, main="Durata utilizare", ylab="Ore/zi", col="lightgreen")
boxplot(data$Varsta, main="Varsta prima utilizare", ylab="Ani", col="lightyellow")
dev.off()
cat("Saved: caso2_boxplots.png\n\n")

# --- 3. Scatter plots ---
cat("3. SCATTER PLOTS\n\n")
png("caso2_scatters.png", width=900, height=400)
par(mfrow=c(1,3))
plot(data$Durata, data$Adictie, xlab="Durata (ore/zi)", ylab="Adictie (SAS-SV)",
     main="Adictie vs Durata", pch=19, col=rgb(0,0,1,0.3))
abline(lm(Adictie ~ Durata, data=data), col="red", lwd=2)
plot(data$Varsta, data$Adictie, xlab="Varsta prima utilizare (ani)", ylab="Adictie (SAS-SV)",
     main="Adictie vs Varsta", pch=19, col=rgb(0,0.5,0,0.3))
abline(lm(Adictie ~ Varsta, data=data), col="red", lwd=2)
plot(data$Durata, data$Varsta, xlab="Durata (ore/zi)", ylab="Varsta prima utilizare (ani)",
     main="Varsta vs Durata", pch=19, col=rgb(0.5,0,0.5,0.3))
abline(lm(Varsta ~ Durata, data=data), col="red", lwd=2)
dev.off()
cat("Saved: caso2_scatters.png\n\n")

# --- 4. Matricea de corelatie ---
cat("4. MATRICEA DE CORELATIE\n\n")
cor_vars <- data[, c("Adictie", "Durata", "Varsta")]
cor_mat <- cor(cor_vars, use="complete.obs")
cat("Matricea de corelatie Pearson:\n")
print(round(cor_mat, 4))
cat("\n")

# Test de semnificatie pt fiecare pereche
pairs_list <- list(c("Adictie","Durata"), c("Adictie","Varsta"), c("Durata","Varsta"))
for (p in pairs_list) {
  ct <- cor.test(cor_vars[[p[1]]], cor_vars[[p[2]]])
  cat(sprintf("  %s vs %s: r=%.4f, t=%.4f, df=%d, p=%s\n",
              p[1], p[2], ct$estimate, ct$statistic, ct$parameter, format.pval(ct$p.value, digits=4)))
}
cat("\n")

# --- 5. Modelul de regresie liniara multipla ---
cat("5. MODELUL DE REGRESIE LINIARA MULTIPLA\n\n")
model2 <- lm(Adictie ~ Durata + Varsta, data=data)
s2 <- summary(model2)
print(s2)
cat("\n")

# --- 6. Testul de semnificatie globala (F) ---
cat("6. TESTUL DE SEMNIFICATIE GLOBALA (F)\n\n")
cat("Ipoteze:\n")
cat("  H0: beta1 = beta2 = 0 (modelul nu este semnificativ)\n")
cat("  H1: cel putin un beta_j != 0 (modelul este semnificativ)\n\n")
cat("F-statistic =", sprintf("%.4f", s2$fstatistic[1]), "\n")
cat("df1 (k) =", s2$fstatistic[2], "\n")
cat("df2 (n-k-1) =", s2$fstatistic[3], "\n")
p_f <- pf(s2$fstatistic[1], s2$fstatistic[2], s2$fstatistic[3], lower.tail=FALSE)
cat("p-value =", format.pval(p_f, digits=4), "\n\n")
if (p_f < 0.05) {
  cat("Decizie: p < 0.05, se respinge H0. Modelul de regresie multipla este semnificativ statistic.\n\n")
} else {
  cat("Decizie: p >= 0.05, nu se respinge H0. Modelul nu este semnificativ statistic.\n\n")
}

# --- 7. Teste individuale ---
cat("7. TESTE INDIVIDUALE PENTRU COEFICIENTI\n\n")
coef2 <- coef(s2)
ci2 <- confint(model2)
for (i in 2:nrow(coef2)) {
  cat(sprintf("--- %s ---\n", rownames(coef2)[i]))
  cat("  H0: beta =", 0, " H1: beta != 0\n")
  cat("  B =", sprintf("%.4f", coef2[i,1]), "\n")
  cat("  SE =", sprintf("%.4f", coef2[i,2]), "\n")
  cat("  t =", sprintf("%.4f", coef2[i,3]), "\n")
  cat("  df =", model2$df.residual, "\n")
  cat("  p-value =", format.pval(coef2[i,4], digits=4), "\n")
  cat("  95% CI: [", sprintf("%.4f", ci2[i,1]), ",", sprintf("%.4f", ci2[i,2]), "]\n")
  if (coef2[i,4] < 0.05) {
    cat("  Decizie: Semnificativ (p < 0.05)\n\n")
  } else {
    cat("  Decizie: Nesemnificativ (p >= 0.05)\n\n")
  }
}

# --- 8. R-squared ---
cat("8. COEFICIENTUL DE DETERMINARE\n\n")
cat("R-squared =", sprintf("%.4f", s2$r.squared), "\n")
cat("Adjusted R-squared =", sprintf("%.4f", s2$adj.r.squared), "\n")
cat("Interpretare: ", sprintf("%.1f%%", s2$r.squared*100),
    "din variabilitatea adictiei la smartphone este explicata de modelul cu\n")
cat("  durata de utilizare si varsta la prima utilizare a smartphone-ului.\n\n")

# --- 9. Diagnostice model ---
cat("9. DIAGNOSTICE MODEL\n\n")

# 9a. Liniaritate
cat("9a. LINIARITATE\n")
cat("Verificare prin graficele Residuals vs Fitted si partial regression plots.\n\n")

# 9b. Normalitatea reziduurilor
cat("9b. NORMALITATEA REZIDUURILOR\n\n")
resid2 <- residuals(model2)

# Shapiro-Wilk
sw <- shapiro.test(resid2)
cat("Shapiro-Wilk test: W =", sprintf("%.4f", sw$statistic), ", p =", format.pval(sw$p.value, digits=4), "\n")

# Kolmogorov-Smirnov
ks <- ks.test(resid2, "pnorm", mean=mean(resid2), sd=sd(resid2))
cat("Kolmogorov-Smirnov test: D =", sprintf("%.4f", ks$statistic), ", p =", format.pval(ks$p.value, digits=4), "\n\n")

# Diagnostic plots
png("caso2_diag_resid_fitted.png", width=600, height=500)
plot(model2, which=1, main="Residuals vs Fitted")
dev.off()
cat("Saved: caso2_diag_resid_fitted.png\n")

png("caso2_diag_qq.png", width=600, height=500)
plot(model2, which=2, main="Normal Q-Q")
dev.off()
cat("Saved: caso2_diag_qq.png\n")

png("caso2_diag_hist_resid.png", width=600, height=500)
hist(resid2, breaks=25, main="Histograma reziduurilor", xlab="Reziduuri",
     col="lightblue", border="darkblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid2), sd=sd(resid2)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Saved: caso2_diag_hist_resid.png\n")

# 9c. Homoscedasticitate
cat("\n9c. HOMOSCEDASTICITATE\n\n")
bp <- bptest(model2)
cat("Breusch-Pagan test:\n")
cat("  BP =", sprintf("%.4f", bp$statistic), "\n")
cat("  df =", bp$parameter, "\n")
cat("  p-value =", format.pval(bp$p.value, digits=4), "\n\n")

png("caso2_diag_scale_location.png", width=600, height=500)
plot(model2, which=3, main="Scale-Location")
dev.off()
cat("Saved: caso2_diag_scale_location.png\n")

# 9d. Independenta erorilor
cat("\n9d. INDEPENDENTA ERORILOR (Durbin-Watson)\n\n")
dw <- dwtest(model2)
cat("Durbin-Watson test:\n")
cat("  DW =", sprintf("%.4f", dw$statistic), "\n")
cat("  p-value =", format.pval(dw$p.value, digits=4), "\n\n")

# 9e. Outlieri si puncte influente
cat("9e. OUTLIERI SI PUNCTE INFLUENTE\n\n")
cook <- cooks.distance(model2)
influential <- which(cook > 4/n)
cat("Numar puncte cu Cook's D > 4/n:", length(influential), "\n")
if (length(influential) > 0) {
  cat("Indici:", paste(influential, collapse=", "), "\n")
  cat("Cook's D maxim:", sprintf("%.4f", max(cook)), "\n")
}
cat("\n")

png("caso2_diag_cooks.png", width=600, height=500)
plot(model2, which=4, main="Cook's Distance")
dev.off()
cat("Saved: caso2_diag_cooks.png\n")

png("caso2_diag_resid_leverage.png", width=600, height=500)
plot(model2, which=5, main="Residuals vs Leverage")
dev.off()
cat("Saved: caso2_diag_resid_leverage.png\n\n")

# 9f. Multicoliniaritate
cat("9f. MULTICOLINIARITATE (VIF)\n\n")
vif_vals <- vif(model2)
cat("VIF values:\n")
print(vif_vals)
cat("\n")
if (all(vif_vals < 5)) {
  cat("Toate valorile VIF < 5: nu exista probleme de multicoliniaritate.\n\n")
} else {
  cat("Atentie: exista valori VIF >= 5, posibila multicoliniaritate.\n\n")
}

# --- 10. Tabelul 1: Coeficienti regresie multipla ---
cat("10. TABELUL 1 - COEFICIENTI REGRESIE MULTIPLA\n\n")

# Standardized coefficients (beta)
data_scaled <- as.data.frame(scale(data[, c("Adictie", "Durata", "Varsta")]))
model2_std <- lm(Adictie ~ Durata + Varsta, data=data_scaled)
beta_std <- coef(model2_std)

cat(sprintf("%-15s %10s %10s %10s %10s %10s %10s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef2)) {
  tval <- sprintf("%.4f(%d)", coef2[i,3], model2$df.residual)
  pval <- format.pval(coef2[i,4], digits=4)
  beta_val <- if (i == 1) "-" else sprintf("%.4f", beta_std[i])
  cat(sprintf("%-15s %10.4f %10.4f %10.4f %10.4f %10s %15s %15s\n",
              rownames(coef2)[i], coef2[i,1], coef2[i,2], ci2[i,1], ci2[i,2],
              beta_val, tval, pval))
}
cat("\n")

# --- 11. Interpretarea coeficientilor ---
cat("11. INTERPRETAREA COEFICIENTILOR\n\n")
cat("a) Coeficienti de regresie partiala nestandardizati (B):\n")
cat(sprintf("   - Intercept (B0 = %.4f): Valoarea estimata a scorului de adictie\n", coef2[1,1]))
cat("     cand ambele VI sunt egale cu 0.\n")
cat(sprintf("   - Durata (B1 = %.4f): La o crestere cu 1 ora/zi a duratei de utilizare,\n", coef2[2,1]))
cat("     scorul de adictie creste in medie cu", sprintf("%.4f", coef2[2,1]),
    "puncte, controlind pentru varsta.\n")
cat(sprintf("   - Varsta (B2 = %.4f): La o crestere cu 1 an a varstei la prima utilizare,\n", coef2[3,1]))
cat("     scorul de adictie se modifica in medie cu", sprintf("%.4f", coef2[3,1]),
    "puncte, controlind pentru durata.\n\n")

cat("b) Coeficienti de regresie partiala standardizati (Beta):\n")
cat(sprintf("   - Durata: Beta = %.4f\n", beta_std[2]))
cat(sprintf("   - Varsta: Beta = %.4f\n", beta_std[3]))
cat("   Comparand valorile absolute ale coeficientilor Beta, variabila cu\n")
cat("   influenta mai mare asupra adictiei la smartphone este:",
    if (abs(beta_std[2]) > abs(beta_std[3])) "Durata_utilizare" else "Varsta_utilizare", "\n\n")

cat("c) Coeficientul de determinare R^2:\n")
cat(sprintf("   R^2 = %.4f => %.1f%% din variabilitatea adictiei la smartphone\n",
            s2$r.squared, s2$r.squared*100))
cat("   este explicata de modelul cu cele 2 variabile independente.\n")
cat(sprintf("   R^2 ajustat = %.4f\n\n", s2$adj.r.squared))

cat("=== ANALIZA COMPLETA ===\n")
