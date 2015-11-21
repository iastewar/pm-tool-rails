class TasksController < ApplicationController
  before_action :find_project, only: [:new, :create, :edit, :update, :show]
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy, :done]


  def new
    @task = Task.new
  end

  def create
    @task = Task.new task_params
    @task.project = @p
    @task.done = false
    @task.user = current_user

    if @task.save
      redirect_to project_path(@p), notice: "Task created succussfully!"
    else
      @tasks_done = @p.tasks.where(done: true)
      @tasks_not_done = @p.tasks.where(done: false)
      render :new
    end
  end

  def destroy
    redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :destroy, @task
    task.destroy
    redirect_to project_path(task.project), notice: "Task deleted"

  end

  def edit
    redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :edit, @task
  end

  def update
    redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :update, @task
    if @task.update task_params
      redirect_to project_path(@p)
    else
      render :edit
    end
  end

  def done
    task = Task.find_by_id params[:id]
    redirect_to project_task_path(task.project, task), alert: "Access denied." and return unless can? :update, task
    task.done = task.done ^= true
    if task.done
      TasksMailer.notify_task_owner(task, current_user).deliver_later
      done = "'Done'"
    else
      done = "'Not Done'"
    end
    task.save
    redirect_to project_path(task.project), notice: "#{task.title} marked as #{done}"
  end

  def show

  end

  private

  def task_params
    params.require(:task).permit([:title, :due_date, :body])
  end

  def find_project
    @p = Project.find(params[:project_id])
  end

  def find_task
    @task = Task.find_by_id params[:id]
  end

end
