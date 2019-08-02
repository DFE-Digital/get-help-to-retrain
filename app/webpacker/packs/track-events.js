function TrackEvents () {
  this.start = function () {
    if (typeof(appInsights) !== 'undefined') {
      document.querySelectorAll('[data-tracked-event]').forEach(function (element) {
        trackComponentOnClick(element);
      });
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
