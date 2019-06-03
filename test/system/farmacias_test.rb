require "application_system_test_case"

class FarmaciasTest < ApplicationSystemTestCase
  setup do
    @farmacia = farmacias(:one)
  end

  test "visiting the index" do
    visit farmacias_url
    assert_selector "h1", text: "Farmacias"
  end

  test "creating a Farmacia" do
    visit farmacias_url
    click_on "New Farmacia"

    fill_in "Comuna", with: @farmacia.comuna_id
    fill_in "Contacto", with: @farmacia.contacto
    fill_in "Direccion", with: @farmacia.direccion
    fill_in "Fono", with: @farmacia.fono
    fill_in "Nombre", with: @farmacia.nombre
    fill_in "Tipo", with: @farmacia.tipo
    click_on "Create Farmacia"

    assert_text "Farmacia was successfully created"
    click_on "Back"
  end

  test "updating a Farmacia" do
    visit farmacias_url
    click_on "Edit", match: :first

    fill_in "Comuna", with: @farmacia.comuna_id
    fill_in "Contacto", with: @farmacia.contacto
    fill_in "Direccion", with: @farmacia.direccion
    fill_in "Fono", with: @farmacia.fono
    fill_in "Nombre", with: @farmacia.nombre
    fill_in "Tipo", with: @farmacia.tipo
    click_on "Update Farmacia"

    assert_text "Farmacia was successfully updated"
    click_on "Back"
  end

  test "destroying a Farmacia" do
    visit farmacias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Farmacia was successfully destroyed"
  end
end
