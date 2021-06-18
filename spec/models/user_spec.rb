require 'rails_helper'

RSpec.describe User, type: :model do

  context "validation of user" do 

  

  it 'normal created' do
    user = User.new(email:"juan",password:"1234").save
    
    expect(user).to eq(true)


  end


  it 'whitout mail' do
    user = User.new(password:"1234").save
    
    expect(user).to eq(false)


  end




  end
end
