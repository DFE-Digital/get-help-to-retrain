import '../styles/application.scss';
import TrackEvents from './track-events';
import UserFeedback from './user-feedback';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';

TrackEvents.start();
UserFeedback.start();
Rails.start();
initAll();
