--depends on GET_CHARSET_NAME function
create or alter procedure enum_clients
returns (
  id smallint,
  datetitme timestamp,
  state char(1),
  address varchar(20),
  application varchar(255),
  client varchar(255),
  host varchar(255),
  charset varchar(63)
)
as
begin
  for
    select row_number() over(order by a.mon$timestamp),
           a.mon$timestamp,
           a.mon$state,
           a.mon$remote_address,
           coalesce(a.mon$remote_process, c.mon$variable_value),
           a.mon$client_version,
           coalesce(a.mon$remote_os_user, a.mon$remote_host),
           get_charset_name(a.mon$character_set_id)
    from mon$attachments a
    left join mon$context_variables c
      on a.mon$attachment_id = c.mon$attachment_id
    where lower(mon$user) not in ('cache writer', 'garbage collector')
    into :id, :datetitme, :state, :address, :application, :client, :host, :charset
  do
    suspend;
end#

comment on procedure enum_clients is 'shows a list of database connections'#
