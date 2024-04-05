require 'jwt'
require "time"

class Api::SessionController < ApplicationController

    def create
        
        if check_params
            user = User.find_by(email: user_params[:email], password: user_params[:password])
            if user
                payload_new = {id: user.id, email: user.email, password: user.password, jwt_validation: user.jwt_validation, created_at: Time.now}
                token_new = (JWT.encode payload_new, "SK", "HS256")[0..-2]
                if token_new
                    render json: {jwt: token_new}, status: :ok
                else
                    render status: :unprocessable_entity
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
        decoded_token = JWT.decode token, nil, false
        user = User.find_by(id: decoded_token[0]["id"], jwt_validation: decoded_token[0]["jwt_validation"])
        if user
            o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
            string = (0...32).map { o[rand(o.length)] }.join

            user.jwt_validation = string
            user.save
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
