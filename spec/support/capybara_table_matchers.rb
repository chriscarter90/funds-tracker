module CapybaraTableMatchers
  def has_table_columns?(*rows)
    has_exact_table?('thead', rows)
  end

  def has_table_rows_in_order?(*rows)
    has_exact_table?('tbody', rows)
  end

  def has_exact_table?(selector, arr)
    match = true
    within selector do
      arr.each_with_index do |row, row_idx|
        row.each_with_index do |expected_text, cell_idx|
          xpath = "tr[#{row_idx + 1}]/*[not (contains(@class, 'hidden'))][#{cell_idx + 1}]"
          elem = find(:xpath, xpath)

          # need to use xpath if we're in a js test in order to have waiting applied
          if driver.class == Capybara::Poltergeist::Driver
            if expected_text == '*'
              # ignore
            elsif expected_text.blank?
              match &&= has_xpath?(xpath, text: expected_text)
            elsif expected_text.start_with?('input: ')
              input_field_value = expected_text.sub('input: ', '')
              match &&= has_xpath?(xpath + "/input[@value='#{input_field_value}']")
            elsif expected_text.start_with?('select2: ')
              select_value = expected_text.sub('select2: ', '')
              match &&= has_xpath?(xpath + "//*[@class='select2-chosen' and text()='#{select_value}']")
            else
              match &&= has_xpath?(xpath + "[.='#{expected_text}']") # this prevents a partial match returning true
            end
          else
            if expected_text == '*'
              # ignore
            elsif expected_text.start_with?('input: ')
              expected_input_field_value = expected_text.sub('input: ', '')
              input_field = find(:xpath, xpath + '/input')
              match &&= input_field.value == expected_input_field_value
            elsif elem.text.strip.gsub(/(\n*\s{2,})/, " ") != expected_text.to_s.strip
              message = "Expected '#{expected_text.to_s.strip}' but got  #{elem.text.strip}' for element '#{xpath}'"
              raise RSpec::Expectations::ExpectationNotMetError.new(message)
            end
          end
        end
      end

      # check number of rows are as expected
      if arr.size == 0
        match &&= has_no_xpath?('tr')
      else
        match &&= has_xpath?('tr', count: arr.size)
      end
    end
    match
  end

  def has_table_rows?(rows)
    match = true
    rows.each do |index, values|
      # xpath index starts from 1
      index = index.to_i
      values.each_with_index do |cell_value, cell_index|
        if cell_value == '*'
          # ignore
        elsif cell_value.start_with?('input: ')
          input_field_value = cell_value.sub('input: ', '')
          selector = ".//tbody/tr[#{index}]/td[#{cell_index + 1}]/input"
          input_field = find(:xpath, selector)
          match &&= input_field.value == input_field_value
        else
          selector = ".//tbody/tr[#{index}]/td[#{cell_index + 1}]"
          td = find(:xpath, selector)
          match &&= td.has_content?(cell_value)
        end
      end
    end
    match
  end

  def has_empty_table?
    has_no_xpath?('//tbody/tr')
  end
end

Capybara::Session.send(:include, CapybaraTableMatchers)
