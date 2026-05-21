/*
This sample usage:
   sqlite3 :memory: < os_type.sql | sqlite3
*/
.shell sqlite3 temp.db "select '.shell echo '||iif(file like '%/%', 'unix && rm -f', 'win && del /f/q')||' temp.db' from pragma_database_list() where name = 'main';"
