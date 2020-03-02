# Hashcode 2020 baby

## FUNCTION DEFINITIONS ##
function target(scores::Array{Int64},remDays::Int64,libDetails::Dict{String},libContents::Dict{String}, usedBooks::Set)
    newBooks::Array{Int64,1} = setdiff([x[2] for x in libContents["books"]],usedBooks)
    if length(newBooks) > 0
        listToSum::Array{Int64,1} = [0]
        maxPossibleBooks::Int64 = libDetails["booksPerDay"]*(remDays-1-libDetails["signUpTime"])
        if maxPossibleBooks < 0
            return 0
        else
            bookNum::Int = length(newBooks) > maxPossibleBooks ? maxPossibleBooks : length(newBooks)

            for i in 1:bookNum
                push!(listToSum,scores[newBooks[i]+1])
            end
            total::Float64 = sum(listToSum)
            return (total+bookNum)/(libDetails["signUpTime"])
        end
    else
        return 0
    end
end

function calculateRanks(scores::Array{Int64},remDays::Int64,rankedLibs,libDetails,libContents,usedBooks::Set,usedLibs::Set)
    for (lib,libC) in zip(libDetails, libContents)
        auxDict = Dict("libID"=> 0, "libScore" =>0.0)
        if lib ∉ usedLibs
            score = target(scores,remDays,lib,libC,usedBooks)
        else
            continue
        end
        auxDict["libID"] = lib["libID"]
        auxDict["libScore"] = score
        push!(rankedLibs,(score,lib["libID"]))
        # Sort libraries by their target score!
    end
    return maximum(rankedLibs)[2]
end
## INPUT PARSING

const nBooks, libs, nDays = map(str -> parse(Int, str), split(readline(),' '))
const scores = map(str -> parse(Int, str), split(readline(),' '))

libDetails = []
libContents = []
for n in 1:libs
    auxDict::Dict{String} = Dict("bookNum" => 0, "signUpTime" => 0, "booksPerDay" => 0)
    auxDict["bookNum"], auxDict["signUpTime"], auxDict["booksPerDay"] = map(str -> parse(Int, str), split(readline(),' '))
    auxDict["libID"] = n-1
    push!(libDetails,auxDict)
    auxDict = Dict("books" => [])
    # Relate books to their score to sort
    auxList = map(str -> parse(Int, str), split(readline(),' '))
    for i in 1:length(auxList)
        push!(auxDict["books"], tuple(scores[auxList[1]+1], auxList[1]) )
        popfirst!(auxList)
    end
    push!(libContents,auxDict)
    # println(typeof(libDetails[n]))
    # println(libContents[n])
end
## PROCESSING
# Global number of books: nBooks
# Number of libraries: libs
# Number of days to scan: nDays
# bookNum, signUpTime, booksPerDay for specific lib: libDetails[n]
# books inside specific lib: libContents

# Sort book contents by score
for lib in libContents
    sort!(lib["books"],rev=true)
    # println(lib["books"])
end


# Stores books which are already in a delivery list
# for future use
usedBookSet = Set()
usedLibsSet = Set()

libOrder = []

# Find out EXACTLY how many books each library will provide, and which
remDays = nDays
deliveredBooks = Array{Array{Int}}(undef,libs)
libDeliverCount = 0
for ind in 1:libs
    global remDays
    global bestLib
    global libDeliverCount
    global usedBooksSet
    global usedLibsSet
    global libOrder
    global scores
    # Stores tuples with (Score,libID)
    rankedLibs = []
    # Recalculate ranks, now that the book list has changed!

    bestLib = calculateRanks(scores,remDays,rankedLibs,libDetails,libContents,usedBookSet,usedLibsSet)
    # "i" is the index of the highest ranked library, so far
    i = bestLib
    # Check if the current library will be able to deliver any books at all
    nPossibleBooks = (remDays-libDetails[i+1]["signUpTime"])*libDetails[i+1]["booksPerDay"]

    if nPossibleBooks ≤ 0
        continue
    end
    if remDays ≤ 0
        break
    else
        # Check for book duplicates for this specific library
        allBooks = [x[2] for x in libContents[i+1]["books"]]
        # This is the final list of books to be shipped
        tempBooks = []
        for book in allBooks
            if book ∉ usedBookSet
                push!(tempBooks,book)
            end
        end
        # If any books are present, put them in the deliveredBooks list
        if length(tempBooks) > 0
            if nPossibleBooks ≥ length(tempBooks)
                deliveredBooks[i+1] = deepcopy(tempBooks)
            else
                deliveredBooks[i+1] = deepcopy(tempBooks[1:nPossibleBooks])
            end
            # Update the sets of used resources
            push!(usedBookSet,tempBooks...)
            push!(usedLibsSet,i)
            push!(libOrder,i)
            # If books were delivered, take away days
            remDays -= libDetails[i+1]["signUpTime"]
            # Increment counter of libraries that will ship books
            libDeliverCount +=1
        end
    end
end

## OUTPUT PARSING
# Print pretty output
println(libDeliverCount)
for i in libOrder
    if isassigned(deliveredBooks,i+1)
        # print lib number and number of books it will ship
        println(i, ' ',length(deliveredBooks[i+1]))
        # From books and scores tuple, extract only book numbers
        tempStr = string(deliveredBooks[i+1])[2:end-1]
        # Take away commas from common list format
        tempStr = replace(tempStr, ", " => " ")
        println(tempStr)
    end
end
