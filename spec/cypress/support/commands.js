// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })
import 'cypress-file-upload'

Cypress.Commands.add('findLink', (text) => {
  cy.get(`a:contains("${text}")`)
})

Cypress.Commands.add('findButton', (text) => {
  cy.get(`
    button:contains("${text}"),
    input[type="submit"]:contains("${text}"),
    input[type="submit"][value="${text}"]`
  )
})

Cypress.Commands.add('findInput', (text) => {
  cy.get(`label:contains("${text}")`).parent().find('input,select,textarea').first()
})

Cypress.Commands.add('findInputWithValue', (text, value) => {
  cy.findInput(text).should('have.value', value)
})

Cypress.Commands.add('findAlert', () => {
  cy.get('div.text-lg.p-4.font-bold.bg-green-200.text-green-600.text-center.flex.items-center.justify-center')
})

Cypress.Commands.add('urlContains', (contains) => {
  cy.url().should('include', contains)
})

Cypress.Commands.add('login', (email, password) => {
  cy.visit('/users/sign_in')
  cy.findInput('Email').type(email)
  cy.findInput('Password').type(password)
  cy.findButton('Log in').click()
})

Cypress.Commands.add('logout', () => {
  cy.findLink('Salir').first().click()
})

Cypress.Commands.add('register', ({ firstName, lastName, email, password }) => {
  cy.visit('/users/sign_up')
  cy.findInput('Nombre').type(firstName)
  cy.findInput('Apellido').type(lastName)
  cy.findInput('Email').type(email)
  cy.findInput('Password').type(password)
  cy.findInput('Password confirmation').type(password)
  cy.findButton('Registrarse').click()
})

Cypress.Commands.add('findFormErrors', () => {
  cy.get('.alert.alert-danger.mb-4 ul li')
})

Cypress.Commands.add('containsExact', { prevSubject: 'optional' }, (subject, text) => {
  const exactText = new RegExp(`^${text}$`)

  if (subject) return cy.wrap(subject).contains(exactText)
  return cy.contains(exactText)
})
