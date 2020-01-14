function CookiesBanner () {
  this.start = function () {
    var cookiesModal = document.querySelector('#cookies-banner');

    if (typeof(cookiesModal) !== 'undefined' && cookiesModal != null) {
      if (getCookie('seen_cookie_message') !== 'true') {
        displayCookiesModal(cookiesModal);
        trapFocus(cookiesModal)
      }
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
    modalElement.insertBefore(document.querySelector('#govuk-header'), document.querySelector('#cookies-modal'));
    document.querySelector('.govuk-header__container').classList.add('govuk-!-padding-bottom-2');

    modalElement.style.display = 'block';

    var cookiesAccept = document.querySelector('#accept-cookies');

    if (typeof(cookiesAccept) !== 'undefined' && cookiesAccept != null) {
      handleAcceptCookies(modalElement, cookiesAccept);
    }
  }

  function handleAcceptCookies(modalElement, acceptElement) {
    acceptElement.onclick = function(e) {
      e.preventDefault();

      document.querySelector('#govuk-header-container').appendChild(
        document.querySelector('#govuk-header')
      );
      document.querySelector('.govuk-header__container').classList.remove('govuk-!-padding-bottom-2');

      modalElement.style.display = 'none';
      setCookie('seen_cookie_message', 'true', 30);
    }
  }

  function trapFocus(element) {
    var focusableElements = element.querySelectorAll('a[href]:not([disabled])');
    var acceptCookies = focusableElements[2];  
    var cookieSettings = focusableElements[3];
    var KEYCODE_TAB = 9;

    element.addEventListener('keydown', function(e) {
      var isTabPressed = (e.keyCode === KEYCODE_TAB);

      if (!isTabPressed) { 
        return; 
      }

      if ( e.shiftKey ) /* shift + tab */ {
        if (document.activeElement === acceptCookies) {
          cookieSettings.focus();
          e.preventDefault();
        }
      } else /* tab */ {
        if (document.activeElement === cookieSettings) {
          acceptCookies.focus();
          e.preventDefault();
        }
      }
    });
  }
}

export default new CookiesBanner();
