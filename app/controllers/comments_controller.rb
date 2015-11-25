class CommentsController < ApplicationController
  before_action :find_project, only: [:create, :edit, :update]
  before_action :find_discussion, only: [:create, :edit, :update]
  before_action :find_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user, only: [:create, :edit, :update, :destroy]



  def create
    @comment = Comment.new comment_params
    @comment.discussion = @discussion
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        CommentsMailer.notify_discussion_owner(@comment).deliver_later
        format.html { redirect_to project_discussion_path(@p, @discussion), notice: "Comment created succussfully!" }
        format.js { render :create_success }
      else
        @comments = @discussion.comments.order(created_at: :desc)
        format.html { render "discussions/show" }
        format.js { render :create_failure }
      end
    end
  end

  def destroy
    redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :destroy, @comment
    respond_to do |format|
      @comment.destroy
      format.html { redirect_to project_discussion_path(params[:project_id], params[:discussion_id]), notice: "Comment deleted" }
      format.js { render }
    end
  end

  def edit
    respond_to do |format|
      redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :edit, @comment
      @comments = @discussion.comments.order(created_at: :desc)
      format.html { render "discussions/show" }
      format.js { render }
    end
  end

  def update
    redirect_to project_discussion_path(@p, @discussion), alert: "Access denied." and return unless can? :update, @comment
    respond_to do |format|
      if @comment.update comment_params
        format.html { redirect_to project_discussion_path(@p, @discussion) }
        format.js { render :update_success }
      else
        @comments = @discussion.comments.order(created_at: :desc)
        format.html { render "discussions/show" }
        format.js { render :update_failure }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_project
    @p = Project.find params[:project_id]
  end

  def find_comment
    @comment = Comment.find params[:id]
  end

  def find_discussion
    @discussion = Discussion.find params[:discussion_id]
  end


end
