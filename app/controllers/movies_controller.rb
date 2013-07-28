class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def store_params_in_session
    store_ratings
    store_sort

  end

  def store_sort
    if params.has_key?(:sort)
      @sort = session[:sort] = params[:sort]
    elsif session.has_key?(:sort)
      @sort = session[:sort]
    # else 
    #   @sort = session[:sort] = @all_ratings
    end

  end

  def store_ratings
    if params.has_key?(:ratings)
      @ratings_filter = session[:ratings_filter] = params[:ratings].keys
    elsif params.has_key?(:ratings_filter)
      @ratings_filter = session[:ratings_filter]= params[:ratings_filter]
    elsif session.has_key?(:ratings_filter)
      @ratings_filter = session[:ratings_filter]
    else 
      @ratings_filter = session[:ratings_filter] = @all_ratings
    end
  end

  def index
    @all_ratings = Movie.all_ratings

    store_params_in_session

    # @sort = params[:sort]
    # if params.has_key?(:ratings)
    #   @ratings_filter = params[:ratings].keys
    # elsif params.has_key?(:ratings_filter)
    #   @ratings_filter = params[:ratings_filter]
    # else 
    #   @ratings_filter = @all_ratings
    # end

    case @sort
    when "title"
      @movies = Movie.where(rating: @ratings_filter).find(:all, :order => "title") #.find(:all, :order => "title")
    when "release_date"
      @movies = Movie.where(rating: @ratings_filter).find(:all, :order => "release_date")
    else 
      @movies = Movie.where(rating: @ratings_filter)
    end

  end

  def new
    # default: render 'new' template
    # @movie = Movie.new
  end

  def create
    @movie = Movie.create!(params[:movie])
    # @movie - Movie.new(params[:movie])
    # if @movie.save
      # flash carries info across a single redirect (all other info is zapped)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    # else
    #   render 'new'
    # end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
