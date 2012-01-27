module TicketEvolution
  class Model < Builder
    def plural_class_name
      "TicketEvolution::#{self.class.name.demodulize.pluralize.camelize}"
    end
  end
end
