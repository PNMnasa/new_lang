where LLVM # checks if LLVM is installed and available in the system PATH
if %errorlevel% neq 0 (
    echo LLVM is not installed or not found in the system PATH.
    echo Please install LLVM and ensure it is added to your PATH environment variable.
    exit /b 1
) else (
    echo LLVM is installed and available in the system PATH.
)

# install lib
zig std
