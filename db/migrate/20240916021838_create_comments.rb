class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.string :by
      t.datetime :time
      t.text :text
      t.integer :hn_id
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end
    add_index :comments, :hn_id, unique: true
  end
end
