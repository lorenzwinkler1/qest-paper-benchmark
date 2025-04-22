
library(ggplot2)
library(stats)
library(MASS)
library(cowplot)
library(robustbase)
library(rrcov)
library(scales)




data_lin_10 <- read.csv("./output/random_walk/inputs/different_initial/lin_10.json.csv")
data_lin_100 <- read.csv("./output/random_walk/inputs/different_initial/lin_100.json.csv")
data_lin_1000 <- read.csv("./output/random_walk/inputs/different_initial/lin_1000.json.csv")
data_lin_10000 <- read.csv("./output/random_walk/inputs/different_initial/lin_10000.json.csv")

data_lin_10 = data_lin_10[data_lin_10$i>0 &data_lin_10$p_t>0,]
data_lin_100 = data_lin_100[data_lin_100$i>0 &data_lin_100$p_t>0,]
data_lin_1000 = data_lin_1000[data_lin_1000$i>0 &data_lin_1000$p_t>0,]
data_lin_10000 = data_lin_10000[data_lin_10000$i>0 &data_lin_10000$p_t>0 & (data_lin_10000$i<10000 | data_lin_10000$i%%10 == 0),]




## Perform robust linear regression


reg_lin_10 = rlm(log(p_t)~log(i), data=data_lin_10, weights=1/i)
reg_lin_100 = rlm(log(p_t)~log(i), data=data_lin_100[data_lin_100$i>10&data_lin_100$i<1e4,], weights=1/i)
reg_lin_1000 = rlm(log(p_t)~log(i), data=data_lin_1000[data_lin_1000$i>1e2 & data_lin_1000$i<1e5,], weights=1/i)
reg_lin_10000 = rlm(log(p_t)~log(i), data=data_lin_10000[data_lin_10000$i>1e3 & data_lin_10000$i<8e5,], weights=1/i)




p <- ggplot(data_lin_10000) +
  geom_line(aes(x=i, y=p_t, color="initial10000"))+
  geom_line(data=data_lin_1000,aes(x=i, y=p_t, color="initial1000"))+
  geom_line(data=data_lin_100,aes(x=i, y=p_t, color="initial100"))+
  geom_line(data=data_lin_10,aes(x=i, y=p_t, color="initial10"))+
  # geom_line(aes(x=i, y=exp(predict(reg_lin_10000,data.frame(i = i))), color="initial10000"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_lin_1000,data.frame(i = i))), color="initial1000"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_lin_100,data.frame(i = i))), color="initial100"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_lin_10,data.frame(i = i))), color="initial10"), linetype=2)+
  scale_x_log10()+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.0001,0.01,1), limits=c(0.00001, 10))+
  scale_color_manual(values = c(
    "initial10000"="#E63946",
    "initial1000"="#F4A261",
    "initial100"="#2A9D8F",
    "initial10"="#8E44AD"
  ),
  labels = c(
    "initial10000"=expression(y[0]~"="~10000), 
    "initial1000"=expression(y[0]~"="~1000), 
    "initial100"=expression(y[0]~"="~100), 
    "initial10"=expression(y[0]~"="~10)
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.85))

print(p)
ggsave("output/initial_value_plot.pdf",width=7, height=5)






# Comparison of non_zero_means



data_imb_n <- read.csv("./output/random_walk/inputs/non_zero_mean/n.json.csv")
data_imb_const <- read.csv("./output/random_walk/inputs/non_zero_mean/const.json.csv")
data_imb_2n <- read.csv("./output/random_walk/inputs/non_zero_mean/2n.json.csv")
data_imb_sym <- read.csv("./output/random_walk/inputs/non_zero_mean/sym.json.csv")

data_imb_n = data_imb_n[data_imb_n$i>0 &data_imb_n$p_t>0,]
data_imb_const = data_imb_const[data_imb_const$i>0 &data_imb_const$p_t>0,]
data_imb_2n = data_imb_2n[data_imb_2n$i>0 &data_imb_2n$p_t>0,]
data_imb_sym = data_imb_sym[data_imb_sym$i>0 &data_imb_sym$p_t>0 & (data_imb_sym$i<10000 | data_imb_sym$i%%10 == 0),]




