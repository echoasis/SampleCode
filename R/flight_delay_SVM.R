flights$monday    <- ifelse(as.character(flights$DOW)=="Monday", 1, 0)
flights$tuesday   <- ifelse(as.character(flights$DOW)=="Tuesday", 1, 0)
flights$wednesday <- ifelse(as.character(flights$DOW)=="Wednesday", 1, 0)
flights$thursday  <- ifelse(as.character(flights$DOW)=="Thursday", 1, 0)
flights$friday    <- ifelse(as.character(flights$DOW)=="Friday", 1, 0)
flights$saturday  <- ifelse(as.character(flights$DOW)=="Saturday", 1, 0)
flights$sunday    <- ifelse(as.character(flights$DOW)=="Sunday", 1, 0)

fl_16$monday    <- ifelse(as.character(fl_16$DOW)=="Monday", 1, 0)
fl_16$tuesday   <- ifelse(as.character(fl_16$DOW)=="Tuesday", 1, 0)
fl_16$wednesday <- ifelse(as.character(fl_16$DOW)=="Wednesday", 1, 0)
fl_16$thursday  <- ifelse(as.character(fl_16$DOW)=="Thursday", 1, 0)
fl_16$friday    <- ifelse(as.character(fl_16$DOW)=="Friday", 1, 0)
fl_16$saturday  <- ifelse(as.character(fl_16$DOW)=="Saturday", 1, 0)
fl_16$sunday    <- ifelse(as.character(fl_16$DOW)=="Sunday", 1, 0)


flights$redeye <-  ifelse(as.character(flights$CRS_DEP_TIME_GRP)=="Red Eye",1,0)
flights$earlyam <- ifelse(as.character(flights$CRS_DEP_TIME_GRP)=="Early AM",1,0)
flights$midday <-  ifelse(as.character(flights$CRS_DEP_TIME_GRP)=="Mid Day",1,0)
flights$evening <- ifelse(as.character(flights$CRS_DEP_TIME_GRP)=="Evening",1,0)

fl_16$redeye <-  ifelse(as.character(fl_16$CRS_DEP_TIME_GRP)=="Red Eye",1,0)
fl_16$earlyam <- ifelse(as.character(fl_16$CRS_DEP_TIME_GRP)=="Early AM",1,0)
fl_16$midday <-  ifelse(as.character(fl_16$CRS_DEP_TIME_GRP)=="Mid Day",1,0)
fl_16$evening <- ifelse(as.character(fl_16$CRS_DEP_TIME_GRP)=="Evening",1,0)


flights$FL <- ifelse(as.character(flights$CARRIER)=="FL", 1,0) 
flights$NK <- ifelse(as.character(flights$CARRIER)=="NK", 1,0) 
flights$AS <- ifelse(as.character(flights$CARRIER)=="AS", 1,0) 
flights$WN <- ifelse(as.character(flights$CARRIER)=="WN", 1,0) 
flights$MQ <- ifelse(as.character(flights$CARRIER)=="MQ", 1,0) 
flights$F9 <- ifelse(as.character(flights$CARRIER)=="F9", 1,0) 


fl_16$FL <- ifelse(as.character(fl_16$CARRIER)=="FL", 1,0) 
fl_16$NK <- ifelse(as.character(fl_16$CARRIER)=="NK", 1,0) 
fl_16$AS <- ifelse(as.character(fl_16$CARRIER)=="AS", 1,0) 
fl_16$WN <- ifelse(as.character(fl_16$CARRIER)=="WN", 1,0) 
fl_16$MQ <- ifelse(as.character(fl_16$CARRIER)=="MQ", 1,0) 
fl_16$F9 <- ifelse(as.character(fl_16$CARRIER)=="F9", 1,0) 

flights$jan <- ifelse(as.character(flights$Month)=="1",1,0)
flights$feb <- ifelse(as.character(flights$Month)=="2",1,0)
flights$mar <- ifelse(as.character(flights$Month)=="3",1,0)
flights$apr <- ifelse(as.character(flights$Month)=="4",1,0)
flights$may <- ifelse(as.character(flights$Month)=="5",1,0)
flights$jun <- ifelse(as.character(flights$Month)=="6",1,0)
flights$jul <- ifelse(as.character(flights$Month)=="7",1,0)
flights$aug <- ifelse(as.character(flights$Month)=="8",1,0)
flights$sep <- ifelse(as.character(flights$Month)=="9",1,0)
flights$oct <- ifelse(as.character(flights$Month)=="10",1,0)
flights$nov <- ifelse(as.character(flights$Month)=="11",1,0)
flights$dec <- ifelse(as.character(flights$Month)=="12",1,0)

