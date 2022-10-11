library(networkD3)
library(readxl)
library(writexl)
library(igraph)
library(bruceR)
library(htmlwidgets)

edge <- read_excel("C:/Users/cheng/OneDrive/Desktop/Meeting Minutes/East side test/edges_west.xlsx")
node <- read_excel("C:/Users/cheng/OneDrive/Desktop/Meeting Minutes/East side test/nodes_west.xlsx")


G <- graph_from_data_frame(d = edge, directed = FALSE)
V(G)$degree <- degree(G)
centrality <- igraph::as_data_frame(G, what="vertices")
node$centrality <- centrality$degree[match(node$number,centrality$name)]
node[is.na(node)] <- 0.1
node$centrality <- scaler(node$centrality, min = 0.1, max = 30)
node$freq <- scaler(node$freq, min = 0.1, max = 1)
edge$value <- scaler(edge$value, min = 0.1, max = 15)

edges <- data.frame(edge)
nodes <- data.frame(node)
network <- forceNetwork(Links = edges, Nodes = nodes,
             Source = "item1", Target = "item2",
             Value = "value", NodeID = "constraint",
             Nodesize = "centrality",
             Group = "crew", opacity = "freq", opacityNoHover = F, width = 700,
             height = 500, fontSize = 20, linkDistance = 150, legend = T, zoom = F,arrows = T, bounded = T)


 # network <- htmlwidgets::onRender(
 #   network,
 #   'function(el, x) { 
 #     d3.select("body")
 #       .style("background-image", "url(zz.png)")
 #       .style("background-repeat", "no-repeat")
 #       .style("background-size", "1200px 800px")
 #       .style("background-position", "left top");
 #   }'
 # )

saveNetwork(network, "C:/Users/cheng/OneDrive/Desktop/Meeting Minutes/East side test/west.html", selfcontained = TRUE)
