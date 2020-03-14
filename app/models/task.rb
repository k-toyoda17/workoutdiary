class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :activity_at, presence: true
  belongs_to :user
  has_one_attached :image
  scope :recent, -> { order(activity_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name activity_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
