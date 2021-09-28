-- https://dodona.ugent.be/nl/courses/819/series/9249/activities/656007670

rits []          _ = []
rits _          [] = []
rits (x:xs) (y:ys) = (x, y) : rits xs ys
