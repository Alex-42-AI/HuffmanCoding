# HufmanCoding
Hufman coding is an algorithm for compression of a sequence of elements without loss of data. It works in four major steps:
1) Generating a histogram (frequency list) of the elements on the sequence;
2) Creating a Hufman tree, based on it - a binary tree of integers with a character on each leaf;
3) Generating the binary codes for each letter on the tree's leaves (left is 0 and right is 1);
4) Replacing each consequitive letter in the original message with its binary code.

The `encode` function accepts a text and returns a sequence of bits for it via a Hufman tree of this text.

The `decode` function works the other way around - it takes a Hufman tree and a sequence of bits and returns the original message based on the input.

# Code instructions

In the `main` function information is read from the three input files.
The `encode` function is applied to the text from file encodeInput.txt.
Information about the Hufman tree and the encoded message in bits is taken respectively from file
decodeTreeInput.txt and file decodeBittsInput.txt and given as arguments to the `decode` function.
