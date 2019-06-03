class Programa < ApplicationRecord
  belongs_to :laboratorio
  belongs_to :qf_soporte_id, class_name: 'User'
end
