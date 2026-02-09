# =============================================================================
# LP06 - Regresia liniara multipla cu efect de interactiune
# VD: cGIM_mm (grosimea intima-media carotidiana, mm)
# VI de interes: Varsta_ani, Gen
# Covariate: Durata_bolii_ani, Medicamente_antireumatice,
#            Medicamente_antiinfl_nesteroidiene, Corticosteroizi
# n = 214 pacienti cu artrita reumatoida
# =============================================================================

library(car)
library(lmtest)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
n <- nrow(data)
cat("n =", n, "\n\n")

# Clean column name (trailing space)
colnames(data) <- trimws(colnames(data))

# Recode Gen as factor
data$Gen_f <- factor(data$Gen, levels=c(0,1), labels=c("Femei","Barbati"))

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
#   INTREBAREA 1 - REGRESIE SIMPLA: Varsta -> cGIM
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 1: Exista o dependenta liniara semnificativa intre\n")
cat("# varsta si cGIM la pacientii cu AR?\n")
cat("###################################################################\n\n")

cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: cGIM_mm - cantitativa continua\n")
cat("VI: Varsta_ani - cantitativa continua\n\n")

cat("2. ANALIZA DESCRIPTIVA\n\n")
desc_stats(data$cGIM_mm, "cGIM_mm (mm)")
desc_stats(data$Varsta_ani, "Varsta_ani (ani)")

cat("3. GRAFICE\n\n")

png("q1_boxplot_cgim.png", width=600, height=400)
boxplot(data$cGIM_mm, main="Distributia cGIM (mm)", ylab="cGIM (mm)",
        col="lightblue", border="darkblue")
dev.off()
cat("Saved: q1_boxplot_cgim.png\n")

png("q1_boxplot_varsta.png", width=600, height=400)
boxplot(data$Varsta_ani, main="Distributia Varsta (ani)", ylab="Varsta (ani)",
        col="lightgreen", border="darkgreen")
dev.off()
cat("Saved: q1_boxplot_varsta.png\n")

png("q1_scatter.png", width=600, height=500)
plot(data$Varsta_ani, data$cGIM_mm,
     xlab="Varsta (ani)", ylab="cGIM (mm)",
     main="Relatia dintre varsta si cGIM",
     pch=19, col=rgb(0,0,1,0.4))
abline(lm(cGIM_mm ~ Varsta_ani, data=data), col="red", lwd=2)
dev.off()
cat("Saved: q1_scatter.png\n\n")

cat("4. CORELATIA\n\n")
r1 <- cor.test(data$Varsta_ani, data$cGIM_mm)
cat("Pearson r =", sprintf("%.4f", r1$estimate), "\n")
cat("t =", sprintf("%.4f", r1$statistic), "\n")
cat("df =", r1$parameter, "\n")
cat("p-value =", format.pval(r1$p.value, digits=4), "\n")
cat("95% CI: [", sprintf("%.4f", r1$conf.int[1]), ",", sprintf("%.4f", r1$conf.int[2]), "]\n\n")

cat("5. MODELUL DE REGRESIE SIMPLA\n\n")
model_q1 <- lm(cGIM_mm ~ Varsta_ani, data=data)
s_q1 <- summary(model_q1)
print(s_q1)
cat("\n")

coef_q1 <- coef(s_q1)
ci_q1 <- confint(model_q1)

