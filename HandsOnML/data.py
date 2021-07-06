#!/usr/local/bin/python3.9

import os
import tarfile
from six.moves import urllib
import pandas as pd

import matplotlib as mpl
gui_env = ['GTK3Agg', 'GTK3Cairo', 'MacOSX', 'nbAgg', 'Qt4Agg', 'Qt4Cairo', 'Qt5Agg', 'Qt5Cairo', 'TkAgg', 'TkCairo', 'WebAgg', 'WX', 'WXAgg', 'WXCairo', 'agg', 'cairo', 'pdf', 'pgf', 'ps', 'svg', 'template'] #backends for Matplotlib
mpl.use(gui_env[2]) #select MacOSX

import matplotlib.pyplot as plt

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

print("\nHEAD:\n",housing.head()) #shows top row of data (see attributes)

print("\nINFO:")
print(housing.info()) #description of data

print("\nOCEAN_PROXIMITY:\n", housing["ocean_proximity"].value_counts()) #display categories in a column

#summary of numerical attributes
print("\nDESCRIBE:")
print(housing.describe())

#histogram
housing.hist(bins=50)
plt.show(block=True)
