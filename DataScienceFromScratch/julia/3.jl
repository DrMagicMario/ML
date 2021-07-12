#!/usr/local/bin/julia

#=
  Resources
  ---------

    *JuliaDocs: https://docs.julialang.org/en/v1/ 
    *JuliaPlots: http://docs.juliaplots.org/latest/
    *Visualizations: https://www.youtube.com/watch?v=WxEBII1_YWY
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


########################################## Line charts #########################################

variance = [1, 2, 4, 8, 16, 32, 64, 128, 256]
bias_squared = [256, 128, 64, 32, 16, 8, 4, 2, 1]

function line_test()
  total_error = [x+y for (x,y) in zip(variance,bias_squared)]
  xs = [i for (i,n) in enumerate(variance)]
  plot(xs,variance,l= :green, label = "variance")
  plot!(xs,bias_squared ,l= :red, label = "bias^2")
  plot!(xs,total_error ,l= :blue, label = "total error", show =true, xlabel ="model complexity", title="The Bias-Variance Tradeoff")
end
#line_test()


######################################### Scatter plot ########################################
friends = [ 70,  65,  72,  63,  71,  64,  60,  64,  67]
minutes = [175, 170, 205, 120, 220, 130, 105, 145, 190]
labels =  ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']

function scatter_test()
  scatter(friends, minutes, title="Daily Minutes vs. Number of Friends",
          xlabel="# of friends", ylabel="daily minutes spent on the site",
          show =true, series_annotations = text.(labels, :bottom))
end
scatter_test()
readline() #wait for user input to exit
