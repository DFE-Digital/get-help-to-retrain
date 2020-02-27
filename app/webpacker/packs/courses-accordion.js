function CoursesAccordion () {
  this.start = function () {
    var largerThanTablet = window.matchMedia('(min-width: 700px)');
    if(largerThanTablet.matches === true) {
      window.sessionStorage.setItem('accordion-default-content-1', true);
    }
  }
}

export default new CoursesAccordion();
