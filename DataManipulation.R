# Data Manipulation R code for
# Introduction to R workshop
# Ryan Womack, rwomack@rutgers.edu
# 2018-10-06 version


###################################################
### code chunk number 1: install packages (eval = FALSE)
###################################################
## install.packages("Hmisc", dependencies=TRUE)
## install.packages("reshape", dependencies=TRUE)
## install.packages("reshape2",dependencies=TRUE)
## install.packages("foreign",dependencies=TRUE)
## install.packages("gdata", dependencies=TRUE)
## install.packages("xlsx", dependencies=TRUE)
## install.packages("readxl", dependencies=TRUE)
## install.packages("tidyr", dependencies=TRUE)
## install.packages("lubridate", dependencies=TRUE)
## install.packages("plyr", dependencies=TRUE)
## install.packages("dplyr", dependencies=TRUE)
## update.packages()


###################################################
### code chunk number 2: scan (eval = FALSE)
###################################################
## coffee<-scan(what="numeric")


###################################################
### code chunk number 3: read.table
###################################################
importdata<-read.table("http://ryanwomack.com/data/myfile.txt")


###################################################
### code chunk number 4: read.table parameters (eval = FALSE)
###################################################
importdata2<-read.table("http://ryanwomack.com/data/myfile2.txt", header=TRUE, sep=";",row.names="id", na.strings="..", stringsAsFactors=FALSE)


###################################################
### code chunk number 5: foreign (eval = FALSE)
###################################################
library(foreign)
download.file("http://ryanwomack.com/data/mydata.xpt", "mydata.xpt", mode="wb")
importdata3 <- read.xport ("mydata.xpt")
importdata4 <- read.spss ("http://ryanwomack.com/data/mydata.sav")
detach(package:foreign)


###################################################
### code chunk number 6: Excel files (eval = FALSE)
###################################################
library(gdata)
importdata5 <- read.xls ("http://ryanwomack.com/data/mydata.xlsx", 1)
importdata6 <- read.xls ("http://ryanwomack.com/data/mydata.xls", 1)
detach(package:gdata)

# using xlsx package - 32 bit R easier to get started with
# cannot read from http connection
download.file("http://ryanwomack.com/data/mydata.xls", "mydata.xls", mode='wb')
library(xlsx)
importdata7 <- read.xlsx ("mydata.xls", 1)

# Hadley Wickham's readxl is new, requires no external dependencies on Linux, Mac, Windows
# cannot read from http connection
library(readxl)
importdata8 <- read_excel ("mydata.xls", 1)


###################################################
### code chunk number 7: if then
###################################################
if(mean(importdata$age)>30) "these people are old" else "these people are young"
ifelse((importdata$age)>30, "old", "young")


###################################################
### code chunk number 8: loops
###################################################
i <- 1
repeat {if (i > 10) break else {print(i); i <- i + 1;}}

i<-2
while (i <= 256) {print(i); i <- i *2}

for (i in seq(1:10))
{
sq<-i*i
if(sq>70) next
print(i*i)
}


###################################################
### code chunk number 9: Import Gender Statistics
###################################################
download.file("http://databank.worldbank.org/data/download/Gender_Stats_csv.zip","Gender.zip")
unzip("Gender.zip")
#change name..
genderstats<-read.csv("Gender_StatsData.csv")
head(genderstats)


###################################################
### code chunk number 10: Import Millenium Development Indicators
###################################################
download.file("http://databank.worldbank.org/data/download/MDG_csv.zip","MDG.zip")
unzip("MDG.zip")
#change name...
MDstats<-read.csv("MDGData.csv")

head(MDstats)

#change names - this step is not necessary in the current iteration of the data
library(reshape)
myChanges<-c(ï..Country.Name="Country.Name")
genderstats<-rename(genderstats,myChanges)
MDstats<-rename(MDstats,myChanges)

###################################################
### code chunk number 18: Inspect
###################################################
mode(genderstats)
class(genderstats) 
mode(MDstats)
class(MDstats)


###################################################
### code chunk number 19: Select Rows and Columns
###################################################
tinymatrix<-MDstats[1:10,1:10]
print(tinymatrix)


###################################################
### code chunk number 20: Examine Variable Names
###################################################
names(genderstats)
names(MDstats)


###################################################
### code chunk number 21: Levels
###################################################
table(genderstats$Country.Name)
table(MDstats$Country.Name)
levels(genderstats$Country.Name)
levels(MDstats$Country.Name)


###################################################
### code chunk number 22: Select Countries
###################################################
gscountry<-subset(genderstats, Country.Name=="China" | Country.Name=="India" | Country.Name=="United States")
MDcountry<-subset(MDstats, Country.Name=="China" | Country.Name=="India" | Country.Name=="United States")
table(gscountry$Country.Name)
table(MDcountry$Country.Name)

