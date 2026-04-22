namespace :import do
  desc "Умный импорт аниме и персонажей с автоматической загрузкой картинок"
  task anime: :environment do
    require 'open-uri'
    require 'json'
    require 'uri'

    query = ENV['TITLE']
    if query.blank?
      puts "❌ Ошибка: Укажи название. Пример: docker compose exec web rake import:anime TITLE='Fate'"
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
    
    # Ищем ссылку на постер (большую картинку)
    poster_url = anime_data.dig('images', 'jpg', 'large_image_url')

    puts "✅ Найдено: #{title}. Скачиваем данные и постер..."

    franchise = Franchise.find_or_create_by!(name: title)
    franchise.update!(description: synopsis[0..250] + "...") unless franchise.description.present?

    tv_type = MediaType.find_or_create_by!(name: 'TV Series')

    work = Work.find_or_create_by!(title: title, franchise: franchise)
    work.update!(
      release_year: year, 
      synopsis: synopsis, 
      media_type: tv_type
    )

    # Прикрепляем постер к тайтлу (если у тебя в модели Work есть has_one_attached :poster)
    # Если картинка называется иначе (например :image), поменяй слово poster
    if poster_url.present? && !work.poster.attached?
      puts "  🖼️  Загружаем постер..."
      downloaded_image = URI.open(poster_url)
      work.poster.attach(io: downloaded_image, filename: "poster_#{mal_id}.jpg")
    end

    puts "⏳ Ждем 1 секунду, чтобы API не заблокировал..."
    sleep(1) 

    puts "⏳ Загружаем главных героев и их аватарки..."
    chars_url = "https://api.jikan.moe/v4/anime/#{mal_id}/characters"
    chars_response = JSON.parse(URI.open(chars_url).read)

    main_chars = chars_response['data'].select { |c| c['role'] == 'Main' }
    role_protagonist = CharacterRole.find_or_create_by!(name: 'Протагонист')

    main_chars.each do |char_info|
      char_data = char_info['character']
      char_name = char_data['name']
      portrait_url = char_data.dig('images', 'jpg', 'image_url')

      character = franchise.characters.find_or_create_by!(name: char_name)
      
      character.update!(
        character_role: role_protagonist,
        status: character.status || 'Неизвестно',
        biography: character.biography || 'Информация загружается...',
        plot_role: character.plot_role || 'Главный герой'
      )

      # Скачиваем и прикрепляем аватарку
      if portrait_url.present? && !character.portrait.attached?
        begin
          downloaded_portrait = URI.open(portrait_url)
          character.portrait.attach(io: downloaded_portrait, filename: "char_#{char_data['mal_id']}.jpg")
          puts "  👤 Добавлен: #{char_name} (с фото 📸)"
        rescue
          puts "  👤 Добавлен: #{char_name} (без фото ❌)"
        end
      else
        puts "  👤 Добавлен: #{char_name}"
      end
    end

    puts "🎉 Импорт '#{title}' полностью завершен! Тексты и картинки в базе."
  end
end