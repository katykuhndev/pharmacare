class Alarma < ApplicationRecord
  enum resultado: [:aprobacion, :aprobacion_con_reparos, :rechazo_administrativo, :rechazo_tecnico]	
  belongs_to :medicion
end
