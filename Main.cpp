/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */
 
#include "ProtoFileLoader.h"
#include <string>
#include <iostream>
#include <cstring>

int main(int argc, char * argv[]) {
	// make sure we received a filename
	if (argc != 2) {
		std::cerr << "Usage: ./ini-parser [FILENAME]" << std::endl;
		return 255;
	}

	// try and open the INI file
		// - means stdin, not a file named '-'
		ProtoGenerator::ProtoFile * iniFile; 
		if (strcmp(argv[1], "-") == 0) {
			iniFile = new ProtoGenerator::ProtoFile(std::cin);
		} else {
			iniFile = new ProtoGenerator::ProtoFile(argv[1]);
		}
	std::cout << "PRINT";
	iniFile->print();
	return 0;
}

