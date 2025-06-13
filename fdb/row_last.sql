create or alter function row_last(
  table_name varchar(31)
)
returns bigint
as
declare variable gen_name varchar(31);
declare variable gen_value bigint;
begin
  select first 1 trim(rdb$generator_name)
  from rdb$relation_fields
  where lower(rdb$relation_name) = lower(:table_name)
  order by rdb$field_position
  into :gen_name;

  execute statement 'select gen_id(' || :gen_name ||
            ', 0) from rdb$database' into :gen_value;
  return :gen_value;
end#

comment on function row_last is 'getting potential last row via generator'#
