class Glossary < ApplicationRecord
  belongs_to :franchise
  
  # Добавляем поддержку загрузки файлов (картинок)
  has_one_attached :image
  
  validates :title, presence: true
end