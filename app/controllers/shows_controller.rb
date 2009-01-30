class ShowsController < ApplicationController
  def index
    @shows = Show.find(:all)
  end

  def show
    @show = Show.find(params[:id])
  end

  def new
    @show = Show.new
  end

  def edit
    @show = Show.find(params[:id])
  end

  def create
    @show = Show.new(params[:show])

    if @show.save
      flash[:notice] = 'Show was successfully created.'
      redirect_to @show
    else
      render :action => "new"
    end
  end

  def update
    @show = Show.find(params[:id])

    if @show.update_attributes(params[:show])
      flash[:notice] = 'Show was successfully updated.'
      redirect_to(@show)
    else
      render :action => "edit"
    end
  end

  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    redirect_to(shows_url)
  end
end
