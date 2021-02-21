linear_regression <- lm(pick~pass.tds+int.rate+yards.per.attempt,data=full_data)
summary(linear_regression)
