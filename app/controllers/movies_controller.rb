class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    path_info = request.env['PATH_INFO']
    
    # Clear the sessiom if no query params are passed as part of the get request.
    if path_info == '/'
      session.clear
    end

    @allRatings = Movie.all_ratings

    check_Rating_Param = (params[:ratings].nil?)
    check_Sessions_Param = (session[:ratings_to_show].nil? )
    rates = check_Rating_Param ? ( check_Sessions_Param ? 
                            @allRatings : JSON.parse(session[:ratings_to_show])) : params[:ratings].keys
    
    if params[:sort]
      session[:sort] = params[:sort]
      sort = params[:sort]
    elsif session[:sort]
      sort = session[:sort]
    end      
      
    @ratings_to_show = rates
  
    
    if (sort == "release_date")
      @movies = Movie.with_ratings(rates).order(:release_date)
      
    elsif (sort == "title") 
      @movies = Movie.with_ratings(rates).order(:title)
      
    
    elsif (sort != "release_date" and sort != "title")
      @movies = Movie.with_ratings(rates)
    end
    
    session[:ratings_to_show] = JSON.generate(rates)
    session[:ratings] = params[:ratings]
    @sort = sort
      
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end