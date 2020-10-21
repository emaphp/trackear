/// <reference types="Cypress" />

describe('Track activity', () => {
  beforeEach(() => {
    cy.appScenario('project_track_activity');
    cy.login('project-activty@email.com', 'test123456')
    cy.visit('/')
  })

  function logTime(howMuch, description) {
    cy.visit('/')
    cy.findLink('Testing project').click()
    cy.findLink('Registrar horas de trabajo').first().click()
    cy.findInput('Horas (formato hh:mm)').clear().type(howMuch)
    cy.findInput('Descripción').type(description)
    cy.findButton('Registrar horas de trabajo').click()
  }

  function findStatWithValue(stat, value) {
    cy.get(`span:contains("${stat}")`).next().contains(value)
  }

  it('should be able to track time', () => {
    logTime('00:30', 'Lorem ipsum')
    cy.findAlert().contains('Registro de trabajo creado.')
  })

  it('should display logged time', () => {
    cy.findLink('Testing project').click()
    cy.get('p').contains('No se encontraron registros...')

    logTime('02:30', 'Sit amet')
    cy.get('p').contains('Sit amet')
  })

  it('should allow to remove tracks', () => {
    logTime('02:30', 'To be deleted')
    cy.findLink('Borrar').click()
    cy.findAlert().contains('Registro de trabajo descartado exitosamente.')
  })

  it('should allow to edit tracks', () => {
    logTime('02:30', 'To be changed')
    cy.findLink('Editar').last().click()
    cy.findInput('Descripción').clear().type('New description')
    cy.findButton('Actualizar registro').click()
    cy.findAlert().contains('Registro de trabajo actualizado exitosamente.')
  })

  it('should calculate the stats based on tracks', () => {
    const hours = 3
    const rate_per_hour = 42
    cy.findLink('Testing project').click()
    logTime('02:30', 'Lorem')
    logTime('00:30', 'Ipsum')
    findStatWithValue('Registros totales', '2')
    findStatWithValue('Tiempo registrado', `${3} horas`)
    findStatWithValue('Facturable', `$${hours * rate_per_hour}`)
  })
})
