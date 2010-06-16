class String
  def dot_camelize
    self.gsub(/(?:^|\.|_)(.)/) { $1.upcase }
  end
end