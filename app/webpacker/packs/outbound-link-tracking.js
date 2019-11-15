function OutboundLinkTracking () {
  this.start = function () {
    if (typeof(gtag) !== 'undefined') {
      trackOutboundLinks();
    }
  }


  function trackOutboundLinks () {
    if (document.getElementsByTagName) {
      var el = document.getElementsByTagName('a');
      var getDomain = document.domain.split('.').reverse()[1] + '.' + document.domain.split('.').reverse()[0];

      // Look through each a element
      for (var i = 0; i < el.length; i++) {
        // Extract its href attribute
        var href = (typeof(el[i].getAttribute('href')) == 'string' ) ? el[i].getAttribute('href') : '';

        // Query the href for the top level domain (xxxxx.com)
        var myDomain = href.match(getDomain);

        // If link is outbound and is not to this domain
        if ((href.match(/^(https?:|\/\/)/i)  && !myDomain) || href.match(/^mailto\:/i)) {

          // Add an event to click
          addEvent(el[i], 'click', function(e) {
            var url = this.getAttribute('href');
            var win = (typeof(this.getAttribute('target')) == 'string') ? this.getAttribute('target') : '';

            // Log event to Analytics, once done, go to the link
            gtag('event', 'click', {
              'event_category': 'outbound',
              'event_label': url,
              'transport_type': 'beacon',
              'event_callback': hitCallbackHandler(url, win)
            });

            e.preventDefault();
          });
        }
      }
    }
  }

  function hitCallbackHandler (url, win) {
    if (win) {
      window.open(url, win);
    } else {
      window.location.href = url;
    }
  }

  function addEvent (el, eventName, handler) {
    if (el.addEventListener) {
      el.addEventListener(eventName, handler);
    } else {
      el.attachEvent('on' + eventName, function(){
        handler.call(el);
      });
    }
  }
}

export default new OutboundLinkTracking();
