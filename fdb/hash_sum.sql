/*
Overengineering :)
But this can solve the problem of calculating hash sums of strings in Firebird3,
which only supports a limited HASH function.

Sequential steps:
1) deploy Firebird5 in docker
mkdir -p ~/data
docker run -p 3050:3050 --name firebird -e FIREBIRD_ROOT_PASSWORD=masterkey \
           -e FIREBIRD_USER=SYSDBA -e FIREBIRD_PASSWORD=masterkey \
           -e FIREBIRD_DATABASE=temp.fdb \
           -e FIREBIRD_DATABASE_DEFAULT_CHARSET=UTF8 \
           -v ~/data:/var/lib/firebird/data -d firebirdsql/firebird

2) allow legacy authentication
docker exec -it firebird bash
# cp /opt/firebird/firebird.conf /opt/firebird/firebird.conf.bak
# cat > /opt/firebird/firebird.conf << EOF
> AuthServer = Srp, Legacy_Auth
> AuthClient = Srp, Legacy_Auth
> UserManager = Srp, Legacy_UserManager
> WireCrypt = Enabled
> EOF
# exit
docker restart firebird

3) on Firebird3 side, define function below
*/
create or alter function hash_sum(
   input_string varchar(8192),
   algorithm varchar(6) = 'sha256'
)
returns varchar(64)
as
declare res varchar(64);
begin
  if (:input_string is null or :input_string = '') then
    return null;

  :algorithm = lower(:algorithm);
  if (:algorithm not in ('md5', 'sha1', 'sha256', 'sha384', 'sha512')) then
    return null;

  execute statement 'select hex_encode(crypt_hash(cast(''' || :input_string ||
     ''' as varchar(8192) character set utf8) using ' || :algorithm || ')) from rdb$database'
     on external '172.17.0.1:/var/lib/firebird/data/temp.fdb' -- use your Docker network
     with autonomous transaction
     as user 'sysdba' password 'masterkey'
  into :res;

  return res;
end#

comment on function hash_sum
is 'calculating hash sums of strings in Firebird3 via Firebird5'#
