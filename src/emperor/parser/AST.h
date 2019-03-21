#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <printf.h>

#define GENERIC_TYPE 	1001
#define TUPLE_TYPE 		1002
#define TUPLE_VALUE 	1003
#define LIST_TYPE 		1004

typedef enum nodeTypes
{
	NUMBER_v,
	REAL_v,
	BOOLEAN_VALUE_v,
	FUNCTION_PURITY_v,
	PRIMITIVE_TYPE_v,
	ACCESS_MODIFIER_v,
	CHARACTER_v,
	STRING_v,
	program_v,
	line_v,
	startLineWhiteSpace_v,
	lineContents_v,
	functionalLine_v,
	declaration_v,
	type_list_non_zero_v,
	functionDeclarationLine_v,
	type_v,
	type_list_v,
	functionType_v,
	parameters_v,
	parameters_non_zero_v,
	parameter_v,
	returnType_v,
	assignment_v,
	declarationWithAssignment_v,
	expression_v,
	value_v,
	value_list_v,
	functionCall_v,
	impureFunctionCall_v,
	pureFunctionCall_v,
	arguments_v,
	args_non_zero_v,
	argument_v,
	variable_v,
	variable_list_with_ignores_v,
	variable_or_ignore_v
} nodeType_t;

typedef struct AstNode
{
	nodeType_t nodeType;
	void *value;
	int numChildren;
	struct AstNode *children[];
} AstNode_t;

typedef struct Line
{
	int lineNum;
	AstNode_t contents;
	struct Line *nextLine;
} Line_t;

AstNode_t *makeLeaf(nodeType_t nodeType, void *value);
AstNode_t *makeJoiningNode(nodeType_t nodeType, AstNode_t *children[]);
AstNode_t *makeNode(nodeType_t nodeType, void *value, AstNode_t *children[]);
void printNode(AstNode_t *node);
void destroyNode(AstNode_t *node);

#endif /* AST_H */