## Perform robust linear regression


reg_imb_n = rlm(log(p_t)~log(i), data=data_imb_n[data_imb_n>50,], weights=1/i)
reg_imb_const = rlm(log(p_t)~log(i), data=data_imb_const[data_imb_const$i>50&data_imb_const$i<1e4,], weights=1/i)
reg_imb_2n = rlm(log(p_t)~log(i), data=data_imb_2n[data_imb_2n$i>500 & data_imb_2n$i<1e5,], weights=1/i)
reg_imb_sym = rlm(log(p_t)~log(i), data=data_imb_sym[data_imb_sym$i>50 & data_imb_sym$i<8e5,], weights=1/i)




p <- ggplot(data_imb_2n) +
  geom_line(aes(x=i, y=p_t, color="imb2n"))+
  geom_line(data=data_imb_n,aes(x=i, y=p_t, color="imbn"))+
  geom_line(data=data_imb_const,aes(x=i, y=p_t, color="imbconst"))+
  geom_line(data=data_imb_sym,aes(x=i, y=p_t, color="imbsym"))+
  # geom_line(aes(x=i, y=exp(predict(reg_imb_2n,data.frame(i = i))), color="imb2n"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_imb_n,data.frame(i = i))), color="imbn"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_imb_const,data.frame(i = i))), color="imbconst"), linetype=2)+
  # geom_line(aes(x=i, y=exp(predict(reg_imb_sym,data.frame(i = i))), color="imbsym"), linetype=2)+
  scale_x_log10()+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.000001,0.0001,0.01,1), limits=c(0.00001, 10))+
  scale_color_manual(values = c(
    "imb2n"="#E63946",
    "imbn"="#F4A261",
    "imbconst"="#2A9D8F",
    "imbsym"="#8E44AD"
  ),
  labels = c(
    "imb2n"=expression(E(X[n])~"="~2*n+20), 
    "imbn"=expression(E(X[n])~"="~n), 
    "imbconst"=expression(E(X[n])~"="~20), 
    "imbsym"=expression(E(X[n])~"="~0)
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.85))

print(p)
ggsave("output/imbalance_plot.pdf",width=7, height=5)




# Slope change



data1 <- read.csv("./output/random_walk/inputs/slope_change/test1.json.csv")
data2 <- read.csv("./output/random_walk/inputs/slope_change/test2.json.csv")
data3 <- read.csv("./output/random_walk/inputs/slope_change/test3.json.csv")

data1 = data1[data1$i>0 &data1$p_t>0,]
data2 = data2[data2$i>0 &data2$p_t>0,]
data3 = data3[data3$i>0 &data3$p_t>0,]





## Perform robust linear regression






p <- ggplot(data1) +
  geom_line(data=data2,aes(x=i, y=p_t, color="cubic"))+
  geom_line(data=data3,aes(x=i, y=p_t, color="linear"))+
  geom_line(aes(x=i, y=p_t, color="mixture"))+
  scale_x_log10()+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.000001,0.0001,0.01,1), limits=c(0.00001, 10))+
  scale_color_manual(values = c(
    "cubic"="#E63946",
    "linear"="#F4A261",
    "mixture"="#2A9D8F",
    "_"="#8E44AD"
  ),
  labels = c(
    "cubic"=expression("\u00B1"~n^{3}), 
    "linear"=expression("\u00B1"~10^{6}*n), 
    "mixture"=expression("\u00B1"~(n^{3}+10^{6}*n)), 
    "_"=expression(E(X[n])~"="~0)
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.85))

print(p)
ggsave("output/slope_change.pdf",width=7, height=5)




# Termination-cutoff-analysis

data1 <- read.csv("./output/random_walk/inputs/termination_boundary/lin.json.csv")
data2 <- read.csv("./output/random_walk/inputs/termination_boundary/sqrt.json.csv")
data3 <- read.csv("./output/random_walk/inputs/termination_boundary/qubicroot.json.csv")
data4 <- read.csv("./output/random_walk/inputs/termination_boundary/quadr.json.csv")
data5 <- read.csv("./output/random_walk/inputs/termination_boundary/pow5.json.csv")

