CC     = g++
CFLAGS = -Wall -g -std=c++11
BIN    = pgen 

$(BIN) : parser.o scanner.o Main.cpp ProtoFileLoader.h
	$(CC) $(CFLAGS) Main.cpp scanner.o parser.o -o $(BIN)

parser.o : parser.y
	bison parser.y
	$(CC) $(CFLAGS) -c -o parser.o parser.tab.c 

scanner.o : parser.y scanner.l Scanner.h
	flex scanner.l
	$(CC) $(CFLAGS) -c -o scanner.o lex.yy.cc

.PHONY : clean
clean :
# remove bison generated files
	rm -rf parser.tab.c parser.tab.h location.hh position.hh stack.hh
# remove flex generated files
	rm -rf lex.yy.cc
# remove compiled files
	rm -rf $(BIN) *.o

