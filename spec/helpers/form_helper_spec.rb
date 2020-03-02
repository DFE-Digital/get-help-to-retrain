require 'rails_helper'

RSpec.describe FormHelper do
  let(:search) { CourseGeospatialSearch.new(postcode: 'NW9 8ET') }

  describe '#error_summary' do
    it 'returns nothing if object supplied has no errors' do
      expect(helper.error_summary(search)).to be_nil
    end

    it 'returns the error summary title' do
      search.errors.add(:postcode, 'Test error')

      expect(helper.error_summary(search)).to include(
        '<h2 id="error-summary-title" class="govuk-error-summary__title">There is a problem</h2>'
      )
    end

    it 'returns a link for each object error with the correct error id' do
      search.errors.add(:postcode, 'Test error')
      search.errors.add(:postcode_in_uk, 'Postcode not in uk')

      expect(helper.error_summary(search)).to include(
        '<a href="#course_geospatial_search_postcode-error">Test error</a>',
        '<a href="#course_geospatial_search_postcode_in_uk-error">Postcode not in uk</a>'
      )
    end
  end

  describe '#form_group_tag' do
    it 'wraps the supplied block in a form group <div> tag' do
      expect(helper.form_group_tag(search, :postcode) { content_tag(:div) }).to eq('<div class="govuk-form-group"><div></div></div>')
    end

    context 'when supplied with an object that has errors' do
      it 'adds the error class' do
        search.errors.add(:postcode, 'Test error')
        expect(helper.form_group_tag(search, :postcode) {}).to have_css('.govuk-form-group--error')
      end

      it 'does not add error class when there are no errors on the attribute' do
        search.errors.add(:topic, 'Test error')
        expect(helper.form_group_tag(search, :postcode) {}).not_to have_css('.govuk-form-group--error')
      end

      it 'add extra classes if passed in to group tag' do
        expect(helper.form_group_tag(search, :postcode, tag_class: ['some-class']) { content_tag(:div) }).to eq(
          '<div class="govuk-form-group some-class"><div></div></div>'
        )
      end
    end
  end

  describe '#errors_tag' do
    it 'adds error classs' do
      search.errors.add(:attribute, 'Test error one')

      error_message = helper.errors_tag(search, :attribute)

      expect(error_message).to have_css('.govuk-error-message')
    end

    it 'returns correctly formatted error messages' do
      search.errors.add(:attribute, 'Test error one')
      search.errors.add(:attribute, 'Test error two')

      error_message = helper.errors_tag(search, :attribute)
      expect(error_message).to include(
        '<span class="govuk-visually-hidden">Error:</span> Test error one<br>',
        '<span class="govuk-visually-hidden">Error:</span> Test error two'
      )
    end

    it 'only returns if there is a error for the attribute' do
      search.errors.add(:attribute, 'Test error')

      expect(helper.errors_tag(search, :a_different_attribute)).to be_nil
    end
  end

  describe '#errors_tag_minimal' do
    it 'adds error classs' do
      search.errors.add(:attribute, 'Test error one')

      error_message = helper.errors_tag_minimal(search, :attribute)

      expect(error_message).to have_css('.govuk-error-message-placeholder')
    end

    it 'returns correctly formatted error span' do
      search.errors.add(:attribute, 'Test error one')

      error_message = helper.errors_tag_minimal(search, :attribute)
      expect(error_message).to eq('<span class="govuk-error-message-placeholder"></span>')
    end

    it 'only returns if there is a error for the attribute' do
      search.errors.add(:attribute, 'Test error')

      expect(helper.errors_tag_minimal(search, :a_different_attribute)).to be_nil
    end
  end

  describe '#css_classes_for_input' do
    it 'adds the correct css class' do
      expect(helper.css_classes_for_input(search, :attribute) {}).to eq('govuk-input')
    end

    it 'adds the error class when there are errors' do
      search.errors.add(:attribute, 'Test error')

      expect(helper.css_classes_for_input(search, :attribute) {}).to eq('govuk-input govuk-input--error')
    end

    it 'keeps any existing css classes' do
      expect(helper.css_classes_for_input(search, :attribute, 'class-one class-two') {}).to eq('class-one class-two govuk-input')
    end
  end
end
