#!/bin/bash
# #!/data/data/com.termux/files/usr/bin/bash
# #!C:/Git/bin/bash.exe

# 使用説明：

# Title: Startup Julia or Python or Nodejs statistical server
# Author: 弘毅
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# Date: 歲在丙申
# Operating system: Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 arm64 aarch64

# 需要在：Android11-Termux0.118 系統的控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行;
# ~ $ chmod a+x /data/data/com.termux/files/home/StatisticalServer/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# ~ $ /data/data/com.termux/files/usr/bin/bash /data/data/com.termux/files/home/StatisticalServer/startServer.sh configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt executableFile=/data/data/com.termux/files/usr/bin/julia interpreterFile=-p,4,--project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/ scriptFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configInstructions=configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/

# 需要在：Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 系統的控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行;
# root@localhost:~# chmod a+x /home/StatisticalServer/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# root@localhost:~# /bin/bash /home/StatisticalServer/startServer.sh configFile=/home/StatisticalServer/config.txt executableFile=/bin/julia interpreterFile=-p,4,--project=/home/StatisticalServer/StatisticalServerJulia/ scriptFile=/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configInstructions=configFile=/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/

# 需要在 Windows 系統 cmd 控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行；並且需要事先已經在 Windows 系統安裝配置成功：C:/Git/bin/bash.exe 軟體;
# C:\> chmod a+x C:/StatisticalServer/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# C:\> C:/Git/bin/bash.exe C:/StatisticalServer/startServer.sh configFile=C:/StatisticalServer/config.txt executableFile=C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe interpreterFile=-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/ scriptFile=C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configInstructions=configFile=C:/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=C:/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/

clear

NoteVersion_1="Startup Julia or Python or Nodejs statistical server v20161211"
NoteVersion_2="Android11-Termux0.118 arm64 aarch64"
# NoteVersion_2="Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 arm64 aarch64"
# NoteVersion_2="Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30"
NoteVersion_3="283640621@qq.com"
NoteVersion_4="+8618604537694"
NoteVersion_5="弘毅"
NoteVersion_6="歲在丙申"

NoteHelp_1="--help -h --version -v"
NoteHelp_2="configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# NoteHelp_2="configFile=/home/StatisticalServer/config.txt"
# NoteHelp_2="configFile=C:/StatisticalServer/config.txt"
NoteHelp_3="executableFile=/data/data/com.termux/files/usr/bin/julia"
# NoteHelp_3="executableFile=/bin/julia"
# NoteHelp_3="executableFile=C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
NoteHelp_4="interpreterFile=-p,4,--project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/"
# NoteHelp_4="interpreterFile=-p,4,--project=/home/StatisticalServer/StatisticalServerJulia/"
# NoteHelp_4="interpreterFile=-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/"
NoteHelp_5="scriptFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
# NoteHelp_5="scriptFile=/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
# NoteHelp_5="scriptFile=C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
NoteHelp_6="configInstructions=configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=/data/data/com.termux/files/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# NoteHelp_6="configInstructions=configFile=/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/home/StatisticalServer/config.txt"
# NoteHelp_6="configInstructions=configFile=C:/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=C:/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt"
NoteHelp_7="isBlock=true"
NoteHelp_8="executableFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/Scripts/python"
# NoteHelp_8="executableFile=/home/StatisticalServer/StatisticalServerPython/Scripts/python"
# NoteHelp_8="executableFile=C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
NoteHelp_9="executableFile=/data/data/com.termux/files/usr/bin/python"
# NoteHelp_9="executableFile=/bin/python3"
# NoteHelp_9="executableFile=C:/StatisticalServer/Python/Python311/python.exe"
NoteHelp_10="scriptFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# NoteHelp_10="scriptFile=/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# NoteHelp_10="scriptFile=C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
NoteHelp_11="configInstructions=configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=/data/data/com.termux/files/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# NoteHelp_11="configInstructions=configFile=/home/StatisticalServer/StatisticalServerPython/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/home/StatisticalServer/config.txt"
# NoteHelp_11="configInstructions=configFile=C:/StatisticalServer/StatisticalServerPython/config.txt,interface_Function=http_Server,webPath=C:/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt"
NoteHelp_12="executableFile=/data/data/com.termux/files/usr/bin/node"
# NoteHelp_12="executableFile=/bin/node"
# NoteHelp_12="executableFile=C:/StatisticalServer/Nodejs/node.exe"
NoteHelp_13="scriptFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js"
# NoteHelp_13="scriptFile=/home/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js"
# NoteHelp_13="scriptFile=C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js"
NoteHelp_14="configInstructions=configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJavaScript/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=FALSE,Sys_sleep=0.2,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/,number_Worker_process=0,to_executable=/data/data/com.termux/files/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# NoteHelp_14="configInstructions=configFile=/home/StatisticalServer/StatisticalServerJavaScript/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=FALSE,Sys_sleep=0.2,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/,number_Worker_process=0,to_executable=/home/StatisticalServer/StatisticalServer.exe,to_script=configFile=/home/StatisticalServer/config.txt"
# NoteHelp_14="configInstructions=configFile=C:/StatisticalServer/StatisticalServerJavaScript/config.txt,interface_Function=http_Server,webPath=C:/StatisticalServer/html/,host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=FALSE,Sys_sleep=0.2,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,number_Worker_process=0,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt"

