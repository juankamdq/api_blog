class UsersController < ApplicationController
    #before_action :authorized, only: [:welcome]

    def sign_up

        @user = User.create(params_user)

        if @user.valid?
           token = encode_token ({ id: @user.id})
           render json: { Status: "ok", Token: token}
        else 
            render json: { Message: "Account hasn't been created", Status: false}, status: un
        end
        


    end


    def welcome
        render json: { Message: "Bienvenido" }
    end


    private

    def params_user
        params.permit(:email, :password)
    end

end
