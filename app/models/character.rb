class Character < ApplicationRecord
  belongs_to :franchise
  belongs_to :character_role
  
  has_many :favorites, dependent: :destroy
  has_many :appearances, dependent: :destroy
  has_many :works, through: :appearances
  
  # Портрет персонажа
  has_one_attached :portrait
  
  # Связь с эпизодами многие-ко-многим
  has_and_belongs_to_many :episodes

  STATUSES = ['Жив', 'Мертв', 'Неизвестно', 'Запечатан', 'Перерожден']

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES, allow_blank: true }
end