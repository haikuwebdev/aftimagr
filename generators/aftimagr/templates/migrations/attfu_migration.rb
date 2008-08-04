class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.integer :size
      t.integer :height
      t.integer :width
      t.integer :parent_id
      <%- if options[:with_categories] -%>
      t.integer <%= ":#{name}_category_id" %>  
      <%- end -%>
      t.string :alt
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.timestamps
    end
  end
  
  def self.down
    drop_table "<%= table_name %>"
  end
end