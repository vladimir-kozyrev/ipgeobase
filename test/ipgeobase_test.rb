# frozen_string_literal: true

require "test_helper"

class IpgeobaseTest < Minitest::Test
  # rubocop:disable Metrics/MethodLength
  def setup
    test_ip_address = "8.8.8.8"
    test_endpoint = "http://ip-api.com/xml/#{test_ip_address}"
    test_response_body = <<-XML
      <?xml version="1.0" encoding="UTF-8"?>
      <query>
        <status>success</status>
        <country>United States</country>
        <countryCode>US</countryCode>
        <region>VA</region>
        <regionName>Virginia</regionName>
        <city>Ashburn</city>
        <zip>20149</zip>
        <lat>39.03</lat>
        <lon>-77.5</lon>
        <timezone>America/New_York</timezone>
        <isp>Google LLC</isp>
        <org>Google Public DNS</org>
        <as>AS15169 Google LLC</as>
        <query>#{test_ip_address}</query>
      </query>
    XML
    stub_request(:any, test_endpoint)
      .to_return(body: test_response_body, status: 200)
    @ip_meta = Ipgeobase.lookup(test_ip_address)
  end
  # rubocop:enable Metrics/MethodLength

  def test_that_it_has_a_version_number
    refute_nil ::Ipgeobase::VERSION
  end

  def test_city
    assert "Ashburn", @ip_meta.city
  end

  def test_country
    assert "United States", @ip_meta.country
  end

  def test_country_code
    assert "US", @ip_meta.country_code
  end

  def test_latitude
    assert "39.03", @ip_meta.lat
  end

  def test_longitude
    assert "-77.5", @ip_meta.lon
  end
end
