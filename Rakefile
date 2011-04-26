task :default => [:test]

task :console do
  sh 'irb --simple-prompt -rubygems -I lib -r console.rb'
end

task :test do
  ruby 'test/test_api.rb'
end