cat("--- Tabelul 0: Regresie simpla Varsta -> cGIM ---\n")
cat(sprintf("%-15s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "t(df)", "p-value"))
for (i in 1:nrow(coef_q1)) {
  tval <- sprintf("%.4f(%d)", coef_q1[i,3], model_q1$df.residual)
  pval <- format.pval(coef_q1[i,4], digits=4)
  cat(sprintf("%-15s %10.4f %10.4f %10.4f %10.4f %15s %15s\n",
              rownames(coef_q1)[i], coef_q1[i,1], coef_q1[i,2],
              ci_q1[i,1], ci_q1[i,2], tval, pval))
}
cat("\n")
cat("R-squared =", sprintf("%.4f", s_q1$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_q1$adj.r.squared), "\n\n")

# =====================================================================
#   INTREBAREA 2 - REGRESIE SIMPLA: Gen -> cGIM
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 2: Exista o asociere semnificativa intre gen si cGIM\n")
cat("# la pacientii cu AR?\n")
cat("###################################################################\n\n")

cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: cGIM_mm - cantitativa continua\n")
cat("VI: Gen - calitativa dihotomiala (0=Femei ref, 1=Barbati)\n\n")

cat("2. ANALIZA DESCRIPTIVA\n\n")
cat("Distributia Gen:\n")
print(table(data$Gen_f))
cat("\n")

for (g in levels(data$Gen_f)) {
  sub <- data$cGIM_mm[data$Gen_f == g]
  cat(sprintf("cGIM la %s (n=%d): Media=%.4f, SD=%.4f, Mediana=%.4f\n",
              g, length(sub), mean(sub), sd(sub), median(sub)))
}
cat("\n")

cat("3. GRAFICE\n\n")
png("q2_boxplot_cgim_by_gen.png", width=600, height=500)
boxplot(cGIM_mm ~ Gen_f, data=data, main="cGIM per Gen",
        ylab="cGIM (mm)", xlab="Gen", col=c("pink","lightblue"))
dev.off()
cat("Saved: q2_boxplot_cgim_by_gen.png\n\n")

cat("4. MODELUL DE REGRESIE SIMPLA (Gen -> cGIM)\n\n")
model_q2 <- lm(cGIM_mm ~ Gen, data=data)
s_q2 <- summary(model_q2)
print(s_q2)
cat("\n")

coef_q2 <- coef(s_q2)
ci_q2 <- confint(model_q2)

cat("--- Tabelul 1: Regresie simpla Gen -> cGIM ---\n")
cat(sprintf("%-15s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "t(df)", "p-value"))
for (i in 1:nrow(coef_q2)) {
  tval <- sprintf("%.4f(%d)", coef_q2[i,3], model_q2$df.residual)
  pval <- format.pval(coef_q2[i,4], digits=4)
  cat(sprintf("%-15s %10.4f %10.4f %10.4f %10.4f %15s %15s\n",
              rownames(coef_q2)[i], coef_q2[i,1], coef_q2[i,2],
              ci_q2[i,1], ci_q2[i,2], tval, pval))
}
cat("\n")
cat("R-squared =", sprintf("%.4f", s_q2$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_q2$adj.r.squared), "\n\n")

# =====================================================================
#   INTREBAREA 3 - REGRESIE MULTIPLA FARA INTERACTIUNE
#   cGIM ~ Varsta + Gen + covariate
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 3: Exista o dependenta liniara semnificativa intre\n")
cat("# varsta si cGIM, ajustind pentru gen si caracteristicile clinice?\n")
cat("###################################################################\n\n")

cat("1. SPECIFICAREA VARIABILELOR\n")
cat("VD: cGIM_mm\n")
cat("VI de interes: Varsta_ani, Gen\n")
cat("Covariate: Durata_bolii_ani, Medicamente_antireumatice,\n")
cat("           Medicamente_antiinfl_nesteroidiene, Corticosteroizi\n\n")

cat("2. STATISTICI DESCRIPTIVE PENTRU TOATE VARIABILELE\n\n")
desc_stats(data$cGIM_mm, "cGIM_mm")
desc_stats(data$Varsta_ani, "Varsta_ani")
desc_stats(data$Durata_bolii_ani, "Durata_bolii_ani")
cat("Gen (0=F, 1=M):\n")
print(table(data$Gen))
cat("\nMedicamente_antireumatice:\n")
print(table(data$Medicamente_antireumatice))
cat("\nMedicamente_antiinfl_nesteroidiene:\n")
print(table(data$Medicamente_antiinfl_nesteroidiene))
cat("\nCorticosteroizi:\n")
print(table(data$Corticosteroizi))
cat("\n")

cat("3. MODELUL DE REGRESIE MULTIPLA FARA INTERACTIUNE\n\n")
model_q3 <- lm(cGIM_mm ~ Varsta_ani + Gen + Durata_bolii_ani +
                  Medicamente_antireumatice + Medicamente_antiinfl_nesteroidiene +
                  Corticosteroizi, data=data)
s_q3 <- summary(model_q3)
print(s_q3)
cat("\n")

# F-test global
cat("4. TESTUL DE SEMNIFICATIE GLOBALA (F)\n\n")
cat("H0: toti coeficientii = 0\n")
cat("H1: cel putin un coeficient != 0\n\n")
cat("F =", sprintf("%.4f", s_q3$fstatistic[1]), "\n")
cat("df1 =", s_q3$fstatistic[2], ", df2 =", s_q3$fstatistic[3], "\n")
p_f3 <- pf(s_q3$fstatistic[1], s_q3$fstatistic[2], s_q3$fstatistic[3], lower.tail=FALSE)
cat("p-value =", format.pval(p_f3, digits=4), "\n\n")

# Individual tests
cat("5. TESTE INDIVIDUALE\n\n")
coef_q3 <- coef(s_q3)
ci_q3 <- confint(model_q3)

cat("--- Tabelul 2: Regresie multipla fara interactiune ---\n")
sd_y <- sd(data$cGIM_mm)
cat(sprintf("%-40s %10s %10s %10s %10s %8s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_q3)) {
  tval <- sprintf("%.4f(%d)", coef_q3[i,3], model_q3$df.residual)
  pval <- format.pval(coef_q3[i,4], digits=4)
  vname <- rownames(coef_q3)[i]
  if (vname == "(Intercept)") {
    beta_val <- "-"
  } else {
    beta_val <- sprintf("%.4f", coef_q3[i,1] * sd(data[[vname]]) / sd_y)
  }
  cat(sprintf("%-40s %10.4f %10.4f %10.4f %10.4f %8s %15s %15s\n",
              vname, coef_q3[i,1], coef_q3[i,2],
              ci_q3[i,1], ci_q3[i,2], beta_val, tval, pval))
}
cat("\n")

# R-squared
cat("6. COEFICIENTUL DE DETERMINARE\n\n")
cat("R-squared =", sprintf("%.4f", s_q3$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_q3$adj.r.squared), "\n\n")

# Diagnostics
cat("7. DIAGNOSTICE MODEL Q3\n\n")

# Normality
resid_q3 <- residuals(model_q3)
sw3 <- shapiro.test(resid_q3)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw3$statistic), ", p =", format.pval(sw3$p.value, digits=4), "\n")
ks3 <- ks.test(resid_q3, "pnorm", mean=mean(resid_q3), sd=sd(resid_q3))
cat("KS test: D =", sprintf("%.4f", ks3$statistic), ", p =", format.pval(ks3$p.value, digits=4), "\n\n")

png("q3_diag_resid_fitted.png", width=600, height=500)
plot(model_q3, which=1, main="Q3: Residuals vs Fitted")
dev.off()
png("q3_diag_qq.png", width=600, height=500)
plot(model_q3, which=2, main="Q3: Normal Q-Q")
dev.off()
png("q3_diag_hist_resid.png", width=600, height=500)
hist(resid_q3, breaks=25, main="Q3: Histograma reziduurilor",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid_q3), sd=sd(resid_q3)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Saved: q3_diag_resid_fitted.png, q3_diag_qq.png, q3_diag_hist_resid.png\n")

# Homoscedasticity
bp3 <- bptest(model_q3)
cat("\nBreusch-Pagan: BP =", sprintf("%.4f", bp3$statistic), ", df =", bp3$parameter,
    ", p =", format.pval(bp3$p.value, digits=4), "\n")

png("q3_diag_scale_location.png", width=600, height=500)
plot(model_q3, which=3, main="Q3: Scale-Location")
dev.off()
cat("Saved: q3_diag_scale_location.png\n")

# Durbin-Watson
dw3 <- dwtest(model_q3)
cat("\nDurbin-Watson: DW =", sprintf("%.4f", dw3$statistic), ", p =", format.pval(dw3$p.value, digits=4), "\n")

# Outliers / influential
cook3 <- cooks.distance(model_q3)
influential3 <- which(cook3 > 4/n)
cat("\nPuncte influente (Cook's D > 4/n):", length(influential3), "\n")
if (length(influential3) > 0) {
  cat("Indici:", paste(head(influential3, 20), collapse=", "), "\n")
  cat("Cook's D maxim:", sprintf("%.4f", max(cook3)), "\n")
}

png("q3_diag_cooks.png", width=600, height=500)
plot(model_q3, which=4, main="Q3: Cook's Distance")
dev.off()
png("q3_diag_resid_leverage.png", width=600, height=500)
plot(model_q3, which=5, main="Q3: Residuals vs Leverage")
dev.off()
cat("Saved: q3_diag_cooks.png, q3_diag_resid_leverage.png\n")

# VIF
cat("\nMulticoliniaritate (VIF):\n")
vif_q3 <- vif(model_q3)
print(vif_q3)
cat("\n")

# =====================================================================
#   INTREBAREA 4 - REGRESIE MULTIPLA CU INTERACTIUNE Varsta*Gen
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 4: Dependenta liniara intre varsta si cGIM difera\n")
cat("# semnificativ in functie de gen, ajustind pentru covariate?\n")
cat("###################################################################\n\n")

cat("1. MODELUL CU INTERACTIUNE\n\n")
model_q4 <- lm(cGIM_mm ~ Varsta_ani * Gen + Durata_bolii_ani +
                  Medicamente_antireumatice + Medicamente_antiinfl_nesteroidiene +
                  Corticosteroizi, data=data)
s_q4 <- summary(model_q4)
print(s_q4)
cat("\n")

# F-test global
cat("2. TESTUL DE SEMNIFICATIE GLOBALA (F)\n\n")
cat("F =", sprintf("%.4f", s_q4$fstatistic[1]), "\n")
cat("df1 =", s_q4$fstatistic[2], ", df2 =", s_q4$fstatistic[3], "\n")
p_f4 <- pf(s_q4$fstatistic[1], s_q4$fstatistic[2], s_q4$fstatistic[3], lower.tail=FALSE)
cat("p-value =", format.pval(p_f4, digits=4), "\n\n")

# Individual tests
cat("3. TESTE INDIVIDUALE\n\n")
coef_q4 <- coef(s_q4)
ci_q4 <- confint(model_q4)

cat("--- Tabelul 3: Regresie multipla cu interactiune ---\n")
data$Varsta_Gen <- data$Varsta_ani * data$Gen
cat(sprintf("%-40s %10s %10s %10s %10s %8s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_q4)) {
  tval <- sprintf("%.4f(%d)", coef_q4[i,3], model_q4$df.residual)
  pval <- format.pval(coef_q4[i,4], digits=4)
  vname <- rownames(coef_q4)[i]
  if (vname == "(Intercept)") {
    beta_val <- "-"
  } else if (vname == "Varsta_ani:Gen") {
    beta_val <- sprintf("%.4f", coef_q4[i,1] * sd(data$Varsta_Gen) / sd_y)
  } else {
    beta_val <- sprintf("%.4f", coef_q4[i,1] * sd(data[[vname]]) / sd_y)
  }
  cat(sprintf("%-40s %10.4f %10.4f %10.4f %10.4f %8s %15s %15s\n",
              vname, coef_q4[i,1], coef_q4[i,2],
              ci_q4[i,1], ci_q4[i,2], beta_val, tval, pval))
}
cat("\n")

cat("4. R-SQUARED\n\n")
cat("R-squared =", sprintf("%.4f", s_q4$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_q4$adj.r.squared), "\n\n")

# Test interactiune
cat("5. SEMNIFICATIA TERMENULUI DE INTERACTIUNE\n\n")
int_row <- which(rownames(coef_q4) == "Varsta_ani:Gen")
cat("Coeficient interactiune (Varsta_ani:Gen):\n")
cat("  B =", sprintf("%.4f", coef_q4[int_row, 1]), "\n")
cat("  SE =", sprintf("%.4f", coef_q4[int_row, 2]), "\n")
cat("  t =", sprintf("%.4f", coef_q4[int_row, 3]), "\n")
cat("  p =", format.pval(coef_q4[int_row, 4], digits=4), "\n\n")
if (coef_q4[int_row, 4] < 0.05) {
  cat("Interactiunea este semnificativa (p < 0.05): efectul varstei\n")
  cat("asupra cGIM difera semnificativ intre barbati si femei.\n\n")
} else {
  cat("Interactiunea NU este semnificativa (p >= 0.05): efectul varstei\n")
  cat("asupra cGIM nu difera semnificativ intre barbati si femei.\n\n")
}

# Interaction plot
cat("6. GRAFICUL INTERACTIUNII\n\n")
png("q4_interaction_plot.png", width=700, height=500)
varsta_range <- seq(min(data$Varsta_ani), max(data$Varsta_ani), length.out=100)
# Predictions for females (Gen=0)
newdata_f <- data.frame(
  Varsta_ani = varsta_range, Gen = 0,
  Durata_bolii_ani = mean(data$Durata_bolii_ani),
  Medicamente_antireumatice = mean(data$Medicamente_antireumatice),
  Medicamente_antiinfl_nesteroidiene = mean(data$Medicamente_antiinfl_nesteroidiene),
  Corticosteroizi = mean(data$Corticosteroizi))
pred_f <- predict(model_q4, newdata_f)
# Predictions for males (Gen=1)
newdata_m <- data.frame(
  Varsta_ani = varsta_range, Gen = 1,
  Durata_bolii_ani = mean(data$Durata_bolii_ani),
  Medicamente_antireumatice = mean(data$Medicamente_antireumatice),
  Medicamente_antiinfl_nesteroidiene = mean(data$Medicamente_antiinfl_nesteroidiene),
  Corticosteroizi = mean(data$Corticosteroizi))
pred_m <- predict(model_q4, newdata_m)

plot(varsta_range, pred_f, type="l", col="red", lwd=2,
     xlab="Varsta (ani)", ylab="cGIM estimat (mm)",
     main="Graficul interactiunii Varsta x Gen",
     ylim=range(c(pred_f, pred_m)))
lines(varsta_range, pred_m, col="blue", lwd=2)
legend("topleft", legend=c("Femei (Gen=0)", "Barbati (Gen=1)"),
       col=c("red","blue"), lwd=2)
# Add scatter points
points(data$Varsta_ani[data$Gen==0], data$cGIM_mm[data$Gen==0],
       pch=19, col=rgb(1,0,0,0.2), cex=0.7)
points(data$Varsta_ani[data$Gen==1], data$cGIM_mm[data$Gen==1],
       pch=19, col=rgb(0,0,1,0.2), cex=0.7)
dev.off()
cat("Saved: q4_interaction_plot.png\n\n")

# Diagnostics for Q4
cat("7. DIAGNOSTICE MODEL Q4\n\n")
resid_q4 <- residuals(model_q4)
sw4 <- shapiro.test(resid_q4)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw4$statistic), ", p =", format.pval(sw4$p.value, digits=4), "\n")

bp4 <- bptest(model_q4)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp4$statistic), ", df =", bp4$parameter,
    ", p =", format.pval(bp4$p.value, digits=4), "\n")

