#turn categorical variables to numeric factors
data<-data1

data$channel_name<-unclass(data$channel_name)
data$channel_name<-as.factor(data$channel_name)

data$category<-unclass(data$category)
data$category<-as.factor(data$category)
levels(data$category)

data$end_screen_element_type<-unclass(data$end_screen_element_type)
data$end_screen_element_type<-as.factor(data$end_screen_element_type)
levels(data$end_screen_element_type)


summary(data$ctr)
#which data points have >1 CTR
c<-which(data$ctr>1)
data<-data[-c,]
remove(c)

#the numerical variables
hist(data$length)
hist(data$view_count)
hist(data$comment_count)
hist(data$impressions)
hist(data$clicks)
hist(data$ctr)

#scaling numerical data (impressions & clicks are not scaled due to that in GLM they will be the outcome variables)
#(but for other models they should be scaled)
data$length=data$length/sd(data$length)
data$view_count=data$view_count/sd(data$view_count)
data$comment_count=data$comment_count/sd(data$comment_count)
#data$impressions=data$impressions/sd(data$impressions)
#data$clicks=data$clicks/sd(data$clicks)
#data$ctr=data$ctr/sd(data$ctr)


#############################
#1. GLM
data_glm=data[,-c(1,10)]

set.seed(12345)
u=sample(x = 1:nrow(data_glm),size=.2*nrow(data_glm),replace = F)
train.glm=data_glm[-u,]
test.glm=data_glm[u,]

glm.fit=glm(cbind(clicks,impressions-clicks)~.,data = train.glm,family=binomial(logit) )

summary(glm.fit)
names(glm.fit)
summary(glm.fit$fitted.values)

library(rsq)
rsq(glm.fit, data=train.glm) #46.87% R^2

glm.pred=predict.glm(glm.fit,newdata = test.glm)
glm.pred=exp(glm.pred)/(exp(glm.pred)+1) #turn into probabilities
summary(glm.pred)
#this probability is the prob of an impression turning into a click

test.glm2<-test.glm
test.glm2$ctr<-test.glm$clicks/test.glm$impressions #add our actual ctr back to the test set
RMSE.glm <- sqrt(mean((glm.pred-test.glm2$ctr)^2)) #0.0286
MAE.glm <- mean(abs(glm.pred-test.glm2$ctr)) #0.0124

plot(test.glm2$ctr,glm.pred)
abline(a=0,b=1,col="red")

cor(test.glm2$ctr,glm.pred) # 26.2% 

########################
#2. decision tree
names(data)

data_tree=data
data_tree=data_tree[, -c(1,9)]
data_tree$impressions=data_tree$impressions/sd(data_tree$impressions)

set.seed(12345)
u=sample(x = 1:nrow(data_tree),size=.2*nrow(data_tree),replace = F)
train.tree=data_tree[-u,]
test.tree=data_tree[u,]

library(rpart)
library(rattle)

#default decision tree
tree1<-rpart(ctr~., data=train.tree)
pred.tree<-predict(tree1, test.tree)

summary(pred.tree) #all predicted values are within bound [0,1]

RMSE.tree<-sqrt(mean((pred.tree-test.tree$ctr)^2)) #0.0278
MAE.tree <- mean(abs(pred.tree-test.tree$ctr)) #0.0101

#plot(test.tree$ctr,pred.tree)
#abline(a=0,b=1,col="red")

#show me the tree
rattle::fancyRpartPlot(tree1)
#show me the details of the model
printcp(tree1)

#visualization
X=seq(from=1, to=nrow(test.tree), by=1)
tree_out<-data.frame(Y=test.tree$ctr, Y_hat=pred.tree)
tree_out<-tree_out[order(tree_out$Y),]

plot(X,tree_out$Y)
lines(tree_out$Y_hat, col="red")


##################
#3. random forest
library(randomForest)

set.seed(12345)
#use the same train and test data from decision trees

model.rf=randomForest(as.formula("ctr~."), 
                      data = train.tree, importance=TRUE
)

