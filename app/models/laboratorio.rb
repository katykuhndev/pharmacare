class Laboratorio < ApplicationRecord
  has_many :programas
  belongs_to :comuna
end
