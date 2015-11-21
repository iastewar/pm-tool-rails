# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  due_date    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base
#  serialize :task_array, Array
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :discussions, dependent: :destroy

  has_many :members, dependent: :destroy
  has_many :member_users, through: :members, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :favourites, dependent: :destroy
  has_many :favouriting_users, through: :favourites, source: :user

  validates :title, presence: true,
                    uniqueness: true

  def joined_by?(user)
    join_for(user).present?
  end

  def join_for(user)
    members.find_by_user_id(user.id)
  end

  def favourited_by?(user)
    favourite_for(user).present?
  end

  def favourite_for(user)
    favourites.find_by_user_id user.id
  end


end
