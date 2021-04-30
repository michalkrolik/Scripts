import snowflake.connector
import json
import os
import datetime

CONFIG_LOCATION='/home/mike/Desktop/SnowPython/'
CONFIG = json.loads(open(str(CONFIG_LOCATION+'config.json')).read())

SF_ACCOUNT    = CONFIG['secrets']['account']
SF_USER       = CONFIG['secrets']['user']
SF_WAREHOUSE  = CONFIG['secrets']['warehouse']
SF_ROLE       = CONFIG['secrets']['role']
SF_DATABASE   = CONFIG['secrets']['database']
SF_SCHEMA     = CONFIG['secrets']['schema']
SF_PASSWORD   = CONFIG['secrets']['password']

conn = snowflake.connector.connect (
    account    = SF_ACCOUNT,
    role       = SF_ROLE,
    user       = SF_USER,
    password   = SF_PASSWORD,
    database   = SF_DATABASE,
    schema     = SF_SCHEMA
)

sf = conn.cursor()
try:
    sf.execute("Call sp_cmt_stage();")
    sf.execute("List @cmt_stage pattern='.*pfz_sparrow_campaigns_[a-z]{2}_[0-9]{8}_[0-9]{5}.dat'")

    files = sf.fetchall()
    for file in files:
        countrycode = file[0][-21:-19].upper()
        file_date = file[0][-18:-10]
        file_date_formatted = file_date[0:4]+"-"+file_date[4:6]+"-"+file_date[6:8]

        filename = file[0][-43:]        

        copy_command = "copy into stg_email_campaigns_test (countrycode, campaignmetadataid, name, region, version, status, trackingcode, campaigntype, IsDeleted, create_date, file_date) "
        from_command = "From (SELECT '{}', $1, $2, $3, $4, $5, $6, $7, $8, CURRENT_TIMESTAMP, '{}' from @cmt_stage t) ".format(countrycode, file_date_formatted)
        formt = "file_format = (format_name = cmt_format) pattern = '.*"+filename+"' force=true;"

        print("Reading: "+filename)
        sf.execute(copy_command+from_command+formt)

finally:
    sf.close()
conn.close()