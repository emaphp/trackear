const hourlyRateField = document.getElementById('hourlyRateField')
const fixedRateField = document.getElementById('fixedRateField')
const fixedPriceInput = document.getElementById('fixedPriceInput')

document.getElementById('fixedRateButton').onclick = () => {
  hourlyRateField.style.display = 'none'
  fixedRateField.style.display = 'block'
}

document.getElementById('hourlyRateButton').onclick = () => {
  hourlyRateField.style.display = 'block'
  fixedRateField.style.display = 'none'
  fixedPriceInput.value = ''
}
