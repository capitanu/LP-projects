# =============================================================================
# LP09 - Regresia liniara multipla - Validarea modelului
# VD: Vit_D_conc (concentratia serica 25(OH) vitamina D, nmol/L)
# VI potentiale: Varsta_ani, Ani_menopauza, IMC, PCG, CA
# n = 212 femei > 50 ani
# =============================================================================

library(car)
library(lmtest)
library(MASS)

set.seed(123)

data <- read.csv("data.csv", stringsAsFactors = FALSE)
data <- data[, -1]  # remove Id_pac
n <- nrow(data)
cat("n =", n, "\n\n")

# =============================================================================
# PARTEA 1: ANALIZA DESCRIPTIVA SI SELECTIA MODELULUI
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 1: ANALIZA DESCRIPTIVA SI SELECTIA MODELULUI\n")
cat("###################################################################\n\n")

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

cat("1. STATISTICI DESCRIPTIVE\n\n")
desc_stats(data$Vit_D_conc, "Vit_D_conc (nmol/L)")
desc_stats(data$Varsta_ani, "Varsta_ani (ani)")
desc_stats(data$Ani_menopauza, "Ani_menopauza (ani)")
desc_stats(data$IMC, "IMC (kg/m2)")
desc_stats(data$PCG, "PCG (%)")
desc_stats(data$CA, "CA (cm)")

# Boxplots
png("boxplots_all.png", width=900, height=600)
par(mfrow=c(2,3))
boxplot(data$Vit_D_conc, main="Vit_D_conc (nmol/L)", col="lightyellow")
boxplot(data$Varsta_ani, main="Varsta (ani)", col="lightblue")
boxplot(data$Ani_menopauza, main="Ani menopauza", col="lightgreen")
boxplot(data$IMC, main="IMC (kg/m2)", col="lightpink")
boxplot(data$PCG, main="PCG (%)", col="lightsalmon")
boxplot(data$CA, main="CA (cm)", col="plum")
dev.off()
cat("Saved: boxplots_all.png\n\n")

# Scatter plots
png("scatter_plots.png", width=900, height=600)
par(mfrow=c(2,3))
plot(data$Varsta_ani, data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
     xlab="Varsta (ani)", ylab="Vit D (nmol/L)", main="Varsta vs Vit D")
abline(lm(Vit_D_conc ~ Varsta_ani, data=data), col="red", lwd=2)
plot(data$Ani_menopauza, data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
     xlab="Ani menopauza", ylab="Vit D (nmol/L)", main="Ani menopauza vs Vit D")
abline(lm(Vit_D_conc ~ Ani_menopauza, data=data), col="red", lwd=2)
plot(data$IMC, data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
     xlab="IMC (kg/m2)", ylab="Vit D (nmol/L)", main="IMC vs Vit D")
abline(lm(Vit_D_conc ~ IMC, data=data), col="red", lwd=2)
plot(data$PCG, data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
     xlab="PCG (%)", ylab="Vit D (nmol/L)", main="PCG vs Vit D")
abline(lm(Vit_D_conc ~ PCG, data=data), col="red", lwd=2)
plot(data$CA, data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
     xlab="CA (cm)", ylab="Vit D (nmol/L)", main="CA vs Vit D")
abline(lm(Vit_D_conc ~ CA, data=data), col="red", lwd=2)
dev.off()
cat("Saved: scatter_plots.png\n\n")

# Correlation matrix
cat("2. MATRICEA DE CORELATIE\n\n")
cor_mat <- cor(data)
print(round(cor_mat, 4))
cat("\n")

cat("Corelatii semnificative cu Vit_D_conc:\n\n")
vi_names <- c("Varsta_ani", "Ani_menopauza", "IMC", "PCG", "CA")
for (v in vi_names) {
  ct <- cor.test(data[[v]], data$Vit_D_conc)
  sig <- ifelse(ct$p.value < 0.05, "Da", "Nu")
  cat(sprintf("  %-15s r=%.4f  t=%.4f  df=%d  p=%s  Semnif: %s\n",
              v, ct$estimate, ct$statistic, ct$parameter,
              format.pval(ct$p.value, digits=4), sig))
}
cat("\n")

# Variable selection - Backward
cat("3. SELECTIA VARIABILELOR (Backward)\n\n")
model_full <- lm(Vit_D_conc ~ ., data=data)
cat("Model complet:\n")
print(summary(model_full))
cat("\n")

