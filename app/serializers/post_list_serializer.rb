class PostListSerializer < ActiveModel::Serializer
  attributes :id, :title, :image, :category, :created_at
  
end
