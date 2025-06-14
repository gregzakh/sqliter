create or alter function get_charset_name(
  charset_id integer
)
returns varchar(63)
as
begin
  return (select rdb$character_set_name
          from rdb$character_sets
          where rdn$character_set_id = :charset_id);
end#

comment on function get_charset_name
is 'converts the encoding identifier into a string value'#
