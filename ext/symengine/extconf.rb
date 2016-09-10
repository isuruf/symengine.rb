require 'rbconfig'

ruby_executable = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['RUBY_INSTALL_NAME'] + RbConfig::CONFIG['EXEEXT'])

generator = ""

if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)
    generator = '-G "MSYS Makefiles"'
end

is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/)

# Check if cmake is installed
cmake_found = system("cmake --version")
cmake = "cmake"
if not cmake_found
    # Install cmake using conda
    require 'conda'
    Conda.add_channel("conda-forge")
    Conda.add("cmake")
    cmake = File.join(Conda.SCRIPTDIR, "cmake")
end

args = ARGV.join(" ")

cmd = "#{cmake} #{generator} -DCMAKE_INSTALL_PREFIX=../../ -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=yes -DRUBY_EXECUTABLE=#{ruby_executable} #{args} ../../ "
symengine_found = system(cmd)

if not symengine_found
    # Install symengine using conda and rerun
    require 'conda'
    Conda.add_channel("conda-forge")
    Conda.add_channel("symengine")
    Conda.add("symengine")
    if is_windows
        libdir = File.join(Conda::PREFIX, "Library", "CMake")
    else
        libdir = File.join(Conda::PREFIX, "lib", "cmake")
    end
    cmd = cmd + "-DSymEngine_DIR=#{libdir}"
    if not system(cmd)
        raise "Something went wrong with configuring symengine gem"
    end
end
