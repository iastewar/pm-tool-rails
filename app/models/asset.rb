class Asset < ActiveRecord::Base
  belongs_to :project
  validates :file, presence: true
  mount_uploader :file, FileUploader

end
