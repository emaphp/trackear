/// <reference types="Cypress" />

describe('Login', () => {
  beforeEach(() => {
    cy.appScenario('login');
  })

  it('can go to log in from home', () => {
    cy.visit('/')
    cy.findLink('Ingresar').click()
    cy.urlContains('/users/sign_in')
  })

  it('should login if credentials are ok', () => {
    cy.login('john@doe.com', 'test123456')
    cy.findAlert().contains('¡Es bueno verte por acá!')
  })

  it('should not log in if credentials are invalid', () => {
    cy.login('lorem@ipsum.com', '1234')
    cy.urlContains('/users/sign_in')
  })
})
