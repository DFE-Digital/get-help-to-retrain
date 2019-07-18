import '../styles/application.scss';
import SearchForm from './search-form';
import TrackEvents from './track-events';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';

TrackEvents.start();
SearchForm.start();
Rails.start();
initAll();
