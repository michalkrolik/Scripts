CREATE or replace PROCEDURE sp_cmt_stage()
  RETURNS VARCHAR
  LANGUAGE javascript
  AS
    $$
    var current_path = "Select Concat('s3://static_path/',\
            Cast(year(CURRENT_DATE()) As Varchar(4)),'/',\
            Cast(month(CURRENT_DATE()) As Varchar(2)),'/',\
            Cast(day(CURRENT_DATE()) As Varchar(2)),'/')";
	var cmd = {sqlText: current_path};
	var stmt = snowflake.createStatement(cmd);
	var run = stmt.execute();
    run.next();
    
    var TODAY = run.getColumnValue(1);
    
    var alter_cmd =  "alter stage cmt_stage Set URL = "+TODAY+";";
	var run_cmd = {sqlText: alter_cmd};
	var run_stmt = snowflake.createStatement(run_cmd);
	var execute_run = run_stmt.execute();
    execute_run.next();
    
    var T1 = execute_run.getColumnValue(1);
    return T1;
    $$;