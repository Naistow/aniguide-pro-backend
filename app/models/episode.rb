class Episode < ApplicationRecord
  belongs_to :work
  
  # Связь: у эпизода много появлений персонажей
  has_many :episode_appearances, dependent: :destroy
  has_many :characters, through: :episode_appearances

  validates :episode_number, presence: true
  validates :title, presence: true
end