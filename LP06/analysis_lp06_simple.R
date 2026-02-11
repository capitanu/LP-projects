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
cat("=== Structura datelor ===\n")
str(data)
cat("n =", n, "\n\n")

# Clean column name (trailing space)
colnames(data) <- trimws(colnames(data))

# Recode Gen as factor
data$Gen_f <- factor(data$Gen, levels=c(0,1), labels=c("Femei","Barbati"))

# =====================================================================
#   INTREBAREA 1 - REGRESIE SIMPLA: Varsta -> cGIM
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 1: Exista o dependenta liniara semnificativa intre\n")
cat("# varsta si cGIM la pacientii cu AR?\n")
cat("###################################################################\n\n")

cat("===========================================================================\n")
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("===========================================================================\n\n")
cat("VD: cGIM_mm - cantitativa continua\n")
cat("VI: Varsta_ani - cantitativa continua\n\n")

cat("===========================================================================\n")
cat("2. ANALIZA DESCRIPTIVA\n")
cat("===========================================================================\n\n")

# cGIM
cat("--- cGIM_mm (mm) ---\n")
cat("  N:       ", sum(!is.na(data$cGIM_mm)), "\n")
cat("  NA:      ", sum(is.na(data$cGIM_mm)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$cGIM_mm, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(data$cGIM_mm, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$cGIM_mm, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$cGIM_mm, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$cGIM_mm, na.rm=TRUE)), "\n")
q_cgim <- quantile(data$cGIM_mm, c(0.25, 0.75), na.rm=TRUE)
iqr_cgim <- IQR(data$cGIM_mm, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.4f", q_cgim[1]), "\n")
cat("  Q3:      ", sprintf("%.4f", q_cgim[2]), "\n")
cat("  IQR:     ", sprintf("%.4f", iqr_cgim), "\n")
out_cgim <- data$cGIM_mm[data$cGIM_mm < q_cgim[1] - 1.5*iqr_cgim | data$cGIM_mm > q_cgim[2] + 1.5*iqr_cgim]
cat("  Outliers:", length(out_cgim), "\n\n")

# Varsta
cat("--- Varsta_ani (ani) ---\n")
cat("  N:       ", sum(!is.na(data$Varsta_ani)), "\n")
cat("  NA:      ", sum(is.na(data$Varsta_ani)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$Varsta_ani, na.rm=TRUE)), "\n")
cat("  Mediana: ", sprintf("%.4f", median(data$Varsta_ani, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$Varsta_ani, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$Varsta_ani, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$Varsta_ani, na.rm=TRUE)), "\n")
q_varsta <- quantile(data$Varsta_ani, c(0.25, 0.75), na.rm=TRUE)
iqr_varsta <- IQR(data$Varsta_ani, na.rm=TRUE)
cat("  Q1:      ", sprintf("%.4f", q_varsta[1]), "\n")
cat("  Q3:      ", sprintf("%.4f", q_varsta[2]), "\n")
cat("  IQR:     ", sprintf("%.4f", iqr_varsta), "\n")
out_varsta <- data$Varsta_ani[data$Varsta_ani < q_varsta[1] - 1.5*iqr_varsta | data$Varsta_ani > q_varsta[2] + 1.5*iqr_varsta]
cat("  Outliers:", length(out_varsta), "\n\n")

cat("===========================================================================\n")
cat("3. GRAFICE\n")
cat("===========================================================================\n\n")

png("q1_boxplot_cgim.png", width=600, height=400)
boxplot(data$cGIM_mm, main="Distributia cGIM (mm)", ylab="cGIM (mm)",
        col="lightblue", border="darkblue")
dev.off()
cat("Salvat: q1_boxplot_cgim.png\n")

png("q1_boxplot_varsta.png", width=600, height=400)
boxplot(data$Varsta_ani, main="Distributia Varsta (ani)", ylab="Varsta (ani)",
        col="lightgreen", border="darkgreen")
dev.off()
cat("Salvat: q1_boxplot_varsta.png\n")

png("q1_scatter.png", width=600, height=500)
plot(data$Varsta_ani, data$cGIM_mm,
     xlab="Varsta (ani)", ylab="cGIM (mm)",
     main="Relatia dintre varsta si cGIM",
     pch=19, col=rgb(0,0,1,0.4))
abline(lm(cGIM_mm ~ Varsta_ani, data=data), col="red", lwd=2)
dev.off()
cat("Salvat: q1_scatter.png\n\n")

cat("===========================================================================\n")
cat("4. CORELATIA\n")
cat("===========================================================================\n\n")

