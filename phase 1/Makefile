parse:
	flex parser.l
	yacc parser.y
	gcc y.tab.c -lfl -w
	./a.out ../test.rs

clean:
	rm -f *.tab.c
	rm -f *.out
	rm -f *.yy.c