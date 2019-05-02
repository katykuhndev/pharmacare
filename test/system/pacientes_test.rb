require "application_system_test_case"

class PacientesTest < ApplicationSystemTestCase
  setup do
    @paciente = pacientes(:one)
  end

  test "visiting the index" do
    visit pacientes_url
    assert_selector "h1", text: "Pacientes"
  end

  test "creating a Paciente" do
    visit pacientes_url
    click_on "New Paciente"

    fill_in "Comuna", with: @paciente.comuna_id
    fill_in "Direccion", with: @paciente.direccion
    fill_in "Email", with: @paciente.email
    fill_in "Fecha nacimiento", with: @paciente.fecha_nacimiento
    fill_in "Fono1", with: @paciente.fono1
    fill_in "Fono2", with: @paciente.fono2
    fill_in "Genero", with: @paciente.genero
    fill_in "Nombres", with: @paciente.nombres
    fill_in "Primer apellido", with: @paciente.primer_apellido
    fill_in "Rut", with: @paciente.rut
    fill_in "Segundo apellido", with: @paciente.segundo_apellido
    click_on "Create Paciente"

    assert_text "Paciente was successfully created"
    click_on "Back"
  end

  test "updating a Paciente" do
    visit pacientes_url
    click_on "Edit", match: :first

    fill_in "Comuna", with: @paciente.comuna_id
    fill_in "Direccion", with: @paciente.direccion
    fill_in "Email", with: @paciente.email
    fill_in "Fecha nacimiento", with: @paciente.fecha_nacimiento
    fill_in "Fono1", with: @paciente.fono1
    fill_in "Fono2", with: @paciente.fono2
    fill_in "Genero", with: @paciente.genero
    fill_in "Nombres", with: @paciente.nombres
    fill_in "Primer apellido", with: @paciente.primer_apellido
    fill_in "Rut", with: @paciente.rut
    fill_in "Segundo apellido", with: @paciente.segundo_apellido
    click_on "Update Paciente"

    assert_text "Paciente was successfully updated"
    click_on "Back"
  end

  test "destroying a Paciente" do
    visit pacientes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Paciente was successfully destroyed"
  end
end
