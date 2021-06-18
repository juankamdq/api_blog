class UsersController < ApplicationController
    before_action :authorized, only: [:welcome]

    def sign_up

        @user = User.create(params_user)

        if @user.valid?
           token = encode_token ({ user_id: @user.id})
           render json: { Status: "ok", Token: token}
        else 
            render json: @user.errors 
        end
        
    end

    def login

        @user = User.find_by_email(params[:email])

        if @user && @user.authenticate(params[:password])

            token = encode_token ({ user_id: @user.id })
            render json: { 
                Message: "Welcome #{@user.email}",
                Token: token
            }

        else 
            render json: { Message: "Sorry email/password invalid!!!!"}, status: :not_found
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
