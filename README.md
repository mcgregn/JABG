# JABG
Just Another DNA Barcode Generator

A package for generating and matching DNA barcodes based on Levenshtein distance. Code is written in Julia. 

Generator takes arguments for barcode length ("-l"), number of sequences to genreate ("-n"), and minimum Levenshtein distance ("-d", number of substitutions or indels tolerated)

Barcodes are currently printed to the terminal. 

Code will hang if impossible combinations of length, distance, and number of sequences are chosen. If it takes >10 seconds, kill it and try incrementing the length, decrementing the number of sequences, or decrementing the distance. 

Current inputs and outputs for matching are csv flat files.
