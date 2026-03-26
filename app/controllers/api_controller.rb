class ApiController < ApplicationController
  # Отключаем стандартную браузерную защиту для мобильных запросов
  skip_before_action :verify_authenticity_token, raise: false

  def franchises
    # Берем все франшизы из базы и превращаем их в чистый JSON
    @franchises = Franchise.all
    render json: @franchises
  end
end