# MSP 430 Template Project for CMake on Linux - Visual Studio Code optional

This is a simple guide for setting up cmake/vscode (or just cmake) for programming the msp430. Why?
Code Composer Studio is fine. TI offers another free IDE to use also - fine. If you're just doing MSP stuff for school, or only do MSP stuff (not other coding), then not a strong reason to not use TIs editors. But I'm not a fan.

I used to be an emacs fan, now I use vscode - basically a programmable text editor. I prefer this editor because it doesn't rely on magic behaviour yet still allows things to be automated to keyboard shortcuts. I can use it for web coding, editing notes, writing markdown for readme files, or cross compiling for anything I can setup via command line tools. With vscode you can download extensions for what you need, or if there are none, you can code extensions yourself. Most stuff is customizable via text editable json files instead of GUI menus and text boxes. In any case, it also encourages really understanding your build process which helps immensly when problems occur - much easier to troubleshoot and deal with when you understand what is happening.

## Steps

If using vscode, this assumes you have the official c++ extension installed for VSCode. This is also assuming you have CMake installed, along with vscode cmake and cmake tools extensions.

If your not using vscode and are just trying to use msp430 with cmake, you can disregard anything referring to stuff in the .vscode directory (steps 7 and 8).

1) Download [msp430 compiler installer from TI](https://www.ti.com/tool/MSP430-GCC-OPENSOURCE) and install it somewhere (doesn't matter). I installed to $HOME/ti which created a folder $HOME/ti/msp430-gcc. Note that you have to run the installer with sudo. If you choose the same path as I did, steps 5 through 8 shouldn't be necessary.

2) Download and build [mspdebug from git](https://github.com/dlbeer/mspdebug). Just download, cd to downloaded folder and run **make -j** followed by **sudo make install**.

3) Download and install [Code Composer Studio](https://www.ti.com/tool/CCSTUDIO-MSP). Create an example project for your board (such as blink), compile and upload it to the board. This will install any needed drivers and firmware updates for the MSP debugger interface.

4) Edit CMakeLists.txt so that MSP430_DEVICE_NAME is set to the specific MSP device your using. You can also change EXEC_NAME and VERSION to whatever you want - these are just used to generate the exe name. By default its gonna just search the src dir for cpp and c files - change this to whatever is needed.

5) Edit the MSP430.cmake toolchain file so that the TOOLS_ROOT variable is set to wherever you installed the msp430 compiler package. You can also edit/add any compiler/linker flags to match your specific MSP by editing MSP430_COMPILER_FLAGS and MSP430_LINKER_FLAGS.

6) Edit the mspdebug.sh script so the path after LD_LIBRARY_PATH points to your installation directory.

7) Edit the .vscode/c_cpp_properties compiler path and include path to point to your compiler installation dirs. Also update the defines with your specific MSP430 device type. This is purely for vscode intellisense.

8) Edit the .vscode/launch.json so that the miDebuggerPath points to the debugger file in your installation path (from step 1), and edit additionalSOLibSearchPath so it points to the bin folder in your installation path.

If your using VSCODE with cmake/cmake tools extensions, you can now run the command "CMake: Select Variant" to pick debug or release build, and run "CMake: Configure" to run cmake, and run "CMake: Build" to compile.

For intellisense to work correctly, you also need to set cmake tools within vscode settings to generate compile commands, and refer to that in the c_cpp_properties.json file. Here is my setup:
```json
{
    // A Bunch of other settings
    // ....
    // CMAKE TOOLS
    "cmake.buildDirectory": "${workspaceFolder}/build/${buildType}",
    "cmake.configureSettings": {
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
    },
    "cmake.configureOnOpen": false,
    "cmake.parallelJobs": 12,
    "cmake.copyCompileCommands": "${workspaceFolder}/build/compile_commands.json"
}
```

In vscode you will also be able to debug the msp using the debug pane. The configuration for that is given by .vscode/launch.json. You will also have a task available "Upload Target to MSP", which is defined in .vscode/tasks.json.

This template also allows command line use (no vscode required) - you can easily use the command line to build your project. Assuming you edited the MSP430.cmake and CMakeLists.txt as given in 5 and 6 (if needed), just cd to the top level project directory:

To build:
```bash
mkdir build
cd build
cmake ..
make -j
cd ..
```

To upload (as shown earlier):
```bash
./mspdebug.sh debug_type "prog PATH_TO_EXEC"
```
replacing the debug_type with whatever debug device your using (see mspdebug documentation or run ./mspdebug --help to see options) and PATH_TO_EXEC to your built elf exec file. All arguments are passed directly to mspdebug - the script is just to setup LD_LIBRARY_PATH so that mspdebug can correctly find libmsp430.so, which is included in the compiler package downloaded in step 1 above.

To start the debug server on the msp:
```bash
./mspdebug.sh debug_type "gdb"
```

Again replacing debug_type as needed.

And to start debugging (connecting to the debug server just created), open another terminal:
```bash
INSTALL_PATH/bin/msp430-elf-gdb PATH_TO_EXEC -ex "target remote :2000"
```

replacing INSTALL_PATH to your msp compiler install path, and replace PATH_TO_EXEC to your built elf exec file to be debugged on msp.

The following pages were used to help make this:
[MSP430 debugging with VSCode](https://minkbot.blogspot.com/2019/03/vscode-and-msp430-debugging.html)
[CMake with msp430 setup](https://github.com/descampsa/msp430-cmake)
[Another CMake with msp430 setup](https://github.com/AlexanderSidorenko/msp-cmake)