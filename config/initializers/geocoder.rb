Geocoder.configure(
  timeout: 5,
  lookup: :postcodes_io,
  language: :en,
  use_https: true,
  units: :mi,
  distances: :spherical,
  always_raise: :all
)
