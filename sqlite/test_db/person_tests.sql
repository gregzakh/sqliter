.mode table

-- same birthday
select group_concat(pers_id) pers_ids,
       group_concat(name||' '||surname) names,
       birthday,
       count(pers_id) total
from person
group by birthday
having count(*) > 1;
