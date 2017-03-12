require 'rubygems'
require 'oauth'
require 'json'
require 'cleverbot'
require 'twitter'

bot = Cleverbot.new('RtW9RmyVVExzC3xi','jpaekuzPDA5HRUNuAqtkOztlErHgsWSN')

$client = Twitter::REST::Client.new do |config|
  config.consumer_key        = '1uRJLIi5lyOufWTVjje5XHKG6'
  config.consumer_secret     = "deuZGezqTkP6KIGt5nxQ6n0XEZECST1LvlKw0JgCZ909XClKPk"
  config.access_token        = "377135231-JLlSJoXq1gCr655ccLidWMQRuIgMobFEVaOnEymP"
  config.access_token_secret = "g8FvyFgsJqGQIYokixrOFbtzEsOixqZ5Ul3bm2wC1a5Fx"
end

consumer_key = OAuth::Consumer.new(
    "1uRJLIi5lyOufWTVjje5XHKG6",
    "deuZGezqTkP6KIGt5nxQ6n0XEZECST1LvlKw0JgCZ909XClKPk")
access_token = OAuth::Token.new(
    "377135231-JLlSJoXq1gCr655ccLidWMQRuIgMobFEVaOnEymP",
    "g8FvyFgsJqGQIYokixrOFbtzEsOixqZ5Ul3bm2wC1a5Fx")

baseurl = "https://api.twitter.com"
path = '/1.1/direct_messages.json'
query   = URI.encode_www_form("count" => "5")
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

request.oauth! http, consumer_key, access_token
http.start
response = http.request request

def print_messages (lists)
  puts lists['sender']['id']
end

messages = nil
if response.code == '200'
  puts response.body
  puts ''
  puts ''
  messages = JSON.parse(response.body)
  puts ''
  puts JSON.pretty_generate(messages)
  puts ''
  puts messages
  puts ''
  puts messages[0]['sender']['id']
end

if messages[0]['sender']['id'] != 377135231
  puts ''
  puts ''
  puts comment = bot.say(messages[0]['sender']['text'])
  puts ''
  puts comment

  $client.create_direct_message(messages[0]['sender']['screen_name'], comment)
end
