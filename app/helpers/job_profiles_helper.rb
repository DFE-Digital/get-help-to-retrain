module JobProfilesHelper
  def job_profile_breadcrumbs_for(url)
    URI(url).path =~ /categories/ ? t('breadcrumb.job_category') : t('breadcrumb.search_results')
  end
end
