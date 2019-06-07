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
  
  output$fl_dist_table <- renderTable(select(flData(), -HabitatProp), digits = 4)
  output$total_habitat <- renderText(round(sum(flData()$HabitatProp) * input$total_abundance* 10000)/10000)
  output$total_abundance <- renderText(round(input$total_habitat / sum(flData()$HabitatProp)))
  
}
