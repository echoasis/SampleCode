##### prep purchase data
#get datediff 
a<-purchase_df$next_purchase-purchase_df$previous_purchase
head(a)
class(a)
a<-as.integer(a)
head(a)
summary(a) #3rd Qu: 139
length(which(a>133))

length(a[-which(is.na(a))])/length(a) # 41% of all buyers made a purchse after the cutoff period 
length(which(a>150))/length(a[-which(is.na(a))])  #20% of repeat buyers made purchase >5 months after the cutoff period

(length(which(a>150))+length(a[which(is.na(a))]))/length(a) #66.7% will be considered as churn

#add datediff between previous and next purchase into purchase_df
purchase_df$datediff=a
purchase_df$datediff=as.integer(purchase_df$datediff)
head(purchase_df[which(purchase_df$datediff>150), ])

####################
#define Churn to be:
# 1.datediff is NA, meaning no next purchase in the observation period
# 2. datediff > 150 

purchase_df$churn=(purchase_df$datediff>150|is.na(purchase_df$datediff))*1

round(prop.table((table(purchase_df$churn))),3) # 66.7% are churn, 33.3% are retained

####################

data1<-purchase_df

#first remove the columns we no longer need
data1<-data1[,-c(5,13,14)]

#turn certain features into binary
data1$total_discount=-data1$total_discount
min(data1$total_discount)
data1$total_discount=(data1$total_discount>0)*1

min(data1$num_figures)
length(data1$num_figures[which(data1$num_figures<0)])
data1[which(data1$num_figures<0),]
# treat negative purchase to be 0
data1$num_figures[which(data1$num_figures<0)]=0
data1$spend_figures[which(data1$spend_figures<0)]=0
data1$num_figures=(data1$num_figures>0)*1


min(data1$num_shirts)
data1[which(data1$num_shirts<0),]
data1$num_shirts=(data1$num_shirts>0)*1

data1[which(data1$spend_ah<0),]
data1$spend_ah=(data1$spend_ah>0)*1

data1[which(data1$spend_figures<0),]
data1$spend_figures=(data1$spend_figures>0)*1

data1[which(data1$spend_gr<0),]
data1$spend_gr=(data1$spend_gr>0)*1

data1[which(data1$spend_rwby<0),]
data1$spend_rwby=(data1$spend_rwby>0)*1

data1[which(data1$spend_shirts<0),]
data1$spend_shirts=(data1$spend_shirts>0)*1


#scale numerical features
data1$total_orders=data1$total_orders/sd(data1$total_orders)
data1$total_spend=data1$total_spend/sd(data1$total_spend)

##### end of preping purchase data

##### prep view data
data2<-view_df

min(data2$mins_rt_chan) # has 0's
min(data2$mins_ah_chan) # has 0's

# This round will only use series level data
data2=data2[,-c(2:6)]

# turn certain features into binary
for (i in 2:12){
  data2[,i]=(data2[,i]>0)*1
  
}
remove(i)
# scale numerical features
min(data2$mins_per_mth)
min(data2$num_series)
data2$num_series=as.integer(data2$num_series)

data2$mins_per_mth=data2$mins_per_mth/sd(data2$mins_per_mth)
data2$num_series=data2$num_series/sd(data2$num_series)

##### end of preping view data

### combine (left join on purchase data)
data=merge(data1,data2, by.x="customer_email", by.y="email", all.x=TRUE)
data=data[,-1]
round(prop.table((table(data$churn))),3)

# replace all NA's with 0
for(i in 12:24){
 data[,i][which(is.na( data[,i]))]=0
}

#check if NA's are gone
for(i in 12:24){
  print(length(data[,i][which(is.na( data[,i]))]))
}

# turns out that there's only 0's in gen_lock & harcore tabletop, remove them
data=data[, -c(17,18)]


cor_data<-cor(data)


library(corrplot)
corrplot(cor_data,type="upper")

#remove high-correlated 
data=data[, -c(4,5)]

cor(data$churn, data$total_orders)



#########################
# 1. logistic regression
#piecewise logit has shown that total_orders & total_spend are causing 'perfect separation'
#remove these two for logistic model

