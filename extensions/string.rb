class String
  
  def pull_response_code
    self.split("\n").detect {|d| d.match(/Status/) }
  end
  
end