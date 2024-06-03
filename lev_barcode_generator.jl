using Random
using ArgParse

function generate_dna_barcode(length)
    bases = ["A", "T", "C", "G"]
    return join(rand(bases, length))
end

function levenshtein_distance(s, t)
    d = zeros(Int, length(s) + 1, length(t) + 1)
    for i in 1:length(s)+1
        d[i, 1] = i - 1
    end
    for j in 1:length(t)+1
        d[1, j] = j - 1
    end
    for j in 2:length(t)+1
        for i in 2:length(s)+1
            if s[i-1] == t[j-1]
                d[i, j] = d[i-1, j-1]
            else
                d[i, j] = minimum([d[i-1, j]+1, d[i, j-1]+1, d[i-1, j-1]+1])
            end
        end
    end
    return d[length(s)+1, length(t)+1]
end

function is_valid_barcode(new_barcode, barcodes, min_distance)
    for barcode in barcodes
        if levenshtein_distance(new_barcode, barcode) < min_distance
            return false
        end
    end
    return true
end

function generate_barcodes(num_barcodes, barcode_length, min_distance)
    barcodes = String[]
    while length(barcodes) < num_barcodes
        new_barcode = generate_dna_barcode(barcode_length)
        if is_valid_barcode(new_barcode, barcodes, min_distance)
            push!(barcodes, new_barcode)
        end
    end
    return barcodes
end

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--num_barcodes", "-n"
        help = "Number of DNA barcodes to generate"
        arg_type = Int
        default = 96

        "--barcode_length", "-l"
        help = "Length of each DNA barcode"
        arg_type = Int
        default = 15

        "--min_distance", "-d"
        help = "Minimum Levenshtein distance between barcodes"
        arg_type = Int
        default = 7
    end
    args = parse_args(s)

    num_barcodes = args["num_barcodes"]
    barcode_length = args["barcode_length"]
    min_distance = args["min_distance"]

    barcodes = generate_barcodes(num_barcodes, barcode_length, min_distance)

    for barcode in barcodes
        println(barcode)
    end
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
