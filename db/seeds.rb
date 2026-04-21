puts "--- ГЛОБАЛЬНОЕ ЗАПОЛНЕНИЕ БАЗЫ: EVA & FATE ---"

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

# ==========================================
# --- EVANGELION ---
# ==========================================
puts "Загрузка Evangelion..."
eva = Franchise.create!(name: 'Neon Genesis Evangelion', theme: 'nerv-theme', description: 'От классики 95-го года до грандиозного финала Rebuild.')

e1 = Work.create!(title: 'Neon Genesis Evangelion', release_year: 1995, media_type: tv, franchise: eva, 
  synopsis: "В 2015 году человечество находится на грани уничтожения таинственными существами, известными как Ангелы. Единственная надежда — гигантские биомеханические роботы Евангелионы.")

eg = WatchGuide.create!(franchise: eva)
GuideStep.create!(watch_guide: eg, work: e1, step_number: 1)

shinji = Character.create!(name: 'Синдзи Икари', status: 'Жив', franchise: eva, character_role: role_protagonist, 
  biography: 'Третье Дитя, пилот Евангелиона-01.', plot_role: 'Главный герой.', backstory: 'Сын Гэндо Икари.')
asuka = Character.create!(name: 'Аска Лэнгли', status: 'Жив', franchise: eva, character_role: role_deuteragonist, 
  biography: 'Второе Дитя, пилот Евангелиона-02.', plot_role: 'Опытный боец.', backstory: 'Вундеркинд.')

ep1 = Episode.create!(work: e1, episode_number: 1, title: 'Нападение Ангела', description: 'Синдзи прибывает в Токио-3 по вызову отца и сталкивается с Третьим Ангелом.')
EpisodeAppearance.create!(episode: ep1, character: shinji)

ep8 = Episode.create!(work: e1, episode_number: 8, title: 'Аска прибывает в Японию', description: 'Синдзи и его друзья встречают Аску Лэнгли на авианосце, где на них нападает морской Ангел.')
EpisodeAppearance.create!(episode: ep8, character: shinji)
EpisodeAppearance.create!(episode: ep8, character: asuka)

# ==========================================
# --- FATE SERIES (ИНТЕРАКТИВНАЯ КАРТА) ---
# ==========================================
puts "Загрузка Fate Universe (С расчетом координат)..."
fate = Franchise.create!(name: 'Fate Series', theme: 'magic-theme', description: 'Мультивселенная войн за Святой Грааль.')

fg = WatchGuide.create!(franchise: fate)

# --- ОСНОВНАЯ ВЕТКА ---
zero = Work.create!(title: 'Fate/Zero', release_year: 2011, media_type: tv, franchise: fate, 
  synopsis: "Четвертая Война Святого Грааля. Семь магов призывают семь героических душ...", 
  pos_x: 200, pos_y: 400, parent_id: nil)

GuideStep.create!(watch_guide: fg, work: zero, step_number: 1)

saber = Character.create!(name: 'Сэйбер', status: 'Перерожден', franchise: fate, character_role: role_deuteragonist, 
  biography: 'Король Рыцарей.', plot_role: 'Союзник.', backstory: 'Легендарный Артур.')

f_ep1 = Episode.create!(work: zero, episode_number: 1, title: 'Призыв Героев', description: 'Маги со всего мира готовят ритуалы...')
EpisodeAppearance.create!(episode: f_ep1, character: saber)

sn_2006 = Work.create!(title: 'Fate/stay night (2006)', media_type: tv, franchise: fate, pos_x: 500, pos_y: 300, parent_id: zero.id)
ubw_tv = Work.create!(title: 'Fate/stay night: Unlimited Blade Works', media_type: tv, franchise: fate, pos_x: 500, pos_y: 400, parent_id: zero.id)
ubw_movie = Work.create!(title: 'Fate/stay night: UBW (Movie)', media_type: movie, franchise: fate, pos_x: 800, pos_y: 400, parent_id: ubw_tv.id)
hf = Work.create!(title: 'Fate/stay night: Heaven\'s Feel', media_type: movie, franchise: fate, pos_x: 500, pos_y: 500, parent_id: zero.id)
el_melloi = Work.create!(title: 'Lord El-Melloi II', media_type: tv, franchise: fate, pos_x: 500, pos_y: 600, parent_id: zero.id)

