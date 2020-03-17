function CookiesBanner () {
  this.start = function () {
    var cookiesModal = document.querySelector('.js-enabledd');

    if (typeof(cookiesModal) !== 'undefined' && cookiesModal != null) {
        displayCookiesModal(cookiesModal);
        trapFocus(cookiesModal);
    }
  }

  function getCookie(name) {
    var v = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');

    return v ? v[2] : null;
  }

  function setCookie(name, value, days) {
    var date = new Date;

    date.setTime(date.getTime() + 24*60*60*1000*days);
    document.cookie = name + "=" + value + ";path=/;expires=" + date.toGMTString();
  }

  function displayCookiesModal(modalElement) {
    modalElement.style.display = 'block';
    var cookiesModalDisabled = document.querySelector('.js-disabled');
    cookiesModalDisabled.style.display = 'none';
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
