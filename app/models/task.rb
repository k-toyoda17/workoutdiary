class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  belongs_to :user
  has_one_attached :image
  scope :recent, -> { order(activity_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name activity_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