model_back <- stepAIC(model_full, direction="backward", trace=1)
cat("\nModel final Backward:\n")
s_back <- summary(model_back)
print(s_back)
cat("\n")

# Forward selection
cat("4. SELECTIA VARIABILELOR (Forward)\n\n")
model_null <- lm(Vit_D_conc ~ 1, data=data)
model_fwd <- stepAIC(model_null, scope=list(lower=model_null, upper=model_full),
                     direction="forward", trace=1)
cat("\nModel final Forward:\n")
s_fwd <- summary(model_fwd)
print(s_fwd)
cat("\n")

# Stepwise selection
cat("5. SELECTIA VARIABILELOR (Stepwise)\n\n")
model_step <- stepAIC(model_null, scope=list(lower=model_null, upper=model_full),
                      direction="both", trace=1)
cat("\nModel final Stepwise:\n")
s_step <- summary(model_step)
print(s_step)
cat("\n")

# Use the selected model for validation
# Determine which model to use
cat("MODELUL SELECTAT PENTRU VALIDARE:\n")
cat("Formula:", deparse(formula(model_back)), "\n")
cat("R2 =", sprintf("%.4f", s_back$r.squared), "\n")
cat("Adj R2 =", sprintf("%.4f", s_back$adj.r.squared), "\n\n")

# Coefficients table with CI
coef_sel <- coef(s_back)
ci_sel <- confint(model_back)
cat("--- Tabelul coeficientilor modelului selectat ---\n")
sd_y <- sd(data$Vit_D_conc)
cat(sprintf("%-20s %10s %10s %10s %10s %8s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_sel)) {
  tval <- sprintf("%.4f(%d)", coef_sel[i,3], model_back$df.residual)
  pval <- format.pval(coef_sel[i,4], digits=4)
  vname <- rownames(coef_sel)[i]
  if (vname == "(Intercept)") {
    beta_val <- "-"
  } else {
    beta_val <- sprintf("%.4f", coef_sel[i,1] * sd(data[[vname]]) / sd_y)
  }
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %8s %15s %15s\n",
              vname, coef_sel[i,1], coef_sel[i,2],
              ci_sel[i,1], ci_sel[i,2], beta_val, tval, pval))
}
cat("\n")

# Diagnostics on the full data model
cat("6. DIAGNOSTICE MODEL SELECTAT (pe date complete)\n\n")

resid_sel <- residuals(model_back)
sw <- shapiro.test(resid_sel)
cat("Shapiro-Wilk: W =", sprintf("%.4f", sw$statistic), ", p =", format.pval(sw$p.value, digits=4), "\n")
ks <- ks.test(resid_sel, "pnorm", mean=mean(resid_sel), sd=sd(resid_sel))
cat("KS test: D =", sprintf("%.4f", ks$statistic), ", p =", format.pval(ks$p.value, digits=4), "\n")
bp <- bptest(model_back)
cat("Breusch-Pagan: BP =", sprintf("%.4f", bp$statistic), ", df =", bp$parameter,
    ", p =", format.pval(bp$p.value, digits=4), "\n")
dw <- dwtest(model_back)
cat("Durbin-Watson: DW =", sprintf("%.4f", dw$statistic), ", p =", format.pval(dw$p.value, digits=4), "\n")

