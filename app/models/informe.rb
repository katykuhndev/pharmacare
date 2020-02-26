class Informe
  	
  def self.informe_normal(fecha_desde,fecha_hasta)
  	sql = "SELECT substring(r.id_recomendacion,1,3) as N_rec, 
  	DATE_FORMAT(r.fecha_hora_ingreso,\"%d/%m/%Y\") as Fecha_rec, 
  	c.codigo, FORMat(mr2.valor,0,'de_DE') as Leucocitos, 
  	FORMat(mr1.valor,0,'de_DE') as RAN, 
  	IF(a.id=5, 'SIN ALARMA', a.nombre) as alarmas, 
  	IF(r.resolucion_qf=0, \"A\", \"R\") as A_R 
  	FROM recomendaciones as r, casos as c, medicion_recomendaciones as mr1, medicion_recomendaciones as mr2, alarmas as a 
  	WHERE r.caso_id=c.id and mr1.recomendacion_id=r.id and mr1.medicion_id=1 
  	and mr2.recomendacion_id=r.id and mr2.medicion_id=2 and r.alarma_id=a.id 
  	and r.fecha_hora_ingreso>='#{fecha_desde} 00:00:00' and r.fecha_hora_ingreso<='#{fecha_hasta} 23:59:59' 
  	order by substring(r.fecha_hora_ingreso,1,10), N_rec;"
    records_array = ActiveRecord::Base.connection.execute(sql)
  end	

   def self.informe_medico_adherido(fecha_desde,fecha_hasta,medico_id)
  	sql = "SELECT substring(r.id_recomendacion,1,3) as N_rec, DATE_FORMAT(r.fecha_hora_ingreso,\"%d/%m/%Y\") as Fecha_rec, 
  	c.codigo, IF(mr2.valor,FORMat(mr2.valor,0,'de_DE'),'') as Leucocitos, IF(mr2.valor,FORMat(mr1.valor,0,'de_DE'),'') as RAN, 
  	IF(a.id=5, 'SIN ALARMA', a.nombre) as alarmas, IF(r.resolucion_qf=0, \"A\", \"R\") as A_R, concat(p.nombres,' ',p.primer_apellido) as nombre_paciente 
  	from recomendaciones as r LEFT JOIN medicion_recomendaciones as mr1 ON mr1.recomendacion_id=r.id LEFT 
  	JOIN medicion_recomendaciones as mr2 ON mr2.recomendacion_id=r.id JOIN casos as c ON r.caso_id=c.id 
  	JOIN alarmas as a ON r.alarma_id=a.id 
  	JOIN pacientes as p ON r.paciente_id=p.id 
  	WHERE mr1.medicion_id=1 
  	and mr2.medicion_id=2 
  	and r.medico_id= #{medico_id} 
  	order by substring(r.fecha_hora_ingreso,1,10), N_rec;"
    records_array = ActiveRecord::Base.connection.execute(sql)
  end

  def self.informe_medicos(fecha_desde,fecha_hasta)
    sql = "SELECT substring(r.id_recomendacion,1,3) as N_rec, DATE_FORMAT(r.fecha_hora_ingreso,\"%d/%m/%Y\") as Fecha_rec,
    c.codigo,concat(m.nombres,' ',m.primer_apellido) as medico , p.nombre as prestador from recomendaciones as r 
    JOIN casos as c ON r.caso_id=c.id 
    JOIN medicos as m ON r.medico_id=m.id 
    JOIN prestadores as p ON r.prestador_id=p.id 
    WHERE r.fecha_hora_ingreso>='#{fecha_desde} 00:00:00' and r.fecha_hora_ingreso<='#{fecha_hasta} 23:59:59' 
    ORDER by substring(r.fecha_hora_ingreso,1,10), N_rec;"
    records_array = ActiveRecord::Base.connection.execute(sql)
  end
  
end
