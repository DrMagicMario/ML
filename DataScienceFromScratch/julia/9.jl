#!/usr/local/bin/julia

using Pkg
Pkg.activate("jenv")
Pkg.instantiate()

using DataStructures
#=
    script that reads in lines of text and returns the ones that match a regular expression
        *use keyword 'ARGS' to access command line arguments
=#

function r_match()
  regex = ARGS[1]
  for arg in ARGS
    if arg == regex
      println(arg)
    end
  end
  print("done")
end
#r_match()

#=
    The | is the pipe character, which means “use the output of the left command as the input of the right command.” You can build pretty elaborate data-processing pipelines this way.
=#

most_common(c::Accumulator) = most_common(c, length(c))
most_common(c::Accumulator, k) = sort!(collect(c), by=kv->kv[2], rev=true)

function most_common_word()
  open("hamlet.txt") do f
    words = collect(m.match for m in eachmatch(r"\w+", read(f, String)))
    rankings = counter(words) |> most_common
    println("top 10 most common words: $(rankings[1:10])")
  end
end
#most_common_word()

#=
    Basics of text files
=#

function text_files()
  #open only work if file exists
  read_file = open("hamlet.txt","r")
  write_file = open("write_file.txt","w")
  append_file = open("append_file.txt","a")
  println("files: $write_file, $append_file")
  close(write_file)
  close(append_file)
  close(read_file)
end
#text_files()

#use files in a do or with block so the file is automatically closed 
function file_handling()
  data = open("hamlet.txt", "r") do io
    ##all of the implemenations below work

    #1
    #=
    while !eof(io)
      x = readline(io)
      println("$x")
    end
    =#

    #2
    for line in eachline(io)
      println("$line")
    end


    #3
    #=
    read(io, String)
    println("$data")
    =#
  end
end
#file_handling()

#Delimited Files
#use libraries like DataFrames.jl to process data. way easier and provides other functionalities
using CSV, DataFrames, DelimitedFiles

function delim_files()
  #tab delimited
  df = DataFrame(CSV.File("stockprices.txt"))
  stocks = copy.(eachrow(df))
  for row in stocks
    date = row[1]
    symbol = row[2]
    price = row[3]
    println("date: $date  symbol: $symbol price: $price")
  end

  #headers
  dataframe = DataFrame(CSV.File("stockprices_headers.txt"))
  stonks = copy.(eachrow(dataframe))
  for row in stonks
    date = row["date"]
    symbol = row["symbol"]
    price = row["closing_price"]
    println("date: $date  symbol: $symbol price: $price")
  end
end
delim_files()

#=
    Scraping the Web
=#

using HTTP, Gumbo, Cascadia
function webscrapeEx()
  io = open("get_data.txt","w")
  url = "http://shop.oreilly.com/category/browse-subjects/data.do?sortby=publicationDate&page=1"
  r = HTTP.get(url,response_stream=io)
  close(io)
  r_parsed = parsehtml(String(r.body))
  head, body = r_parsed.root[1], r_parsed.root[2]
  println("Head: $head\nBody: $body")
end
#webscrapeEx()



print("\ndone")

