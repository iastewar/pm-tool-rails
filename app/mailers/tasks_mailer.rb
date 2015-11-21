class TasksMailer < ApplicationMailer
  def notify_task_owner(task, current_user)
    @task   = task
    @owner    = @task.user
    if @owner == current_user
      return
    end
    if @owner.email.present?
      mail(to: @owner.email, subject: "You got a new comment!")
    end
  end
end
