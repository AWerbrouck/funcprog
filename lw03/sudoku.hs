
{-|

  Een sudoku wordt voorgesteld door een tweedimensionaal rooster van getallen.
  We gebruiken geneste lijsten "row-first", zoals in onderstaande tekening.

    o---0-1-2--3-4-5--6-7-8-----> x
    |
   0| [[0,0,0|,0,0,0,|0,0,0],
   1|  [0,0,0|,0,0,0,|0,0,0],
   2|  [0,0,0|,0,0,0,|0,0,0],
    |  ------+-------+------
   3|  [0,0,0|,0,0,0,|0,0,0],
   4|  [0,0,0|,0,0,0,|0,0,0],
   5|  [0,0,0|,0,0,0,|0,0,0],
    |  ------+-------+------
   6|  [0,0,0|,0,0,0,|0,0,0],
   7|  [0,0,0|,0,0,0,|0,0,0],
   8|  [0,0,0|,0,0,0,|0,0,0]]
   |
   V
   y
-}
type Board = [[Int]]

-- Enkele type-synoniemen
type Row = [Int]   -- ^ Een rij in een sudoku.
type Col = [Int]   -- ^ Een kolom in een sudoku.
type X   = Int     -- ^ De x van een coördinaat.
type Y   = Int     -- ^ De y van een coördinaat.

-- Enkele constanten
empty, width, height :: Int
empty  =  0  -- ^ Een leeg vakje.
width  =  9  -- ^ De breedte van een sudoku.
height =  9  -- ^ De hoogte van een sudoku.

-- | Een lege rij.
emptyRow :: Row
emptyRow = []

-- | Een leeg bord.
emptyBoard :: Board
emptyBoard = [[]]

-- | Neem een rij uit een sudoku.
getRow :: Board -> Y -> Row
getRow b y = b!!y 

-- | Neem een kolom uit een sudoku.
getCol :: Board -> X -> Col
getCol b x = [ r!!x | r <- b ]

-- | Controleert of een gegeven getal voorkomt in een gegeven rij.
contains :: Int -> [Int] -> Bool
contains = elem

-- | Bereken een deellijst.
getSubList :: Int  -- ^ Start-index (inclusief).
           -> Int  -- ^ Eind-index (inclusief).
           -> [a]  -- ^ Volledige lijst.
           -> [a]  -- ^ Deellijst.
getSubList s e l= drop s (take (e+1) l)

{-

  Met de volgende drie functies zullen we kijken of een vierkantje van 3 op 3
  een gegeven getal bevat. We omschrijven het vierkantje door 1 van zijn 9
  coördinaten in het volledige rooster. Gegeven bijvoorbeeld coördinaat (1,1)
  zoeken we in het vierkantje linksboven, met grenzen (0:2, 0:2). Coördinaat (7, 4) wijst van weer op
  het vierkantje links in het midden (6:8, 3:5).

  De indexmethode zal deze grenzen teruggeven, maar in 1 as tegelijk:
  - index 1 = (0, 2)
  - index 7 = (6, 8)
  - index 4 = (3, 5)

-}

-- | De grenzen van het vierkantje waar gegeven getal in ligt (in 1 as).
index :: Int -> (Int, Int)
index i = (s, (s+2))
	where s = 3 * ( div i 3)

-- | De lijst van getallen die in het vierkantje van gegeven coördinaat liggen.
-- Hint: gebruik tweemaal `getSubList`.
getSubSquare :: Board -> X -> Y -> [Int]
getSubSquare b x y = concat [ getSubList xs xe c | c <- rows ]
	where (xs,xe) = index x
      	      (ys, ye) = index y
	      rows = getSubList ys ye b
-- | Of in een rooster een getal in het vierkantje van gegeven coördinaten ligt.
containedInSquare :: Board -> Int -> X -> Y -> Bool
containedInSquare b i x y = contains i (getSubSquare b x y)

-- | Of in een rooster een getal op gegeven coördinaat past. Dit is het geval
-- als de omvattende rij, kolom of vakje van die coördinaat dat getal nog niet
-- bevatten.
canPlaceNumber :: Board -> Int -> X -> Y -> Bool
canPlaceNumber b i x y = and [not (containedInSquare b i x y) , not (contains i (getCol b x)), not (contains i (getRow b y))]

-- | Vervangt het element op gegeven coördinaat door het gegeven element.
replace :: a -> Int -> [a] -> [a]
replace newElement n xs = take n xs ++ [newElement] ++ drop (n + 1) xs

-- | Vervangt het element op gegeven coördinaat door het gegeven element.
update :: Int -> X -> Y -> Board -> Board
update newElement x y b = replace (replace newElement x (getrow b y)) y b

-- | De eerste (in leesvolgorde) lege coördinaat in een bord.
findFirstEmpty :: Board -> (X, Y)
findFirstEmpty b = head [ (c,r) | (getRow b r)!!c == 0]
	where

-- | Of dit bord geen lege vakjes meer bevat.
noneEmpty :: Board -> Bool
noneEmpty = undefined

-- | De lijst van getallen die past op een locatie op een bord.
options :: Board -> X -> Y -> [Int]
options = undefined

-- | De lijst van mogelijke borden die 1 vakje verder ingevuld zijn.
nextBoards :: Board -> [Board]
nextBoards = undefined

-- | Los een sudoku-puzzel op.
solve :: Board    -- ^ De focus, de huidige oplossing.
      -> [Board]  -- ^ De borden die we nog verder kunnen uitwerken.
      -> Board    -- ^ De opgeloste sudoku.
solve = undefined


