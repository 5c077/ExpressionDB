# reactive({
#   filteredData = filterData()
#   
#   
#   # Temporary plot to be replaced by interactive version.  
#   mtcars %>%   ggvis(~mpg, ~wt) %>%
#     layer_points() %>%
#     layer_smooths()
# })%>% bind_shiny("compPlot")


mtcars %>%   ggvis(~mpg, ~wt) %>%
  layer_points() %>%
  layer_smooths() %>% 
  bind_shiny("compPlot")


# n= n %>% mutate(expr1 = n/maxN)

# n %>% ggvis(x=~c(1:8), y=~expr/maxN) %>% 
#   layer_bars(fill:="dodgerblue") %>%
#   scale_numeric("y", domain = c(0, 1)) %>%
#                   hide_axis("y") %>%
#                   hide_axis("x")