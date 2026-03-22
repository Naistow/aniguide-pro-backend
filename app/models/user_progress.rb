class UserProgress < ApplicationRecord
  belongs_to :user
  belongs_to :work

  # Статусы: 'planned', 'watching', 'completed'
  validates :status, inclusion: { in: %w(planned watching completed) }
  validates :user_id, uniqueness: { scope: :work_id }
end