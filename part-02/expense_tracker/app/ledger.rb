module ExpenseTracker
  # Redefine the RecordResult struct in its permanent home
  RecordResult = Struct.new(:success?,
                            :expense_id,
                            :error_message)

  class Ledger
    def record(expense)
      unless expense.key?('payee')
        message = 'Invalid expense: `payee` is required'
        return RecordResult.new(false, nil, message)
      end
      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date);
      # returns a hash: { date: 'date', count: Int, expenses: Array }
    end
  end
end