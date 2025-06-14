create or alter function new_guid
returns varchar(36)
as
begin
  return (select uuid_to_char(gen_uuid())
          from rdb$database);
end#

comment on function new_guid is 'creates a new GUID value'#