dw4 <- dwtest(model_q4)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw4$statistic), ", p =", format.pval(dw4$p.value, digits=4), "\n")

cook4 <- cooks.distance(model_q4)
influential4 <- which(cook4 > 4/n)
cat("Puncte influente (Cook's D > 4/n):", length(influential4), "\n")

cat("\nVIF:\n")
vif_q4 <- vif(model_q4)
print(vif_q4)
cat("\n")

png("q4_diag_resid_fitted.png", width=600, height=500)
plot(model_q4, which=1, main="Q4: Residuals vs Fitted")
dev.off()
png("q4_diag_qq.png", width=600, height=500)
plot(model_q4, which=2, main="Q4: Normal Q-Q")
dev.off()
png("q4_diag_hist_resid.png", width=600, height=500)
hist(resid_q4, breaks=25, main="Q4: Histograma reziduurilor",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid_q4), sd=sd(resid_q4)), add=TRUE, col="red", lwd=2)
dev.off()
png("q4_diag_cooks.png", width=600, height=500)
plot(model_q4, which=4, main="Q4: Cook's Distance")
dev.off()
cat("Saved: q4 diagnostic plots\n\n")

# =====================================================================
#   COMPARAREA MODELELOR NESTED (Q3 vs Q4)
# =====================================================================
cat("###################################################################\n")
cat("# COMPARAREA MODELELOR: Fara interactiune (Q3) vs Cu interactiune (Q4)\n")
cat("###################################################################\n\n")

