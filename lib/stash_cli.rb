
Dir[File.join(File.dirname(__FILE__), "atlassian", "stash", "*.rb")].sort.each {|f| require f}
