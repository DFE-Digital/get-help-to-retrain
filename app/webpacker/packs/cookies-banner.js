function CookiesBanner () {
  this.start = function () {
    var cookiesModal = document.querySelector('#cookies-banner');

    if (typeof(cookiesModal) !== 'undefined' && cookiesModal != null) {
      if (getCookie('seen_cookie_message') !== 'true') {
        displayCookiesModal(cookiesModal);
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
    modalElement.style.display = 'block';

    var cookiesAccept = document.querySelector('#accept-cookies');

    if (typeof(cookiesAccept) !== 'undefined' && cookiesAccept != null) {
      handleAcceptCookies(modalElement, cookiesAccept);
    }
  }

  function handleAcceptCookies(modalElement, acceptElement) {
    acceptElement.onclick = function(e) {
      e.preventDefault();

      modalElement.style.display = 'none';
      setCookie('seen_cookie_message', 'true', 30);
    }
  }
}

export default new CookiesBanner();