anova_comp <- anova(model_q3, model_q4)
print(anova_comp)
cat("\n")

cat("--- Tabelul 4: Compararea modelelor nested ---\n")
cat("Model 1 (fara interactiune): cGIM ~ Varsta + Gen + Covariate\n")
cat("Model 2 (cu interactiune): cGIM ~ Varsta * Gen + Covariate\n\n")
cat("F =", sprintf("%.4f", anova_comp$F[2]), "\n")
cat("df1 =", anova_comp$Df[2], "\n")
cat("df2 =", anova_comp$Res.Df[2], "\n")
cat("p-value =", format.pval(anova_comp$`Pr(>F)`[2], digits=4), "\n\n")

if (anova_comp$`Pr(>F)`[2] < 0.05) {
  cat("Decizie: p < 0.05 => Modelul cu interactiune (Q4) este semnificativ\n")
  cat("mai bun decat modelul fara interactiune (Q3).\n\n")
} else {
  cat("Decizie: p >= 0.05 => Modelul cu interactiune (Q4) NU este\n")
  cat("semnificativ mai bun decat modelul fara interactiune (Q3).\n")
  cat("Se pastreaza modelul mai simplu (Q3).\n\n")
}

# Compare R-squared
cat("Comparatie R-squared:\n")
cat("  Model Q3 (fara interactiune): R2 =", sprintf("%.4f", s_q3$r.squared),
    ", Adj R2 =", sprintf("%.4f", s_q3$adj.r.squared), "\n")
