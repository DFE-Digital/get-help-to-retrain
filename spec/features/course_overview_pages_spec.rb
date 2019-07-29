require 'rails_helper'

RSpec.feature 'Course overview page', type: :feature do
  background do
    enable_feature! :course_directory
  end

  scenario 'User navigates to maths overview page' do
    visit(maths_course_overview_path)

    expect(page).to have_text('Benefits of doing a maths course')
  end

  scenario 'User continues journey to explore maths courses' do
    create(:course, :maths)

    visit(maths_course_overview_path)

    click_on('Find a maths course')

    expect(page).to have_text('Maths courses near me')
  end

  scenario 'User navigates to english overview page' do
    visit(english_course_overview_path)

    expect(page).to have_text('Benefits of doing an English course')
  end

  scenario 'User continues journey to explore English courses' do
    create(:course, :english)

    visit(english_course_overview_path)

    click_on('Find an English course')

    expect(page).to have_text('English courses near me')
  end
end
