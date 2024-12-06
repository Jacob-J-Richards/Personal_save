## one-sample t-test 
data(trees)
str(trees)
summary(trees)
t.test(trees$Height, mu = 70)
t.test(trees$Height, mu = 70, alternative = "greater")


## Wilcoxon’s signed rank test
wilcox.test(trees$Height, mu = 70)


## Q-Q plot
qqnorm(trees$Height)
qqline(trees$Height, lty = 2)


## Shapiro–Wilks test of normality
shapiro.test(trees$Height)


## two-sample t-test
atmos <- read.table('data/atmosphere.txt', header = TRUE)
str(atmos)
t.test(atmos$moisture ~ atmos$treatment)
t.test(atmos$moisture ~ atmos$treatment, var.equal = TRUE)


## F-test to compare two variances
var.test(atmos$moisture ~ atmos$treatment)


## The non-parametric two-sample Wilcoxon test
wilcox.test(atmos$moisture ~ atmos$treatment)


## paired t-test 
pollution <- read.table('data/pollution.txt', header = TRUE)
str(pollution)
t.test(pollution$down, pollution$up, paired = TRUE)


## non-parametric matched-pairs Wilcoxon test
wilcox.test(pollution$down, pollution$up, paired = TRUE)


## prop.test
buy <- c(45,71)                 # creates a vector of positive outcomes
total <-c((45 + 35), (71 + 32)) # creates a vector of total numbers
prop.test(buy, total)           # perform the test


## Chi-square test
buyers <- matrix(c(45, 35, 71, 32), nrow = 2)
buyers
colnames(buyers) <- c("before", "after")
rownames(buyers) <- c("buy", "notbuy")
buyers
chisq.test(buyers)


