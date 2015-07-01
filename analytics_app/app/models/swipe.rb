# require 'sinatra'
require 'parse-ruby-client'

client = Parse.init :application_id => 'O7Y3S39SAHWoEpvXcsOL0PkVhboHm9mrAS53Y7Ux',
                    :api_key        => 'kJxlgwIxmcNO0KcxlhkdyI3aJbhzkHtK78vSFX7z'

class Swipe
  def initialize
  end

  def self.total_number_of_swipes(opts = {})
    @total_count = 0
    stop = false
    amount = opts.fetch(:amount, nil)
    while stop == false
      swipes = Parse::Query.new('Swipe')

      if amount != nil
        swipes.eq("amountInDollars", amount)
      end

      @total = swipes.tap do |q|
          q.limit = 1000
              if @total_count % 1000 == 0
                q.skip = @total_count
              end
      end.get

      @total_count += @total.count
      stop = true if @total_count % 1000 != 0

      end
    @total_count
  end

  def self.total_value_of_swipes
    @total_value_of_swipes = 0
    @total_value_of_swipes += Swipe.total_number_of_swipes(amount: 1) * 1
    @total_value_of_swipes += Swipe.total_number_of_swipes(amount: 5) * 5
    @total_value_of_swipes += Swipe.total_number_of_swipes(amount: 10) * 10
    @total_value_of_swipes += Swipe.total_number_of_swipes(amount: 20) * 20
    @total_value_of_swipes
  end

  def self.value_per_swipe
    @total_value_of_swipes / @total_count
  end

  def self.swipes_in_last_hour
    total_in_period = 0
    stop = false
    now = Parse::Date.new(DateTime.now)
    p "now"
    p now
    while stop == false
      swipes = Parse::Query.new('Swipe')
      individual_swipe = swipes.tap do |q|
        q.limit = 1000
        q.greater_than("createdAt", now - 0.0416667)
        if total_in_period % 1000 == 0
          q.skip = total_in_period
        end
      end.get
      total_in_period += individual_swipe.count
        stop = true if total_in_period % 1000 != 0
    end
    total_in_period
  end


end

# use amount: ? for amount query, if leaves blank gives you total
# puts Swipe.total_number_of_swipes()
# puts Swipe.total_value_of_swipes
# puts Swipe.value_per_swipe
# puts Swipe.swipes_in_last_hour







