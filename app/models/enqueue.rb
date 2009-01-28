class Enqueue < Struct.new(:newzbin_id)
  def initialize(options = {})
    update_attributes(options)
  end
  
  def update_attributes(keys_and_values)
    keys_and_values.each do |key, value|
      self.send("#{key}=", value)
    end
  end
  
  def id
    nil
  end
end