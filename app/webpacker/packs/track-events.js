function TrackEvents () {
  this.start = function () {
    if (typeof(appInsights) === 'object') {
      document.querySelectorAll('[data-tracked-event]').forEach(function (element) {
        $this = element;

        if ($this.dataset.type === 'link') {
          $this.onclick = function sendEvent(e) {
            if ($this.dataset.trackedEvent) {
              appInsights.trackEvent($this.dataset.trackedEvent)
            }
          }
        }
      });
    }
  }
}

module.exports = new TrackEvents();
