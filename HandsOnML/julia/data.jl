#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()
using CSV, DataFrames, Tar, Downloads, Arrow

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
  println("\ncreated tgz path: ", tgz_path)
  housing_tgz = Downloads.download(housingurl, tgz_path) #download housing url to tgz_path
  #Tar.extract(housing_tgz) #cant extract: ERROR: LoadError: invalid octal digit: 'Ö'
end

#fetch_data()

function load_data(housingpath=HOUSING_PATH)
  #check in correct directory
  if pwd() != housingpath
    cd(housingpath)
  end
  csv_path = joinpath(pwd(),"housing.csv")
  println("\ncreated csv path: ", csv_path)
  df = DataFrame(CSV.File(csv_path))
  #df = CSV.File(csv_path) |> DataFrame #pipe operator in julia! 
  return df 
end

#good Dataframe resource: https://syl1.gitbook.io/julia-language-a-concise-tutorial/useful-packages/dataframes
housing = load_data()
println("\nHEADER:\n", names(housing))
println("\nDESCRIPTION:\n", describe(housing))
println("\nOCEAN PROXIMITY:\n" ,describe(select(housing, "ocean_proximity")))


