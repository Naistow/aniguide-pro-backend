class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :work, optional: true
  belongs_to :character, optional: true
end