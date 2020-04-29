function JobsNearMeAccordion () {
  this.start = function () {
    var largerThanTablet = window.matchMedia('(min-width: 700px)');
    var postcodeError = document.querySelector('#job_vacancy_search_postcode-error');
    if ((largerThanTablet.matches === true) || (typeof(postcodeError) !== 'undefined' && postcodeError != null)) {
      window.sessionStorage.setItem('accordion-jobs-near-me-content-1', true);
    }
  }
}

export default new JobsNearMeAccordion();
