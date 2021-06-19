
CFLAGS=-g

.PHONY=check

all: sort_strings sort_structs

sort.o: sort.c sort.h

sort_strings.o: sort_strings.c sort.h

sort_strings: sort_strings.o sort.o 
	gcc $(CFLAGS) -o sort_strings sort_strings.o sort.o 

sort_structs.o: sort_structs.c sort.h

sort_structs: sort_structs.o sort.o 
	gcc $(CFLAGS) -o sort_structs sort_structs.o sort.o 

check: sort_strings sort_structs
	./sort_strings
	./sort_structs

clean:
	@echo -n Cleaning...
	@rm *~ *.o sort_structs sort_strings 2>/dev/null || true
	@echo done
