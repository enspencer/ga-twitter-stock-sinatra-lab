require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'twitter'
require 'dotenv'
require 'stock_quote'
set :server, 'webrick'

Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

get '/stocks/:symbol' do
	@symbol = params[:symbol].to_s
	# binding.pry

	stock = StockQuote::Stock.quote(@symbol)
	@company = stock.company
	@stock_last = stock.last
	@daily_open = stock.open
	@daily_close = stock.y_close
	@high = stock.high

	@tweets = client.search("$#{@symbol}", :count => 10, :result_type => "recent", :lang => "en")

	return erb :stocks
end