fl_16$jan <- ifelse(as.character(fl_16$Month)=="1",1,0)
fl_16$feb <- ifelse(as.character(fl_16$Month)=="2",1,0)
fl_16$mar <- ifelse(as.character(fl_16$Month)=="3",1,0)
fl_16$apr <- ifelse(as.character(fl_16$Month)=="4",1,0)
fl_16$may <- ifelse(as.character(fl_16$Month)=="5",1,0)
fl_16$jun <- ifelse(as.character(fl_16$Month)=="6",1,0)
fl_16$jul <- ifelse(as.character(fl_16$Month)=="7",1,0)
fl_16$aug <- ifelse(as.character(fl_16$Month)=="8",1,0)
fl_16$sep <- ifelse(as.character(fl_16$Month)=="9",1,0)
fl_16$oct <- ifelse(as.character(fl_16$Month)=="10",1,0)
fl_16$nov <- ifelse(as.character(fl_16$Month)=="11",1,0)
fl_16$dec <- ifelse(as.character(fl_16$Month)=="12",1,0)



####SVM without DEP_DELAY

install.packages("e1071")
library(e1071)
install.packages("caret")
library(caret)


flights.pred = flights[,c(5,6,7:11,14,17)]
fl_16.pred=fl_16[,c(5,6,7:11,14,17)]

for(i in 4:9)
{
  flights.pred[,i] = as.factor(flights.pred[,i])
  fl_16.pred[,i] = as.factor(fl_16.pred[,i])
}

set.seed(123)
samp = sample(1:433201, 20000)
samp1=sample(1:194657,20000)
svm.sample0 = flights.pred[samp,]
svm.test0=fl_16.pred[samp1,]


tune.out.radial=tune(svm, as.factor(delayed.30) ~.,data=svm.sample0,kernel="radial")
best.svm.radial=tune.out.radial$best.model

svm.test$Month= factor(svm.test$Month, levels = c(1,10,11,12,2,3,4,5,6,7,8,9))
class.test.radial=predict(best.svm.radial, svm.test0,decision.values = TRUE)

summary(class.test.radial)
attr(class.test.radial, "decision.values")
table(class.test.radial, svm.test0$delayed.30, dnn=c("Prediction", "Actual"))  
Conf1<-confusionMatrix(class.test.radial,svm.test0$delayed.30)
#accuracy:87%


######include DEP_DELAY
flights.pred1 = flights[,c(5:15,18)]
fl_16.pred1=fl_16[,c(5:15,18)]

fl_16.pred1$Month=factor(fl_16.pred1$Month, levels = c(1,10,11,12,2,3,4,5,6,7,8,9))
for(i in c(6,7,11,12))
{
  flights.pred1[,i] = as.factor(flights.pred1[,i])
  fl_16.pred1[,i] = as.factor(fl_16.pred1[,i])
}

fl_16.pred1 = fl_16.pred1[-which(fl_16.pred1$DEP_DELAY == -999),]
flights.pred1 = flights.pred1[-which(flights.pred1$DEP_DELAY == -999),]

fl_16.pred1=na.omit(fl_16.pred1)
flights.pred1=na.omit(flights.pred1)
samp = sample(1:428651, 20000)
samp1=sample(1:192845,20000)
svm.sample = flights.pred1[samp,]
svm.test=fl_16.pred1[samp1,]

tune.out=tune(svm, as.factor(delayed.30) ~.,data=svm.sample,kernel="radial")
best.svm=tune.out$best.model

class.test=as.numeric(as.character(predict(best.svm, svm.test,decision.values = TRUE)))
Conf2<-confusionMatrix(class.test,svm.test$delayed.30)
table(class.test, svm.test$delayed.30, dnn=c("Prediction", "Actual")) 



####include dest.wt
flights.pred2 = flights[,c(5:12,14,15,19,20)]
fl_16.pred2=fl_16[,c(5:12,14,15,19,20)]
fl_16.pred2$Month=factor(fl_16.pred2$Month, levels = c(1,10,11,12,2,3,4,5,6,7,8,9))

for(i in c(6,7,10,12))
{
  flights.pred2[,i] = as.factor(flights.pred2[,i])
  fl_16.pred2[,i] = as.factor(fl_16.pred2[,i])
}



set.seed(123)
samp = sample(1:407087, 20000)
svm.sample2 = flights.pred2[samp,]

tune.out2=tune(svm, as.factor(delayed.30) ~.,data=svm.sample2,kernel="radial")
best.svm2=tune.out2$best.model


class.test2=as.numeric(as.character(predict(best.svm2, fl_16.pred2,decision.values = TRUE)))
Conf3<-confusionMatrix(class.test2,fl_16.pred2$delayed.30)


###### more binary variable version
flights.pred3 = flights[,c(5:8,11,15,19,21:49,20)]
fl_16.pred3=fl_16[,c(5:8,11,15,19,21:49,20)]


