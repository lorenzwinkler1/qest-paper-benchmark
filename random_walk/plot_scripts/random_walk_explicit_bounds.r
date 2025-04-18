library(ggplot2)
library(stats)
library(MASS)
library(cowplot)
library(robustbase)
library(rrcov)
library(scales)

data_imb_sym <- read.csv("./output/random_walk/inputs/non_zero_mean/sym.json.csv")
data_imb_2n <- read.csv("./output/random_walk/inputs/non_zero_mean/2n.json.csv")
data_lin_100 <- read.csv("./output/random_walk/inputs/different_initial/lin_100.json.csv")
data2L <- read.csv("./output/random_walk/inputs/different_p/1e_2_L.json.csv")

data_lin_100 = data_lin_100[data_lin_100$i>0 &data_lin_100$p_t>0,]
data_imb_sym = data_imb_sym[data_imb_sym$i>0 &data_imb_sym$p_t>0,]
data_imb_2n = data_imb_2n[data_imb_2n$i>0 &data_imb_2n$p_t>0,]
data2L <- data2L[data2L$i>0 & data2L$p_t >0,]



p <- ggplot(data_imb_2n) +
  geom_line(aes(x=i, y=p_t, color="3_imb2n"))+
  geom_line(data=data_imb_sym,aes(x=i, y=p_t, color="2_imbsym"))+
  geom_line(data=data_lin_100, aes(x=i, y=p_t, color="1_lin_100"))+
  geom_line(data=data2L, aes(x=i, y=p_t, color="4_2L"))+
  stat_function(fun = function(x) {r=x^(-1.163321)*9855.04127203253; return(pmin(c(r),1))}, aes(color="2_imbsym"),linetype="dashed")+
  stat_function(fun = function(x) {r=x^(-1.151799)*145856.52768537975; return(pmin(c(r),1))}, aes(color="3_imb2n"),linetype="dashed")+
  stat_function(fun = function(x) {r=x^(-1.031223)*439259.3264274979; return(pmin(c(r),1))}, aes(color="1_lin_100"),linetype="dashed")+
  stat_function(fun = function(x) {r=x^(-1.158010)*2866554.715353357; return(pmin(c(r),1))}, aes(color="4_2L"),linetype="dashed")+
  scale_x_log10(limits=c(1, 1e8))+
  xlab("n")+
  ylab(expression(bold(P) (T >= n)))+
  labs(color=NULL)+
  scale_y_log10(labels=percent, breaks=c(0.000001,0.0001,0.01,1), limits=c(0.00001, 10))+
  scale_color_manual(values = c(
    "3_imb2n"="#E63946",
    "1_lin_100"="#F4A261",
    "4_2L"="#2A9D8F",
    "2_imbsym"="#8E44AD"
  ),
  labels = c(
    "3_imb2n"=expression("id"~ "=" ~3), 
    "1_lin_100"=expression("id"~ "=" ~1), 
    "4_2L"=expression("id"~ "=" ~4), 
    "2_imbsym"=expression("id"~ "=" ~2)
  )) +
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.75,0.85))

print(p)
ggsave("output/explicit_bound_examples.pdf",width=7, height=5)
