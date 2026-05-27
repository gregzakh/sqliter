.mode table

-- same birthday
select group_concat(pers_id) pers_ids,
       group_concat(name||' '||surname) names,
       birthday,
       count(pers_id) total
from person
group by birthday
having count(*) > 1;

-- born in a leap year
select pers_id, name, surname, birthday
from person
where julianday(strftime('%Y-12-31', birthday)) -
      julianday(strftime('%Y-01-01', birthday)) > 364;

-- youngest namesake
select pers_id, name||' '||surname name, birthday
from person
group by name, surname
having count(*) > 1 and max(birthday);

select pers_id, name||' '||surname name, birthday
from (
   select last_value(birthday) over(
      partition by name, surname order by birthday
      rows between unbounded preceding
               and unbounded following
   ) lv, count(*) over(
      partition by name, surname
   ) cnt, pers_id, name, surname, birthday
   from person
)
where lv = birthday
  and cnt > 1;
