class CommentsMailer < ApplicationMailer
  def notify_discussion_owner(comment)
    @comment   = comment
    @discussion = comment.discussion
    @owner    = @discussion.user
    if @owner == comment.user
      return
    end
    if @owner.email.present?
      mail(to: @owner.email, subject: "You got a new comment!")
    end
  end

end
