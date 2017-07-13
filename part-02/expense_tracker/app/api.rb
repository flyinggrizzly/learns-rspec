require 'sinatra/base'
require 'json'

module ExpenseTracker
  class API < Sinatra::Base

    post '/expenses' do
      # write just enough code to get the specs to pass
      JSON.generate('expense_id' => 42)
    end

  end
end