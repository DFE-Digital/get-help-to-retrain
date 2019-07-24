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
      `${host}/categories/government-services`,
      `${host}/explore-occupations`,
      `${host}/explore-occupations/results?search=test`,
      `${host}/check-your-skills`,
      `${host}/check-your-skills/results?search=manager`,
      `${host}/find-training-courses`,
      `${host}/next-steps`,
      `${host}/explore-occupations/results?search=construction`,
      `${host}/find-training-courses`
    ]
  };
};

module.exports = myPa11yCiConfiguration(process.env.HOST);
