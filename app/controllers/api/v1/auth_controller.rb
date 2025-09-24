class Api::V1::AuthController < ApplicationController
skip_before_action :authorize_request, only: [:signup, :login]
 
# ✅ POST /signup
def signup
user = User.new(user_params)
if user.save
token = JsonWebToken.encode(user_id: user.id)
render json: {
token: token,
user: {
id: user.id,
name: user.name,
email: user.email,
role: user.role,
avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
}
}, status: :created
else
render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
end
end
 
# ✅ POST /login
def login
user = User.find_by(email: params[:email])
if user&.valid_password?(params[:password])
token = JsonWebToken.encode(user_id: user.id)
render json: {
token: token,
user: {
id: user.id,
name: user.name,
email: user.email,
role: user.role,
avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
}
}, status: :ok
else
render json: { error: 'unauthorized' }, status: :unauthorized
end
end
 
private
 
# ✅ Permit avatar upload along with other user fields
def user_params
params.permit(:name, :email, :password, :password_confirmation, :role, :avatar)
end
end