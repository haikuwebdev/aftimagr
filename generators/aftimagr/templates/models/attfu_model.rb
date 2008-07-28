class <%= model_class_name %> < ActiveRecord::Base
  # You may want to pass other options to has_attachment.
  # See the attachment_fu README.
  has_attachment :content_type => :image,
                 # There is no size restriction on thumbnails.
                 # But you'll want them to fit in the TinyMCE plugin popup dialog.
                 :thumbnails => {:thumbnail => '124'}
  validates_as_attachment
  named_scope :thumbnails, :conditions => {:thumbnail => 'thumbnail'}
end
