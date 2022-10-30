library(survival)
setwd("~/Desktop/github/biostatist_cases/1.KMplot")
# 1st method to draw the KMplot
for (c in c("BLCA")) {
  data <- read.table(paste0(c, ".FGD4.survival.rank.txt"), header = T, row.names = 1, sep = "\t")
  pvalue <- summary(coxph(Surv(T_OS, E_OS) ~ type, data)) # P=0.002
  pdf(file = paste0(c, ".os.top33-bottom33.pdf"), onefile = F)
  plot(survfit(formula = Surv(T_OS, E_OS) ~ type, data), mark.time = TRUE,
       main = c, col = c("red", "blue"), bty = "l", lwd = 3,
       xlab="Days",ylab="Probability of overall survival",cex.lab=1.5,mgp=c(2.5,1,0))
  legend(1000,1.0,c("high FGD4-AS1(top 33%, n=135)","low FGD4-AS1(bottom 33%, n=136)"), 
         col = c("red","blue"), bty="n", lwd = 3)
  text(1000, 0.1, labels = paste0("Logrank P=", signif(pvalue$sctest[3], 2)))
  dev.off()
}

# 2nd method to draw the KMplot
library(ggsurvfit)
data <- read.table("BLCA.FGD4.survival.rank.txt", header = T, row.names = 1, sep = "\t")
pdf(file = "BLCA.os.top33-bottom33.method2.pdf", onefile = F)
survfit2(Surv(T_OS, E_OS) ~ type, data) %>% 
  ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  ) + 
  add_confidence_interval() +
  add_risktable(times = c(0, 730, 1460, 2190, 2920, 3650))
dev.off()

