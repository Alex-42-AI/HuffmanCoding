import Data.Char

type Dict a b = [(a, b)]

data Tree = Leaf Int Char | Node Int Tree Tree
  deriving (Show, Eq)

data Bit = O | I
  deriving (Show, Eq)

fromMaybe :: Maybe a -> a
fromMaybe Nothing = error "Nothing!"
fromMaybe (Just x) = x

makeTree :: String -> Maybe Tree
makeTree "" = Nothing
makeTree ('N':r) = Just (Node (fromMaybe (getValue r 0)) (fromMaybe (makeTree ('(':helper (tail (fromMaybe (rest r))) 1 ""))) (fromMaybe (makeTree (right (tail (fromMaybe (rest r))) 1))))
  where
    getValue "" _ = Nothing
    getValue (c:cs) res = if (isDigit c) then getValue cs (10 * res + (digitToInt c)) else (if res > 0 then Just res else getValue cs res)
    
    helper :: String -> Int -> String -> String
    helper "" _ res = reverse res
    helper _ 0 res = reverse res
    helper (c:cs) n res = if c == '(' then helper cs (n + 1) (c:res) else (if c == ')' then helper cs (n - 1) (c:res) else  helper cs n (c:res))
    
    rest "" = Nothing
    rest (c:cs) = if c == '(' then Just (c:cs) else rest cs
    
    right :: String -> Int -> String
    right "" _ = ""
    right (c:cs) n = if c == '(' then (if n == 0 then c:cs else right cs (n + 1)) else (if c == ')' then right cs (n - 1) else right cs n)
makeTree ('L':r) = Just (Leaf (fromMaybe (getValue r 0)) (fromMaybe (getSymbol r)))
  where
    getValue "" _ = Nothing
    getValue (c:cs) res = if (isDigit c) then getValue cs (10 * res + (digitToInt c)) else (if res > 0 then Just res else getValue cs res)

    getSymbol "" = Nothing
    getSymbol "\'" = Nothing
    getSymbol ('\'':c:_) = Just c
    getSymbol (_:s) = getSymbol s
makeTree (_:r) = (makeTree r)

makeBits :: String -> Maybe [Bit]
makeBits "" = Just []
makeBits ('0':rest) = Just (O:(fromMaybe (makeBits rest)))
makeBits ('1':rest) = Just (I:(fromMaybe (makeBits rest)))
makeBits _ = Nothing

main :: IO ()
main = do
    word <- readFile "encodeInput.txt"
    print (encode_histogram word)
    print (hufmanTree word)
    print (encode word)
    tree <- readFile "decodeTreeInput.txt"
    bits <- readFile "decodeBitsInput.txt"
    print (decode (fromMaybe (makeTree tree)) (fromMaybe (makeBits bits)))

value :: Eq a => a -> Dict a b -> Maybe b
value _ [] = Nothing
value x (y:ys) = if x == (fst y) then Just (snd y) else value x ys


increment :: Eq a => a -> Dict a Int -> Dict a Int
increment el [] = [(el, 1)]
increment el (x:xs) = if el == (fst x) then (el, (snd x + 1)):xs else x:(increment el xs)


histogram :: Eq a => [a] -> Dict a Int
histogram s = reverse (helper s [])
  where
    helper [] res = res
    helper (c:cs) res = helper cs (increment c res)


least :: Dict a Int -> Maybe a
least [] = Nothing
least (p:ps) = Just (helper (fst p) ps (snd p))
  where
    helper el [] _ = el
    helper el (x:xs) val = if (snd x) < val then helper (fst x) xs (snd x) else helper el xs val


root :: Tree -> Int
root (Leaf v _) = v
root (Node n _ _) = n


hufmanTree :: String -> Tree
hufmanTree s = helper (filter (\x -> x /= (least_often s)) s) (Leaf (fromMaybe (value (least_often s) (histogram s))) (least_often s))
  where
    least_often _str = fromMaybe (least (histogram _str))
    helper str res = if str == "" then res else
        helper (filter (\x -> x /= (least_often str)) str) (Node ((root res) + (fromMaybe (value (least_often str) (histogram str))))
        (Leaf (fromMaybe (value (least_often str) (histogram str))) (least_often str)) res)


encode_histogram :: String -> Dict Char [Bit]
encode_histogram "" = []
encode_histogram s = helper tree_uniques [] []
  where
    tree_uniques = hufmanTree s
    helper (Leaf _ d) code res = (d, code):res
    helper (Node _ lt rt) code res = (left_res ++ right_res)
      where
        left_res = helper lt (code ++ [O]) res
        right_res = helper rt (code ++ [I]) res


encode :: String -> [Bit]
encode s = helper s
  where
    code_histogram = encode_histogram s
    helper "" = []
    helper (c:cs) = (fromMaybe (value c code_histogram)) ++ helper cs


decode :: Tree -> [Bit] -> String
decode tree code = helper tree code ""
  where
    helper (Leaf _ c) bits res = helper tree bits (res ++ [c])
    helper _ [] res = res
    helper (Node _ lt _) (O:bs) res = helper lt bs res
    helper (Node _ _ rt) (I:bs) res = helper rt bs res
