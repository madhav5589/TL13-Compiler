The following are set of production rules in BNF.
In this part of the project, we use lex/flex to do lexical analysis. Also using symbol table.

TL13 Language Language Syntax Comments The first occurrence of the character "%" on a line denotes the start of a comment that extends to the end of that line. For purposes of determining the lexical elements of the source file, the entire comment will be treated as if it were whitespace. Lexical Elements All TL13 lexical elements (a.k.a. tokens) are separated by spaces and should match one of the categories below. If the definition of a lexical element is in quotes, then it is meant to match exactly, the contained string. Otherwise, it is a regular expression. Square brackets in regular expressions are used as an abbreviation for matching ranges of letters. For example, [0-9] matches any digit, and [a-zA-Z] matches any English letter in capital or lower case. Numbers, Literals, and Identifiers: • num = [1-9][0-9]|0 • boollit = false|true • ident = [A-Z][A-Z0-9] Symbols and Operators: • LP = "(" • RP = ")" • ASGN = ":=" • SC = ";" • OP2 = "*" | "div" | "mod" • OP3 = "+" | "-" • OP4 = "=" | "!=" | "<" | ">" | "<=" | ">=" Keywords: • IF = "if" • THEN = "then" • ELSE = "else" • BEGIN = "begin" • END = "end" • WHILE = "while" • DO = "do" • PROGRAM = "program" • VAR = "var" • AS = "as" • INT = "int" • BOOL = "bool" Built-in Procedures: • WRITEINT = "writeInt" • READINT = "readInt" BNF Grammar ::= PROGRAM BEGIN END

::= VAR ident AS SC | e

::= INT | BOOL

::= SC | e

::= | | |

::= ident ASGN | ident ASGN READINT

::= IF THEN END

::= ELSE | e

::= WHILE DO END

::= WRITEINT

::= | OP4

::= OP3 |

::= OP2 |

::= ident | num | boollit | LP RP

Errata/Clarifications

Informal Type Rules 1. The operands of all OP2, OP3, and OP4 operators must be integers 2. The OP2 and OP3 operators create an integer result. 3. The OP4 operators create boolean results. 4. All variables must be declared with a particular type. 5. Each variables may only be declared once. 6. The left-hand of assignment must be a variable, and the right-hand side must be an expression of the variable's type. 7. When used as a value, a variable's type is its declared type. 8. Only integer variables may be assigned the result of readInt. 9. writeInt's expression must evaluate to an integer. 10. The expression guarding if-statements and while-loops must be boolean. 11. The literals "false" and "true" are boolean constants. 12. The literal numbers 0 through 2147483647 are integer constants. Numbers outside of that range should be flagged as illegal. Informal Semantics • Only those variables which have been declared can be assigned to or used. o All int variables and array elements are considered to have initial values of "0". o All bool variables are considered to have initial values of "false". • All binary operators operate on signed integer operands: o "x * y" results in the product of x and y. o "x div y" which results in the integer quotient of x divided by y. The behavior is not defined if y is 0 or if x is the smallest 32-bit negative integer and y is -1. o "x mod y" is the results in the remainder of x divided by y when x is non-negative and y is positive. Otherwise, the result is undefined. o "x + y" results in the sum of x and y. o "x - y" is the difference of y subtracted from x. o "x = y" is true if x and y are the same, otherwise it is false. o "x != y" is false if x and y are the same, otherwise it is true. o "x < y" is true if x is less than y, otherwise it is false. o "x > y" is true if x is greater than y, otherwise it is false. o "x <= y" is true if x is less than or equal to y, otherwise it is false. o "x >= y" is true if x is greater than or equal to y, otherwise it is false. o Computations should be done using integers using a 32-bit 2's complement representation. Overflowing computations should simply "wrap around". • "if" statements evaluate their expression, if the expression is true, then the "then-statements" are executed, if it is fales, the "else-statements" are executed. • "while" statements first evaluates its expression. If it is false, execution continues after the end of the "while" statement. If it is true, the statements in the body of the "while" loop are executed. After they finish executing, the expression is re-evaluated. As long as the expression is true, the process repeats itself, alternatively evaluating the expression and executing the statements in the body. Once the expression is false, execution continues after the end of the "while" loop. • "writeInt" evaluates its expression and outputs the result to the console and causes the cursor to move to the beginning of the next line. • "readInt" reads an integer from the console and updates an integer variable to hold that value. Lexical Features The TL13 language is lexically simple. All lexical items are to be separated by one or more whitespace characters (i.e., spaces, tabs, and returns). All identifiers start with a capital letter, and may contain only numbers and capital letters. All key words are start with lower-case letters or are a symbol. The symbols "(", ")", ":=", ";", "", "div", "mod", "+", "-", "=", "!=", "<", "<=", ">", ">=" are used. Data Types Core TL13 supports 32-bit integers ("int"), booleans ("bool"). Variables are always declared to be of a particular type. Operators TL13 has several infix binary operators that work on either integer operands. The multiplication "", division "div", modulus "mod", addition "+", and subtraction "-" produce integer results. The comparison operators (i.e., equals "=", not equal "!=", less than "<", less-than or equal-to "<=", greater than ">", and greater-than or equal-to ">=") all produce boolean results. Control Structures TL13 is a structured programming language. The only control structures supported are "if" and "while" statements. Both take a boolean expression that guards the body of the control structure. In the case of an "if" statement, the statements after the "then" are executed if the expression is true, and the statements after the "else" (if there is one) are executed if the expression is false. In the case of the "while" statement, the loop is exited if the expression false; otherwise if the expression is true, the body will be executed, and then the expression will be re-evaluated. Assignment Assignments are a kind of statement rather than a kind of operator. The ":=" keyword is used to separate the left hand side (which is the variable being assigned to) from the right hand side, which is an expression that must be of the same type as the left hand side. Built-in Procedures Core TL13 does not support user-defined functions or procedures, but it does support one built-in procedures "writeInt" that outputs an integer and a new-line to the console (respectively), and one user-defined function, "readInt" that reads an integer from the console. The syntax for these is hard-coded into TL13's BNF grammar.

