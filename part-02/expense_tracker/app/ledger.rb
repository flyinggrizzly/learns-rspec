module ExpenseTracker
  # Redefine the RecordResult struct in its permanent home
  RecordResult = Struct.new(:success?,
                            :expense_id,
                            :error_message)

  class Ledger
    def record(expense); end
    def expenses_on(date);
      # returns a hash: { date: 'date', count: Int, expenses: Array }
    end
  end
end