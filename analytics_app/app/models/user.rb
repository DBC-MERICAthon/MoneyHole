# require 'sinatra'
require 'parse-ruby-client'
require_relative 'swipe'

client = Parse.init :application_id => 'O7Y3S39SAHWoEpvXcsOL0PkVhboHm9mrAS53Y7Ux',
                    :api_key        => 'kJxlgwIxmcNO0KcxlhkdyI3aJbhzkHtK78vSFX7z'



class User
  def self.total_users
    @total_user_count = 0
    stop = false
    while stop == false
      users = Parse::Query.new('_User')
      total = users.tap do |q|
          q.limit = 1000
              if @total_user_count % 1000 == 0
                q.skip = @total_user_count
              end
      end.get
      @total_user_count += total.count
      stop = true if @total_user_count % 1000 != 0
    end
    @total_user_count
  end

  def self.total_users_spent
    Swipe.total_value_of_swipes
  end

  def self.average_user_toss
    User.total_users_spent / total_users
  end

end
