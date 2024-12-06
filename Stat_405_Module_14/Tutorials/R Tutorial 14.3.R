## Simple linear modelling
smoke <- read.table('data/smoking.txt', header = TRUE, sep = "\t", 
                    stringsAsFactors = TRUE)
str(smoke, vec.len = 2)

library(ggplot2)
ggplot(mapping = aes(x = smoking, y = mortality), data = smoke) +
  geom_point()

smoke_lm <- lm(mortality ~ smoking, data = smoke)
str(smoke_lm)
summary(smoke_lm)
anova(smoke_lm)

smoke_risk_lm <- lm(mortality ~ risk.group, data = smoke)
anova(smoke_risk_lm)
summary(smoke_risk_lm)

ggplot(mapping = aes(x = smoking, y = mortality), data = smoke) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE)

plot(smoke$smoking, smoke$mortality, xlab = "smoking rate", ylab = " mortality rate")
abline(smoke_lm, col = "red")


## check the underlying assumptions of linear model
smoke_res <- resid(smoke_lm)  # residuals
smoke_fit <- fitted(smoke_lm)  # fitted values

# check for equal variances
ggplot(mapping = aes(x = smoke_fit, y = smoke_res)) +
  geom_point() +
  geom_hline(yintercept = 0, colour = "red", linetype = "dashed") 


# check for the normality of residuals
ggplot(mapping = aes(sample = smoke_res)) +
  stat_qq() + 
  stat_qq_line()

qqnorm(smoke_res)
qqline(smoke_res) 

# diagnostic plots
par(mfrow = c(2,2))
plot(smoke_lm)

library(ggfortify)
autoplot(smoke_lm, which = 1:6, ncol = 2, label.size = 3)

smoke_lm2 <- update(smoke_lm, subset = -2)
summary(smoke_lm2)

par(mfrow=c(2,2))
plot(dffits(smoke_lm), type = "l")
plot(rstudent(smoke_lm))
matplot(dfbetas(smoke_lm), type = "l", col = "black")
lines(sqrt(cooks.distance(smoke_lm)), lwd = 2)


