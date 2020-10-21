/// <reference types="Cypress" />

describe('Settings', () => {
  beforeEach(() => {
    cy.appScenario('login');
    cy.login('john@doe.com', 'test123456')
  })

  function goToSettings() {
    cy.visit('/settings')
  }

  it('should be able to go to settings from home', () => {
    cy.findLink('Preferencias').click()
    cy.urlContains('/settings')
  })

  it('should take us back home when clicking cancel', () => {
    goToSettings()
    cy.findLink('Cancelar').click()
    cy.urlContains('/')
  })

  it('should display user information', () => {
    goToSettings()
    cy.findInputWithValue('Nombre', 'john')
    cy.findInputWithValue('Apellido', 'doe')
    cy.findInputWithValue('Idioma', 'es')
    cy.findInputWithValue('Time Zone', 'Eastern Time (US & Canada)')
    cy.findInputWithValue('Nombre de la empresa', '')
    cy.findInputWithValue('Dirección de la empresa', '')
    cy.findInputWithValue('Email de la empresa', '')
  })

  it('should allow user to update values', () => {
    goToSettings()
    cy.findInput('Nombre').clear().type('John')
    cy.findInput('Apellido').clear().type('Doe')
    cy.findInput('Nombre de la empresa').type('Known company')
    cy.findInput('Dirección de la empresa').type('Fake address 123')
    cy.findInput('Email de la empresa').type('fake@company.com')

    cy.findButton('Guardar').click()
    cy.findAlert().contains('Successfully updated.')

    cy.findInputWithValue('Nombre', 'John')
    cy.findInputWithValue('Apellido', 'Doe')
    cy.findInputWithValue('Nombre de la empresa', 'Known company')
    cy.findInputWithValue('Dirección de la empresa', 'Fake address 123')
    cy.findInputWithValue('Email de la empresa', 'fake@company.com')
  })

  it('should update language', () => {
    goToSettings()
    cy.findInput('Idioma').select('🇺🇸 English')
    cy.findButton('Guardar').click()
    cy.findButton('Save')
  })
})
