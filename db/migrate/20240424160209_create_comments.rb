class CreateComments < ActiveRecord::Migration[7.0]
  def up
    create_table :comments do |t|
      t.string :name
      t.text :text
      t.integer :post_id

      t.timestamps
    end
  end

  def down
    drop_table :comments
  end
end
