import numpy as np
from scipy.io import loadmat, whosmat
from sklearn.decomposition import PCA
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.preprocessing import Imputer
from pprint import pprint


## functions ##
def Classify(TrainSet,TestSet,LabelsTrain):
	
	model = SVC()
	model.fit(TrainSet,LabelsTrain)

	OutLabelsTrain = model.predict(TrainSet)
	OutLabelsTest = model.predict(TestSet)

	return(OutLabelsTrain,OutLabelsTest)

def ScoreClassifer(TrueLabels,OutLabels):
	PercCorrect = 100 * sum(TrueLabels==OutLabels) / len(TrueLabels)
	return(PercCorrect)

## load data ##
data=loadmat('Proj1Data.mat')
#pprint(whosmat('Proj1Data'))

## reshape data ##
X = np.reshape(data['Proj1Im'],(data['Proj1Im'].shape[0]*data['Proj1Im'].shape[1],data['Proj1Im'].shape[2]))
Y = data['Proj1ClassLabels'].ravel()

## fill in missing values ##
imp = Imputer(missing_values='NaN', strategy='mean', axis=0)
imp.fit(X)
X = imp.transform(X)

## subset training/testing data by class
"""
idxTrain1 = [Ytrain==-1]
idxTrain2 = [Ytrain==1]
idxTest1 = [Ytest==-1]
idxTest2 = [Ytest==1]
"""
n = 2
algo = 2
CP = np.zeros((n,algo))-1 # intialize to negative one

for e in range(n):
	print("Experiment: {}".format(e+1))
	for a in range(algo):
		print("\tAlgorithm: {}".format(a+1))
		Xtrain, Xtest, Ytrain, Ytest = train_test_split(X,Y,train_size=0.75,stratify=Y)
		OutLabelsTrain,OutLabelsTest = Classify(Xtrain,Xtest,Ytrain)
		CP[e,a] = ScoreClassifer(Ytrain,OutLabelsTrain)

means = np.around(np.mean(CP,axis=0),decimals=1)
std = np.around(np.std(CP,axis=0),decimals=1)
CP = np.around(CP,decimals=0)

print(CP)
print(means)
print(std)










