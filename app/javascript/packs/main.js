import { Elm } from '../Main'

import 'application.scss'

document.addEventListener('DOMContentLoaded', () => {
  const target = document.createElement('div')

  document.body.appendChild(target)
  Elm.Main.init({ node: target })
})
