import { Elm } from '../../Page/Invoices/New'
import * as Rails from "@rails/ujs"

document.addEventListener('turbolinks:load', function () {
  const parent = document.getElementById('invoice-form')

  if (!parent) return

  const node = document.createElement('div')
  const props = {
    project_id: parent.dataset.project_id,
    name_label: parent.dataset.name_label,
    hours_label: parent.dataset.hours_label,
    amount_label: parent.dataset.amount_label,
    date_label: parent.dataset.date_label,
    choose_another_date_label: parent.dataset.choose_another_date_label,
    create_invoice_label: parent.dataset.create_invoice_label,
    continue_label: parent.dataset.continue_label,
    select_date_label: parent.dataset.select_date_label,
    default_avatar: parent.dataset.default_avatar,
    authenticity_token: Rails.csrfToken() || ''
  }

  while (parent.firstChild) {
    parent.removeChild(parent.firstChild)
  }

  parent.appendChild(node)

  Elm.Page.Invoices.New.init({
    node: node,
    flags: props
  })
})
