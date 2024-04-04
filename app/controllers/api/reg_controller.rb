class Api::RegController < ApplicationController

    def create
        puts params
        if check_params
            @user = User.new(user_params)
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
