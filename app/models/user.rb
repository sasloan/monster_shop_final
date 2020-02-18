class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :email, :password, :password_confirmation

  validates_uniqueness_of :email

  has_secure_password
end
