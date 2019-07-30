
function UserFeedback () {
  this.start = function () {
    document.querySelector('.answer-no').onclick = function(e) {
      e.preventDefault();
      document.querySelector('.feedback-prompt-questions').classList.remove('hidden');
      document.querySelector('.feedback-prompt').remove();
    }

    document.querySelector('.answer-yes').onclick = function(e) {
      e.preventDefault();
      document.querySelector('.feedback-prompt-full-question').classList.add('hidden');
      document.querySelector('.feedback-prompt-success').classList.remove('hidden');
    }
  }
}

export default new UserFeedback();