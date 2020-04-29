import '../styles/application.scss';
import CookiesBanner from './cookies-banner';
import OutboundLinkTracking from './outbound-link-tracking';
import UserFeedback from './user-feedback';
import Sorting from './sorting';
import CoursesAccordion from './courses-accordion';
import JobsNearMeAccordion from './jobs-near-me-accordion';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';

CoursesAccordion.start();
JobsNearMeAccordion.start();
CookiesBanner.start();
UserFeedback.start();
OutboundLinkTracking.start();
Sorting.start();
Rails.start();
initAll();
