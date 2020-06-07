output: EnsembleClassifier.o linearClass.o voter.o
	g++ EnsembleClassifier.o -o EnsembleClassifier.out
	g++ linearClass.o -o linearClassifier
	g++ voter.o -o voter
EnsembleClassifier.o: EnsembleClassifier.cpp
	g++ -c EnsembleClassifier.cpp

linearClass.o: linearClass.cpp
	g++ -c linearClass.cpp

voter.o: voter.cpp
	g++ -c voter.cpp




