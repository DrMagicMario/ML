#!/usr/local/bin/julia

#=
  Resources
  ---------

    *JuliaDocs: https://docs.julialang.org/en/v1/ 
    *JUliaPlots: http://docs.juliaplots.org/latest/
=#


using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using Plots, StatsBase
gr()

############################################# Plots ##########################################
years = [1950, 1960, 1970, 1980, 1990, 2000, 2010]
gdp = [300.2, 543.3, 1075.9, 2862.5, 5979.6, 10289.7, 14958.3]

function plot_test()
  plot(years,gdp, color = :green, linestyle = :solid)
  plot!(title="Nominal GDP")
  plot!(ylabel="Billions of \$") #'$' is a keyword in strings -> \$ 
  plot!(show = true)
end
#plot_test()


########################################## Bar charts #########################################
movies = ["Annie Hall", "Ben-Hur", "Casablanca", "Gandhi", "West Side Story"]
num_oscars = [5, 11, 3, 8, 10]
grades = [83,95,91,87,70,0,85,82,100,67,73,77,0]

function bar_test()
  xs = [i+0.1 for (i,n) in enumerate(movies)]
  bar(xs,num_oscars,ylabel="# of Academy Awards",title="My Favorite Movies")
  bar!(xticks=[i + 0.5 for (i,n) in enumerate(movies)],show=true)
end
#bar_test()

function histogram_test()
  decile = grade -> (grade%10) * 10
  histogram = countmap(decile(grade) for grade in grades)
  bar(collect(keys(histogram)), collect(values(histogram)), show=true)
  bar!(xaxis=[-5, 105], yaxis=[0, 5]) # x-axis from -5 to 105; y-axis from 0 to 5
  bar!(xticks=[10*i for i=0:10]) # puts x-axis labels at 0, 10, 20, ..., 100.
  bar!(xlabel="Decile",ylabel="# of Students",title="Distribution of Exam 1 Grades")
end
#histogram_test()


########################################## Bar charts #########################################
readline() #wait for user input to exit
