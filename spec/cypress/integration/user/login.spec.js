/// <reference types="Cypress" />

describe('Login', () => {
  beforeEach(() => {
    cy.appScenario('login');
    cy.visit('/')
    cy.findLink('Ingresar').click()
  })

  it('should login if credentials are ok', () => {
    cy.findInput('Email').type('john@doe.com')
    cy.findInput('Password').type('test123456')
    cy.findButton('Log in').click()
    cy.findAlert().contains('¡Es bueno verte por acá!')
  })

  it('should not log in if credentials are invalid', () => {
    cy.findInput('Email').type('lorem@ipsum')
    cy.findInput('Password').type('test123456')
    cy.findButton('Log in').click()
    cy.urlContains('/users/sign_in')
  })
})
