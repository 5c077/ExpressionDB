# themes ------------------------------------------------------------------



theme_jointplot <- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light'),
      axis.text = element_text(size = 16, color = grey50K, family = 'Segoe UI Light'),
      title =  element_text(size = 18, family = 'Segoe UI', hjust = 0, color = grey60K),
      axis.title.y =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = 1),
      axis.title.x =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = -0.25),
      # axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=13, color = grey50K, family = 'Segoe UI Semilight'),
      legend.position = c(0.85, 0.85),
      legend.text = element_text(size = 13),
      strip.background = element_blank()
      #           panel.grid.minor.y = element_blank(),
      #           panel.grid.major.y = element_blank())
    )
}

theme_box_ygrid<- function() {
  theme_bw() +
    theme(
      rect = element_blank(),
      plot.background = element_blank(),
      # panel.background = element_rect(fill = 'white'),
      axis.text = element_text(size = 10, color = '#4D525A'),
      title =  element_text(size = 14, face = "bold", hjust = 0, color = '#4D525A'),
      axis.title.x =  element_text(size = 12, face = "bold", color = '#4D525A', hjust = 0.5, vjust = -0.25),
      axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks.y = element_blank(),
      panel.margin = unit(3, 'lines'),
      panel.grid.major.y = element_line(size = 0.2, color = '#bababa'),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank())
}

theme_xylab<- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light', colour = grey60K),
      rect = element_blank(),
      plot.background = element_blank(),
      axis.text = element_text(size = 12,  color = grey60K),
      title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
      axis.title =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
      strip.text = element_text(size=14, family = "Segoe UI Semilight", hjust = 0.05, vjust = -2.5, color = grey90K),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks = element_blank(),
      panel.margin = unit(1, 'lines'),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank())
}

theme_xygrid<- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light', colour = grey60K),
      rect = element_blank(),
      plot.background = element_blank(),
      # panel.background = element_rect(fill = 'white'),
      axis.text = element_text(size = 12,  color = grey60K),
      title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
      axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
      axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks = element_blank(),
      panel.margin = unit(3, 'lines'),
      panel.grid.major.y = element_line(size = 0.2, color = '#bababa'),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(size = 0.1, color = '#bababa'))
}

theme_blankbox <- function() {
  theme_bw() +
    theme(
      axis.text = element_text(size = 16, color = 'white'),
      title =  element_text(size = 18, face = "bold", hjust = 0, color = 'white'),
      axis.title =  element_text(size = 20, face = "bold", color = 'white', hjust = 0.5, vjust = -0.25),
      # axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      axis.ticks = element_blank(),
      strip.text = element_text(size=11),
      strip.background = element_blank(),
      legend.position="none",
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.border = element_blank()
    )
}


theme_blankLH <- function() {
  theme(
    title = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.ticks.length = unit(0, units = 'points'),
    axis.ticks.margin = unit(0, units =  'points'),
    panel.border = element_blank(),
    plot.margin = rep(unit(0, units = 'points'),4),
    panel.grid = element_blank(),
    panel.background = element_blank(), 
    plot.background = element_blank(), 
    legend.position="none"
  )
}


theme_heatmap <- function() {
  theme(
    title =  element_text(size = 16, hjust = 0, color = grey90K,
                          family = 'Segoe UI'),
    axis.title = element_blank(),
    axis.text = element_text(size = 12, hjust = 0.5, 
                             color = grey60K, family = 'Segoe UI Light'),
    axis.ticks = element_blank(),
    # axis.text.margin = unit(0, units =  'points'),
    panel.border = element_blank(),
    plot.margin = rep(unit(0, units = 'points'),4),
    panel.grid = element_blank(),
    panel.background = element_blank(), 
    plot.background = element_blank(), 
    legend.position="none"
  )
}


