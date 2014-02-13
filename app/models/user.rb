class User < ActiveRecord::Base
  has_many :event_attendances
  has_many :attended_events, through: :event_attendances, source: :event
  has_many :created_events, :class_name => 'Event', foreign_key: 'user_id'  # RE-VISIT !!


  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, :format => { :with => /\w+\@\w+.\w{1}/, :message => "Email format doesn't validate"}
  validates :birthdate, presence: true
  validates :password_digest, presence: true

  # REVISIT ENCRYPTING PASSWORD !
end
