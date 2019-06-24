class Bloque < ApplicationRecord
  has_and_belongs_to_many :programas
end
