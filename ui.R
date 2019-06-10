fluidPage(
  # shinythemes::themeSelector(),
  # setBackgroundColor(color = "ghostwhite"),
  useShinydashboard(),
  theme = shinytheme("yeti"),
  titlePanel("Juvenile Salmonid Habitat Calculator"),
  hr(),
  fluidRow(
    column(width = 7,
           shinydrawrUI("fl_dist_drawing"),
           p("Use mouse to draw a line representing a fork length distribution on plot above. Hold mouse button to draw. 
             Release mouse button to display (and update) fork length distribution. The drawn line must span the entire x-axis.
             Click and hold mouse button on plot to edit line. The x-axis shows fork length (mm). The y-axis values are arbitrary 
             and re-scaled to a proportion that sums to one."),
           br(),
           fluidRow(
             column(width = 6,
                    numericInput("total_abundance", label = "Total abundance", min = 0, value = 100000, width = '100%'),
                    valueBox(textOutput("total_habitat"), "Total suitable habitat required (ha)", color = "yellow", width = NULL)),
             column(width = 6,
                    numericInput("total_habitat", label = "Total suitable habitat available (ha)", min = 0, value = 10, width = '100%'),
                    valueBox(textOutput("total_abundance"), "Total capacity", color = "yellow", width = NULL))
           ),
           p("After drawing a fork length distribution, the value boxes display the total suitable habitat required and the total capacity  
             for the specified total abundance and total suitable habitat, respectively. The calculations are based on the salmonid territory 
             size-fork length relationship from Grant and Kramer (1990)."),
           br(),
           p(tags$a(href="https://github.com/fishsciences/juvenile-salmonid-habitat-calculator", "Code on GitHub")),
           p(tags$a(href="https://www.travishinkelman.com/post/free-drawing-distributions-with-shinysense/", "Blog post with more info")),
           br()
    ),
    column(width = 5,
           h3("Fork length distribution"), 
           plotOutput("fl_dist_plot"),
           br(),
           dataTableOutput("fl_dist_table")
    )
  )
)
