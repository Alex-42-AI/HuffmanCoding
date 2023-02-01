# HufmanCoding
Hufman coding is an algorithm for compression of a sequence of elements without loss of data. It works in four major steps:
1) Generating a histogram (frequency list) of the elements on the sequence;
2) Creating a Hufman tree, based on it (the Hufman tree is an ordered pair of a binary tree and a list of the unique elements under each leaf;
3) Generating the binary codes for each letter inder the tree's leaves (left is 0 and right is 1);
4) Replacing each consequitive letter in the original message with its binary code.

# Code instructions

In the `main` function information is read from the three input files.
The `encode` function is applied to the text from file encodeInput.txt.
Information about the Hufman tree and the encoded message in bits is taken
respectively from file decodeTreeInput.txt and file decodeBittsInput.txt.
