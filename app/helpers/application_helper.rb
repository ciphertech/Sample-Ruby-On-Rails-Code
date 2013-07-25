module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def current_controller?(opts)
    hash = Rails.application.routes.recognize_path(url_for(opts))
    params[:controller] == hash[:controller]
  end

  def controller_name_with_module
    controller.class.name.sub(/Controller$/, '').underscore
  end

  def pp_action
    [controller_name_with_module, controller.action_name].join('/')
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, '#{association}', '#{simple_escape_javascript(raw(fields))}')"), :class => 'btn btn-info')
  end

  def link_to_remove_fields(name, f, *args)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", *args)
  end

  # Note: The built in rails escape_javascript method can hose a drop down list. This one simplifies it a little
  # to keep the elelements needed for a select list.
  JS_ESCAPE_MAP 	= 	{ '\\' => '\\\\', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

  def simple_escape_javascript(javascript)
    if javascript
      result = javascript.gsub(/(\\|\r\n|[\n\r"'])/) {|match| JS_ESCAPE_MAP[match] }
      javascript.html_safe? ? result.html_safe : result
    else
      ''
    end
  end

end
