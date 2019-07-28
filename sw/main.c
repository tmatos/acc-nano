/*
 Demonstrate how to do HPS to FPGA comunication through the 'heavy' AXI bridge
 Need to program the FPGA with the modified GHRD project first,
 the mod just replaces the Avalon MM bridge master from h2f_lw_axi to h2f_axi
*/

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

#define ALT_FPGASLVS_OFST ( 0xC0000000 )  // FPGA slaves (ref.: cyclone v doc)

int main() {

	void *virtual_base;
	int fd;
	int loop_count;
	int led_direction;
	int led_mask;
	void *h2p_led_addr;
	void *h2p_controle_addr;

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	h2p_led_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LED_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	

	// toggle the LEDs a bit

	loop_count = 0;
	led_mask = 0x01;
	led_direction = 0; // 0: left to right direction
	while( loop_count < 5 ) {
		
		// control led
		*(uint32_t *)h2p_led_addr = ~led_mask; 

		// wait 100ms
		usleep( 100*1000 );
		
		// update led mask
		if (led_direction == 0){
			led_mask <<= 1;
			if (led_mask == (0x01 << (LED_PIO_DATA_WIDTH-1)))
				 led_direction = 1;
		}else{
			led_mask >>= 1;
			if (led_mask == 0x01){ 
				led_direction = 0;
				loop_count++;
			}
		}
	}


	// parte no heavy axi bus

	printf("FPGA slaves: %#010x \n", (unsigned long) (HW_REGS_BASE + ALT_FPGASLVS_OFST) ); // debug

	h2p_controle_addr = virtual_base + ( ( unsigned long  )( ALT_FPGASLVS_OFST + PIO_CONTROLE_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	// escreve o controle
	*(uint32_t *)h2p_controle_addr = 1988; 

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
