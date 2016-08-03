sm = data  %>% slice(1:100)
smTidy = sm  %>% select(Transcript, contains("mean"))

smTidy = smTidy  %>% 
  mutate(aorta = AOR_mean, atria = ATR_mean, dia = DIA_mean, EDL = EDL_mean, 
         eye = EYE_mean, LV = LV_mean, RV = RV_mean, soleus = SOL_mean)%>% 
  select(-contains("mean")) %>% 
  gather(tissue, expr, -Transcript)

labCol = "#41b6c4"

df = data.frame(x = 380, y = 1,
                labels = c("uc007aey.1"))

smTidy %>% filter(Transcript == "uc007aey.1") %>% 
  ggvis(x= ~tissue, y = ~expr, fill := "#225ea8", 
        strokeWidth := 1) %>% 
  layer_bars() %>% 
      add_axis("y", title = 'expression (FPKM)',
               title_offset=60, 
               ticks = 5,
               tick_padding = 10,
               properties = axis_props(
                 title = list(fontSize = 20),
                 axis = list(stroke = NA),
                 grid = list(strokeWidth = 0.5),
                 labels = list(fontSize = 16))) %>% 
  add_axis("x", title = 'tissue',
           title_offset=45, 
           properties = axis_props(
             title = list(fontSize = 20),
             axis = list(strokeWidth = 2),
             grid = list(stroke = NA),
             labels = list(fontSize = 16))) %>% 
  layer_text(data = df, text := ~labels, x := ~ x, y := ~ y - 20, 
             fontSize := 16, fontWeight := 'bold', fill := labCol, align := 'right') %>% 
  layer_text(data = df, text := ~labels, x := ~ x , y := ~ y , 
             fontSize := 16, fill := labCol, align := 'right')