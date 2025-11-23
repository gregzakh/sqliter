with c(a,b) as (
   values(1,8),(9,4),(13,4),(17,4),(21,12)
), g(v) as (
   select lower(hex(randomblob(16)))
)
select group_concat(
   substr((select v from g), a, b), '-'
) guid
from c
