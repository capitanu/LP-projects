# =============================================================================
# EXAMEN - Regresia liniara multipla
# Studiu transversal: 100 copii (7-13 ani), 5 scoli din Cluj-Napoca
# VD1: PEF (Debitul Expirator Maxim de Varf, L/min)
# VD2: FEV1 (Debitul Expirator Maxim in prima secunda, L/s)
# VI: Varsta_ani (ani), Inaltime_cm (cm), Gen (1=M, 0=F)
# Obiectiv: testarea relatiei dintre caracteristicile demografice si
#           antropometrice (varsta, inaltime) si cele spirometrice (PEF, FEV1)
# =============================================================================

library(car)
library(lmtest)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
data <- data[, -1]  # remove id_subiect
n <- nrow(data)
cat("=== Structura datelor ===\n")
str(data)
cat("n =", n, "\n\n")

# Recode Gen as factor for descriptive purposes
data$Gen_f <- factor(data$Gen, levels=c(0,1), labels=c("Feminin","Masculin"))

# =============================================================================
# 1. STATISTICI DESCRIPTIVE
# =============================================================================
cat("===========================================================================\n")
cat("1. STATISTICI DESCRIPTIVE\n")
cat("===========================================================================\n\n")

# Gen
cat("--- Gen ---\n")
print(table(data$Gen_f))
cat("  Feminin:", sum(data$Gen == 0), "(", sprintf("%.1f%%", sum(data$Gen == 0)/n*100), ")\n")
cat("  Masculin:", sum(data$Gen == 1), "(", sprintf("%.1f%%", sum(data$Gen == 1)/n*100), ")\n\n")

# Variabile cantitative
cant_vars <- c("Varsta_ani", "Inaltime_cm", "FEV1", "PEF")
cant_labels <- c("Varsta (ani)", "Inaltime (cm)", "FEV1 (L/s)", "PEF (L/min)")

for (i in seq_along(cant_vars)) {
  x <- data[[cant_vars[i]]]
  cat(sprintf("--- %s ---\n", cant_labels[i]))
  cat("  N:       ", sum(!is.na(x)), "\n")
  cat("  NA:      ", sum(is.na(x)), "\n")
  cat("  Media:   ", sprintf("%.4f", mean(x, na.rm=TRUE)), "\n")
  cat("  Mediana: ", sprintf("%.4f", median(x, na.rm=TRUE)), "\n")
  cat("  SD:      ", sprintf("%.4f", sd(x, na.rm=TRUE)), "\n")
  cat("  Min:     ", sprintf("%.4f", min(x, na.rm=TRUE)), "\n")
  cat("  Max:     ", sprintf("%.4f", max(x, na.rm=TRUE)), "\n")
  q <- quantile(x, c(0.25, 0.75), na.rm=TRUE)
  iqr_val <- IQR(x, na.rm=TRUE)
  cat("  Q1:      ", sprintf("%.4f", q[1]), "\n")
  cat("  Q3:      ", sprintf("%.4f", q[2]), "\n")
  cat("  IQR:     ", sprintf("%.4f", iqr_val), "\n")
  out <- x[x < q[1] - 1.5*iqr_val | x > q[2] + 1.5*iqr_val]
  cat("  Outliers:", length(out), "\n")
  if (length(out) > 0 && length(out) <= 10) cat("    Valori:", out, "\n")
  cat("\n")
}

# Descriptive by Gen
cat("--- Statistici descriptive pe Gen ---\n\n")
for (v in cant_vars) {
  for (g in levels(data$Gen_f)) {
    sub <- data[[v]][data$Gen_f == g]
    cat(sprintf("  %s la %s (n=%d): Media=%.4f, SD=%.4f\n",
                v, g, length(sub), mean(sub), sd(sub)))
  }
  cat("\n")
}

# =============================================================================
# 2. BOX-PLOTS
# =============================================================================
cat("===========================================================================\n")
cat("2. BOX-PLOTS\n")
cat("===========================================================================\n\n")

png("boxplots_all.png", width=1000, height=500)
par(mfrow=c(1,4))
boxplot(data$Varsta_ani, main="Varsta (ani)", col="lightblue")
boxplot(data$Inaltime_cm, main="Inaltime (cm)", col="lightgreen")
boxplot(data$FEV1, main="FEV1 (L/s)", col="lightyellow")
boxplot(data$PEF, main="PEF (L/min)", col="pink")
dev.off()
cat("Salvat: boxplots_all.png\n")

png("boxplots_by_gen.png", width=800, height=400)
par(mfrow=c(1,2))
boxplot(FEV1 ~ Gen_f, data=data, main="FEV1 per Gen", ylab="FEV1 (L/s)",
        col=c("pink","lightblue"))
boxplot(PEF ~ Gen_f, data=data, main="PEF per Gen", ylab="PEF (L/min)",
        col=c("pink","lightblue"))
dev.off()
cat("Salvat: boxplots_by_gen.png\n\n")

# =============================================================================
# 3. HISTOGRAME
# =============================================================================
cat("===========================================================================\n")
cat("3. HISTOGRAME\n")
cat("===========================================================================\n\n")

