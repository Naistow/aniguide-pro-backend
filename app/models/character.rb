class Character < ApplicationRecord
  belongs_to :franchise
  belongs_to :character_role
  
  has_many :favorites, dependent: :destroy
  has_many :appearances, dependent: :destroy
  has_many :works, through: :appearances
  has_one_attached :portrait
  
  # НОВЫЕ СВЯЗИ ДЛЯ СЕРИЙ
  has_many :episode_appearances, dependent: :destroy
  has_many :episodes, through: :episode_appearances

  has_one_attached :portrait

  STATUSES = ['Жив', 'Мертв', 'Неизвестно', 'Запечатан', 'Перерожден']

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES, allow_blank: true }
end