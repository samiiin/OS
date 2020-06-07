#include<iostream>
#include <stdio.h>
#include<iostream>
#include<fcntl.h>
#include<sys/types.h>
#include<unistd.h>
#include<string.h>
#include <sstream>
#include <vector>
#include<fstream>
#include<vector>
#include<cmath>
#include<algorithm> 
#include <sys/stat.h> 
#include <cerrno> 
using namespace std;
vector<vector<string> > read_csv(string dir){
        vector<std::string> col;
	string line;
	string field;
        vector<std::vector<std::string>> table;
        ifstream test;
	test.open(dir.c_str());

	if (!test.good()) {
		exit(1); 
	}
	while (getline(test, line)){
		col.clear();
		stringstream ss(line);
		while (std::getline(ss,field,',')){
			col.push_back(field);
		}
		table.push_back(col);
	}
        table.erase(table.begin());
	test.close();
        return table;
}

vector<int> specify_classes(string classifier_dir,string database_dir,string number){
      vector<vector<string> > classifier= read_csv(classifier_dir.c_str());
      vector<vector<string> > data= read_csv(database_dir.c_str());
      vector<int> data_result;
      vector<double> numbers;
      for(int i=0;i<data.size();i++){
          numbers.clear();
          for(int j=0;j<classifier.size();j++){
              double n=atof((data[i][0]).c_str())*atof((classifier[j][0]).c_str()) + 
                           atof((data[i][1]).c_str())*atof((classifier[j][1]).c_str()) +
                           atof((classifier[j][2]).c_str());
              numbers.push_back(n);
          }
          int max_i=max_element(numbers.begin(),numbers.end()) - numbers.begin();
          data_result.push_back(max_i);
     }
     return data_result;
}

int main(int argc, char **argv) {
    string number=argv[1];
    string weight_vectors=argv[3];
    string validation=argv[2];
    string classifier_dir=(weight_vectors+"/classifier_"+number+".csv").c_str();
    string data_dir=(validation+"/dataset.csv").c_str();
    vector<int> data_result=specify_classes(classifier_dir,data_dir,number);
    int fd = open(("./"+number).c_str(), O_WRONLY); 
    string s="";
    for (int i=0;i<data_result.size();i++){
         s+=to_string(data_result[i]);
         s+=" ";
    }
    write(fd,s.c_str(),(s.length())+1); 
    close(fd); 
    return 0;
}
