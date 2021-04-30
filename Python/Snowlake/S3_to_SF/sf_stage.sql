Create or replace stage cmt_stage url = 's3://some_path/'
    credentials=(aws_key_id='...' aws_secret_key='...')
    encryption=(master_key='...')
    file_format = cmt_format
;