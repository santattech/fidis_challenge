module ErrorSerializer
  def self.serialize(status, options = {})
    if options[:message]
      [
        {
          status: status,
          code: options[:code],
          detail: options[:message]
        }
      ]
    else
      options[:object].errors.messages.map do |field, errors|
        errors.map do |error_message|
          {
            status: status,
            source: { pointer: field.to_s.titleize },
            detail: error_message
          }
        end
      end.flatten
    end
  end
end
