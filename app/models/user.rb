class User < ApplicationRecord
  has_secure_password
  belongs_to :user_role
  has_many :favorites, dependent: :destroy
  has_many :favorite_characters, through: :favorites, source: :character
  has_many :user_progresses, dependent: :destroy
  has_many :works, through: :user_progresses
  def admin?
    user_role.role_name == 'Admin'
  end
end