require 'sinatra'
require 'parse-ruby-client'
require_relative 'models/user'
require_relative 'models/swipe'

CLIENT = Parse.init :application_id => 'O7Y3S39SAHWoEpvXcsOL0PkVhboHm9mrAS53Y7Ux',
                    :api_key        => 'kJxlgwIxmcNO0KcxlhkdyI3aJbhzkHtK78vSFX7z'

user_query = Parse::Query.new('_User')

def user_query
	Parse::Query.new('_User')
end

get '/' do
	erb :index
end

get '/leaderboard' do
		user_query.tap do |q| 
			q.order_by = 'amountGiven' 
			q.order = :descending
		end
		
	@users = user_query.get
	erb :leaderboard
end

get '/usertotaldata' do
	@users = user_query.get
	@total = 0
	@users.each do |user|
		@total += user['amountGiven']
	end
	@total

	erb :usertotaldata
end

get '/usernotossdata' do
	@users = user_query.get
	@notoss = 0
	@users.each do |user|
		@notoss += 1 if user['amountGiven'].zero?
	end
	@notoss

	erb :usernotossdata
end

get '/numberofusers' do
	@user_count = user_query.get.length
	erb :numberofusers
end

get '/totalswipes' do 
	@swipes = Swipe.total_number_of_swipes
	erb :totalswipes
end

# get '/averageswipes' do 
# 	@average = Swipe.total_value_of_swipes
# 	erb :averageswipes
# end

get '/swipetime' do 
	@last_hour_swipes = Swipe.swipes_in_last_hour
	erb :swipetime
end


