class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:type]  ||= "text"

    @builder.text_field(attribute_name, input_html_options)
  end
end
