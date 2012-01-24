module TicketEvolution
  class Time < ::Time
    def self.parse(str)
      if str =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/
        parts = str.split(/[-T:Z]/).collect(&:to_i)
        Time.gm(
          parts[0],
          parts[1],
          parts[2],
          parts[3],
          parts[4],
          parts[5]
        )
      else
        str
      end
    end
  end
end
