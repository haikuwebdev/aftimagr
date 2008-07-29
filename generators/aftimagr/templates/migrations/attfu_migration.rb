class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.integer :size, :height, :width, :parent_id
      t.string :alt, :content_type, :filename, :thumbnail
      t.timestamps
    end
  end
  
  def self.down
    drop_table "<%= table_name %>"
  end
end