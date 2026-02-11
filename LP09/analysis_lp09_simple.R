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
cat("=== Structura datelor ===\n")
str(data)
cat("n =", n, "\n\n")

# =============================================================================
# PARTEA 1: ANALIZA DESCRIPTIVA SI SELECTIA MODELULUI
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 1: ANALIZA DESCRIPTIVA SI SELECTIA MODELULUI\n")
cat("###################################################################\n\n")

cat("===========================================================================\n")
cat("1. STATISTICI DESCRIPTIVE\n")
cat("===========================================================================\n\n")

vi_names <- c("Varsta_ani", "Ani_menopauza", "IMC", "PCG", "CA")
all_vars <- c("Vit_D_conc", vi_names)

for (v in all_vars) {
  x <- data[[v]]
  cat(sprintf("--- %s ---\n", v))
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

# Boxplots
png("boxplots_all.png", width=900, height=600)
par(mfrow=c(2,3))
for (v in all_vars) {
  boxplot(data[[v]], main=v, col="lightblue")
}
dev.off()
cat("Salvat: boxplots_all.png\n\n")

# Scatter plots
png("scatter_plots.png", width=900, height=600)
par(mfrow=c(2,3))
for (v in vi_names) {
  plot(data[[v]], data$Vit_D_conc, pch=19, col=rgb(0,0,1,0.4),
       xlab=v, ylab="Vit D (nmol/L)", main=paste("Vit D vs", v))
  abline(lm(data$Vit_D_conc ~ data[[v]]), col="red", lwd=2)
}
dev.off()
cat("Salvat: scatter_plots.png\n\n")

# Correlation matrix
cat("===========================================================================\n")
cat("2. MATRICEA DE CORELATIE\n")
cat("===========================================================================\n\n")

cor_mat <- cor(data)
print(round(cor_mat, 4))
cat("\n")

cat("Corelatii semnificative cu Vit_D_conc:\n\n")
for (v in vi_names) {
  ct <- cor.test(data[[v]], data$Vit_D_conc)
  sig <- ifelse(ct$p.value < 0.05, "Da", "Nu")
  cat(sprintf("  %-15s r=%.4f  t=%.4f  df=%d  p=%s  Semnif: %s\n",
              v, ct$estimate, ct$statistic, ct$parameter,
              format.pval(ct$p.value, digits=4), sig))
}
cat("\n")

# Variable selection - Backward
cat("===========================================================================\n")
cat("3. SELECTIA VARIABILELOR (Backward)\n")
cat("===========================================================================\n\n")

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
cat("===========================================================================\n")
cat("4. SELECTIA VARIABILELOR (Forward)\n")
cat("===========================================================================\n\n")

model_null <- lm(Vit_D_conc ~ 1, data=data)
model_fwd <- stepAIC(model_null, scope=list(lower=model_null, upper=model_full),
                     direction="forward", trace=1)
cat("\nModel final Forward:\n")
s_fwd <- summary(model_fwd)
print(s_fwd)
cat("\n")

# Stepwise selection
cat("===========================================================================\n")
cat("5. SELECTIA VARIABILELOR (Stepwise)\n")
cat("===========================================================================\n\n")

model_step <- stepAIC(model_null, scope=list(lower=model_null, upper=model_full),
                      direction="both", trace=1)
cat("\nModel final Stepwise:\n")
s_step <- summary(model_step)
print(s_step)
cat("\n")

# Use the selected model for validation
cat("MODELUL SELECTAT PENTRU VALIDARE:\n")
cat("Formula:", deparse(formula(model_back)), "\n")
cat("R² =", sprintf("%.4f", s_back$r.squared), "\n")
cat("R² ajustat =", sprintf("%.4f", s_back$adj.r.squared), "\n\n")

ci_sel <- confint(model_back)
cat("95% IC:\n")
print(ci_sel)
cat("\n")

# Diagnostics on the full data model
cat("===========================================================================\n")
cat("6. DIAGNOSTICE MODEL SELECTAT (pe date complete)\n")
cat("===========================================================================\n\n")

resid_sel <- residuals(model_back)
sw <- shapiro.test(resid_sel)
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

cook_sel <- cooks.distance(model_back)
cat("Cook's D > 4/n:", sum(cook_sel > 4/n), "observatii\n")
cat("Cook's D maxim:", sprintf("%.4f", max(cook_sel)), "\n")

if (length(coef(model_back)) > 2) {
  cat("\nVIF:\n")
  print(vif(model_back))
}
cat("\n")

# Diagnostic plots
png("diag_4panel.png", width=900, height=800, res=150)
par(mfrow=c(2,2))
plot(model_back)
dev.off()
cat("Salvat: diag_4panel.png\n\n")

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

cat("Set antrenare (train): n =", nrow(train_data), "\n")
cat("Set testare (test):    n =", nrow(test_data), "\n\n")

# Train the selected model
model_formula <- formula(model_back)
model_train <- lm(model_formula, data=train_data)
s_train <- summary(model_train)
cat("MODEL PE SETUL DE ANTRENARE:\n\n")
print(s_train)
cat("\n")

ci_train <- confint(model_train)
cat("95% IC (antrenare):\n")
print(ci_train)
cat("\n")

# Performance on training set
pred_train <- predict(model_train, newdata=train_data)
resid_train <- train_data$Vit_D_conc - pred_train
SS_res_train <- sum(resid_train^2)
SS_tot_train <- sum((train_data$Vit_D_conc - mean(train_data$Vit_D_conc))^2)
R2_train <- 1 - SS_res_train/SS_tot_train
p_model <- length(coef(model_train)) - 1
n_train <- nrow(train_data)
R2_adj_train <- 1 - (1-R2_train)*(n_train-1)/(n_train-p_model-1)
RMSE_train <- sqrt(mean(resid_train^2))
MAE_train <- mean(abs(resid_train))

cat("PERFORMANTA PE SETUL DE ANTRENARE:\n")
cat("  R² =", sprintf("%.4f", R2_train), "\n")
cat("  R² ajustat =", sprintf("%.4f", R2_adj_train), "\n")
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
cat("  R² =", sprintf("%.4f", R2_test), "\n")
cat("  R² ajustat =", sprintf("%.4f", R2_adj_test), "\n")
cat("  RMSE =", sprintf("%.4f", RMSE_test), "\n")
cat("  MAE =", sprintf("%.4f", MAE_test), "\n\n")

# Plot predicted vs actual for test set
png("validation_pred_vs_actual.png", width=600, height=500)
plot(test_data$Vit_D_conc, pred_test, pch=19, col=rgb(0,0,1,0.5),
     xlab="Valori observate (nmol/L)", ylab="Valori prezise (nmol/L)",
     main="Validare: Valori prezise vs observate (set testare)")
abline(0, 1, col="red", lwd=2, lty=2)
legend("topleft", legend=c(
  sprintf("R² = %.4f", R2_test),
  sprintf("RMSE = %.4f", RMSE_test)),
  bty="n")
dev.off()
cat("Salvat: validation_pred_vs_actual.png\n\n")

png("validation_resid_test.png", width=600, height=500)
plot(pred_test, resid_test, pch=19, col=rgb(0,0,1,0.5),
     xlab="Valori prezise (nmol/L)", ylab="Reziduuri",
     main="Reziduuri pe setul de testare")
abline(h=0, col="red", lwd=2, lty=2)
dev.off()
cat("Salvat: validation_resid_test.png\n\n")

# =============================================================================
# PARTEA 3: VALIDARE INCRUCISATA (k-fold Cross-Validation)
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 3: VALIDARE INCRUCISATA (k-fold Cross-Validation)\n")
cat("###################################################################\n\n")

# 10-fold CV
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
  cat(sprintf("  Fold %2d: R²=%.4f  RMSE=%.4f  MAE=%.4f\n",
              i, cv_R2[i], cv_RMSE[i], cv_MAE[i]))
}

