if [%PLATFORM%] == [x64] appveyor DownloadFile "https://raw.githubusercontent.com/symengine/dependencies/31ed6b09d7cf3b609da236f48243fd9a01fa365c/gmp-6.0.0-x86_64-w64-mingw32-2.7z" -FileName gmp.7z
if [%PLATFORM%] == [Win32] appveyor DownloadFile " https://raw.githubusercontent.com/symengine/dependencies/e1e9dc3e7288ba06c96b452fb556b11ef6d5299f/gmp-6.0.0-i686-w64-mingw32.7z" -FileName gmp.7z
7z x -oC:\gmp gmp.7z > NUL
set PATH=C:\gmp\bin\;%PATH%
set /p commit=<symengine_version.txt
git clone https://github.com/symengine/symengine symengine-cpp
cd symengine-cpp
git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
git fetch origin
git checkout %commit%
cmake -G "MSYS Makefiles" -DGMP_DIR=C:\gmp -DBUILD_TESTS=no -DBUILD_BENCHMARKS=no .
make
make install
cd ..

