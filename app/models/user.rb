class User < ApplicationRecord
  has_many :purchases, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
