# == Schema Information
#
# Table name: discussions
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :title, presence: true

end