configFileName="config.txt"
configFile=""
# configFile="/data/data/com.termux/files/home/StatisticalServer/config.txt"
# configFile="/home/StatisticalServer/config.txt"
# configFile="C:/StatisticalServer/config.txt"

CalculationTool="Julia"

# 設置將傳入參數中的逗號字符(,)替換爲空格字符( );
search_string=','
replace_string=' '

executableFileName="StatisticalServerPython/Scripts/python"
# executableFileName="StatisticalServerPython/Scripts/python.exe"
# executableFileName="Julia/Julia-1.10.3/bin/julia"
# executableFileName="Julia/Julia-1.10.3/bin/julia.exe"
executableFile=""
# executableFile="/data/data/com.termux/files/usr/bin/python"
# executableFile="/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/Scripts/python"
# executableFile="/bin/python3"
# executableFile="/home/StatisticalServer/StatisticalServerPython/Scripts/python"
# executableFile="C:/StatisticalServer/Python/Python311/python.exe"
# executableFile="C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"
# executableFile="/usr/julia/julia-1.10.3/bin/julia"
# executableFile="C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"

interpreterFileName="StatisticalServerPython/"
# interpreterFileName="StatisticalServerJulia/"
interpreterFile=""
# interpreterFile="--project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/"
# interpreterFile="--project=/home/StatisticalServer/StatisticalServerPython/"
# interpreterFile="--project=C:/StatisticalServer/StatisticalServerPython/"
# interpreterFile="-p,4,--project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/"
# interpreterFile="-p,4,--project=home/StatisticalServer/StatisticalServerJulia/"
# interpreterFile="-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/"

scriptFileName="StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# scriptFileName="StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
scriptFile=""
# scriptFile="/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# scriptFile="/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# scriptFile="C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"
# scriptFile="/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
# scriptFile="/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
# scriptFile="C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"

configInstructions=""
# configInstructions="configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,Key=username:password,Is_multi_thread=False,number_Worker_process=0,is_Monitor_Concurrent=0,is_monitor=False,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/"
# configInstructions="configFile=/home/StatisticalServer/StatisticalServerPython/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,Key=username:password,Is_multi_thread=False,number_Worker_process=0,is_Monitor_Concurrent=0,is_monitor=False,time_sleep=0.02,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/"
# configInstructions="configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/data/data/com.termux/files/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/,output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/"
# configInstructions="configFile=/home/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=/home/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/StatisticalServer/Intermediary/,monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=/home/StatisticalServer/Intermediary/,output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/StatisticalServer/temp/"
# configInstructions="configFile=C:/StatisticalServer/StatisticalServerJulia/config.txt,interface_Function=http_Server,webPath=C:/StatisticalServer/html/,host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/"