# --- GRAND ORDER ---
fgo_first = Work.create!(title: 'Fate/Grand Order: First Order', media_type: movie, franchise: fate, pos_x: 200, pos_y: 750, parent_id: nil)
fgo_camelot = Work.create!(title: 'FGO: Camelot', media_type: movie, franchise: fate, pos_x: 500, pos_y: 700, parent_id: fgo_first.id)
fgo_babylonia = Work.create!(title: 'FGO: Babylonia', media_type: tv, franchise: fate, pos_x: 500, pos_y: 800, parent_id: fgo_first.id)
fgo_solomon = Work.create!(title: 'FGO: Solomon', media_type: movie, franchise: fate, pos_x: 800, pos_y: 750, parent_id: fgo_babylonia.id)
fgo_lostroom = Work.create!(title: 'FGO: Moonlight/Lostroom', media_type: movie, franchise: fate, pos_x: 1100, pos_y: 750, parent_id: fgo_solomon.id)

# --- АЛЬТЕРНАТИВНЫЕ МИРЫ ---
apocrypha = Work.create!(title: 'Fate/Apocrypha', media_type: tv, franchise: fate, pos_x: 200, pos_y: 1000, parent_id: nil)
extra = Work.create!(title: 'Fate/Extra: Last Encore', media_type: tv, franchise: fate, pos_x: 500, pos_y: 1000, parent_id: nil)
strange_fake = Work.create!(title: 'Fate/strange Fake', media_type: tv, franchise: fate, pos_x: 800, pos_y: 1000, parent_id: nil)
prototype = Work.create!(title: 'Fate/Prototype', media_type: movie, franchise: fate, pos_x: 1100, pos_y: 1000, parent_id: nil)

# --- ИЛЛИЯ ---
illya_movie = Work.create!(title: 'Prisma☆Illya: Sekka no Chikai', media_type: movie, franchise: fate, pos_x: 100, pos_y: 1300, parent_id: nil)
illya_s1 = Work.create!(title: 'Prisma☆Illya S1', media_type: tv, franchise: fate, pos_x: 400, pos_y: 1300, parent_id: illya_movie.id)
illya_s2 = Work.create!(title: 'Prisma☆Illya 2wei!', media_type: tv, franchise: fate, pos_x: 700, pos_y: 1300, parent_id: illya_s1.id)
illya_s3 = Work.create!(title: 'Prisma☆Illya 2wei Herz!', media_type: tv, franchise: fate, pos_x: 1000, pos_y: 1300, parent_id: illya_s2.id)
illya_s4 = Work.create!(title: 'Prisma☆Illya 3rei!!', media_type: tv, franchise: fate, pos_x: 1300, pos_y: 1300, parent_id: illya_s3.id)

# --- КОМЕДИИ & NASUVERSE ---
emiya = Work.create!(title: 'Emiya-san Chi no Kyou no Gohan', media_type: tv, franchise: fate, pos_x: 800, pos_y: 200, parent_id: ubw_tv.id)
carnival = Work.create!(title: 'Carnival Phantasm', media_type: tv, franchise: fate, pos_x: 1100, pos_y: 150, parent_id: nil)
knk = Work.create!(title: 'Kara no Kyoukai', media_type: movie, franchise: fate, pos_x: 200, pos_y: 100, parent_id: nil)
tsukihime = Work.create!(title: 'Tsukihime', media_type: tv, franchise: fate, pos_x: 500, pos_y: 100, parent_id: nil)

puts "--- БАЗА УСПЕШНО ЗАПОЛНЕНА! ---"