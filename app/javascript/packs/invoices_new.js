import { Elm } from '../Main'

document.addEventListener('turbolinks:load', function () {
  const parent = document.getElementById('invoice-form')

  if (!parent) return

  const node = document.createElement('div')

  while (parent.firstChild) {
    parent.removeChild(parent.firstChild)
  }

  parent.appendChild(node)

  Elm.Main.init({ node: node })
})
