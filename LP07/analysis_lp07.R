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

vars <- c("Vit_D_conc", "Varsta_ani", "Ani_menopauza", "IMC", "PCG", "CA", "Scor_HEI", "Scor_SEI")
labels <- c("Vitamina D (nmol/L)", "Varsta (ani)", "Ani menopauza", "IMC (kg/m2)",
            "PCG (%)", "CA (cm)", "Scor HEI", "Scor SEI")
for (i in seq_along(vars)) {
  desc_stats(data[[vars[i]]], labels[i])
}

# =====================================================================
# 2. BOX-PLOTS
# =====================================================================
cat("###################################################################\n")
cat("# 2. BOX-PLOTS\n")
cat("###################################################################\n\n")

png("boxplots_all.png", width=1200, height=600)
par(mfrow=c(2,4))
for (i in seq_along(vars)) {
  boxplot(data[[vars[i]]], main=labels[i], col="lightblue", border="darkblue")
}
dev.off()
cat("Saved: boxplots_all.png\n\n")

# =====================================================================
# 3. SCATTER PLOTS (fiecare VI vs VD)
# =====================================================================
cat("###################################################################\n")
cat("# 3. SCATTER PLOTS\n")
cat("###################################################################\n\n")

iv_vars <- vars[-1]  # exclude VD
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
cat("Saved: scatter_plots.png\n\n")

# =====================================================================
# 4. CORELATII
# =====================================================================
cat("###################################################################\n")
cat("# 4. CORELATII\n")
cat("###################################################################\n\n")

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
cat("###################################################################\n")
cat("# 5. REGRESIE LINIARA SIMPLA PENTRU FIECARE FACTOR\n")
cat("###################################################################\n\n")

cat("--- Tabelul 0: Regresie simpla ---\n")
cat(sprintf("%-20s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "t(df)", "p-value"))

for (v in iv_vars) {
  mod <- lm(as.formula(paste("Vit_D_conc ~", v)), data=data)
  s <- summary(mod)
  ci <- confint(mod)
  coefs <- coef(s)
  # Only show the VI row (row 2)
  i <- 2
  tval <- sprintf("%.4f(%d)", coefs[i,3], mod$df.residual)
  pval <- format.pval(coefs[i,4], digits=4)
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %15s %15s\n",
              v, coefs[i,1], coefs[i,2], ci[i,1], ci[i,2], tval, pval))
  # Also show R-squared
  cat(sprintf("  R-squared = %.4f, F = %.4f, p(F) = %s\n\n",
              s$r.squared, s$fstatistic[1],
              format.pval(pf(s$fstatistic[1], s$fstatistic[2], s$fstatistic[3], lower.tail=FALSE), digits=4)))
}

# =====================================================================
# 6. REGRESIE MULTIPLA - BACKWARD SELECTION
# =====================================================================
cat("###################################################################\n")
cat("# 6. BACKWARD SELECTION\n")
cat("###################################################################\n\n")

# Start with full model
model_full <- lm(Vit_D_conc ~ Varsta_ani + Ani_menopauza + IMC + PCG + CA + Scor_HEI + Scor_SEI, data=data)
cat("Model complet (full):\n")
print(summary(model_full))
cat("\n")

# Backward selection using step()
cat("--- Procedura Backward ---\n\n")
model_back <- step(model_full, direction="backward", trace=1)
cat("\n")

cat("Model final Backward:\n")
s_back <- summary(model_back)
print(s_back)
cat("\n")

coef_back <- coef(s_back)
ci_back <- confint(model_back)

# Standardized coefficients
vars_in_back <- names(coef(model_back))[-1]
data_scaled <- as.data.frame(scale(data[, c("Vit_D_conc", vars_in_back)]))
formula_std <- as.formula(paste("Vit_D_conc ~", paste(vars_in_back, collapse=" + ")))
model_back_std <- lm(formula_std, data=data_scaled)
beta_std <- coef(model_back_std)

