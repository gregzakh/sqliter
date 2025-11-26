create or alter function hex(num bigint)
returns varchar(19)
as
declare hexmap varchar(16) = '0123456789ABCDEF';
declare result varchar(19) = '';
begin
  if (:num = 0 or :num is null) then
  	return null;
  while (:num > 0) do
  begin
    result = substring(hexmap from mod(:num, 16) + 1 for 1) || result;
 	  :num = :num / 16;
  end
  return '0x' || iif(result = '', null, result);
end#

comment on function hex
is 'converts decimal numbers to hexadecimal representation'#