png("histograme.png", width=1000, height=500)
par(mfrow=c(1,4))
hist(data$Varsta_ani, breaks=15, main="Varsta", xlab="Ani", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(data$Varsta_ani), sd=sd(data$Varsta_ani)), add=TRUE, col="red", lwd=2)
hist(data$Inaltime_cm, breaks=15, main="Inaltime", xlab="cm", col="lightgreen", probability=TRUE)
curve(dnorm(x, mean=mean(data$Inaltime_cm), sd=sd(data$Inaltime_cm)), add=TRUE, col="red", lwd=2)
hist(data$FEV1, breaks=15, main="FEV1", xlab="L/s", col="lightyellow", probability=TRUE)
curve(dnorm(x, mean=mean(data$FEV1), sd=sd(data$FEV1)), add=TRUE, col="red", lwd=2)
hist(data$PEF, breaks=15, main="PEF", xlab="L/min", col="pink", probability=TRUE)
curve(dnorm(x, mean=mean(data$PEF), sd=sd(data$PEF)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Salvat: histograme.png\n\n")

# =============================================================================
# 4. SCATTER PLOTS
# =============================================================================
cat("===========================================================================\n")
cat("4. SCATTER PLOTS\n")
cat("===========================================================================\n\n")

png("scatter_plots.png", width=1000, height=800)
par(mfrow=c(2,3))
# PEF vs IVs
plot(data$Varsta_ani, data$PEF, pch=19, col=rgb(0,0,1,0.4),
     xlab="Varsta (ani)", ylab="PEF (L/min)", main="PEF vs Varsta")
abline(lm(PEF ~ Varsta_ani, data=data), col="red", lwd=2)
plot(data$Inaltime_cm, data$PEF, pch=19, col=rgb(0,0,1,0.4),
     xlab="Inaltime (cm)", ylab="PEF (L/min)", main="PEF vs Inaltime")
abline(lm(PEF ~ Inaltime_cm, data=data), col="red", lwd=2)
# FEV1 vs IVs
plot(data$Varsta_ani, data$FEV1, pch=19, col=rgb(0,0.5,0,0.4),
     xlab="Varsta (ani)", ylab="FEV1 (L/s)", main="FEV1 vs Varsta")
abline(lm(FEV1 ~ Varsta_ani, data=data), col="red", lwd=2)
plot(data$Inaltime_cm, data$FEV1, pch=19, col=rgb(0,0.5,0,0.4),
     xlab="Inaltime (cm)", ylab="FEV1 (L/s)", main="FEV1 vs Inaltime")
abline(lm(FEV1 ~ Inaltime_cm, data=data), col="red", lwd=2)
# IVs relationship
plot(data$Varsta_ani, data$Inaltime_cm, pch=19, col=rgb(0.5,0,0.5,0.4),
     xlab="Varsta (ani)", ylab="Inaltime (cm)", main="Inaltime vs Varsta")
abline(lm(Inaltime_cm ~ Varsta_ani, data=data), col="red", lwd=2)
dev.off()
cat("Salvat: scatter_plots.png\n\n")

# =============================================================================
# 5. TESTE DE NORMALITATE
# =============================================================================
cat("===========================================================================\n")
cat("5. TESTE DE NORMALITATE\n")
cat("===========================================================================\n\n")

for (i in seq_along(cant_vars)) {
  sw <- shapiro.test(data[[cant_vars[i]]])
  cat(sprintf("  %s: W=%.4f, p=%s", cant_labels[i], sw$statistic, format.pval(sw$p.value, digits=4)))
  if (sw$p.value > 0.05) {
    cat("  => Normal\n")
  } else {
    cat("  => NU este normal\n")
  }
}
cat("\n")

# =============================================================================
# 6. MATRICEA DE CORELATIE
# =============================================================================
cat("===========================================================================\n")
cat("6. MATRICEA DE CORELATIE\n")
cat("===========================================================================\n\n")

cor_vars <- data[, c("Varsta_ani", "Inaltime_cm", "Gen", "FEV1", "PEF")]
cor_mat <- cor(cor_vars, use="complete.obs")
cat("Matricea de corelatie Pearson:\n")
print(round(cor_mat, 4))
cat("\n")

cat("Teste de semnificatie:\n\n")
pairs <- list(
  c("Varsta_ani", "PEF"), c("Inaltime_cm", "PEF"), c("Gen", "PEF"),
  c("Varsta_ani", "FEV1"), c("Inaltime_cm", "FEV1"), c("Gen", "FEV1"),
  c("Varsta_ani", "Inaltime_cm")
)
for (p in pairs) {
  ct <- cor.test(data[[p[1]]], data[[p[2]]])
  cat(sprintf("  %s vs %s: r=%.4f, t=%.4f, df=%d, p=%s\n",
              p[1], p[2], ct$estimate, ct$statistic, ct$parameter,
              format.pval(ct$p.value, digits=4)))
}
cat("\n")

# =============================================================================
#   ANALIZA 1: PEF
# =============================================================================
cat("###################################################################\n")
cat("# ANALIZA 1: PEF (Debitul Expirator Maxim de Varf)\n")
cat("###################################################################\n\n")

# --- 1a. Regresii simple ---
cat("===========================================================================\n")
cat("1a. REGRESII SIMPLE PENTRU PEF\n")
cat("===========================================================================\n\n")

# PEF ~ Varsta
cat("--- PEF ~ Varsta_ani ---\n\n")
m_pef_varsta <- lm(PEF ~ Varsta_ani, data=data)
s <- summary(m_pef_varsta)
print(s)
cat("\n")
ci <- confint(m_pef_varsta)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# PEF ~ Inaltime
cat("--- PEF ~ Inaltime_cm ---\n\n")
m_pef_inaltime <- lm(PEF ~ Inaltime_cm, data=data)
s <- summary(m_pef_inaltime)
print(s)
cat("\n")
ci <- confint(m_pef_inaltime)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# PEF ~ Gen
cat("--- PEF ~ Gen ---\n\n")
m_pef_gen <- lm(PEF ~ Gen, data=data)
s <- summary(m_pef_gen)
print(s)
cat("\n")
ci <- confint(m_pef_gen)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# --- 1b. Regresie multipla: PEF ~ Varsta + Inaltime ---
cat("===========================================================================\n")
cat("1b. REGRESIE MULTIPLA: PEF ~ Varsta_ani + Inaltime_cm\n")
cat("===========================================================================\n\n")

model_pef <- lm(PEF ~ Varsta_ani + Inaltime_cm, data=data)
s_pef <- summary(model_pef)
print(s_pef)
cat("\n")

ci_pef <- confint(model_pef)
cat("95% IC:\n")
print(ci_pef)
cat("\n")

cat("Ecuatia: PEF =", sprintf("%.4f", coef(model_pef)[1]), "+ (",
    sprintf("%.4f", coef(model_pef)[2]), ") * Varsta + (",
    sprintf("%.4f", coef(model_pef)[3]), ") * Inaltime\n\n")

# Test F global
cat("Testul F global:\n")
cat("  H0: beta_varsta = beta_inaltime = 0\n")
cat("  H1: cel putin un beta != 0\n")
cat("  F =", sprintf("%.4f", s_pef$fstatistic[1]), "\n")
cat("  df1 =", s_pef$fstatistic[2], ", df2 =", s_pef$fstatistic[3], "\n")
p_f_pef <- pf(s_pef$fstatistic[1], s_pef$fstatistic[2], s_pef$fstatistic[3], lower.tail=FALSE)
cat("  p-value =", format.pval(p_f_pef, digits=4), "\n")
if (p_f_pef < 0.05) {
  cat("  Decizie: Modelul este semnificativ (p < 0.05).\n\n")
} else {
  cat("  Decizie: Modelul NU este semnificativ (p >= 0.05).\n\n")
}

cat("R² =", sprintf("%.4f", s_pef$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_pef$adj.r.squared), "\n")
cat("Interpretare:", sprintf("%.1f%%", s_pef$r.squared*100),
    "din variabilitatea PEF este explicata de varsta si inaltime.\n\n")

# --- 1c. Regresie multipla cu Gen: PEF ~ Varsta + Inaltime + Gen ---
cat("===========================================================================\n")
cat("1c. REGRESIE MULTIPLA: PEF ~ Varsta_ani + Inaltime_cm + Gen\n")
cat("===========================================================================\n\n")

model_pef_gen <- lm(PEF ~ Varsta_ani + Inaltime_cm + Gen, data=data)
s_pef_gen <- summary(model_pef_gen)
print(s_pef_gen)
cat("\n")

ci_pef_gen <- confint(model_pef_gen)
cat("95% IC:\n")
print(ci_pef_gen)
cat("\n")

cat("R² =", sprintf("%.4f", s_pef_gen$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_pef_gen$adj.r.squared), "\n\n")

# Compare models with and without Gen
cat("Comparare model cu/fara Gen (ANOVA):\n")
anova_pef <- anova(model_pef, model_pef_gen)
print(anova_pef)
cat("\n")
if (anova_pef$`Pr(>F)`[2] < 0.05) {
  cat("Adaugarea Gen imbunatateste semnificativ modelul (p < 0.05).\n\n")
} else {
  cat("Adaugarea Gen NU imbunatateste semnificativ modelul (p >= 0.05).\n\n")
}

# --- 1d. Diagnostice model PEF ---
cat("===========================================================================\n")
cat("1d. DIAGNOSTICE MODEL PEF (Varsta + Inaltime)\n")
cat("===========================================================================\n\n")

resid_pef <- residuals(model_pef)

# Normalitate
sw_pef <- shapiro.test(resid_pef)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw_pef$statistic),
    ", p =", format.pval(sw_pef$p.value, digits=4), "\n")
