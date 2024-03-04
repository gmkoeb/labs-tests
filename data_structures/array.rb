class Array
  def as_json
    map(&:as_json).to_json
  end
end
