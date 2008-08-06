class <%= model_class_name %>Category < ActiveRecord::Base
  has_many :<%= plural_name %>

  def self.default
    find(:first)
  end

  def thumbnails
    <%= plural_name %>.collect{ |image| image.thumbnails(:small) }.flatten
  end
end
