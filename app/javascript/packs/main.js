// require("turbolinks").start()
require('@rails/ujs').start()

import '../css/main.scss'

document.addEventListener('DOMContentLoaded', function () {
  document.dispatchEvent(new Event('turbolinks:load'))
})
