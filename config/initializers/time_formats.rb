Date::DATE_FORMATS[:default] = "%d-%m-%Y"
Date::DATE_FORMATS.merge!(
  longer: lambda { |date| date.strftime("#{date.day.ordinalize} %B %Y") }
)
