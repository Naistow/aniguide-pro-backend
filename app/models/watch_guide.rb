class WatchGuide < ApplicationRecord
  belongs_to :franchise
  has_many :guide_steps, dependent: :destroy
end