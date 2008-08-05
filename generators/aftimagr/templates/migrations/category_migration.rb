class <%= categories_migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= categories_table_name %>", :force => true do |t|
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table "<%= categories_table_name %>"
  end
end