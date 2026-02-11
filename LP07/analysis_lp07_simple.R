# =============================================================================
# LP07 - Regresia liniara multipla - selectia variabilelor independente
# VD: Vit_D_conc (concentratia serica 25(OH) vitamina D, nmol/L)
# VI potentiale: Varsta_ani, Ani_menopauza, IMC, PCG, CA, Scor_HEI, Scor_SEI
# n = 212 femei > 50 ani
# Metode selectie: Backward, Forward, Stepwise
# =============================================================================

library(car)
library(lmtest)
library(MASS)

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

vars <- c("Vit_D_conc", "Varsta_ani", "Ani_menopauza", "IMC", "PCG", "CA", "Scor_HEI", "Scor_SEI")
labels <- c("Vitamina D (nmol/L)", "Varsta (ani)", "Ani menopauza", "IMC (kg/m2)",
            "PCG (%)", "CA (cm)", "Scor HEI", "Scor SEI")

for (i in seq_along(vars)) {
  x <- data[[vars[i]]]
  cat(sprintf("--- %s ---\n", labels[i]))
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
  cat("  Outliers:", length(out), "\n\n")
}

# =====================================================================
# 2. BOX-PLOTS
# =====================================================================
cat("===========================================================================\n")
cat("2. BOX-PLOTS\n")
cat("===========================================================================\n\n")

png("boxplots_all.png", width=1200, height=600)
par(mfrow=c(2,4))
for (i in seq_along(vars)) {
  boxplot(data[[vars[i]]], main=labels[i], col="lightblue", border="darkblue")
}
dev.off()
cat("Salvat: boxplots_all.png\n\n")

# =====================================================================
# 3. SCATTER PLOTS (fiecare VI vs VD)
# =====================================================================
cat("===========================================================================\n")
cat("3. SCATTER PLOTS\n")
cat("===========================================================================\n\n")

iv_vars <- vars[-1]
iv_labels <- labels[-1]

png("scatter_plots.png", width=1200, height=800)
par(mfrow=c(2,4))
for (i in seq_along(iv_vars)) {
  plot(data[[iv_vars[i]]], data$Vit_D_conc,
       xlab=iv_labels[i], ylab="Vitamina D (nmol/L)",
       main=paste("VitD vs", iv_labels[i]),
       pch=19, col=rgb(0,0,1,0.3), cex=0.8)
  abline(lm(data$Vit_D_conc ~ data[[iv_vars[i]]]), col="red", lwd=2)
}
dev.off()
cat("Salvat: scatter_plots.png\n\n")

# =====================================================================
# 4. CORELATII
# =====================================================================
cat("===========================================================================\n")
cat("4. CORELATII\n")
cat("===========================================================================\n\n")

cat("Matricea de corelatie Pearson:\n")
cor_mat <- cor(data[, vars], use="complete.obs")
print(round(cor_mat, 4))
cat("\n")

cat("Teste de semnificatie (VD vs fiecare VI):\n")
for (v in iv_vars) {
  ct <- cor.test(data[[v]], data$Vit_D_conc)
  cat(sprintf("  VitD vs %s: r=%.4f, t=%.4f, df=%d, p=%s\n",
              v, ct$estimate, ct$statistic, ct$parameter, format.pval(ct$p.value, digits=4)))
}
cat("\n")

# =====================================================================
# 5. REGRESIE LINIARA SIMPLA PENTRU FIECARE FACTOR
# =====================================================================
cat("===========================================================================\n")
cat("5. REGRESIE LINIARA SIMPLA PENTRU FIECARE FACTOR\n")
cat("===========================================================================\n\n")

for (v in iv_vars) {
  mod <- lm(as.formula(paste("Vit_D_conc ~", v)), data=data)
  s <- summary(mod)
  ci <- confint(mod)
  cat(sprintf("--- %s ---\n", v))
  cat("  B =", sprintf("%.4f", coef(s)[2,1]), "\n")
  cat("  SE =", sprintf("%.4f", coef(s)[2,2]), "\n")
  cat("  t =", sprintf("%.4f", coef(s)[2,3]), "\n")
  cat("  p =", format.pval(coef(s)[2,4], digits=4), "\n")
  cat("  95% CI: [", sprintf("%.4f", ci[2,1]), ",", sprintf("%.4f", ci[2,2]), "]\n")
  cat("  R² =", sprintf("%.4f", s$r.squared), "\n\n")
}

# =====================================================================
# 6. REGRESIE MULTIPLA - BACKWARD SELECTION
# =====================================================================
cat("===========================================================================\n")
cat("6. BACKWARD SELECTION\n")
cat("===========================================================================\n\n")

model_full <- lm(Vit_D_conc ~ Varsta_ani + Ani_menopauza + IMC + PCG + CA + Scor_HEI + Scor_SEI, data=data)
cat("Model complet (full):\n")
print(summary(model_full))
cat("\n")

cat("--- Procedura Backward ---\n\n")
model_back <- step(model_full, direction="backward", trace=1)
cat("\n")

