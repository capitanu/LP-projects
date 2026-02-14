# =============================================================================
# Model Selection: Backward Elimination + Interaction Testing
# =============================================================================

library(dplyr)
library(pROC)
library(ResourceSelection)
library(car)
library(broom)

# --- Citire date ---
data <- read.csv("cardiovascular_data.csv", stringsAsFactors = FALSE)

data$heart_disease <- as.factor(data$heart_disease)
data$smoking_status <- as.factor(data$smoking_status)
data$family_history <- as.factor(data$family_history)
data$high_stress <- as.factor(data$high_stress)
data$hypertension <- as.factor(data$hypertension)
data$diabetes <- as.factor(data$diabetes)
data$obesity <- as.factor(data$obesity)

# Dichotomizare LDL la mediană
ldl_median <- median(data$ldl_cholesterol, na.rm = TRUE)
data$ldl_high <- as.factor(ifelse(data$ldl_cholesterol >= ldl_median, 1, 0))

cat("================================================================\n")
cat("PART 1: BACKWARD ELIMINATION (AIC-based)\n")
cat("================================================================\n\n")

# Full model (9 predictors)
full_model <- glm(heart_disease ~ ldl_high + age + family_history +
                    hypertension + diabetes + obesity +
                    systolic_bp + hdl + triglycerides,
                  data = data, family = binomial)

cat("--- Full model (9 predictors) ---\n")
cat("AIC:", AIC(full_model), "\n\n")

# Backward elimination
cat("--- Backward elimination steps ---\n\n")
reduced_model <- step(full_model, direction = "backward", trace = 1)

cat("\n--- Final model after backward elimination ---\n")
summary(reduced_model)

cat("\n--- Odds Ratios ---\n")
tidied_reduced <- tidy(reduced_model, conf.int = TRUE, exponentiate = TRUE)
print(tidied_reduced)

cat("\nAIC full model:   ", AIC(full_model), "\n")
cat("AIC reduced model:", AIC(reduced_model), "\n")

# LRT comparing full vs reduced
cat("\n--- Likelihood Ratio Test: Full vs Reduced ---\n")
lrt <- anova(reduced_model, full_model, test = "Chisq")
print(lrt)

cat("\n================================================================\n")
cat("PART 2: INTERACTION TEST (LDL x family_history)\n")
cat("================================================================\n\n")

# Model with interaction
interaction_model <- glm(
  update(formula(reduced_model), ~ . + ldl_high:family_history),
  data = data, family = binomial
)

cat("--- Model with LDL x family_history interaction ---\n")
summary(interaction_model)

cat("\n--- Odds Ratios ---\n")
tidied_interaction <- tidy(interaction_model, conf.int = TRUE, exponentiate = TRUE)
print(tidied_interaction)

cat("\nAIC without interaction:", AIC(reduced_model), "\n")
cat("AIC with interaction:   ", AIC(interaction_model), "\n")

# LRT for interaction
cat("\n--- Likelihood Ratio Test: Main effects vs Interaction ---\n")
lrt_int <- anova(reduced_model, interaction_model, test = "Chisq")
print(lrt_int)

# Decide final model
if (AIC(interaction_model) < AIC(reduced_model) - 2) {
  final_model <- interaction_model
  cat("\n>>> Interaction model is better (lower AIC by >2). Using interaction model.\n")
  has_interaction <- TRUE
} else {
  final_model <- reduced_model
  cat("\n>>> Interaction not significant or doesn't improve model. Using main effects model.\n")
  has_interaction <- FALSE
}

cat("\n================================================================\n")
cat("PART 3: FINAL MODEL DIAGNOSTICS\n")
cat("================================================================\n\n")

cat("--- Final model summary ---\n")
summary(final_model)

cat("\n--- Final model Odds Ratios ---\n")
tidied_final <- tidy(final_model, conf.int = TRUE, exponentiate = TRUE)
print(tidied_final)

# 1. Hosmer-Lemeshow
cat("\n1. Hosmer-Lemeshow goodness-of-fit test:\n")
hl <- hoslem.test(as.numeric(as.character(data$heart_disease)),
                  fitted(final_model), g = 10)
print(hl)

# 2. VIF
cat("\n2. Multicolinearitate (VIF):\n")
vif_vals <- vif(final_model)
print(vif_vals)

# 3. Box-Tidwell for continuous variables
cat("\n3. Liniaritate în logit (Box-Tidwell):\n")
# Identify continuous predictors in the final model
final_terms <- attr(terms(final_model), "term.labels")
cont_candidates <- intersect(final_terms, c("age", "systolic_bp", "hdl", "triglycerides"))

if (length(cont_candidates) > 0) {
  data_bt <- data
  bt_add <- ""
  for (v in cont_candidates) {
    data_bt[[paste0(v, "_log")]] <- data_bt[[v]] * log(data_bt[[v]])
    bt_add <- paste0(bt_add, " + ", v, "_log")
  }
  bt_formula <- as.formula(paste("heart_disease ~",
    paste(deparse(formula(final_model)[[3]]), collapse = ""),
    bt_add))
  bt_model <- glm(bt_formula, data = data_bt, family = binomial)
  bt_tidy <- tidy(bt_model)
  bt_log <- bt_tidy[grep("_log$", bt_tidy$term), ]
  cat(sprintf("   %-20s   p-value\n", "Variable"))
  for (i in 1:nrow(bt_log)) {
    cat(sprintf("   %-20s   %s\n", bt_log$term[i],
                format.pval(bt_log$p.value[i], digits = 3)))
  }
} else {
  cat("   No continuous variables in final model.\n")
}

