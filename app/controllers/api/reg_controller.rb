class Api::RegController < ApplicationController

    def create
        puts params
        if check_params
            o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
            string = (0...32).map { o[rand(o.length)] }.join
            
            @user = User.new(fio: user_params[:fio], email: user_params[:email], password: user_params[:password], teacher: user_params[:teacher], jwt_validation: string)
            if @user.save
                render json: @user, status: :ok
            else
                render json: @user.errors, status: :unprocessable_entity
            end
        else
            render status: 400
        end
    end

    private def user_params
        params.require(:user).permit(:fio, :email, :password, :teacher)
    end

    private def check_params
        return ((params["user"].include? :fio) and (params["user"].include? :email) and (params["user"].include? :password) and (params["user"].include? :teacher))
    end

end
