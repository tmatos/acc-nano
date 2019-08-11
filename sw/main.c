/*
 HPS to FPGA comunication through the 'light' or 'heavy' AXI bridges
 Need to program the FPGA with the updated GHRD project first
*/

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>
#include <sys/time.h>

#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"

#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

#define ALT_FPGASLVS_OFST ( 0xC0000000 )  // FPGA slaves (ref.: cyclone v doc)

int main()
{
	void *virtual_base;
	int fd;
	int loop_count;
	int led_direction;
	int led_mask;
	void *h2p_led_addr;
    volatile void *h2p_sw_addr;
    volatile uint32_t valor_sw;
    volatile void *h2p_acc_start;
    volatile void *h2p_acc_finish;


    // HW MAPPING ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // SWITCH READING ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    // get switches addrs, read and print the binary value as an unsigned decimal number

    h2p_sw_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + DIPSW_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    valor_sw = *(uint32_t *)h2p_sw_addr;
    printf("SWITCH = %u \n", valor_sw);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // LED BLINKING /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // get leds addrs
	
	h2p_led_addr = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LED_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	

	// toggle the LEDs a bit

    printf("Pisca-pisca... \n");

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

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // ACC INTERFACE ////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// pios de controle do acc

	h2p_acc_start = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_CONTROLE_START_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_acc_finish = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_CONTROLE_FINISH_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

    // para contagem de intervalos de tempo
    struct timespec inicio;
    struct timespec fim;

    clock_gettime(CLOCK_REALTIME, &inicio);  /// T_zero

    printf("DBG: Enviar sinal de start \n");

	// escreve um valor de controle para iniciar o acc
	*(uint32_t *)h2p_acc_start = (uint32_t) 0xFFFFFFFF;
    ////usleep(10);
    ////// logo em seguida volta a zero, pois queremos apenas um pulso
    ////*(uint32_t *)h2p_acc_start = (uint32_t) 0x00000000;

    printf("DBG: Sinal de start enviado \n");

    printf("DBG: Esperando retorno de finish \n");

    // POOLING

    volatile uint32_t finish;

    do {
        usleep(250000); // 250000 us = 0.25 s
        finish = *(uint32_t *)h2p_acc_finish;
        printf("DBG: pooling, finish = %8X \n", finish);
    } while( finish == 0 );

    printf("DBG: Retorno de finish recebido = %8X \n", finish);

    printf("DBG: Zerar sinal de start \n");
    *(uint32_t *)h2p_acc_start = (uint32_t) 0x00000000;

    clock_gettime(CLOCK_REALTIME, &fim);  /// T_final

    // calculo do delta_t em ns
    long tempo = ((fim.tv_sec * 1000000000 + fim.tv_nsec) - (inicio.tv_sec * 1000000000 + inicio.tv_nsec));

    // precisao do 'instrumento' de medida
    struct timespec tp;
    clock_getres(CLOCK_REALTIME, &tp);
    long precisao = (tp.tv_sec * 1000000000 + tp.tv_nsec);

    printf("\nFPGA ACC:\n\n");
    printf("TEMPO GASTO: %ld (ns)\n", tempo );
    printf("   PRECISAO: %ld (ns)\n\n", precisao );

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // HW UNMAPPING /////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	return( 0 );
}
