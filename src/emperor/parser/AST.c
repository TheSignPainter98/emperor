#include "AST.h"

// #define MAKE_NODE(A,  S,  N) \
// 	((person*)memcpy(calloc(sizeof(person) + (N), 1), \
// 					&(person const){ .age = (A), .sex = (S) }, \
// 					sizeof(person)))

AstNode_t *makeLeaf(nodeType_t nodeType, void *value)
{
	return makeNode(nodeType, value, NULL);
}

AstNode_t *makeJoiningNode(nodeType_t nodeType, AstNode_t *children[])
{
	return makeNode(nodeType, NULL, children);
}

AstNode_t *makeNode(nodeType_t nodeType, void *value, AstNode_t *children[])
{
	AstNode_t *newNode = (AstNode_t *)malloc(sizeof(AstNode_t));
	newNode->nodeType = nodeType;
	newNode->value = value;
	if (children != NULL)
	{
		memcpy(&(newNode->children), children, sizeof(children));
		newNode->numChildren = sizeof(*children);
	}
	else
	{
		newNode->numChildren = 0;
	}
	
	return newNode;
}

void printNode(AstNode_t *node)
{
	char *buffer;
	int len;

	// Get the output in the right format
	len = sprintf(buffer, "<AstNode %p: %d>(%d)", node, node->nodeType, node->numChildren);

	if (len != -1)
	{
		printf("%s\n", buffer);
		free(buffer);
	}
}

void destroyNode(AstNode_t *node)
{
	printf("%s%d\n", "Destroying node of type ", node->nodeType);
	for (int i = 0; i < node->numChildren; i++)
	{
		destroyNode(node->children[i]);
	}
}
