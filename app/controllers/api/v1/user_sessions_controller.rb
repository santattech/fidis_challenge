module Api
  module V1
    class UserSessionsController < BaseController
      before_action :authenticate_request, only: [:get_user]

      def create
        user = User.find_by_email(params[:email])

        if user
          if user.authenticate(params[:password])
            auth_token = JsonWebToken.encode(user_id: user.id)
            render status: :created, json: json_api_serializer_response(user, meta: { auth_token: auth_token, message: "Login successful" })
          else
            render_json_error(:unauthorized, message: "Invalid Password")
          end
        else
          render_json_error(:not_found, message: "Invalid Email")
        end
      rescue => e
        render_json_error(:unauthorized, message: e.message)
      end

      def get_user
        render status: :ok, json: json_api_serializer_response(current_user, include: [:company])
      end
    end
  end
end
