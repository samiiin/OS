#include<iostream>
#include <stdio.h>
#include<iostream>
#include<fcntl.h>
#include<sys/types.h>
#include<unistd.h>
#include<string>
#include <sstream>
#include <vector>
#include<fstream>
#include<vector>
#include<cmath>
#include<algorithm> 
#include <sys/stat.h> 
using namespace std;
vector<string> split (const string &s, char delim) {
    vector<string> result;
    stringstream ss (s);
    string item;
    while (getline (ss, item, delim)) {
        result.push_back (item);
    }
    return result;
}

int get_max_frequent(vector<vector<int> > result,int col,int class_num){
    vector<int> freq;
    for(int i=0;i<class_num;i++)
        freq.push_back(0);
    for(int i=0;i<result.size();i++){
        int n=result[i][col];
	freq[n]++;
    }
    int max =max_element(freq.begin(),freq.end()) - freq.begin();
    return max;
}

int main(int argc, char **argv) {
    int classifier_num=stoi(argv[1]);
    int class_num=stoi(argv[2]);
    vector<vector<int> > all_results;
    vector<int> best;
    for(int i=0;i<classifier_num;i++){
	int fd = open(("./"+to_string(i)).c_str(), O_RDONLY); 
        char str[1000000];
        read(fd, str,1000000); 
        close(fd);
        vector<string> v = split (str, ' ');
        vector<int> class_result;
    	for (int i=0;i<v.size(); i++){
     		int num = atoi(v.at(i).c_str());
     		class_result.push_back(num);
    	}
	all_results.push_back(class_result);
    }
    if(all_results.size()>0){
    	for(int i=0;i<all_results[0].size();i++){
        	int num=get_max_frequent(all_results,i,class_num);
                best.push_back(num);
	}
    }
    int fdp = open("./acfifo", O_WRONLY); 
    string s="";
    for (int i=0;i<best.size();i++){
         s+=to_string(best[i]);
         s+=" ";
    }
    write(fdp,s.c_str(),(s.length())+1); 
    close(fdp); 
}

