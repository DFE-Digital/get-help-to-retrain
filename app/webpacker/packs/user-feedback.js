
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
    }
  }

  function collapseSurvey(element) {
    element.onclick = function(e) {
      e.preventDefault();
      document.querySelector('#feedback-prompt-container').classList.remove('hidden');
      document.querySelector('#feedback-not-useful-container').classList.add('hidden');
    }
  }
}

export default new UserFeedback();
