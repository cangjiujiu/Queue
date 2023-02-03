Class JHUTIL.Tasks.BackupCode Extends %SYS.Task.Definition
{

/// 需要导出的代码所在包名1112
Property PackageName As %String;

Method OnTask() As %Status
{
    //设置备份路径，并将包名当作备份文件名前缀
	set name=$replace(..PackageName,",","_")
	set path="/goodwill/jhip/hc/file/backup/"
    if $SYSTEM.Version.GetBuildOS()="Windows"{
	   set path="D:\jhip\hc\file\backup\" 
    }
    
    //进行代码备份，每天，每周一，周月初分别进行备份
	set date=$p($h,",")
	Set tSC=$system.OBJ.ExportPackage(..PackageName,path_name_"-day.xml")
	if $zd(date,10)=1 {
		Set tSC=$system.OBJ.ExportPackage(..PackageName,path_name_"-week.xml")
	}
	if +$e($zd(date,3),*-1,*)=1{
		Set tSC=$system.OBJ.ExportPackage(..PackageName,path_name_"-month.xml")
	}
	quit $$$OK
}

}

