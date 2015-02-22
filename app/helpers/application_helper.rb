module ApplicationHelper
  def string_to_symbol string
    string.parameterize.underscore.to_sym 
  end
end
