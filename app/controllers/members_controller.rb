class MembersController < ApplicationController
  before_action :authenticate_user

  # POST /projects/12/members
  def create
    member          = Member.new
    project      = Project.find params[:project_id]
    member.project = project
    redirect_to project_path(project), alert: "Access denied." and return if can? :edit, project
    member.user     = current_user
    if member.save
      #MembersMailer.notify_project_owner(member).deliver_later
      redirect_to project_path(project), notice: "Thanks for joining!"
    else
      redirect_to project_path(project), alert: "Can't join! Joined already?"
    end
  end

  def destroy
    project = Project.find params[:project_id]
    redirect_to project_path(project), alert: "Access denied." and return if can? :edit, project
    member     = current_user.members.find params[:id]
    member.destroy
    redirect_to project_path(project), notice: "Unjoined!"
  end

end
