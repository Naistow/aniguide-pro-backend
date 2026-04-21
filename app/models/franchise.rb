class Franchise < ApplicationRecord
  has_many :characters, dependent: :destroy
  has_many :lore_glossaries, dependent: :destroy
  has_many :watch_guides, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy # Новое!
  has_many :glossaries, dependent: :destroy
  
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end
end