r1 <- cor.test(data$Varsta_ani, data$cGIM_mm)
cat("Pearson r =", sprintf("%.4f", r1$estimate), "\n")
cat("t =", sprintf("%.4f", r1$statistic), "\n")
cat("df =", r1$parameter, "\n")
cat("p-value =", format.pval(r1$p.value, digits=4), "\n")
cat("95% CI: [", sprintf("%.4f", r1$conf.int[1]), ",", sprintf("%.4f", r1$conf.int[2]), "]\n\n")

cat("===========================================================================\n")
cat("5. MODELUL DE REGRESIE SIMPLA (Varsta -> cGIM)\n")
cat("===========================================================================\n\n")

model_q1 <- lm(cGIM_mm ~ Varsta_ani, data=data)
s_q1 <- summary(model_q1)
print(s_q1)
cat("\n")

ci_q1 <- confint(model_q1)
cat("95% IC:\n")
print(ci_q1)
cat("\n")
cat("R² =", sprintf("%.4f", s_q1$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_q1$adj.r.squared), "\n\n")

# =====================================================================
#   INTREBAREA 2 - REGRESIE SIMPLA: Gen -> cGIM
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 2: Exista o asociere semnificativa intre gen si cGIM\n")
cat("# la pacientii cu AR?\n")
cat("###################################################################\n\n")

cat("===========================================================================\n")
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("===========================================================================\n\n")
cat("VD: cGIM_mm - cantitativa continua\n")
cat("VI: Gen - calitativa dihotomiala (0=Femei ref, 1=Barbati)\n\n")

cat("===========================================================================\n")
cat("2. ANALIZA DESCRIPTIVA\n")
cat("===========================================================================\n\n")

cat("Distributia Gen:\n")
print(table(data$Gen_f))
cat("\n")

for (g in levels(data$Gen_f)) {
  sub <- data$cGIM_mm[data$Gen_f == g]
  cat(sprintf("cGIM la %s (n=%d): Media=%.4f, SD=%.4f, Mediana=%.4f\n",
              g, length(sub), mean(sub), sd(sub), median(sub)))
}
cat("\n")

png("q2_boxplot_cgim_by_gen.png", width=600, height=500)
boxplot(cGIM_mm ~ Gen_f, data=data, main="cGIM per Gen",
        ylab="cGIM (mm)", xlab="Gen", col=c("pink","lightblue"))
dev.off()
cat("Salvat: q2_boxplot_cgim_by_gen.png\n\n")

cat("===========================================================================\n")
cat("3. MODELUL DE REGRESIE SIMPLA (Gen -> cGIM)\n")
cat("===========================================================================\n\n")

model_q2 <- lm(cGIM_mm ~ Gen, data=data)
s_q2 <- summary(model_q2)
print(s_q2)
cat("\n")

ci_q2 <- confint(model_q2)
cat("95% IC:\n")
print(ci_q2)
cat("\n")
cat("R² =", sprintf("%.4f", s_q2$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_q2$adj.r.squared), "\n\n")

# =====================================================================
#   INTREBAREA 3 - REGRESIE MULTIPLA FARA INTERACTIUNE
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 3: Exista o dependenta liniara semnificativa intre\n")
cat("# varsta si cGIM, ajustind pentru gen si caracteristicile clinice?\n")
cat("###################################################################\n\n")

cat("===========================================================================\n")
cat("1. SPECIFICAREA VARIABILELOR\n")
cat("===========================================================================\n\n")
cat("VD: cGIM_mm\n")
cat("VI de interes: Varsta_ani, Gen\n")
cat("Covariate: Durata_bolii_ani, Medicamente_antireumatice,\n")
cat("           Medicamente_antiinfl_nesteroidiene, Corticosteroizi\n\n")

cat("===========================================================================\n")
cat("2. STATISTICI DESCRIPTIVE COVARIATE\n")
cat("===========================================================================\n\n")

# Durata bolii
cat("--- Durata_bolii_ani ---\n")
cat("  N:       ", sum(!is.na(data$Durata_bolii_ani)), "\n")
cat("  Media:   ", sprintf("%.4f", mean(data$Durata_bolii_ani, na.rm=TRUE)), "\n")
cat("  SD:      ", sprintf("%.4f", sd(data$Durata_bolii_ani, na.rm=TRUE)), "\n")
cat("  Min:     ", sprintf("%.4f", min(data$Durata_bolii_ani, na.rm=TRUE)), "\n")
cat("  Max:     ", sprintf("%.4f", max(data$Durata_bolii_ani, na.rm=TRUE)), "\n\n")

cat("Medicamente_antireumatice:\n")
print(table(data$Medicamente_antireumatice))
cat("\nMedicamente_antiinfl_nesteroidiene:\n")
print(table(data$Medicamente_antiinfl_nesteroidiene))
cat("\nCorticosteroizi:\n")
print(table(data$Corticosteroizi))
cat("\n")

