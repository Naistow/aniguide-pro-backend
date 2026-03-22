class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    # Автоматически находим в БД роль "User" и присваиваем её новичку
    user_role = UserRole.find_by(role_name: 'User')
    @user.user_role = user_role

    if @user.save
      # Если всё успешно, отправляем на главную страницу
      redirect_to root_path
    else
      # Если есть ошибки (например, такой email уже есть), показываем форму снова
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Защита от хакеров: разрешаем передавать из формы только эти 4 поля
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end