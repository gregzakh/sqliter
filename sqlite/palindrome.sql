.mode table

.param set $phrase "Madam, I'm Adam"
with
symbols(i, c) as (
   select 1, ''
   union all
   select i + 1, substr(lower($phrase), i, 1) chr
   from symbols
   where chr <> ''
),
purified as (
   select i, c
   from symbols
   where unicode(c) > 96 and unicode(c) <= 122
)
select $phrase phrase, iif((( -- checking the phrase for palindromicity
   select group_concat(c, '') from purified order by i desc
) = (select group_concat(c, '') from purified)), 'true', 'false') is_palindrome;
