class Forgery::GemName < Forgery
  def self.name
    dictionaries[:gem_names].random
  end
end
