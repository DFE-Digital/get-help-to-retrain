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

    setTimeout(function () {
      appInsights.trackEvent(eventLabel);
    }, 0);
  };

  function trackComponentOnClick(element) {
    if (element.dataset.trackedEvent) {
      element.addEventListener('click', sendEvent, false);
    }
  }
}

export default new TrackEvents();
