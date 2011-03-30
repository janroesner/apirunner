if defined?(Rails) and Rails.version.match(/^2.+$/)
  APIRUNNER_ROOT = File.dirname(__FILE__).to_s + "/../../"
  TEST_EXAMPLES_PATH = APIRUNNER_ROOT + "examples/test/api_runner"
  CONFIG_EXAMPLE_PATH = APIRUNNER_ROOT + "examples/config"
end

begin
  config = YAML.load_file("#{Rails.root}/config/api_runner.yml")
rescue
end

namespace :api do
  namespace :run do
    config.delete_if{ |key| key == "general" }.each_key do |env|
      desc "runs a series of nessecary api calls and parses their response in environment #{env}"
      task env.to_sym => :environment do
        puts "Running API tests in environment #{env}"
        api_runner = ApiRunner.new(env)
        api_runner.run
        puts "\nTestrun finished\n\n"
      end
    end unless config.nil?
  end
  namespace:performance do
    config.delete_if{ |key| key == "general" }.each_key do |env|
      desc "runs a series of nessecary api calls for performance measuring and parses their response in environment #{env}"
      task env.to_sym => :environment do
        puts "Running API performance tests in environment #{env}"
        api_runner = ApiRunner.new(env, performance=true)
        api_runner.run
        puts "\nPerformance testrun finished\n\n"
      end
    end unless config.nil?
  end
  desc "generates configuration and a skeleton for apirunner tests as well as excludes"
  task :scaffold do
    TEST_EXAMPLES_PATH="test/api_runner"
    CONFIG_EXAMPLE_PATH="config"

    FileUtils.mkdir_p( TEST_EXAMPLES_PATH )
    FileUtils.mkdir_p( CONFIG_EXAMPLE_PATH )
    Dir.glob("#{APIRUNNER_ROOT}/examples/#{TEST_EXAMPLES_PATH}/*.yml").each do |file|
      unless File.exists?("#{TEST_EXAMPLES_PATH}/#{File.basename(file)}")
        FileUtils.cp(file, "#{TEST_EXAMPLES_PATH}") 
        puts "%-50s .... created" % "#{TEST_EXAMPLES_PATH}/#{File.basename(file)}"
      else
        puts "%-50s .... already exists" % "#{TEST_EXAMPLES_PATH}/#{File.basename(file)}"
      end
    end
    Dir.glob("#{APIRUNNER_ROOT}/examples/#{CONFIG_EXAMPLE_PATH}/*.yml").each do |file|
      unless File.exists?("#{CONFIG_EXAMPLE_PATH}/#{File.basename(file)}")
        FileUtils.cp(file, "#{CONFIG_EXAMPLE_PATH}") unless File.exists?("#{CONFIG_EXAMPLE_PATH}/#{File.basename(file)}")
        puts "%-50s .... created" % "#{CONFIG_EXAMPLE_PATH}/#{File.basename(file)}"
      else
        puts "%-50s .... already exists" % "#{CONFIG_EXAMPLE_PATH}/#{File.basename(file)}"
      end
    end
  end
end
