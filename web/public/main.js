const testsUrl = 'http://localhost:3000/tests' + environment()
const doctorsUrl = 'http://localhost:3000/doctors' + environment()
const patientsUrl = 'http://localhost:3000/patients' + environment()

fetch(testsUrl).
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

      document.getElementById('examsBody').appendChild(tr)
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

function toggleElement(event) {
  const doctors = document.getElementById('doctors')
  const patients = document.getElementById('patients')
  const exams = document.getElementById('exams')
  const buttons = document.querySelectorAll('.navLink');
  const clickedButton = event.target
  clickedButton.classList.toggle('active')
  buttons.forEach((btn) => {
    if (btn !== clickedButton) {
      btn.classList.remove('active');
    }
  })
  if(event.target.innerHTML === 'Exames'){
    doctors.style.display = "none"
    patients.style.display = "none"
    exams.style.display = ""
  }else if(event.target.innerHTML === 'Médicos'){
    getDoctors(doctorsUrl)
    doctors.style.display = ""
    patients.style.display = "none"
    exams.style.display = "none"
  }else{
    getPatients(patientsUrl)
    doctors.style.display = "none"
    patients.style.display = ""
    exams.style.display = "none"
  }
}

function getDoctors(doctorsUrl){
  doctorsTable = document.getElementById('doctorsBody')
  if (doctorsTable.childElementCount === 0){
    fetch(doctorsUrl).
    then((response) => response.json()).
    then((data) => {
      data.forEach(function(doctor) {
        const tr = document.createElement('tr')
        const doctorName = document.createElement('td')
        const doctorEmail = document.createElement('td')
        const crm = document.createElement('td')
        const crmState = document.createElement('td')

        doctorName.textContent = `${doctor.name}`
        doctorEmail.textContent = `${doctor.email}`
        crm.textContent = `${doctor.crm}`
        crmState.textContent = `${doctor.crm_state}`

        tr.appendChild(doctorName)
        tr.appendChild(doctorEmail)
        tr.appendChild(crm)
        tr.appendChild(crmState)
        doctorsTable.appendChild(tr)
      })
    }).
    catch(function(error) {
      console.log(error)
    })
  }
}

function getPatients(patientsUrl){
  patientsTable = document.getElementById('patientsBody')
  if (patientsTable.childElementCount === 0){
    fetch(patientsUrl).
    then((response) => response.json()).
    then((data) => {
      data.forEach(function(patient) {
        const tr = document.createElement('tr')
        const patientName = document.createElement('td')
        const registrationNumber = document.createElement('td')
        const patientEmail = document.createElement('td')
        const birthDate = document.createElement('td')
        const address = document.createElement('td')
        const city = document.createElement('td')
        const state = document.createElement('td')

        patientName.textContent = `${patient.name}`
        registrationNumber.textContent = `${patient.registration_number}`
        patientEmail.textContent = `${patient.email}`
        birthDate.textContent = `${patient.birth_date}`
        address.textContent = `${patient.address}`
        city.textContent = `${patient.city}`
        state.textContent = `${patient.state}`

        tr.appendChild(patientName)
        tr.appendChild(registrationNumber)
        tr.appendChild(patientEmail)
        tr.appendChild(birthDate)
        tr.appendChild(address)
        tr.appendChild(city)
        tr.appendChild(state)
        patientsTable.appendChild(tr)

    })
  }).
  catch(function(error) {
    console.log(error)
  })}
}

function filterPatients() {
  const input = document.getElementById('filterInput').value.toUpperCase();
  const rows = document.getElementsByTagName('tr');
  
  for (let i = 0; i < rows.length; i++) {
    const name = rows[i].getElementsByTagName('td')[0];
    const doctorName = rows[i].getElementsByTagName('td')[7];

    if (name && doctorName) {
      const patientTextValue = name.textContent || name.innerText;
      const doctorTextValue = doctorName.textContent || doctorName.innerText;
      
      if (patientTextValue.toUpperCase().indexOf(input) > -1 || doctorTextValue.toUpperCase().indexOf(input) > -1) {
        rows[i].style.display = '';
      } else {
        rows[i].style.display = 'none';
      }
    } else if (name){
      const textValue = name.textContent || name.innerText;
      
      if (textValue.toUpperCase().indexOf(input) > -1) {
        rows[i].style.display = '';
      } else {
        rows[i].style.display = 'none';
      }
    }
  }
}