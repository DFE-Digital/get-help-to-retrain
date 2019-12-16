function OutboundLinkTracking () {
  this.start = function () {
    if (typeof(gtag) !== 'undefined') {
      trackOutboundLinks();
    }
  }

  function trackOutboundLinks () {
    if (document.getElementsByTagName) {
      var links = document.getElementsByTagName('a');
      var getDomain = document.domain;

      // Look through each a element
      for (var i = 0; i < links.length; i++) {
        // Extract its href attribute
        var href = (typeof(links[i].getAttribute('href')) == 'string' ) ? links[i].getAttribute('href') : '';

        // Query the href for the top level domain (xxxxx.com)
        var myDomain = href.match(getDomain);

        // If linking to another domain (except via email)
        if ((href.match(/^(https?:|\/\/)/i)  && !myDomain) || href.match(/^mailto\:/i)) {

          // Add an event to click
          addEvent(links[i], 'click', function(e) {
            var url = this.getAttribute('href');
            var win = this.getAttribute('target');
            var event_category = this.getAttribute('data-ga-event-category') || 'outbound';

            // Log event to Analytics, once done, go to the link
            gtag('event', 'click', {
              'event_category': event_category,
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
