module SimpleForm
  module Components
    module InputGroupText
      def input_group_text(wrapper_options)
        @input_group_text ||= begin
          "<span class='input-group-addon'>#{options[:input_group_text]}</span>".html_safe if options[:input_group_text].present?
        end
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::InputGroupText)
