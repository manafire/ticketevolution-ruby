module TicketEvolution
  module SingularClass
    def singular_class(klass = self.class)
      "TicketEvolution::#{(klass.is_a?(String) ? klass : klass.name).demodulize.singularize.camelize}".constantize
    end
  end
end
