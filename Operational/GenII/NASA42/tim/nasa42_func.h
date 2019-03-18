#ifndef __NASA42_FUNC_H__
#define __NASA42_FUNC_H__




#include <ccd_commands.h>

#include <arc-lib.h>

extern camera_struct	nasa42_ccd;
extern int		cam_fd, pscan_pix,oscan_pix;
extern char		dsppath[128], timdsp[40], utildsp[40], trighost[64];
extern info_struct	info;
extern struct sockaddr_in nasa42_server;
extern int		master, trigport, trig_socket,map_flag;
extern long		store_size;
extern cmd_struct	ccdcmd;
extern camera_header	cam_header;
extern char		*cammap_ptr;
extern time_struct	timesrv;
extern setgain_struct   nasa42gain;
extern  store_addimagedata lois_addimagedata;

int nasa42_getconf(ccd_info *ccdptr, cam_getconf_struct * getconf);

int nasa42_bit(camera_info *ccdptr);
int nasa42_close(camera_info *ccdptr);
int nasa42_init(camera_info *ccdptr);
int nasa42_open(camera_info *ccdptr);
int nasa42_shutter(int state);
int nasa42_setgain(camera_info *ccdptr, setgain_struct *gainptr);
int nasa42_setamp(camera_info *ccdptr);
int nasa42_standardamps( char *rawamps, char *stdamps, int *ampindx);
int nasa42_reset(camera_info *ccdptr);
int nasa42_idle(camera_info *ccdptr, int onoff);
int nasa42_purge(camera_info *iptr);
int nasa42_rdmdsp(char *board, char *type, char *address);
int nasa42_wrmdsp(char *board, char *type, char *address, char *data);
int nasa42_power(int state);


int nasa42_setdim(camera_info *ccdptr);
int nasa42_settrigger(camera_info *ccdptr);
int nasa42_setmux(int clock_id, int mux1, int mux2);
int nasa42_gettemp(double *temp1, double *temp2, double *heater1,
		  double *heater2, double *set1_val, double *set2_val);
int nasa42_settemp(camera_info *ccdptr);
int nasa42_abort(camera_info *ccdptr);
int nasa42_clear (void *status);
int nasa42_timcfg(void *filename);
int nasa42_utilcfg(void *filename);
int nasa42_setamplifier(camera_info *ccdptr, char * ampval);

int nasa42_subframe(camera_info *ccdptr, subframe_struct *subptr);
int nasa42_camaction(int action, camera_info *ccdptr);
int nasa42_socket();
int nasa42_connect(int sock_fd);
char *nasa42_qmmtimstr(struct timeval *syst, char *qmmstrbuf);
int nasa42_triglastime( void *r, void *nasa42_ptr);
int nasa42_trigfirstime( void *r, void *nasa42_ptr);
int trighostcmd(char *msg, char *trighostreply, int verbose);

time_t nasa42_synctrig( void * toffset);

/* Camera Mode Start Exposures */

int nasa42_startstrip(camera_info *ccdptr, long exptime);
int nasa42_startseries(camera_info *ccdptr, long exptime);
int nasa42_startoccul(camera_info *ccdptr, long exptime);
int nasa42_startsingle(camera_info *ccdptr, long exptime);
int nasa42_startfdots(camera_info *ccdptr, long exptime);
int nasa42_startfind(camera_info *ccdptr, long exptime);
int nasa42_startsdots(camera_info *ccdptr, long exptime);
/* Camera Mode Read Exposures */


int nasa42_stripread(char * buffer, camera_info *ccdptr);
int nasa42_seriesread(char * buffer, camera_info *ccdptr);
int nasa42_readimage(char * buffer, camera_info *ccdptr);
int nasa42_readimage_c(char * buffer, camera_info *ccdptr);
int nasa42_occulread(char *buffer, camera_info *ccdptr);
int nasa42_findread(char * buffer, camera_info *ccdptr);
int nasa42_fdotsread(char * buffer, camera_info *ccdptr);
int nasa42_sdotsread(char * buffer, camera_info *ccdptr);

int nasa42_expsetup( camera_info *ccdptr);
int nasa42_imsetup( camera_info *ccdptr, long etime, long itime, int sendimage,
                  int stripdot);
/*
*
* Loadable Module Init called from Tcl/Tk load
*
*/

int ccd_cfgtime(ClientData clientdata, Tcl_Interp *interp,
		   int objc, Tcl_Obj *CONST objv[]);
int ccd_cfgutil(ClientData clientdata, Tcl_Interp *interp,
		   int objc, Tcl_Obj *CONST objv[]);