shellCodeScript=""
# shellCodeScript="/data/data/com.termux/files/usr/bin/python /data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/config.txt,interface_Function=http_Server webPath=/data/data/com.termux/files/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/data/data/com.termux/files/home/StatisticalServer/StatisticalServer.exe to_script=configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# shellCodeScript="/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/Scripts/python /data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerPython/config.txt interface_Function=http_Server webPath=/data/data/com.termux/files/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/data/data/com.termux/files/home/StatisticalServer/StatisticalServer.exe to_script=configFile=/data/data/com.termux/files/home/StatisticalServer/config.txt"
# shellCodeScript="/bin/python3 /home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py configFile=/home/StatisticalServer/StatisticalServerPython/config.txt interface_Function=http_Server webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/home/StatisticalServer/StatisticalServer.exe to_script=configFile=/home/StatisticalServer/config.txt"
# shellCodeScript="/home/StatisticalServer/StatisticalServerPython/Scripts/python /home/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py configFile=/home/StatisticalServer/StatisticalServerPython/config.txt interface_Function=http_Server webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/home/StatisticalServer/StatisticalServer.exe to_script=configFile=/home/StatisticalServer/config.txt"
# shellCodeScript="/data/data/com.termux/files/usr/bin/julia --project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/ /data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=/data/data/com.termux/files/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/"
# shellCodeScript="/data/data/com.termux/files/usr/bin/julia -p 4 --project=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/ /data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=/data/data/com.termux/files/home/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=/data/data/com.termux/files/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ monitor_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/StatisticalServer/Intermediary/ output_file=/data/data/com.termux/files/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/StatisticalServer/temp/"
# shellCodeScript="/bin/julia --project=/home/StatisticalServer/StatisticalServerJulia/ /home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=/home/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/"
# shellCodeScript="/bin/julia -p 4 --project=/home/StatisticalServer/StatisticalServerJulia/ /home/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=/home/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/"
# shellCodeScript="C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=C:/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=C:/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/StatisticalServer/Intermediary/ monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=C:/StatisticalServer/Intermediary/ output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/StatisticalServer/temp/"
# shellCodeScript="C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configFile=C:/StatisticalServer/StatisticalServerJulia/config.txt interface_Function=http_Server webPath=C:/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/StatisticalServer/Intermediary/ monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=C:/StatisticalServer/Intermediary/ output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/StatisticalServer/temp/"


# 獲取當前工作空間;
work_directory="$(pwd)"
work_directory="$work_directory/"
# echo "Worker directory = $work_directory"
shell_directory="$(cd "$(dirname "$0")" && pwd)"
shell_directory="$shell_directory/"
# echo "Directory(.sh) = $shell_directory"
shell_file="$shell_directory$(basename "$0")"
# echo "File(.sh) = $shell_file"


# 變量賦預設值;
configFile="$shell_directory$configFileName"
# echo "configFile = $configFile"

# executableFile="$shell_directory$executableFileName"
# # echo "executableFile = $executableFile"

# scriptFile="$shell_directory$scriptFileName"
# # echo "scriptFile = $scriptFile"

# interpreterFile="--project=$shell_directory$interpreterFileName"
# # echo "interpreterFile = $interpreterFile"


# # 讀取控制臺命令列傳入的參數;
# echo $#
# echo "$@"
# echo "$0"
# echo "$1"
# Argument="$@"
# echo "$Argument"

