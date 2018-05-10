# Bajar R y Rstudio =D
# Como instalar paquetes desde la consola de R
# install.packages("packcircles")

# libraries
library(packcircles)
library(ggplot2)
library(viridis)

# ---------------------------------- #
#### PIE CHART ####

neuro <- c(231,17,184,41,22,51,11,74,45,44)
categ <- c("RC.activacion","RC.inhibicion","RC.sostenido","RE.sp","RE.izq","RE.der","RE.inhibicion", "RM.sp", "RM.izq", "RM.der")
Col <- c("darkseagreen4","darkseagreen", "cadetblue3", "darkorange4","darkorange3","darkorange2","darkorange", "firebrick4","firebrick3","firebrick1")
pie(neuro,labels = categ,col = Col, main="Gráfica de Pai",border = "white")


# ---------------------------------- #
####  Circle PACKING  ####
datos <- data.frame(categ=categ, count=neuro)
packing <- circleProgressiveLayout(datos$count, sizetype='area')
packing$radius=0.95*packing$radius

# We can add these packing information to the initial data frame
datos = cbind(datos, packing)

# Check that radius is proportional to value. We don't want a linear relationship, since it is the AREA that must be proportionnal to the value
#plot(datos$radius, datos$count)


# The next step is to go from one center + a radius to the coordinates of a circle that
# is drawn by a multitude of straight lines.
dat.gg <- circleLayoutVertices(packing, npoints=50)

# Make the plot
ggplot() + 
  
  # Make the bubbles
  geom_polygon(data = dat.gg, aes(x, y, group = id, fill=as.factor(id)), colour = NA, alpha = 0.6) +
  
  # Color
  scale_fill_manual(values = Col) +
  
  # Add text in the center of each bubble + control its size
  geom_text(data = datos, aes(x, y, size=count, label = categ, alpha = 0.6)) +
  scale_size_continuous(range = c(5,8)) +
  
  # General theme:
  theme_void() + 
  theme(legend.position="none") +
  coord_equal()

