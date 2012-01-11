module Kernel

  # This adds in an attr_accessor type ability without needing all of activesupport which to heavy.
  def mattr_accessor(*module_instance_vars)
    module_instance_vars.each do | module_instance_var |
      inst_variable_name = "@#{module_instance_var}".to_sym
      define_method module_instance_var do
        instance_variable_get inst_variable_name
      end
      define_method "#{module_instance_var}=" do |new_value|
        instance_variable_set inst_variable_name, new_value
      end
    end
  end

end
