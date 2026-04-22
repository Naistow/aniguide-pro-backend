namespace :import do
  desc "Импорт аниме и главных персонажей из MyAnimeList"
  task anime: :environment do
    require 'open-uri'
    require 'json'
    require 'uri'

    # Теперь безопасно принимаем аргумент
    query = ENV['TITLE']
    if query.blank?
      puts "❌ Ошибка: Укажи название. Пример: docker compose exec web rake import:anime TITLE='Berserk'"
      next
    end

    puts "🔍 Ищем '#{query}' на MyAnimeList..."

    url = "https://api.jikan.moe/v4/anime?q=#{URI.encode_www_form_component(query)}&limit=1"
    
    begin
      response = JSON.parse(URI.open(url).read)
    rescue => e
      puts "❌ Ошибка сети: #{e.message}"
      next
    end

    if response['data'].empty?
      puts "❌ Аниме не найдено!"
      next
    end

    anime_data = response['data'].first
    mal_id = anime_data['mal_id']
    title = anime_data['title_english'] || anime_data['title'] 
    synopsis = anime_data['synopsis'] || "Описание отсутствует."
    year = anime_data['year'] || anime_data.dig('aired', 'prop', 'from', 'year')

    puts "✅ Найдено: #{title}"

    # Создаем франшизу
    franchise = Franchise.find_or_create_by!(name: title)
    franchise.update!(description: synopsis[0..250] + "...") unless franchise.description.present?

    tv_type = MediaType.find_or_create_by!(name: 'TV Series')

    work = Work.find_or_create_by!(title: title, franchise: franchise)
    work.update!(release_year: year, synopsis: synopsis, media_type: tv_type)

    puts "⏳ Ждем 1 секунду..."
    sleep(1) 

    puts "⏳ Загружаем персонажей..."
    chars_url = "https://api.jikan.moe/v4/anime/#{mal_id}/characters"
    chars_response = JSON.parse(URI.open(chars_url).read)

    main_chars = chars_response['data'].select { |c| c['role'] == 'Main' }
    role_protagonist = CharacterRole.find_or_create_by!(name: 'Протагонист')

    main_chars.each do |char_info|
      char_data = char_info['character']
      char_name = char_data['name']

      character = franchise.characters.find_or_create_by!(name: char_name)
      
      # Добавили заглушки для твоей кастомной структуры БД, чтобы не было ошибок валидации
      character.update!(
        character_role: role_protagonist,
        status: character.status || 'Неизвестно',
        biography: character.biography || 'Информация загружается...',
        plot_role: character.plot_role || 'Главный герой'
      )
      puts "  👤 Добавлен: #{char_name}"
    end

    puts "🎉 Импорт '#{title}' успешно завершен!"
  end
end