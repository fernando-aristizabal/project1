import numpy as np
from scipy.io import loadmat, whosmat, savemat
from sklearn.decomposition import PCA
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.preprocessing import Imputer
from pprint import pprint


## functions ##
def preProcessData(inputMatFile,outputMatFile):
	## load data ##
	data=loadmat(inputMatFile)

	## reshape data ##
	X = np.reshape(data['Proj1Im'],(data['Proj1Im'].shape[0]*data['Proj1Im'].shape[1],data['Proj1Im'].shape[2]))
	Y = data['Proj1ClassLabels'].ravel()

	## fill in missing values ##
	imp = Imputer(missing_values='NaN', strategy='mean', axis=0)
	imp.fit(X)
	X = imp.transform(X)

	## subset training/testing data by class
	idx1 = [ Y == -1]
	idx2 = [ Y == 1 ]

	processedData = { 'X' : X, 'Y' : Y, 'idx1' : idx1, 'idx2' : idx2 }
	savemat(outputMatFile,processedData)

	return(X,Y,idx1,idx2)


def Classify(TrainSet,TestSet,LabelsTrain):
	
	model = SVC()
	model.fit(TrainSet,LabelsTrain)

	OutLabelsTrain = model.predict(TrainSet)
	OutLabelsTest = model.predict(TestSet)

	return(OutLabelsTrain,OutLabelsTest)

def ScoreClassifer(TrueLabels,OutLabels):
	PercCorrect = 100 * sum(TrueLabels==OutLabels) / len(TrueLabels)
	return(PercCorrect)


def RunAll(numberOfExperiments=2):
	
	X,Y,idx1,idx2 = preProcessData('Proj1Data.mat','Processed_Proj1Data.mat')

	algo = 2
	datasets = 2
	CPtrain = np.zeros((datasets,algo,numberOfExperiments))-1 # intialize to negative one
	CPtest = np.zeros((datasets,algo,numberOfExperiments))-1 # intialize to negative one

	for n in range(numberOfExperiments):
		print("Experiment: {}".format(n+1))
		for a in range(algo):
			print("  Algorithm: {}".format(a+1))
			for d in range(datasets):
				print("    Dataset: {}".format(d+1))
				
				Xtrain, Xtest, Ytrain, Ytest = train_test_split(X,Y,train_size=0.75,stratify=Y)
				
				OutLabelsTrain,OutLabelsTest = Classify(Xtrain,Xtest,Ytrain)
				
				CPtrain[d,a,n] = ScoreClassifer(Ytrain,OutLabelsTrain)
				CPtest[d,a,n] = ScoreClassifer(Ytest,OutLabelsTest)

	meansTrain = np.around(np.mean(CPtrain,axis=2),decimals=1)
	stdTrain = np.around(np.std(CPtrain,axis=2),decimals=1)
	CPtrain = np.around(CPtrain,decimals=0)

	meansTest = np.around(np.mean(CPtest,axis=2),decimals=1)
	stdTest = np.around(np.std(CPtest,axis=2),decimals=1)
	CPtest = np.around(CPtest,decimals=0)

	print(meansTrain) ; print(stdTrain) #; print(CPtrain)
	print(meansTrain) ; print(stdTrain) #; print(CPtrain) 


RunAll(numberOfExperiments=2)






