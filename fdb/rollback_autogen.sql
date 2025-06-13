create or alter procedure rollback_autogen(
  table_name varchar(31),
  gen_value bigint
)
as
begin
  execute statement 'alter sequence ' || (
    select first 1 trim(rdb$generator_name)
    from rdb$relation_fields
    where lower(rdb$relation_name) = lower(:table_name)
    order by rdb$field_position
  ) || ' restart with ' || :gen_value;
end#

comment on procedure rollback_autogen is 'sets a new generator value'#
