module JobVacancyHelper
  def map_current_page_from(page)
    return '1' unless page.present?

    page_mapping = page.to_i % 5
    page_mapping == 0 ? '5' : page_mapping.to_s
  end
end