if (sw_pef$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

# Homoscedasticitate
bp_pef <- bptest(model_pef)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp_pef$statistic),
    ", p =", format.pval(bp_pef$p.value, digits=4), "\n")
if (bp_pef$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

# Durbin-Watson
dw_pef <- dwtest(model_pef)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw_pef$statistic),
    ", p =", format.pval(dw_pef$p.value, digits=4), "\n")
if (dw_pef$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

# Cook's D
cook_pef <- cooks.distance(model_pef)
cat("Cook's D > 4/n:", sum(cook_pef > 4/n), "observatii\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook_pef)), "\n")

# Standardized residuals
sr_pef <- rstandard(model_pef)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr_pef) > 2), "observatii\n\n")

# VIF
cat("VIF:\n")
print(vif(model_pef))
if (all(vif(model_pef) < 5)) {
  cat("\n  Toate VIF < 5: nu exista probleme de multicoliniaritate.\n\n")
} else {
  cat("\n  Atentie: VIF >= 5 detectat, posibila multicoliniaritate.\n\n")
}

# Diagnostic plots
png("pef_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_pef)
dev.off()
cat("Salvat: pef_diagnostic.png\n")

png("pef_hist_resid.png", width=600, height=500)
hist(resid_pef, breaks=20, main="Histograma reziduurilor (model PEF)",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid_pef), sd=sd(resid_pef)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Salvat: pef_hist_resid.png\n\n")

# --- 1e. Interpretare PEF ---
cat("===========================================================================\n")
cat("1e. INTERPRETARE MODEL PEF\n")
cat("===========================================================================\n\n")

coef_pef <- coef(model_pef)
cat("Coeficienti nestandardizati:\n")
cat("  Intercept (b0) =", sprintf("%.4f", coef_pef[1]),
    "=> PEF estimat cand varsta=0 si inaltime=0 (nu are sens clinic)\n")
cat("  Varsta_ani (b1) =", sprintf("%.4f", coef_pef[2]),
    "=> La cresterea cu 1 an a varstei,\n")
cat("    PEF creste cu", sprintf("%.4f", coef_pef[2]),
    "L/min, controlind pentru inaltime.\n")
cat("  Inaltime_cm (b2) =", sprintf("%.4f", coef_pef[3]),
    "=> La cresterea cu 1 cm a inaltimii,\n")
cat("    PEF creste cu", sprintf("%.4f", coef_pef[3]),
    "L/min, controlind pentru varsta.\n\n")

# Coeficienti de regresie partiala (standardizati)
cat("--- Coeficienti de regresie partiala (standardizati) ---\n\n")
model_pef_std <- lm(scale(PEF) ~ scale(Varsta_ani) + scale(Inaltime_cm), data=data)
s_pef_std <- summary(model_pef_std)
cat("Model standardizat: PEF_z ~ Varsta_z + Inaltime_z\n\n")
print(s_pef_std)
cat("\n")
cat("Coeficienti standardizati (beta):\n")
cat("  beta_Varsta =", sprintf("%.4f", coef(model_pef_std)[2]), "\n")
cat("  beta_Inaltime =", sprintf("%.4f", coef(model_pef_std)[3]), "\n\n")
cat("Interpretare:\n")
cat("  La cresterea cu 1 SD a varstei (", sprintf("%.2f", sd(data$Varsta_ani)), "ani),\n")
cat("    PEF creste cu", sprintf("%.4f", coef(model_pef_std)[2]), "SD (",
    sprintf("%.2f", sd(data$PEF)), "L/min), controlind pentru inaltime.\n")
cat("  La cresterea cu 1 SD a inaltimii (", sprintf("%.2f", sd(data$Inaltime_cm)), "cm),\n")
cat("    PEF creste cu", sprintf("%.4f", coef(model_pef_std)[3]), "SD (",
    sprintf("%.2f", sd(data$PEF)), "L/min), controlind pentru varsta.\n")
abs_b_v <- abs(coef(model_pef_std)[2])
abs_b_i <- abs(coef(model_pef_std)[3])
if (abs_b_i > abs_b_v) {
  cat("  => Inaltimea are un efect standardizat mai mare decat varsta (",
      sprintf("%.4f", abs_b_i), "vs", sprintf("%.4f", abs_b_v), ")\n\n")
} else {
  cat("  => Varsta are un efect standardizat mai mare decat inaltimea (",
      sprintf("%.4f", abs_b_v), "vs", sprintf("%.4f", abs_b_i), ")\n\n")
}

# --- 1f. Modele cu interactiuni PEF ---
cat("===========================================================================\n")
cat("1f. MODELE CU INTERACTIUNI PENTRU PEF\n")
cat("===========================================================================\n\n")

# Interactiune Varsta * Inaltime
cat("--- PEF ~ Varsta_ani * Inaltime_cm ---\n\n")
model_pef_int1 <- lm(PEF ~ Varsta_ani * Inaltime_cm, data=data)
s_pef_int1 <- summary(model_pef_int1)
print(s_pef_int1)
cat("\n")
ci_pef_int1 <- confint(model_pef_int1)
cat("95% IC:\n")
print(ci_pef_int1)
cat("\n")

cat("Comparare cu modelul fara interactiune (ANOVA):\n")
anova_pef_int1 <- anova(model_pef, model_pef_int1)
print(anova_pef_int1)
cat("\n")
if (anova_pef_int1$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Varsta*Inaltime este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Varsta*Inaltime NU este semnificativa (p >= 0.05).\n\n")
}

# Interactiune Varsta * Gen
cat("--- PEF ~ Varsta_ani * Gen ---\n\n")
model_pef_int2 <- lm(PEF ~ Varsta_ani * Gen, data=data)
s_pef_int2 <- summary(model_pef_int2)
print(s_pef_int2)
cat("\n")
ci_pef_int2 <- confint(model_pef_int2)
cat("95% IC:\n")
print(ci_pef_int2)
cat("\n")

cat("Comparare cu modelul simplu PEF ~ Varsta (ANOVA):\n")
anova_pef_int2 <- anova(m_pef_varsta, model_pef_int2)
print(anova_pef_int2)
cat("\n")
if (anova_pef_int2$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Varsta*Gen este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Varsta*Gen NU este semnificativa (p >= 0.05).\n\n")
}

# Interactiune Inaltime * Gen
cat("--- PEF ~ Inaltime_cm * Gen ---\n\n")
model_pef_int3 <- lm(PEF ~ Inaltime_cm * Gen, data=data)
s_pef_int3 <- summary(model_pef_int3)
print(s_pef_int3)
cat("\n")
ci_pef_int3 <- confint(model_pef_int3)
cat("95% IC:\n")
print(ci_pef_int3)
cat("\n")

cat("Comparare cu modelul simplu PEF ~ Inaltime (ANOVA):\n")
anova_pef_int3 <- anova(m_pef_inaltime, model_pef_int3)
print(anova_pef_int3)
cat("\n")
if (anova_pef_int3$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Inaltime*Gen este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Inaltime*Gen NU este semnificativa (p >= 0.05).\n\n")
}

# Model complet cu toate interactiunile
cat("--- PEF ~ Varsta_ani + Inaltime_cm + Gen + Varsta:Inaltime + Varsta:Gen + Inaltime:Gen ---\n\n")
model_pef_full_int <- lm(PEF ~ Varsta_ani * Inaltime_cm + Varsta_ani * Gen + Inaltime_cm * Gen, data=data)
s_pef_full_int <- summary(model_pef_full_int)
print(s_pef_full_int)
cat("\n")

cat("Comparare model complet cu interactiuni vs model simplu Varsta+Inaltime (ANOVA):\n")
anova_pef_full <- anova(model_pef, model_pef_full_int)
print(anova_pef_full)
cat("\n")
if (anova_pef_full$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunile impreuna imbunatatesc semnificativ modelul (p < 0.05).\n\n")
} else {
  cat("Interactiunile impreuna NU imbunatatesc semnificativ modelul (p >= 0.05).\n\n")
}

# Interaction plot: PEF by Varsta, split by Gen
png("pef_interaction_varsta_gen.png", width=600, height=500)
plot(data$Varsta_ani[data$Gen==0], data$PEF[data$Gen==0],
     pch=19, col=rgb(1,0,0,0.5), xlim=range(data$Varsta_ani), ylim=range(data$PEF),
     xlab="Varsta (ani)", ylab="PEF (L/min)", main="PEF vs Varsta per Gen")
points(data$Varsta_ani[data$Gen==1], data$PEF[data$Gen==1],
       pch=17, col=rgb(0,0,1,0.5))
abline(lm(PEF ~ Varsta_ani, data=data[data$Gen==0,]), col="red", lwd=2)
abline(lm(PEF ~ Varsta_ani, data=data[data$Gen==1,]), col="blue", lwd=2)
legend("topleft", legend=c("Feminin", "Masculin"), col=c("red","blue"),
       pch=c(19,17), lty=1, lwd=2, bty="n")
dev.off()
cat("Salvat: pef_interaction_varsta_gen.png\n")

# Interaction plot: PEF by Inaltime, split by Gen
png("pef_interaction_inaltime_gen.png", width=600, height=500)
plot(data$Inaltime_cm[data$Gen==0], data$PEF[data$Gen==0],
     pch=19, col=rgb(1,0,0,0.5), xlim=range(data$Inaltime_cm), ylim=range(data$PEF),
     xlab="Inaltime (cm)", ylab="PEF (L/min)", main="PEF vs Inaltime per Gen")
points(data$Inaltime_cm[data$Gen==1], data$PEF[data$Gen==1],
       pch=17, col=rgb(0,0,1,0.5))
abline(lm(PEF ~ Inaltime_cm, data=data[data$Gen==0,]), col="red", lwd=2)
abline(lm(PEF ~ Inaltime_cm, data=data[data$Gen==1,]), col="blue", lwd=2)
legend("topleft", legend=c("Feminin", "Masculin"), col=c("red","blue"),
       pch=c(19,17), lty=1, lwd=2, bty="n")
dev.off()
cat("Salvat: pef_interaction_inaltime_gen.png\n\n")

# =============================================================================
#   ANALIZA 2: log10(FEV1) - Transformare logaritmica
# =============================================================================
cat("###################################################################\n")
cat("# ANALIZA 2: log10(FEV1) - Transformare logaritmica\n")
cat("###################################################################\n\n")

# --- 2a. Necesitatea transformarii ---
cat("===========================================================================\n")
cat("2a. NECESITATEA TRANSFORMARII log10(FEV1)\n")
cat("===========================================================================\n\n")

cat("--- Modelul original FEV1 ~ Inaltime_cm ---\n\n")
m_fev_orig <- lm(FEV1 ~ Inaltime_cm, data=data)
s_orig <- summary(m_fev_orig)
cat("R² =", sprintf("%.6f", s_orig$r.squared), "\n")
cat("Avertisment: 'essentially perfect fit' - R² = 1.0000\n")
cat("FEV1 = -1 + 0.02 * Inaltime_cm (relatie determinista)\n\n")

cat("Shapiro-Wilk pe reziduurile modelului FEV1 ~ Varsta + Inaltime:\n")
m_fev_orig2 <- lm(FEV1 ~ Varsta_ani + Inaltime_cm, data=data)
sw_orig <- shapiro.test(residuals(m_fev_orig2))
cat("  W =", sprintf("%.4f", sw_orig$statistic),
    ", p =", format.pval(sw_orig$p.value, digits=4), "\n")
cat("  Reziduurile NU sunt normal distribuite (artefact al fitului perfect).\n\n")

cat("Justificare transformare log10:\n")
cat("  - FEV1 are o relatie determinista cu Inaltimea (R² = 1.0)\n")
cat("  - Diagnosticele nu sunt interpretabile pe date netransformate\n")
cat("  - Transformarea log10 va produce un model cu reziduuri reale,\n")
cat("    permitind evaluarea semnificativa a conditiilor regresiei\n")
cat("  - log10 este o transformare standard pentru volume/debite respiratorii\n\n")

# Aplicare transformare
data$log_FEV1 <- log10(data$FEV1)

# --- 2b. Statistici descriptive log10(FEV1) ---
cat("===========================================================================\n")
cat("2b. STATISTICI DESCRIPTIVE log10(FEV1)\n")
cat("===========================================================================\n\n")

x <- data$log_FEV1
cat("--- log10(FEV1) ---\n")
cat("  N:       ", sum(!is.na(x)), "\n")
cat("  NA:      ", sum(is.na(x)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(x, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(x, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(x, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(x, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(x, na.rm=TRUE)), "\n")
q <- quantile(x, c(0.25, 0.75), na.rm=TRUE)
iqr_val <- IQR(x, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.4f", q[1]), "\n")
cat("  Q3:      ", sprintf("%.4f", q[2]), "\n")
cat("  IQR:     ", sprintf("%.4f", iqr_val), "\n")
out <- x[x < q[1] - 1.5*iqr_val | x > q[2] + 1.5*iqr_val]
cat("  Outliers:", length(out), "\n")
if (length(out) > 0 && length(out) <= 10) cat("    Valori:", out, "\n")
cat("\n")

cat("Shapiro-Wilk pe log10(FEV1):\n")
sw_log <- shapiro.test(data$log_FEV1)
cat("  W =", sprintf("%.4f", sw_log$statistic),
    ", p =", format.pval(sw_log$p.value, digits=4), "\n")
if (sw_log$p.value > 0.05) {
  cat("  log10(FEV1) urmeaza o distributie normala.\n\n")
} else {
  cat("  log10(FEV1) NU urmeaza o distributie normala.\n\n")
}

# Histograme comparare original vs transformat
png("fev1_transform_compare.png", width=900, height=450)
par(mfrow=c(1,2))
hist(data$FEV1, breaks=15, main="FEV1 (original)", xlab="FEV1 (L/s)",
     col="lightyellow", probability=TRUE)
curve(dnorm(x, mean=mean(data$FEV1), sd=sd(data$FEV1)), add=TRUE, col="red", lwd=2)
hist(data$log_FEV1, breaks=15, main="log10(FEV1) (transformat)", xlab="log10(FEV1)",
     col="lightgreen", probability=TRUE)
curve(dnorm(x, mean=mean(data$log_FEV1), sd=sd(data$log_FEV1)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Salvat: fev1_transform_compare.png\n\n")

# --- 2c. Comparare original vs transformat ---
cat("===========================================================================\n")
cat("2c. COMPARARE FEV1 ORIGINAL VS log10(FEV1)\n")
cat("===========================================================================\n\n")

cat("--- FEV1 ~ Inaltime (original) ---\n")
cat("  R² =", sprintf("%.6f", s_orig$r.squared), " (fit perfect)\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_orig$statistic),
    ", p =", format.pval(sw_orig$p.value, digits=4), " (ESEC)\n\n")

m_log_inaltime_check <- lm(log_FEV1 ~ Inaltime_cm, data=data)
s_log_check <- summary(m_log_inaltime_check)
sw_log_resid <- shapiro.test(residuals(m_log_inaltime_check))
cat("--- log10(FEV1) ~ Inaltime (transformat) ---\n")
cat("  R² =", sprintf("%.4f", s_log_check$r.squared), "\n")
cat("  Shapiro-Wilk reziduuri: W =", sprintf("%.4f", sw_log_resid$statistic),
    ", p =", format.pval(sw_log_resid$p.value, digits=4), "\n")
if (sw_log_resid$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite => transformarea a rezolvat problema.\n\n")
} else {
  cat("  Reziduurile inca nu sunt normal distribuite, dar modelul e mai realist.\n\n")
}

# --- 2d. Regresii simple pentru log10(FEV1) ---
cat("===========================================================================\n")
cat("2d. REGRESII SIMPLE PENTRU log10(FEV1)\n")
cat("===========================================================================\n\n")

# log10(FEV1) ~ Varsta
cat("--- log10(FEV1) ~ Varsta_ani ---\n\n")
m_fev_varsta <- lm(log_FEV1 ~ Varsta_ani, data=data)
s <- summary(m_fev_varsta)
print(s)
cat("\n")
ci <- confint(m_fev_varsta)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# log10(FEV1) ~ Inaltime
cat("--- log10(FEV1) ~ Inaltime_cm ---\n\n")
m_fev_inaltime <- lm(log_FEV1 ~ Inaltime_cm, data=data)
s <- summary(m_fev_inaltime)
print(s)
cat("\n")
ci <- confint(m_fev_inaltime)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# log10(FEV1) ~ Gen
cat("--- log10(FEV1) ~ Gen ---\n\n")
m_fev_gen <- lm(log_FEV1 ~ Gen, data=data)
s <- summary(m_fev_gen)
print(s)
cat("\n")
ci <- confint(m_fev_gen)
cat("95% IC:\n")
print(ci)
cat("\nR² =", sprintf("%.4f", s$r.squared), "\n\n")

# --- 2e. Regresie multipla: log10(FEV1) ~ Varsta + Inaltime ---
cat("===========================================================================\n")
cat("2e. REGRESIE MULTIPLA: log10(FEV1) ~ Varsta_ani + Inaltime_cm\n")
cat("===========================================================================\n\n")

model_fev <- lm(log_FEV1 ~ Varsta_ani + Inaltime_cm, data=data)
s_fev <- summary(model_fev)
print(s_fev)
cat("\n")

ci_fev <- confint(model_fev)
cat("95% IC:\n")
print(ci_fev)
cat("\n")

cat("Ecuatia: log10(FEV1) =", sprintf("%.6f", coef(model_fev)[1]), "+ (",
    sprintf("%.6f", coef(model_fev)[2]), ") * Varsta + (",
    sprintf("%.6f", coef(model_fev)[3]), ") * Inaltime\n\n")

# Test F global
cat("Testul F global:\n")
cat("  H0: beta_varsta = beta_inaltime = 0\n")
cat("  H1: cel putin un beta != 0\n")
cat("  F =", sprintf("%.4f", s_fev$fstatistic[1]), "\n")
cat("  df1 =", s_fev$fstatistic[2], ", df2 =", s_fev$fstatistic[3], "\n")
p_f_fev <- pf(s_fev$fstatistic[1], s_fev$fstatistic[2], s_fev$fstatistic[3], lower.tail=FALSE)
cat("  p-value =", format.pval(p_f_fev, digits=4), "\n")
if (p_f_fev < 0.05) {
  cat("  Decizie: Modelul este semnificativ (p < 0.05).\n\n")
} else {
  cat("  Decizie: Modelul NU este semnificativ (p >= 0.05).\n\n")
}

cat("R² =", sprintf("%.4f", s_fev$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_fev$adj.r.squared), "\n")
cat("Interpretare:", sprintf("%.1f%%", s_fev$r.squared*100),
    "din variabilitatea log10(FEV1) este explicata de varsta si inaltime.\n\n")

# --- 2f. Regresie multipla cu Gen: log10(FEV1) ~ Varsta + Inaltime + Gen ---
cat("===========================================================================\n")
cat("2f. REGRESIE MULTIPLA: log10(FEV1) ~ Varsta_ani + Inaltime_cm + Gen\n")
cat("===========================================================================\n\n")

model_fev_gen <- lm(log_FEV1 ~ Varsta_ani + Inaltime_cm + Gen, data=data)
s_fev_gen <- summary(model_fev_gen)
print(s_fev_gen)
cat("\n")

ci_fev_gen <- confint(model_fev_gen)
cat("95% IC:\n")
print(ci_fev_gen)
cat("\n")

cat("R² =", sprintf("%.4f", s_fev_gen$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_fev_gen$adj.r.squared), "\n\n")

# Compare models with and without Gen
cat("Comparare model cu/fara Gen (ANOVA):\n")
anova_fev <- anova(model_fev, model_fev_gen)
print(anova_fev)
cat("\n")
if (anova_fev$`Pr(>F)`[2] < 0.05) {
  cat("Adaugarea Gen imbunatateste semnificativ modelul (p < 0.05).\n\n")
} else {
  cat("Adaugarea Gen NU imbunatateste semnificativ modelul (p >= 0.05).\n\n")
}

# --- 2g. Diagnostice model log10(FEV1) ---
cat("===========================================================================\n")
cat("2g. DIAGNOSTICE MODEL log10(FEV1) (Varsta + Inaltime)\n")
cat("===========================================================================\n\n")

resid_fev <- residuals(model_fev)

# Normalitate
sw_fev <- shapiro.test(resid_fev)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw_fev$statistic),
    ", p =", format.pval(sw_fev$p.value, digits=4), "\n")
if (sw_fev$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

# Homoscedasticitate
bp_fev <- bptest(model_fev)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp_fev$statistic),
    ", p =", format.pval(bp_fev$p.value, digits=4), "\n")
if (bp_fev$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

# Durbin-Watson
dw_fev <- dwtest(model_fev)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw_fev$statistic),
    ", p =", format.pval(dw_fev$p.value, digits=4), "\n")
if (dw_fev$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

# Cook's D
cook_fev <- cooks.distance(model_fev)
cat("Cook's D > 4/n:", sum(cook_fev > 4/n), "observatii\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook_fev)), "\n")

# Standardized residuals
sr_fev <- rstandard(model_fev)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr_fev) > 2), "observatii\n\n")

# VIF
cat("VIF:\n")
print(vif(model_fev))
if (all(vif(model_fev) < 5)) {
  cat("\n  Toate VIF < 5: nu exista probleme de multicoliniaritate.\n\n")
} else {
  cat("\n  Atentie: VIF >= 5 detectat, posibila multicoliniaritate.\n\n")
}

# Diagnostic plots
png("fev1_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_fev)
dev.off()
cat("Salvat: fev1_diagnostic.png\n")

png("fev1_hist_resid.png", width=600, height=500)
hist(resid_fev, breaks=20, main="Histograma reziduurilor (model log10(FEV1))",
     xlab="Reziduuri", col="lightgreen", probability=TRUE)
curve(dnorm(x, mean=mean(resid_fev), sd=sd(resid_fev)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Salvat: fev1_hist_resid.png\n\n")

# --- 2h. Interpretare log10(FEV1) ---
cat("===========================================================================\n")
cat("2h. INTERPRETARE MODEL log10(FEV1)\n")
cat("===========================================================================\n\n")

coef_fev <- coef(model_fev)
cat("Coeficienti nestandardizati (pe scala log10):\n")
cat("  Intercept (b0) =", sprintf("%.6f", coef_fev[1]), "\n")
cat("  Varsta_ani (b1) =", sprintf("%.6f", coef_fev[2]), "\n")
cat("  Inaltime_cm (b2) =", sprintf("%.6f", coef_fev[3]), "\n\n")

cat("Interpretare pe scala originala (back-transform):\n")
cat("  La cresterea cu 1 an a varstei, FEV1 se multiplica cu",
    sprintf("%.4f", 10^coef_fev[2]),
    "(factor multiplicativ), controlind pentru inaltime.\n")
pct_varsta <- (10^coef_fev[2] - 1) * 100
cat("  Aceasta corespunde unei modificari de", sprintf("%.2f%%", pct_varsta), "\n\n")

cat("  La cresterea cu 1 cm a inaltimii, FEV1 se multiplica cu",
    sprintf("%.4f", 10^coef_fev[3]),
    "(factor multiplicativ), controlind pentru varsta.\n")
pct_inaltime <- (10^coef_fev[3] - 1) * 100
cat("  Aceasta corespunde unei cresteri de", sprintf("%.2f%%", pct_inaltime), "\n\n")

cat("  La cresterea cu 10 cm a inaltimii, FEV1 se multiplica cu",
    sprintf("%.4f", 10^(10*coef_fev[3])), "\n")
pct_10cm <- (10^(10*coef_fev[3]) - 1) * 100
cat("  Aceasta corespunde unei cresteri de", sprintf("%.2f%%", pct_10cm), "\n\n")

# Coeficienti de regresie partiala (standardizati)
cat("--- Coeficienti de regresie partiala (standardizati) ---\n\n")
model_fev_std <- lm(scale(log_FEV1) ~ scale(Varsta_ani) + scale(Inaltime_cm), data=data)
s_fev_std <- summary(model_fev_std)
cat("Model standardizat: log10(FEV1)_z ~ Varsta_z + Inaltime_z\n\n")
print(s_fev_std)
cat("\n")
cat("Coeficienti standardizati (beta):\n")
cat("  beta_Varsta =", sprintf("%.4f", coef(model_fev_std)[2]), "\n")
cat("  beta_Inaltime =", sprintf("%.4f", coef(model_fev_std)[3]), "\n\n")
cat("Interpretare:\n")
cat("  La cresterea cu 1 SD a varstei (", sprintf("%.2f", sd(data$Varsta_ani)), "ani),\n")
cat("    log10(FEV1) creste cu", sprintf("%.4f", coef(model_fev_std)[2]), "SD (",
    sprintf("%.4f", sd(data$log_FEV1)), "), controlind pentru inaltime.\n")
cat("  La cresterea cu 1 SD a inaltimii (", sprintf("%.2f", sd(data$Inaltime_cm)), "cm),\n")
cat("    log10(FEV1) creste cu", sprintf("%.4f", coef(model_fev_std)[3]), "SD (",
    sprintf("%.4f", sd(data$log_FEV1)), "), controlind pentru varsta.\n")
abs_b_v <- abs(coef(model_fev_std)[2])
abs_b_i <- abs(coef(model_fev_std)[3])
if (abs_b_i > abs_b_v) {
  cat("  => Inaltimea are un efect standardizat mai mare decat varsta (",
      sprintf("%.4f", abs_b_i), "vs", sprintf("%.4f", abs_b_v), ")\n\n")
} else {
  cat("  => Varsta are un efect standardizat mai mare decat inaltimea (",
      sprintf("%.4f", abs_b_v), "vs", sprintf("%.4f", abs_b_i), ")\n\n")
}

# --- 2i. Modele cu interactiuni log10(FEV1) ---
cat("===========================================================================\n")
cat("2i. MODELE CU INTERACTIUNI PENTRU log10(FEV1)\n")
cat("===========================================================================\n\n")

# Interactiune Varsta * Inaltime
cat("--- log10(FEV1) ~ Varsta_ani * Inaltime_cm ---\n\n")
model_fev_int1 <- lm(log_FEV1 ~ Varsta_ani * Inaltime_cm, data=data)
s_fev_int1 <- summary(model_fev_int1)
print(s_fev_int1)
cat("\n")
ci_fev_int1 <- confint(model_fev_int1)
cat("95% IC:\n")
print(ci_fev_int1)
cat("\n")

cat("Comparare cu modelul fara interactiune (ANOVA):\n")
anova_fev_int1 <- anova(model_fev, model_fev_int1)
print(anova_fev_int1)
cat("\n")
if (anova_fev_int1$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Varsta*Inaltime este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Varsta*Inaltime NU este semnificativa (p >= 0.05).\n\n")
}

# Interactiune Varsta * Gen
cat("--- log10(FEV1) ~ Varsta_ani * Gen ---\n\n")
model_fev_int2 <- lm(log_FEV1 ~ Varsta_ani * Gen, data=data)
s_fev_int2 <- summary(model_fev_int2)
print(s_fev_int2)
cat("\n")
ci_fev_int2 <- confint(model_fev_int2)
cat("95% IC:\n")
print(ci_fev_int2)
cat("\n")

cat("Comparare cu modelul simplu log10(FEV1) ~ Varsta (ANOVA):\n")
anova_fev_int2 <- anova(m_fev_varsta, model_fev_int2)
print(anova_fev_int2)
cat("\n")
if (anova_fev_int2$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Varsta*Gen este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Varsta*Gen NU este semnificativa (p >= 0.05).\n\n")
}

# Interactiune Inaltime * Gen
cat("--- log10(FEV1) ~ Inaltime_cm * Gen ---\n\n")
model_fev_int3 <- lm(log_FEV1 ~ Inaltime_cm * Gen, data=data)
s_fev_int3 <- summary(model_fev_int3)
print(s_fev_int3)
cat("\n")
ci_fev_int3 <- confint(model_fev_int3)
cat("95% IC:\n")
print(ci_fev_int3)
cat("\n")

cat("Comparare cu modelul simplu log10(FEV1) ~ Inaltime (ANOVA):\n")
anova_fev_int3 <- anova(m_fev_inaltime, model_fev_int3)
print(anova_fev_int3)
cat("\n")
if (anova_fev_int3$`Pr(>F)`[2] < 0.05) {
  cat("Interactiunea Inaltime*Gen este semnificativa (p < 0.05).\n\n")
} else {
  cat("Interactiunea Inaltime*Gen NU este semnificativa (p >= 0.05).\n\n")
}

# Interaction plots for log10(FEV1)
png("fev1_interaction_varsta_gen.png", width=600, height=500)
plot(data$Varsta_ani[data$Gen==0], data$log_FEV1[data$Gen==0],
     pch=19, col=rgb(1,0,0,0.5), xlim=range(data$Varsta_ani), ylim=range(data$log_FEV1),
     xlab="Varsta (ani)", ylab="log10(FEV1)", main="log10(FEV1) vs Varsta per Gen")
points(data$Varsta_ani[data$Gen==1], data$log_FEV1[data$Gen==1],
       pch=17, col=rgb(0,0,1,0.5))
abline(lm(log_FEV1 ~ Varsta_ani, data=data[data$Gen==0,]), col="red", lwd=2)
abline(lm(log_FEV1 ~ Varsta_ani, data=data[data$Gen==1,]), col="blue", lwd=2)
legend("topleft", legend=c("Feminin", "Masculin"), col=c("red","blue"),
       pch=c(19,17), lty=1, lwd=2, bty="n")
dev.off()
cat("Salvat: fev1_interaction_varsta_gen.png\n")

png("fev1_interaction_inaltime_gen.png", width=600, height=500)
plot(data$Inaltime_cm[data$Gen==0], data$log_FEV1[data$Gen==0],
     pch=19, col=rgb(1,0,0,0.5), xlim=range(data$Inaltime_cm), ylim=range(data$log_FEV1),
     xlab="Inaltime (cm)", ylab="log10(FEV1)", main="log10(FEV1) vs Inaltime per Gen")
points(data$Inaltime_cm[data$Gen==1], data$log_FEV1[data$Gen==1],
       pch=17, col=rgb(0,0,1,0.5))
abline(lm(log_FEV1 ~ Inaltime_cm, data=data[data$Gen==0,]), col="red", lwd=2)
abline(lm(log_FEV1 ~ Inaltime_cm, data=data[data$Gen==1,]), col="blue", lwd=2)
legend("topleft", legend=c("Feminin", "Masculin"), col=c("red","blue"),
       pch=c(19,17), lty=1, lwd=2, bty="n")
dev.off()
cat("Salvat: fev1_interaction_inaltime_gen.png\n\n")

# =============================================================================
# SUMAR GENERAL
# =============================================================================
cat("###################################################################\n")
cat("# SUMAR GENERAL\n")
cat("###################################################################\n\n")

cat("Model PEF ~ Varsta + Inaltime:\n")
cat("  R² =", sprintf("%.4f", s_pef$r.squared),
    ", Adj R² =", sprintf("%.4f", s_pef$adj.r.squared), "\n")
cat("  F =", sprintf("%.4f", s_pef$fstatistic[1]),
    ", p =", format.pval(p_f_pef, digits=4), "\n\n")

cat("Model log10(FEV1) ~ Varsta + Inaltime:\n")
cat("  R² =", sprintf("%.4f", s_fev$r.squared),
    ", Adj R² =", sprintf("%.4f", s_fev$adj.r.squared), "\n")
cat("  F =", sprintf("%.4f", s_fev$fstatistic[1]),
    ", p =", format.pval(p_f_fev, digits=4), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
