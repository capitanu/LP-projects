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
cat("=== Structura datelor ===\n")
str(data)
cat("n =", n, "\n\n")

# Rename for convenience
colnames(data)[colnames(data) == "Durata_utilizare_smartphone"] <- "Durata"
colnames(data)[colnames(data) == "Varsta_utilizare_smartphone"] <- "Varsta"
colnames(data)[colnames(data) == "Adictie_smartphone"] <- "Adictie"

# =====================================================================
#                      CAZUL I - REGRESIE LINIARA SIMPLA
#   VI = Durata_utilizare_smartphone -> VD = Adictie_smartphone
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL I - REGRESIE LINIARA SIMPLA\n")
cat("# VI: Durata_utilizare_smartphone -> VD: Adictie_smartphone\n")
cat("###################################################################\n\n")

# --- 1. Specificarea variabilelor ---
cat("===========================================================================\n")
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("===========================================================================\n\n")
cat("VD: Adictie_smartphone (scor SAS-SV) - cantitativa continua\n")
cat("VI: Durata_utilizare_smartphone (ore/zi) - cantitativa continua\n\n")

# --- 2. Analiza descriptiva ---
cat("===========================================================================\n")
cat("2. ANALIZA DESCRIPTIVA\n")
cat("===========================================================================\n\n")

