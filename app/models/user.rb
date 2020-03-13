class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :tasks
  scope :recent, -> { order(:created_at) }

  def self.csv_attributes
    ["name", "email", "password_digest", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |user|
        csv << csv_attributes.map{|attr| user.send(attr) }
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = new
      user.attributes = row.to_hash.slice(*csv_attributes)
      user.save!
    end
  end
end
