function CookiesBanner () {
  this.start = function () {
    var cookiesModal = document.querySelector('#cookies-banner');

    if (typeof(cookiesModal) !== 'undefined' && cookiesModal != null) {
      displayCookiesModalButton();
      trapFocus(cookiesModal);
    }
  }

  function displayCookiesModalButton(modalElement) {
    document.querySelector('#cookies-necessary-button').className = 'govuk-button govuk-button--secondary';
  }

  function trapFocus(element) {
    var focusableElements = element.querySelectorAll('a[href]:not([disabled])');
    var firstElement = focusableElements[0];
    var lastElement = focusableElements[focusableElements.length - 1];
    var KEYCODE_TAB = 9;

    element.addEventListener('keydown', function(e) {
      var isTabPressed = (e.keyCode === KEYCODE_TAB);

      if (!isTabPressed) {
        return;
      }

      if ( e.shiftKey ) /* shift + tab */ {
        if (document.activeElement === firstElement) {
          lastElement.focus();
          e.preventDefault();
        }
      } else /* tab */ {
        if (document.activeElement === lastElement) {
          firstElement.focus();
          e.preventDefault();
        }
      }
    });
  }
}

export default new CookiesBanner();
