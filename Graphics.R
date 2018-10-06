# Graphics R code for
# Introduction to R workshop
# Ryan Womack, rwomack@rutgers.edu
# 2018-10-06 version

###################################################
### code chunk number 1: setup (eval = FALSE)
###################################################
## install.packages("lattice",dependencies=TRUE)
## install.packages("ggplot2",dependencies=TRUE)


###################################################
### code chunk number 2: data
###################################################
library(lattice)
library(ggplot2)
data(diamonds)
?diamonds
attach(diamonds)


###################################################
### code chunk number 3: scatterplot
###################################################
plot(price~carat)
plot(x*y*z~carat)
xyplot(price~carat)
xyplot(x*y*z~carat)
qplot(price,carat)
qplot(x*y*z,carat)


###################################################
### code chunk number 4: grouped_scatterplots
###################################################
xyplot(price~carat| clarity)
ggplot(diamonds, aes(carat,price)) + facet_grid(.~clarity) + geom_point()


###################################################
### code chunk number 5: barplot_graphics
###################################################
barplot(table(cut))
barplot(table(clarity))
barplot(table(clarity,cut),beside=TRUE)


###################################################
### code chunk number 6: barchart_lattice
###################################################
barchart(table(cut))
barchart(table(clarity), horizontal=FALSE)
barchart(table(clarity,cut),horizontal=FALSE, stack=FALSE)


###################################################
### code chunk number 7: barchart_using_ggplot
###################################################
ggplot(diamonds, aes(cut) )+ geom_bar(position="stack") 
ggplot(diamonds, aes(clarity) )+ geom_bar(position="stack") 
ggplot(diamonds, aes(clarity)) + facet_grid(.~cut) + geom_bar(position="dodge")


###################################################
### code chunk number 8: groups parameter
###################################################
xyplot(price~carat, groups=cut)
xyplot(price~carat | cut + clarity)
xyplot(price~carat | cut , groups=clarity, auto.key=list(space="right"))


###################################################
### code chunk number 9: store and modify lattice object
###################################################
diamondgraph<-xyplot(price~carat | cut)
update(diamondgraph, aspect="fill", layout=c(1,5))
update(diamondgraph, panel=panel.barchart)
update(diamondgraph, col="tomato") 


###################################################
### code chunk number 10: scatterplot_tweaks
###################################################
plot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
	ylab="price of diamond in dollars", xlim=c(0,3))


###################################################
### code chunk number 11: scatterplot_tweaks_in_lattice
###################################################
xyplot(price~carat, col="steelblue", pch=3, main="Diamond Data", xlab="weight of diamond in carats", 
	ylab="price of diamond in dollars", xlim=c(0,3), scales=list(tick.number=10))


###################################################
### code chunk number 12: scatterplot_tweaks_in_ggplot2
###################################################
ggplot(diamonds, aes(carat,price)) + xlim(0,3) + geom_point(colour="steelblue", pch=3) + 
	labs(x="weight of diamond in carats", y="price of diamond in dollars", title="Diamond Data") 


###################################################
### code chunk number 13: PDF
###################################################
pdf(file="output.pdf")
qplot(price,carat)
barchart(table(clarity,cut),horizontal=FALSE, stack=FALSE)
dev.off()


###################################################
### code chunk number 14: regression_line
###################################################
plot(price~carat)
abline(lm(price~carat), col="red")


###################################################
### code chunk number 15: regression_lattice
###################################################
print(xyplot(price~carat, type=c("p","r")))


###################################################
### code chunk number 16: regression_ggplot2
###################################################
print(ggplot(diamonds, aes(carat, price)) + geom_point() + geom_smooth(method=lm))


###################################################
### code chunk number 17: map3
###################################################
library("latticeExtra")
library("mapproj")
data(USCancerRates)
rng <- with(USCancerRates, range(rate.male, rate.female, finite = TRUE)) 
nbreaks <- 50 
breaks <- exp(do.breaks(log(rng), nbreaks)) 
mapplot(rownames(USCancerRates) ~ rate.male + rate.female, data = USCancerRates, breaks = breaks, map = map("county", plot = FALSE, fill = TRUE, projection = "tetra"), scales = list(draw = FALSE), xlab = "", main = "Average yearly deaths due to cancer per 100000") 


