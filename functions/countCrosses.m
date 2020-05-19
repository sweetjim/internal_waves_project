function count = countCrosses(image)
    count = length(nonzeros((gradient(image))));
end

