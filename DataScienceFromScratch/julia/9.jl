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
most_common_word()

#=
    Basics of text files
=#

function text_files()
  #open only work if file exists
  #read_file = open("read_file.txt","r")
  #close(read_file)

  write_file = open("write_file.txt","w")
  append_file = open("append_file.txt","a")
  println("files: $write_file, $append_file")
  close(write_file)
  close(append_file)
end
#text_files()

#use libraries like DataFrames.jl to process data. way easier and provides other functionalities

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
webscrapeEx()



print("\ndone")

