require "application_system_test_case"

class PrestadoresTest < ApplicationSystemTestCase
  setup do
    @prestador = prestadores(:one)
  end

  test "visiting the index" do
    visit prestadores_url
    assert_selector "h1", text: "Prestadores"
  end

  test "creating a Prestador" do
    visit prestadores_url
    click_on "New Prestador"

    fill_in "Comuna", with: @prestador.comuna_id
    fill_in "Contacto", with: @prestador.contacto
    fill_in "Direccion", with: @prestador.direccion
    fill_in "Fono", with: @prestador.fono
    fill_in "Nombre", with: @prestador.nombre
    click_on "Create Prestador"

    assert_text "Prestador was successfully created"
    click_on "Back"
  end

  test "updating a Prestador" do
    visit prestadores_url
    click_on "Edit", match: :first

    fill_in "Comuna", with: @prestador.comuna_id
    fill_in "Contacto", with: @prestador.contacto
    fill_in "Direccion", with: @prestador.direccion
    fill_in "Fono", with: @prestador.fono
    fill_in "Nombre", with: @prestador.nombre
    click_on "Update Prestador"

    assert_text "Prestador was successfully updated"
    click_on "Back"
  end

  test "destroying a Prestador" do
    visit prestadores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Prestador was successfully destroyed"
  end
end
