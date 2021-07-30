/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

int comment_line = 0;
int comment_level = 0;
int len_string = 0;

/*
 *  Add Your own definitions here
 */
 /* forward declarations */
 bool strTooLong();
 void exitStrState(char* msg);
 int strLenErr();
 void addToStr(char* str);
%}

/*
 * Define names for regular expressions here.
 */
DARROW		 =>
ASSIGN     <-
NEWLINE    \n
OTHER      [{};:,\.()<=\+\-~@\*/]
LE         <=
TYPEID     [A-Z][A-Za-z0-9_]*
OBJECTID   [a-z][A-Za-z0-9_]*
WHITESPACE [ \t\r\f]* 




%x DOUBLE_DASH_COMMENT
%x STAR_COMMENT
%x INSTRING
%x BREAKSTRING

/*
*  Nested comments
*/

/*
*  The multiple-character operators.
*/

%%

"--" {BEGIN(DOUBLE_DASH_COMMENT);}
<DOUBLE_DASH_COMMENT>\n {curr_lineno++;
											BEGIN(INITIAL);}
<DOUBLE_DASH_COMMENT>[^\n]*

"(*" {BEGIN(STAR_COMMENT);comment_level++;}
<STAR_COMMENT>"(*"						{comment_level++;}
<STAR_COMMENT>. 							{} 
<STAR_COMMENT>\n							{curr_lineno++;}
<STAR_COMMENT>\*\)						{comment_level--;
																if(comment_level==0)
																		BEGIN(INITIAL);}
<STAR_COMMENT><<EOF>> {
	/*cool_yylval.error_msg = "EOF in comment";*/
	BEGIN(INITIAL);
	/*return ERROR;*/}
{DARROW}	{ return DARROW; }
{LE} {return LE;}
{ASSIGN} {return ASSIGN;}
{NEWLINE} {curr_lineno++;}
{WHITESPACE}	{ ;}
{OTHER} {return (char)*yytext;}
(?i:class) { return CLASS; }
(?i:fi) { return FI; }
(?i:if) { return IF; }
(?i:in) { return IN; }
(?i:else) { return (ELSE); }
(?i:inherits) { return INHERITS; }
(?i:let) { return LET; }
(?i:loop) {return LOOP; }
(?i:pool) {return POOL; }
(?i:then) {return THEN; }
(?i:while) {return WHILE; }
(?i:case) {return CASE; }
(?i:esac) {return ESAC; }
(?i:of)  {return OF; }
(?i:new) {return NEW; }
(?i:isvoid) {return ISVOID; }
(?i:not) {return NOT;}

{TYPEID} {
	cool_yylval.symbol = idtable.add_string(yytext);
	return TYPEID;
}
{OBJECTID} {
	cool_yylval.symbol = idtable.add_string(yytext);
	return OBJECTID;
}
[0-9]+ {
	cool_yylval.symbol = inttable.add_string(yytext);
	return INT_CONST;
}

"*)"  {
        cool_yylval.error_msg = "Unmatched *)";
        return ERROR;
      }

\"              {
                    BEGIN(INSTRING);
                    len_string = 0;
             }
<INSTRING>\"      {
                    cool_yylval.symbol = stringtable.add_string(string_buf);
                    string_buf[0] = '\0';
                    BEGIN(INITIAL);
                    return (STR_CONST);
             }
<INSTRING>\0      {
                    cool_yylval.error_msg ="String contains null character";
                    string_buf[0] = '\0';
                    BEGIN(BREAKSTRING);
                    return ERROR;
             }
<INSTRING>\\\0    {
                    cool_yylval.error_msg ="String contains escaped null character.";
                    string_buf[0] = '\0';
                    BEGIN(BREAKSTRING);
                    return ERROR;
             }
<INSTRING>\n      {
                    cool_yylval.error_msg ="Unterminated string constant";
                    string_buf[0] = '\0';
                    curr_lineno++;
                    BEGIN(INITIAL);
                    return ERROR;
             }
<INSTRING>\\n     {

                    if (strTooLong()) { return strLenErr(); }
                    len_string = len_string + 2;
                    addToStr("\n");
                    
             }
<INSTRING>\\\n    {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    curr_lineno++;
                    addToStr("\n");
                    
                }
<INSTRING>\\t     {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    addToStr("\t");
                }
<INSTRING>\\b     {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    addToStr("\b");
             }
<INSTRING>\\f     {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    addToStr("\f");
             }

 /* All other escaped characters should just return the character. */
<INSTRING>\\.     {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    addToStr(&strdup(yytext)[1]);
             }
<INSTRING><<EOF>> {
                 cool_yylval.error_msg ="EOF in string constant";
                 curr_lineno++;
                    BEGIN(INITIAL);
                    return ERROR;
             }
<INSTRING>.       {
                    if (strTooLong()) { return strLenErr(); }
                    len_string++;
                    addToStr(yytext);
             }
<BREAKSTRING>\"  {
                    BEGIN(INITIAL);
             }
<BREAKSTRING>\\\n {
                 curr_lineno++;
                    BEGIN(INITIAL);
                }
<BREAKSTRING>\n  {
                 curr_lineno++;
                    BEGIN(INITIAL);
             }
<BREAKSTRING>.   {}

.               {
                 cool_yylval.error_msg =yytext;
                    return ERROR;
                }

%%

bool strTooLong() {
 if (len_string+ 1 >= MAX_STR_CONST) {
  BEGIN(BREAKSTRING);
        return true;
    }
    return false;
}





int strLenErr() {
 string_buf[0] = '\0';
    cool_yylval.error_msg ="String constant too long";
    return ERROR;
}

void addToStr(char* str) {
	strcat(string_buf, str);
}

/*
* Keywords are case-insensitive except for the values true and false,
* which must begin with a lower-case letter.
*/
