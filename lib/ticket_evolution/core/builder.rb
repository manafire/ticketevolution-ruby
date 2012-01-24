module TicketEvolution
  class Builder < OpenStruct
    def initialize(*stuff)
      super
      @table.each do |k, v|
        send("#{k}=", process_datum(v))
      end
    end

    private

    def process_datum(v)
      case v.class.to_s.to_sym
      when :Hash
        Datum.new(v)
      when :Array
        v.map{|x| process_datum(x)}
      when :String
        Time.parse(v)
      else
        v
      end
    end

    def method_missing(meth, *args, &block)
      args.size == 1 ? super(meth, process_datum(args.first), &block) : super(meth, process_datum(args), &block)
    end
  end
end
