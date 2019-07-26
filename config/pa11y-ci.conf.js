/*!
  Pa11y-ci Configuration.
  USAGE:
    export HOST=http://localhost:3000
    pa11y-ci -c .pa11yci.conf.js
*/

function myPa11yCiConfiguration (host) {
  return {
    defaults: {
      screenCapture: './_pa11y-screen-capture.png',
      standard: 'WCAG2AA',
      level: 'error',
      timeout: 5000,
      wait: 1500
    },
    urls: [
      `${host}`,
      `${host}/task-list`,
      `${host}/check-your-skills`,
      `${host}/check-your-skills/results?search=manager`,
      `${host}/job-profiles/yoga-therapist/skills?search=manager`,
      `${host}/check-your-skills/results?search=nonexisting`,
      `${host}/explore-occupations`,
      `${host}/explore-occupations/results?search=construction`,
      `${host}/job-profiles/construction-site-supervisor`,
      `${host}/explore-occupations/results?search=nonexisting`,
      `${host}/categories/administration`,
      `${host}/find-training-courses`,
      `${host}/courses/maths`,
      `${host}/courses/maths?postcode=NW11+7HB`,
      `${host}/courses/maths?postcode=invalid`,
      `${host}/next-steps`
    ]
  };
};

module.exports = myPa11yCiConfiguration(process.env.HOST);
