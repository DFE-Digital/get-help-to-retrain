function Sorting () {
  this.start = function () {
    // Show sort options when JS enabled
    document.querySelector('#sort-container').classList.remove('hidden')

    var select = document.querySelector('#sort-select');

    if (typeof(select) !== 'undefined' && select != null) {
      handleSortOrder(select);
    }
  }

  function handleSortOrder(element) {
    element.onchange = function(e) {
      element.form.submit();
    }
  }
}

export default new Sorting();
