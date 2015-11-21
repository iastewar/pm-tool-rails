namespace :email_task_discussion_summary do

  desc "Generate a summary of all comments created today for each post owner and email it to them"
  task gen_email_task_discussion_summary: :environment do
    all_tasks_today = Task.where("created_at >= ?", 1.day.ago)
    all_discussions_today = Discussion.where("created_at >= ?", 1.day.ago)
    TasksAndDiscussionsMailer.notify_project_owner(all_tasks_today, all_discussions_today, User.all).deliver_now
  end


end
