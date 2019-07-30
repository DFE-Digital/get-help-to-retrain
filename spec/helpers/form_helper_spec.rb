require 'rails_helper'

RSpec.describe FormHelper do
  let(:search) { CourseGeospatialSearch.new(postcode: 'NW9 8ET') }

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
