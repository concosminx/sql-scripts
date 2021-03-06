/* generate profile ddl*/
select dbms_metadata.get_ddl('PROFILE', profile) as profile_ddl
from   (select distinct profile
        from   dba_profiles)
where  profile like upper(:PROFILE);