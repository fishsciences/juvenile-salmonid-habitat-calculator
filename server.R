function(session, input, output) {
  rv = reactiveValues(FL = NULL)
  #server side call of the drawr module
  drawChart <- callModule(
    shinydrawr,
    "fl_dist_drawing",
    data = empty_data,
    draw_start = cutoff,
    raw_draw = TRUE,
    x_key = "ForkLength_mm",
    y_key = "Value",
    y_min = 0,
    y_max = 100
  )
  
  #logic for what happens after a user has drawn their values. Note this will fire on editing again too.
  observeEvent(drawChart(), {
    drawnValues = drawChart()
    
    rv$FL <- empty_data %>%
      filter(ForkLength_mm > cutoff) %>%
      mutate(Proportion = drawnValues/sum(drawnValues)) %>%
      select(-Value)
  })
  
  flData <- reactive({
    req(rv$FL)
    rv$FL %>% mutate(HabitatProp = calc_territory_size(ForkLength_mm) * Proportion)
  })
  
  output$fl_dist_plot <- renderPlot({
    ggplot(flData() %>% bind_rows(tibble(ForkLength_mm = 25, Proportion = 0)), aes(x = ForkLength_mm)) + # adding an entry at 25 mm to make bins line up
      geom_histogram(aes(weight = Proportion), binwidth = 5, alpha = 0.5, color = "black") +
      labs(x = "Fork length (mm)", y = "Proportion") +
      scale_x_continuous(breaks = seq(25, 105, 5)) +
      coord_cartesian(xlim = c(empty_data$ForkLength_mm)) +
      theme_minimal()
  })
  
  output$fl_dist_table = renderDT({
    flData() %>% mutate(Proportion = round4dec(Proportion)) %>% select(-HabitatProp) %>% rename(`Fork length (mm)` = ForkLength_mm)
  }, style = "bootstrap", rownames = FALSE,
  options = list(pageLength = 16, bLengthChange = FALSE, bPaginate = TRUE, searching = FALSE))
  
  output$total_habitat <- renderText({
    round4dec(sum(flData()$HabitatProp) * input$total_abundance)
  })
  
  output$total_abundance <- renderText({
    format(round(input$total_habitat / sum(flData()$HabitatProp)), big.mark = ",")
  })
  
}
