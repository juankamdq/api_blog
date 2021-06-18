class AddStatusToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :content, :image, :status, default: true
  end
end

 