data_log=data[,-c(1,2)]
set.seed(12345)

#data_log=data

# five-fold cross-validation index
u.five.fold=list()
temp=NULL
for(i in 1:4)
{
  
  u.five.fold[[i]]=sample(setdiff(1:nrow(data),temp),
                          size = nrow(data)/5 ,replace = F)
  temp=c(temp,u.five.fold[[i]])
  
}
u.five.fold[[5]]=setdiff(1:nrow(data),temp)



# start here 
AUC.five.fold=NULL
for(i in 1:5)
{
  train.data=data_log[-u.five.fold[[i]],]
  test.data=data_log[u.five.fold[[i]],]
  
  
  glm.fit=glm(churn~.,data = train.data,family = "binomial" )
  
  
  #glm.fit2=bayesglm(churn~., data = train.data, family = "binomial" )
  
  
  summary(glm.fit)
  names(glm.fit)
  summary(glm.fit$fitted.values)
  
  
  
  glm.pred=predict.glm(glm.fit,newdata = test.data)
  glm.pred=exp(glm.pred)/(exp(glm.pred)+1) #turn into probabilities
  summary(glm.pred)
  
  
  true.positive=NULL
  true.negative=NULL
  start=0
  for(r in seq(0,1,length=2000))
  {
    start=start+1
    temp0=which(test.data[,7]==1)
    temp1=which(glm.pred>r)
    true.positive[start]=1-length(setdiff(temp0,temp1))/length(temp0)
    temp0=which(test.data[,7]==0)
    temp1=which(glm.pred<r)
    true.negative[start]=1-length(setdiff(temp0,temp1))/length(temp0)
    
  }
  
  
  plot(1-true.negative,true.positive)
  
  
  library(pracma)
  AUC1 = abs(trapz(1-true.negative,true.positive))
  AUC.five.fold[i]=AUC1
  print(AUC1)
}

mean(AUC.five.fold) #71% accuracy


########################
# 2. Random Forest Exploring Process
library(randomForest)

set.seed(12345)
u=sample(x = 1:nrow(data),size=.2*nrow(data),replace = F)
train.data=data[-u,]
test.data=data[u,]
train.data$churn=as.factor(train.data$churn)
test.data$churn=as.factor(test.data$churn)


model.rf=randomForest(as.formula("churn~."), 
                                              data = train.data, importance=TRUE
                                        )
model.rf

plot(model.rf$err.rate[,1], type='l') ## OOB error plot


model.rf2=randomForest(as.formula("churn~."), 
                       data = train.data, mtry=10,importance=TRUE
)
model.rf2 #worse

# Predicting on train set
predTrain <- predict(model.rf, train.data, type = "class")
table(predTrain, train.data$churn)

# Prediction on test set
predValid <- predict(model.rf, test.data, type = "class")
mean(predValid == test.data$churn)  # accuracy 77.7%
table(predValid,test.data$churn)

importance(model.rf)
varImpPlot(model.rf)


# which mtry
a=c()
i=5
for (i in 4:12) {
  model.rf3 <- randomForest(as.formula("churn~."), data = train.data, ntree = 500, mtry = i, importance = TRUE)
  predValid <- predict(model.rf3, test.data, type = "class")
  a[i-2] = mean(predValid == test.data$churn)
}

a



###to get the probabilities of 'churn' and use AUC for accuracy### (pure exploring process)
rf.pred=predict(model.rf,newdata = test.data, type="prob")

rf.pred.churn=rf.pred[,2]

true.positive=NULL
true.negative=NULL
start=0
for(r in seq(0,0.999,length=2000))
{
  start=start+1
  temp0=which(test.data[,7]==1)
  temp1=which(rf.pred.churn>r)
  true.positive[start]=1-length(setdiff(temp0,temp1))/length(temp0)
  temp0=which(test.data[,7]==0)
  temp1=which(rf.pred.churn<r)
  true.negative[start]=1-length(setdiff(temp0,temp1))/length(temp0)
  
}


plot(1-true.negative,true.positive)
AUC1 = abs(trapz(1-true.negative,true.positive))
AUC1 
