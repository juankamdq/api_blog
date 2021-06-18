class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :password, length: { in: 6..20}, presence: true
    
    has_many :posts
end