# 讀取控制臺命令列傳入的參數：配置文檔（configFile）保存路徑值;
index=0
for indexArgument in "$@"
do
    index=$(expr $index + 1)
    # echo "Argument-$index: $indexArgument"

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若否（!）含有等號字符（'='），則如下;
    if ! [[ "$indexArgument" == *"="* ]]; then
        # echo "Unable to find equal sign(=) separator in the $index$: $indexArgument"
        # echo "控制臺命令列傳入的參數中不含等號字符（=）."
        # exit 0

        if [ "$indexArgument" = "--version" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            exit 0
        elif [ "$indexArgument" = "-v" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            exit 0
        elif [ "$indexArgument" = "--help" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            echo -e "\n"
            echo "$NoteHelp_1"
            echo "$NoteHelp_2"
            echo "$NoteHelp_3"
            echo "$NoteHelp_4"
            echo "$NoteHelp_5"
            echo "$NoteHelp_6"
            echo "$NoteHelp_7"
            echo "$NoteHelp_8"
            echo "$NoteHelp_9"
            echo "$NoteHelp_10"
            echo "$NoteHelp_11"
            echo "$NoteHelp_12"
            echo "$NoteHelp_13"
            echo "$NoteHelp_14"
            exit 0
        elif [ "$indexArgument" = "-h" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            echo -e "\n"
            echo "$NoteHelp_1"
            echo "$NoteHelp_2"
            echo "$NoteHelp_3"
            echo "$NoteHelp_4"
            echo "$NoteHelp_5"
            echo "$NoteHelp_6"
            echo "$NoteHelp_7"
            echo "$NoteHelp_8"
            echo "$NoteHelp_9"
            echo "$NoteHelp_10"
            echo "$NoteHelp_11"
            echo "$NoteHelp_12"
            echo "$NoteHelp_13"
            echo "$NoteHelp_14"
            exit 0
        elif [ "$indexArgument" = "isJulia" ]; then
            CalculationTool="Julia"
            # echo "CalculationTool = $CalculationTool"
            # exit 0
        elif [ "$indexArgument" = "isPython" ]; then
            CalculationTool="Python"
            # echo "CalculationTool = $CalculationTool"
            # exit 0
        else
            configFile="$indexArgument"
            # echo "configFile = $configFile"
            # exit 0
        fi
    fi

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
    if [[ "$indexArgument" == *"="* ]]; then

        # Argument_Key="$(echo $indexArgument | cut -f1 -d=)"
        Argument_Key="${indexArgument%%=*}"
        # echo "$Argument_Key"

        # Argument_Value="$(echo $indexArgument | cut -f2 -d=)"
        Argument_Value="${indexArgument#*=}"
        # echo "$Argument_Value"
        # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
        Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
        # echo "$Argument_Value"

        # if [ "$Argument_Key" = "configFile" ]; then
        #     configFile="$Argument_Value"
        # fi

        # # if [ "$Argument_Key" = "executableFile" ]; then
        # #     executableFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "interpreterFile" ]; then
        # #     interpreterFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "scriptFile" ]; then
        # #     scriptFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "configInstructions" ]; then
        # #     configInstructions="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "CalculationTool" ]; then
        # #     CalculationTool="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "shellCodeScript" ]; then
        # #     shellCodeScript="$Argument_Value"
        # # fi

        case $Argument_Key in
            configFile) configFile="$Argument_Value";;
            # executableFile) executableFile="$Argument_Value";;
            # interpreterFile) interpreterFile="$Argument_Value";;
            # scriptFile) scriptFile="$Argument_Value";;
            # configInstructions) configInstructions="$Argument_Value";;
            # CalculationTool) CalculationTool="$Argument_Value";;
            # shellCodeScript) shellCodeScript="$Argument_Value";;
            *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
        esac

    fi
done
# echo "configFile = $configFile"
# # echo "executableFile = $executableFile"
# # echo "interpreterFile = $interpreterFile"
# # echo "scriptFile = $scriptFile"
# # echo "configInstructions = $configInstructions"
# # echo "CalculationTool = $CalculationTool"
# # echo "shellCodeScript = $shellCodeScript"
Argument_Key=""
Argument_Value=""
index=0


# 讀取控制文檔（config.txt）傳入的參數;
# echo "configFile = $configFile"
if [ -z "$configFile" ]; then
    echo 'Error ( configFile = "" )'
elif ! [ -f "$configFile" ]; then
    echo "Config file ( $configFile ) unrecognized."
else
    echo "configFile = $configFile"
    index=0
    while read line; do
        index=$(expr $index + 1)
        # echo "$index: $line"

        # 判斷是否爲空列;
        if ! [ -z "$line" ]; then

            # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
            if [[ "$line" == *"="* ]]; then

                # Argument_Key="$(echo $line | cut -f1 -d=)"
                Argument_Key="${line%%=*}"
                # echo "$Argument_Key"

                # Argument_Value="$(echo $line | cut -f2 -d=)"
                Argument_Value="${line#*=}"
                # echo "$Argument_Value"
                # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
                Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
                # echo "$Argument_Value"

                # # if [ "$Argument_Key" = "configFile" ]; then
                # #     configFile="$Argument_Value"
                # # fi

                # if [ "$Argument_Key" = "executableFile" ]; then
                #     executableFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "interpreterFile" ]; then
                #     interpreterFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "scriptFile" ]; then
                #     scriptFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "configInstructions" ]; then
                #     configInstructions="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "CalculationTool" ]; then
                #     CalculationTool="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "shellCodeScript" ]; then
                #     shellCodeScript="$Argument_Value"
                # fi

                case $Argument_Key in
                    # configFile) configFile="$Argument_Value";;
                    executableFile) executableFile="$Argument_Value";;
                    interpreterFile) interpreterFile="$Argument_Value";;
                    scriptFile) scriptFile="$Argument_Value";;
                    configInstructions) configInstructions="$Argument_Value";;
                    CalculationTool) CalculationTool="$Argument_Value";;
                    shellCodeScript) shellCodeScript="$Argument_Value";;
                    *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
                esac

            fi
        fi
    done < $configFile
    # # echo "configFile = $configFile"
    # echo "executableFile = $executableFile"
    # echo "interpreterFile = $interpreterFile"
    # echo "scriptFile = $scriptFile"
    # echo "configInstructions = $configInstructions"
    # echo "CalculationTool = $CalculationTool"
    # echo "shellCodeScript = $shellCodeScript"
    Argument_Key=""
    Argument_Value=""
    index=0
