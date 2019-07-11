base_dir = input('base_dir', value: '/usr/local/camsa', description: 'Base directory fo all CAMSA related files')

# Ensure all the necessry directories have been created

# Create array of the directories to test the existence of
dirs = [
  base_dir,
  ::File.join(base_dir, 'bin'),
  ::File.join(base_dir, 'etc'),
  ::File.join(base_dir, 'archive'),
  ::File.join(base_dir, 'flags'),
  ::File.join(base_dir, 'data'),
]

# Iterate around the dirs array and check eash one exists
dirs.each do |dir|
  describe file(dir) do
    it { should exist }
  end
end