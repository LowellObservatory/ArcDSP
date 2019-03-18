/* These are the locations in X and Y memory space that are available for
 * application code to communicate with the timing board in the Leach CCD
 * electronics.
 */


// Util board status
#define UTIL_DSP_STATUS 0x000000
#define UTIL_MEM_STATUS 'X'
 
 
// Util Board DSP code version
#define UTIL_DSP_DSP_VERS 0x000049
#define UTIL_MEM_DSP_VERS 'Y'
// Values for the UTIL capabilities word

// RDA Workaround  capable
#define UTIL_DSP_EXPOSECAPABLE 0x000000
#define UTIL_MEM_EXPOSECAPABLE 'N'
// History log capable
#define UTIL_DSP_PWRCAPABLE 0x000000
#define UTIL_MEM_PWRCAPABLE 'N'
// Temp Regulation capable
#define UTIL_DSP_TEMPREGCAPABLE 0x000004
#define UTIL_MEM_TEMPREGCAPABLE 'N'
// Write DAC capable
#define UTIL_DSP_WDACCAPABLE 0x000008
#define UTIL_MEM_WDACCAPABLE 'N'
// Write DAC All capable
#define UTIL_DSP_WDACALLCAPABLE 0x000000
#define UTIL_MEM_WDACALLCAPABLE 'N'