fi


# # 讀取控制臺命令列傳入的參數;
# echo $#
# echo "$@"
# echo "$0"
# echo "$1"
# Argument="$@"
# echo "$Argument"

# 讀取控制臺命令列傳入的參數：executableFile、interpreterFile、scriptFile、configInstructions、CalculationTool、shellCodeScript
index=0
for indexArgument in "$@"
do
    index=$(expr $index + 1)
    # echo "Argument-$index: $indexArgument"

    # # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若否（!）含有等號字符（'='），則如下;
    # if ! [[ "$indexArgument" == *"="* ]]; then
    #     # echo "Unable to find equal sign(=) separator in the $index$: $indexArgument"
    #     # echo "控制臺命令列傳入的參數中不含等號字符（=）."
    #     # exit 0
    #     if [ "$indexArgument" = "isJulia" ]; then
    #         CalculationTool="Julia"
    #         # echo "CalculationTool = $CalculationTool"
    #         # exit 0
    #     elif [ "$indexArgument" = "isPython" ]; then
    #         CalculationTool="Python"
    #         # echo "CalculationTool = $CalculationTool"
    #         # exit 0
    #     elif [ "$indexArgument" = "--version" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         exit 0
    #     elif [ "$indexArgument" = "-v" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         exit 0
    #     elif [ "$indexArgument" = "--help" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         echo -e "\n"
    #         echo "$NoteHelp_1"
    #         echo "$NoteHelp_2"
    #         echo "$NoteHelp_3"
    #         echo "$NoteHelp_4"
    #         echo "$NoteHelp_5"
    #         echo "$NoteHelp_6"
    #         echo "$NoteHelp_7"
    #         echo "$NoteHelp_8"
    #         echo "$NoteHelp_9"
    #         echo "$NoteHelp_10"
    #         echo "$NoteHelp_11"
    #         echo "$NoteHelp_12"
    #         echo "$NoteHelp_13"
    #         echo "$NoteHelp_14"
    #         exit 0
    #     elif [ "$indexArgument" = "-h" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         echo -e "\n"
    #         echo "$NoteHelp_1"
    #         echo "$NoteHelp_2"
    #         echo "$NoteHelp_3"
    #         echo "$NoteHelp_4"
    #         echo "$NoteHelp_5"
    #         echo "$NoteHelp_6"
    #         echo "$NoteHelp_7"
    #         echo "$NoteHelp_8"
    #         echo "$NoteHelp_9"
    #         echo "$NoteHelp_10"
    #         echo "$NoteHelp_11"
    #         echo "$NoteHelp_12"
    #         echo "$NoteHelp_13"
    #         echo "$NoteHelp_14"
    #         exit 0
    #     else
    #         configFile="$indexArgument"
    #         # echo "configFile = $configFile"
    #         # exit 0
    #     fi
    # fi

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
    if [[ "$indexArgument" == *"="* ]]; then

        # Argument_Key="$(echo $indexArgument | cut -f1 -d=)"
        Argument_Key="${indexArgument%%=*}"
        # echo "$Argument_Key"

        # Argument_Value="$(echo $indexArgument | cut -f2 -d=)"
        Argument_Value="${indexArgument#*=}"
        # echo "$Argument_Value"
        # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
        Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
        # echo "$Argument_Value"

        # # if [ "$Argument_Key" = "configFile" ]; then
        # #     configFile="$Argument_Value"
        # # fi

        # if [ "$Argument_Key" = "executableFile" ]; then
        #     executableFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "interpreterFile" ]; then
        #     interpreterFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "scriptFile" ]; then
        #     scriptFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "configInstructions" ]; then
        #     configInstructions="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "CalculationTool" ]; then
        #     CalculationTool="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "shellCodeScript" ]; then
        #     shellCodeScript="$Argument_Value"
        # fi

        case $Argument_Key in
            # configFile) configFile="$Argument_Value";;
            executableFile) executableFile="$Argument_Value";;
            interpreterFile) interpreterFile="$Argument_Value";;
            scriptFile) scriptFile="$Argument_Value";;
            configInstructions) configInstructions="$Argument_Value";;
            CalculationTool) CalculationTool="$Argument_Value";;
            shellCodeScript) shellCodeScript="$Argument_Value";;
            *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
        esac

    fi

