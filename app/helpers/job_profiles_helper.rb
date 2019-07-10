module JobProfilesHelper
  def job_profile_breadcrumbs_for(params)
    if params[:category]
      [t('breadcrumb.job_category'), category_path(params[:category])]
    else
      [t('breadcrumb.search_results'), results_explore_occupations_path(
        name: params[:explore_occupations_result]
      )]
    end
  end
end
