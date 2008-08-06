class <%= model_class_name %> < ActiveRecord::Base
  <%- if options[:with_categories] -%>
  belongs_to :category, :class_name => '<%= category_class_name %>', :foreign_key => '<%= category_name %>_id'
  <%- end -%>
  
  # You may want to pass other options to has_attachment.
  # See the attachment_fu README.
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 # There is no size restriction on thumbnails.
                 # But you'll probably want them to fit in the TinyMCE plugin popup dialog.
                 :thumbnails => {:small => '124'}
  validates_as_attachment
  named_scope :thumbnails, :conditions => {:thumbnail => 'thumbnail'}
end
