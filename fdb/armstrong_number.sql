create or alter function armstrong_number(val bigint)
returns boolean
as
declare variable len integer;
begin
  if (:val is null or :val < 0) then
    return false;

  len = char_length(:val);
  return (select sum(x) = :val
    from (
      select n, power(substring(:val from n for 1), :len) x
      from (
        select row_number() over() n from rdb$relations rows :len
      )
    )
  );
end#

comment on function armstrong_number
is 'checks if number is narcissistic'#
