parse:
	flex parser-v2.l
	yacc parser-v2.y
	gcc y.tab.c -lfl -w
	./a.out ../test.rs

optimize:
	python3 code_optimizer.py icg.txt

clean:
	rm -f *.tab.c
	rm -f *.out
	rm -f *.yy.c