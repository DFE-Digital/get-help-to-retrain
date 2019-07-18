function SearchForm () {
  this.start = function () {
    const $jobProfileName = document.querySelector('#search');
    const $jobProfileSearchForm = document.querySelector('#job-profile-search');

    disableEmptyForm($jobProfileSearchForm, $jobProfileName);
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

export default new SearchForm();
