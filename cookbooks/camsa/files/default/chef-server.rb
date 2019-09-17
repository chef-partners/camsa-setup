# Determine the current directory
current_dir = File.expand_path(File.dirname(__FILE__))

# Read in any configuration files in the conf.d, if it exists
conf_d_dir = File.join(current_dir, 'conf.d')
if File.exist?(conf_d_dir)
  Dir.glob(File.join(conf_d_dir), "*.rb")).each do |conf|
    Chef::Config.from_file(conf)
  end
end