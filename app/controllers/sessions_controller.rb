class SessionsController < ApplicationController
  def new
    # Просто показывает форму входа
  end

  def create
    # Ищем пользователя по email
    user = User.find_by(email: params[:email])
    
    # Если нашли И пароль совпал (метод authenticate дает bcrypt)
    if user && user.authenticate(params[:password])
      # Кладем его ID в сессию браузера
      session[:user_id] = user.id
      redirect_to root_path
    else
      # Если ошибка - показываем сообщение
      flash.now[:alert] = "Неверный email или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Удаляем ID из сессии (Выход)
    session[:user_id] = nil
    redirect_to root_path
  end
end