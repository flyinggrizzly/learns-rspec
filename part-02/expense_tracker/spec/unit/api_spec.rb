require_relative '../../app/api'
require 'rack/test'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods

    # Create a double/mock of the Ledger class (yet to be written)
    # for testing with the instance_double method
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    # Define a dummy return object for the get requests
    Expenses = Struct.new(:success?, 
                          :count,
                          :expenses,
                          :error_message)
    # Define a dummy expense object to include in the Expenses objects
    Expense  = Struct.new(:date,
                          :id)

    def app
      API.new(ledger: ledger)
    end

    # Extract repeated shared code to helper
    def response_body
      JSON.parse(last_response.body)
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-10')
            .and_return({ date:     '2017-06-10',
                          count:    2,
                          expenses: ['expense_1',
                                     'expense_2'] })
        end
        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-10'
          expect(response_body).to eq({ 'date'     => '2017-06-10',
                                        'count'    => 2,
                                        'expenses' => ['expense_1',
                                                       'expense_2'] })
        end

        it 'responds with a 200 OK' do
          get '/expenses/2017-06-10'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-11')
            .and_return({ date:    '2017-06-11',
                          count:    0,
                          expenses: [] })
        end
        it 'returns an empty array as JSON' do
          get '/expenses/2017-06-11'
          expect(response_body).to eq({ 'date'     => '2017-06-11',
                                        'count'    => 0,
                                        'expenses' => [] })
        end
        it 'responds with a 200 OK' do
          get '/expenses/2017-06-11'
          expect(last_response.status).to eq(200)
        end
      end
    end

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do

        # Extract shared code to reduce repetition
        expense = { 'gcu' => 'liveware-problem' }
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect(response_body).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        # We can probably anticipate needing a before block and some prep bits here
        let(:expense) { { 'gsv' => 'honest-mistake' } }
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(response_body).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end
  end
end