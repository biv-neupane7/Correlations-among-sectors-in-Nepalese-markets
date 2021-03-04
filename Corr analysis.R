#Changing the column name in our data frames

head(Nepse2)
colnames(Nepse2)<- c("Date","Nepse_Index","Nepse_returns")
colnames(hydro2)[2]<-"Hydro_Index"
head(hydro2)
colnames(finance_comp2)[2]<-"Finance_Index"
head(finance_comp2)
colnames(Comm_banks1)[2]<-"Comm_bank_Index"
head(Comm_banks1)
colnames(Dev_banks1)[2]<-"Dev_bank_Index"
head(Dev_banks1)
library(dplyr)

#Since we have differnet number of rows in our data frames,
# using cbind() is not a good option. Hence, we shall use merge

Nepse2$Nepse_returns<-NULL
micro_finance1$log_returns<-NULL
life_insurance1$log_returns<-NULL
Non_life_insurance1$log_returns<-NULL
others1$log_returns<-NULL

combined_table<-merge.data.frame(Nepse2, 
                      finance_comp2,by="Date", all.x=TRUE)

combined_table1<-left_join(Nepse2,finance_comp2,
                           by="Date")

combined_table2<- left_join(combined_table1, hydro2,
                            by="Date")

combined_table3<- left_join(combined_table2, micro_finance1,
                            by="Date")

combined_table4<-left_join(combined_table3,life_insurance1,
                           by="Date")

combined_table5<-left_join(combined_table4,Comm_banks1,
                           by="Date")
combined_table6<-left_join(combined_table5,Dev_banks1,
                           by="Date")
combined_table7<-left_join(combined_table6,hotel1,
                           by="Date")
combined_table8<-left_join(combined_table7,Non_life_insurance1,
                           by="Date")

combined_table9<-left_join(combined_table8,others1,
                           by="Date")
View(combined_table9)


###################################################

# Calculating the log returns of entire data frame

combined_logs=data.frame(
  cbind.data.frame(combined_table9$Date[-1],
                   diff(as.matrix(log(combined_table9[,-1])))))

View(combined_logs)  

# We have to remove the index column from the merged_file 
# to successfully compute correlation matrix

combined_logs$combined_table9.Date..1.<-NULL
correlation_matrix_Nepal<-cor(combined_logs,use="complete.obs")
View(correlation_matrix_Nepal)

pairs(combined_logs,main="Pairwise corr between sectors")


#Exporting this correlation matrix to .xlsx file

getwd()
setwd("C://Users//user//Desktop")

write.csv(correlation_matrix_Nepal,file="Correlation matrix.csv")
