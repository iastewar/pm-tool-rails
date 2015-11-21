class FavouritesController < ApplicationController
  before_action :authenticate_user

  def create
    fav          = current_user.favourites.new
    project     = Project.find params[:project_id]
    redirect_to project_path(project), alert: "Access denied." and return if can? :manage, project
    # fav.user     = current_user
    fav.project = project
    if fav.save
      redirect_to project_path(project), notice: "Favourited!"
    else
      redirect_to project_path(project), alert: "Error occured!"
    end
  end

  def destroy
    project = Project.find params[:project_id]
    redirect_to project_path(project), alert: "Access denied." and return if can? :manage, project
    fav      = current_user.favourites.find params[:id]
    fav.destroy
    redirect_to project_path(project), notice: "Unfavourited!"
  end

  def index
    @favourites = current_user.favourites
  end

end