cat("\nMETRICI MEDII (10-fold CV):\n")
cat("  R² mediu =", sprintf("%.4f", mean(cv_R2)), " (SD =", sprintf("%.4f", sd(cv_R2)), ")\n")
cat("  RMSE mediu =", sprintf("%.4f", mean(cv_RMSE)), " (SD =", sprintf("%.4f", sd(cv_RMSE)), ")\n")
cat("  MAE mediu =", sprintf("%.4f", mean(cv_MAE)), " (SD =", sprintf("%.4f", sd(cv_MAE)), ")\n\n")

# 5-fold CV
k5 <- 5
set.seed(123)
folds5 <- sample(rep(1:k5, length.out=n))

cv_R2_5 <- numeric(k5)
cv_RMSE_5 <- numeric(k5)
cv_MAE_5 <- numeric(k5)

cat("--- 5-fold Cross-Validation ---\n\n")
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
  cat(sprintf("  Fold %d: R²=%.4f  RMSE=%.4f  MAE=%.4f\n",
              i, cv_R2_5[i], cv_RMSE_5[i], cv_MAE_5[i]))
}

cat("\nMETRICI MEDII (5-fold CV):\n")
cat("  R² mediu =", sprintf("%.4f", mean(cv_R2_5)), " (SD =", sprintf("%.4f", sd(cv_R2_5)), ")\n")
cat("  RMSE mediu =", sprintf("%.4f", mean(cv_RMSE_5)), " (SD =", sprintf("%.4f", sd(cv_RMSE_5)), ")\n")
cat("  MAE mediu =", sprintf("%.4f", mean(cv_MAE_5)), " (SD =", sprintf("%.4f", sd(cv_MAE_5)), ")\n\n")

