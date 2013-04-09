# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "atlassian-stash"
  gem.homepage = "https://bitbucket.org/atlassian/stash-command-line-tools"
  gem.license = "MIT"
  gem.summary = "Command line tools for Atlassian Stash"
  gem.description = "Provides convenient functions for interacting with Atlassian Stash through the command line" 
  gem.email = "sruiz@atlassian.com"
  gem.authors = ["Seb Ruiz"]
  # dependencies defined in Gemfile
  gem.executables = ["stash"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError => e
end

begin
  require "simplecov"

  desc "Execute tests with coverage report"
  task :simplecov do
    ENV["COVERAGE"]="true"
    Rake::Task["test"].execute
  end
rescue LoadError
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "atlassian-stash #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
