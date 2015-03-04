module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when Symbol
      bootstrap_class_for(flash_type.to_s)
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      ""
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
