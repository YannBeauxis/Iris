class Float
  def display
    if self>100 then
      self.round(0)
    elsif self>10 then
      self.round(1)
    else
      self.round(2)
    end
  end
end