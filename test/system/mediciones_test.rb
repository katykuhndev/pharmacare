require "application_system_test_case"

class MedicionesTest < ApplicationSystemTestCase
  setup do
    @medicion = mediciones(:one)
  end

  test "visiting the index" do
    visit mediciones_url
    assert_selector "h1", text: "Mediciones"
  end

  test "creating a Medicion" do
    visit mediciones_url
    click_on "New Medicion"

    fill_in "Descripcion", with: @medicion.descripcion
    fill_in "Examen", with: @medicion.examen_id
    fill_in "Nombre", with: @medicion.nombre
    fill_in "Programa", with: @medicion.programa_id
    fill_in "Unidad medida", with: @medicion.unidad_medida
    click_on "Create Medicion"

    assert_text "Medicion was successfully created"
    click_on "Back"
  end

  test "updating a Medicion" do
    visit mediciones_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @medicion.descripcion
    fill_in "Examen", with: @medicion.examen_id
    fill_in "Nombre", with: @medicion.nombre
    fill_in "Programa", with: @medicion.programa_id
    fill_in "Unidad medida", with: @medicion.unidad_medida
    click_on "Update Medicion"

    assert_text "Medicion was successfully updated"
    click_on "Back"
  end

  test "destroying a Medicion" do
    visit mediciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Medicion was successfully destroyed"
  end
end
