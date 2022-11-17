CC = gcc
CFLAGS = -Wall
LDFLAGS = -Wall -lfl -ly
EXEC = tpc

$(EXEC): lex.yy.o $(EXEC).tab.o 
	$(CC) -o as $^ $(LDFLAGS)

$(EXEC).tab.c $(EXEC).tab.h: $(EXEC).y
	bison -d -v $(EXEC).y

lex.yy.c: $(EXEC).lex $(EXEC).tab.h
	flex $(EXEC).lex

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -f as lex.yy.* *.tab.c *.tab.h *.tab.o $(EXEC)
