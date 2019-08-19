/*
 conv kernel test
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
    volatile void *h2p_sw_addr;
    volatile uint32_t valor_sw;
    volatile void *h2p_acc_start;
    volatile void *h2p_acc_finish;
    volatile void *h2p_onchip_ram_in;
    volatile void *h2p_onchip_ram_out;


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


    // LOAD AND PREPARE DATA FOR TESTS ////

    unsigned int qtde_nums = 128;

    FILE * fp_entrada = fopen("entrada.dat", "r");

    if(!fp_entrada) {
        printf("Fornecer o arquivo \"entrada.dat\".\n");
        exit(1);
    }

    int i;

    int numeros_in[qtde_nums];
    int results_out[qtde_nums];

    for(i=0 ; i<qtde_nums ; i++) {
        fscanf(fp_entrada, "%i", (numeros_in+i) );
    }

    for(i=0 ; i<qtde_nums ; i++) {
        results_out[i] = 0;
    }

    printf("\nTeste da operacao no FPGA:\n\n"); /// DBG
    printf("Entrada = ");
    for(i=0 ; i<qtde_nums ; ++i) {
        printf("%i ; ", numeros_in[i]);
    }
    printf("\n\n");

    //////////////////////////////////////


    // ACC INTERFACE ////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // pios de controle do acc
    h2p_acc_start = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_CONTROLE_START_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_acc_finish = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_CONTROLE_FINISH_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

    // RAM inside the FPGA
    h2p_onchip_ram_in = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + ONCHIP_RAM_BASE + 0 ) & ( unsigned long)( HW_REGS_MASK ) );
    h2p_onchip_ram_out = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + ONCHIP_RAM_BASE + 1024 ) & ( unsigned long)( HW_REGS_MASK ) );

    // para contagem de intervalos de tempo
    struct timespec inicio;
    struct timespec fim;

    ///clock_gettime(CLOCK_REALTIME, &inicio);  /// T_zero

    printf("DBG: Enviando dados para o chip \n");
    memcpy( (void*)h2p_onchip_ram_in, (void*)numeros_in, qtde_nums*4);
    printf("DBG: OK \n");

    clock_gettime(CLOCK_REALTIME, &inicio);  /// T_zero

    ///printf("DBG: Enviar pulso de start \n");

    // escreve um valor de controle para iniciar o acc
    *(uint32_t *)h2p_acc_start = (uint32_t) 0xFFFFFFFF;
    //usleep(1); // na vdd, nao precisa de sleep pra o acc detectar
    // logo em seguida volta a zero, pois queremos apenas um pulso
    *(uint32_t *)h2p_acc_start = (uint32_t) 0x00000000;

    ///printf("DBG: Pulso de start enviado \n");

    ///printf("DBG: Esperando retorno de finish \n");

    // POOLING

    volatile uint32_t finish;

    do {
        //usleep(250000); // 250000 us = 0.25 s
        //usleep(1000); // 1000 us = 0.001 s
        finish = *(uint32_t *)h2p_acc_finish;
        ///printf("DBG: pooling, finish = %8X \n", finish);
    } while( finish == 0 );

    ///printf("DBG: Retorno de finish recebido = %8X \n", finish);

    clock_gettime(CLOCK_REALTIME, &fim);  /// T_final

    printf("DBG: Recebendo resultados do chip \n");
    memcpy( (void*)results_out, (void*)h2p_onchip_ram_out, qtde_nums*4);
    printf("DBG: OK \n");

    ///clock_gettime(CLOCK_REALTIME, &fim);  /// T_final

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


    // VER DADOS DO RESULTADO ////
    printf("Saida = ");
    for(i=0 ; i<qtde_nums ; ++i) {
        printf("%i ; ", results_out[i] );
    }
    printf("\n\n");
    //////////////////////////////


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
