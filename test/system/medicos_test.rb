require "application_system_test_case"

class MedicosTest < ApplicationSystemTestCase
  setup do
    @medico = medicos(:one)
  end

  test "visiting the index" do
    visit medicos_url
    assert_selector "h1", text: "Medicos"
  end

  test "creating a Medico" do
    visit medicos_url
    click_on "New Medico"

    fill_in "Comuna", with: @medico.comuna_id
    fill_in "Direccion", with: @medico.direccion
    fill_in "Email", with: @medico.email
    fill_in "Fecha nacimiento", with: @medico.fecha_nacimiento
    fill_in "Fono1", with: @medico.fono1
    fill_in "Fono2", with: @medico.fono2
    fill_in "Genero", with: @medico.genero
    fill_in "Nombres", with: @medico.nombres
    fill_in "Primer apellido", with: @medico.primer_apellido
    fill_in "Rut", with: @medico.rut
    fill_in "Segundo apellido", with: @medico.segundo_apellido
    click_on "Create Medico"

    assert_text "Medico was successfully created"
    click_on "Back"
  end

  test "updating a Medico" do
    visit medicos_url
    click_on "Edit", match: :first

    fill_in "Comuna", with: @medico.comuna_id
    fill_in "Direccion", with: @medico.direccion
    fill_in "Email", with: @medico.email
    fill_in "Fecha nacimiento", with: @medico.fecha_nacimiento
    fill_in "Fono1", with: @medico.fono1
    fill_in "Fono2", with: @medico.fono2
    fill_in "Genero", with: @medico.genero
    fill_in "Nombres", with: @medico.nombres
    fill_in "Primer apellido", with: @medico.primer_apellido
    fill_in "Rut", with: @medico.rut
    fill_in "Segundo apellido", with: @medico.segundo_apellido
    click_on "Update Medico"

    assert_text "Medico was successfully updated"
    click_on "Back"
  end

  test "destroying a Medico" do
    visit medicos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Medico was successfully destroyed"
  end
end
