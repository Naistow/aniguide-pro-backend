FROM ruby:4.0.1

# Устанавливаем зависимости системы
RUN apt-get update -qq && apt-get install -y nodejs npm postgresql-client

# Создаем рабочую папку
WORKDIR /app

# Копируем Gemfile и устанавливаем гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Копируем весь остальной код
COPY . .

# Указываем, как запускать сервер
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0 -p 3000"]