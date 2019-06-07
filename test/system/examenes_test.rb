require "application_system_test_case"

class ExamenesTest < ApplicationSystemTestCase
  setup do
    @examen = examenes(:one)
  end

  test "visiting the index" do
    visit examenes_url
    assert_selector "h1", text: "Examenes"
  end

  test "creating a Examen" do
    visit examenes_url
    click_on "New Examen"

    fill_in "Descripcion", with: @examen.descripcion
    fill_in "Nombre", with: @examen.nombre
    click_on "Create Examen"

    assert_text "Examen was successfully created"
    click_on "Back"
  end

  test "updating a Examen" do
    visit examenes_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @examen.descripcion
    fill_in "Nombre", with: @examen.nombre
    click_on "Update Examen"

    assert_text "Examen was successfully updated"
    click_on "Back"
  end

  test "destroying a Examen" do
    visit examenes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Examen was successfully destroyed"
  end
end
