
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
invBind$x = invBind$X 
invBind$y = invBind$Y

s<-seq(0,6000,50) 
## Determina uma sequencia s. Representa um raio em torno de cada 
#árvore para o cálculo da função K. O valor máximo deve ser o menor lado da parcela divido por 2. No . 
# No seu caso ficaria s<-seq (0,5,1)


especie.pts<-as.points(invBind[,14:15])#  cria formato do splancs


plot(especie.pts, pch=20) #visualizar distribuição das árvores
poly<-(matrix(c(min(invBind$x),max(invBind$y), min(invBind$x), min(invBind$y), max(invBind$x),min(invBind$y), max(invBind$x),max(invBind$y)), 
              byrow=TRUE, 4,2)) # determinando poligono para a correção do efeito de borda
envelope <- Kenv.csr(length(especie.pts[,1]), 
                     poly, nsim=1000, s) ## Calcula o envelope de  Khat  a partir de simulações de completa aleatoriedade espacial
especie.k<-khat(especie.pts,poly,s) ## Calcula a funca K
plot(s, sqrt((especie.k)/pi)-s, type="l", 
     xlab="Distance (m)", ylab="L estimated") 

## plota a funcao L, derivada da funcao K
lines(s, sqrt(envelope$lower/pi)-s, lty=2) ## plota o limite inferior do envelope
lines(s, sqrt(envelope$upper/pi)-s, lty=2) ## plota o limite superior do envelope
