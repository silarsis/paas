#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'open-uri'

uri = URI.parse('https://discovery.etcd.io/new')
params = { size: '3' }
uri.query = URI.encode_www_form(params)
discoveryid = uri.open.read
puts "New Discovery ID: #{discoveryid}"

params = [
  { 'ParameterKey'   => 'InstanceType', 'ParameterValue' => 'm3.large' },
  { 'ParameterKey'   => 'SpotPrice', 'ParameterValue' => '0.05' },
  { 'ParameterKey'   => 'ClusterSize', 'ParameterValue' => '3' },
  { 'ParameterKey'   => 'KeyPair', 'ParameterValue' => 'kevinl' },
  { 'ParameterKey'   => 'AdvertisedIPAddress', 'ParameterValue' => 'private' },
  { 'ParameterKey'   => 'DiscoveryURL', 'ParameterValue' => discoveryid }
]

open('params.json', 'w') { |f| f.write(params.to_json) }
