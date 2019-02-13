class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = sort_column + " " + sort_direction
    puts "sort param " + @sort
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    puts "filter param ", @selected_ratings
    
    if params[:ratings] != session[:ratings]
      session[:ratings] = @selected_ratings
      redirect_to :ratings => @selected_ratings , :sort => sort_column, :direction => sort_direction and return
    end
    
    @marked = @selected_ratings.keys
    @movies = Movie.order(@sort).with_ratings(@marked)
  end

  def sortable_columns
    ["title", "release_date"]
  end

  def sort_column
    @sort_title = params[:sort] || session[:sort] || "title"
    if params[:sort] != session[:sort]
      session[:sort] = @sort_title
    end 
    @sort_title
  end

  def sort_direction
    @sort_direction = params[:direction] || session[:direction] || "asc"
    if params[:direction] != session[:direction]
      session[:direction] = @sort_direction
    end 
    @sort_direction
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  

end
