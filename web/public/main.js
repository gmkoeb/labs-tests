let testsUrl = 'http://localhost:3000/tests' + environment();
const doctorsUrl = 'http://localhost:3000/doctors' + environment();
const patientsUrl = 'http://localhost:3000/patients' + environment();
const importUrl = 'http://localhost:3000/import' + environment();

const doctors = document.getElementById('doctors');
const patients = document.getElementById('patients');
const exams = document.getElementById('exams');
const buttons = document.querySelectorAll('.navLink');
const emptyMessage = document.getElementById('emptyMessage');
const uploadStatus = document.getElementById('uploadStatus')

getTests();

function getTests() {
  fetch(testsUrl)
    .then((response) => response.json())
    .then((data) => {
      data.forEach(function(test) {
        test.tests.forEach(function(testItem) {
          const tr = document.createElement('tr');
          const name = document.createElement('td');
          const registrationNumber = document.createElement('td');
          const patientEmail = document.createElement('td');
          const birthDate = document.createElement('td');
          const doctorName = document.createElement('td');
          const crm = document.createElement('td');
          const crmState = document.createElement('td');
          const token = document.createElement('td');
          const date = document.createElement('td');
          const type = document.createElement('td');
          const typeLimits = document.createElement('td');
          const typeResult = document.createElement('td');
  
          name.textContent = `${test.name}`;
          registrationNumber.textContent = `${test.registration_number}`;
          patientEmail.textContent = `${test.email}`;
          birthDate.textContent = `${test.birth_date}`;
          doctorName.textContent = `${test.doctor.name}`;
          crm.textContent = `${test.doctor.crm}`;
          crmState.textContent = `${test.doctor.crm_state}`;
          token.textContent = `${test.token}`;
          date.textContent = `${test.date}`;
          type.textContent = `${testItem.type}`;
          typeLimits.textContent = `${testItem.type_limits}`;
          typeResult.textContent = `${testItem.type_result}`;
  
          tr.appendChild(name);
          tr.appendChild(registrationNumber);
          tr.appendChild(patientEmail);
          tr.appendChild(birthDate);
          tr.appendChild(doctorName);
          tr.appendChild(crm);
          tr.appendChild(crmState);
          tr.appendChild(token);
          tr.appendChild(date);
          tr.appendChild(type);
          tr.appendChild(typeLimits);
          tr.appendChild(typeResult);
  
          document.getElementById('examsBody').appendChild(tr);
        });
      });
    })
    .catch(function(error) {
      console.log(error);
  });
}

function environment() {
  const isUserAgentHeadless = navigator.userAgent.includes('HeadlessChrome');
  if (isUserAgentHeadless === true) {
    return '?env=test';
  }else
  {
    return '';
  }
}

function toggleElement(event) {
  document.getElementById('filteredExams').style.display = 'none'
  emptyMessage.textContent = ''
  uploadStatus.textContent = ''
  const clickedButton = event.target;
  clickedButton.classList.toggle('active');
  buttons.forEach((btn) => {
    if (btn !== clickedButton) {
      btn.classList.remove('active');
    }
  })
  if(event.target.innerHTML === 'Exames'){
    doctors.style.display = "none";
    patients.style.display = "none";
    exams.style.display = "";
  }else if(event.target.innerHTML === 'Médicos'){
    getDoctors(doctorsUrl);
    doctors.style.display = "";
    patients.style.display = "none";
    exams.style.display = "none";
  }else{
    getPatients(patientsUrl);
    doctors.style.display = "none";
    patients.style.display = "";
    exams.style.display = "none";
  }
}

function getDoctors(doctorsUrl){
  doctorsTable = document.getElementById('doctorsBody');
  if (doctorsTable.childElementCount === 0){
    fetch(doctorsUrl).
    then((response) => response.json()).
    then((data) => {
      data.forEach(function(doctor) {
        const tr = document.createElement('tr');
        const doctorName = document.createElement('td');
        const doctorEmail = document.createElement('td');
        const crm = document.createElement('td');
        const crmState = document.createElement('td');

        doctorName.textContent = `${doctor.name}`;
        doctorEmail.textContent = `${doctor.email}`;
        crm.textContent = `${doctor.crm}`;
        crmState.textContent = `${doctor.crm_state}`;

        tr.appendChild(doctorName);
        tr.appendChild(doctorEmail);
        tr.appendChild(crm);
        tr.appendChild(crmState);
        doctorsTable.appendChild(tr);
      })
    }).
    catch(function(error) {
      console.log(error);
    })
  }
}

function getPatients(patientsUrl){
  patientsTable = document.getElementById('patientsBody');
  if (patientsTable.childElementCount === 0){
    fetch(patientsUrl).
    then((response) => response.json()).
    then((data) => {
      data.forEach(function(patient) {
        const tr = document.createElement('tr');
        const patientName = document.createElement('td');
        const registrationNumber = document.createElement('td');
        const patientEmail = document.createElement('td');
        const birthDate = document.createElement('td');
        const address = document.createElement('td');
        const city = document.createElement('td');
        const state = document.createElement('td');

        patientName.textContent = `${patient.name}`;
        registrationNumber.textContent = `${patient.registration_number}`;
        patientEmail.textContent = `${patient.email}`;
        birthDate.textContent = `${patient.birth_date}`;
        address.textContent = `${patient.address}`;
        city.textContent = `${patient.city}`;
        state.textContent = `${patient.state}`;

        tr.appendChild(patientName);
        tr.appendChild(registrationNumber);
        tr.appendChild(patientEmail);
        tr.appendChild(birthDate);
        tr.appendChild(address);
        tr.appendChild(city);
        tr.appendChild(state);
        patientsTable.appendChild(tr);

    })
  }).
  catch(function(error) {
    console.log(error);
  })}
}

