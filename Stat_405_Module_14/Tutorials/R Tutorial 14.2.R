## Pearson’s product-moment correlation coefficient
data(trees)
str(trees)
cor(trees$Height, trees$Volume)
cor(trees) # matrix of correlation coefficients for all variables
cor(trees, use = "complete.obs")
cor.test(trees$Height, trees$Volume) # test whether the coefficient is significantly different from zero
cor.test(trees$Height, trees$Volume, method = "spearman")
