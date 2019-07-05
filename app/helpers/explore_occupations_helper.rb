module ExploreOccupationsHelper
  def job_profile_category_list(job_profile)
    job_profile.categories.map { |category|
      link_to(category.name, category_path(category.slug), class: 'govuk-link')
    }.join(', ').html_safe
  end
end