data1 = data1[data1$i>0 &data1$p_t>0,]
data2 = data2[data2$i>0 &data2$p_t>0,]
data3 = data3[data3$i>0 &data3$p_t>0,]
data4 = data4[data4$i>0 &data4$p_t>0,]
data5 = data5[data5$i>0 &data5$p_t>0,]



## Perform robust linear regression


reg1 = rlm(log(p_t)~log(i), data=data1[data1$i>1e3 & data1$i<1e5,], weights=1/i)
reg2 = rlm(log(p_t)~log(i), data=data2[data2$i>1e3 & data2$i<1e5,], weights=1/i)
reg3 = rlm(log(p_t)~log(i), data=data3[data3$i>1e3 & data3$i<1e5,], weights=1/i)
reg4 = rlm(log(p_t)~log(i), data=data4[data4$i>2e2 & data4$i<1e3,], weights=1/i)
reg5 = rlm(log(p_t)~log(i), data=data5[data5$i>12 & data5$i<1e3,], weights=1/i)

print("--------Regression for linear symmetric random walk--------")
reg1
print("--------Regression for squareroot symmetric random walk--------")
reg2
print("--------Regression for qubicroot symmetric random walk--------")
reg3
print("--------Regression for quadratic symmetric random walk--------")
reg4
print("--------Regression for pow5 symmetric random walk--------")
reg5




p <- ggplot(data1) +
  geom_line(data=data2,aes(x=i, y=p_t, color="sqrt"))+
  geom_line(data=data3,aes(x=i, y=p_t, color="4rt"))+
  geom_line(aes(x=i, y=p_t, color="linear"))+
  geom_line(data=data4,aes(x=i, y=p_t, color="quadr"))+
  geom_line(data=data5,aes(x=i, y=p_t, color="pow5"))+
  stat_function(fun = function(x) {r=x^(reg2$coefficients[2])*exp(reg2$coefficients[1]); return(r)}, aes(color="sqrt"),linetype="dashed")+
  stat_function(fun = function(x) {r=x^(reg1$coefficients[2])*exp(reg1$coefficients[1]); return(r)}, aes(color="linear"),linetype="dashed")+
  stat_function(fun = function(x) {r=x^(reg3$coefficients[2])*exp(reg3$coefficients[1]); return(r)}, aes(color="4rt"),linetype="dashed")+
 stat_function(fun = function(x) {r=x^(reg4$coefficients[2])*exp(reg4$coefficients[1]); return(r)}, aes(color="quadr"),linetype="dashed")+
 stat_function(fun = function(x) {r=x^(reg5$coefficients[2])*exp(reg5$coefficients[1]); return(r)}, aes(color="pow5"),linetype="dashed")+
  scale_x_log10()+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.0001,0.01,1), limits=c(0.00001, 10))+
  scale_color_manual(values = c(
    "linear"="#E63946",
    "sqrt"="#F4A261",
    "4rt"="#2A9D8F",
    "quadr"="#8E44AD",
    "pow5"="#1D3557"
  ),
  labels = c(
    "linear"=expression("\u00B1"~n), 
    "sqrt"=expression("\u00B1"~sqrt(n)), 
    "4rt"=expression("\u00B1"~root(n,4)), 
    "quadr"=expression("\u00B1"~n^{2}),
    "pow5"=expression("\u00B1"~n^{5})
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.85))

print(p)
ggsave("output/termination_boundary.pdf",width=7, height=5)





# Different p




data1 <- read.csv("./output/random_walk/inputs/different_p/sym.json.csv")
data2 <- read.csv("./output/random_walk/inputs/different_p/1e_1_L.json.csv")
data3 <- read.csv("./output/random_walk/inputs/different_p/1e_1_R.json.csv")
data4 <- read.csv("./output/random_walk/inputs/different_p/1e_2_L.json.csv")
data5 <- read.csv("./output/random_walk/inputs/different_p/1e_2_R.json.csv")
data6 <- read.csv("./output/random_walk/inputs/different_p/1e_3_L.json.csv")
data7 <- read.csv("./output/random_walk/inputs/different_p/1e_3_R.json.csv")