cat("--- Tabelul 1: Backward selection ---\n")
cat(sprintf("%-20s %10s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_back)) {
  tval <- sprintf("%.4f(%d)", coef_back[i,3], model_back$df.residual)
  pval <- format.pval(coef_back[i,4], digits=4)
  beta_val <- if (i == 1) "-" else sprintf("%.4f", beta_std[i])
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %10s %15s %15s\n",
              rownames(coef_back)[i], coef_back[i,1], coef_back[i,2],
              ci_back[i,1], ci_back[i,2], beta_val, tval, pval))
}
cat("\n")

cat("R-squared =", sprintf("%.4f", s_back$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_back$adj.r.squared), "\n")
cat("F =", sprintf("%.4f", s_back$fstatistic[1]),
    "on", s_back$fstatistic[2], "and", s_back$fstatistic[3], "DF\n")
cat("p(F) =", format.pval(pf(s_back$fstatistic[1], s_back$fstatistic[2],
    s_back$fstatistic[3], lower.tail=FALSE), digits=4), "\n\n")

# Diagnostics for backward model
cat("--- Diagnostice model Backward ---\n\n")
resid_back <- residuals(model_back)

# Normality
sw <- shapiro.test(resid_back)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw$statistic), ", p =", format.pval(sw$p.value, digits=4), "\n")
ks <- ks.test(resid_back, "pnorm", mean=mean(resid_back), sd=sd(resid_back))
cat("KS test: D =", sprintf("%.4f", ks$statistic), ", p =", format.pval(ks$p.value, digits=4), "\n\n")

png("back_diag_resid_fitted.png", width=600, height=500)
plot(model_back, which=1, main="Backward: Residuals vs Fitted")
dev.off()
png("back_diag_qq.png", width=600, height=500)
plot(model_back, which=2, main="Backward: Normal Q-Q")
dev.off()
png("back_diag_hist.png", width=600, height=500)
hist(resid_back, breaks=25, main="Backward: Histograma reziduurilor",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid_back), sd=sd(resid_back)), add=TRUE, col="red", lwd=2)
dev.off()
cat("Saved diagnostic plots (backward)\n")

# Homoscedasticity
bp <- bptest(model_back)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp$statistic), ", df =", bp$parameter,
    ", p =", format.pval(bp$p.value, digits=4), "\n")

png("back_diag_scale_loc.png", width=600, height=500)
plot(model_back, which=3, main="Backward: Scale-Location")
dev.off()

# Durbin-Watson
dw <- dwtest(model_back)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw$statistic), ", p =", format.pval(dw$p.value, digits=4), "\n")

# Outliers
cook <- cooks.distance(model_back)
influential <- which(cook > 4/n)
cat("Puncte influente (Cook's D > 4/n):", length(influential), "\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook)), "\n")

png("back_diag_cooks.png", width=600, height=500)
plot(model_back, which=4, main="Backward: Cook's Distance")
dev.off()
png("back_diag_leverage.png", width=600, height=500)
plot(model_back, which=5, main="Backward: Residuals vs Leverage")
dev.off()

# VIF
cat("\nVIF (Backward model):\n")
if (length(vars_in_back) > 1) {
  vif_back <- vif(model_back)
  print(vif_back)
} else {
  cat("Only 1 predictor, VIF not applicable.\n")
}
cat("\n")

# =====================================================================
# 7. REGRESIE MULTIPLA - FORWARD SELECTION
# =====================================================================
cat("###################################################################\n")
cat("# 7. FORWARD SELECTION\n")
cat("###################################################################\n\n")

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

coef_fwd <- coef(s_fwd)
ci_fwd <- confint(model_fwd)

# Standardized coefficients
vars_in_fwd <- names(coef(model_fwd))[-1]
if (length(vars_in_fwd) > 0) {
  data_scaled_fwd <- as.data.frame(scale(data[, c("Vit_D_conc", vars_in_fwd)]))
  formula_std_fwd <- as.formula(paste("Vit_D_conc ~", paste(vars_in_fwd, collapse=" + ")))
  model_fwd_std <- lm(formula_std_fwd, data=data_scaled_fwd)
  beta_std_fwd <- coef(model_fwd_std)
}

cat("--- Tabelul 2: Forward selection ---\n")
cat(sprintf("%-20s %10s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_fwd)) {
  tval <- sprintf("%.4f(%d)", coef_fwd[i,3], model_fwd$df.residual)
  pval <- format.pval(coef_fwd[i,4], digits=4)
  beta_val <- if (i == 1) "-" else sprintf("%.4f", beta_std_fwd[i])
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %10s %15s %15s\n",
              rownames(coef_fwd)[i], coef_fwd[i,1], coef_fwd[i,2],
              ci_fwd[i,1], ci_fwd[i,2], beta_val, tval, pval))
}
cat("\n")

