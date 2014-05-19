module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      bootstrap_class_for(flash_type.to_s)
    end
  end

  def as_currency(number)
    number_to_currency(number)
  end

  def format_date(date, format)
    unformatted = date || Date.today
    unformatted.to_date.to_s(format)
  end
end
