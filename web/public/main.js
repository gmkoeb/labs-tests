const url = 'http://localhost:3000/tests' + environment()

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.forEach(function(test) {
      const tr = document.createElement('tr')
      const name = document.createElement('td')
      const registrationNumber = document.createElement('td')
      const patientEmail = document.createElement('td')
      const birthDate = document.createElement('td')
      const address = document.createElement('td')
      const city = document.createElement('td')
      const state = document.createElement('td')
      const doctorName = document.createElement('td')
      const doctorEmail = document.createElement('td')
      const crm = document.createElement('td')
      const crmState = document.createElement('td')
      const token = document.createElement('td')
      const date = document.createElement('td')
      const type = document.createElement('td')
      const typeLimits = document.createElement('td')
      const typeResult = document.createElement('td')

      name.textContent = `${test.patient_name}`
      registrationNumber.textContent = `${test.registration_number}`
      patientEmail.textContent = `${test.patient_email}`
      birthDate.textContent = `${test.birth_date}`
      address.textContent = `${test.address}`
      city.textContent = `${test.city}`
      state.textContent = `${test.state}`
      doctorName.textContent = `${test.doctor_name}`
      doctorEmail.textContent = `${test.doctor_email}`
      crm.textContent = `${test.crm}`
      crmState.textContent = `${test.crm_state}`
      token.textContent = `${test.token}`
      date.textContent = `${test.date}`
      type.textContent = `${test.type}`
      typeLimits.textContent = `${test.type_limits}`
      typeResult.textContent = `${test.type_result}`

      tr.appendChild(name)
      tr.appendChild(registrationNumber)
      tr.appendChild(patientEmail)
      tr.appendChild(birthDate)
      tr.appendChild(address)
      tr.appendChild(city)
      tr.appendChild(state)
      tr.appendChild(doctorName)
      tr.appendChild(doctorEmail)
      tr.appendChild(crm)
      tr.appendChild(crmState)
      tr.appendChild(token)
      tr.appendChild(date)
      tr.appendChild(type)
      tr.appendChild(typeLimits)
      tr.appendChild(typeResult)

      document.querySelector('tbody').appendChild(tr)
    })
  }).
  catch(function(error) {
    console.log(error);
});

function environment() {
  const isUserAgentHeadless = navigator.userAgent.includes('HeadlessChrome')
  if (isUserAgentHeadless === true) {
    return '?env=test'
  }else
  {
    return ''
  }
}
