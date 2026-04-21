class Work < ApplicationRecord
  belongs_to :media_type
  belongs_to :franchise
  
  has_many :guide_steps, dependent: :destroy
  has_many :appearances, dependent: :destroy
  has_many :characters, through: :appearances
  has_many :user_progresses, dependent: :destroy
  
  # Связь с эпизодами
  has_many :episodes, dependent: :destroy

  validates :title, presence: true
end