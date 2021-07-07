#!/usr/local/bin/python3.9

import os
import matplotlib as mpl
gui_env = ['GTK3Agg', 'GTK3Cairo', 'MacOSX', 'nbAgg', 'Qt4Agg', 'Qt4Cairo', 'Qt5Agg', 'Qt5Cairo', 'TkAgg', 'TkCairo', 'WebAgg', 'WX', 'WXAgg', 'WXCairo', 'agg', 'cairo', 'pdf', 'pgf', 'ps', 'svg', 'template'] #backends for Matplotlib
mpl.use(gui_env[2]) #select MacOSX
import matplotlib.pyplot as plt
import tarfile
from six.moves import urllib
import pandas as pd
import numpy as np
from zlib import crc32
from sklearn.model_selection import train_test_split, StratifiedShuffleSplit

###################################### download data #######################################

DOWNLOAD_ROOT = "https://raw.githubusercontent.com/ageron/handson-ml2/master/"
HOUSING_PATH = os.path.join("datasets","housing")
HOUSING_URL = DOWNLOAD_ROOT + "datasets/housing/housing.tgz"

def fetch_housing(housing_url=HOUSING_URL,housing_path=HOUSING_PATH):
    #assert correct dir
    if not os.path.isdir(housing_path):
        os.makedirs(housing_path)
    tgz_path = os.path.join(housing_path, "housing.tgz") #creating path to house .tgz file
    urllib.request.urlretrieve(housing_url, tgz_path) #download file to created path
    housing_tgz = tarfile.open(tgz_path) #open .tgz
    housing_tgz.extractall(path=housing_path) #extract files @housing_path
    housing_tgz.close() 

def load_housing(housing_path=HOUSING_PATH):
    csv_path = os.path.join(housing_path, "housing.csv") 
    return pd.read_csv(csv_path) #returns panda dataframe object

#get data
#fetch_housing()
housing = load_housing()

def download_test():
    print("\nHEAD:\n",housing.head()) #shows top row of data (see attributes)
    print("\nINFO:")
    print(housing.info()) #description of data
    print("\nOCEAN_PROXIMITY:\n", housing["ocean_proximity"].value_counts()) #display categories in a column
    
    #summary of numerical attributes
    print("\nDESCRIBE:")
    print(housing.describe())

    #histogram
    housing.hist(bins=50)
    plt.show()
    return 

download_test()

##################################### create test set #######################################

#need a test set to test for overfitting! 

#pick some instances randomly, typically <20% of the dataset,
def split_train_test(data, test_ratio):
    shuffled_idx = np.random.permutation(len(data)) #randomize data order
    test_set_size = int(len(data)*test_ratio) #compute size*=ratio 
    test_idx = shuffled_idx[:test_set_size] #select testsize
    train_idx = shuffled_idx[test_set_size:] #rest is testset
    return data.iloc[train_idx], data.iloc[test_idx] 

#prevent volatility of testset by hashing images and selecting ones within a range
#check
def test_set_check(identifier, test_ratio):
    return crc32(np.int64(identifier)) & 0xffffffff < test_ratio *2**32
#select testset
def split_train_test_by_id(data, test_ratio, id_column):
    ids = data[id_column]
    in_test_set = ids.apply(lambda id_: test_set_check(id_,test_ratio)) #match hash value
    return data.loc[~in_test_set], data.loc[in_test_set]

#Scikit-Learn
trainset, testset = train_test_split(housing, test_size=0.2, random_state=42) #uses a see for randomness (not good if dataset size changes)

#stratified sampling based on income_cat
housing["income_cat"] = pd.cut(housing["median_income"],
        bins = [0.,1.5,3.0,4.5,6.,np.inf],
        labels = [1,2,3,4,5])

split = StratifiedShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
for train_index, test_index in split.split(housing, housing["income_cat"]):
    strat_trainset = housing.loc[train_index]
    strat_testset = housing.loc[test_index]

#for set_ in (strat_trainset, strat_testset):
#    set_.drop("income_cat", axis=1, inplace=True)

def testSet_test():

    volatile_trainset, volatile_testset = split_train_test(housing, 0.2)
    print("volatile trainset: ", volatile_trainset)
    print("volatile testset: ", volatile_testset)
    housing_with_id = housing.reset_index() #adds index column
    housing_with_id["id"] = housing["longitude"] * 1000 + housing["latitude"] #create unique values
    const_trainset, const_testset = split_train_test_by_id(housing_with_id, 0.2, "id")
    print("const trainset: ", const_trainset)
    print("const testset: ", const_testset)
    print("scikit trainset: ", trainset)
    print("scikit testset: ", testset)
    housing["income_cat"].hist()
    plt.show()
    print("Stratified shuffle trainset: ", strat_trainset)
    print("Stratified shuffle testset: ", strat_testset)
    print(strat_testset["income_cat"].value_counts()/len(strat_testset))
    print("Stratified shuffle trainset: ", strat_trainset)
    print("Stratified shuffle testset: ", strat_testset)
    return

testSet_test()
