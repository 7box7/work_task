class Api::CoursesController < ApplicationController
    before_action :check_auth

    def index
        id_teach = 0
        id_stud = 0
        pagination = {:page => 1, :limit => 50}

        if params.include? :pagination
            pagination = {:page => params[:pagination][:page], :limit => params[:pagination][:limit] % 1000}
        end

        if params.include? :id_teach
            id_teach = params[:id_teach]
        end

        if params.include? :id_stud
            id_stud = params[:id_stud]
        end
        
        if (id_stud != 0) and (id_teach != 0)
            courses = Course.where(user_id: id_teach).joins(:participants).where("participants.user_id" => id_stud).offset((pagination[:page] - 1) * pagination[:limit]).take(pagination[:limit])
        elsif (id_stud != 0)
            courses = Course.joins(:participants).where("participants.user_id" => id_stud).offset((pagination[:page] - 1) * pagination[:limit]).take(pagination[:limit])
        elsif (id_teach != 0)
            courses = Course.where(user_id: id_teach).offset((pagination[:page] - 1) * pagination[:limit]).take(pagination[:limit])
        else
            courses = Course.offset((pagination[:page] - 1) * pagination[:limit]).take(pagination[:limit])
        end
        
        if courses
            render json: courses, status: :ok
        else
            render status: :unprocessable_entity
        end

    end


    def show
        course = Course.find(params[:id])
        if course
            teacher = User.find(course.user_id)
            students = Participant.where(:course => course.id)
            number = 0
            if students
                number = students.count
            end
            render json: {
                title:  course.title,
                description: course.description,
                fio_of_teacher: teacher.fio,
                number_of_students: number
            }, status: :ok
        else
            render status: :unprocessable_entity
        end
    end


    def subscribe
        if !@user.teacher
            course = Course.find(params[:course_id])
            if course
                if !Participant.find_by(:user => @user, :course => course)
                    participant = Participant.new(:user => @user, :course => course)
                    participant.save
                    render status: :ok
                else
                    render status: :unprocessable_entity
                end
            else
                render status: :unprocessable_entity
            end
        else
            render status: :forbidden
        end
    end


    def create
        if check_course_params
            if @user.teacher
                @course = Course.new(:title => course_params[:title], :description => course_params[:description], :user => @user)
                @course.save
                render json: {
                    fio_of_teacher: @user.fio,
                    name_of_course: @course.title,
                    description_of_course: @course.description
                }, status: :ok
            else
                render status: :forbidden
            end
        else
            render status: :bad_request
        end
    end

    private def check_auth
        if check_token
            token = request.headers['Authorization'][7..-1]
            decoded_token = JWT.decode token, nil, false
            @user = User.find_by(id: decoded_token[0]["id"], jwt_validation: decoded_token[0]["jwt_validation"])
            if !@user
                render status: :unauthorized
            end
        else
            render status: :unauthorized
        end
    end

    private def check_course_params
        return ((params["course"].include? :title) and (params["course"].include? :description))
    end

    private def course_params
        params.require(:course).permit(:title, :description)
    end

    private def check_token
        return request.headers['Authorization']
    end

end
