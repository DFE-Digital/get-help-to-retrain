/*!
  Pa11y-ci Configuration.
  USAGE:
    export TEST_SRV=http://localhost:3000
    pa11y-ci -c .pa11yci.conf.js
*/

var config = {
    defaults: {
      screenCapture: './_pa11y-screen-capture.png',
      standard: 'WCAG2AA',
      ignore: [ 'notice' ],
      timeout: 5000,
      wait: 1500
    },
    urls: [
        '${TEST_SRV}',
        '${TEST_SRV}/job-categories/government-services',
        '${TEST_SRV}/explore_occupations',
        '${TEST_SRV}/explore_occupations/results?utf8=✓&name=test',
        '${TEST_SRV}/check_your_skills',
        '${TEST_SRV}/check_your_skills/results?utf8=✓&name=manager',
        '${TEST_SRV}/find_training_courses',
        '${TEST_SRV}/next_steps',
        '${TEST_SRV}/explore_occupations/results?utf8=✓&name=construction',
        '${TEST_SRV}/find_training_courses'
    ]
  };

  function myPa11yCiConfiguration (urls, defaults) {

    console.error('Env:', process.env.TEST_SRV);

    for (var idx = 0; idx < urls.length; idx++) {
      urls[ idx ] = urls[ idx ].replace('${TEST_SRV}', process.env.TEST_SRV);
    }

    return {
      defaults: defaults,
      urls: urls
    }
  };

  // Important ~ call the function, don't just return a reference to it!
  module.exports = myPa11yCiConfiguration (config.urls, config.defaults);

  // End config.
