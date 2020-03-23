function CoursesAccordion () {
  this.start = function () {
    var largerThanTablet = window.matchMedia('(min-width: 700px)');
    var postcodeError = document.querySelector('#course_search_postcode-error');
    if (((largerThanTablet.matches === true) || (typeof(postcodeError) !== 'undefined' && postcodeError != null)) && (window.location.href.indexOf('/courses/') > -1)) {
      window.sessionStorage.setItem('accordion-default-content-1', true);
    }
  }
}

export default new CoursesAccordion();