int ccd_disptemp(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_settemp(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_clear(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_reset(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_configure(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_power(ClientData clientdata, Tcl_Interp *interp,
                   int objc, Tcl_Obj *CONST objv[]);
int ccd_dither (ClientData clientdata, Tcl_Interp *interp,
                int objc, Tcl_Obj *CONST objv[]);


int nasa42_stop(ccd_info *ccdptr, stop_struct * stop_dat);

int nasa42_header(fitsfile *fptr);


#ifdef old
typedef struct {
	int	sub;	/**<  Subframe to use for occultation exposure */
	int	nexp;	/**<  Set the number of exposures to take */
	char *	setamp;	/**<  Amplifier to use for the occultation exposure */
	char *	when;	/**<  When should the action start */
	float	etime;	/**<  The exposure time in floating point secs */
	ushort 	test;	/**<  Is the exposure a test exposure */
	float	itime;	/**<  The interval time in floating point secs */
	int		iframes;	/**<  The number of interval frames to expose */
	int		frame;	/**<  The type of frame to expose */
	int 	trigger;	/**<  The type of trigger for timing */
	char *	title;	/**<  The title of the frame */
	char *	comment1;	/**<  Comment for the storage file */
	char *	comment2;	/**<  Comment for the storage  file */
 } nasa42_ostruct;

/* nasa42 Header Information and Call */

#define NASA42KEYS 11

static char nasa42keywords[NASA42KEYS][11]={
	"DETECTOR\0",
	"CCDMODE\0",
	"GAIN\0",
	"RDNOISE\0",
	"TRIGGER\0",
	"NUMSUB\0",
	"SUBFNUM\0",
	"ORIGSEC\0",
	"CCDTEMP\0",
	"SETTEMP\0",
	"INTERVAL",
};
static char nasa42comments[NASA42KEYS][71]={
	"detector name\0",
	"CCD exposure mode\0",
	"gain, electrons per adu\0",
	"read noise, electrons\0",
	"trigger source(internal,etc..)\0",
	"Number of Subframes\0",
	"Subframe Number\0",
	"original size full frame\0",
	"CCD Temp in Deg C\0",
	"CCD Temp Set Value in Deg C\0",
	"Solar seconds between read outs",
};
Tcl_Obj  *nasa42keys[NASA42KEYS*3];
#endif

static struct QMMrecord {
   int avail;
   int triggeron;                /* non-zero if triggering currently running. */
   long trig_usecs;              /* last known trigger interval. */
   long ntrig;                   /* number of triggers expected last call. */
   long trigval;                 /* number of triggers you got last call. */
   struct timeval time_trigon;   /* last systime trigger turned on. */
   struct timeval time_trigoff;  /* last systime trigger turned off. */
};


/*
 * Structure for managing incremental dump of image data for display and
 * analysis within a long 3-d exposure.
 */
struct readout_incr_record {
   int finalbuffer;        /* if true dump final buffer end of readout. */
   long portion;           /* if >0 dump this portion (pixels) per cycle. */
   long skip;              /* skip this many portions between dumps. */
   int  row;               /* x size for portion dump. */
   int col;                /* y size for portion dump. */
   long disprows;          /* count of initial rows for display. */
   long skiprows;          /* remaining rows to skip. */
};

typedef int (*turn_on)( int );
typedef int (*turn_off)( void );
typedef int (*dac_set)( int );

/* legacy from hipo */
#define LEFT_AMP	0x005F5F4C	/* __L */
#define RIGHT_AMP	0x005F5F52	/* __R */
#define SPLIT_AMP	0x005F4C52	/* _LR */

#if 0
#define _A_AMP          0x005F5F41	/* __A */
#define _B_AMP          0x005F5F42	/* __B */
#endif
#define _A_AMP          LEFT_AMP
#define _B_AMP          RIGHT_AMP
#define _AB_AMP         SPLIT_AMP

#define _C_AMP          0x005F5F43	/* __C */
#define _D_AMP          0x005F5F44	/* __D */
#if 0
#define _AB_AMP         0x005F4142	/* _AB */
#endif
#define _CD_AMP         0x005F4344	/* _CD */
#define _AC_AMP         0x005F4143	/* _AC */
#define _BD_AMP         0x005F4244	/* _BD */
#define _ALL_AMP        0x00414C4C	/* ALL */


/* 
 *  Amplifier layout:
 *
 *      A          B
 *
 *
 *      C          D
 *
 * upper/lower and right/left are wrt the physical imaging area and
 * arbitrary from Lois point of view. It is guaranteed however that
 * after de-interlacing, AB gives the same image orientation as A
 * and B gives the orientation of A with the X axis flipped.
 * C, D, and CD after deinterlacing give the same image orientation
 * as A, B, and AB respectively with the Y axis flipped.
 * AC, BD, and ABCD (ALL) after deinterlacing give the same image orientation
 * as A, B, and AB respectively.
 * AD and BC are currently undefined and will not be implemented.
 */

#define A_AMP    0          /*  readout of upper left corner. */
#define B_AMP    1          /*  readout of upper right corner. */
#define AB_AMP   2          /*  split serials readout of upper right 
                             *  and left corners. */
#define C_AMP    3          /*   readout of lower left corner. */
#define D_AMP    4          /*   readout of lower right corner. */
#define CD_AMP   5          /*   split serials readout of lower right 
                             *   and left corners. */

/* if AD and BC get implemented, put here as 6,7. */

#define AC_AMP   8          /*  readout of upper, lower left corners
                             * with split parallels. */
#define BD_AMP   9          /*  readout of upper, lower right corners
                             * with split parallels. */
#define ALL_AMP  10         /*  readout of all 4 corners
                             * with split parallels and serials. */

#define RTIMOUT_CNT 15

#define NASA42_MAXAMP  4   
#define NASA42_IMGMODE_SCALE .327   /* 5.7' field */

#define ADTEMPSLOPE_NASA42_DEFAULT     .14100
#define ADTEMPINTRCPT_NASA42_DEFAULT   -538.0
#define HEATEROHMS_NASA42_DEFAULT      40.0

int nasa42_triggercam(ccd_info *ccdptr, struct QMMrecord *qmmr, int qmmtrig);
int trig_sendstart();
int trig_sendhalt();
int trig_sendttime(int trig_int, float *correction);
int trig_sendexit();
int trig_readtrig();




#endif
