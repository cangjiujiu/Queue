Class JHUTIL.Tasks.StopStudioSession Extends %SYS.Task.Definition
{

Method OnTask() As %Status
{
    set ERROR=0
	set ns=$namespace
	zn "%sys"
	Set sqlStr="call SYS.Process_CONTROLPANEL()"
	Set statement = ##class(%SQL.Statement).%New()
	Set qStatus = statement.%Prepare(sqlStr)
	if qStatus'=1 {w "error"}
	#dim rset As %SQL.StatementResult = statement.%Execute()
	while rset.%Next(){
		if ("CStudio.exe"=rset.%Get("EXE Name")){
			set PID = rset.%Get("Pid")
			If '##class(SYS.Process).%ExistsId(PID) {Continue}
			Set tPOBJ = ##class(SYS.Process).%OpenId(PID)
			If '$IsObject(tPOBJ){
				SET ERROR=ERROR+1 
				Continue 
			} 
			If tPOBJ.CanBeTerminated = 0 {
				SET ERROR=ERROR+1 
				Continue 
			}Else{
				Set tSC = tPOBJ.Terminate(1)
				If tSC '> 0 {
					SET ERROR=ERROR+1 
					Continue 
				}
			}
		}
	}
	kill statement,rset
	zn ns
	if ERROR>0{
		quit 0
	}else{
		quit 1
	}
}

}

