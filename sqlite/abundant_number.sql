/*
An example of checking whether a number is abundant.
Usage: sqlite3 :memory: < abundant_number.sql
*/
.param set $num 945
with recursive abn(dig, sum) as (
   select 2, 1
   union all
   select dig + 1, sum + iif(mod($num, dig) = 0, dig, 0)
   from abn
   where dig < $num
)
select sum > $num
from abn
order by sum desc
limit 1;