theme_xOnly<- function() {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_line(color = grey60K, size = 1),
        axis.ticks.x = element_line(color = grey60K, size = 0.5),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 22, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.grid = element_blank(),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_xAxis_yText<- function() {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_line(color = grey60K, size = 1),
        axis.ticks.x = element_line(color = grey60K, size = 0.5),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 22, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.grid = element_blank(),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_xGrid<- function() {
  theme(title = element_text(size = 16, color = grey90K, 
                             family = 'Segoe UI'),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 18, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(size = 0.1, colour = grey60K),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}



theme_yGrid<- function() {
  theme(title = element_text(size = 16, color = grey90K, 
                             family = 'Segoe UI'),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_text(size = 18, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_line(size = 0.1, colour = grey60K),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_bump<- function() {
  theme(title = element_text(size = 32, color = '#4D525A'),
        axis.line = element_blank(),
        axis.ticks.length = unit(7, 'points'),
        axis.ticks.y = element_line(color = '#4D525A', size = 0.5),
        axis.text.y = element_text(size = 16, color = '#4D525A'),
        axis.title.y = element_text(size = 22, color = '#4D525A'),
        axis.text.x = element_text(size = 16, color = '#4D525A'),
        axis.title.x = element_blank(), 
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_classicLH<- function() {
  theme(title = element_text(size = 32, color = '#4D525A'),
        axis.line = element_blank(),
        axis.ticks.x = element_line(color = '#4D525A', size = 1),
        axis.text.x = element_text(size = 16, color = '#4D525A'),
        axis.title.x = element_text(size = 22, color = '#4D525A'),
        axis.ticks.y = element_line(color = '#4D525A', size = 1),
        axis.text.y = element_text(size = 16, color = '#4D525A'),
        axis.title.y = element_text(size = 22, color = '#4D525A'),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())
}

theme_pairGrid = function() {
  theme(legend.position="none",
        plot.background = element_blank(),
        panel.background = element_blank(),
        axis.text = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        title =  element_text(size = 18, face = "bold", hjust = 0, color = grey90K, family = 'Segoe UI'),
        axis.title =  element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y= element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y= element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(size = 0.2, colour = grey60K),
        axis.ticks.x = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.margin = rep(unit(0, units = 'points'),4),
        panel.border = element_blank(),
        # axis.text.x  = element_blank(), axis.title.x  = element_blank(),
        # axis.ticks = element_blank(), axis.line = element_blank(),
        axis.ticks.y = element_blank(), axis.line.y = element_blank(),
        axis.text.y = element_blank(), axis.title.y = element_blank())
}



# Blacks/Grey --------------------------------------------------------------
softBlack = '#353839'
stdGrey = '#4D525A'
dkGrey = '#353839'
grey90K = '#414042'
grey60K = '#808285'
grey50K = '#939598'
grey30K = '#BCBEC0'
grey15K = '#DCDDDE'
grey10K = '#E6E7E8'

x = anovas %>% 
  select(-Coordinates, -Length) %>% 
  gather(tissue, expr, -Transcript) %>% 
  separate(tissue, c('tissue', 'gunk'), sep= '[0-9]') %>% 
  select(-gunk) %>% 
  mutate(logExpr = log10(expr))  

x = x %>%  filter(Transcript %in% z)
  


y = x %>% 
  filter(Transcript == 'uc007aet.1(ucsc),-transcript' |
           Transcript == 'uc007aev.1(ucsc),-transcript') %>% 
  group_by(Transcript, tissue) %>% 
  summarise(avg = mean(expr), minVal = min(expr), 
            maxVal = max(expr), med = median(expr), 
            std = sd(expr))

ggplot(x, 
       aes(x = tissue, y = expr)) +
  facet_wrap(~Transcript) +
  geom_boxplot(fill = 'dodgerblue', alpha = 0.2, 
               colour = 'dodgerblue') +
  stat_summary(fun.y = mean, geom = 'point', size = 2, colour = 'dodgerblue') +
  coord_flip() + 
  theme_xGrid()

ggplot(y, aes(y = tissue)) + 
  scale_color_gradientn(colours = brewer.pal(9, 'PuRd')) +
  geom_segment(aes(x = avg - std, xend = avg + std, yend = tissue),
               size = 2, colour = grey50K, alpha = 0.4) +
  geom_point(aes(x = minVal), colour = softBlack, size = 1.25) + 
  geom_point(aes(x = maxVal), colour = softBlack, size = 1.25) + 
  facet_wrap(~Transcript) + 
  geom_point(aes(x = avg, colour = avg), size = 4) +
  theme_xGrid()



# ggvis implementation ----------------------------------------------------
x %>% ggvis(~tissue, ~ expr) %>% 
  layer_points() %>% 
  add_tooltip(on = 'hover')
  
#   devtools::install_github("hadley/lazyeval", build_vignettes = FALSE)
# devtools::install_github("hadley/dplyr", build_vignettes = FALSE)
# devtools::install_github("rstudio/ggvis", build_vignettes = FALSE)

nasa %>%
  group_by(year, month) %>%
  ggvis(~year, ~month) %>%
  subvis() %>%
  layer_tile(~long, ~lat, fill = ~ozone)
  
