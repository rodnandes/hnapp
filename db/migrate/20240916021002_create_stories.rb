class CreateStories < ActiveRecord::Migration[7.2]
  def change
    create_table :stories do |t|
      t.string :by
      t.datetime :time
      t.text :text
      t.string :url
      t.integer :score
      t.string :title
      t.integer :comment_count
      t.integer :hn_id

      t.timestamps
    end
    add_index :stories, :hn_id, unique: true
  end
end
