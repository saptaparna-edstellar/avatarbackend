class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers   # 👈 needed for url_for

  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    decoded = JsonWebToken.decode(token)
    if decoded.nil?
      render json: { error: 'unauthorized' }, status: :unauthorized
      return
    end
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: 'unauthorized' }, status: :unauthorized
  end

  # 👇 helper to build consistent user JSON
  def user_json(user)
    user.slice(:id, :name, :email, :role).merge(
      avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
    )
  end
end
