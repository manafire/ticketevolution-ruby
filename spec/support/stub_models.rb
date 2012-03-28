module TicketEvolution
  class Samples < Base
    def initialize(*attrs); end
  end

  class Models < Endpoint; end

  self.constants.each do |const|
    konstant = self.const_get(const)
    if const == :Model or (konstant.class == Class and konstant.ancestors.include?(TicketEvolution::Model::ParentalBehavior))
      klass = Class.new(TicketEvolution::Base) do
        def initialize(*args); end
        def testing
          "testing"
        end
      end
      eval "TicketEvolution::#{konstant.name.demodulize.pluralize.camelize}::Samples = klass"
    end
  end
end
