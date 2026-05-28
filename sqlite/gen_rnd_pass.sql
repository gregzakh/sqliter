-- simple password generator
with chars(c) as (
   select 33 union all select c + 1 from chars limit 90
)
select group_concat(c, '') from (
   select char(c) c from chars order by random() limit 13
);