done
# # echo "configFile = $configFile"
# echo "executableFile = $executableFile"
# echo "interpreterFile = $interpreterFile"
# echo "scriptFile = $scriptFile"
# echo "configInstructions = $configInstructions"
# echo "CalculationTool = $CalculationTool"
# echo "shellCodeScript = $shellCodeScript"
Argument_Key=""
Argument_Value=""
index=0


# 拼接參數獲取 shell 啓動脚本;
# echo "executableFile = $executableFile"
if [ -z "$executableFile" ]; then
    echo "Error, startup executable file path is empty ( executableFile = )."
    # echo "Config file ( $configFile ) import argument: [ executableFile ] is empty."
    # exit 1
else

    # 修改檔權限爲：可執行權限;
    if ! [ -x "./$executableFile" ]; then
        # echo "Error, executableFile: [ $executableFile ] does not exist or is not executable."
        chmod a+x "$executableFile"
        # exit 1
    fi

    if [ -z "$scriptFile" ]; then
        if [ -z "$interpreterFile" ]; then
            shellCodeScript="$executableFile"
        else
            shellCodeScript="$executableFile $interpreterFile"
        fi
    else
        if [ -z "$interpreterFile" ]; then
            if [ -z "$configInstructions" ]; then
                shellCodeScript="$executableFile $scriptFile"
            else
                shellCodeScript="$executableFile $scriptFile $configInstructions"
            fi
        else
            if [ -z "$configInstructions" ]; then
                shellCodeScript="$executableFile $interpreterFile $scriptFile"
            else
                shellCodeScript="$executableFile $interpreterFile $scriptFile $configInstructions"
            fi
        fi
    fi
    # echo "shellCodeScript = $shellCodeScript"
fi


# 啓動服務器二進制可執行檔（.exe）;
# echo "shellCodeScript = $shellCodeScript"
if [ -z "$shellCodeScript" ]; then
    echo "Error, startup shell scrip is emptyt ( shellCodeScript = $shellCodeScript )."
else

    # # 修改檔權限爲：可執行權限;
    # if ! [ -x "./$executableFile" ]; then
    #     echo "Error, executableFile: [ $executableFile ] does not exist or is not executable."
    #     # chmod a+x "$executableFile"
    #     exit 1
    # fi

    # # Ubuntu 系統創建新的控制臺命令列，並進入指定目錄;
    # # gnome-terminal --window --working-directory="$work_directory"
    # gnome-terminal --window --working-directory="$shell_directory"
    # # Ubuntu 系統創建新的控制臺命令列窗口，並在當前目錄下，啓動二進制可執行檔（.exe）;
    # gnome-terminal --window --"$shellCodeScript"

    # 當前控制臺命令列，啓動二進制可執行檔（.exe）;
    # cd "$work_directory"
    # cd "$shell_directory"
    # clear
    $shellCodeScript

fi


# 設定運行完畢窗口不要自動關閉;
# # Read-Host -Prompt "按任意鍵關閉 PowerShell 窗口 ..."
# # echo "按任意鍵繼續 ..."
# echo "Enter any key to continue ..."
# read -n 1
# echo "exit window."

# 關閉控制臺命令列窗口;
exit 0
