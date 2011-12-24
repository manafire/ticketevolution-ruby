module Kernel
  
  # This adds in an attr_accessor type ability without needing all of activesupport which to heavy.
  def mattr(*attributes)
    attributes.each do | attribute |
      define_method(attribute)       { return @attribute }
      define_method("#{attribute}=") { |other| @attribute = other  } 
    end
  end
  
end