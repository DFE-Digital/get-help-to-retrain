import '../styles/application.scss';
import SearchForm from './search-form';
import InPageFeedback from './in-page-feedback';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';

InPageFeedback.start();
SearchForm.start();
Rails.start();
initAll();
