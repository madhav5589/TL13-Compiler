typedef enum {
        MUL_OP,
        DIV_OP,
        MOD_OP,
        PLUS_OP,
        MINUS_OP,
        EQ_OP,
        NEQ_OP,
        L_OP,
        G_OP,
        LEQ_OP,
        GEQ_OP
}Arith_Ops;

typedef enum { typeLit, typeVar, typeOp, typeStr } nodeEnum;

//Literal node type
typedef struct {
	int value;
} litNodeType;

//Variable node type
typedef struct {
	char* name; //index in symbol table
} varNodeType;

//String node type for decalarations
typedef struct {
	char* name;
} strNodeType;

//Operator node type
typedef struct {
	int operation;
	int num_ops;
	struct nodeTypeTag **operands;
} opNodeType;

typedef struct nodeTypeTag {
	nodeEnum type;
	
	union {
		litNodeType lit;
		varNodeType var;
		opNodeType op;
		strNodeType str;
	};
} nodeType;
