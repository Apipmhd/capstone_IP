#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$table_lazada <- renderDataTable({
    
    # data datatable
    datatable(
      lazada,
      options = list(scrollX = T, scrollY = T)
    )
  })
  
  output$plot1 <- renderPlotly({
    
    # Data preparation
    # Ambil dari DD no 1
    lazada_count <- lazada %>% 
      group_by(category) %>% 
      summarise(count= n()) %>% 
      arrange(-count)
    
    lazada_count <- lazada_count %>% 
      mutate(
        label = glue(
          "Category: {category}
      Video Count: {count}"
        )
      )
    
    # Visualisasi plot statis
    plot1 <- ggplot(data = lazada_count, aes(x = count, 
                                           y = reorder(category, count),
                                           text = label)) + # reorder(A, berdasarkan B)
      geom_col(aes(fill = count)) +
      scale_fill_gradient(low="#FF420E", high="pink") +
      labs(title = "Trending Categories Review 2019",
           x = "Review Count",
           y = NULL) +
      theme_minimal() +
      theme(legend.position = "none")
    
    # Visualisasi plot interaktif
    ggplotly(plot1, tooltip = "text")
  })
  
  
  
  output$plot2 <- renderPlotly({
    
    # Data preparation
    lazada_count_brand <- lazada %>% 
      group_by(brandName) %>% 
      summarise(count= n()) %>% 
      arrange(desc(count)) %>% 
      top_n(10)
    
    lazada_count_brand <- lazada_count_brand %>% 
      mutate(
        label = glue(
          "brandName: {brandName}
        Video Count: {count}"
        )
      )
    
    # Visualisasi plot statis
    plot2 <- ggplot(data = lazada_count_brand, aes(x = count, 
                                                   y = reorder(brandName, count),
                                                   text = label)) +
      geom_col(aes(fill = count)) +
      scale_fill_gradient(low="#FF420E", high="pink") +
      labs(title = "Top 10 Trending Categories Review 2019",
           x = "Review Count",
           y = NULL) +
      theme_minimal() +
      theme(legend.position = "none")
    
    # Visualisasi plot interaktif
    ggplotly(plot2, tooltip = "text")
  })
  
  output$plot3 <- renderPlotly({
  
  # Data preparation
  top_10_brands <- lazada %>%
    group_by(brandName) %>%
    summarise(total_price = sum(price)) %>%
    top_n(10, total_price) %>%
    arrange(desc(total_price))
  
  top_10_brands <- top_10_brands %>%
    mutate(
      label = glue("Brand: {brandName}\nTotal Price: {total_price}")
    )
  
  # Visualizing the plot
  plot3 <- ggplot(data = top_10_brands, aes(x = reorder(brandName, -total_price),
                                            y = total_price,
                                            text = label)) +
    geom_col(aes(fill = total_price), width = 0.8, position = "identity") +
    scale_fill_gradient(low = "#FF420E", high = "pink") +
    labs(title = "Top 10 Brands by Total Price",
         x = NULL,
         y = "Total Price") +
    theme_minimal() +
    theme(legend.position = "none")
  
  # Converting to interactive plot
  ggplotly(plot3, tooltip = "text")
})
  
  
  output$plot4 <- renderPlotly({
    
    # Data preparation
    lazada_top10 <- lazada %>%
      filter(brandName==input$select_category) %>% 
      group_by(name) %>% 
      summarise(mean_views = mean(totalReviews)) %>% 
      arrange(-mean_views) %>% 
      head(10)
    

    lazada_top10 <- lazada_top10 %>% 
      mutate(
        label = glue(
          "Channel: {name}
      Average Views: {comma(round(mean_views,2))}"
        )
      )
    
    # Visualisasi plot statis
    plot4 <- ggplot(lazada_top10, 
                    aes(x = mean_views,
                        y = reorder(name, mean_views),
                        color = mean_views,
                        text = label)) +
      geom_point(size = 1) +
      geom_segment(aes(x = 0, 
                       xend = mean_views,
                       y = name, 
                       yend = name),
                   size = 1.5) +
      scale_color_gradient(low = "red",
                           high = "orange") +
      scale_x_continuous(labels = comma) +
      labs(name = glue("Top 10 {input$select_category} Channel"),
           x = "Average Views",
           y = NULL) +
      theme_minimal() +
      theme(legend.position = "none",
            plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
            axis.text.y = element_text(hjust = 0, vjust = 0.5, face = "wrap"))
    
    
    # Visualisasi plot interaktif
    ggplotly(plot4, tooltip = "text")
  })
  

  
}