# CV barplots
png("cv_results_barplot.png", width=700, height=500)
barplot(cv_R2, names.arg=1:k, col="steelblue",
        main="R² pe fiecare fold (10-fold CV)",
        xlab="Fold", ylab="R²", ylim=c(min(0, min(cv_R2)-0.05), max(cv_R2)+0.05))
abline(h=mean(cv_R2), col="red", lwd=2, lty=2)
legend("topright", legend=sprintf("Media R² = %.4f", mean(cv_R2)),
       col="red", lty=2, lwd=2, bty="n")
dev.off()
cat("Salvat: cv_results_barplot.png\n")

png("cv_rmse_barplot.png", width=700, height=500)
barplot(cv_RMSE, names.arg=1:k, col="coral",
        main="RMSE pe fiecare fold (10-fold CV)",
        xlab="Fold", ylab="RMSE")
abline(h=mean(cv_RMSE), col="blue", lwd=2, lty=2)
legend("topright", legend=sprintf("Media RMSE = %.4f", mean(cv_RMSE)),
       col="blue", lty=2, lwd=2, bty="n")
dev.off()
cat("Salvat: cv_rmse_barplot.png\n\n")

# =============================================================================
# PARTEA 4: COMPARATIE GENERALA
# =============================================================================
cat("###################################################################\n")
cat("# PARTEA 4: COMPARATIE GENERALA\n")
cat("###################################################################\n\n")

cat("Model complet (n=212):\n")
cat("  R² =", sprintf("%.4f", s_back$r.squared), "\n")
cat("  RMSE =", sprintf("%.4f", sqrt(mean(residuals(model_back)^2))), "\n")
cat("  MAE =", sprintf("%.4f", mean(abs(residuals(model_back)))), "\n\n")

cat("Train/Test - Train (70%):\n")
cat("  R² =", sprintf("%.4f", R2_train), "\n")
cat("  RMSE =", sprintf("%.4f", RMSE_train), "\n")
cat("  MAE =", sprintf("%.4f", MAE_train), "\n\n")

cat("Train/Test - Test (30%):\n")
cat("  R² =", sprintf("%.4f", R2_test), "\n")
cat("  RMSE =", sprintf("%.4f", RMSE_test), "\n")
cat("  MAE =", sprintf("%.4f", MAE_test), "\n\n")

cat("10-fold CV (medie):\n")
cat("  R² =", sprintf("%.4f", mean(cv_R2)), "\n")
cat("  RMSE =", sprintf("%.4f", mean(cv_RMSE)), "\n")
cat("  MAE =", sprintf("%.4f", mean(cv_MAE)), "\n\n")

cat("5-fold CV (medie):\n")
cat("  R² =", sprintf("%.4f", mean(cv_R2_5)), "\n")
cat("  RMSE =", sprintf("%.4f", mean(cv_RMSE_5)), "\n")
cat("  MAE =", sprintf("%.4f", mean(cv_MAE_5)), "\n\n")

cat("=== ANALIZA COMPLETA ===\n")
