#Feito por Gustavo Mourao

#Carregando pacotes 

pkg <- c("spatstat")

install.packages(pkg, dependencies = TRUE)

require(magrittr)
require(splancs)
require(dplyr)
require(spatstat)


# Carreganfo dados

setwd("E:\\Mestrado\\Sintegra2019\\emerg\\result")

inv1 <- read.table("./csv/NP_T-396tree_tile_0001_0001_treelist.csv", header = T, sep = ",", dec = ".")
inv2 <- read.table("./csv/NP_T-396tree_tile_0001_0002_treelist.csv", header = T, sep = ",", dec = ".")
inv3 <- read.table("./csv/NP_T-396tree_tile_0002_0001_treelist.csv", header = T, sep = ",", dec = ".")
inv4 <- read.table("./csv/NP_T-396tree_tile_0002_0002_treelist.csv", header = T, sep = ",", dec = ".")

# Unindo tabelas

invBind <- rbind(inv1, inv2, inv3, inv4)

invBind %<>% filter(Height > quantile(invBind$Height,.95))

mypattern <- ppp(invBind$X, invBind$Y, c(min(invBind$X),max(invBind$X)), c(min(invBind$Y),max(invBind$Y)))

plot(mypattern, xlim = c(min(invBind$X),max(invBind$X)))

summary(mypattern)

plot(Kest(mypattern))

Kest(mypattern)

plot(envelope(mypattern,Kest))

plot(density(mypattern))

marks(mypattern) <- invBind[,c("Height","Ht.to.crown.base")]

plot(Smooth(mypattern))

K <- Kest(mypattern)
K
K <- Kest(cells, correction="isotropic")

plot(K, main="K function for cells")

# plot the L function

plot(K, sqrt(iso/pi) ~ r)
plot(K, sqrt(./pi) ~ r, ylab="L(r)", main="L function for cells")

