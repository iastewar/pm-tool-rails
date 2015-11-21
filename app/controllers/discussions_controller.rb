class DiscussionsController < ApplicationController
  before_action :find_project, only: [:create, :edit, :update, :show, :index]
  before_action :find_discussion, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:create, :edit, :update, :destroy]

  def create
    @discussion = Discussion.new discussion_params
    @discussion.project = @p
    @discussion.user = current_user

    if @discussion.save
      redirect_to project_discussions_path(@p), notice: "Discussion created succussfully!"
    else
      @discussions = @p.discussions.order(created_at: :desc)
      render "discussions/index"
    end
  end

  def destroy
    redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :destroy, @discussion
    @discussion.destroy
    redirect_to project_path(@discussion.project), notice: "Discussion deleted"
  end

  def show
    @comments = @discussion.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  def edit
    redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :edit, @discussion
    @discussions = @p.discussions.order(created_at: :desc)
    render "discussions/index"
  end

  def index
    @discussions = @p.discussions.order(created_at: :desc)
    @discussion = Discussion.new
  end

  def update
    redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :update, @discussion
    if @discussion.update discussion_params
      redirect_to project_discussions_path(@p)
    else
      @discussions = @p.discussions.order(created_at: :desc)
      render "discussions/index"
    end
  end

  private

  def discussion_params
    params.require(:discussion).permit([:title, :description])
  end

  def find_project
    @p = Project.find(params[:project_id])
  end

  def find_discussion
    @discussion = Discussion.find_by_id params[:id]
  end

end
