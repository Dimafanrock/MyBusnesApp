class Purchase < ApplicationRecord
    belongs_to :user
    validates :category_name, :price,  presence: true
    date_check = Date.new(1900, 1, 1)   
    validates  :buy_at,  comparison: { greater_than: date_check , less_than: Date.today } 
end
