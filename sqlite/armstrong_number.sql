/*
An example of checking whether a number is PPDI.
Usage: sqlite3 :memory: < armstrong_number.sql
*/
.param set $num 1634
with recursive arm(pow, rem) as (
   select power(substr($num, 1, 1), length($num)), substr($num, 2)
   union all
   select power(substr(rem, 1, 1), length($num)), substr(rem, 2)
   from arm
   where rem <> ''
)
select sum(pow) = $num
from arm;
