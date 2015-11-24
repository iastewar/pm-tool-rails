class TasksController < ApplicationController
  before_action :find_project, only: [:new, :create, :edit, :update, :show, :done]
  before_action :find_task, only: [:show, :edit, :update, :destroy, :done]
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy, :done]


  def new
    @task = Task.new
  end

  def create
    @task = Task.new task_params
    @task.project = @p
    @task.done = false
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_path(@p), notice: "Task created succussfully!" }
        format.js { render :create_success }
      else
        @tasks_done = @p.tasks.where(done: true)
        @tasks_not_done = @p.tasks.where(done: false)
        format.html { render :new }
        format.js { render :create_failure}
      end
    end
  end

  def destroy
    respond_to do |format|
      redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :destroy, @task
      @task.destroy
      format.html { redirect_to project_path(@task.project), notice: "Task deleted" }
      format.js { render }
    end
  end

  def edit
    redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :edit, @task
  end

  def update
    redirect_to project_task_path(@p, @task), alert: "Access denied." and return unless can? :update, @task
    respond_to do |format|
      if @task.update task_params
        format.html { redirect_to project_path(@p) }
        format.js { render :update_success }
      else
        format.html { render :edit }
        format.js { render :update_failure }
      end
    end
  end

  def done
    redirect_to project_task_path(@task.project, @task), alert: "Access denied." and return unless can? :update, @task
    @task.done = @task.done ^= true
    if @task.done
      TasksMailer.notify_task_owner(@task, current_user).deliver_later
      done = "'Done'"
    else
      done = "'Not Done'"
    end
    @task.save
    respond_to do |format|
      format.html { redirect_to project_path(task.project), notice: "#{@task.title} marked as #{done}" }
      format.js { render :done }
    end
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
