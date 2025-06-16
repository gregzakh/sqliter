create or alter function get_days_in_month(
  "date" date = current_date
)
returns smallint
as
begin
  return (select datediff(day, :"date", dateadd(1 month to :"date"))
          from rdb$database);
end#

comment on function get_days_in_month
is 'calculates the total number of days in the specified month'#
