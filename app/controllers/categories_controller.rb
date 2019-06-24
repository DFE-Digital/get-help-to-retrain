class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @other_categories = Category.with_job_profiles_without(@category)
  end
end