data1 = data1[data1$i>0 &data1$p_t>0,]
data2 = data2[data2$i>0 &data2$p_t>0,]
data3 = data3[data3$i>0 &data3$p_t>0,]
data4 = data4[data4$i>0 &data4$p_t>0,]
data5 = data5[data5$i>0 &data5$p_t>0,]
data6 = data6[data6$i>0 &data6$p_t>0,]
data7 = data7[data7$i>0 &data7$p_t>0,]





reg1 = rlm(log(p_t)~log(i), data=data1[data1$i>1e3 & data1$p_t>1e-6,], weights=1/i)
reg2 = rlm(log(p_t)~log(i), data=data2[data2$i>7e3 & data2$p_t>1e-6,], weights=1/i)
reg3 = rlm(log(p_t)~log(i), data=data3[data3$i>1e3 & data3$p_t>1e-6,], weights=1/i)
reg4 = rlm(log(p_t)~log(i), data=data4[data4$i>3e3 & data4$p_t>1e-6,], weights=1/i)
reg5 = rlm(log(p_t)~log(i), data=data5[data5$i>8e2 & data5$p_t>1e-6,], weights=1/i)
reg6 = rlm(log(p_t)~log(i), data=data6[data6$i>1e4 & data6$p_t>1e-6,], weights=1/i)
reg7 = rlm(log(p_t)~log(i), data=data7[data7$i>1e3 & data7$p_t>1e-6,], weights=1/i)

print("--------Regression for pow3 symmetric random walk--------")
reg1

print("--------Regression for pow3 p=0.9 random walk--------")
reg2
print("--------Regression for pow3 p=0.1 random walk--------")
reg3


print("--------Regression for pow3 p=0.99 random walk--------")
reg4
print("--------Regression for pow3 p=0.01 random walk--------")
reg5

print("--------Regression for pow3 p=0.999 random walk--------")
reg6
print("--------Regression for pow3 p=0.001 random walk--------")
reg7




p <- ggplot(data1) +
  geom_line(aes(x=i, y=p_t, color="sym"), linetype=2)+
  geom_line(data=data2,aes(x=i, y=p_t, color="1L"), linetype=2)+
  geom_line(data=data3,aes(x=i, y=p_t, color="1R"))+
  geom_line(data=data4,aes(x=i, y=p_t, color="2L"), linetype=2)+
  geom_line(data=data5,aes(x=i, y=p_t, color="2R"))+
  geom_line(data=data6,aes(x=i, y=p_t, color="3L"), linetype=2)+
  geom_line(data=data7,aes(x=i, y=p_t, color="3R"))+
  #stat_function(fun = function(x) {r=x^(reg6$coefficients[2])*exp(reg6$coefficients[1]); return(r)}, aes(color="sqrt"))+
  #stat_function(fun = function(x) {r=x^(reg7$coefficients[2])*exp(reg7$coefficients[1]); return(r)}, aes(color="linear"))+
  scale_x_log10()+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.000001,0.0001,0.01,1), limits=c(0.000001, 10))+
  scale_color_manual(values = c(
    "sym"="#E63946",
    "1L"="#F4A261",
    "1R"="#F4A261",
    "2L"="#2A9D8F",
    "2R"="#2A9D8F",
    "3L"="#8E44AD",
    "3R"="#8E44AD"
  ),
  labels = c(
    "sym"=expression(p~"="~0.5),
    "1L"= expression(p~"="~0.9),
    "1R"=expression(p~"="~0.1),
    "2L"=expression(p~"="~0.99),
    "2R"=expression(p~"="~0.01),
    "3L"=expression(p~"="~0.999),
    "3R"=expression(p~"="~0.001)
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.7))

print(p)
ggsave("output/different_percentages.pdf",width=7, height=5)


