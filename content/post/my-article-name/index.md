---
# Documentation: https://wowchemy.com/docs/managing-content/

title: "Starter guide for statistical analysis in R"
subtitle: ""
summary: ""
authors: []
tags: []
categories: []
date: 2020-11-29T17:17:48-05:00
lastmod: 2020-11-29T17:17:48-05:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: "Destiny 2"
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []

---
# What is this guide? 
  If you have never coded before, starting to write code in R for your statistical analysis is as daunting as facing an alien spaceship - You know there is so much to learn, but nowhere to start. Don't worry, this is the guide for you. 

  In this guide, I will take you from start to finish --- from obtaining a dataset to finishing your analysis and reporting the results. Of course for now, we will stick to the basic analysis methods to get you started. Once you have the basics covered and know your way around the alien spaceship, it is all yours to explore.  

  As an essential tip for any reader who is struggling with code or reading this article, the first place you would look when you encouter a problem is the original R documentation. Don't worry if you don't know what this is, we will illustrate the importance of this as we go. 

> Pull it up, Jamie -- Joe Rogan

  Now, let's get some data to work with. Feel free to use your own data, and try to change certain variables from this guide to the corresponding variables in your dataset. Feel free to skip the data description part if you have your own data. 
  
# Get our data ready 

  The data used in this guide is a large-sample dataset of the **Rosenberg self-esteem scale (RSE)** obtained from [Open Psychometrics](https://openpsychometrics.org/_rawdata/), published in 2014. If you go ahead and download the .zip file, the details of the questions are logged in codebook.txt. Take a look at the excel file for now, and you will see that the original dataset has 47,974 participants. To not burn my laptop's poor CPU too hard, I have only chosen the first 1000 rows for this assignment. Feel free to use the entire dataset, but you might not get the same numbers as I did. 

  ## Load your data into R and clean it up

```{r}
# load, clean up, and recode the dataset + prepare the relevant libraries
#install.packages("psych")
#install.packages("ggplot2")
library(tidyverse)
library(naniar)
library(psych)
library(ggplot2) 
# read and clean up 
RSE.dat <- read_csv("./data.csv",col_types = cols())
RSE.dat <- replace_with_na_if(data = RSE.dat,
                              .predicate = is.numeric,
                              condition = ~.x == "0")
RSE.dat[1:10] <- RSE.dat[1:10] - 1
# scoring
source("./scoring_rses.R")
RSE.dat <- scoring_rses(RSE.dat, items = 1:10)
# recode
RSE.dat <- mutate(RSE.dat,
                  gender_recode = case_when(gender == 1 ~ "Male",
                                            gender == 2 ~ "Female"))
head(RSE.dat)

#check missing data 

vis_miss(RSE.dat)
#I think we can safely discard missing data
RSE.dat <- na.omit(RSE.dat)
head(RSE.dat)
```