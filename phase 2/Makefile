parse:
	flex parser-v2.l
	yacc parser-v2.y
	gcc y.tab.c -lfl -w
	./a.out ../test.rs

clean:
	rm -f *.tab.c
	rm -f *.out
	rm -f *.yy.c