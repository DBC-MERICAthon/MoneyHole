require 'sinatra'
require 'parse-ruby-client'


CLIENT = Parse.init :application_id => 'O7Y3S39SAHWoEpvXcsOL0PkVhboHm9mrAS53Y7Ux',
                    :api_key        => 'kJxlgwIxmcNO0KcxlhkdyI3aJbhzkHtK78vSFX7z'
                       # :quiet          => false

get '/' do
	user_query = Parse::Query.new('_User')
	user_query.tap { |q| q.order_by = 'amountGiven'; q.order = :descending }
	@users = user_query.get
	erb :index
end