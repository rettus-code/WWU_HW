
CFLAGS=-g -pedantic
LDFLAGS=

.PHONY=check

all: precision_test

check: all
	@if ./precision_test.sh; then echo "SUCCESS"; fi

precision_test: precision_test.o natural.o natural_aux.o
	$(CC) $(CFLAGS) -o precision_test precision_test.o natural.o natural_aux.o

natural_aux.o: natural_aux.s
	$(CC) $(CFLAGS) -c natural_aux.s

natural.o: natural.c natural.h

precision_test.o : precision_test.c natural.h


clean:
	@echo -n Cleaning...
	@rm *~ *.o precision_test 2>/dev/null || true
	@echo done
