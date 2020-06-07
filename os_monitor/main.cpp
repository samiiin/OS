#include <iostream>
#include<string.h>
#include<vector>
#include <sstream>
#include <fstream>
#include <thread>
#include <semaphore.h>
#include <stdlib.h> 
#include<chrono>
#include <ctime>
using namespace std;
using namespace chrono;
class Monitor;
vector<Monitor> monitors;
float total_pollution;
sem_t mutex_sem;
vector<string> split (const string &s, char delim) {
    vector<string> result;
    stringstream ss (s);
    string item;
    while (getline (ss, item, delim)) {
        result.push_back (item);
    }
    return result;
}

vector<vector<string> > get_map(string fileName){
    ifstream file(fileName);
    vector<vector<string> > map;
    if (file.is_open()) {
        string line;
        while (getline(file, line) && line[0]!='#') {
			line.pop_back();
            vector<string> path = split(line.c_str(), '-');
            map.push_back(path);
        }
        file.close();
    }
    return map;

}

vector<vector<string> > get_cars_path(string fileName){
    ifstream file(fileName);
    vector<vector<string> > cars_path;
    bool flag = false;
    if (file.is_open()) {
        string line;
        while (getline(file, line)) {
            if(line[0] == '#'){
                flag=true;
                continue;
            }
            if(flag){
				line.pop_back();
                vector<string> path = split(line.c_str(), '-');
                cars_path.push_back(path);
            }
        }
        file.close();
    }
    return cars_path;
}

struct condition{
	sem_t sem;
	int count;
};

class Monitor{
private:
	struct condition x;
	struct condition next;
	sem_t mutex;
	bool in_way;
	int h;
	string entrance;
	string exit;
	void wait();
	void signal();
public:
	int get_h(){return h;}
	string get_entrance(){return entrance;}
	string get_exit(){return exit;}
	void acquire();
	void release();
	Monitor(string s,string e,int _h);
};

Monitor::Monitor(string s,string e,int _h){
	entrance=s;
	exit=e;
	h=_h;
	x.count=0;
	sem_init(&(x.sem),0,0);
	next.count=0;
	sem_init(&(next.sem),0,0);
	sem_init(&(mutex),0,1);
	in_way=false;
}

void Monitor::wait(){
	x.count++;
	if(next.count>0)
		sem_post(&(next.sem));
	else
		sem_post(&mutex);
	sem_wait(&(x.sem));
	x.count--;
}

void Monitor::signal(){
	if(x.count>0){
		next.count++;
		sem_post(&(x.sem));
		sem_wait(&(next.sem));
		next.count--;
	}
}

void Monitor::acquire(){
	sem_wait(&mutex);
	if(in_way)
		wait();
	in_way=true;
	if(next.count > 0){
	   sem_post(&(next.sem));
	}
	else{
	   sem_post(&(mutex));
	}		

}

void Monitor::release(){
	sem_wait(&mutex);
	in_way=false;	
	signal();
	if(next.count > 0){
	   sem_post(&(next.sem));
	}
	else{
	   sem_post(&(mutex));
	}	
}

Monitor* find_monitor(string s,string e){
	for(int i=0;i<monitors.size();i++){
		string start = monitors[i].get_entrance();
		string end = monitors[i].get_exit();
		if((strcmp(s.c_str(),start.c_str()) == 0) && (strcmp(e.c_str(),end.c_str()) == 0)){
			return &(monitors[i]);
		}
	}
}

float calculate_pollution(int h,int p){
	float sum;
	sum=0;
	for(int k=0;k<10000000;k++){
		sum+=(float(k)/(float(1000000)*float(p)*float(h)));
	}
	return sum;
}

void calculate(vector<string> path,int id,int path_num,int p){
	string fileName=to_string(path_num)+"-"+to_string(id);
	ofstream myfile;
  	myfile.open (fileName);
	for(int i=0;i<path.size()-1;i++){
		Monitor* m=find_monitor(path[i],path[i+1]);
		m->acquire();
		milliseconds entrance = duration_cast< milliseconds >(system_clock::now().time_since_epoch());
		float self_p=calculate_pollution(m->get_h(),p);
		sem_wait(&mutex_sem);
		total_pollution+=self_p;
		sem_post(&mutex_sem);
		m->release();
		milliseconds exit = duration_cast< milliseconds >(system_clock::now().time_since_epoch());
		string written =path[i]+","+to_string(entrance.count())+","+path[i+1]+","+to_string(exit.count())+","+to_string(self_p)+","+to_string(total_pollution);
		myfile<<written<<endl;
	}
	myfile.close();
}

int main(int argc, char **argv)  {
    string fileName = argv[1];
    vector<vector<string> > map=get_map(fileName.c_str());
    vector<vector<string> > cars_path=get_cars_path(fileName.c_str());
    vector<thread*> cars;
    int car_num;
    int car_id=0;
	total_pollution = 0;
	sem_init(&(mutex_sem),0,1);
	for(int i=0;i<map.size();i++){
		Monitor m(map[i][0],map[i][1],atoi(map[i][2].c_str()));
		monitors.push_back(m);
	}
    for(int i=1;i<cars_path.size();i+=2){
        car_num=atoi(cars_path[i][0].c_str());
        for(int j=0;j<car_num;j++){
            car_id++;
			int p=1+rand()%10;
	    	thread* car=new thread(calculate,cars_path[i-1],car_id,i/2+1,p);
	   	 	cars.push_back(car);
		}
    }
    for(int i=0;i<cars.size();i++)
       cars[i]->join();
    return 0;
}