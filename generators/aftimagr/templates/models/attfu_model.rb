class <%= model_class_name %> < ActiveRecord::Base
  <%= "belongs_to :#{name}_category" if options[:with_categories] %>
  
  # You may want to pass other options to has_attachment.
  # See the attachment_fu README.
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 # There is no size restriction on thumbnails.
                 # But you'll want them to fit in the TinyMCE plugin popup dialog.
                 :thumbnails => {:thumbnail => '124'}
  validates_as_attachment
  named_scope :thumbnails, :conditions => {:thumbnail => 'thumbnail'}
end
