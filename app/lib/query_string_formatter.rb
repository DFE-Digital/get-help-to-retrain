module QueryStringFormatter
  def format(string)
    normalize(string)
      .squish
      .split(/\s/)
      .map { |str| str.concat(':*') }
      .join(' | ')
  end

  def format_exact_match(string)
    normalize(string)
      .squish
      .gsub(/\s/, ' & ')
  end

  def normalize(string)
    string
      .unicode_normalize(:nfkc)
      .gsub(/[^[[:alnum:]]\s]/, '')
  end

  module_function :format, :normalize, :format_exact_match
end
