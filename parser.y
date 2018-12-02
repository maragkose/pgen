/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */
 
%require "2.4.1"
%skeleton "lalr1.cc"
%defines
%locations
%define api.namespace {ProtoGenerator::ProtoFileLoader}
%define parser_class_name {Parser}
%parse-param { ProtoGenerator::ProtoFileLoader::Scanner &scanner }
%parse-param { std::string currentSection }
%parse-param { ProtoGenerator::ProtoFileLoader::mapData &iniData }
%lex-param   { ProtoGenerator::ProtoFileLoader::Scanner &scanner }

%code requires {
	#include <string>
	#include <sstream>
	#include <map>
	#include "Printer.h"
	// We want to return a string
	#define YYSTYPE std::string

	namespace ProtoGenerator {
		namespace ProtoFileLoader {
			// Forward-declare the Scanner class; the Parser needs to be assigned a 
			// Scanner, but the Scanner can't be declared without the Parser
			class Scanner;
		
			// We use a map to store the INI data
			typedef std::map<std::string, std::map<std::string, std::string> > mapData;
		}
	}
}

%code {
	// Prototype for the yylex function
	static int yylex(ProtoGenerator::ProtoFileLoader::Parser::semantic_type * yylval,
	                 ProtoGenerator::ProtoFileLoader::Parser::location_type * yylloc,
	                 ProtoGenerator::ProtoFileLoader::Scanner &scanner);
	Printer printer;
	#define debug_print(x) std::cerr << (x) << std::endl; 
}

%token tENUM tNAME tWORD tSTRUCT tUNION tPACK tCURLY_START tCURLY_END tBRACKET_START tBRACKET_END 
%token tSQUARE_START tSQUARE_END tEQUAL tTLV tTV tSPACE tCOMMA tCOLON tPLUS tMINUS tSEMICOLON tINTEGER  tSTRING
%token tUINT8 tUINT16 tUINT32 tUINT64 tREQUIRED tOPTIONAL tSTR tENDOFFILE
%%


input:          input line
	        | line 
		
	        ;
	
eofile:  	tENDOFFILE
		{
		debug_print("END OF FILE");
		printer.generateCode();
		return 0;
		}
line:           enumBlock
	        | structBlock
		| eofile
	        ;

//=======================================================================================
// ENUM BLOCK
//=======================================================================================
enumBlock:	tENUM tSTRING tCURLY_START
                {
			printer.enum_begin($2);
		
                }
		enumMembers tCURLY_END {
			printer.enum_end();
		}
		;
enumMembers:    
                tSTRING tEQUAL tINTEGER  
                {
			printer.enum_push($1, $3);
                }
                | tSTRING tEQUAL tINTEGER tCOMMA 
                {
			printer.enum_push($1, $3);
                }
                | enumMembers tSTRING tEQUAL tINTEGER  
                {
			printer.enum_push($2, $4);
                }
                ;

//=======================================================================================
// MESSAGE BLOCK
//=======================================================================================
structBlock:	tSTRUCT tSTRING tCURLY_START  
		{ 
			/*printer.struct_begin($2);*/
			debug_print("struct " + $2)
                    
		}
		structLines tCURLY_END tSEMICOLON
		{ 
			debug_print("----");
			printer.struct_end();
		}
		;

structLines:    /*empty*/
	 	| structLines structMemberType structMemberList tSEMICOLON
		{	
			$$=$3;
		}
		;

structMemberList: tSTRING  
                  { 
			debug_print("+ " + $1);
			$$=$1;
		/*	addAttribs($0,$1,0,(int)$2); */
		  }
                | tSTRING tSQUARE_START tINTEGER tSQUARE_END
                  { 
			debug_print("strucMemberList2");
			/*addAttribs($0,$1,(int)$3,0); */
		  }
                | structMemberList tCOMMA tSTRING tSTRING 
                  { 
			debug_print("strucMemberList3");
			/*addAttribs($0,$1,(int)$3,0); */
		 	/*addAttribs($0,$3,0,(int)$4); */
		  }
                | structMemberList tCOMMA tSTRING tSQUARE_START tINTEGER tSQUARE_END
                  { 
			debug_print("strucMemberList4");
			/*addAttribs($0,$1,(int)$3,0); */
			/*addAttribs($0,$3,(int)$5,0); */
		  }
                ;

structMemberType: tUINT8
	       	| tSTRING	
                {
		  debug_print("type:"+$1);
                  /*std::string type("$2::$4");*/
                  $$ = $0;
                }
                | embeddedType
                ;
optName:        /*empty*/ 
                { 
		  debug_print("AAA");
		  debug_print($0);
			
		  $$=$0; /*$$ = genName($0);*/ 
		}
                | tSTRING 
                { 
		  debug_print("AAA");
		  debug_print($1);
		  $$ = $1;
		}
                ;
 
embeddedType:   tSTRUCT optName tCURLY_START 
                {
		  debug_print("AAA");
                  /*openStruct($2,strcmp($1,"union") == 0);*/
                }
                structLines tCURLY_END 
                {
		  debug_print("AAA");
		  debug_print($2);
                  $$ = $2;
                }
	
%%

// Error function throws an exception (std::string) with the location and error struct
void ProtoGenerator::ProtoFileLoader::Parser::error(const ProtoGenerator::ProtoFileLoader::Parser::location_type &loc,
                                          const std::string &msg) {
	std::ostringstream ret;
	ret << "Parser Error at " << loc << ": " << msg;
	throw ret.str();
}

// Now that we have the Parser declared, we can declare the Scanner and implement
// the yylex function
#include "Scanner.h"
static int yylex(ProtoGenerator::ProtoFileLoader::Parser::semantic_type * yylval,
                 ProtoGenerator::ProtoFileLoader::Parser::location_type * yylloc,
                 ProtoGenerator::ProtoFileLoader::Scanner &scanner) {
	return scanner.yylex(yylval, yylloc);
}

