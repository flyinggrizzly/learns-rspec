require_relative '../../app/api'
require 'rack/test'

module ExpenseTracker
  # Remove dummy definition of RecordResult and move it to the Ledger definition

  RSpec.describe API do
    include Rack::Test::Methods

    # Create a double/mock of the Ledger class (yet to be written)
    # for testing with the instance_double method
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    def app
      API.new(ledger: ledger)
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
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
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
          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end
  end
end