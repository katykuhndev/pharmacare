class Alarma < ApplicationRecord
  enum resultado: [:aprobacion_con_reparos, :rechazo_tecnico]	
  belongs_to :medicion
end
