# ggvis cleanup code to set everything to be blank.
formatPlot <- function(vis, ...) {
  layer_bars(vis, fill= 'dodgerblue', strokeWidth := 2)  %>%
    hide_axis("x") %>%
    
    hide_axis("y") %>%
    
#     add_axis("y", title = NULL,
#              title_offset=65, 
#              properties = axis_props(
#                title = list(fontSize = 20),
#                axis = list(strokeWidth = 2),
#                grid = list(stroke = NA),
#                labels = list(fontSize = 16))) %>%
    
    hide_legend("fill")
  #     add_legend("fill", title = tempTitle, values = list(tempSub))
}