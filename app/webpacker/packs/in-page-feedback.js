
function InPageFeedback () {
  this.start = function () {
    document.querySelector('.answer-no').onclick = function(e) {
      e.preventDefault();
      document.querySelector('.gem-c-feedback__js-prompt-questions').classList.remove('js-hidden')
      document.querySelector('.gem-c-feedback__prompt').remove();
    }
  }
}

export default new InPageFeedback();