cat("  Model Q4 (cu interactiune):   R2 =", sprintf("%.4f", s_q4$r.squared),
    ", Adj R2 =", sprintf("%.4f", s_q4$adj.r.squared), "\n\n")

# Interpretations
cat("8. INTERPRETAREA COEFICIENTILOR (Model Q3 - fara interactiune)\n\n")
cat(sprintf("  Intercept = %.4f: cGIM estimat cand toate VI = 0\n", coef_q3[1,1]))
cat(sprintf("  Varsta_ani (B = %.4f): La cresterea cu 1 an a varstei,\n", coef_q3["Varsta_ani",1]))
cat("    cGIM creste cu", sprintf("%.4f", coef_q3["Varsta_ani",1]),
    "mm, controlind pentru celelalte variabile.\n")
cat(sprintf("  Gen (B = %.4f): Barbatii au un cGIM cu %.4f mm\n",
            coef_q3["Gen",1], coef_q3["Gen",1]))
cat("    mai mare/mic decat femeile, controlind pentru celelalte variabile.\n\n")

cat("9. INTERPRETAREA INTERACTIUNII (Model Q4)\n\n")
cat("In modelul cu interactiune:\n")
cat(sprintf("  Varsta_ani (B = %.4f): Efectul varstei la femei (Gen=0)\n", coef_q4["Varsta_ani",1]))
cat(sprintf("  Varsta_ani:Gen (B = %.4f): Diferenta de efect al varstei\n", coef_q4["Varsta_ani:Gen",1]))
cat("    intre barbati si femei. La barbati, efectul varstei = ",
    sprintf("%.4f", coef_q4["Varsta_ani",1] + coef_q4["Varsta_ani:Gen",1]), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
