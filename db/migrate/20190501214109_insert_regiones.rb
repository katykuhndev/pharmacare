class InsertRegiones < ActiveRecord::Migration[5.2]
    def up
       
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Tarapacá', '01' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Antofagasta', '02' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Atacama', '03' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Coquimbo', '04' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Valparaíso', '05' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('Del Libertador B. O\''Higgins', '06', '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('Del Maule', '07' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('Del Bíobío', '08' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De La Araucanía', '09' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Los Lagos', '10' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Aisén del Gral. C. Ibáñez del Campo', '11' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Magallanes y de La Antártica Chilena', '12' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('Metropolitana de Santiago', '13' , '2019-05-01 17:21:26' , '2019-05-01 17:21:26');" 
		execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Los Ríos', '14', '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
        execute "insert into regiones(nombre, codigo, created_at, updated_at) values('De Arica y Parinacota', '15', '2019-05-01 17:21:26' , '2019-05-01 17:21:26');"
	end
    def down
      execute "delete from regiones;"	
    end
end
