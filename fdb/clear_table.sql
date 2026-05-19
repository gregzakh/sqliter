create or alter procedure clear_table(table_name varchar(31))
as
declare variable field varchar(31);
declare variable gen   varchar(31);
begin
   select first 1 trim(rdb$field_name), trim(rdb$generator_name)
   from rdb$relation_fields
   where lower(rdb$relation_name) = lower(:table_name)
   order by rdb$field_position
   into :field, :gen;

   execute statement 'delete from ' || :table_name || ' where ' || :field || ' is not null';
   execute statement 'alter sequence ' || :gen || ' restart with 0';
end#

comment on procedure clear_table is 'auto-increment table cleanup strategy'#
