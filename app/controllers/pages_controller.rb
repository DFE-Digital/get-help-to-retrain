class PagesController < ApplicationController
  GRAPH_HOST = 'https://graph.microsoft.com'.freeze

  def action_plan
    redirect_to task_list_path unless target_job.present?
  end

  def task_list
    dd = make_api_call('/v1.0/me/memberOf', session['graph_token_hash']['token'])
    @roles = dd['value'].map{ |e| e['displayName'] }

    if user_session.job_profile_skills?
      current_job = JobProfile.find(user_session.job_profile_ids.first)

      @skills_summary_path = skills_path(job_profile_id: current_job.slug)
    else
      @skills_summary_path = check_your_skills_path
    end
  end

  private

  def make_api_call(endpoint, token, params = nil)
    headers = {
      Authorization: "Bearer #{token}"
    }

    query = params || {}

    HTTParty.get "#{GRAPH_HOST}#{endpoint}",
                 headers: headers,
                 query: query
  end
end
