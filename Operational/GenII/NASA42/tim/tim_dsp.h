/* These are the locations in X and Y memory space that are available for
 * application code to communicate with the timing board in the Leach CCD
 * electronics.
 */


// Timing board status
#define TIM_DSP_STATUS 0x000000
#define TIM_MEM_STATUS 'X'
 
 
// Timing Board DSP code version
#define TIM_DSP_DSP_VERS 0x000032
#define TIM_MEM_DSP_VERS 'X'
// Timing Board DSP code flavor
#define TIM_DSP_DSP_FLAV 0x000033
#define TIM_MEM_DSP_FLAV 'X'
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
