function TrackEvents () {
  this.start = function () {
    if (typeof(appInsights) === 'object') {
      document.querySelectorAll('[data-tracked-event]').forEach(function (element) {
        if (element.dataset.type === 'link') {
          element.onclick = function sendEvent() {
            if (element.dataset.trackedEvent) {
              setTimeout(function () {
                appInsights.trackEvent(element.dataset.trackedEvent);
              }, 0);
            }
          };
        }
      });
    }
  };
}

export default new TrackEvents();
