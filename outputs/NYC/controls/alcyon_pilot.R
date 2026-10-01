suppressMessages(library(alcyon))
args <- commandArgs(trailingOnly = TRUE)
ln <- st_read(args[1], quiet = TRUE)
st_geometry(ln) <- "geometry"
g <- as(ln[, "line"], "AxialShapeGraph")
res <- allToAllTraverse(g, traversalType = TraversalType$Topological, radii = c("n", "3"),
                        radiusTraversalType = TraversalType$Topological, includeBetweenness = TRUE)
write.csv(st_drop_geometry(as(res, "sf")), args[2], row.names = FALSE)
write.csv(as.data.frame(connections(res)), args[3], row.names = FALSE)
