class ApplicationController < ActionController::API

    def encode_token(payload)
        
        JWT.encode payload,"secret",'HS256'

    end

    def decode_token

        if request.headers['Authorization']

            byebug
            encoded_token = request.headers['Authorization'].split(' ')[1]
            
            token = JWT.decode(encoded_token, 'secret', true, algorithm: 'HS256')
            user = token[0]['user_id']
        end
        
        

    end


    def authorized

        if !request.headers['Authorization']
            render json: { Message: "No estas autorizado"}, status: :unauthorized
        end

    end







end
