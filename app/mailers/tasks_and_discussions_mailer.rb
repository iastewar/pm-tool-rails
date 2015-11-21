class TasksAndDiscussionsMailer < ApplicationMailer
  def notify_project_owner(all_tasks_today, all_discussions_today, users)
    @all_tasks_today = all_tasks_today
    @all_discussions_today = all_discussions_today

    users.each do |owner|
      next unless owner.projects.present?
      @owner = owner
      mail(to: @owner.email, subject: "Today's Project Summary")
    end
  end
end
