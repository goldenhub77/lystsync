module ApplicationHelper
  def link_active?(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def format_date_to_ISO(date_obj)
    begin
      date_obj.strftime("%Y-%m-%dT%H:%M%:z")
    rescue DateTime::ArgumentError, DateTime::NoMethodError, DateTime::TypeError => message
      nil
    end
  end

  def form_error_messages!(resource)
    return nil unless form_error_messages?(resource)
    resource.errors.full_messages
  end

  def form_error_messages?(resource)
    !resource.errors.empty?
  end
end
