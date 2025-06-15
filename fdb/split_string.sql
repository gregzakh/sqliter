create or alter procedure split_string(
  input_string varchar(4096),
  delimiter char(1) = ' '
)
returns (
  id integer,
  subvalue varchar(4096)
)
as
begin
  for
    with recursive split(s, r) as (
      select cast(null as varchar(4096)),
             :input_string || :delimiter
      from rdb$database
      union all
      select trim(substring(r from 1 for position(:delimiter, r) - 1)),
             substring(r from position(:delimiter, r) + 1)
      from split
      where r containing :delimiter and position(:delimiter, r) > 0
    )
    select row_number() over(), s
    from split
    where s is not null
    into :id, :subvalue
  do
    suspend;
end#

comment on procedure split_string
is 'splits a string into substrings relative to the specified separaor'#
-- depends on the previous procedure
create or alter procedure split_string_ex(
  input_string varchar(4096),
  delimiter char(1) = ' ',
  subvalue_number = 0
)
returns (
  subvalue varchar(4096)
)
as
begin
  for select s.subvalue
      from split_string(:input_string, :delimiter) s
      where (:subvalue_number <= 0 or s.id = :subvalue_number)
      into :subvalue
  do
    suspend;
end#

comment on procedure split_string_ex
is 'splits a string into substrings and extracts one of them by its index'#
