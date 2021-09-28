-- https://dodona.ugent.be/nl/courses/819/series/9249/activities/655439734

roteer 0 l = l
roteer n l = roteer (n-1) (tail l ++ [head l])