cat("R-squared =", sprintf("%.4f", s_fwd$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_fwd$adj.r.squared), "\n\n")

# =====================================================================
# 8. REGRESIE MULTIPLA - STEPWISE SELECTION
# =====================================================================
cat("###################################################################\n")
cat("# 8. STEPWISE SELECTION\n")
cat("###################################################################\n\n")

cat("--- Procedura Stepwise ---\n\n")
model_step <- step(model_null, scope=list(lower=~1, upper=scope_formula),
                   direction="both", trace=1)
cat("\n")

cat("Model final Stepwise:\n")
s_step <- summary(model_step)
print(s_step)
cat("\n")

coef_step <- coef(s_step)
ci_step <- confint(model_step)

# Standardized coefficients
vars_in_step <- names(coef(model_step))[-1]
if (length(vars_in_step) > 0) {
  data_scaled_step <- as.data.frame(scale(data[, c("Vit_D_conc", vars_in_step)]))
  formula_std_step <- as.formula(paste("Vit_D_conc ~", paste(vars_in_step, collapse=" + ")))
  model_step_std <- lm(formula_std_step, data=data_scaled_step)
  beta_std_step <- coef(model_step_std)
}

cat("--- Tabelul 3: Stepwise selection ---\n")
cat(sprintf("%-20s %10s %10s %10s %10s %10s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_step)) {
  tval <- sprintf("%.4f(%d)", coef_step[i,3], model_step$df.residual)
  pval <- format.pval(coef_step[i,4], digits=4)
  beta_val <- if (i == 1) "-" else sprintf("%.4f", beta_std_step[i])
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %10s %15s %15s\n",
              rownames(coef_step)[i], coef_step[i,1], coef_step[i,2],
              ci_step[i,1], ci_step[i,2], beta_val, tval, pval))
}
cat("\n")

cat("R-squared =", sprintf("%.4f", s_step$r.squared), "\n")
cat("Adj R-squared =", sprintf("%.4f", s_step$adj.r.squared), "\n\n")

# =====================================================================
# 9. COMPARATIE MODELE
# =====================================================================
cat("###################################################################\n")
cat("# 9. COMPARATIE MODELE\n")
cat("###################################################################\n\n")

cat("Model Backward - variabile selectate:", paste(vars_in_back, collapse=", "), "\n")
cat("  R2 =", sprintf("%.4f", s_back$r.squared), ", Adj R2 =", sprintf("%.4f", s_back$adj.r.squared), "\n")
cat("Model Forward - variabile selectate:", paste(vars_in_fwd, collapse=", "), "\n")
cat("  R2 =", sprintf("%.4f", s_fwd$r.squared), ", Adj R2 =", sprintf("%.4f", s_fwd$adj.r.squared), "\n")
cat("Model Stepwise - variabile selectate:", paste(vars_in_step, collapse=", "), "\n")
cat("  R2 =", sprintf("%.4f", s_step$r.squared), ", Adj R2 =", sprintf("%.4f", s_step$adj.r.squared), "\n")
cat("Model Full - toate variabilele\n")
s_full <- summary(model_full)
cat("  R2 =", sprintf("%.4f", s_full$r.squared), ", Adj R2 =", sprintf("%.4f", s_full$adj.r.squared), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
