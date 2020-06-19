module JobVacanciesHelper
  def titleize_without_downcasing(string)
    string.sub(/^./, &:upcase)
  end
end
