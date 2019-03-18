/* These are the locations in X and Y memory space that are available for
 * application code to communicate with the timing board in the Leach CCD
 * electronics.
 */


// Timing board status
#define TIM_DSP_STATUS 0x000000
#define TIM_MEM_STATUS 'X'
 
 
// Number of cols to read out (serial shifts)
#define TIM_DSP_NSR 0x000001
#define TIM_MEM_NSR 'Y'
// Number of rows to read out (parallel shifts)
#define TIM_DSP_NPR 0x000002
#define TIM_MEM_NPR 'Y'

// Binning parameters

// Column binning
#define TIM_DSP_NSBIN 0x000005
#define TIM_MEM_NSBIN 'Y'
// Row  binning
#define TIM_DSP_NPBIN 0x000006
#define TIM_MEM_NPBIN 'Y'


// DSP independent INF parameters

// Standard INFO version word
#define TIM_DSP_GET_VERSION 0x000000
#define TIM_MEM_GET_VERSION 'N'
// Standard INFO flavor word
#define TIM_DSP_GET_FLAVOR 0x000001
#define TIM_MEM_GET_FLAVOR 'N'
// Standard INFO make time (lo) word
#define TIM_DSP_GET_TIME0 0x000002
#define TIM_MEM_GET_TIME0 'N'
// Standard INFO make time (hi) word
#define TIM_DSP_GET_TIME1 0x000003
#define TIM_MEM_GET_TIME1 'N'
// Standard INFO svn rev word
#define TIM_DSP_GET_SVNREV 0x000004
#define TIM_MEM_GET_SVNREV 'N'

// tim DSP dependent INF parameters

// Standard INFO capabilities word
#define TIM_DSP_GET_CAPABLE 0x000100
#define TIM_MEM_GET_CAPABLE 'N'
//  integration time word
#define TIM_DSP_GET_INT_TIM 0x000101
#define TIM_MEM_GET_INT_TIM 'N'
//  serial delay word
#define TIM_DSP_GET_R_DELAY 0x000102
#define TIM_MEM_GET_R_DELAY 'N'
//  parallel delay word
#define TIM_DSP_GET_SI_DELAY 0x000103
#define TIM_MEM_GET_SI_DELAY 'N'

// Values for the TIM capabilities word

// Find exposure mode capable
#define TIM_DSP_FINDCAPABLE 0x000001
#define TIM_MEM_FINDCAPABLE 'N'
// Single exposure mode capable
#define TIM_DSP_SNGLCAPABLE 0x000002
#define TIM_MEM_SNGLCAPABLE 'N'
// Series exposure mode capable
#define TIM_DSP_SERICAPABLE 0x000004
#define TIM_MEM_SERICAPABLE 'N'
// Basic Occultation exposure mode capable
#define TIM_DSP_BASCCAPABLE 0x000008
#define TIM_MEM_BASCCAPABLE 'N'
// Fast Occultation exposure mode capable
#define TIM_DSP_FASTCAPABLE 0x000010
#define TIM_MEM_FASTCAPABLE 'N'
// Pipeline Occultation exposure mode capable
#define TIM_DSP_PIPECAPABLE 0x000020
#define TIM_MEM_PIPECAPABLE 'N'
// Fast Dots exposure mode capable
#define TIM_DSP_FDOTCAPABLE 0x000040
#define TIM_MEM_FDOTCAPABLE 'N'
// Slow Dots exposure mode capable
#define TIM_DSP_SDOTCAPABLE 0x000080
#define TIM_MEM_SDOTCAPABLE 'N'
// Strip exposure mode capable
#define TIM_DSP_STRPCAPABLE 0x000100
#define TIM_MEM_STRPCAPABLE 'N'