cat("===========================================================================\n")
cat("3. MODELUL DE REGRESIE MULTIPLA FARA INTERACTIUNE\n")
cat("===========================================================================\n\n")

model_q3 <- lm(cGIM_mm ~ Varsta_ani + Gen + Durata_bolii_ani +
                  Medicamente_antireumatice + Medicamente_antiinfl_nesteroidiene +
                  Corticosteroizi, data=data)
s_q3 <- summary(model_q3)
print(s_q3)
cat("\n")

ci_q3 <- confint(model_q3)
cat("95% IC:\n")
print(ci_q3)
cat("\n")

# F-test global
cat("Testul F global:\n")
cat("  F =", sprintf("%.4f", s_q3$fstatistic[1]), "\n")
cat("  df1 =", s_q3$fstatistic[2], ", df2 =", s_q3$fstatistic[3], "\n")
p_f3 <- pf(s_q3$fstatistic[1], s_q3$fstatistic[2], s_q3$fstatistic[3], lower.tail=FALSE)
cat("  p-value =", format.pval(p_f3, digits=4), "\n\n")

cat("R² =", sprintf("%.4f", s_q3$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_q3$adj.r.squared), "\n\n")

# Diagnostics Q3
cat("===========================================================================\n")
cat("4. DIAGNOSTICE MODEL Q3\n")
cat("===========================================================================\n\n")

resid_q3 <- residuals(model_q3)
sw3 <- shapiro.test(resid_q3)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw3$statistic), ", p =", format.pval(sw3$p.value, digits=4), "\n")
if (sw3$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

bp3 <- bptest(model_q3)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp3$statistic),
    ", p =", format.pval(bp3$p.value, digits=4), "\n")
if (bp3$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

dw3 <- dwtest(model_q3)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw3$statistic),
    ", p =", format.pval(dw3$p.value, digits=4), "\n")
if (dw3$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

cook3 <- cooks.distance(model_q3)
cat("Cook's D > 4/n:", sum(cook3 > 4/n), "observatii\n")
sr3 <- rstandard(model_q3)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr3) > 2), "observatii\n\n")

cat("VIF:\n")
print(vif(model_q3))
cat("\n")

png("q3_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_q3)
dev.off()
cat("Salvat: q3_diagnostic.png\n\n")

# =====================================================================
#   INTREBAREA 4 - REGRESIE MULTIPLA CU INTERACTIUNE Varsta*Gen
# =====================================================================
cat("###################################################################\n")
cat("# INTREBAREA 4: Dependenta liniara intre varsta si cGIM difera\n")
cat("# semnificativ in functie de gen, ajustind pentru covariate?\n")
cat("###################################################################\n\n")

cat("===========================================================================\n")
cat("1. MODELUL CU INTERACTIUNE\n")
cat("===========================================================================\n\n")

model_q4 <- lm(cGIM_mm ~ Varsta_ani * Gen + Durata_bolii_ani +
                  Medicamente_antireumatice + Medicamente_antiinfl_nesteroidiene +
                  Corticosteroizi, data=data)
s_q4 <- summary(model_q4)
print(s_q4)
cat("\n")

ci_q4 <- confint(model_q4)
cat("95% IC:\n")
print(ci_q4)
cat("\n")

# F-test global
cat("Testul F global:\n")
cat("  F =", sprintf("%.4f", s_q4$fstatistic[1]), "\n")
cat("  df1 =", s_q4$fstatistic[2], ", df2 =", s_q4$fstatistic[3], "\n")
p_f4 <- pf(s_q4$fstatistic[1], s_q4$fstatistic[2], s_q4$fstatistic[3], lower.tail=FALSE)
cat("  p-value =", format.pval(p_f4, digits=4), "\n\n")

cat("R² =", sprintf("%.4f", s_q4$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_q4$adj.r.squared), "\n\n")

# Semnificatia interactiunii
cat("===========================================================================\n")
cat("2. SEMNIFICATIA TERMENULUI DE INTERACTIUNE\n")
cat("===========================================================================\n\n")

coef_q4 <- s_q4$coefficients
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
cat("===========================================================================\n")
cat("3. GRAFICUL INTERACTIUNII\n")
cat("===========================================================================\n\n")

png("q4_interaction_plot.png", width=700, height=500)
varsta_range <- seq(min(data$Varsta_ani), max(data$Varsta_ani), length.out=100)
newdata_f <- data.frame(
  Varsta_ani = varsta_range, Gen = 0,
  Durata_bolii_ani = mean(data$Durata_bolii_ani),
  Medicamente_antireumatice = mean(data$Medicamente_antireumatice),
  Medicamente_antiinfl_nesteroidiene = mean(data$Medicamente_antiinfl_nesteroidiene),
  Corticosteroizi = mean(data$Corticosteroizi))
pred_f <- predict(model_q4, newdata_f)
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
points(data$Varsta_ani[data$Gen==0], data$cGIM_mm[data$Gen==0],
       pch=19, col=rgb(1,0,0,0.2), cex=0.7)
points(data$Varsta_ani[data$Gen==1], data$cGIM_mm[data$Gen==1],
       pch=19, col=rgb(0,0,1,0.2), cex=0.7)
dev.off()
cat("Salvat: q4_interaction_plot.png\n\n")

# Diagnostics Q4
cat("===========================================================================\n")
cat("4. DIAGNOSTICE MODEL Q4\n")
cat("===========================================================================\n\n")

resid_q4 <- residuals(model_q4)
sw4 <- shapiro.test(resid_q4)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw4$statistic), ", p =", format.pval(sw4$p.value, digits=4), "\n")
if (sw4$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

bp4 <- bptest(model_q4)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp4$statistic),
    ", p =", format.pval(bp4$p.value, digits=4), "\n")
