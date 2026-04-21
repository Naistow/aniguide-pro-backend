class Episode < ApplicationRecord
  belongs_to :work
  
  # Прямая связь многие-ко-многим (через скрытую таблицу characters_episodes)
  has_and_belongs_to_many :characters

  # Валидации
  validates :title, presence: true
  # validates :episode_number, presence: true # Раскомментируй, если добавишь это поле в базу
end