cat("Model final Backward:\n")
s_back <- summary(model_back)
print(s_back)
cat("\n")

ci_back <- confint(model_back)
cat("95% IC:\n")
print(ci_back)
cat("\n")

cat("R² =", sprintf("%.4f", s_back$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_back$adj.r.squared), "\n")
cat("F =", sprintf("%.4f", s_back$fstatistic[1]),
    "on", s_back$fstatistic[2], "and", s_back$fstatistic[3], "DF\n")
cat("p(F) =", format.pval(pf(s_back$fstatistic[1], s_back$fstatistic[2],
    s_back$fstatistic[3], lower.tail=FALSE), digits=4), "\n\n")

# Diagnostics for backward model
cat("--- Diagnostice model Backward ---\n\n")
resid_back <- residuals(model_back)

sw <- shapiro.test(resid_back)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw$statistic), ", p =", format.pval(sw$p.value, digits=4), "\n")
if (sw$p.value > 0.05) {
  cat("  Reziduurile sunt normal distribuite.\n")
} else {
  cat("  Reziduurile NU sunt normal distribuite.\n")
}

bp <- bptest(model_back)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp$statistic),
    ", p =", format.pval(bp$p.value, digits=4), "\n")
if (bp$p.value > 0.05) {
  cat("  Homoscedasticitate respectata.\n")
} else {
  cat("  Heteroscedasticitate detectata.\n")
}

dw <- dwtest(model_back)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw$statistic),
    ", p =", format.pval(dw$p.value, digits=4), "\n")
if (dw$p.value > 0.05) {
  cat("  Erorile sunt independente.\n")
} else {
  cat("  Erorile NU sunt independente.\n")
}

cook <- cooks.distance(model_back)
cat("Cook's D > 4/n:", sum(cook > 4/n), "observatii\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook)), "\n\n")

vars_in_back <- names(coef(model_back))[-1]
if (length(vars_in_back) > 1) {
  cat("VIF (Backward model):\n")
  print(vif(model_back))
  cat("\n")
}

png("back_diagnostic.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_back)
dev.off()
cat("Salvat: back_diagnostic.png\n\n")

# =====================================================================
# 7. REGRESIE MULTIPLA - FORWARD SELECTION
# =====================================================================
cat("===========================================================================\n")
cat("7. FORWARD SELECTION\n")
cat("===========================================================================\n\n")

model_null <- lm(Vit_D_conc ~ 1, data=data)
scope_formula <- formula(model_full)

cat("--- Procedura Forward ---\n\n")
model_fwd <- step(model_null, scope=list(lower=~1, upper=scope_formula),
                  direction="forward", trace=1)
cat("\n")

cat("Model final Forward:\n")
s_fwd <- summary(model_fwd)
print(s_fwd)
cat("\n")

ci_fwd <- confint(model_fwd)
cat("95% IC:\n")
print(ci_fwd)
cat("\n")

cat("R² =", sprintf("%.4f", s_fwd$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_fwd$adj.r.squared), "\n\n")

# =====================================================================
# 8. REGRESIE MULTIPLA - STEPWISE SELECTION
# =====================================================================
cat("===========================================================================\n")
cat("8. STEPWISE SELECTION\n")
cat("===========================================================================\n\n")

cat("--- Procedura Stepwise ---\n\n")
model_step <- step(model_null, scope=list(lower=~1, upper=scope_formula),
                   direction="both", trace=1)
cat("\n")

cat("Model final Stepwise:\n")
s_step <- summary(model_step)
print(s_step)
cat("\n")

ci_step <- confint(model_step)
cat("95% IC:\n")
print(ci_step)
cat("\n")

cat("R² =", sprintf("%.4f", s_step$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_step$adj.r.squared), "\n\n")

# =====================================================================
# 9. COMPARATIE MODELE
# =====================================================================
cat("===========================================================================\n")
cat("9. COMPARATIE MODELE\n")
cat("===========================================================================\n\n")

vars_in_fwd <- names(coef(model_fwd))[-1]
vars_in_step <- names(coef(model_step))[-1]
s_full <- summary(model_full)

cat("Model Backward - variabile selectate:", paste(vars_in_back, collapse=", "), "\n")
cat("  R² =", sprintf("%.4f", s_back$r.squared), ", Adj R² =", sprintf("%.4f", s_back$adj.r.squared), "\n")
cat("Model Forward - variabile selectate:", paste(vars_in_fwd, collapse=", "), "\n")
cat("  R² =", sprintf("%.4f", s_fwd$r.squared), ", Adj R² =", sprintf("%.4f", s_fwd$adj.r.squared), "\n")
cat("Model Stepwise - variabile selectate:", paste(vars_in_step, collapse=", "), "\n")
cat("  R² =", sprintf("%.4f", s_step$r.squared), ", Adj R² =", sprintf("%.4f", s_step$adj.r.squared), "\n")
cat("Model Full - toate variabilele\n")
cat("  R² =", sprintf("%.4f", s_full$r.squared), ", Adj R² =", sprintf("%.4f", s_full$adj.r.squared), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
