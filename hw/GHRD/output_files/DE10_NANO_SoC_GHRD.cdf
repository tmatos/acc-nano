/* Quartus Prime Version 18.1.1 Build 646 04/11/2019 SJ Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEBA6U23) Path("/home/tiago/projects/FPGA/de10-nano/DE10_NANO_SoC_GHRD/output_files/") File("DE10_NANO_SoC_GHRD.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
