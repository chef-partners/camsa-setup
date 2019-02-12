
describe file('/usr/local/camsa') do
  it { should exist }
  it { should be_directory }
end
