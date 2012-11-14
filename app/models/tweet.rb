class Tweet < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id,:receiver_id, :body,:document,:reply,:tweet_id
  validates :body, :presence => true
#  has_attached_file :document, :styles => {:medium => "300x300>", :thumb => "100x100>"}
  has_attached_file :document,
    :default_url => '/assets/avatar.png',
    :whiny => false,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => "uploaded_files/profile/:id/:style/:basename.:extension",
    :bucket => S3_BUCKET_NAME,
    :styles => {
    :original => "300x300>",
    :default => "280x190>",
    :other => "100x100>" }
  has_one :favorite, :dependent => :destroy
end
