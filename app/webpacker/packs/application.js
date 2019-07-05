import '../styles/application.scss';
import SearchForm from './search-form';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { initAll } from 'govuk-frontend';


SearchForm.start();
Rails.start();
Turbolinks.start();
initAll();
