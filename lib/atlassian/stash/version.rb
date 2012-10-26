
module Atlassian
  module Stash
    module Version
      STRING = IO.readlines("VERSION").first.strip
    end
  end
end

