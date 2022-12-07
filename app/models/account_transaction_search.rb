class AccountTransactionSearch
  attr_reader :date_from, :date_to

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], 7.days.ago.to_s(:db).split(' ')[0])
    @date_to = parsed_date(params[:date_to], Date.today.to_s(:db).split(' ')[0])
  end

  def scope
    AccountTransaction.where('created_at BETWEEN ? AND ?', @date_from, @date_to)
  end

  private

  def parsed_date(date_string, default)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    default
  end
end
