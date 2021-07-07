#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()
using Gadfly, DataFrames, Tar, Downloads

DOWNLOAD_ROOT = "https://raw.githubusercontent.com/ageron/handson-ml2/master/"
HOUSING_URL = string(DOWNLOAD_ROOT,"datasets/housing/housing.tgz")
println("\nhousing url: ",HOUSING_URL) #https://raw.githubusercontent.com/ageron/handson-ml2/master/datasets/housing/housing.tgz

HOUSING_PATH = mkpath(string(pwd(),"/datasets/housing")) #make dir in current path
println("\nhousing path: ",HOUSING_PATH) #/Users/igs/Github Repos/DataScienceFromScratch/datasets/housing


function fetch_data(housingurl = HOUSING_URL, housingpath = HOUSING_PATH)
  #check in correct directory
  if pwd() != housingpath
    cd(housingpath)
  end
  tgz_path = joinpath(pwd(),"housing.tgz")
  println("created tgz path: ", tgz_path)
  housing_tgz = Downloads.download(housingurl, tgz_path) #download housing url to tgz_path
  Tar.extract(housing_tgz) #cant extract: ERROR: LoadError: invalid octal digit: 'Ö'
end

fetch_data()