# dplyr - filter
# filter in dplyr is easy...
# this is a great tutorial
# http://rpubs.com/justmarkham/dplyr-tutorial
# https://github.com/justmarkham/dplyr-tutorial

library(dplyr)
gscountry <- filter(genderstats, Country.Name=="China" | Country.Name=="India" | Country.Name=="United States")
MDcountry<- filter(MDstats, Country.Name %in% c("China", "India", "United States"))


###################################################
### code chunk number 23: Check row.names
###################################################
row.names(genderstats)
row.names(gscountry)
row.names(MDstats)
row.names(MDcountry)


###################################################
### code chunk number 24: Select Variables from MDI
###################################################
myMDI<-subset(MDcountry, Indicator.Name=="Mobile cellular subscriptions (per 100 people)" | Indicator.Name=="Internet users (per 100 people)", select=c(Country.Name,Indicator.Name,X2000:X2008))
myMDI

#dplyr approach with chaining
myMDI <- MDcountry %>%
  filter (Indicator.Name %in% c("Mobile cellular subscriptions (per 100 people)", "Internet users (per 100 people)")) 
myMDI <- myMDI %>%  
  select(Country.Name, Indicator.Name, starts_with("X20"))

# see
# https://www.r-bloggers.com/the-complete-catalog-of-argument-variations-of-select-in-dplyr/

###################################################
### code chunk number 25: Select Variables from Gender
###################################################
mygender<-subset(gscountry, Indicator.Name=="Adolescent fertility rate (births per 1,000 women ages 15-19)" | Indicator.Name=="Fertility rate, total (births per woman)", select=c(Country.Name,Indicator.Name,X2000:X2008))
mygender

#dplyr approach with chaining
mygender <- gscountry %>%
  filter (Indicator.Name %in% c("Adolescent fertility rate (births per 1,000 women ages 15-19)", "Fertility rate, total (births per woman)")) 
mygender <- mygender %>%  
  select(Country.Name, Indicator.Name, starts_with("X20"))

#drop 2016 and 2017 data for compatibility
mygender <- mygender[,1:18]


###################################################
### code chunk number 26: rbind
###################################################
names(mygender)<-c("Country.Name","Indicator.Name","X2000","X2001","X2002","X2003","X2004","X2005","X2006","X2007","X2008","X2009","X2010","X2011","X2012","X2013","X2014","X2015")
names(mygender)
mydata<-rbind(myMDI,mygender)
head(mydata)


###################################################
### code chunk number 28: merge
###################################################
mydata<-merge(mygender,myMDI,all=TRUE)
mydata

# dplyr supports database-style join operations (inner, outer, left, right, full)
# the dplyr equivalent is 

mydata2 <- full_join(mygender,myMDI)

# the tidyr package can also be used for data manipulation operations
# see
# https://rpubs.com/bradleyboehmke/data_wrangling
# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf


###################################################
### code chunk number 35: export formats for mydata
###################################################
write.csv(mydata,"mydata.csv")
library(foreign)
write.foreign(mydata, datafile="mydata.sav", codefile="mydata.sps", package="SPSS")


###################################################
### code chunk number 37: save
###################################################
save.image("mydata.RData")


###################################################
### code chunk number 39: Databases (eval = FALSE)
###################################################
install.packages("RMySQL",dependencies=TRUE) 
install.packages("DBI",dependencies=TRUE) 
library(RMySQL) 
library(DBI) 

# we connect to the publicly available genome server at genome.ucsc.edu
# see that site for documentation of tables and schema

con = dbConnect(MySQL(), host="genome-mysql.cse.ucsc.edu", user="genome", dbname="hg19") 
knownGene = dbReadTable (con, 'knownGene') 
head(knownGene) 
table(knownGene$chrom) 
sort(table(knownGene$chrom), decreasing=TRUE) 

proteins = dbGetQuery(con, "SELECT * FROM knownGene WHERE proteinID='O95872'") 
proteins
proteins[order(proteins$exonEnds, decreasing=TRUE), ]
dbDisconnect(con)

# connecting to databases is easy and transparent in dplyr
# see http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html

# once the connection is made, we can operate on a remote database as if it is loaded in R

my_db <- src_mysql(dbname="hg19", host="genome-mysql.cse.ucsc.edu", user="genome")

my_db %>% tbl("knownGene") %>% head(5)

my_db %>% 
arrange(knownGene, desc(chrom))

knownGenesql<-tbl(my_db, "knownGene")

my_db %>% tbl("knownGene")
  filter(proteinID, c("095872"))
