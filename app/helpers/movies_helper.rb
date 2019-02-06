module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_id = column == "title" ? "title_header":"release_date_header" 
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:id => css_id, :class => css_class}
  end
end
