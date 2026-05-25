create or alter function abundant_number(val bigint)
returns boolean
as
declare variable div     bigint;
declare variable sum_div bigint;
declare variable div_sqr bigint;
begin
   if (:val is null or :val <= 1) then
      return false;

   :div = 2;
   :sum_div = 1;

   while (true) do
   begin
      :div_sqr = :div * :div;
      if (:div_sqr > :val) then
         break;

      if (mod(:val, :div) = 0) then
      begin
         :sum_div = :sum_div + :div;
         if (:div_sqr != :val) then
            :sum_div = :sum_div + (:val / :div);
         if (:sum_div > :val) then
            return true;
      end
      :div = :div + 1;
   end

   return :sum_div > :val;
end#

comment on function abundant_number
is 'checks if number is abundant'#
