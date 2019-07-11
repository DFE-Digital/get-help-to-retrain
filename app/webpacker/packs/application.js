import '../styles/application.scss';
import SearchForm from './search-form';
import TrackEvents from './track-events';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';


SearchForm.start();
TrackEvents.start();
Rails.start();
initAll();
