/*!
  Pa11y-ci Configuration.
  USAGE:
    export HOST=http://localhost:3000
    pa11y-ci -c .pa11yci.conf.js
*/

var config = {
    defaults: {
      screenCapture: './_pa11y-screen-capture.png',
      standard: 'WCAG2AAA',
      level: 'error',
      timeout: 5000,
      wait: 1500
    },
    urls: [
        '${HOST}',
        '${HOST}/job-categories/government-services',
        '${HOST}/explore-occupations',
        '${HOST}/explore-occupations/results?utf8=✓&search=test',
        '${HOST}/check-your-skills',
        '${HOST}/check-your_skills/results?utf8=✓&search=manager',
        '${HOST}/find-training-courses',
        '${HOST}/next-steps',
        '${HOST}/explore-occupations/results?utf8=✓&search=construction',
        '${HOST}/find-training-courses'
    ]
  };

  function myPa11yCiConfiguration (urls, defaults) {

    console.error('Env:', process.env.HOST);

    for (var idx = 0; idx < urls.length; idx++) {
      urls[ idx ] = urls[ idx ].replace('${HOST}', process.env.HOST);
    }

    return {
      defaults: defaults,
      urls: urls
    }
  };

  // Important ~ call the function, don't just return a reference to it!
  module.exports = myPa11yCiConfiguration (config.urls, config.defaults);

  // End config.
