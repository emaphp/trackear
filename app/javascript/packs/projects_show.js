import { Elm } from '../PageProjectsShow'

document.addEventListener('turbolinks:load', function () {
  const parent = document.getElementById('stopwatch-timer')

  if (!parent) return

  const timer = parent.dataset.timer;
  const node = document.createElement('div')

  while (parent.firstChild) {
    parent.removeChild(parent.firstChild)
  }

  parent.appendChild(node)

  Elm.PageProjectsShow.init({
    node: node,
    flags: Number(timer),
  })
})
