all: libed25519.a

CC := gcc
CFLAGS := -O2 -pipe
CFLAGS += -Wall -pedantic
LDFLAGS += -Led25519

SRCS = $(wildcard src/*.c)
OBJS = $(SRCS:.c=.o)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

libed25519.a: $(OBJS)
	ls $(OBJS)
	ar rcs $@ $^

.PHONY: test
test: $(LIB)
	$(CC) -o $@ test.c $(LDFLAGS) -led25519

.PHONY: clean
clean:
	rm -f libed25519.a test test.o $(OBJS)


