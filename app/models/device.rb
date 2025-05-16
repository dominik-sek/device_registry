class Device < ApplicationRecord
  has_many :device_assignments
  has_many :users, through: :device_assignments
end
