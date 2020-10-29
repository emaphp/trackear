/// <reference types="Cypress" />

describe('Invite team members', () => {
  beforeEach(() => {
    cy.appScenario('project_invite_member');
    loginProjectAdmin()
    cy.visit('/')
  })

  const invitedUser = {
    firstName: 'Lorem',
    lastName: 'Ipsum',
    email: 'lorem@ipsum.com',
    password: 'my-super-secret-password',
    project_rate: '42',
    user_rate: '24',
    rol: 'Developer'
  }

  function loginProjectAdmin() {
    cy.login('project-invite-member@email.com', 'test123456')
  }

  function visitProject() {
    cy.visit('/')
    cy.findLink('Testing project').click()
  }

  function inviteMember({ firstName, lastName, email, password, rol, project_rate, user_rate }) {
    visitProject()
    cy.findLink('Agregar miembro').click()

    cy.findInput('Email').type(email)
    cy.findInput('Actividad').type(rol)
    cy.findInput('Tarifa del proyecto por hora').type(project_rate)
    cy.findInput('Tarifa por hora del miembro').type(user_rate)
    cy.findButton('Agregar miembro').click()

    cy.findAlert().contains('El nuevo miembro ha sido invitado exitosamente, cuando ingresen en Trackear van a tener acceso al proyecto')
  }

  function logoutAndCreateAccount({ firstName, lastName, email, password }) {
    cy.logout()
    cy.register({
      firstName,
      lastName,
      email,
      password
    })
  }

  function acceptInvitation() {
    cy.visit('/')
    cy.findLink('Aceptar').click()
  }

  function declineInvitation() {
    cy.visit('/')
    cy.findLink('Rechazar').click()
  }

  function inviteAndAcceptUser(user) {
    inviteMember(user)
    logoutAndCreateAccount(user)
    acceptInvitation()
    cy.logout()
    loginProjectAdmin()
  }

  function visitInvitedUserContract({ firstName, lastName }) {
    visitProject()
    cy.findLink(`${firstName} ${lastName}`).click()
  }

  it('should be able to invite', () => {
    inviteMember(invitedUser)
    logoutAndCreateAccount(invitedUser)
    cy.get(`div:contains("${invitedUser.firstName}, te han invitado a unirte al proyecto Testing project.")`)
  })

  it('should be able to decline invitation', () => {
    inviteMember(invitedUser)
    logoutAndCreateAccount(invitedUser)
    declineInvitation()
    cy.get('p:contains("No tenes proyectos... ¡todavía!")')
  })

  it('should be able to accept invitations', () => {
    inviteMember(invitedUser)
    logoutAndCreateAccount(invitedUser)
    acceptInvitation()
    visitProject()
  })

  it('should accept and create the contract accordingly', () => {
    inviteAndAcceptUser(invitedUser)
    visitProject()
    visitInvitedUserContract(invitedUser)

    cy.findInputWithValue('Actividad', invitedUser.rol)
    cy.findInputWithValue('Tarifa del proyecto por hora', `${invitedUser.project_rate}.0`)
    cy.findInputWithValue('Tarifa por hora del miembro', `${invitedUser.user_rate}.0`)
  })

  it('should be able to remove user from project', () => {
    inviteAndAcceptUser(invitedUser)
    visitInvitedUserContract(invitedUser)

    cy.findLink('Remover usuario del proyecto').click()
    cy.logout()
    cy.login(invitedUser.email, invitedUser.password)
    cy.get('p:contains("No tenes proyectos... ¡todavía!")')
  })
})
