class ImportentLink < ActiveRecord::Base
  attr_accessible :title, :links, :user_id,:link_document
  validates :title, :links,:presence => true
  belongs_to :user
  has_attached_file :link_document,
    :whiny => false,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "uploaded_files/profile/:id/:style/:basename.:extension",
    :bucket => "edupost",
    :styles => {
    :original => "900x900>",
    :default => "280x190>",
    :other => "96x96>" } if Rails.env == 'production'
  has_attached_file :link_document,:styles => {:original => "900x900>", :default => "280x190>" } if Rails.env == 'development'
end
