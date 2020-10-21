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
  cy.get(`label:contains("${text}")`).parent().find('input').first()
})

Cypress.Commands.add('findAlert', () => {
  cy.get('div.text-lg.p-4.font-bold.bg-green-200.text-green-600.text-center.flex.items-center.justify-center')
})

Cypress.Commands.add('urlContains', (contains) => {
  cy.url().should('include', contains)
})
