class AddMedicamentoProgramaIdToTratamiento < ActiveRecord::Migration[5.2]
  def change
  	add_column :tratamientos, :medicamento_programa_id, :integer
  end
end
