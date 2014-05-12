class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:class] << "form-control"
    html = <<-HTML
      <div class="input-group">
        <span class="input-group-addon">#{t 'number.currency.format.unit' }</span>#{@builder.text_field(attribute_name, input_html_options)}
      </div>
    HTML
    html.html_safe
  end
end
