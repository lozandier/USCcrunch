class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => 'User'
  attr_accessible :user_id,:receiver_id, :body,:document,:reply,:tweet_id,:post_box
  validates :body, :presence => true
  has_attached_file :document, :styles => {:medium => "300x300>", :thumb => "100x100>"}
  before_post_process :resize_images
  has_one :favorite, :dependent => :destroy

  # Helper method to determine whether or not an attachment is an image.
  def image?
    document_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}
  end

  private

  def resize_images
    return false unless image?
  end
end

