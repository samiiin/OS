#include<iostream>
#include<fcntl.h>
#include<sys/types.h>
#include<unistd.h>
#include<string.h>
#include <sstream>
#include <vector>
#include<sys/wait.h>
#include<fstream>
#include <sys/stat.h> 
#include <iomanip> 
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

int get_number_of_classifier(string weight_vectors){
    int file;
    int num=0;
    file=open((weight_vectors+"/classifier_0.csv").c_str(),O_RDONLY);
    while(file>0){
        num++;
        string s=weight_vectors+"/classifier_"+to_string(num)+".csv";
        file=open(s.c_str(),O_RDONLY);
    }
    return num;
}

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

int main(int argc, char **argv) {
    string weight_vectors=argv[2];
    string validation=argv[1];
    int classifier_num=get_number_of_classifier(weight_vectors.c_str());
    int p[classifier_num][2];
    for(int i=0;i<classifier_num;i++)
         mkfifo(("./"+to_string(i)).c_str(), 0666);
    mkfifo("./acfifo", 0666);
    for (int i = 0; i < classifier_num; i++){
        if (pipe(p[i])== -1){
            perror("pipe() failed!");
            exit(1);
        }
        int pid = fork();
        if (pid == 0){
            close(p[i][1]);
            char msg[1000]; 
            read(p[i][0], msg, 1000); 
            close(p[i][0]);
            vector<string> v = split (msg, '$');
            string c_w=(v[0]);
            string c_v=(v[1]);
            char ch_weight_vector[100];
            strcpy(ch_weight_vector,c_w.c_str());
            char ch_validation[100];
            strcpy(ch_validation,c_v.c_str());
            char number[100];
            strcpy(number,to_string(i).c_str());
            char* args[]={"./linearClassifier",number,ch_weight_vector,ch_validation,NULL};
            execv(args[0],args);
        }
        else if(pid > 0){
            close(p[i][0]);
            string send=validation+"$"+weight_vectors;
            write(p[i][1],send.c_str(), (send.length())+1);
            close(p[i][1]);
        }
    }
    int pid=fork();
    if(pid==0){
       vector<vector<string> > csv=read_csv((weight_vectors+"/classifier_0.csv").c_str());
       int size=csv.size();
       char number[100];
       strcpy(number,to_string(size).c_str());
       char classifier_n[100];
       strcpy(classifier_n,to_string(classifier_num).c_str());
       char* args[]={"./voter",classifier_n,number,NULL};
       execv(args[0],args);
    }

    int fdp = open("./acfifo", O_RDONLY); 
    char str[1000000];
    read(fdp, str,1000000); 
    close(fdp);
    vector<string> v = split (str, ' ');
    vector<vector<string> > label=read_csv((validation+"/labels.csv").c_str());
    float sum=0;
    float data_size=label.size();
    for(int i=0;i<label.size();i++){
        string first=label[i][0];
        string second=v[i];
	if(strcmp(first.c_str(),second.c_str())==0){
          sum++;
        }
    }
    float accuracy=((sum)/data_size)*100;
    cout<<"Accuracy: "<<setprecision(4)<<accuracy<<"%"<<endl;
    for(int i=0;i<classifier_num+1;i++)
          wait(NULL);
    for(int i=0;i<classifier_num;i++)
         unlink(("./"+to_string(i)).c_str());
    unlink("./acfifo");
    return 0;
}




