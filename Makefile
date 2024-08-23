compressorscontest:
	fpc -Cg -O3 -CX -XX compressorscontest.pas
	-sstrip compressorscontest
clean:
	rm -f *.ppu *.o compressorscontest