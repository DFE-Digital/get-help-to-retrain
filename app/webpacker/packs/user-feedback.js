
function UserFeedback () {
  this.start = function () {
    var yesLink = document.querySelector('#answer-yes');
    var noLink = document.querySelector('#answer-no');

    if (typeof(yesLink) !== 'undefined' && yesLink != null) {
      handleSuccessAnswer(yesLink);
    }

    if (typeof(noLink) !== 'undefined' && noLink != null) {
      handleRejectionAnswer(noLink);
    }
  }

  function handleSuccessAnswer(element) {
    element.onclick = function(e) {
      e.preventDefault();
      document.querySelector('#feedback-prompt-question').classList.add('hidden');
      document.querySelector('#feedback-prompt-success').classList.remove('hidden');
    }
  }

  function handleRejectionAnswer(element) {
    element.onclick = function(e) {
      e.preventDefault();
      document.querySelector('#feedback-survey-container').classList.remove('hidden');
      document.querySelector('#feedback-prompt-container').remove();
    }
  }
}

export default new UserFeedback();
