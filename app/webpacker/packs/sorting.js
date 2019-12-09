import Rails from 'rails-ujs';

function Sorting () {
  this.start = function () {
    var container = document.querySelector('#sort-container');

    if (typeof(container) !== 'undefined' && container != null) {
      // Show sort options when JS enabled
      container.classList.remove('hidden');

      var select = document.querySelector('#sort-select');

      if (typeof(select) !== 'undefined' && select != null) {
        handleSortOrder(select);
      }
    }
  }

  function handleSortOrder(element) {
    element.onchange = function(e) {
      Rails.fire(element.form, 'submit');
    }
  }
}

export default new Sorting();
