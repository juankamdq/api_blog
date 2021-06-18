class ApplicationController < ActionController::API

    def encode_token(payload)
        JWT.encode payload,"secret",'HS256'
    end

    def decode_token
         
        authorization = request.headers['Authorization']

        if authorization         
            token = request.headers['Authorization'].split(' ')[1]   
            decoded_token = JWT.decode(token, 'secret', true, algorithm: 'HS256')
            @user_id = decoded_token[0]["user_id"]
        end
        
    end


    def authorized

        if !request.headers['Authorization']
            render json: { Message: "You aren't authorized"}, status: :unauthorized
        end

    end







end
