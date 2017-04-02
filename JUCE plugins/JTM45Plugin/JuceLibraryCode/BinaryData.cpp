/* ==================================== JUCER_BINARY_RESOURCE ====================================

   This is an auto-generated file: Any edits you make may be overwritten!

*/

namespace BinaryData
{

//================== README.md ==================
static const unsigned char temp_binary_data_0[] =
"# r8brain-free-src #\r\n"
"## Introduction ##\r\n"
"Open source (under the MIT license) high-quality professional audio sample rate converter (SRC) (resampling) library.  Features routines for SRC, both up- and downsampling, to/from any sample rate, including non-integer sample rates: it can be also u"
"sed for conversion to/from SACD sample rate and even go beyond that.  SRC routines were implemented in multi-platform C++ code, and have a high level of optimality.\r\n"
"\r\n"
"The structure of this library's objects is such that they can be frequently created and destroyed in large applications with a minimal performance impact due to a high level of reusability of its most \"initialization-expensive\" objects: the fast Fo"
"urier transform and FIR filter objects.\r\n"
"\r\n"
"The SRC algorithm at first produces 2X oversampled (relative to the source sample rate, or the destination sample rate if the downsampling is performed) signal and then performs interpolation using a bank of short (14 to 28 taps, depending on the req"
"uired precision) polynomial-interpolated sinc function-based fractional delay filters.  This puts the algorithm into the league of the fastest among the most precise SRC algorithms. The more precise alternative being only the whole number-factored SR"
"C, which can be slower.\r\n"
"\r\n"
"## Requirements ##\r\n"
"C++ compiler and system with the \"double\" floating point type (53-bit mantissa) support.  No explicit code for the \"float\" type is present in this library, because as practice has shown the \"float\"-based code performs considerably slower on a m"
"odern processor, at least in this library.  However, if the \"double\" type really represents the \"float\" type (24-bit mantissa) in a given compiler, on a given system, the library won't become broken, only the conversion quality may become degrade"
"d.  This library always uses the \"sizeof( double )\" operator to obtain \"double\" floating point type's size in bytes.  This library does not have dependencies beside the standard C library, the \"windows.h\" on Windows and the \"pthread.h\" on Mac"
" OS X and Linux.\r\n"
"\r\n"
"## Links ##\r\n"
"* [Documentation](https://c16f948c1577658f1b05f6c1d146730273eb6285.googledrive.com/host/0BwakvlMNBQdwUXhLMDFJLWdBSlU/Documentation/)\r\n"
"* [Discussion](http://www.kvraudio.com/forum/viewtopic.php?t=389711)\r\n"
"* [r8brain-free-src-1.6-dll.zip](https://drive.google.com/open?id=0BwakvlMNBQdwR1JlZ3pKcVBpaWc&authuser=0)\r\n"
"\r\n"
"## Usage Information ##\r\n"
"The sample rate converter (resampler) is represented by the **r8b::CDSPResampler<>** class, which is a single front-end class for the whole library.  You do not basically need to use nor understand any other classes beside this class.  Several derive"
"d classes that have varying levels of precision are also available.\r\n"
"\r\n"
"The code of the library resides in the \"r8b\" C++ namespace, effectively isolating it from all other code.  The code is thread-safe.  A separate resampler object should be created for each audio channel or stream being processed.\r\n"
"\r\n"
"Note that you will need to compile the \"r8bbase.cpp\" source file and include the resulting object file into your application build.  This source file includes definitions of several global static objects used by the library.  You may also need to i"
"nclude to your project: the \"Kernel32\" library (on Windows) and the \"pthread\" library on Mac OS X and Linux.\r\n"
"\r\n"
"The library is able to process signal of any scale and loudness: it is not limited to just a \"usual\" -1.0 to 1.0 range.\r\n"
"\r\n"
"The code of this library was commented in the [Doxygen](http://www.doxygen.org/) style.  To generate the documentation locally you may run the \"doxygen ./other/r8bdoxy.txt\" command from the library's directory.\r\n"
"\r\n"
"Preliminary tests show that the r8b::CDSPResampler24 resampler class achieves 15.6\\*n\\_cores Mflops when converting 1 channel of audio from 44100 to 96000 sample rate, on a typical Intel Core i7-4770K processor-based system without overclocking.  T"
"his approximately translates to a real-time resampling of 160\\*n\\_cores audio streams, at 100% CPU load.  When comparing performance of this resampler library to another library make sure that the competing library is also tuned to produce a fully "
"linear-phase response.\r\n"
"\r\n"
"## Dynamic Link Library ##\r\n"
"The functions of this SRC library are also accessible in simplified form via the DLL file on Windows, requiring a processor with SSE2 support.  Delphi Pascal interface unit file for the DLL file is available.  DLL and C LIB files are distributed in a"
" separate ZIP file on the project's home page. On non-Windows systems it is preferrable to use the C++ library directly.\r\n"
"\r\n"
"## Real-time Applications ##\r\n"
"The resampler class of this library was designed as asynchronous processor: it may produce any number of output samples, depending on the input sample data length and the resampling parameters.  The resampler must be fed with the input sample data un"
"til enough output sample data was produced, with any excess output samples used before feeding the resampler with more input data.  A \"relief\" factor here is that the resampler removes the initial processing latency automatically, and that after in"
"itial moments of processing the output becomes steady, with only minor output sample data length fluctuations.\r\n"
"\r\n"
"Note that the r8b::CDSPResampler::getInLenBeforeOutStart() function can be used to estimate the number of input samples that should be provided to the resampler before the actual output starts.\r\n"
"\r\n"
"## Notes ##\r\n"
"When using the r8b::CDSPResampler<> class directly, you may select the transition band/steepness of the low-pass (reconstruction) filter, expressed as a percentage of the full spectral bandwidth of the input signal (or the output signal if the downsa"
"mpling is performed), and the desired stop-band attenuation in decibel.\r\n"
"\r\n"
"The transition band is specified as the normalized spectral space of the input signal (or the output signal if the downsampling is performed) between the low-pass filter's -3 dB point and the Nyquist frequency, and ranges from 0.5% to 45%.  Stop-band"
" attenuation can be specified in the range 49 to 218 decibel.\r\n"
"\r\n"
"This SRC library also implements a faster \"power of 2\" resampling (e.g. 2X, 4X, 8X, 16X, etc. upsampling and downsampling).\r\n"
"\r\n"
"This library was tested for compatibility with [GNU C++](http://gcc.gnu.org/), [Microsoft Visual C++](http://www.microsoft.com/visualstudio/eng/products/visual-studio-express-products) and [Intel C++](http://software.intel.com/en-us/c-compilers) comp"
"ilers, on 32- and 64-bit Windows, Mac OS X and CentOS Linux.\r\n"
"\r\n"
"All code is fully \"inline\", without the need to compile many source files.  The memory footprint is quite modest.\r\n"
"\r\n"
"## Users ##\r\n"
"This library is used by:\r\n"
"\r\n"
"  * [Combo Model V VSTi instrument](http://www.martinic.com/combov/)\r\n"
"  * [WDM Asio Link Driver](http://midithru.net/Home/AsioLink)\r\n"
"  * [Boogex Guitar Amp audio plugin](http://www.voxengo.com/product/boogex/)\r\n"
"  * [OpenMPT](http://openmpt.org/)";

const char* README_md = (const char*) temp_binary_data_0;


const char* getNamedResource (const char*, int&) throw();
const char* getNamedResource (const char* resourceNameUTF8, int& numBytes) throw()
{
    unsigned int hash = 0;
    if (resourceNameUTF8 != 0)
        while (*resourceNameUTF8 != 0)
            hash = 31 * hash + (unsigned int) *resourceNameUTF8++;

    switch (hash)
    {
        case 0x64791dc8:  numBytes = 6912; return README_md;
        default: break;
    }

    numBytes = 0;
    return 0;
}

const char* namedResourceList[] =
{
    "README_md"
};

}
