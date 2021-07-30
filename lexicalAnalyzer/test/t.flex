%{
int numChars = 0, numWords = 0, numLines = 0;
%}
%%
username	printf("%s\n", getlogin());
"for"     printf("%s\n", "for");
%%
int main() {
yylex();
 printf("%d\t%d\t%d\n", numChars, numWords, numLines);
}