for(i in c(5,6,8:37))
{
  flights.pred3[,i] = as.factor(flights.pred3[,i])
  fl_16.pred3[,i] = as.factor(fl_16.pred3[,i])
}



set.seed(123)
samp = sample(1:407087, 20000)
svm.sample3 = flights.pred3[samp,]

#tune.out3=tune(svm, as.factor(delayed.30) ~.,data=svm.sample3,kernel="radial")
#best.svm3=tune.out3$best.model
model <- svm (as.factor(delayed.30) ~ ., data=svm.sample3, probability=TRUE, cost = 1, gamma = 0.02564103,kernel="radial")

fl_16.pred3$FL=factor(fl_16.pred3$FL, levels = c(0,1))
fl_16.pred3$MQ=factor(fl_16.pred3$MQ, levels = c(0,1))
fl_16.pred3$dec=factor(fl_16.pred3$dec, levels = c(0,1))
#class.test3=predict(best.svm3, fl_16.pred3,decision.values = TRUE)
class.test3=predict(model, fl_16.pred3,decision.values = TRUE,probability = TRUE)


#train on train
train3=predict(model,flights.pred3,probability=TRUE,decision.values=TRUE)
pred_t<-as.data.frame(matrix(train3,ncol=1,byrow=T))
pred_t$prob<-attr(train3,"probabilities")[,2]
pred_t$delayed<-ifelse(as.numeric(pred_t$prob)<0.1295,0,1)
Conf5<-confusionMatrix(pred_t$delayed,flights.pred3$delayed.30)

roc_train <- prediction(attributes(train3)$decision.values, flights.pred3) 

perf_train<-performance(train3,"tpr","fpr")

prob_train_radial<-pred_t$prob #wanted column of probabilities
#train on test
pred1<-as.data.frame(matrix(class.test3,ncol=1,byrow=T))
pred1$prob<-attr(class.test3,"probabilities")[,2]
pred1$delayed<-ifelse(as.numeric(pred1$prob)<0.1295,0,1)
Conf3<-confusionMatrix(class.test2,fl_16.pred3$delayed.30)
Conf4<-confusionMatrix(pred1$delayed,fl_16.pred3$delayed.30)
prob_test_radial<-pred1$prob# wanted probability column

dec_test<-attributes(class.test3)$decision.values
roc_test<-roc(response=fl_16.pred3$delayed.30,predictor=dec_test)
dec_train<-attributes(train3)$decision.values
roc_train<-roc(response=flights.pred3$delayed.30,predictor=dec_train)
plot(roc_train,col="blue",type="s")
lines(roc_test,col="red")
legend(0.5,0.2,c("train ROC--AUC 0.587","test ROC--AUC 0.555"),lty=c(1,1),col=c("blue","red"),bty="n")





####### Linear Kernel:
tune.out3=tune(svm, as.factor(delayed.30) ~.,data=svm.sample3,kernel="linear")
best.svm3=tune.out3$best.model
model1 <- svm (as.factor(delayed.30) ~ ., data=svm.sample3, probability=TRUE, cost = 1, gamma = 0.02564103,kernel="linear")
class.test4=predict(model1, fl_16.pred3,decision.values = TRUE,probability = TRUE)

#train on train
train4=predict(model1,flights.pred3,probability=TRUE,decision.values=TRUE)
pred_t1<-as.data.frame(matrix(train4,ncol=1,byrow=T))
pred_t1$prob<-attr(train4,"probabilities")[,2]
pred_t1$delayed<-ifelse(as.numeric(pred_t1$prob)<0.1295,0,1)
Conf7<-confusionMatrix(pred_t1$delayed,flights.pred3$delayed.30)

roc_train <- prediction(attributes(train3)$decision.values, flights.pred3) 

perf_train<-performance(train3,"tpr","fpr")

prob_train_linear<-pred_t1$prob #wanted column of probabilities
#train on test
pred2<-as.data.frame(matrix(class.test4,ncol=1,byrow=T))
pred2$prob<-attr(class.test4,"probabilities")[,2]
pred2$delayed<-ifelse(as.numeric(pred2$prob)<0.1295,0,1)
#Conf3<-confusionMatrix(class.test2,fl_16.pred3$delayed.30)
Conf6<-confusionMatrix(pred2$delayed,fl_16.pred3$delayed.30)
prob_test_linear<-pred2$prob# wanted probability column

dec_test1<-attributes(class.test4)$decision.values
roc_test1<-roc(response=fl_16.pred3$delayed.30,predictor=dec_test1)
dec_train1<-attributes(train4)$decision.values
roc_train1<-roc(response=flights.pred3$delayed.30,predictor=dec_train1)
plot(roc_train1,col="blue")
lines(roc_test1,col="red")
legend(0.5,0.2,c("train ROC--AUC 0.563","test ROC--AUC 0.555"),lty=c(1,1),col=c("blue","red"),bty="n")
