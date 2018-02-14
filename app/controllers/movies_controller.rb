class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.key?(:ratings)
      @filtered_ratings = params[:ratings].keys
      @movies = Movie.order(params[:sort]).where(rating: @filtered_ratings)
    else
      @movies = Movie.order(params[:sort])
      @filtered_ratings = Movie.all_ratings
    end
    @all_ratings = Movie.all_ratings
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
  
  def ratings
    @all_ratings = Movie.Ratings
  end
  
  def sort_title
    @movies = Movie.order(params[:title])
    redirect_to movies_path
  end
  
  def sort_date
    @movies = Movie.order(params[:release_date])
    redirect_to movies_path
  end

end