# 4. Cook's distance
cat("\n4. Observații influente (Cook's Distance):\n")
cooks_d <- cooks.distance(final_model)
influential <- which(cooks_d > 4 / nrow(data))
cat("   Nr. observații cu Cook's D > 4/n:", length(influential), "\n")

# 5. AUC
cat("\n5. Capacitatea discriminativă:\n")
pred_probs <- predict(final_model, type = "response")
roc_final <- roc(as.numeric(as.character(data$heart_disease)), pred_probs, quiet = TRUE)
auc_final <- auc(roc_final)
ci_final <- ci.auc(roc_final)
cat("   AUC:", sprintf("%.3f", auc_final),
    "(95% CI:", sprintf("%.3f", ci_final[1]), "-", sprintf("%.3f", ci_final[3]), ")\n")

# Compare with full model AUC
pred_full <- predict(full_model, type = "response")
roc_full <- roc(as.numeric(as.character(data$heart_disease)), pred_full, quiet = TRUE)
auc_full <- auc(roc_full)
ci_full <- ci.auc(roc_full)
cat("   AUC full model:", sprintf("%.3f", auc_full),
    "(95% CI:", sprintf("%.3f", ci_full[1]), "-", sprintf("%.3f", ci_full[3]), ")\n")

# DeLong test comparing ROCs
cat("\n   DeLong test (final vs full model ROC):\n")
roc_test <- roc.test(roc_final, roc_full, method = "delong")
print(roc_test)

# 6. Classification table
cat("\n6. Tabel de clasificare (cutoff = 0.5):\n")
pred_class <- ifelse(pred_probs >= 0.5, 1, 0)
conf_matrix <- table(Observed = as.numeric(as.character(data$heart_disease)),
                     Predicted = pred_class)
print(conf_matrix)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
sens <- conf_matrix[2, 2] / sum(conf_matrix[2, ])
spec <- conf_matrix[1, 1] / sum(conf_matrix[1, ])
cat("   Acuratețe:", sprintf("%.1f%%", accuracy * 100), "\n")
cat("   Sensibilitate:", sprintf("%.1f%%", sens * 100), "\n")
cat("   Specificitate:", sprintf("%.1f%%", spec * 100), "\n")

# 7. Nagelkerke R²
cat("\n7. Pseudo R² (Nagelkerke):\n")
null_model <- glm(heart_disease ~ 1, data = data, family = binomial)
ll_null <- logLik(null_model)
ll_final <- logLik(final_model)
n <- nrow(data)
cox_snell <- 1 - exp((2/n) * (as.numeric(ll_null) - as.numeric(ll_final)))
nagelkerke <- cox_snell / (1 - exp((2/n) * as.numeric(ll_null)))
cat("   Cox & Snell R²:", sprintf("%.4f", cox_snell), "\n")
cat("   Nagelkerke R²:", sprintf("%.4f", nagelkerke), "\n")

# Compare with full model
ll_full <- logLik(full_model)
cox_snell_full <- 1 - exp((2/n) * (as.numeric(ll_null) - as.numeric(ll_full)))
nagelkerke_full <- cox_snell_full / (1 - exp((2/n) * as.numeric(ll_null)))
cat("   Nagelkerke R² (full model):", sprintf("%.4f", nagelkerke_full), "\n")

# 8. Diagnostic plots
png("diagnostic_cooks_final.png", width = 800, height = 600, res = 150)
plot(cooks_d, main = "Cook's Distance - Final Model",
     ylab = "Cook's Distance", xlab = "Observation")
abline(h = 4/nrow(data), col = "red", lty = 2)
dev.off()

png("roc_model_final.png", width = 800, height = 700, res = 150)
plot(roc_final,
     main = "ROC Curve - Final Model",
     col = "darkgreen", lwd = 2,
     print.auc = TRUE, print.auc.x = 0.4, print.auc.y = 0.2,
     legacy.axes = TRUE,
     xlab = "1 - Specificity", ylab = "Sensitivity")
dev.off()
cat("\nPlots saved: diagnostic_cooks_final.png, roc_model_final.png\n")

cat("\n================================================================\n")
cat("PART 4: MODEL COMPARISON SUMMARY\n")
cat("================================================================\n\n")

cat(sprintf("%-30s %8s %8s %10s %8s\n", "Model", "AIC", "AUC", "Nagelkerke", "Pred"))
cat(paste(rep("-", 70), collapse = ""), "\n")
cat(sprintf("%-30s %8.1f %8.3f %10.4f %8d\n",
            "Full (9 predictors)", AIC(full_model), auc_full, nagelkerke_full,
            length(coef(full_model)) - 1))
cat(sprintf("%-30s %8.1f %8.3f %10.4f %8d\n",
            "Reduced (backward)", AIC(reduced_model), auc(roc(
              as.numeric(as.character(data$heart_disease)),
              predict(reduced_model, type = "response"), quiet = TRUE)),
            nagelkerke, length(coef(reduced_model)) - 1))
if (has_interaction) {
  auc_int <- auc(roc(as.numeric(as.character(data$heart_disease)),
                     predict(interaction_model, type = "response"), quiet = TRUE))
  ll_int <- logLik(interaction_model)
  cs_int <- 1 - exp((2/n) * (as.numeric(ll_null) - as.numeric(ll_int)))
  nag_int <- cs_int / (1 - exp((2/n) * as.numeric(ll_null)))
  cat(sprintf("%-30s %8.1f %8.3f %10.4f %8d\n",
              "With interaction", AIC(interaction_model), auc_int, nag_int,
              length(coef(interaction_model)) - 1))
}

cat("\n=== MODEL SELECTION COMPLETE ===\n")
