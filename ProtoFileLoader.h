/* This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */
 
#pragma once

#include <fstream>
#include "Scanner.h"

namespace ProtoGenerator {
	class ProtoFile {
		public:
			// can instantiate with either a file name or an already open stream
			inline explicit ProtoFile(const char * const fileName) throw(std::string);
			inline explicit ProtoFile(std::istream &iniStream) throw(std::string);

			// Get a value from section and key
			const char * getValue(const char * const section, const char * const key) const;
			void print();
		private:
			// supress default constructor
			ProtoFile();
			// supress default copy constructor
			ProtoFile(ProtoFile const &rhs);
			// supress default assignment operator
			ProtoFile &operator=(ProtoFile const &rhs);
			
			// the ini data
			ProtoFileLoader::mapData iniData;
	};
	
	/**
	 * Open and parse a file
	 */
	ProtoFile::ProtoFile(const char * const fileName) throw(std::string) {
		std::ifstream inFile(fileName);
		if (!inFile.good()) {
			throw std::string("Unable to open file");
		}
		
		ProtoFileLoader::Scanner scanner(&inFile);
		ProtoFileLoader::Parser parser(scanner, "", iniData);
		parser.parse();
	}

	/**
	 * Parse an already open stream
	 */
	ProtoFile::ProtoFile(std::istream &iniStream) throw(std::string) {
		ProtoFileLoader::Scanner scanner(&iniStream);
		ProtoFileLoader::Parser parser(scanner, "", iniData);
		parser.parse();
	}
	

	/**
	 * Retrieve a value
	 */
	char const * ProtoFile::getValue(const char * const section, const char * const key) const {
	    // find the section
	    ProtoFileLoader::mapData::const_iterator iSection = iniData.find(section);
	    if (iSection == iniData.end()) {
	        return 0;
	    }
	    
	    // find the value
	    std::map<std::string, std::string>::const_iterator iValue = iSection->second.find(key);
	    if (iValue == iSection->second.end()) {
	        return 0;
	    }
	    
	    // return the result
		return iValue->second.c_str();
	}
	void ProtoFile::print() {
		
		for(auto &subject : iniData){
			for (auto &obj: subject.second) {
				cerr << obj.second << endl;
			}
		}
	}
}

