create or alter function to_timespan (seconds bigint)
returns varchar(64)
as
declare variable ts timestamp;
begin
  ts = dateadd(second, :seconds, timestamp '0001-01-01 00:00:00');
  return datediff(day from timestamp '0001-01-01 00:00:00' to :ts)
	|| '.' || substring(:ts from 12 for 8);
end#

comment on function to_timespan
is 'converts seconds to elapsed days and time'#
