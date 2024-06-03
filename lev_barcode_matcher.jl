using CSV
using ArgParse
using DataFrames

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

function find_closest_barcode(observed_sequence, barcodes)
    min_distance = typemax(Int)
    closest_barcode = ""
    for barcode in barcodes
        dist = levenshtein_distance(observed_sequence, barcode)
        if dist < min_distance
            min_distance = dist
            closest_barcode = barcode
        end
    end
    return closest_barcode
end

function assign_barcodes(observed_sequences, barcodes)
    assignments = []
    for observed in observed_sequences
        closest_barcode = find_closest_barcode(observed, barcodes)
        push!(assignments, (observed, closest_barcode))
    end
    return assignments
end

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--barcodes-file", "-b"
        help = "Path to the file containing the list of chosen barcode sequences"
        arg_type = String

        "--observed-file", "-i"
        help = "Path to the file containing the list of observed sequences"
        arg_type = String

        "--output-file", "-o"
        help = "Path to the output CSV file"
        arg_type = String
        default = "assignments.csv"
    end
    args = parse_args(s)
    print(args)

    barcodes_file = args["barcodes-file"]
    observed_file = args["observed-file"]
    output_file = args["output-file"]

    barcodes = CSV.read(barcodes_file, DataFrame).Barcode
    observed_sequences = CSV.read(observed_file, DataFrame).Sequence

    assignments = assign_barcodes(observed_sequences, barcodes)

    df = DataFrame(Observed = [a[1] for a in assignments], Assigned = [a[2] for a in assignments])
    CSV.write(output_file, df)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
