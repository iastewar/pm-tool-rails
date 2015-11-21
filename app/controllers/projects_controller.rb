class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @p = Project.new
  end

  def create
    @p = Project.new(project_params)
    @p.user = current_user
    if @p.save
      redirect_to(project_path(@p), notice: "Project created!")
    else
      render :new
    end
  end

  def show
    @tasks_done = @p.tasks.where(done: true)
    @tasks_not_done = @p.tasks.where(done: false)
    @task = Task.new
    @members = @p.member_users
  end

  def edit
    redirect_to project_path(@p), alert: "Access denied." and return unless can? :edit, @p
  end

  def update
    redirect_to project_path(@p), alert: "Access denied." and return unless can? :update, @p
    if @p.update project_params
      redirect_to(project_path(@p))
    else
      render :edit
    end
  end

  def index
    @projects = Project.all
  end

  def destroy
    redirect_to project_path(@p), alert: "Access denied." and return unless can? :destroy, @p
    @p.destroy
    flash[:notice] = "Project deleted successfully"
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit([:title, :description, :due_date, {tag_ids: []}])
  end

  def find_project
    @p = Project.find params[:id]
  end
end
