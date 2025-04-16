
library(MASS)
library(ggplot2)
library(cowplot)
library(dplyr)
library(scales)




data <- read.csv("output/output_all.csv")



rearranged_data = data%>% 
  filter(!is.na(n0)) %>%
  filter(id == 2) %>%
  arrange(explicit_bound) %>%
  select(id,q1,q2, percentage,explicit_bound, n0, exponent) 

# rearranged_data



#filtered = data[data$exponent>-0.5 & data$id !=0 & data$id!=1 ,]
#filtered
print("Minimum exponents")

min_data = data %>%
  group_by(id, q1, q2, percentage) %>%
  summarise(
    min_exponent = min(exponent)
  ) %>% select(q1,percentage,q2, min_exponent)
min_data

mean_data = data[data$min_population==100 & data$max_population == 100 & data$min_granularity ==400 & data$max_granularity==400 & data$exact_n0=='False',] %>%
  group_by(id) %>%
  summarise(
    mean_exp_with_max_config = mean(exponent),
    mean_time_with_max_config = mean(time)
  )



#mean_data




divided_by_mean_data = data[data$exact_n0=="False",] %>% left_join(mean_data, by="id") %>%
  mutate(deviation_exponent = exponent/mean_exp_with_max_config, deviation_time = time/mean_time_with_max_config) %>%select(id, num_generations, min_population, max_population, min_granularity, max_granularity, deviation_exponent, deviation_time, time) %>%
  mutate(col=paste(min_population,max_population,min_granularity,max_granularity, sep="_"))

#divided_by_mean_data

#divided_by_mean_data[divided_by_mean_data$col=="100_100_400_400" | divided_by_mean_data$col=="100_100_200_200" | divided_by_mean_data$col=="100_100_50_50",]




plot_data = divided_by_mean_data[divided_by_mean_data$col=="100_100_400_400" | divided_by_mean_data$col=="100_100_200_200" | divided_by_mean_data$col=="100_100_50_50" | divided_by_mean_data$col=="20_100_50_400" | divided_by_mean_data$col=="20_100_50_200",]

plot_data$col = factor(plot_data$col, levels=c("100_100_400_400", "100_100_200_200","100_100_50_50","20_100_50_200","20_100_50_400"))

ggplot(plot_data) + 
  geom_boxplot(aes(y=deviation_exponent, color=col))+
  scale_color_manual(values = c(
    "100_100_400_400"="#E63946",
    "100_100_200_200"="#F4A261",
    "100_100_50_50"="#2A9D8F",
    "20_100_50_200"="#8E44AD",
    "20_100_50_400"="#264653"
  ),
  labels = c(
    "100_100_400_400"="pop.=100; g=400",
    "100_100_200_200"="pop.=100; g=200",
    "100_100_50_50"="pop.=100; g=50",
    "20_100_50_200"="pop.=20-100; g=50-200",
    "20_100_50_400"="pop.=20-100; g=50-400"
  )) +
  labs(col=NULL)+
  ylab("relative value of exponent")+
  xlab("")+
  guides(color=guide_legend(reverse = FALSE))+
  scale_y_continuous(labels=percent)+
  theme_half_open() +
  theme(legend.position="none", axis.ticks.x=element_blank(), axis.text.x=element_blank())

ggsave("output/genetic_algorithm_exponent.pdf",width=7, height=5)



ggplot(plot_data) + 
  geom_boxplot(aes(y=time, color=col))+
  scale_color_manual(values = c(
    "100_100_400_400"="#E63946",
    "100_100_200_200"="#F4A261",
    "100_100_50_50"="#2A9D8F",
    "20_100_50_200"="#8E44AD",
    "20_100_50_400"="#264653"
  ),
  labels = c(
    "100_100_400_400"="pop.=100; g=400",
    "100_100_200_200"="pop.=100; g=200",
    "100_100_50_50"="pop.=100; g=50",
    "20_100_50_200"="pop.=20-100; g=50-200",
    "20_100_50_400"="pop.=20-100; g=50-400"
  )) +
  labs(col=NULL)+
  ylab("computation time [ms]")+
  xlab("")+
  guides(color=guide_legend(reverse = FALSE))+
  theme_half_open()+
  theme(legend.position="inside",legend.position.inside=c(0.65,0.85), axis.ticks.x=element_blank(), axis.text.x=element_blank())

ggsave("output/genetic_algorithm_time.pdf",width=7, height=5)



mean_data_exact = data[data$min_population==100 & data$max_population == 100 & data$min_granularity ==400 & data$max_granularity==400 & data$exact_n0=='True',] %>%
  group_by(id) %>%
  summarise(
    mean_bound_with_max_config = mean(explicit_bound),
    mean_time_with_max_config = mean(time)
  )




divided_by_mean_data_exact = data[data$exact_n0=="True",] %>% left_join(mean_data_exact, by="id") %>%
  mutate(deviation_bound = explicit_bound/mean_bound_with_max_config, deviation_time = time/mean_time_with_max_config) %>%select(id, num_generations, min_population, max_population, min_granularity, max_granularity, deviation_bound, deviation_time) %>%
  mutate(col=paste(min_population,max_population,min_granularity,max_granularity, sep="_"))

#divided_by_mean_data_exact

print("Minimum explicit bounds")
min_data_explicit = data %>%
  group_by(id, q1, q2, percentage) %>%
  summarise(
    min_bound = min(explicit_bound, na.rm=TRUE)
  ) %>% select(q1,percentage,q2, min_bound)
min_data_explicit



ggplot(divided_by_mean_data_exact) + 
  geom_boxplot(aes(y=deviation_bound, color=col))+
  scale_y_log10()

