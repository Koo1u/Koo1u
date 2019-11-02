library(tidyverse)
library(readxl)
library("sqldf")
library(RSQLite)
library(DBI)

contrib_all <- read_xlsx("Top MA Donors 2016-2020 - Copy.xlsx",
                         sheet = "Direct_Contributions_+_JFC Dist")
JFC <- read_xlsx("Top MA Donors 2016-2020 - Copy.xlsx",
                 sheet = "JFC_Contributions")

## Code from Kerui_Cao
contrib_all['contrib'] = gsub(contrib_all$contrib,pattern = ", ",replacement = ",")
contrib_all['contrib'] = gsub(contrib_all$contrib,pattern = "\\s\\w*",replacement = "")


contribution <- select(contrib_all,cycle,contribid,fam,date,amount,recipid,type,fectransid,cmteid) %>% distinct()
contributor <- select(contrib_all,contribid,fam,contrib,City,State,Zip,Fecoccemp,orgname,lastname) %>% distinct()
recipient <- select(contrib_all,recipid,recipient,party,recipcode) %>% distinct()
organization <- select(contrib_all,orgname,ultorg) %>% distinct() %>% na.omit()

con <- dbConnect(SQLite(),"Shangchen@@Han.sqlite")
dbWriteTable(con,"contribution",contribution)
dbWriteTable(con,"contributor",contributor)
dbWriteTable(con,"recipient",recipient)
dbWriteTable(con,"organization",organization)

