# frozen_string_literal: true

require_relative "ipgeobase/version"
require "uri"
require "net/http"
require "nokogiri"

# Looks up IP metadata
module Ipgeobase
  def self.lookup(ip_address)
    uri = URI("http://ip-api.com/xml/#{ip_address}")
    response = Net::HTTP.get_response(uri)

    return IpMetadata.new(response.body) if response.is_a?(Net::HTTPSuccess)

    raise "The lookup of #{ip_address} IP address was not successful"
  end

  # Parses IP metadata
  class IpMetadata
    def initialize(metadata)
      @metadata = Nokogiri::XML(metadata)
    end

    def city
      @metadata.search("//city")
    end

    def country
      @metadata.search("//country")
    end

    def country_code
      @metadata.search("//countryCode")
    end

    def lat
      @metadata.search("//lat")
    end

    def lon
      @metadata.search("//lon")
    end
  end
end
