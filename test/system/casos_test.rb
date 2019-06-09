require "application_system_test_case"

class CasosTest < ApplicationSystemTestCase
  setup do
    @caso = casos(:one)
  end

  test "visiting the index" do
    visit casos_url
    assert_selector "h1", text: "Casos"
  end

  test "creating a Caso" do
    visit casos_url
    click_on "New Caso"

    fill_in "Codigo", with: @caso.codigo
    fill_in "Ejecutivo", with: @caso.ejecutivo_id
    fill_in "Fecha hora cierre", with: @caso.fecha_hora_cierre
    fill_in "Fecha hora ingreso", with: @caso.fecha_hora_ingreso
    fill_in "Medico", with: @caso.medico_id
    fill_in "Observaciones", with: @caso.observaciones
    fill_in "Paciente", with: @caso.paciente_id
    fill_in "Programa", with: @caso.programa_id
    fill_in "Qf soporte", with: @caso.qf_soporte_id
    fill_in "Via ingreso", with: @caso.via_ingreso
    click_on "Create Caso"

    assert_text "Caso was successfully created"
    click_on "Back"
  end

  test "updating a Caso" do
    visit casos_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @caso.codigo
    fill_in "Ejecutivo", with: @caso.ejecutivo_id
    fill_in "Fecha hora cierre", with: @caso.fecha_hora_cierre
    fill_in "Fecha hora ingreso", with: @caso.fecha_hora_ingreso
    fill_in "Medico", with: @caso.medico_id
    fill_in "Observaciones", with: @caso.observaciones
    fill_in "Paciente", with: @caso.paciente_id
    fill_in "Programa", with: @caso.programa_id
    fill_in "Qf soporte", with: @caso.qf_soporte_id
    fill_in "Via ingreso", with: @caso.via_ingreso
    click_on "Update Caso"

    assert_text "Caso was successfully updated"
    click_on "Back"
  end

  test "destroying a Caso" do
    visit casos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Caso was successfully destroyed"
  end
end
