// import { Elm } from '../Main'

require("turbolinks").start()
require('@rails/ujs').start()

import '../css/main.scss'

document.addEventListener('DOMContentLoaded', () => {
  const target = document.createElement('div')

  document.body.appendChild(target)
  // Elm.Main.init({ node: target })
})
