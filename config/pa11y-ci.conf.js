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
      standard: 'WCAG2AAA',
      level: 'error',
      timeout: 5000,
      wait: 1500
    },
    urls: [
      `${host}`,
      `${host}/job-categories/government-services`,
      `${host}/explore-occupations`,
      `${host}/explore-occupations/results?utf8=✓&search=test`,
      `${host}/check-your-skills`,
      `${host}/check-your_skills/results?utf8=✓&search=manager`,
      `${host}/find-training-courses`,
      `${host}/next-steps`,
      `${host}/explore-occupations/results?utf8=✓&search=construction`,
      `${host}/find-training-course`
    ]
  };
};

module.exports = myPa11yCiConfiguration(process.env.HOST);
