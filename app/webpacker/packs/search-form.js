function SearchForm () {
  this.start = function () {
    document.addEventListener("turbolinks:load", function() {
      var $jobProfileName = document.querySelector('#name');
      var $jobProfileSearchForm = document.querySelector('#job-profile-search');

      disableEmptyForm($jobProfileSearchForm, $jobProfileName);
    });
  }

  function disableEmptyForm($form, $field) {

    if ($form) {
      $field.required = false;
      $form.addEventListener('submit', event => {
        if ($field.value.trim().length == 0) {
          event.preventDefault();
        }
      });
    }
  }
}

module.exports = new SearchForm();
