/// <reference types="Cypress" />

describe('Project', () => {
  beforeEach(() => {
    cy.appScenario('login');
    cy.login('john@doe.com', 'test123456')
  })

  function goToCreateProject() {
    cy.visit('/projects/new')
  }

  function submitCreateProject() {
    cy.findButton('Crear proyecto').click()
  }

  function createProject(name) {
    goToCreateProject()
    cy.findInput('Nombre').type(name)
    submitCreateProject()
  }

  it('should be able to create new projects from home', () => {
    cy.findLink('Crear nuevo proyecto').last().click()
    cy.urlContains('/projects/new')
  })

  it('should be able to create projects', () => {
    createProject('Testing project')
    cy.findAlert().contains('Proyecto creado exitosamente.')
  })

  it('should display projects in home page', () => {
    const projectName = 'Listed in home'
    createProject(projectName)
    cy.visit('/')
    cy.findLink(projectName)
  })

  it('should take us back home when clicking cancel', () => {
    goToCreateProject()
    cy.findLink('Cancelar').click()
    cy.urlContains('/')
  })

  it('should present onboarding when creating new project', () => {
    const projectName = 'Onboarding testing proyect'

    createProject(projectName)
    cy.urlContains('/onboarding')

    // First step, setting up rates
    cy.findInput('Tu tarifa por hora').clear().type('42')
    cy.findButton('Guardar e invitar miembros').click()

    // Second step, inviting team members
    cy.findInput('Email').type('lorem@ipsum.com')
    cy.findInput('Actividad').type('Developer')
    cy.findInput('Tarifa del proyecto por hora').clear().type('42')
    cy.findInput('Tarifa por hora del miembro').clear().type('42')
    cy.findButton('Agregar miembro').click()
    cy.findAlert().contains('Miembro invitado exitosamente')
    cy.findLink('Listo').click()

    cy.urlContains('/onboarding_done')
    cy.get(`h1:contains("🎉 Listo, ¡ya estás listo para comenzar con tu proyecto!")`)
    cy.findLink(`Ir a ${projectName}`).click()
  })

  it('should throw error if name empty', () => {
    goToCreateProject()
    submitCreateProject()
    cy.findFormErrors().contains('Name es requerido')
  })
})
