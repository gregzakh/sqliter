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