model.rf #super LOW %var explained (R^2), sqrt(MSE) with ntree=500 is 0.03 
plot(model.rf)
#seems that ntree=300 is enough

pred.rf<-predict(model.rf,test.tree)
summary(pred.rf)
RMSE.rf <- sqrt(mean((pred.rf-test.tree$ctr)^2)) #0.0263
MAE.rf<- mean(abs(pred.rf-test.tree$ctr)) #0.0079

plot(test.tree$ctr,pred.rf)
abline(a=0,b=1,col="red")

varImpPlot(model.rf)

cor(test.tree$ctr,pred.rf) #42.2% 

#remove 18 rows in data that has ctr=1
#what other features can we include? (obviously these features don't explain much of the variance)

#################################################################################################################
data2=data

#remove ctr=1
data2=data2[-which(data2$ctr==1),]

#turn end_screen_type & channel_name into binary
#this round not going to turn category into binary 

#channel_name
chan<-matrix(NA,nrow(data2),5)
start=0
for(i in 1:5){
  start=start+1
  chan[,start]=(data2$channel_name==i)*1
}
chan=as.data.frame(chan)
for (i in 1:5){
names(chan)[i]=paste("chan",i,sep="")}

#end_screen_trype
screen_type<-matrix(NA,nrow(data2),9)
start=0
for(i in 1:9){
  start=start+1
  screen_type[,start]=(data2$end_screen_element_type==i)*1
}
screen_type=as.data.frame(screen_type)
for (i in 1:9){
  names(screen_type)[i]=paste("screen_type",i,sep="")}

names(data2)
data2<-data2[,c("ctr","length", "view_count","comment_count", "impressions","category")]
data2<-cbind(data2,chan)
data2<-cbind(data2,screen_type)

####
##### Next
####### Create more features

#relationsips between binary variables
data3=matrix(NA,nrow(data2),
             ((ncol(data2)-6)*(ncol(data2)-7)/2)*4)

start=0
for(i in 8:ncol(data2))
{
  for(j in 7:(i-1))
  {
    start=start+1
    data3[,start]=(data2[,i]==1)*(data2[,j]==1)
    
    start=start+1
    data3[,start]=(data2[,i]==1)*(data2[,j]==0)
    
    start=start+1
    data3[,start]=(data2[,i]==0)*(data2[,j]==1)
    
    start=start+1
    data3[,start]=(data2[,i]==0)*(data2[,j]==0)
  }
}

# numerical variables
data4=matrix(NA,nrow(data2),(4)*4)
start=0
i=2
for(i in 2:5)
{
  start=start+1
  data4[,start]=1/(data2[,i]+10^-6) 
  data4[,start]=data4[,start]/sd(data4[,start])
  
  start=start+1
  data4[,start]=1/(data2[,i]+10^-6)^2
  data4[,start]=data4[,start]/sd(data4[,start])
  
  
  start=start+1
  data4[,start]=sqrt(data2[,i]+0)
  data4[,start]=data4[,start]/sd(data4[,start])
 
  
  start=start+1
  data4[,start]=data2[,i]^2
  data4[,start]=data4[,start]/sd(data4[,start])
 
  
}


data4<-as.data.frame(data4)
for (i in 1:16){
  names(data4)[i]=paste("V",i,sep="")}


#combine data2 and data4
data2<-cbind(data2,data4)


######################
#random forest


#split into train, test, validation
spec = c(train = .6, test = .2, validate = .2)

