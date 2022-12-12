class AccountTransactionSearch
  attr_reader :date_from, :date_to

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], Date.today - 7.days)
    @date_to = parsed_date(params[:date_to], Date.today)
  end

  def scope
    AccountTransaction.where('created_at >= ? AND created_at < ?', @date_from, @date_to + 1.day)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end
end
