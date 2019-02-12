
# Ensure that the necessary directories exist
node['common']['dirs'].each do |name, path|
  log format('Creating %s directory: %s', name, path)
  directory path
end
