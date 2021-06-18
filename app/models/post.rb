class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user


  validates :title, presence: true
  validates :image, presence: true#, format: { with: /^.*\.(jpg|gif|png|jpeg)/ }
  validates :content, presence: true
   
end
 