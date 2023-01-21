class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum
  enum user_type: { customer: 0, team: 1, admin: 2 }

  validates_presence_of :email, :full_name
end
