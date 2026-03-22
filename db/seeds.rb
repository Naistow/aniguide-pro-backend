puts "--- ГЛОБАЛЬНОЕ ЗАПОЛНЕНИЕ БАЗЫ: EVA & FATE (С ЭПИЗОДАМИ И СИНОПСИСАМИ) ---"

puts "Очистка таблиц..."
[
  'EpisodeAppearance', 'Episode', 'Appearance', 'GuideStep', 'WatchGuide', 'LoreGlossary', 
  'Character', 'Work', 'User', 'Franchise', 'MediaType', 
  'UserRole', 'CharacterRole'
].each { |m| m.constantize.delete_all if Object.const_defined?(m) }

admin_role = UserRole.create!(role_name: 'Admin')
user_role  = UserRole.create!(role_name: 'User')
tv = MediaType.create!(name: 'TV Series')
movie = MediaType.create!(name: 'Movie')

role_protagonist = CharacterRole.create!(name: 'Протагонист')
role_deuteragonist = CharacterRole.create!(name: 'Дейтерагонист (Второй герой)')

User.create!(username: 'AdminUser', email: 'admin@test.com', password: 'password123', user_role: admin_role)

# --- EVANGELION ---
eva = Franchise.create!(name: 'Neon Genesis Evangelion', theme: 'nerv-theme', description: 'От классики 95-го года до грандиозного финала Rebuild.')

e1 = Work.create!(title: 'Neon Genesis Evangelion', release_year: 1995, media_type: tv, franchise: eva, 
  synopsis: "В 2015 году человечество находится на грани уничтожения таинственными существами, известными как Ангелы. Единственная надежда — гигантские биомеханические роботы Евангелионы.")

eg = WatchGuide.create!(franchise: eva)
GuideStep.create!(watch_guide: eg, work: e1, step_number: 1)

shinji = Character.create!(name: 'Синдзи Икари', status: 'Жив', franchise: eva, character_role: role_protagonist, 
  biography: 'Третье Дитя, пилот Евангелиона-01.', plot_role: 'Главный герой.', backstory: 'Сын Гэндо Икари.')
asuka = Character.create!(name: 'Аска Лэнгли', status: 'Жив', franchise: eva, character_role: role_deuteragonist, 
  biography: 'Второе Дитя, пилот Евангелиона-02.', plot_role: 'Опытный боец.', backstory: 'Вундеркинд.')

# Создаем Эпизоды и привязываем героев!
ep1 = Episode.create!(work: e1, episode_number: 1, title: 'Нападение Ангела', description: 'Синдзи прибывает в Токио-3 по вызову отца и сталкивается с Третьим Ангелом.')
EpisodeAppearance.create!(episode: ep1, character: shinji)

ep8 = Episode.create!(work: e1, episode_number: 8, title: 'Аска прибывает в Японию', description: 'Синдзи и его друзья встречают Аску Лэнгли на авианосце, где на них нападает морской Ангел.')
EpisodeAppearance.create!(episode: ep8, character: shinji)
EpisodeAppearance.create!(episode: ep8, character: asuka)

# --- FATE ---
fate = Franchise.create!(name: 'Fate Series', theme: 'magic-theme', description: 'Мультивселенная войн за Святой Грааль.')

f1 = Work.create!(title: 'Fate/Zero', release_year: 2011, media_type: tv, franchise: fate, 
  synopsis: "Четвертая Война Святого Грааля. Семь магов призывают семь героических душ, чтобы сражаться насмерть за артефакт, исполняющий желания.")

fg = WatchGuide.create!(franchise: fate)
GuideStep.create!(watch_guide: fg, work: f1, step_number: 1)

saber = Character.create!(name: 'Сэйбер', status: 'Перерожден', franchise: fate, character_role: role_deuteragonist, 
  biography: 'Король Рыцарей.', plot_role: 'Союзник.', backstory: 'Легендарный Артур.')

f_ep1 = Episode.create!(work: f1, episode_number: 1, title: 'Призыв Героев', description: 'Маги со всего мира готовят ритуалы. Кирицугу Эмия призывает могущественного Слугу класса Сэйбер.')
EpisodeAppearance.create!(episode: f_ep1, character: saber)

puts "--- БАЗА ЗАПОЛНЕНА! ---"