class Api::V1::UsersController < ApplicationController
  before_action :authorize_request

  # ✅ GET /users
  def index
    users = case @current_user.role
            when 'superadmin' then User.all
            when 'admin' then User.where.not(role: 'superadmin')
            else return render json: { error: 'unauthorized' }, status: :unauthorized
            end

    render json: users.map { |u| user_json(u) }
  end

  # ✅ GET /users/:id
  def show
    user = User.find(params[:id])
    if @current_user.role == 'superadmin' || (@current_user.role == 'admin' && user.role != 'superadmin') || @current_user.id == user.id
      render json: user_json(user)
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # ✅ GET /users/me
  def me
    render json: user_json(@current_user)
  end

  # ✅ POST /users  <-- NEW ACTION
  def create
    # Only superadmin/admin can create users
    unless @current_user.role == 'superadmin' || @current_user.role == 'admin'
      return render json: { error: 'unauthorized' }, status: :unauthorized
    end

    user = User.new(user_params)
    if user.save
      render json: user_json(user), status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ PUT /users/:id
  def update
    user = User.find(params[:id])
    if @current_user.role == 'superadmin' ||
       (@current_user.role == 'admin' && user.role != 'superadmin') ||
       @current_user.id == user.id

      if user.update(user_params)
        render json: user_json(user)
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # ✅ DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    if @current_user.role == 'superadmin'
      user.destroy
      render json: { message: 'User deleted' }
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  # Permit avatar for create/update
  def user_params
    params.permit(:name, :email, :role, :password, :password_confirmation, :avatar)
  end

  # Format user JSON including avatar URL
  def user_json(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
    }
  end
end
