import '../styles/application.scss';
import CookiesBanner from './cookies-banner';
import TrackEvents from './track-events';
import UserFeedback from './user-feedback';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';

CookiesBanner.start();
TrackEvents.start();
UserFeedback.start();
Rails.start();
initAll();
