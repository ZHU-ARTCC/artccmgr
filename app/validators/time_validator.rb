class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Time.parse(value.to_s)
  rescue ArgumentError
    record.errors[attribute] << (options[:message] || 'must be a valid time')
  end
end
