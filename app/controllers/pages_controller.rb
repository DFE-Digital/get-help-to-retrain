require 'uri'
require 'net/http'
require 'openssl'

class PagesController < ApplicationController
  include Secured

  def action_plan
    redirect_to task_list_path unless target_job.present?
  end

  def task_list
    @auth0_user_info = session[:userinfo]
    @roles = user_roles(session[:userinfo]['uid'], session[:userinfo]['credentials']['token'])

    if user_session.job_profile_skills?
      current_job = JobProfile.find(user_session.job_profile_ids.first)

      @skills_summary_path = skills_path(job_profile_id: current_job.slug)
    else
      @skills_summary_path = check_your_skills_path
    end
  end

  def user_roles(user_id, token)
    url = URI("https://hidden-hill-8351.eu.auth0.com/api/v2/users/#{URI.encode(user_id)}/roles")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    token = ENV['AUTH0_TEMP_TOKEN']
    request["authorization"] = "Bearer #{token}"
    response = http.request(request)
    response.read_body
  end
end
