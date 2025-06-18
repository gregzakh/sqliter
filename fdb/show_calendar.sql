create or alter procedure show_calendar(
  "date" date = current_date
)
returns (
  mo varchar(2), tu varchar(2), we varchar(2), th varchar(2),
  fr varchar(2), sa varchar(2), su varchar(2)
)
as
begin
  for
    select max(case when d = 1 then b end),
           max(case when d = 2 then b end),
           max(case when d = 3 then b end),
           max(case when d = 4 then b end),
           max(case when d = 5 then b end),
           max(case when d = 6 then b end),
           max(case when d = 7 then b end)
    from (
      select b, (row_number() over() - 1) / 7 c,
             mod((row_number() over() - 1), 7) + 1 d
      from (
        select a, lag(a, b) over() b
        from (
          select row_number() over() a,
                 (select extract(weekday from :"date" - extract(day from :"date"))
                  from rdb$database) b
          from rdb$relations
          where rdb$system_flag = 1
        )
      )
      where b is null or b <= datediff(day, :"date", dateadd(1 month to :"date"))
    )
    group by c
    into :mo, :tu, :we, :th, :fr, :sa, :su
  do
    suspend;
end#

comment on procedure show_calendar is 'displays a simple calendar'#
