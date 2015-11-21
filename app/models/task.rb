# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string
#  due_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#

class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :title, presence: true,
                    uniqueness: {scope: :project}

end