Commands to run

flex parse.l
bison -d parse.y
gcc *.c -lfl
./a.out

Input
1.
program
	var X as int ;
begin
	X := readInt ;
	writeInt 2 * X ;
end




2.
program
	var X as int ;
	var Y as int ;
begin
        X := readInt ;
	Y := 5 - X ;
	writeInt X - Y ;
end


3. 
This is a program that approximates a sqrt to the smallest integer less than the square root by trying each possible sqrt until it finds one that is too large

program 
  var N as int ; 
  var SQRT as int ; 
begin 
  N := readInt ; 
  SQRT := 0 ; 
  while SQRT * SQRT <= N do 
    SQRT := SQRT + 1 ; 
  end ; 

  SQRT := SQRT - 1 ;

  writeInt SQRT ;
end ; 

 
EXEXCUTION:
INPUT
36
OUTPUT
6
-------------------
INPUT
35
OUTPUT
5
-------------------
INPUT
96
OUTPUT
9
-------------------
INPUT
100
OUTPUT
10
-------------------
INPUT
25
OUTPUT
5
-------------------
INPUT
9
OUTPUT
3
-------------------
INPUT
8
OUTPUT
2


4. 
program 
   var N as int ; 
   var I as int ; 
begin 
   N := readInt ; 

   I := 2 ; 
   while I <= N do 
      while N mod I = 0 do 
         N := N div I ; 
         writeInt I ; 
      end ; 
      I := I + 1 ; 
   end ; 
end 

 
EXECUTION
INPUT
35
OUTPUT
5
7
---------------------
INPUT
98
OUTPUT
2
7
7
---------------------
INPUT
96
OUTPUT
2
2
2
2
2
3
---------------------
INPUT
128
OUTPUT
2
2
2
2
2
2
2
---------------------
INPUT
60
OUTPUT
2
2
3
5
---------------------
INPUT
40
OUTPUT
2
2
2
5

 
5. FIbnoncci
program
   var N1 as int ; 
   var N2 as int ; 
   var NEXT as int ; 
   var MAX as int ; 
begin 
   MAX := readInt ; 

   N1 := 0 ; 
   N2 := 1 ; 

   writeInt N1 ; 

   while N2 < MAX do 
      writeInt N2 ; 
      NEXT := N1 + N2 ; 
      N1 := N2 ; 
      N2 := NEXT ; 
   end ; 
end 

EXECUTION
INPUT
25
OUTPUT
0
1
1
2
3
5
8
13
21

 
6. EUCLID
program
   var SMALLER as int ;
   var BIGGER as int ;
   var TEMP as int ;
begin
   BIGGER := readInt ;
   SMALLER := readInt ;

   if SMALLER > BIGGER then
      TEMP := SMALLER ;
      SMALLER := BIGGER ;
      BIGGER := TEMP ;
   end ;

   while SMALLER > 0 do
      BIGGER := BIGGER - SMALLER ;

      if SMALLER > BIGGER then
         TEMP := SMALLER ;
         SMALLER := BIGGER ;
         BIGGER := TEMP ;
      end ;
   end ;
   writeInt BIGGER ;
end

EXECUTION
INPUT
25
30
OUTPUT
5
---------------------
INPUT
256
78
OUTPUT
2
---------------------
INPUT
45
15
OUTPUT
15
---------------------
INPUT
30
20
OUTPUT
10