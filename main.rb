#!/usr/local/bin/ruby
require 'rubygems'
require "/home/kilari/work/ruby/vpswork/ping1"

loop do
Ping.httpcheck
sleep 15
end
