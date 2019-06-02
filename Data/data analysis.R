library(magrittr)
library(tidyverse)
library(colorRamps)
library(dplyr)
library(rvest)


# Read the exploratory data from the csv file 
final_list <- read.csv('movie_dataset.csv',header=TRUE,stringsAsFactors = TRUE)



# Domestic Earnings

# Let's look at the average earnings by year
present3 <- final_list[!is.na(final_list$domestic_gross),]
theater <- summarise(group_by(present3, year), Order.Amount=mean(domestic_gross))
f <- theater[2]$Order.Amount
g <- theater[1]$year
barplot(f,names.arg=g,col=matlab.like(40),main='Average Domestic Earnings by Year',xlab='Year')

# Note how the earnings increase over the years. This is primarily due to inflation causing later years to look higher. 
# We will want to adjust for this in our model. That's why we created the adjusted earnings column. 

# Here's a plot of the adjusted earnings by year:
present3 <- final_list[!is.na(final_list$gross_adj),]
theater <- summarise(group_by(present3, year), Order.Amount=mean(gross_adj))
f <- theater[2]$Order.Amount
g <- theater[1]$year
barplot(f,names.arg=g,col=rainbow(10),main='Adjusted Domestic Earnings by Year',xlab='Year')

# This now looks much better and easier to work with. 

hist(final_list$gross_adj,xaxt = 'n',col=matlab.like(8),xlab='Adjusted Domestic Earnings',main='Domestic Box Office')
axis(1, at=c(0,2e8,4e8,6e8,8e8,1e9),labels=c('$0','$200 mil','$400 mil','$600 mil','$800 mil','$1 billion'))
# Note the right-skewed nature. We're going to have to transform the data. 

# The histogram of the Log transformation looks much better.
hist(log(final_list$gross_adj),col=matlab.like(9),xlab='Log Domestic Earnings',main='Log Transform Domestic Box Office')




# Frequency of Ratings
barplot(table(final_list$rating),col=c('orchid','firebrick','seagreen','cornflowerblue'),
        main='Frequency of Ratings',ylim=c(0,500))
# G-Rated movies don't often make the cut. But when they do, they are lit - e.g. Lion King, Finding Nemo



# Histogram of widest opening
hist(final_list$widest_opening,col=rainbow(9),xlab='Number of Theaters',main='Widest Theater Release')
# Nice normal-ish distribution. Slightly left-skewed. 




# This value is probably largely affected by the year. More theaters open now than in 1982. 
present3 <- final_list[!is.na(final_list$widest_opening),]
theater <- summarise(group_by(present3, year), Order.Amount=mean(widest_opening))
f <- theater[2]$Order.Amount
g <- theater[1]$year
barplot(f,names.arg=g,col=matlab.like(40),main='Average Theater Realeases by Year',xlab='Year')
# Maybe not the best variable because it is increasing linearly each year. 
# It's not as simple to adjust for this variable though. We'll just leave it for simplicity. 




# Histogram of Budget
table(final_list$budget,useNA='ifany') # There are 118 movies out of 251 (47%) without a budget listed
final_list[is.na(final_list$budget),1] # These are mostly older movies and recent Disney movies. Disney doesn't like to share. 


# Here is a histogram of the budgets of movies that do share that information. 
final_list[is.na(final_list$budget),7] <- 5e8
hist(final_list$budget,xaxt='n',col=rainbow(10),xlab='Budget',main='Film Budgets',xlim=c(0,500000000))
axis(1, at=c(0,1e8,2e8,3e8,4e8,5e8),labels=c('$0','$100 mil','$200 mil','$300 mil','$400 mil','N/A'))
# That's unfortunate, but there's not much we can do about it. 

# The budget histogram is very much skewed-right. We might want to adjust for this when using it in the model.
# Let's consider a log transformation to see how it fits. 
hist(log(final_list$budget), col=rainbow(12),xlab='Log of Budget', main = 'Adjusting for Budget Skewness')
# Ignore the pink bar on the right, those are the NA values. 
# This transformed histogram looks much better for our model. We will likely go with this. 



# Seasons
barplot(table(final_list$season), col=c('orange','green','yellow','blue'),ylim=c(0,300),
        main='Films by Season')
# The interesting part about this is that since there are fewer films here from winter, 
#   it indicates that top films released in the winter tend to stay on top longer than those released in other seasons. 


# Here is the average earnings by season, which is obviously highest in the summer. 
hey <- final_list[!is.na(final_list$gross_adj),]
seas <- summarise(group_by(hey, season), Order.Amount=mean(gross_adj))
f <- seas[2]$Order.Amount
g <- seas[1]$season
barplot(f,names.arg=g,col=c('orange','green','yellow','blue'),main="Average Earnings by Season",yaxt='n',ylim=c(0,2.5e8))
axis(2, at=c(0,5e7,1e8,1.5e8,2e8,2.5e8), labels=c('$0','$50 mil','$100 mil','$150 mil','$200 mil','$250 mil'))








################ Model Fitting ##################

# Let's start with a very basic single-predictor model. 
m1 <- glm(log(gross_adj) ~ budget, data=final_list)
summary(m1)
plot(m1)
# It's not very good, but that's not really surprising. 

# If we add in some other factors, it gets a little better!
m2 <- glm(log(gross_adj) ~ budget +  rating + widest_opening, data=final_list)
summary(m2)
plot(m2)


# Let's add in all of the factors that we think will have the most influence
m3 <- glm(log(gross_adj) ~ budget +  rating + season + widest_opening, data=final_list)
summary(m3)
plot(m3)


# Maybe if we adjust for the right-skewed nature of the budget? 
m4 <- glm(log(gross_adj) ~ log(budget) +  rating + season + widest_opening, data=final_list)
summary(m4)
plot(m4)
# This looks great! And it has a lower AIC than the previous model! 
# This is the model that we'll be using for the app.








