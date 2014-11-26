#!/usr/bin/env ruby

require 'json'

stack = JSON.load(`cd ../base_stack && make -s info`)
outputs = Hash[
  stack['Stacks'][0]['Outputs'].map { |o| [o['OutputKey'], o['OutputValue']] }
]
params = [
  { 'ParameterKey'   => 'InstanceType', 'ParameterValue' => 'm3.medium' },
  { 'ParameterKey'   => 'SpotPrice', 'ParameterValue' => '0.02' },
  { 'ParameterKey'   => 'ClusterSize', 'ParameterValue' => '3' },
  { 'ParameterKey'   => 'KeyPair', 'ParameterValue' => 'kevinl' },
  { 'ParameterKey'   => 'AdvertisedIPAddress', 'ParameterValue' => 'private' },
  {
    'ParameterKey'   => 'DiscoveryURL',
    'ParameterValue' => 'https://discovery.etcd.io/512ba2e83a8d227672e8a20e69e70efb'
  },
  {
    'ParameterKey'   => 'Subnets',
    'ParameterValue' => "#{outputs['SubnetA']},#{outputs['SubnetB']}"
  },
  {
    'ParameterKey'   => 'CoreOSSecurityGroup',
    'ParameterValue' => outputs['CoreOSSecurityGroup']
  }
]

open('params.json', 'w') { |f| f.write(params.to_json) }
