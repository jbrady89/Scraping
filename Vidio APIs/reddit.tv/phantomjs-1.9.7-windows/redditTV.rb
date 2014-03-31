require 'open-uri'
require 'nokogiri'

output = `phantomjs hello.js&`
p output