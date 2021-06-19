require 'rails_helper'

RSpec.describe "Users", type: :request do
  
  describe "POST #SIGN UP /auth/signup" do
     it "create user" do 
    
     post '/auth/sign_up', params: {
       user: {
         email: 'juan',
         password: '123456'
       }
     }

     expect(response).to have_http_status(:create)
    end
  end


  describe "POST #SIGN UP /auth/signup" do
    it "whitot email" do 
    
      post '/auth/sign_up', params: {
        user: {
          password: '123456'
        }
      }
 
      expect(response).to have_http_status(:create)
    
    end
  end
end
  