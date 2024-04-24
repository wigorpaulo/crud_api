class CreatePosts < ActiveRecord::Migration[7.0]
  def up
    create_table :posts do |t|
      t.string :title
      t.text :text
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
