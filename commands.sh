rm a.out
flex parse.l
bison -d parse.y
gcc *.c -lfl
./a.out
