class ProductPhoto < ApplicationRecord
  belongs_to :product

  has_one_attached :photo

  # validates :alt_ar, :alt_en, presence: true
end
