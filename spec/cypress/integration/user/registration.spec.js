/// <reference types="Cypress" />

describe('Registration', () => {
  beforeEach(() => {
    cy.appScenario('registration');
    cy.visit('/')
    cy.findLink('Registrarse gratis').click()
  })

  function findError(error) {
    cy.get('#error_explanation ul li').contains(error)
  }

  function completeForm({
    firstName,
    lastName,
    email,
    password,
    confirmPassword
  }) {
    cy.findInput('Nombre').type(firstName)
    cy.findInput('Apellido').type(lastName)
    cy.findInput('Email').type(email)
    cy.findInput('Password').type(password)
    cy.findInput('Password confirmation').type(confirmPassword)
  }

  function submitForm() {
    cy.findButton('Registrarse').click()
  }

  function completeFormAndSubmit(form) {
    completeForm(form)
    submitForm()
  }

  it('cannot use taken email', () => {
    completeFormAndSubmit({
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@doe.com',
      password: 'my-super-secret-password',
      confirmPassword: 'my-super-secret-password'
    })
    findError('Email ya está siendo usado')
  })

  it('has to display errors if fields are not completed', () => {
    submitForm()
    findError('Email es requerido')
    findError('Password es requerido')
    findError('First name es requerido')
    findError('Last name es requerido')
  })

  it('can register', () => {
    completeFormAndSubmit({
      firstName: 'Lorem',
      lastName: 'Ipsum',
      email: 'lorem@ipsum.com',
      password: 'my-super-secret-password',
      confirmPassword: 'my-super-secret-password'
    })
    cy.findAlert().contains('Te registraste exitosamente, ¡bienvenido!')
  })
})