cook_sel <- cooks.distance(model_back)
influential <- which(cook_sel > 4/n)
cat("Puncte influente (Cook's D > 4/n):", length(influential), "\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook_sel)), "\n")

if (length(coef(model_back)) > 2) {
  cat("\nVIF:\n")
  print(vif(model_back))
}
cat("\n")

# Diagnostic plots
png("diag_resid_fitted.png", width=600, height=500)
plot(model_back, which=1, main="Residuals vs Fitted")
dev.off()
png("diag_qq.png", width=600, height=500)
plot(model_back, which=2, main="Normal Q-Q")
dev.off()
png("diag_hist.png", width=600, height=500)
hist(resid_sel, breaks=25, main="Histograma reziduurilor",
     xlab="Reziduuri", col="lightblue", probability=TRUE)
curve(dnorm(x, mean=mean(resid_sel), sd=sd(resid_sel)), add=TRUE, col="red", lwd=2)
dev.off()
png("diag_scale_loc.png", width=600, height=500)
plot(model_back, which=3, main="Scale-Location")
dev.off()
png("diag_cooks.png", width=600, height=500)
plot(model_back, which=4, main="Cook's Distance")
dev.off()
cat("Saved: diagnostic plots\n\n")

# =============================================================================
# PARTEA 2: VALIDARE PRIN IMPARTIREA DATELOR (Train/Test Split)
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 2: VALIDARE PRIN TRAIN/TEST SPLIT (70%/30%)\n")
cat("###################################################################\n\n")

set.seed(123)
train_idx <- sample(1:n, size=round(0.7*n))
test_idx <- setdiff(1:n, train_idx)
train_data <- data[train_idx, ]
test_data <- data[test_idx, ]

cat("Dimensiuni:\n")
cat("  Set antrenare (train): n =", nrow(train_data), "\n")
cat("  Set testare (test):    n =", nrow(test_data), "\n\n")

# Train the selected model on training data
model_formula <- formula(model_back)
model_train <- lm(model_formula, data=train_data)
s_train <- summary(model_train)
cat("MODEL PE SETUL DE ANTRENARE:\n\n")
print(s_train)
cat("\n")

coef_train <- coef(s_train)
ci_train <- confint(model_train)
cat("--- Tabelul coeficientilor (set antrenare) ---\n")
sd_y_train <- sd(train_data$Vit_D_conc)
cat(sprintf("%-20s %10s %10s %10s %10s %8s %15s %15s\n",
            "Variabila", "B", "SE", "CI_low", "CI_up", "Beta", "t(df)", "p-value"))
for (i in 1:nrow(coef_train)) {
  tval <- sprintf("%.4f(%d)", coef_train[i,3], model_train$df.residual)
  pval <- format.pval(coef_train[i,4], digits=4)
  vname <- rownames(coef_train)[i]
  if (vname == "(Intercept)") {
    beta_val <- "-"
  } else {
    beta_val <- sprintf("%.4f", coef_train[i,1] * sd(train_data[[vname]]) / sd_y_train)
  }
  cat(sprintf("%-20s %10.4f %10.4f %10.4f %10.4f %8s %15s %15s\n",
              vname, coef_train[i,1], coef_train[i,2],
              ci_train[i,1], ci_train[i,2], beta_val, tval, pval))
}
cat("\n")

# Performance on training set
pred_train <- predict(model_train, newdata=train_data)
resid_train <- train_data$Vit_D_conc - pred_train
SS_res_train <- sum(resid_train^2)
SS_tot_train <- sum((train_data$Vit_D_conc - mean(train_data$Vit_D_conc))^2)
R2_train <- 1 - SS_res_train/SS_tot_train
n_train <- nrow(train_data)
p_model <- length(coef(model_train)) - 1  # number of predictors
R2_adj_train <- 1 - (1-R2_train)*(n_train-1)/(n_train-p_model-1)
RMSE_train <- sqrt(mean(resid_train^2))
MAE_train <- mean(abs(resid_train))

cat("PERFORMANTA PE SETUL DE ANTRENARE:\n")
cat("  R2 =", sprintf("%.4f", R2_train), "\n")
cat("  R2 ajustat =", sprintf("%.4f", R2_adj_train), "\n")
cat("  RMSE =", sprintf("%.4f", RMSE_train), "\n")
cat("  MAE =", sprintf("%.4f", MAE_train), "\n\n")

# Performance on test set
pred_test <- predict(model_train, newdata=test_data)
resid_test <- test_data$Vit_D_conc - pred_test
SS_res_test <- sum(resid_test^2)
SS_tot_test <- sum((test_data$Vit_D_conc - mean(test_data$Vit_D_conc))^2)
R2_test <- 1 - SS_res_test/SS_tot_test
n_test <- nrow(test_data)
R2_adj_test <- 1 - (1-R2_test)*(n_test-1)/(n_test-p_model-1)
RMSE_test <- sqrt(mean(resid_test^2))
MAE_test <- mean(abs(resid_test))

cat("PERFORMANTA PE SETUL DE TESTARE:\n")
cat("  R2 =", sprintf("%.4f", R2_test), "\n")
cat("  R2 ajustat =", sprintf("%.4f", R2_adj_test), "\n")
cat("  RMSE =", sprintf("%.4f", RMSE_test), "\n")
cat("  MAE =", sprintf("%.4f", MAE_test), "\n\n")

# Comparison table
cat("--- Comparatie Train vs Test ---\n")
cat(sprintf("%-20s %10s %10s\n", "Metrica", "Train", "Test"))
cat(sprintf("%-20s %10.4f %10.4f\n", "R2", R2_train, R2_test))
cat(sprintf("%-20s %10.4f %10.4f\n", "R2 ajustat", R2_adj_train, R2_adj_test))
cat(sprintf("%-20s %10.4f %10.4f\n", "RMSE", RMSE_train, RMSE_test))
cat(sprintf("%-20s %10.4f %10.4f\n", "MAE", MAE_train, MAE_test))
cat("\n")

# Plot predicted vs actual for test set
png("validation_pred_vs_actual.png", width=600, height=500)
plot(test_data$Vit_D_conc, pred_test, pch=19, col=rgb(0,0,1,0.5),
     xlab="Valori observate (nmol/L)", ylab="Valori prezise (nmol/L)",
     main="Validare: Valori prezise vs observate (set testare)")
abline(0, 1, col="red", lwd=2, lty=2)
legend("topleft", legend=c(
  sprintf("R2 = %.4f", R2_test),
  sprintf("RMSE = %.4f", RMSE_test)),
  bty="n")
dev.off()
cat("Saved: validation_pred_vs_actual.png\n\n")

# Plot residuals on test set
png("validation_resid_test.png", width=600, height=500)
plot(pred_test, resid_test, pch=19, col=rgb(0,0,1,0.5),
     xlab="Valori prezise (nmol/L)", ylab="Reziduuri",
     main="Reziduuri pe setul de testare")
abline(h=0, col="red", lwd=2, lty=2)
dev.off()
cat("Saved: validation_resid_test.png\n\n")

# =============================================================================
# PARTEA 3: VALIDARE INCRUCISATA (k-fold Cross-Validation)
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 3: VALIDARE INCRUCISATA (k-fold Cross-Validation)\n")
cat("###################################################################\n\n")

k <- 10
cat("k =", k, "folduri\n\n")

set.seed(123)
folds <- sample(rep(1:k, length.out=n))
cat("Distributia observatiilor pe folduri:\n")
print(table(folds))
cat("\n")

cv_R2 <- numeric(k)
cv_RMSE <- numeric(k)
cv_MAE <- numeric(k)

cat("Rezultate pe fiecare fold:\n\n")
cat(sprintf("%-6s %8s %8s %10s %10s %10s\n",
            "Fold", "n_train", "n_test", "R2", "RMSE", "MAE"))

for (i in 1:k) {
  train_cv <- data[folds != i, ]
  test_cv <- data[folds == i, ]

  model_cv <- lm(model_formula, data=train_cv)
  pred_cv <- predict(model_cv, newdata=test_cv)

  resid_cv <- test_cv$Vit_D_conc - pred_cv
  ss_res <- sum(resid_cv^2)
  ss_tot <- sum((test_cv$Vit_D_conc - mean(test_cv$Vit_D_conc))^2)

  cv_R2[i] <- 1 - ss_res/ss_tot
  cv_RMSE[i] <- sqrt(mean(resid_cv^2))
  cv_MAE[i] <- mean(abs(resid_cv))

  cat(sprintf("%-6d %8d %8d %10.4f %10.4f %10.4f\n",
              i, nrow(train_cv), nrow(test_cv), cv_R2[i], cv_RMSE[i], cv_MAE[i]))
}

cat("\n")
cat("METRICI MEDII (Cross-Validation):\n")
cat("  R2 mediu =", sprintf("%.4f", mean(cv_R2)), " (SD =", sprintf("%.4f", sd(cv_R2)), ")\n")
cat("  RMSE mediu =", sprintf("%.4f", mean(cv_RMSE)), " (SD =", sprintf("%.4f", sd(cv_RMSE)), ")\n")
cat("  MAE mediu =", sprintf("%.4f", mean(cv_MAE)), " (SD =", sprintf("%.4f", sd(cv_MAE)), ")\n\n")

# Also do 5-fold CV for comparison
k5 <- 5
set.seed(123)
folds5 <- sample(rep(1:k5, length.out=n))

cv_R2_5 <- numeric(k5)
cv_RMSE_5 <- numeric(k5)
cv_MAE_5 <- numeric(k5)

cat("--- 5-fold Cross-Validation ---\n\n")
cat(sprintf("%-6s %8s %8s %10s %10s %10s\n",
            "Fold", "n_train", "n_test", "R2", "RMSE", "MAE"))

for (i in 1:k5) {
  train_cv5 <- data[folds5 != i, ]
  test_cv5 <- data[folds5 == i, ]

  model_cv5 <- lm(model_formula, data=train_cv5)
  pred_cv5 <- predict(model_cv5, newdata=test_cv5)

  resid_cv5 <- test_cv5$Vit_D_conc - pred_cv5
  ss_res5 <- sum(resid_cv5^2)
  ss_tot5 <- sum((test_cv5$Vit_D_conc - mean(test_cv5$Vit_D_conc))^2)

  cv_R2_5[i] <- 1 - ss_res5/ss_tot5
  cv_RMSE_5[i] <- sqrt(mean(resid_cv5^2))
  cv_MAE_5[i] <- mean(abs(resid_cv5))

  cat(sprintf("%-6d %8d %8d %10.4f %10.4f %10.4f\n",
              i, nrow(train_cv5), nrow(test_cv5), cv_R2_5[i], cv_RMSE_5[i], cv_MAE_5[i]))
}

cat("\n")
cat("METRICI MEDII (5-fold CV):\n")
cat("  R2 mediu =", sprintf("%.4f", mean(cv_R2_5)), " (SD =", sprintf("%.4f", sd(cv_R2_5)), ")\n")
cat("  RMSE mediu =", sprintf("%.4f", mean(cv_RMSE_5)), " (SD =", sprintf("%.4f", sd(cv_RMSE_5)), ")\n")
cat("  MAE mediu =", sprintf("%.4f", mean(cv_MAE_5)), " (SD =", sprintf("%.4f", sd(cv_MAE_5)), ")\n\n")

# Barplot of CV results
png("cv_results_barplot.png", width=700, height=500)
bar_data <- rbind(cv_R2, cv_RMSE)
barplot_r2 <- barplot(cv_R2, names.arg=1:k, col="steelblue",
        main="R2 pe fiecare fold (10-fold CV)",
        xlab="Fold", ylab="R2", ylim=c(min(0, min(cv_R2)-0.05), max(cv_R2)+0.05))
abline(h=mean(cv_R2), col="red", lwd=2, lty=2)
legend("topright", legend=sprintf("Media R2 = %.4f", mean(cv_R2)),
       col="red", lty=2, lwd=2, bty="n")
dev.off()
cat("Saved: cv_results_barplot.png\n\n")

png("cv_rmse_barplot.png", width=700, height=500)
barplot(cv_RMSE, names.arg=1:k, col="coral",
        main="RMSE pe fiecare fold (10-fold CV)",
        xlab="Fold", ylab="RMSE")
abline(h=mean(cv_RMSE), col="blue", lwd=2, lty=2)
legend("topright", legend=sprintf("Media RMSE = %.4f", mean(cv_RMSE)),
       col="blue", lty=2, lwd=2, bty="n")
dev.off()
cat("Saved: cv_rmse_barplot.png\n\n")

# =============================================================================
# PARTEA 4: COMPARATIE GENERALA
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 4: COMPARATIE GENERALA\n")
cat("###################################################################\n\n")

cat("--- Tabelul comparativ al performantelor ---\n\n")
cat(sprintf("%-30s %10s %10s %10s\n", "Metoda", "R2", "RMSE", "MAE"))
cat(sprintf("%-30s %10.4f %10.4f %10s\n", "Model complet (n=212)",
            s_back$r.squared, sqrt(mean(residuals(model_back)^2)), sprintf("%.4f", mean(abs(residuals(model_back))))))
cat(sprintf("%-30s %10.4f %10.4f %10.4f\n", "Train/Test - Train (70%)",
            R2_train, RMSE_train, MAE_train))
cat(sprintf("%-30s %10.4f %10.4f %10.4f\n", "Train/Test - Test (30%)",
            R2_test, RMSE_test, MAE_test))
cat(sprintf("%-30s %10.4f %10.4f %10.4f\n", "10-fold CV (medie)",
            mean(cv_R2), mean(cv_RMSE), mean(cv_MAE)))
cat(sprintf("%-30s %10.4f %10.4f %10.4f\n", "5-fold CV (medie)",
            mean(cv_R2_5), mean(cv_RMSE_5), mean(cv_MAE_5)))
cat("\n")

cat("=== ANALIZA COMPLETA ===\n")
