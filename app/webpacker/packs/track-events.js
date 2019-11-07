function TrackEvents () {
  this.start = function () {
    if (typeof(appInsights) !== 'undefined') {
      var elements = document.querySelectorAll('[data-tracked-event]');

      for (let i = 0; i < elements.length; ++i) {
        trackComponentOnClick(elements[i]);
      }
    }
  };

  function sendEvent() {
    var eventLabel = this.dataset.trackedEvent;
    var eventProps = this.dataset.trackedEventProps;
    
    if (typeof(eventProps) !== 'undefined') {
      eventProps = JSON.parse(eventProps);
    } else {
      eventProps = {};
    }
      
    setTimeout(function () {
      appInsights.trackEvent(eventLabel, eventProps);
    }, 0);
  };

  function trackComponentOnClick(element) {
    if (element.dataset.trackedEvent) {
      element.addEventListener('click', sendEvent, false);
    }
  }
}

export default new TrackEvents();
