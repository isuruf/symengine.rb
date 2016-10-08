require 'rbconfig'

ruby_executable = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['RUBY_INSTALL_NAME'] + RbConfig::CONFIG['EXEEXT'])

generator = ''

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
  generator = '-G "MSYS Makefiles"'
end

is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)

# Check if cmake is installed
cmake_found = system('cmake --version')
cmake = 'cmake'
unless cmake_found
  # Install cmake using conda
  require 'conda'
  Conda.add_channel('conda-forge')
  Conda.add('cmake')
  cmake = File.join(Conda.SCRIPTDIR, 'cmake')
end

args = ARGV.join(' ')
dir = File.dirname(File.dirname(__dir__))

cmd = "#{cmake} #{generator} "\
      "-DCMAKE_INSTALL_PREFIX=#{dir} "\
      '-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=yes '\
      "-DRUBY_EXECUTABLE=#{ruby_executable} "\
      "#{args} #{dir}"

symengine_found = system(cmd)

unless symengine_found
  # Install symengine using conda and rerun
  require 'conda'
  Conda.add_channel('conda-forge')
  Conda.add_channel('symengine')
  Conda.add('symengine')
  libdir = if is_windows
             File.join(Conda::PREFIX, 'Library', 'CMake')
           else
             File.join(Conda::PREFIX, 'lib', 'cmake')
           end
  cmd += "-DSymEngine_DIR=#{libdir}"
  raise 'Something went wrong with configuring symengine gem' unless system(cmd)
end
