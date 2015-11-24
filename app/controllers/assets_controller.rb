class AssetsController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy]

  def create
    asset_params = params.require(:asset).permit(:file)
    @p = Project.find params[:project_id]
    @asset = Asset.new asset_params
    @asset.project = @p

    if @asset.save
      redirect_to project_path(@p), notice: "Asset created succussfully!"
    else
      @assets = @p.assets.order(created_at: :desc)
      render "projects/show"
    end
  end

  def destroy
    asset = Asset.find_by_id params[:id]
    if asset
      redirect_to project_path(params[:project_id]), alert: "Access denied." and return unless can? :destroy, asset
      asset.destroy
      redirect_to project_path(asset.project), notice: "Asset deleted"
    else
      redirect_to project_path(params[:project_id]), notice: "Asset already deleted"
    end

  end
end
