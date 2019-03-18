/* These are the locations in X memory space that are available for
 * application code to communicate with the PCI card in the Leach CCD
 * electronics.
 */


// The low and hi order (lo 16 bits only on each!) parts of the
// PCI circular buffer size set by the application for continuous mode.
#define PCI_DSP_PCI_BUFSIZE_0 0x000036
#define PCI_MEM_PCI_BUFSIZE_0 'X'
#define PCI_DSP_PCI_BUFSIZE_1 0x000037
#define PCI_MEM_PCI_BUFSIZE_1 'X'
 
 
// Count of pci retries and errors for the entire image.
#define PCI_DSP_PCI_ERRS 0x000027
#define PCI_MEM_PCI_ERRS 'X'
// The count of pci retries and errors for the "last little bit" image 
// processing.
#define PCI_DSP_PCI_LSTERRS 0x000038
#define PCI_MEM_PCI_LSTERRS 'X'
// Variable application must SET non-zero to enable pci detail error log.
#define PCI_DSP_PCI_ERRLOG 0x000029
#define PCI_MEM_PCI_ERRLOG 'X'
// 24 bit DSP code version number.
#define PCI_DSP_DSP_VERS 0x000011
#define PCI_MEM_DSP_VERS 'X'


// DSP independent INF parameters

// Standard INFO version word
#define PCI_DSP_GET_VERSION 0x000000
#define PCI_MEM_GET_VERSION 'N'
// Standard INFO flavor word
#define PCI_DSP_GET_FLAVOR 0x000001
#define PCI_MEM_GET_FLAVOR 'N'
// Standard INFO make time (lo) word
#define PCI_DSP_GET_TIME0 0x000002
#define PCI_MEM_GET_TIME0 'N'
// Standard INFO make time (hi) word
#define PCI_DSP_GET_TIME1 0x000003
#define PCI_MEM_GET_TIME1 'N'
// Standard INFO svn rev word
#define PCI_DSP_GET_SVNREV 0x000004
#define PCI_MEM_GET_SVNREV 'N'

// pci DSP dependent INF parameters

// Standard INFO capabilities word
#define PCI_DSP_GET_CAPABLE 0x000100
#define PCI_MEM_GET_CAPABLE 'N'

// Values for the TIM capabilities word

// RDA Workaround  capable
#define PCI_DSP_RDACAPABLE 0x000001
#define PCI_MEM_RDACAPABLE 'N'
// History log capable
#define PCI_DSP_HISTCAPABLE 0x000002
#define PCI_MEM_HISTCAPABLE 'N'
// Timer capable
#define PCI_DSP_TIMCAPABLE 0x000004
#define PCI_MEM_TIMCAPABLE 'N'
