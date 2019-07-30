function SearchForm () {
  this.start = function () {
    const $searchField = document.querySelector('#search, #postcode');
    const $searchForm = document.querySelector('#job-profile-search, #courses-search, #location-eligibility');

    disableEmptyForm($searchForm, $searchField);
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
