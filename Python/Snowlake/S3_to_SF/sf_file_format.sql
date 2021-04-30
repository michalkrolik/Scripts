Create or replace file format cmt_format
    Type = csv
    field_delimiter = '|'
    record_delimiter = '\n'
    skip_header = 1
    empty_field_as_null = true
    ESCAPE = '\\'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;