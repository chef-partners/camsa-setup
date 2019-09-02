
# Iterate around the packages that need to be installed
node['camsa']['packages'].each do |pkg|
  package pkg['name'] do
    action :install
  end
end