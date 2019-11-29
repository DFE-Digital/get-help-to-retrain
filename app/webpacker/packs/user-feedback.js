
function UserFeedback () {
  this.start = function () {
    // Show in page survey when JS enabled
    document.querySelector('#feedback-prompt-container').classList.remove('hidden')

    var noLink = document.querySelector('#answer-no');
    var closeSurveyButton = document.querySelector('.close-feedback-survey');

    if (typeof(noLink) !== 'undefined' && noLink != null) {
      handleRejectionAnswer(noLink);
    }

    if (typeof(closeSurveyButton) !== 'undefined' && closeSurveyButton != null) {
      collapseSurvey(closeSurveyButton);
    }
  }

  function handleRejectionAnswer(element) {
    element.onclick = function(e) {
      e.preventDefault();
      document.querySelector('#feedback-not-useful-container').classList.remove('hidden');
      document.querySelector('#feedback-prompt-container').classList.add('hidden');

      element.setAttribute('aria-expanded', true);
      document.querySelector('#page-is-useful-form').setAttribute('aria-hidden', true);
      document.querySelector('#page-is-not-useful-form').setAttribute('aria-hidden', false);
    }
  }

  function collapseSurvey(element) {
    element.onclick = function(e) {
      e.preventDefault();
      document.querySelector('#feedback-prompt-container').classList.remove('hidden');
      document.querySelector('#feedback-not-useful-container').classList.add('hidden');

      document.querySelector('#answer-no').setAttribute('aria-expanded', false);
      document.querySelector('#page-is-useful-form').setAttribute('aria-hidden', false);
      document.querySelector('#page-is-not-useful-form').setAttribute('aria-hidden', true);
    }
  }
}

export default new UserFeedback();
