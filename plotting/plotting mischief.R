df = data %>% 
  slice(1) %>% 
  select(contains('mean')) %>% 
  gather(tissue, avg)

df = df  %>% mutate(lb = avg *0.9, ub = avg*1.1)

grey60K = 'grey'
grey90K = 'darkgrey'

ggplot(x, aes(x = tissue, y = avg)) +
  geom_bar(stat = 'identity', fill = 'dodgerblue') +
  coord_flip() +
  theme_bw() +
  theme(
    text = element_text(family = 'Segoe UI Light', colour = grey60K),
    rect = element_blank(),
    plot.background = element_blank(),
    axis.text = element_text(size = 12,  color = grey60K),
    title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
    axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
    axis.title.y = element_blank(), 
    strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
    legend.position = 'none',
    strip.background = element_blank(),
    axis.ticks = element_blank(),
    panel.margin = unit(3, 'lines'),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_line(size = 0.1, color = '#bababa'))


x %>% 
  ggvis(~tissue, ~avg) %>% 
  layer_points() %>% 
  layer_rects(x = 1, x2 = 1, y = 0, y2 = 1, fill := 'grey')

layer_bars(fill := 'dodgerblue', stroke := NA) %>% 
  add_axis(type = 'y',
           layer = 'front',
           properties = axis_props(
             majorTicks = NULL,
             grid = list(stroke = 'white',
                         strokeWidth = 0.5)
           )) %>% 
  add_axis(type = 'x',
           properties = axis_props(
             majorTicks = NULL,
             grid = list(stroke = 'white')
           ))


tissueColor = 'dodgerblue'
grey20K = '#D1D3D4'

df %>% 
  ggvis() %>% 
  layer_rects(x = ~tissue, width := 5,
              y = ~ lb, y2 = ~ub, fill := 'grey', strokeWidth := 0,
              opacity := 0.4) %>% 
  layer_points(x = ~tissue, y = ~ avg, fill = ~avg) %>% 
  add_axis(type = 'y',
           title = '',
           tick_size_major = 0,
           ticks = 5,
           properties = axis_props(
             axis = list(strokeWidth = 0),
             grid = list(stroke = grey20K,
                         strokeWidth = 0.5)
           )) %>% 
  add_axis(type = 'x', 
           tick_size_major = 0,
           title = "",
           properties = axis_props(
             axis = list(strokeWidth = 0),
             majorTicks = NULL,
             grid = list(strokeWidth = 0)
           )) %>% 
  add_axis(type = 'x', 
           tick_size_major = 0,
           orient = "top",
           title = "Expression level (FPKM) of tissue X",
           properties = axis_props(
             axis = list(strokeWidth = 0),
             grid = list(strokeWidth = 0),
             labels = list(text = ""),
             title  = list(fontSize = 14,
                           dx = -120))) %>% 
  scale_numeric("fill", domain = c(0, 3), 
                range = c(brewer.pal(9, 'Blues')[3], brewer.pal(9, 'Blues')[9])) %>% 
  hide_legend('fill')