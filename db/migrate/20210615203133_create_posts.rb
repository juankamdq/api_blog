class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :image
      t.references :category, null: false, foreign_key: true
      t.date :date_created
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
