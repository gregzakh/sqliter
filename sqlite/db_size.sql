-- computes size of the database
with db_size(Kb) as (
   select page_count * page_size / 1024.0
   from pragma_page_count(), pragma_page_size()
)
select round(Kb, 1) Kb,
       round(Kb / 1024, 1) Mb,
       round(Kb / 1024 / 1024, 1) Gb
from db_size;