g = sample(cut(
  seq(nrow(data2)), 
  nrow(data2)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(data2, g)

train.rf=res$train
val.rf=res$validate
test.rf=res$test


set.seed(12345)
model.rf2=randomForest(as.formula("ctr~."), 
                      data = train.rf, importance=TRUE, ntree=200
)


model.rf2 #slightly higher % of var explained by model (19%)
plot(model.rf2) # seems 200 trees are enough
summary(model.rf2$predicted)

pred.rf2<-predict(model.rf2,val.rf)
summary(pred.rf2)
RMSE.rf2 <- sqrt(mean((pred.rf2-val.rf$ctr)^2)) #0.0219
MAE.rf2<- mean(abs(pred.rf2-val.rf$ctr)) #0.0076

plot(val.rf$ctr,pred.rf2)
abline(a=0,b=1,col="red")

ccc

cor(val.rf$ctr,pred.rf2) #47.6% 


####Next:
####What other features can we pull and include? 
####remove data points w/ low impressions 
####generate more features based on what we have similarly as above
####tune hyper parameters to get better reults (current models are all default setting)


##### remove data points w/ low impressions
data2.1=data2[-which(data2$impressions<=2),]
data2.2=data2[-which(data2$impressions<=5),]

# data2.1
g = sample(cut(
  seq(nrow(data2.1)), 
  nrow(data2.1)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(data2.1, g)

train.rf2=res$train
val.rf2=res$validate
test.rf2=res$test


set.seed(12345)
model.rf2.1=randomForest(as.formula("ctr~."), 
                       data = train.rf2, importance=TRUE
)


model.rf2.1 #slightly higher % of var explained by model (25.6% with 500 trees, 25% with 200 trees), slightly lower MSE at tree=200 
plot(model.rf2.1) # seems 200 trees are enough
summary(model.rf2.1$predicted)

pred.rf2.1<-predict(model.rf2.1,val.rf2)
summary(pred.rf2.1)
RMSE.rf2.1 <- sqrt(mean((pred.rf2.1-val.rf2$ctr)^2)) #0.0208
MAE.rf2.1<- mean(abs(pred.rf2.1-val.rf2$ctr)) #0.0078 this is bigger than before! 

plot(val.rf2$ctr,pred.rf2.1)
abline(a=0,b=1,col="red")
cor(val.rf2$ctr,pred.rf2.1) #52.2%


# data2.2
g = sample(cut(
  seq(nrow(data2.2)), 
  nrow(data2.2)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(data2.2, g)

train.rf2.2=res$train
val.rf2.2=res$validate
test.rf2.2=res$test


set.seed(12345)
model.rf2.2=randomForest(as.formula("ctr~."), 
                         data = train.rf2.2, importance=TRUE
)


model.rf2.2 #slightly higher % of var explained by model (37.18% with 500 trees, 36.7% with 200 trees) 
plot(model.rf2.2) 
summary(model.rf2.2$predicted)

pred.rf2.2<-predict(model.rf2.2,val.rf2.2)
summary(pred.rf2.2)
RMSE.rf2.2 <- sqrt(mean((pred.rf2.2-val.rf2.2$ctr)^2)) #0.0173
MAE.rf2.2<- mean(abs(pred.rf2.2-val.rf2.2$ctr)) #0.0073 

plot(val.rf2.2$ctr,pred.rf2.2)
abline(a=0,b=1,col="red")
cor(val.rf2.2$ctr,pred.rf2.2) #62.2%

varImpPlot(model.rf2.2)



#################################
# try Lasso regression with data
library(glmnet)

#need to use matrix instead of dataframe or formula
x<-model.matrix(ctr~., data)[,-1]
y<-data$ctr

u=sample(x = 1:nrow(x),size=.2*nrow(x),replace = F)

set.seed(12345)

lasso<-glmnet(x[-u,], y[-u], alpha=1)
lasso$lambda

plot(lasso, xvar="lambda")

cv_glmnet <-  cv.glmnet(x[-u,], y[-u])
best_lam<-cv_glmnet$lambda.min

lasso_pred<-predict(lasso, s=best_lam, newx=x[u,], type="response")
summary(lasso_pred) #this returns some negative values?!

RMSE.lasso <- sqrt(mean((lasso_pred-y[u])^2)) #0.0185
MAE.lasso<- mean(abs(lasso_pred-y[u])) #0.0093

plot(y[u],lasso_pred)
abline(a=0,b=1,col="red")
cor(lasso_pred,y[u]) #39.3%