if (bp4$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

dw4 <- dwtest(model_q4)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw4$statistic),
    ", p =", format.pval(dw4$p.value, digits=4), "\n")
if (dw4$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

cook4 <- cooks.distance(model_q4)
cat("Cook's D > 4/n:", sum(cook4 > 4/n), "observatii\n")
sr4 <- rstandard(model_q4)
cat("Reziduuri standardizate |> 2|:", sum(abs(sr4) > 2), "observatii\n\n")

cat("VIF:\n")
print(vif(model_q4))
cat("\n")

png("q4_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_q4)
dev.off()
cat("Salvat: q4_diagnostic.png\n\n")

# =====================================================================
#   COMPARAREA MODELELOR NESTED (Q3 vs Q4)
# =====================================================================
cat("###################################################################\n")
cat("# COMPARAREA MODELELOR: Fara interactiune (Q3) vs Cu interactiune (Q4)\n")
cat("###################################################################\n\n")

anova_comp <- anova(model_q3, model_q4)
print(anova_comp)
cat("\n")

if (anova_comp$`Pr(>F)`[2] < 0.05) {
  cat("Decizie: p < 0.05 => Modelul cu interactiune (Q4) este semnificativ\n")
  cat("mai bun decat modelul fara interactiune (Q3).\n\n")
} else {
  cat("Decizie: p >= 0.05 => Modelul cu interactiune (Q4) NU este\n")
  cat("semnificativ mai bun. Se pastreaza modelul mai simplu (Q3).\n\n")
}

cat("Comparatie R²:\n")
cat("  Model Q3 (fara interactiune): R² =", sprintf("%.4f", s_q3$r.squared),
    ", Adj R² =", sprintf("%.4f", s_q3$adj.r.squared), "\n")
cat("  Model Q4 (cu interactiune):   R² =", sprintf("%.4f", s_q4$r.squared),
    ", Adj R² =", sprintf("%.4f", s_q4$adj.r.squared), "\n\n")

# Interpretare
cat("===========================================================================\n")
cat("INTERPRETARE\n")
cat("===========================================================================\n\n")

coef_q3_vals <- coef(model_q3)
coef_q4_vals <- coef(model_q4)

cat("Model Q3 (fara interactiune):\n")
cat("  Varsta_ani (B =", sprintf("%.4f", coef_q3_vals["Varsta_ani"]),
    "): La cresterea cu 1 an, cGIM creste cu",
    sprintf("%.4f", coef_q3_vals["Varsta_ani"]), "mm, controlind pentru celelalte.\n")
cat("  Gen (B =", sprintf("%.4f", coef_q3_vals["Gen"]),
    "): Barbatii au un cGIM cu", sprintf("%.4f", coef_q3_vals["Gen"]),
    "mm diferit fata de femei.\n\n")

cat("Model Q4 (cu interactiune):\n")
cat("  Varsta_ani (B =", sprintf("%.4f", coef_q4_vals["Varsta_ani"]),
    "): Efectul varstei la femei (Gen=0)\n")
cat("  Varsta_ani:Gen (B =", sprintf("%.4f", coef_q4_vals["Varsta_ani:Gen"]),
    "): Diferenta de efect al varstei intre barbati si femei.\n")
cat("  La barbati, efectul varstei =",
    sprintf("%.4f", coef_q4_vals["Varsta_ani"] + coef_q4_vals["Varsta_ani:Gen"]), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
