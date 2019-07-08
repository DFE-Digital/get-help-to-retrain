import '../styles/application.scss';
import SearchForm from './search-form';
import Rails from 'rails-ujs';
import { initAll } from 'govuk-frontend';


SearchForm.start();
Rails.start();
initAll();