function getFilteredExams(event){
  event.preventDefault();
  exams.style.display = 'none';
  doctors.style.display = 'none';
  patients.style.display = 'none';
  document.getElementById('filteredExams').style.display = '';
  document.getElementById('filteredExamsBody').innerHTML = '';
  buttons.forEach((btn) => {
    btn.classList.remove('active');
  })
  const examsButton = buttons[0];
  examsButton.classList.toggle('active');
  const token = document.getElementById('filterByToken').value;
  if (token !== '') {
    testsUrl = `http://localhost:3000/tests/${token}` + environment();
  } else {
    location.reload();
  }

  fetch(testsUrl)
    .then((response) => response.json())
    .then((data) => {
      if (data === null) {
        emptyMessage.textContent = `Nenhum exame com código ${token} encontrado`
        document.body.appendChild(emptyMessage);
      } else {
        emptyMessage.textContent = ''
      }
      data.tests.forEach(function(testItem) {
        const tr = document.createElement('tr');
        const name = document.createElement('td');
        const registrationNumber = document.createElement('td');
        const patientEmail = document.createElement('td');
        const birthDate = document.createElement('td');
        const doctorName = document.createElement('td');
        const crm = document.createElement('td');
        const crmState = document.createElement('td');
        const token = document.createElement('td');
        const date = document.createElement('td');
        const type = document.createElement('td');
        const typeLimits = document.createElement('td');
        const typeResult = document.createElement('td');

        name.textContent = `${data.name}`;
        registrationNumber.textContent = `${data.registration_number}`;
        patientEmail.textContent = `${data.email}`;
        birthDate.textContent = `${data.birth_date}`;
        doctorName.textContent = `${data.doctor.name}`;
        crm.textContent = `${data.doctor.crm}`;
        crmState.textContent = `${data.doctor.crm_state}`;
        token.textContent = `${data.token}`;
        date.textContent = `${data.date}`;
        type.textContent = `${testItem.type}`;
        typeLimits.textContent = `${testItem.type_limits}`;
        typeResult.textContent = `${testItem.type_result}`;

        tr.appendChild(name);
        tr.appendChild(registrationNumber);
        tr.appendChild(patientEmail);
        tr.appendChild(birthDate);
        tr.appendChild(doctorName);
        tr.appendChild(crm);
        tr.appendChild(crmState);
        tr.appendChild(token);
        tr.appendChild(date);
        tr.appendChild(type);
        tr.appendChild(typeLimits);
        tr.appendChild(typeResult);

        document.getElementById('filteredExamsBody').appendChild(tr);
      });
    })
    .catch(function(error) {
      console.log(error);
  });
}


function getJobStatus(tokenUrl){
  fetch(tokenUrl)
    .then((response) => response.json())
    .then((data) => {
      return JSON.parse(data)
    })
    .catch(function(error) {
      console.log(error);
  });
}

async function sendFile(event) {
  event.preventDefault();
  const formData = new FormData();
  const fileInput = document.getElementById('file'); 
  const file = fileInput.files[0];
  const token = Math.random().toString(36).slice(6).toUpperCase();
  const tokenUrl = `?token=${token}`;
  const jobStatusUrl = `http://localhost:3000/job_status/${token}`;
  
  formData.append('file', file);

  try {
    const importResponse = await fetch(importUrl + tokenUrl, {
      method: 'POST',
      body: formData
    });

    if (!importResponse.ok) {
      throw new Error('Network response was not ok');
    }

    const importData = await importResponse.text();
    const parsedData = JSON.parse(importData);
    const conversionStatus = parsedData.conversion_status;
    uploadStatus.textContent = conversionStatus;

    await new Promise(r => setTimeout(r, 1000));

    await waitForJobCompletion(jobStatusUrl);
    
    getTests();
    uploadStatus.textContent = 'Conversão concluída'
  } catch (error) {
    console.error('Error during file upload:', error);
  }
}

async function waitForJobCompletion(jobStatusUrl) {
  while (true) {
    const jobStatus = getJobStatus(jobStatusUrl);
    if (jobStatus !== 'pending') {
      break;
    }

    await new Promise(resolve => setTimeout(resolve, 1000));
  }
}

async function getJobStatus(jobStatusUrl) {
  try {
    const response = await fetch(jobStatusUrl);
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    return data.job_status;
  } catch (error) {
    console.error('Error getting job status:', error);
    throw error;
  }
}

function filterTable() {
  const input = document.getElementById('filterInput').value.toUpperCase();
  const rows = document.getElementsByTagName('tr');
  
  for (let i = 0; i < rows.length; i++) {
    const name = rows[i].getElementsByTagName('td')[0];
    let doctorName = ''
    if (document.getElementsByClassName('navLink')[0].classList.contains('active')) {
      doctorName = rows[i].getElementsByTagName('td')[4];
    }

    if (name && doctorName !== '') {
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