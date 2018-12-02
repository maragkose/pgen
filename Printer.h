#include <iostream>
#include <string>
#include <vector>

using namespace std; 

class Printer {

public:
	enum encoding_t {
		TLV=1,
		TV=2,
		BCD
	};
	enum base_t {
		STRING=1,
		UINT8=2,
		UINT16=3,
		UINT32=4,
		UINT64=5
	};
	struct ie_t {
		bool isRequired;
		encoding_t encoding;
		base_t baseType;
		int size;
		std::string ieName;
		std::string ieId;
	};
	
    	Printer(){ 
		std::cerr << "Initialised Printer"<< std::endl;
	};

	~Printer(){};

	void enum_begin(std::string val){ 
		m_currEnumName = val;	
	}   
	void enum_push(std::string name, std::string val){
		oEnumData[m_currEnumName][name] = val; 
	}  
	void enum_end(){
		enum_flush(); 
		m_currEnumName.clear();
	}
	void enum_flush(){
		
		std::cout << "enum " << m_currEnumName <<  " { " << std::endl;
		auto &oMyMap = oEnumData[m_currEnumName];
		for(auto it = oMyMap.begin(); it != oMyMap.end(); it++){
			std::cout << it->first << "=" << it->second;
			if(it != --oMyMap.end()){
				std::cout << "," << std::endl;
			}
		}
		std::cout << std::endl;
		std::cout << "};" << std::endl;
	}

	void struct_begin(std::string val) { 
		m_currMsgName = val;	
	}
	void ie_begin(string ieName) {
		m_currIEName = ieName;
	}
	void ie_end() {
		ie_push();
		ie_flush();
		m_currIEName.clear();
	}
	void ie_push_isRequired(bool val){
		cerr << "isRequired = " << val  << endl;
		m_curr_IEData.isRequired = val;
	}
   
	void ie_push_encoding(encoding_t val) {
		cerr << "encoding = " << val << endl;
		m_curr_IEData.encoding = val;
	}  
	void ie_push_baseType(base_t val) {
		cerr << "baseType = " << val << endl;
		m_curr_IEData.baseType = val;
	}  
	void ie_push_size(int val) {
		cerr << "size = " << endl;
		m_curr_IEData.size = val;
	}  
	void ie_push_ieName(std::string val) {
		cerr << "ieName = " << val << endl;
		m_curr_IEData.ieName = val;
	}  
	void ie_push_ieId(std::string val) {
		cerr << "ieId = " << val << endl;
		m_curr_IEData.ieId = val;
	}  
	void struct_end(){
		struct_flush(); 
		m_currMsgName.clear();
	}
	void ie_push() {
		cerr << "Setting current IE : " << m_currIEName << endl;
		oMsgData[m_currMsgName][m_currIEName] = m_curr_IEData;
	}
	void ie_flush(){
		ie_flush(m_currMsgName, m_currIEName);
	}
	void ie_flush(string msgName, string ieName){
		std::cerr << "IE: " << m_currMsgName <<  std::endl;
		std::cerr << "------------------------------" <<  std::endl;
		auto &oIE = oMsgData[msgName][ieName];
		std::cerr << oIE.ieName << std::endl;
		std::cerr << oIE.ieId << std::endl;
		std::cerr << oIE.encoding << std::endl;
		std::cerr << oIE.isRequired << std::endl;
		std::cerr << oIE.baseType << std::endl;
		std::cerr << oIE.size << std::endl;
		std::cerr << "------------------------------" <<  std::endl;
	}
	void struct_flush(){
		
		std::cerr << "Struct: " << m_currMsgName <<  std::endl;
		std::cerr << "------------------------------"  << std::endl;
		
		for(auto &subject : oMsgData){
			for (auto &obj: subject.second) {
				cerr << obj.second.ieName << endl;
			}
		}
		std::cerr << "------------------------------" <<  std::endl;
	}

	void generateCode(){
		std::cerr << "+++Starting code generation"<< std::endl;	
	}

private:
	
	//
	// Map of one Message block and enum block 
	//
	std::map <string, map <string, ie_t>   > oMsgData; 
	std::map <string, map <string, string> > oEnumData;

	//
	// Temporary placeholder of the name and/or data for IE
	//
	std::string m_currEnumName;
	std::string m_currIEName;
	struct ie_t m_curr_IEData;
	std::string m_currMsgName;
};

