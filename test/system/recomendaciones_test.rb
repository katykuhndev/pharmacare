require "application_system_test_case"

class RecomendacionesTest < ApplicationSystemTestCase
  setup do
    @recomendacion = recomendaciones(:one)
  end

  test "visiting the index" do
    visit recomendaciones_url
    assert_selector "h1", text: "Recomendaciones"
  end

  test "creating a Recomendacion" do
    visit recomendaciones_url
    click_on "New Recomendacion"

    fill_in "Caso", with: @recomendacion.caso_id
    check "Con alarma" if @recomendacion.con_alarma
    fill_in "Ejecutivo", with: @recomendacion.ejecutivo_id
    fill_in "Estado", with: @recomendacion.estado
    fill_in "Farmacia", with: @recomendacion.farmacia_id
    fill_in "Fecha hora ingreso", with: @recomendacion.fecha_hora_ingreso
    fill_in "Fecha hora respuesta", with: @recomendacion.fecha_hora_respuesta
    fill_in "Id recomendacion", with: @recomendacion.id_recomendacion
    fill_in "Medico", with: @recomendacion.medico_id
    fill_in "Observaciones", with: @recomendacion.observaciones
    fill_in "Paciente", with: @recomendacion.paciente_id
    fill_in "Prestador", with: @recomendacion.prestador_id
    fill_in "Programa", with: @recomendacion.programa_id
    fill_in "Qf soporte", with: @recomendacion.qf_soporte_id
    fill_in "Resultado", with: @recomendacion.resultado
    fill_in "Via ingreso", with: @recomendacion.via_ingreso
    click_on "Create Recomendacion"

    assert_text "Recomendacion was successfully created"
    click_on "Back"
  end

  test "updating a Recomendacion" do
    visit recomendaciones_url
    click_on "Edit", match: :first

    fill_in "Caso", with: @recomendacion.caso_id
    check "Con alarma" if @recomendacion.con_alarma
    fill_in "Ejecutivo", with: @recomendacion.ejecutivo_id
    fill_in "Estado", with: @recomendacion.estado
    fill_in "Farmacia", with: @recomendacion.farmacia_id
    fill_in "Fecha hora ingreso", with: @recomendacion.fecha_hora_ingreso
    fill_in "Fecha hora respuesta", with: @recomendacion.fecha_hora_respuesta
    fill_in "Id recomendacion", with: @recomendacion.id_recomendacion
    fill_in "Medico", with: @recomendacion.medico_id
    fill_in "Observaciones", with: @recomendacion.observaciones
    fill_in "Paciente", with: @recomendacion.paciente_id
    fill_in "Prestador", with: @recomendacion.prestador_id
    fill_in "Programa", with: @recomendacion.programa_id
    fill_in "Qf soporte", with: @recomendacion.qf_soporte_id
    fill_in "Resultado", with: @recomendacion.resultado
    fill_in "Via ingreso", with: @recomendacion.via_ingreso
    click_on "Update Recomendacion"

    assert_text "Recomendacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Recomendacion" do
    visit recomendaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recomendacion was successfully destroyed"
  end
end
