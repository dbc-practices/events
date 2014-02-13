class Event < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', foreign_key: 'user_id'
  has_many :event_attendances
  has_many :guests, through: :event_attendances, source: :user

  validates :name, presence: true
  validates :location, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
end
