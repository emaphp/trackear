/// <reference types="Cypress" />

describe('Invoice', () => {
  beforeEach(() => {
    cy.appScenario('invoice_creation');
    cy.login('invoice@email.com', 'test123456')
    visitInvoiceCreation()
  })

  function visitProject() {
    cy.visit('/')
    cy.findLink('Testing project').click()
  }

  function visitInvoiceCreation() {
    visitProject()
    cy.findLink('Crear factura').click()
  }

  function openCalendar() {
    cy.findButton('Seleccionar fecha').click()
  }

  function clickOnCalendarDay(day) {
    const daySelector = 'div.elm-datetimepicker-duration--calendar-day:visible'
    cy.get(daySelector).contains(day).first().trigger('mouseover')
    cy.wait(1)
    cy.get(daySelector).contains(day).first().click()
  }

  function findSummaryWith(user, expectedHours, expectedAmount) {
    cy.contains(user)
    cy.contains(user).parent().parent().contains(expectedHours)
    cy.contains(user).parent().parent().contains(expectedAmount)
  }

  function findStatusWith(user, status) {
    cy.contains(user)
    cy.contains(user).parent().parent().contains(status)
  }

  function closeCalendar() {
    cy.get('#invoice-form').click('top')
  }

  function createInvoice(from, to) {
    openCalendar()
    clickOnCalendarDay(from)
    clickOnCalendarDay(to)
    closeCalendar()
    cy.findButton('Continuar').click()
    cy.findButton('Crear factura').click()
  }

  function createInvoiceAndConfirmHours(from, to) {
    createInvoice(from, to)
    visitProject()
    cy.findLink('Si, las horas y montos son correctos').click()
  }

  it('should be able to create invoices', () => {
    openCalendar()
    clickOnCalendarDay('1')
    clickOnCalendarDay('28')
    closeCalendar()

    cy.findButton('Continuar').click()

    findSummaryWith('john doe', '00:30', '$21,00')

    cy.findButton('Crear factura').click()

    cy.contains('Esperando confirmación del equipo')
    cy.contains('Esperando a que todos los miembros del equipo confirmen su tiempo registrado')

    findStatusWith('john doe', 'Esperando confirmación')
  })

  it('should be able to select another date', () => {
    openCalendar()
    clickOnCalendarDay('1')
    clickOnCalendarDay('28')
    closeCalendar()
    cy.findButton('Continuar').click()

    cy.findButton('Elegir otra fecha').click()
    openCalendar()
    clickOnCalendarDay('5')
    clickOnCalendarDay('25')
    closeCalendar()
    cy.findButton('Continuar').click()

    findSummaryWith('john doe', '00:00', '$0,00')
  })

  it('should display confirm hours notification', () => {
    createInvoice('1', '28')
    visitProject()
    cy.contains('registraste 30 minutos, haciendo un total de $21')
  })

  it('should be able to confirm hours', () => {
    createInvoiceAndConfirmHours('1', '28')
    cy.contains('Esperando el pago...')
    cy.contains('Esperando el pago por parte del administrador del proyecto')
    visitProject()
    cy.findLink('Factura cliente').click()
    findStatusWith('john doe', 'Confirmado')
  })

  it('should be able to see team member invoice details after hours confirmation', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.contains('invoice@email.com').parent().find('a:contains("Detalles")').click()
    cy.contains('Lorem ipsum') // track description
    cy.contains('42.0') // rate
    cy.contains('0.5') // quantity
    cy.contains('$21') // total
    cy.contains('SUBTOTAL').parent().next().contains('$21')
    cy.containsExact('TOTAL').parent().next().contains('$21')
  })

  it('should be able to create client invoice for review after all confirmed', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findAlert().contains('Registros agregados exitosamente.')
    cy.contains('Revisar factura de cliente')
    cy.contains('Última revisión antes de crear la factura. Asegurate de que todo esté en órden.')
  })

  it('should be able to create client invoice', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findLink('Crear factura').click()
    cy.findAlert().contains('Email notification sent.')
    cy.contains('Esperando por el pago del cliente')
    cy.contains('Esperá por el pago del cliente. Una vez efectuado, registrá el pago y la cotización')
  })

  it('should be able to see client invoice details after created', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findLink('Crear factura').click()
    cy.findLink('Detalles').first().click()
  })

  it('should be able to register client payment', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findLink('Crear factura').click()
    cy.findInput('Exchange').clear().type('50')
    cy.findButton('Registrar pago').click()
    cy.contains('Esperando a que el usuario suba la factura AFIP')
    cy.contains('Monto factura AFIP: $1.050')
    cy.findLink('Atrás').click()
    cy.contains('Factura equipo').parent().children().first().click()
    cy.contains('Subir factura AFIP')
    cy.contains('El administrator requiere que subas una factura AFIP para realizar el pago')
  })

  it('should be able to upload afip invoice', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findLink('Crear factura').click()
    cy.findButton('Registrar pago').click()
    cy.findLink('Atrás').click()
    cy.contains('Factura equipo').parent().children().first().click()
    cy.findInput('Factura AFIP').attachFile('afip-invoice.pdf', { allowEmpty: true })
    cy.findButton('Subir factura').click()
    cy.findAlert().contains('Factura adjuntada exitosamente.')
    cy.contains('Pago en proceso')
    cy.contains('El administrador del proyecto esta procesando tu pago')
  })

  it('should be able to upload payment receipt', () => {
    createInvoiceAndConfirmHours('1', '28')
    visitProject()
    cy.findLink('Factura cliente').click()
    cy.findLink('Crear factura de cliente para revisar').click()
    cy.findLink('Crear factura').click()
    cy.findButton('Registrar pago').click()
    cy.findLink('Atrás').click()
    cy.contains('Factura equipo').parent().children().first().click()
    cy.findInput('Factura AFIP').attachFile('afip-invoice.pdf', { allowEmpty: true })
    cy.findButton('Subir factura').click()
    cy.findLink('Atrás').click()
    cy.contains('Factura client').parent().children().first().click()
    cy.findInput('Recibo de pago').attachFile('payment-receipt.pdf', { allowEmpty: true })
    cy.findButton('Registrar pago').click()
    cy.findAlert().contains('Recibo de pago adjuntado exitosamente.')
    cy.contains('Pago completado')
    cy.contains('Esta factura ya fue pagada')
    cy.findLink('Atrás').click()
    cy.contains('Factura client').parent().children().first().click()
    cy.contains('Factura completada')
    cy.contains('Esta factura ya ha sido completada')
  })
})
