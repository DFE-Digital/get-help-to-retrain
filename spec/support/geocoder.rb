Geocoder.configure(lookup: :test, ip_lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates' => [40.7143528, -74.0059731],
      'address' => 'sw1p3bt',
      'country' => 'United Kingdom',
      'country_code' => 'UK'
    }
  ]
)
