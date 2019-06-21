# Use this rather than `puts` or `p` in rake tasks to keep spec output clean
def print(text)
  puts text unless Rails.env.test?
end
