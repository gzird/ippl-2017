.PHONY: clean distclean count

CFILES   = 
HFILES   = 
OBJFILES = $(patsubst %.cpp,%.o,$(CFILES))
SRCFILES = $(HFILES) $(CFILES)

CC=g++
CFLAGS2=-Wall -pedantic -g -std=c++0x -Wno-psabi
CFLAGS=-g -Wall

all: parser24

parser.o : parser.cpp
	$(CC) $(CFLAGS2) -c $<

parser24: lexer.o parser.o 
	$(CC) $(CFLAGS) -o $@ $^

lexer.cpp: lexer.l
	flex -s -o $@ $<

parser.cpp parser.hpp: parser.y 
	bison -v -t -d -o parser.cpp $<

lexer.o: lexer.cpp parser.hpp
	$(CC) $(CFLAGS2) -c $<

clean:
	$(RM) $(OBJFILES) lexer.cpp parser.cpp parser.hpp parser.output *.o *~

distclean: clean
	$(RM) $(EXEFILES) parser24

count:
	wc -l -c Makefile $(SRCFILES)
