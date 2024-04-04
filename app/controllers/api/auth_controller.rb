require 'jwt'

class Api::AuthController < ApplicationController

    def create
        
        if check_params
            user = User.find_by(email: user_params[:email], password: user_params[:password])
            if user
                payload = {id: user.id, email: user_params[:email], password: user_params[:password]}
                token = user.id.to_s + (JWT.encode payload, "SK", "HS256")[0..-2]
                @token = user.tokens.create(token: token)
                if @token.save
                    render json: {jwt: token}, status: :ok
                else
                    render json: @token.errors, status: :unprocessable_entity
                end
            else
                render status: :unauthorized
            end
        else
            render status: 400
        end
    
    end

    def destroy
        token = request.headers['Authorization'][7..-1]
        if Token.find_by(token: token)
            Token.where(user_id: token[0]).destroy_all
            render status: :ok
        else
            render status: :unprocessable_entity
        end
    end

    private def user_params
        params.require(:user).permit(:email, :password)
    end

    private def check_params
        return ((params["user"].include? :email) and (params["user"].include? :password))
    end

end
