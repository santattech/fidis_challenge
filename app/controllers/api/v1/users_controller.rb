module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_request, only: [:upload_images, :get_images]

      def create
        User.transaction do
          @user = User.create(email: user_param[:email], password: user_param[:password].to_s, password_confirmation: user_param[:confirm_password].to_s)
          unless @user.persisted?
            raise ActiveRecord::Rollback
          end
        end

        if @user.persisted?
          render status: :created, json: json_api_serializer_response(@user, meta: { message: "Signed up successfully" })
        else
          render_json_error(:unprocessable_entity, object: @user)
        end
      end

      def upload_images
        user = current_user

        if user_update_params[:images].present?
          if user.images.attach(user_update_params[:images])
            render status: :ok, json: json_api_serializer_response(user, params: { uploaded: true}, meta: { message: "Uploaded successfully" })
          else
            render_json_error(:unprocessable_entity, object: user)
          end
        else
          render_json_error(:unprocessable_entity, message: "Images are missing")
        end
      end

      def get_images
        render status: :ok, json: json_api_serializer_response(current_user)
      end

      private

      def user_param
        params.permit(:email, :password, :confirm_password)
      end

      def user_update_params
        params.permit(:images, :id)
      end
    end
  end
end
