class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def retrieve_params_from_session

    if params.has_key?(:sort)
      @sort = session[:sort] = params[:sort]
    elsif session.has_key?(:sort)
      @sort = session[:sort]
    else
      @sort = "no_sort"
    end

    if params.has_key?(:ratings)
      @ratings = session[:ratings] = params[:ratings]
      # @ratings_filter = @ratings.keys
    elsif session.has_key?(:ratings)
      @ratings = session[:ratings]
      # @ratings_filter = @ratings
    else 
      all = Hash.new
      Movie.all_ratings.each {|rate| all["#{rate}"] = "1"}
      @ratings = session[:ratings] = all
    end
    @ratings_filter = @ratings.keys

    flash.keep
    redirect_to movies_path(:sort => @sort, :ratings => @ratings)

  end

  def index
    @all_ratings = Movie.all_ratings

    retrieve_params_from_session unless params.has_key?(:sort) && params.has_key?(:ratings)

    if params.has_key?(:sort)
      @sort = session[:sort] = params[:sort]
    end

    if params.has_key?(:ratings)
      @ratings = session[:ratings] = params[:ratings]
      @ratings_filter = @ratings.keys
    end

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
    session.clear
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
