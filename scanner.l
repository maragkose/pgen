/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */
 
%{
	#include "Scanner.h"
	// used to keep track of location
	#define YY_USER_ACTION yylloc->columns(yyleng);
%}

DIGIT    [0-9]
ID       [a-zA-Z_][a-zA-Z"_"0-9]*

%option nodefault yyclass="Scanner" noyywrap c++

%%


%{
	yylloc->step();
%}

<<EOF>>		             { return ProtoGenerator::ProtoFileLoader::Parser::token::tENDOFFILE;}
enum                         { return ProtoGenerator::ProtoFileLoader::Parser::token::tENUM; }
struct                       { return ProtoGenerator::ProtoFileLoader::Parser::token::tSTRUCT; }
union                       { return ProtoGenerator::ProtoFileLoader::Parser::token::tUNION; }
required                      { return ProtoGenerator::ProtoFileLoader::Parser::token::tREQUIRED; }
optional                      { return ProtoGenerator::ProtoFileLoader::Parser::token::tOPTIONAL; }
uint8                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tUINT8; }
uint16                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tUINT8; }
uint32                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tUINT32; }
uint64                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tUINT64; }
string                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tSTR; }
pack                	     { return ProtoGenerator::ProtoFileLoader::Parser::token::tPACK; }
tlv 	                     { return ProtoGenerator::ProtoFileLoader::Parser::token::tTLV; }
tv 	                     { return ProtoGenerator::ProtoFileLoader::Parser::token::tTV; }
"{" 	                     { return ProtoGenerator::ProtoFileLoader::Parser::token::tCURLY_START; }
"}"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tCURLY_END; }
"("                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tBRACKET_START; }
")"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tBRACKET_END; }
"["                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tSQUARE_START; }
"]"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tSQUARE_END; }
"+"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tPLUS; }
"-"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tMINUS; }
"="                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tEQUAL; }
","	                     { return ProtoGenerator::ProtoFileLoader::Parser::token::tCOMMA; }
";"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tSEMICOLON; }
":"                          { return ProtoGenerator::ProtoFileLoader::Parser::token::tCOLON; }
{DIGIT}+                     { *yylval = yytext; return ProtoGenerator::ProtoFileLoader::Parser::token::tINTEGER; };
{ID}                         { *yylval = yytext;       return ProtoGenerator::ProtoFileLoader::Parser::token::tSTRING;};
[ \t]+  		     { yylloc->step(); }
"\n"+                        { yylloc->lines(yyleng); yylloc->step(); }
