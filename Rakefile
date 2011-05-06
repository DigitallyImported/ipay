require 'rake/testtask'

task :default => [:test]

task :console do
  sh 'irb --simple-prompt -rubygems -I lib -r console.rb'
end

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end