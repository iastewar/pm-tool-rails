class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy
  has_many :discussions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :members, dependent: :destroy
  has_many :member_projects, through: :members, source: :project

  has_many :favourites, dependent: :nullify
  has_many :favourite_projects, through: :favourites, source: :project

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