# Adictie
cat("--- Adictie_smartphone (scor SAS-SV) ---\n")
cat("  N:       ", length(data$Adictie), "\n")
cat("  NA:      ", sum(is.na(data$Adictie)), "\n")
cat("  Media:   ", sprintf("%.2f", mean(data$Adictie, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.2f", median(data$Adictie, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.2f", sd(data$Adictie, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.2f", min(data$Adictie, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.2f", max(data$Adictie, na.rm=TRUE)), "\n")
q_ad <- quantile(data$Adictie, c(0.25, 0.75), na.rm=TRUE)
iqr_ad <- IQR(data$Adictie, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.2f", q_ad[1]), "\n")
cat("  Q3:      ", sprintf("%.2f", q_ad[2]), "\n")
cat("  IQR:     ", sprintf("%.2f", iqr_ad), "\n")
out_ad <- data$Adictie[data$Adictie < q_ad[1] - 1.5*iqr_ad | data$Adictie > q_ad[2] + 1.5*iqr_ad]
cat("  Outliers:", length(out_ad), "\n")
if (length(out_ad) > 0) cat("    Valori:", out_ad, "\n")
cat("\n")

# Durata
cat("--- Durata_utilizare_smartphone (ore/zi) ---\n")
cat("  N:       ", length(data$Durata), "\n")
cat("  NA:      ", sum(is.na(data$Durata)), "\n")
cat("  Media:   ", sprintf("%.2f", mean(data$Durata, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.2f", median(data$Durata, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.2f", sd(data$Durata, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.2f", min(data$Durata, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.2f", max(data$Durata, na.rm=TRUE)), "\n")
q_dur <- quantile(data$Durata, c(0.25, 0.75), na.rm=TRUE)
iqr_dur <- IQR(data$Durata, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.2f", q_dur[1]), "\n")
cat("  Q3:      ", sprintf("%.2f", q_dur[2]), "\n")
cat("  IQR:     ", sprintf("%.2f", iqr_dur), "\n")
out_dur <- data$Durata[data$Durata < q_dur[1] - 1.5*iqr_dur | data$Durata > q_dur[2] + 1.5*iqr_dur]
cat("  Outliers:", length(out_dur), "\n")
if (length(out_dur) > 0) cat("    Valori:", out_dur, "\n")
cat("\n")

# --- 3. Grafice ---
cat("===========================================================================\n")
cat("3. GRAFICE\n")
cat("===========================================================================\n\n")

png("caso1_boxplot_adictie.png", width=600, height=400)
boxplot(data$Adictie, main="Distributia Adictie_smartphone",
        ylab="Scor SAS-SV", col="lightblue", border="darkblue")
dev.off()
cat("Salvat: caso1_boxplot_adictie.png\n")

png("caso1_boxplot_durata.png", width=600, height=400)
boxplot(data$Durata, main="Distributia Durata_utilizare_smartphone",
        ylab="Ore/zi", col="lightgreen", border="darkgreen")
dev.off()
cat("Salvat: caso1_boxplot_durata.png\n")

png("caso1_scatter.png", width=600, height=500)
plot(data$Durata, data$Adictie,
     xlab="Durata utilizare smartphone (ore/zi)",
     ylab="Adictie smartphone (scor SAS-SV)",
     main="Relatia dintre durata utilizarii si adictia la smartphone",
     pch=19, col=rgb(0,0,1,0.4))
abline(lm(Adictie ~ Durata, data=data), col="red", lwd=2)
dev.off()
cat("Salvat: caso1_scatter.png\n\n")

# --- 4. Corelatia ---
cat("===========================================================================\n")
cat("4. CORELATIA\n")
cat("===========================================================================\n\n")

r_test <- cor.test(data$Durata, data$Adictie)
cat("Pearson r =", sprintf("%.4f", r_test$estimate), "\n")
cat("t =", sprintf("%.4f", r_test$statistic), "\n")
cat("df =", r_test$parameter, "\n")
cat("p-value =", format.pval(r_test$p.value, digits=4), "\n")
cat("95% CI: [", sprintf("%.4f", r_test$conf.int[1]), ",",
    sprintf("%.4f", r_test$conf.int[2]), "]\n\n")

# --- 5. Model regresie liniara simpla ---
cat("===========================================================================\n")
cat("5. MODELUL DE REGRESIE LINIARA SIMPLA\n")
cat("===========================================================================\n\n")

model1 <- lm(Adictie ~ Durata, data=data)
s1 <- summary(model1)
print(s1)
cat("\n")

b0 <- coef(model1)[1]
b1 <- coef(model1)[2]
cat("Ecuatia: Adictie =", sprintf("%.4f", b0), "+ (",
    sprintf("%.4f", b1), ") * Durata\n\n")

# Intervale de incredere
ci1 <- confint(model1)
cat("95% IC pentru b0 (intercept):", sprintf("(%.4f, %.4f)", ci1[1,1], ci1[1,2]), "\n")
cat("95% IC pentru b1 (Durata):", sprintf("(%.4f, %.4f)", ci1[2,1], ci1[2,2]), "\n\n")

# R² si F
cat("R² =", sprintf("%.4f", s1$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s1$adj.r.squared), "\n")
f1 <- s1$fstatistic
cat("F(", f1[2], ",", f1[3], ") =", sprintf("%.4f", f1[1]), "\n")
cat("p-value (F) =", format.pval(pf(f1[1], f1[2], f1[3], lower.tail=FALSE), digits=4), "\n\n")


# =====================================================================
#                      CAZUL II - REGRESIE LINIARA MULTIPLA
#   VI1 = Durata + VI2 = Varsta -> VD = Adictie
# =====================================================================
cat("###################################################################\n")
cat("# CAZUL II - REGRESIE LINIARA MULTIPLA CU 2 VI CANTITATIVE\n")
cat("# VI1: Durata_utilizare_smartphone\n")
cat("# VI2: Varsta_utilizare_smartphone\n")
cat("# VD: Adictie_smartphone\n")
cat("###################################################################\n\n")

# --- 1. Statistici descriptive ---
cat("===========================================================================\n")
cat("1. STATISTICI DESCRIPTIVE\n")
cat("===========================================================================\n\n")

# Varsta (Adictie si Durata deja afisate mai sus)
cat("--- Varsta_utilizare_smartphone (ani) ---\n")
cat("  N:       ", length(data$Varsta), "\n")
cat("  NA:      ", sum(is.na(data$Varsta)), "\n")
cat("  Media:   ", sprintf("%.2f", mean(data$Varsta, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.2f", median(data$Varsta, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.2f", sd(data$Varsta, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.2f", min(data$Varsta, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.2f", max(data$Varsta, na.rm=TRUE)), "\n")
q_var <- quantile(data$Varsta, c(0.25, 0.75), na.rm=TRUE)
iqr_var <- IQR(data$Varsta, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.2f", q_var[1]), "\n")
cat("  Q3:      ", sprintf("%.2f", q_var[2]), "\n")
cat("  IQR:     ", sprintf("%.2f", iqr_var), "\n")
out_var <- data$Varsta[data$Varsta < q_var[1] - 1.5*iqr_var | data$Varsta > q_var[2] + 1.5*iqr_var]
cat("  Outliers:", length(out_var), "\n\n")

# --- 2. Box-plots ---
cat("===========================================================================\n")
cat("2. BOX-PLOTS\n")
cat("===========================================================================\n\n")

png("caso2_boxplots.png", width=900, height=400)
par(mfrow=c(1,3))
boxplot(data$Adictie, main="Adictie smartphone", ylab="Scor SAS-SV", col="lightblue")
boxplot(data$Durata, main="Durata utilizare", ylab="Ore/zi", col="lightgreen")
boxplot(data$Varsta, main="Varsta prima utilizare", ylab="Ani", col="lightyellow")
dev.off()
cat("Salvat: caso2_boxplots.png\n\n")

# --- 3. Scatter plots ---
cat("===========================================================================\n")
cat("3. SCATTER PLOTS\n")
cat("===========================================================================\n\n")

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
cat("Salvat: caso2_scatters.png\n\n")

# --- 4. Matricea de corelatie ---
cat("===========================================================================\n")
cat("4. MATRICEA DE CORELATIE\n")
cat("===========================================================================\n\n")

cor_vars <- data[, c("Adictie", "Durata", "Varsta")]
cor_mat <- cor(cor_vars, use="complete.obs")
cat("Matricea de corelatie Pearson:\n")
print(round(cor_mat, 4))
cat("\n")

pairs_list <- list(c("Adictie","Durata"), c("Adictie","Varsta"), c("Durata","Varsta"))
for (p in pairs_list) {
  ct <- cor.test(cor_vars[[p[1]]], cor_vars[[p[2]]])
  cat(sprintf("  %s vs %s: r=%.4f, t=%.4f, df=%d, p=%s\n",
              p[1], p[2], ct$estimate, ct$statistic, ct$parameter, format.pval(ct$p.value, digits=4)))
}
cat("\n")

# --- 5. Modelul de regresie liniara multipla ---
cat("===========================================================================\n")
cat("5. MODELUL DE REGRESIE LINIARA MULTIPLA\n")
cat("===========================================================================\n\n")

model2 <- lm(Adictie ~ Durata + Varsta, data=data)
s2 <- summary(model2)
print(s2)
cat("\n")

b0_2 <- coef(model2)[1]
b1_2 <- coef(model2)[2]
b2_2 <- coef(model2)[3]
cat("Ecuatia: Adictie =", sprintf("%.4f", b0_2), "+ (",
    sprintf("%.4f", b1_2), ") * Durata + (",
    sprintf("%.4f", b2_2), ") * Varsta\n\n")

# --- 6. Testul de semnificatie globala (F) ---
cat("===========================================================================\n")
cat("6. TESTUL DE SEMNIFICATIE GLOBALA (F)\n")
cat("===========================================================================\n\n")

cat("H0: beta1 = beta2 = 0 (modelul nu este semnificativ)\n")
cat("H1: cel putin un beta_j != 0 (modelul este semnificativ)\n\n")
cat("F =", sprintf("%.4f", s2$fstatistic[1]), "\n")
cat("df1 (k) =", s2$fstatistic[2], "\n")
cat("df2 (n-k-1) =", s2$fstatistic[3], "\n")
p_f <- pf(s2$fstatistic[1], s2$fstatistic[2], s2$fstatistic[3], lower.tail=FALSE)
cat("p-value =", format.pval(p_f, digits=4), "\n\n")
if (p_f < 0.05) {
  cat("Decizie: p < 0.05, se respinge H0. Modelul este semnificativ statistic.\n\n")
} else {
  cat("Decizie: p >= 0.05, nu se respinge H0. Modelul nu este semnificativ.\n\n")
}

# --- 7. Teste individuale ---
cat("===========================================================================\n")
cat("7. TESTE INDIVIDUALE PENTRU COEFICIENTI\n")
cat("===========================================================================\n\n")

coef2 <- s2$coefficients
ci2 <- confint(model2)
for (i in 2:nrow(coef2)) {
  cat(sprintf("--- %s ---\n", rownames(coef2)[i]))
  cat("  H0: beta = 0  H1: beta != 0\n")
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
cat("===========================================================================\n")
cat("8. COEFICIENTUL DE DETERMINARE\n")
cat("===========================================================================\n\n")

cat("R² =", sprintf("%.4f", s2$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s2$adj.r.squared), "\n")
cat("Interpretare:", sprintf("%.1f%%", s2$r.squared*100),
    "din variabilitatea adictiei la smartphone este explicata de model.\n\n")

# --- 9. Diagnostice model ---
cat("===========================================================================\n")
cat("9. DIAGNOSTICE MODEL\n")
cat("===========================================================================\n\n")

# a) Normalitatea reziduurilor
cat("a) Normalitatea reziduurilor:\n\n")
resid2 <- residuals(model2)

sw <- shapiro.test(resid2)
cat("  Shapiro-Wilk: W =", sprintf("%.4f", sw$statistic), ", p =", format.pval(sw$p.value, digits=4), "\n")
if (sw$p.value > 0.05) {
  cat("  Concluzie: Reziduurile sunt normal distribuite (p > 0.05).\n\n")
} else {
  cat("  Concluzie: Reziduurile NU sunt normal distribuite (p < 0.05).\n\n")
}

png("caso2_diag_resid_fitted.png", width=600, height=500)
plot(model2, which=1, main="Residuals vs Fitted")
dev.off()
cat("  Salvat: caso2_diag_resid_fitted.png\n")

png("caso2_diag_qq.png", width=600, height=500)
plot(model2, which=2, main="Normal Q-Q")
dev.off()
cat("  Salvat: caso2_diag_qq.png\n")

png("caso2_diag_hist_resid.png", width=600, height=500)
hist(resid2, breaks=25, main="Histograma reziduurilor", xlab="Reziduuri",
     col="lightblue", border="darkblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid2), sd=sd(resid2)), add=TRUE, col="red", lwd=2)
dev.off()
cat("  Salvat: caso2_diag_hist_resid.png\n\n")

# b) Homoscedasticitate
cat("b) Homoscedasticitatea:\n\n")
bp <- bptest(model2)
cat("  Breusch-Pagan: BP =", sprintf("%.4f", bp$statistic),
    ", df =", bp$parameter, ", p =", format.pval(bp$p.value, digits=4), "\n")
if (bp$p.value > 0.05) {
  cat("  Concluzie: Homoscedasticitatea este respectata (p > 0.05).\n\n")
} else {
  cat("  Concluzie: Heteroscedasticitate detectata (p < 0.05).\n\n")
}

png("caso2_diag_scale_location.png", width=600, height=500)
plot(model2, which=3, main="Scale-Location")
dev.off()
cat("  Salvat: caso2_diag_scale_location.png\n\n")

# c) Independenta erorilor
cat("c) Independenta erorilor (Durbin-Watson):\n\n")
dw <- dwtest(model2)
cat("  DW =", sprintf("%.4f", dw$statistic), ", p =", format.pval(dw$p.value, digits=4), "\n")
if (dw$p.value > 0.05) {
  cat("  Concluzie: Erorile sunt independente (p > 0.05).\n\n")
} else {
  cat("  Concluzie: Erorile NU sunt independente (p < 0.05).\n\n")
}

# d) Outlieri si puncte influente
cat("d) Outlieri si puncte influente:\n\n")
cook <- cooks.distance(model2)
influential <- which(cook > 4/n)
cat("  Nr. observatii cu Cook's D > 4/n:", length(influential), "\n")
if (length(influential) > 0) {
  cat("  Indici:", paste(influential, collapse=", "), "\n")
}

std_res <- rstandard(model2)
outliers_std <- which(abs(std_res) > 2)
cat("  Nr. observatii cu reziduuri standardizate |> 2|:", length(outliers_std), "\n\n")

png("caso2_diag_cooks.png", width=600, height=500)
plot(model2, which=4, main="Cook's Distance")
dev.off()
cat("  Salvat: caso2_diag_cooks.png\n")

png("caso2_diag_resid_leverage.png", width=600, height=500)
plot(model2, which=5, main="Residuals vs Leverage")
dev.off()
cat("  Salvat: caso2_diag_resid_leverage.png\n\n")

# e) Multicoliniaritate
cat("e) Multicoliniaritate (VIF):\n\n")
vif_vals <- vif(model2)
print(vif_vals)
if (all(vif_vals < 5)) {
  cat("\n  Toate valorile VIF < 5: nu exista probleme de multicoliniaritate.\n\n")
} else {
  cat("\n  Atentie: exista valori VIF >= 5, posibila multicoliniaritate.\n\n")
}

# 4-panel diagnostic
png("caso2_diagnostic_4panel.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model2)
dev.off()
cat("Salvat: caso2_diagnostic_4panel.png\n\n")

# --- 10. Interpretare ---
cat("===========================================================================\n")
cat("10. INTERPRETARE\n")
cat("===========================================================================\n\n")

cat("Coeficienti:\n")
cat("  Intercept (b0) =", sprintf("%.4f", b0_2), "\n")
cat("  Durata (b1) =", sprintf("%.4f", b1_2),
    "=> La o crestere cu 1 ora/zi, scorul de adictie creste cu",
    sprintf("%.4f", b1_2), "puncte, controlind pentru varsta.\n")
cat("  Varsta (b2) =", sprintf("%.4f", b2_2),
    "=> La o crestere cu 1 an a varstei la prima utilizare,\n")
cat("    scorul de adictie se modifica cu", sprintf("%.4f", b2_2),
    "puncte, controlind pentru durata.\n\n")

cat("R² =", sprintf("%.4f", s2$r.squared), "=>",
    sprintf("%.1f%%", s2$r.squared*100),
    "din variabilitatea adictiei este explicata de model.\n\n")

cat("=== ANALIZA COMPLETA ===\n")
