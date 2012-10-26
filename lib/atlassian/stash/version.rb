
module Atlassian
  module Stash
    module Version
      STRING = IO.readlines(File.dirname(__FILE__) + "/../../../VERSION").first.strip
    end
  end
end

