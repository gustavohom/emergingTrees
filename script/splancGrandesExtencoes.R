require(splancs)
require(dplyr)
require(magrittr)


# Carreganfo dados

setwd("E:\\Mestrado\\Sintegra2019\\emerg\\result")

# Tabela com altura das arvores

inv1 <- read.table("./csv/NP_T-396tree_tile_0001_0001_treelist.csv", header = T, sep = ",", dec = ".")
inv2 <- read.table("./csv/NP_T-396tree_tile_0001_0002_treelist.csv", header = T, sep = ",", dec = ".")
inv3 <- read.table("./csv/NP_T-396tree_tile_0002_0001_treelist.csv", header = T, sep = ",", dec = ".")
inv4 <- read.table("./csv/NP_T-396tree_tile_0002_0002_treelist.csv", header = T, sep = ",", dec = ".")

# Vertices do poligono 

ver <- read.table("./qgis/vert/vert.csv", sep=",", dec=".", header = T)

# Unindo tabelas

invBind <- rbind(inv1, inv2, inv3, inv4)

invBind %<>% filter(Height > quantile(invBind$Height,.95))
invBind$x = invBind$X 
invBind$y = invBind$Y


## Determina uma sequencia s. Representa um raio em torno de cada 
#árvore para o cálculo da função K. O valor máximo deve ser o menor lado da parcela divido por 2. No . 
# No seu caso ficaria s<-seq (0,5,1)

#  cria formato do splancs

especie.pts<-as.points(invBind[,14:15])

#visualizar distribuição das árvores

plot(especie.pts, pch=20) 

#########################################
# Preparando dados para loop
#########################################

# definindo valores de maximo e minimo

maxX = max(ver$x)
minX = min(ver$x)
maxY = max(ver$y)
minY = min(ver$y)

# extraindo amplitude

aX = maxX - minX
aY = maxY - minY

# numero de divisao do poligono (cheguei a conclusão que deve ser no maximo 2 km)

n = 6

# valores a serem acrescentado a x e y 

somX = aX/n
somY = aY/n

# Valores iniciais de x e y

X1 = ver[3,"x"]
X2 = ver[4,"x"]
Y1 = ver[3,"y"]
Y2 = ver[4,"y"]

## Determina uma sequencia s. Representa um raio em torno de cada 
#árvore para o cálculo da função K. O valor máximo deve ser o menor lado da parcela divido por 2. No . 
# No seu caso ficaria s<-seq (0,5,1)

tamanhomaximo = 12000

s<-seq(0,tamanhomaximo/(n*2),50) 

# Preparando dados para plotar graficos mais a frente

verAjust = ver

verAjust[1:4,"id"] = "blue"

par(mfrow=c(3,2))

# loop para calcular a distribuicao espacial da área

i = 1

for (i in 1:n) {

# valores corrigidos 

acrX1 = X1 + somX
acrX2 = X2 + somX
acrY1 = Y1 + somY
acrY2 = Y2 + somY

# Criando poligono para a correcao do efeito de borda:  
# poligono deve ser criado com cuidado para nao dar o efeito "X"

poly<-(matrix(c(X1, Y1,acrX1, acrY1, acrX2, acrY2, X2, Y2), 
              byrow=TRUE, 4,2))

## Calcula o envelope de  Khat  a partir de simulações de completa aleatoriedade espacial

envelope <- Kenv.csr(length(especie.pts[,1]), 
                     poly, nsim=1000, s) 

## Calcula a funca K

especie.k<-khat(especie.pts,poly,s) 

plot(s, sqrt((especie.k)/pi)-s, type="l", 
     xlab="Distance (m)", ylab="L estimated") 

# plota a funcao L, derivada da funcao K

lines(s, sqrt(envelope$lower/pi)-s, lty=2)
lines(s, sqrt(envelope$upper/pi)-s, lty=2)

# Preparação para proximo loop: correcao de coordenada inferiores

X1 = acrX1
X2 = acrX2
Y1 = acrY1
Y2 = acrY2

# Escrevendo novos valores em tabela para futura analise

len = length(verAjust$x)
verAjust[1 + len,"x"] = X1
verAjust[1 + len,"y"] = Y1
verAjust[1 + len,"id"] = "red"
len = length(verAjust$x)
verAjust[1 + len,"x"] = X2
verAjust[1 + len,"y"] = Y2
verAjust[1 + len,"id"] = "red"

# definindo valor de i para prosseguir no loop

i = i + 1

}

# Plotando grafico dos pontos (azuis pontos reais, vermelho pontos ajustados)

par(mfrow=c(1,1))

verAjust

plot(data = verAjust, x~y, col = verAjust$id)

