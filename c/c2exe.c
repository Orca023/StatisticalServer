/**************************************************************************

// Title: C call executable(.exe) v20161211
// Explain: C startup julia statistical server
// Author: 弘毅
// E-mail: 283640621@qq.com
// Telephont number: +86 18604537694
// Date: 歲在丙申
// Compiler: gcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0
// Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
// Executable: Julia statistical server

// 使用説明：
// 編譯指令：
// root@localhost:~# C:\MinGW64\bin\gcc.exe C:/StatisticalServer/c/c2exe.c -o C:/StatisticalServer/StatisticalServer.exe
// 控制臺顯示中文字符指令;
// root@localhost:~# chcp 65001
// 運行指令：
// root@localhost:~# C:/StatisticalServer/StatisticalServer.exe configFile=C:/StatisticalServer/config.txt executableFile=C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe interpreterFile=-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/ scriptFile=C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/ isBlock=true

***************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <libgen.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/stat.h>

char *NoteVersion = "C call executable(.exe) v20161211\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\nC startup julia statistical server\nJulia statistical server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n";
char *NoteHelp = "C call executable(.exe) v20161211\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\nC startup julia statistical server\nJulia statistical server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n\n--help -h ? --version -v\n\nconfigFile=C:/StatisticalServer/config.txt\n\nisBlock=true\n\nexecutableFile=C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe\n\ninterpreterFile=-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/\n\nscriptFile=C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl\n\nconfigInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt\n\nexecutableFile=C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe\n\nexecutableFile=C:/StatisticalServer/Python/Python311/python.exe\n\nscriptFile=C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py\n\nconfigInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt\n\nexecutableFile=C:/StatisticalServer/Nodejs/node.exe\n\nscriptFile=C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js\n\nconfigInstructions=host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=FALSE,Sys_sleep=0.2,monitor_dir=C:/StatisticalServer/Intermediary/,monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt,output_dir=C:/StatisticalServer/Intermediary/,output_file=C:/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=C:/StatisticalServer/temp/,number_Worker_process=0,to_executable=C:/StatisticalServer/StatisticalServer.exe,to_script=configFile=C:/StatisticalServer/config.txt\n";

#define BUFFER_LEN 1024  // 定義緩衝區最多不得超過 1024 個字符;

// 控制臺傳參，直接使用 gcc 的：main() 函數參數，獲取從控制臺傳入的參數，注意 C 語言的 main() 函數的參數是兩個，第一個是參數的數量（參數數組的長度），第二個是參數的數組;
int main(int argc, char *argv[]) {

    // 判斷控制臺命令行是否有傳入參數，若有傳入參數，則繼續判斷是否爲：查詢信息指令;
    if (argc > 1) {
        // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
        // 使用函數：strncmp(argv[1], "--version", sizeof(argv[1])) == 0 判斷兩個字符串是否相等;
        if ((strncmp(argv[1], "--version", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-v", sizeof(argv[1])) == 0)) {
            printf(NoteVersion);
            return 0;  // 跳出函數，中止運行後續的代碼;
        }
        // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
        if ((strncmp(argv[1], "--help", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-h", sizeof(argv[1])) == 0) || (strncmp(argv[1], "?", sizeof(argv[1])) == 0)) {
            printf(NoteHelp);
            return 0;  // 跳出函數，中止運行後續的代碼;
        }
    }

    char *configFile = "";  // 配置文檔的保存路徑參數："C:/StatisticalServer/config.txt"

    char *isBlock = "";  // 子進程中的，控制臺命令行程式，運行時，是否阻塞主進程後續代碼的執行;
    // isBlock = "true";  // 初始預設值爲："true"，即：阻塞主進程後續代碼的執行;
    // printf("isBlock = %s\n", isBlock);

    char *interpreterFile = "";  // 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動時的，配置參數："-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/"
    // interpreterFile = "";  // "-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/";  // 初始預設值;
    // printf("interpreterFile = %s\n", interpreterFile);

    char *configInstructions = "";// 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動時，讀入的脚步文檔（.jl、.py、.js、.class）的，配置參數："host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks"
    // configInstructions = "host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks";  // 初始預設值;
    // printf("configInstructions = %s\n", configInstructions);

    char *executableFile = "";  // 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動路徑參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"、"C:/StatisticalServer/Python/Python311/python.exe"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"、"C:/StatisticalServer/Nodejs/node.exe"
    char *scriptFile = "";  // 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動時，讀入的脚步文檔（.jl、.py、.js、.class）的保存路徑參數："C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"、"C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"、"C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js"

    char *shellCodeScript = "";  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"


    // 1.1、解析預設的配置文檔（C:/StatisticalServer/config.txt）的保存路徑參數：configFile;
    
    // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
    // printf("The full path to the executable is :\n%s\n", argv[0]);
    // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);  // "C:/StatisticalServer/StatisticalServer.exe"
    // const int Argument0Length = strlen(argv[0]);  // 獲取傳入的第一個參數：argv[0]，即：當前運行的二進制可執行檔完整路徑，的字符串的長度;
    // printf("當前運行的二進制可執行檔完整路徑:\n%s\n長度爲：%d 個字符.\n", argv[0], Argument0Length);  // 24
    // 備份控制臺傳入參數;
    // char copyArgv0[Argument0Length + 1];
    // strncpy(copyArgv0, argv[0], sizeof(copyArgv0) - 1);  // 字符串數組傳值，淺拷貝;
    // copyArgv0[sizeof(copyArgv0) - 1] = '\0';
    // 備份控制臺傳入參數;
    char *copyArgv0 = strdup(argv[0]);  // 函數：strdup(argv[0]) 表示，指針傳值，深拷貝，需要 free(copyArgv0) 釋放内存;
    // printf("%s\n", argv[0]);  // "C:/StatisticalServer/StatisticalServer.exe"
    // printf("%s\n", copyArgv0);  // "C:/StatisticalServer/StatisticalServer.exe"
    // const int lengthCopyArgv0 = strlen(copyArgv0);
    // printf("%d\n", lengthCopyArgv0);  // 42

    char *defaultConfigFileDirectory = "";  // "C:/StatisticalServer"
    defaultConfigFileDirectory = dirname(copyArgv0);
    // printf("預設配置文檔的保存位置爲：\n%s\n", defaultConfigFileDirectory);  // "C:/StatisticalServer"
    const int lengthDefaultConfigFileDirectory = strlen(defaultConfigFileDirectory);
    // printf("%d\n", lengthDefaultConfigFileDirectory);  // 20

    char *configFileName = "config.txt";  // "C:/StatisticalServer/config.txt"
    const int lengthConfigFileName = strlen(configFileName);
    // printf("%d\n", lengthConfigFileName);  // 10

    char defaultConfigFilePath[lengthDefaultConfigFileDirectory + 1 + lengthConfigFileName + 1];  // "C:/StatisticalServer/config.txt"
    snprintf(defaultConfigFilePath, sizeof(defaultConfigFilePath), "%s%s%s", defaultConfigFileDirectory, "/", configFileName);
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/StatisticalServer/config.txt"
    const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31
    defaultConfigFilePath[lengthDefaultConfigFilePath] = '\0';
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/StatisticalServer/config.txt"
    // const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31

    configFile = strdup(defaultConfigFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // configFile = defaultConfigFilePath;
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/StatisticalServer/config.txt"
    // const int lengthDefaultConfigFilePath = strlen(configFile);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31


    // // 1.2、解析預設的配置參數值：executableFile、scriptFile、interpreterFile;

    // char *executableFileName = "Julia/Julia-1.9.3/bin/julia.exe";  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
    // const int lengthEexecutableFileName = strlen(executableFileName);
    // // printf("%d\n", lengthEexecutableFileName);  // 31

    // char defaultExecutableFilePath[lengthDefaultConfigFileDirectory + 1 + lengthEexecutableFileName + 1];  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
    // snprintf(defaultExecutableFilePath, sizeof(defaultExecutableFilePath), "%s%s%s", defaultConfigFileDirectory, "/", executableFileName);
    // // printf("預設的解釋器二進制可執行檔的啓動路徑爲：\n%s\n", defaultExecutableFilePath);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
    // const int lengthDefaultExecutableFilePath = strlen(defaultExecutableFilePath);
    // // printf("%d\n", lengthDefaultExecutableFilePath);  // 52
    // defaultExecutableFilePath[lengthDefaultExecutableFilePath] = '\0';
    // // printf("預設的解釋器二進制可執行檔的啓動路徑爲：\n%s\n", defaultExecutableFilePath);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
    // // const int lengthDefaultExecutableFilePath = strlen(defaultExecutableFilePath);
    // // printf("%d\n", lengthDefaultExecutableFilePath);  // 52

    // executableFile = strdup(defaultExecutableFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // // executableFile = defaultExecutableFilePath;
    // // printf("預設的解釋器二進制可執行檔（julia.exe）的啓動路徑爲：\n%s\n", executableFile);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
    // // const int lengthDefaultExecutableFilePath = strlen(executableFile);
    // // printf("%d\n", lengthDefaultExecutableFilePath);  // 52

    // char *scriptFileName = "StatisticalServerJulia/src/StatisticalAlgorithmServer.jl";  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
    // const int lengthScriptFileName = strlen(scriptFileName);
    // // printf("%d\n", lengthScriptFileName);  // 56

    // char defaultScriptFilePath[lengthDefaultConfigFileDirectory + 1 + lengthScriptFileName + 1];  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
    // snprintf(defaultScriptFilePath, sizeof(defaultScriptFilePath), "%s%s%s", defaultConfigFileDirectory, "/", scriptFileName);
    // // printf("預設的解釋器執行的脚本文檔的保存路徑爲：\n%s\n", defaultScriptFilePath);  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
    // const int lengthDefaultScriptFilePath = strlen(defaultScriptFilePath);
    // // printf("%d\n", lengthDefaultScriptFilePath);  // 77
    // defaultScriptFilePath[lengthDefaultScriptFilePath] = '\0';
    // // printf("預設的解釋器執行的脚本文檔的保存路徑爲：\n%s\n", defaultScriptFilePath);  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
    // // const int lengthDefaultScriptFilePath = strlen(defaultScriptFilePath);
    // // printf("%d\n", lengthDefaultScriptFilePath);  // 77

    // scriptFile = strdup(defaultScriptFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // // scriptFile = defaultScriptFilePath;
    // // printf("預設的解釋器執行的脚本文檔（StatisticalAlgorithmServer.jl）的保存路徑爲：\n%s\n", scriptFile);  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
    // // const int lengthDefaultScriptFilePath = strlen(scriptFile);
    // // printf("%d\n", lengthDefaultScriptFilePath);  // 77

    // char *interpreterFileName = "StatisticalServerJulia/";  // "-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/"
    // const int lengthInterpreterFileName = strlen(interpreterFileName);
    // // printf("%d\n", lengthInterpreterFileName);  // 23

    // char defaultInterpreterFilePath[10 + lengthDefaultConfigFileDirectory + 1 + lengthInterpreterFileName + 1];  // "--project=C:/StatisticalServer/StatisticalServerJulia/"
    // snprintf(defaultInterpreterFilePath, sizeof(defaultInterpreterFilePath), "%s%s%s%s", "--project=", defaultConfigFileDirectory, "/", interpreterFileName);
    // // printf("預設的解釋器啓動時傳入的參數爲：\n%s\n", defaultInterpreterFilePath);  // "--project=C:/StatisticalServer/StatisticalServerJulia/"
    // const int lengthDefaultInterpreterFilePath = strlen(defaultInterpreterFilePath);
    // // printf("%d\n", lengthDefaultInterpreterFilePath);  // 54
    // defaultInterpreterFilePath[lengthDefaultInterpreterFilePath] = '\0';
    // // printf("預設的解釋器啓動時傳入的參數爲：\n%s\n", defaultInterpreterFilePath);  // "--project=C:/StatisticalServer/StatisticalServerJulia/"
    // // const int lengthDefaultInterpreterFilePath = strlen(defaultInterpreterFilePath);
    // // printf("%d\n", lengthDefaultInterpreterFilePath);  // 54

    // interpreterFile = strdup(defaultInterpreterFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // // interpreterFile = defaultInterpreterFilePath;
    // // printf("預設的解釋器啓動時傳入的參數爲：\n%s\n", interpreterFile);  // "--project=C:/StatisticalServer/StatisticalServerJulia/"
    // // const int lengthDefaultInterpreterFilePath = strlen(interpreterFile);
    // // printf("%d\n", lengthDefaultInterpreterFilePath);  // 54


    free(copyArgv0);
    defaultConfigFileDirectory = NULL;
    configFileName = NULL;
    // executableFileName = NULL;
    // scriptFileName = NULL;
    // interpreterFileName = NULL;


    // 2、讀取控制臺傳入的配置文檔（C:/StatisticalServer/config.txt）的保存路徑參數：configFile;
    // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
    // printf("The full path to the executable is :\n%s\n", argv[0]);
    // printf("Input %d arguments from the console.\n", argc);
    // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);
    // printf("控制臺共傳入 %d 個參數.\n", argc);
    // 獲取控制臺傳入的配置文檔：configFile 的完整路徑;
    const char *Delimiter = "=";
    for(int i = 1; i < argc; i++) {
        // printf("參數 %d: %s\n", i, argv[i]);

        // 獲取傳入參數字符串的長度;
        // const int ArgumentLength = strlen(argv[i]);
        // const int ArgumentLength = 0;
        // while (argv[i][ArgumentLength] != '\0') {
        //     ArgumentLength = ArgumentLength + 1;
        // }
        // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, argv[i], ArgumentLength);

        // 備份控制臺傳入參數;
        // char copyArgvI[ArgumentLength + 1];
        // strncpy(copyArgvI, argv[i], sizeof(copyArgvI));  // 字符串數組傳值，淺拷貝;
        // copyArgvI[sizeof(copyArgvI)] = '\0';

        // 備份控制臺傳入參數;
        char *copyArgvI = strdup(argv[i]);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
        // printf("%s\n", argv[i]);
        // printf("%s\n", copyArgvI);
        const int ArgumentLength = strlen(copyArgvI);
        // printf("%d\n", ArgumentLength);


        // // 使用：strstr() 函數檢查字符串：haystack 中是否包含字符串：needle，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
        // const char *haystack = "Hello World";
        // const char *needle = "World";
        // char *result = strstr(haystack, needle);
        // if (result != NULL) {
        //     printf("字符串：'%s' 中包含子字符串：'%s' , 位置在：'%s'\n", haystack, needle, result);
        // } else {
        //     printf("字符串：'%s' 中不包含子字符串：'%s'\n", haystack, needle);
        // }


        // // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
        // // 使用函數：strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0 判斷兩個字符串是否相等;
        // if ((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0)) {
        //     printf(NoteVersion);
        // }
        // // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
        // if ((strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0)) {
        //     printf(NoteHelp);
        // }

        // 若控制臺命令列傳入參數非："--version" 或 "-v" 或 "--help" 或 "-h" 或 "?" 時，則執行如下解析字符串參數;
        if (!((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0))) {

            char *ArgumentKey = "";
            char *ArgumentValue = "";
            char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
            // const char *Delimiter = "=";
            char *DelimiterIndex = "";

            // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
            // DelimiterIndex = strstr(argv[i], Delimiter);
            DelimiterIndex = strstr(copyArgvI, Delimiter);
            // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
            // printf(Delimiter);
            // printf(argv[i]);
            // printf(DelimiterIndex);
            if (DelimiterIndex != NULL) {
                // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

                // 使用 strtok_r() 函數分割字符串;
                // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
                // while(ArgumentKey != NULL) {
                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
                //     ArgumentKey = strtok_r(NULL, Delimiter);
                // }
                // printf("控制臺傳入參數 %d: 字符串：'%s' 的名稱爲：'%s'\n", i, argv[i], ArgumentKey);
                const int ArgumentKeyLength = strlen(ArgumentKey);
                // printf("%d\n", ArgumentKeyLength);
                ArgumentValue = saveArgumentValue;
                // printf("控制臺傳入參數 %d: 字符串：'%s' 的值爲：'%s'\n", i, argv[i], ArgumentValue);
                const int ArgumentValueLength = strlen(ArgumentValue);
                // printf("%d\n", ArgumentValueLength);

                // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
                // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
                // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
                // printf("參數 %d: %s\n", i, buffer);

                // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
                if (ArgumentKey != NULL) {

                    // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
                    if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                        // const int ArgumentValueLength = strlen(ArgumentValue);
                        // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                        // for(int g = 0; g < ArgumentValueLength; g++) {
                        //     configFile[g] = ArgumentValue[g];
                        // }
                        // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                        // char configFile[ArgumentValueLength + 1];
                        // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                        // configFile[sizeof(configFile) - 1] = '\0';

                        configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
                        // printf("%s\n", configFile);
                    }

                    // if (strncmp(ArgumentKey, "executableFile", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                    //     // const int ArgumentValueLength = strlen(ArgumentValue);
                    //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                    //     // for(int g = 0; g < ArgumentValueLength; g++) {
                    //     //     executableFile[g] = ArgumentValue[g];
                    //     // }
                    //     // executableFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                    //     // char executableFile[ArgumentValueLength + 1];
                    //     // strncpy(executableFile, ArgumentValue, sizeof(executableFile) - 1);  // 字符串數組傳值，淺拷貝;
                    //     // executableFile[sizeof(executableFile) - 1] = '\0';

                    //     executableFile = strdup(ArgumentValue);
                    //     // printf("%s\n", executableFile);
                    // }

                    // if (strncmp(ArgumentKey, "interpreterFile", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                    //     interpreterFile = strdup(ArgumentValue);
                    //     // printf("%s\n", interpreterFile);

                    //     // const int ArgumentValueLength = strlen(ArgumentValue);
                    //     // const int ArgumentValueLength = strlen(interpreterFile);
                    //     // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                    //     for (int j = 0; j < ArgumentValueLength; j++) {
                    //         // printf("%c\n", *interpreterFile);
                    //         // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                    //         if (*interpreterFile == ',') {
                    //             *interpreterFile = ' ';
                    //         }
                    //         interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                    //     }
                    //     // 將字符串指針，重新指向字符串的首地址;
                    //     interpreterFile = interpreterFile - ArgumentValueLength;
                    //     // printf("%s\n", interpreterFile);

                    //     // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                    //     // while (*interpreterFile != '\0') {
                    //     //     // printf("%c\n", *interpreterFile);
                    //     //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                    //     //     if (*interpreterFile == ',') {
                    //     //         *interpreterFile = ' ';
                    //     //     }
                    //     //     interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                    //     // }
                    //     // // 將字符串指針，重新指向字符串的首地址;
                    //     // interpreterFile = interpreterFile - ArgumentValueLength;
                    //     // printf("%s\n", interpreterFile);
                    // }

                    // if (strncmp(ArgumentKey, "scriptFile", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                    //     scriptFile = strdup(ArgumentValue);
                    //     // printf("%s\n", scriptFile);
                    // }

                    // if (strncmp(ArgumentKey, "configInstructions", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                    //     configInstructions = strdup(ArgumentValue);
                    //     // printf("%s\n", configInstructions);

                    //     // const int ArgumentValueLength = strlen(ArgumentValue);
                    //     // const int ArgumentValueLength = strlen(configInstructions);
                    //     // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                    //     for (int j = 0; j < ArgumentValueLength; j++) {
                    //         // printf("%c\n", *configInstructions);
                    //         // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                    //         if (*configInstructions == ',') {
                    //             *configInstructions = ' ';
                    //         }
                    //         configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                    //     }
                    //     // 將字符串指針，重新指向字符串的首地址;
                    //     configInstructions = configInstructions - ArgumentValueLength;
                    //     // printf("%s\n", configInstructions);

                    //     // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                    //     // while (*configInstructions != '\0') {
                    //     //     // printf("%c\n", *configInstructions);
                    //     //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                    //     //     if (*configInstructions == ',') {
                    //     //         *configInstructions = ' ';
                    //     //     }
                    //     //     configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                    //     // }
                    //     // // 將字符串指針，重新指向字符串的首地址;
                    //     // configInstructions = configInstructions - ArgumentValueLength;
                    //     // printf("%s\n", configInstructions);
                    // }

                    // if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                    //     isBlock = strdup(ArgumentValue);
                    //     // printf("%s\n", isBlock);
                    // }

                } else {

                    // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
                    configFile = strdup(ArgumentValue);

                    // const int ArgumentValueLength = strlen(ArgumentValue);
                    // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                    // for(int g = 0; g < ArgumentValueLength; g++) {
                    //     configFile[g] = ArgumentValue[g];
                    // }
                    // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                    // char configFile[ArgumentValueLength + 1];
                    // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                    // configFile[sizeof(configFile) - 1] = '\0';

                }

            } else {

                // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
                configFile = strdup(ArgumentValue);

                // const int ArgumentValueLength = strlen(ArgumentValue);
                // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                // for(int g = 0; g < ArgumentValueLength; g++) {
                //     configFile[g] = ArgumentValue[g];
                // }
                // configFile[ArgumentValueLength] = '\0'; // 字符串末尾添加結束標記;

                // char configFile[ArgumentValueLength + 1];
                // strncpy(configFile, ArgumentValue, sizeof(configFile));  // 字符串數組傳值，淺拷貝;
                // configFile[sizeof(configFile)] = '\0';

            }
        }

        free(copyArgvI);
    }
    // printf("控制臺傳入的配置文檔（config.txt）完整路徑爲：\n%s\n", configFile);


    // 3、讀取配置文檔（C:/StatisticalServer/config.txt）中記錄的參數：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
    // printf("配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/StatisticalServer/config.txt";
    // 讀取配置文檔：configFile 中的參數;
    if (strlen(configFile) > 0) {

        FILE *file = fopen(configFile, "rt");  // rt、rb、wt、wb、a、r+、w+、a+;

        if (file == NULL) {

            // printf("無法打開配置文檔：\nconfigFile = %s\n", configFile);
            // // return 1;
        }

        if (file != NULL) {
            // printf("正在使用配置文檔：\nconfigFile = %s\n", configFile);  // "C:/StatisticalServer/config.txt";
            printf("configFile = %s\n", configFile);  // "C:/StatisticalServer/config.txt";

            // // 使用：fread(buffer, size, 1, file) 函數，一次讀入文檔中的全部内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
            // fseek(file, 0, SEEK_END);  // 定位文檔指針到文檔末尾;
            // long size = ftell(file);  // 計算文檔所包含的字符個數長度;
            // fseek(file, 0, SEEK_SET);  // 將文檔指針重新移動到文檔的開頭;
            // char *buffer = (char *)malloc(size + 1);  // 動態内存分配，按照上一部識別的文檔大小，申請内存緩衝區存儲文檔内容;
            // fread(buffer, size, 1, file);  // 讀入文檔中的全部内容到内存緩衝區（buffer）;
            // buffer[size] = '\0';  // 在内存緩衝區（buffer）儲存的文檔内容的末尾添加字符串結束字符（'\0'）;
            // printf("%s\n", buffer);
            // fclose(file);  // 關閉文檔;
            // free(buffer);  // 釋放内存緩衝區（buffer）;

            // // 使用：Character = fgetc(file) 函數，逐字符讀入文檔中的内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
            // int Character;
            // int flag;
            // flag = 1;
            // while (flag) {
            //     // 逐字符讀入文檔中的内容;
            //     Character = fgetc(file);  // 從文檔中讀取一個字符;
            //     // EOF == -1，判斷指針是否已經後移到文檔末尾;
            //     if (c == EOF) {
            //         flag = 0;
            //         break;  // 跳出 while(){} 循環;
            //     }
            //     printf("%c", Character);
            // }
            // fclose(file);  // 關閉文檔;

            // 使用：fgets(buffer, sizeof(buffer), file) 函數，逐個橫向列（row）讀入文檔中的内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
            char buffer[BUFFER_LEN];  // BUFFER_LEN = 1024 // 代碼首部自定義的常量：BUFFER_LEN = 1024，靜態申請内存緩衝區（buffer），存儲文檔每一個橫向列（row）中的内容，要求配置文檔：config.txt 中每一個橫向列（row）最多不得超過 1024 個字符;
            while (fgets(buffer, sizeof(buffer), file) != NULL) {
                // printf("%s\n", buffer);

                // 獲取傳入參數字符串的長度;
                // const int ArgumentLength = strlen(buffer);
                // const int ArgumentLength = 0;
                // while (buffer[ArgumentLength] != '\0') {
                //     ArgumentLength = ArgumentLength + 1;
                // }
                // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, buffer, ArgumentLength);

                // 備份控制臺傳入參數;
                // char copyArgvI[ArgumentLength + 1];
                // strncpy(copyArgvI, buffer, sizeof(copyArgvI) - 1);  // 字符串數組傳值，淺拷貝;
                // copyArgvI[sizeof(copyArgvI) - 1] = '\0';

                // 備份控制臺傳入參數;
                char *copyArgvI = buffer;
                // copyArgvI = strdup(buffer);  // 函數：strdup(buffer) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
                // printf("%s\n", buffer);
                // printf("%s\n", copyArgvI);
                const int ArgumentLength = strlen(copyArgvI);
                // printf("%d\n", ArgumentLength);
                // if (ArgumentLength > 0 && *copyArgvI != '\n') {
                if (ArgumentLength > 0) {

                    // // 使用：for(){} 循環，遍歷字符串，查找注釋符號井號字符（'#'），並將之替換爲字符串結束標志符號（'\0'），即從注釋符號井號（#）處截斷字符串;
                    // printf("%s\n", copyArgvI);
                    // const int ArgumentLength = strlen(copyArgvI);
                    // printf("%d\n", strlen(copyArgvI));
                    // for (int i = 0; i < ArgumentLength; i++) {
                    //     printf("%c\n", *copyArgvI);
                    //     // 判斷當前指向的字符，是否爲注釋符號井號字符（'#'），若是井號字符（'#'），則將之替換爲字符串結束標志符號（'\0'），若非井號字符（'#'）則保持不變;
                    //     if (*copyArgvI == '#') {
                    //         *copyArgvI = '\0';
                    //     }
                    //     copyArgvI++;  // 每輪循環後，自動向後偏移一位指向;
                    // }
                    // // 將字符串指針，重新指向字符串的首地址;
                    // copyArgvI = copyArgvI - ArgumentLength;
                    // printf("%s\n", copyArgvI);
                    // const int ArgumentLength = strlen(copyArgvI);
                    // printf("%d\n", strlen(copyArgvI));

                    // 刪除配置文檔（C:/StatisticalServer/config.txt）中，每個橫向列（row）字符串末尾可能存在的換行符回車符號（Enter）：'\n'，代之以字符串結束標志符號：'\0'，字符串長度會縮短 1 位;
                    // printf("%c ~ %c ~ %c\n", *copyArgvI, *(copyArgvI + ArgumentLength - 2), *(copyArgvI + ArgumentLength));  // *copyArgvI 爲字符串的首字符，*(copyArgvI + ArgumentLength - 2) 爲字符串的尾字符，*(copyArgvI + ArgumentLength - 1) 爲字符串末端的換行符回車符號（Enter）== '\n'，*(copyArgvI + ArgumentLength) 爲字符串末端的結束標志符號 == '\0' ;
                    // printf("%c\n", (copyArgvI + ArgumentLength - 1));
                    if (*(copyArgvI + ArgumentLength - 1) == '\n') {
                        *(copyArgvI + ArgumentLength - 1) = '\0';
                    } else {
                        *(copyArgvI + ArgumentLength) = '\0';
                    }
                    // printf("%s\n", copyArgvI);
                    const int ArgumentLength = strlen(copyArgvI);
                    // printf("%d\n", ArgumentLength);

                    // // 使用：strstr() 函數檢查字符串：haystack 中是否包含字符串：needle，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
                    // const char *haystack = "Hello World";
                    // const char *needle = "World";
                    // char *result = strstr(haystack, needle);
                    // if (result != NULL) {
                    //     printf("字符串：'%s' 中包含子字符串：'%s' , 位置在：'%s'\n", haystack, needle, result);
                    // } else {
                    //     printf("字符串：'%s' 中不包含子字符串：'%s'\n", haystack, needle);
                    // }

                    // 提取配置文檔（C:/StatisticalServer/config.txt）中，每個橫向列（row）字符串中，指定的參數值：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
                    if (ArgumentLength > 0) {
                        // printf("%s\n", copyArgvI);

                        // 判斷當前橫向列（row）字符串的參數，是否被井號（#）注釋掉;
                        if (*copyArgvI != '#') {
                            // printf("%s\n", copyArgvI);

                            // // 使用：for(){} 循環，遍歷字符串，查找注釋符號井號字符（'#'），並將之替換爲字符串結束標志符號（'\0'），即從注釋符號井號（#）處截斷字符串;
                            // printf("%s\n", copyArgvI);
                            // const int ArgumentLength = strlen(copyArgvI);
                            // printf("%d\n", strlen(copyArgvI));
                            // for (int i = 0; i < ArgumentLength; i++) {
                            //     printf("%c\n", *copyArgvI);
                            //     // 判斷當前指向的字符，是否爲注釋符號井號字符（'#'），若是井號字符（'#'），則將之替換爲字符串結束標志符號（'\0'），若非井號字符（'#'）則保持不變;
                            //     if (*copyArgvI == '#') {
                            //         *copyArgvI = '\0';
                            //     }
                            //     copyArgvI++;  // 每輪循環後，自動向後偏移一位指向;
                            // }
                            // // 將字符串指針，重新指向字符串的首地址;
                            // copyArgvI = copyArgvI - ArgumentLength;
                            // printf("%s\n", copyArgvI);
                            // const int ArgumentLength = strlen(copyArgvI);
                            // printf("%d\n", strlen(copyArgvI));

                            char *ArgumentKey = "";
                            char *ArgumentValue = "";
                            char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
                            // const char *Delimiter = "=";
                            char *DelimiterIndex = "";

                            // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
                            // DelimiterIndex = strstr(argv[i], Delimiter);
                            DelimiterIndex = strstr(copyArgvI, Delimiter);
                            // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
                            // printf(Delimiter);
                            // printf(argv[i]);
                            // printf(DelimiterIndex);
                            if (DelimiterIndex != NULL) {
                                // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

                                // 使用 strtok_r() 函數分割字符串;
                                // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                                ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                                // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
                                // while(ArgumentKey != NULL) {
                                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                                //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
                                //     ArgumentKey = strtok_r(NULL, Delimiter);
                                // }
                                // printf("控制臺傳入參數字符串的名稱爲：%s\n", ArgumentKey);
                                const int ArgumentKeyLength = strlen(ArgumentKey);
                                // printf("%d\n", ArgumentKeyLength);
                                ArgumentValue = saveArgumentValue;
                                // printf("控制臺傳入參數字符串的值爲：%s\n", ArgumentValue);
                                const int ArgumentValueLength = strlen(ArgumentValue);
                                // printf("%d\n", ArgumentValueLength);

                                // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
                                // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
                                // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
                                // printf("參數 %d: %s\n", i, buffer);

                                // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
                                if (ArgumentKey != NULL) {

                                    // // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
                                    // if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
                                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                                    //     // const int ArgumentValueLength = strlen(ArgumentValue);
                                    //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                                    //     // for(int g = 0; g < ArgumentValueLength; g++) {
                                    //     //     configFile[g] = ArgumentValue[g];
                                    //     // }
                                    //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                                    //     // char configFile[ArgumentValueLength + 1];
                                    //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                                    //     // configFile[sizeof(configFile) - 1] = '\0';

                                    //     configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
                                    //     // printf("%s\n", configFile);
                                    // }

                                    if (strncmp(ArgumentKey, "executableFile", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                                        // const int ArgumentValueLength = strlen(ArgumentValue);
                                        // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                                        // for(int g = 0; g < ArgumentValueLength; g++) {
                                        //     executableFile[g] = ArgumentValue[g];
                                        // }
                                        // executableFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                                        // char executableFile[ArgumentValueLength + 1];
                                        // strncpy(executableFile, ArgumentValue, sizeof(executableFile) - 1);  // 字符串數組傳值，淺拷貝;
                                        // executableFile[sizeof(executableFile) - 1] = '\0';

                                        executableFile = strdup(ArgumentValue);
                                        // printf("%s\n", executableFile);
                                    }

                                    if (strncmp(ArgumentKey, "interpreterFile", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        interpreterFile = strdup(ArgumentValue);
                                        // printf("%s\n", interpreterFile);

                                        // const int ArgumentValueLength = strlen(ArgumentValue);
                                        // const int ArgumentValueLength = strlen(interpreterFile);
                                        // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                                        for (int j = 0; j < ArgumentValueLength; j++) {
                                            // printf("%c\n", *interpreterFile);
                                            // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                                            if (*interpreterFile == ',') {
                                                *interpreterFile = ' ';
                                            }
                                            interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                                        }
                                        // 將字符串指針，重新指向字符串的首地址;
                                        interpreterFile = interpreterFile - ArgumentValueLength;
                                        // printf("%s\n", interpreterFile);

                                        // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                                        // while (*interpreterFile != '\0') {
                                        //     // printf("%c\n", *interpreterFile);
                                        //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                                        //     if (*interpreterFile == ',') {
                                        //         *interpreterFile = ' ';
                                        //     }
                                        //     interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                                        // }
                                        // // 將字符串指針，重新指向字符串的首地址;
                                        // interpreterFile = interpreterFile - ArgumentValueLength;
                                        // printf("%s\n", interpreterFile);
                                    }

                                    if (strncmp(ArgumentKey, "scriptFile", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        scriptFile = strdup(ArgumentValue);
                                        // printf("%s\n", scriptFile);
                                    }

                                    if (strncmp(ArgumentKey, "configInstructions", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        configInstructions = strdup(ArgumentValue);
                                        // printf("%s\n", configInstructions);

                                        // const int ArgumentValueLength = strlen(ArgumentValue);
                                        // const int ArgumentValueLength = strlen(configInstructions);
                                        // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                                        for (int j = 0; j < ArgumentValueLength; j++) {
                                            // printf("%c\n", *configInstructions);
                                            // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                                            if (*configInstructions == ',') {
                                                *configInstructions = ' ';
                                            }
                                            configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                                        }
                                        // 將字符串指針，重新指向字符串的首地址;
                                        configInstructions = configInstructions - ArgumentValueLength;
                                        // printf("%s\n", configInstructions);

                                        // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                                        // while (*configInstructions != '\0') {
                                        //     // printf("%c\n", *configInstructions);
                                        //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                                        //     if (*configInstructions == ',') {
                                        //         *configInstructions = ' ';
                                        //     }
                                        //     configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                                        // }
                                        // // 將字符串指針，重新指向字符串的首地址;
                                        // configInstructions = configInstructions - ArgumentValueLength;
                                        // printf("%s\n", configInstructions);
                                    }

                                    if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        isBlock = strdup(ArgumentValue);
                                        // printf("%s\n", isBlock);
                                    }

                                // } else {

                                //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
                                //     configFile = strdup(ArgumentValue);

                                //     // const int ArgumentValueLength = strlen(ArgumentValue);
                                //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                                //     // for(int g = 0; g < ArgumentValueLength; g++) {
                                //     //     configFile[g] = ArgumentValue[g];
                                //     // }
                                //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                                //     // char configFile[ArgumentValueLength + 1];
                                //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                                //     // configFile[sizeof(configFile) - 1] = '\0';

                                }

                            // } else {

                            //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
                            //     configFile = strdup(ArgumentValue);

                            //     // const int ArgumentValueLength = strlen(ArgumentValue);
                            //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                            //     // for(int g = 0; g < ArgumentValueLength; g++) {
                            //     //     configFile[g] = ArgumentValue[g];
                            //     // }
                            //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                            //     // char configFile[ArgumentValueLength + 1];
                            //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                            //     // configFile[sizeof(configFile) - 1] = '\0';

                            }
                        }
                    }
                }
                copyArgvI = NULL;  // 清空指針;
                memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
            }

            fclose(file);  // 關閉文檔;
        }

    } else {

        // printf("配置文檔的保存路徑參數爲空：\nconfigFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/StatisticalServer/config.txt"
        // // printf("configFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/StatisticalServer/config.txt"
        // // return 1;
    }


    // 4、讀取控制臺傳入的其他參數：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
    // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
    // printf("The full path to the executable is :\n%s\n", argv[0]);
    // printf("Input %d arguments from the console.\n", argc);
    // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);
    // printf("控制臺共傳入 %d 個參數.\n", argc);
    // 獲取控制臺傳入的配置文檔：configFile 的完整路徑;
    // const char *Delimiter = "=";
    for(int i = 1; i < argc; i++) {
        // printf("參數 %d: %s\n", i, argv[i]);

        // 獲取傳入參數字符串的長度;
        // const int ArgumentLength = strlen(argv[i]);
        // const int ArgumentLength = 0;
        // while (argv[i][ArgumentLength] != '\0') {
        //     ArgumentLength = ArgumentLength + 1;
        // }
        // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, argv[i], ArgumentLength);

        // 備份控制臺傳入參數;
        // char copyArgvI[ArgumentLength + 1];
        // strncpy(copyArgvI, argv[i], sizeof(copyArgvI) - 1);  // 字符串數組傳值，淺拷貝;
        // copyArgvI[sizeof(copyArgvI) - 1] = '\0';

        // 備份控制臺傳入參數;
        char *copyArgvI = strdup(argv[i]);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
        // printf("%s\n", argv[i]);
        // printf("%s\n", copyArgvI);
        const int ArgumentLength = strlen(copyArgvI);
        // printf("%d\n", ArgumentLength);


        // // 使用：strstr() 函數檢查字符串：haystack 中是否包含字符串：needle，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
        // const char *haystack = "Hello World";
        // const char *needle = "World";
        // char *result = strstr(haystack, needle);
        // if (result != NULL) {
        //     printf("字符串：'%s' 中包含子字符串：'%s' , 位置在：'%s'\n", haystack, needle, result);
        // } else {
        //     printf("字符串：'%s' 中不包含子字符串：'%s'\n", haystack, needle);
        // }


        // // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
        // // 使用函數：strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0 判斷兩個字符串是否相等;
        // if ((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0)) {
        //     printf(NoteVersion);
        // }
        // // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
        // if ((strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0)) {
        //     printf(NoteHelp);
        // }

        // 若控制臺命令列傳入參數非："--version" 或 "-v" 或 "--help" 或 "-h" 或 "?" 時，則執行如下解析字符串參數;
        if (!((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0))) {

            char *ArgumentKey = "";
            char *ArgumentValue = "";
            char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
            // const char *Delimiter = "=";
            char *DelimiterIndex = "";

            // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
            // DelimiterIndex = strstr(argv[i], Delimiter);
            DelimiterIndex = strstr(copyArgvI, Delimiter);
            // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
            // printf(Delimiter);
            // printf(argv[i]);
            // printf(DelimiterIndex);
            if (DelimiterIndex != NULL) {
                // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

                // 使用 strtok_r() 函數分割字符串;
                // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
                // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
                // while(ArgumentKey != NULL) {
                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
                //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
                //     ArgumentKey = strtok_r(NULL, Delimiter);
                // }
                // printf("控制臺傳入參數 %d: 字符串：'%s' 的名稱爲：'%s'\n", i, argv[i], ArgumentKey);
                const int ArgumentKeyLength = strlen(ArgumentKey);
                // printf("%d\n", ArgumentKeyLength);
                ArgumentValue = saveArgumentValue;
                // printf("控制臺傳入參數 %d: 字符串：'%s' 的值爲：'%s'\n", i, argv[i], ArgumentValue);
                const int ArgumentValueLength = strlen(ArgumentValue);
                // printf("%d\n", ArgumentValueLength);

                // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
                // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
                // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
                // printf("參數 %d: %s\n", i, buffer);

                // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
                if (ArgumentKey != NULL) {

                    // // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
                    // if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
                    //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                    //     // const int ArgumentValueLength = strlen(ArgumentValue);
                    //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                    //     // for(int g = 0; g < ArgumentValueLength; g++) {
                    //     //     configFile[g] = ArgumentValue[g];
                    //     // }
                    //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                    //     // char configFile[ArgumentValueLength + 1];
                    //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                    //     // configFile[sizeof(configFile) - 1] = '\0';

                    //     configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
                    //     // printf("%s\n", configFile);
                    // }

                    if (strncmp(ArgumentKey, "executableFile", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

                        // const int ArgumentValueLength = strlen(ArgumentValue);
                        // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                        // for(int g = 0; g < ArgumentValueLength; g++) {
                        //     executableFile[g] = ArgumentValue[g];
                        // }
                        // executableFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                        // char executableFile[ArgumentValueLength + 1];
                        // strncpy(executableFile, ArgumentValue, sizeof(executableFile) - 1);  // 字符串數組傳值，淺拷貝;
                        // executableFile[sizeof(executableFile) - 1] = '\0';

                        executableFile = strdup(ArgumentValue);
                        // printf("%s\n", executableFile);
                    }

                    if (strncmp(ArgumentKey, "interpreterFile", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        interpreterFile = strdup(ArgumentValue);
                        // printf("%s\n", interpreterFile);

                        // const int ArgumentValueLength = strlen(ArgumentValue);
                        // const int ArgumentValueLength = strlen(interpreterFile);
                        // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                        for (int j = 0; j < ArgumentValueLength; j++) {
                            // printf("%c\n", *interpreterFile);
                            // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                            if (*interpreterFile == ',') {
                                *interpreterFile = ' ';
                            }
                            interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                        }
                        // 將字符串指針，重新指向字符串的首地址;
                        interpreterFile = interpreterFile - ArgumentValueLength;
                        // printf("%s\n", interpreterFile);

                        // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                        // while (*interpreterFile != '\0') {
                        //     // printf("%c\n", *interpreterFile);
                        //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                        //     if (*interpreterFile == ',') {
                        //         *interpreterFile = ' ';
                        //     }
                        //     interpreterFile++;  // 每輪循環後，自動向後偏移一位指向;
                        // }
                        // // 將字符串指針，重新指向字符串的首地址;
                        // interpreterFile = interpreterFile - ArgumentValueLength;
                        // printf("%s\n", interpreterFile);
                    }

                    if (strncmp(ArgumentKey, "scriptFile", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        scriptFile = strdup(ArgumentValue);
                        // printf("%s\n", scriptFile);
                    }

                    if (strncmp(ArgumentKey, "configInstructions", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        configInstructions = strdup(ArgumentValue);
                        // printf("%s\n", configInstructions);

                        // const int ArgumentValueLength = strlen(ArgumentValue);
                        // const int ArgumentValueLength = strlen(configInstructions);
                        // 使用：for(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                        for (int j = 0; j < ArgumentValueLength; j++) {
                            // printf("%c\n", *configInstructions);
                            // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                            if (*configInstructions == ',') {
                                *configInstructions = ' ';
                            }
                            configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                        }
                        // 將字符串指針，重新指向字符串的首地址;
                        configInstructions = configInstructions - ArgumentValueLength;
                        // printf("%s\n", configInstructions);

                        // // 使用：while(){} 循環，遍歷字符串，查找逗號字符（','），並將之替換爲空格符號（' '）;
                        // while (*configInstructions != '\0') {
                        //     // printf("%c\n", *configInstructions);
                        //     // 判斷當前指向的字符，是否爲逗號字符（','），若是逗號字符（','），則將之替換爲空格符號（' '），若非逗號字符（','）則保持不變;
                        //     if (*configInstructions == ',') {
                        //         *configInstructions = ' ';
                        //     }
                        //     configInstructions++;  // 每輪循環後，自動向後偏移一位指向;
                        // }
                        // // 將字符串指針，重新指向字符串的首地址;
                        // configInstructions = configInstructions - ArgumentValueLength;
                        // printf("%s\n", configInstructions);
                    }

                    if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        isBlock = strdup(ArgumentValue);
                        // printf("%s\n", isBlock);
                    }

                // } else {

                //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
                //     configFile = strdup(ArgumentValue);

                //     // const int ArgumentValueLength = strlen(ArgumentValue);
                //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

                //     // for(int g = 0; g < ArgumentValueLength; g++) {
                //     //     configFile[g] = ArgumentValue[g];
                //     // }
                //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

                //     // char configFile[ArgumentValueLength + 1];
                //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
                //     // configFile[sizeof(configFile) - 1] = '\0';

                }

            // } else {

            //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
            //     configFile = strdup(ArgumentValue);

            //     // const int ArgumentValueLength = strlen(ArgumentValue);
            //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

            //     // for(int g = 0; g < ArgumentValueLength; g++) {
            //     //     configFile[g] = ArgumentValue[g];
            //     // }
            //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

            //     // char configFile[ArgumentValueLength + 1];
            //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
            //     // configFile[sizeof(configFile) - 1] = '\0';

            }
        }

        free(copyArgvI);
    }


    // 5、創建子進程執行調用控制臺 shell 語句運行第三方可執行檔;
    // printf("configFile = %s\n", configFile);  // "C:/StatisticalServer/config.txt"
    // const int lengthConfigFile = strlen(configFile);
    // printf("%d\n", lengthConfigFile); // 31
    // printf("isBlock = %s\n", isBlock);  // "true"
    const int lengthIsBlock = strlen(isBlock);
    // printf("%d\n", lengthIsBlock);  // 4
    // printf("executableFile = %s\n", executableFile);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"、"C:/StatisticalServer/Python/Python311/python.exe"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"、"C:/StatisticalServer/Nodejs/node.exe"
    const int lengthExecutableFile = strlen(executableFile);
    // printf("%d\n", lengthExecutableFile);  // 52
    // printf("interpreterFile = %s\n", interpreterFile);  // "-p,4,--project=C:/StatisticalServer/StatisticalServerJulia/"
    const int lengthInterpreterFile = strlen(interpreterFile);
    // printf("%d\n", lengthInterpreterFile);  // 54
    // printf("scriptFile = %s\n", scriptFile);  // "C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"、"C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py"、"C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js"
    const int lengthScriptFile = strlen(scriptFile);
    // printf("%d\n", lengthScriptFile);  // 77
    // printf("configInstructions = %s\n", configInstructions);  // "host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks"
    const int lengthConfigInstructions = strlen(configInstructions);
    // printf("%d\n", lengthConfigInstructions);  // 63

    if (lengthExecutableFile > 0) {

        // 拼接獲取控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數（shellCodeScript）：shellCodeScript = executableFile + " " + interpreterFile + " " + scriptFile + " " + configInstructions
        // char defaultShellCodeScript[BUFFER_LEN];  // 1024
        char defaultShellCodeScript[lengthExecutableFile + 1 + lengthInterpreterFile + 1 + lengthScriptFile + 1 + lengthConfigInstructions + 1];  // 255 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"

        if (lengthScriptFile == 0) {

            if (lengthInterpreterFile == 0) {

                // char defaultShellCodeScript[lengthExecutableFile + 1];  // 53 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s", executableFile);  // 52 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 52
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 52

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 52

            }

            if (lengthInterpreterFile > 0) {

                // char defaultShellCodeScript[lengthExecutableFile + 1 + lengthInterpreterFile + 1];  // 113 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s%s%s", executableFile, " ", interpreterFile);  // 112 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 112
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 112

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 112

            }
        }

        if (lengthScriptFile > 0) {

            if ((lengthInterpreterFile == 0) && (lengthConfigInstructions == 0)) {

                // char defaultShellCodeScript[lengthExecutableFile + 1 + lengthScriptFile + 1];  // 131 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s%s%s", executableFile, " ", scriptFile);  // 130 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 130
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 130

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 130

            }

            if ((lengthInterpreterFile > 0) && (lengthConfigInstructions == 0)) {

                // char defaultShellCodeScript[lengthExecutableFile + 1 + lengthInterpreterFile + 1 + lengthScriptFile + 1];  // 191 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s%s%s%s%s", executableFile, " ", interpreterFile, " ", scriptFile);  // 190 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 190
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 190

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 190

            }

            if ((lengthInterpreterFile == 0) && (lengthConfigInstructions > 0)) {

                // char defaultShellCodeScript[lengthExecutableFile + 1 + lengthScriptFile + 1 + lengthConfigInstructions + 1];  // 195 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s%s%s%s%s", executableFile, " ", scriptFile, " ", configInstructions);  // 194 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 194
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 194

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 194

            }

            if ((lengthInterpreterFile > 0) && (lengthConfigInstructions > 0)) {

                // char defaultShellCodeScript[lengthExecutableFile + 1 + lengthInterpreterFile + 1 + lengthScriptFile + 1 + lengthConfigInstructions + 1];  // 255 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                snprintf(defaultShellCodeScript, sizeof(defaultShellCodeScript), "%s%s%s%s%s%s%s", executableFile, " ", interpreterFile, " ", scriptFile, " ", configInstructions);  // 254 // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 254
                defaultShellCodeScript[lengthDefaultShellCodeScript] = '\0';
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", defaultShellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // const int lengthDefaultShellCodeScript = strlen(defaultShellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 254

                // shellCodeScript = strdup(defaultShellCodeScript);  // 函數：strdup(defaultShellCodeScript) 表示，指針傳值，深拷貝，需要 free(shellCodeScript) 釋放内存;
                shellCodeScript = defaultShellCodeScript;  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
                // const int lengthDefaultShellCodeScript = strlen(shellCodeScript);
                // printf("%d\n", lengthDefaultShellCodeScript);  // 254

            }
        }

        // printf("C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數爲：\n%s\n", shellCodeScript);  // "C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
        // printf("%d\n", strlen(shellCodeScript));

        // 使用函數：FILE *popen(const char *command, const char *type)，調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）;
        char *IDsubprocess = "";
        int pcloseReturn;
        char buffer[BUFFER_LEN];  // BUFFER_LEN = 1024 // 代碼首部自定義的常量：BUFFER_LEN = 1024，靜態申請内存緩衝區（buffer），存儲子進程標準輸出通道（stdout）中的返回值的每一個橫向列（row）中的内容，要求子進程標準輸出通道（stdout）中的返回值的每一個橫向列（row）最多不得超過 1024 個字符;
        memset(buffer, 0, sizeof(buffer));  // 存緩衝區（buffer）賦初值;
        FILE *fstream = popen(shellCodeScript, "r");  // 取："r" 值表示只讀，取："w" 表示只寫，只能二選一;

        if (fstream == NULL) {
            printf("調用操作系統（Linux、Window）控制臺命令列（shell、cmd）啓動可執行檔（.exe）失敗.\nshell code script:""\n%s\n", shellCodeScript);  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
            // printf("shellCodeScript = %s\n", shellCodeScript);  // C 語言調用操作系統（Linux、Window）控制臺命令列（shell、cmd）運行二進制可執行檔（.exe）的字符串參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/src/StatisticalAlgorithmServer.jl IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/Python/Python311/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe C:/StatisticalServer/StatisticalServerPython/src/StatisticalAlgorithmServer.py IP=::0 port=10001 Is_multi_thread=false number_Worker_threads=1"
            return 1;
        }

        if (fstream != NULL) {

            if ((lengthIsBlock == 0) || (strncmp(isBlock, "true", sizeof(isBlock)) == 0)) {

                // 循環讀取子進程程式指令執行的返回值;
                while (fgets(buffer, sizeof(buffer), fstream) != NULL) {

                    printf("%s\n", buffer);

                    // 從子進程的自定義返回值信息中，提取子進程的 ID 號值;
                    if (strlen(buffer) > 0) {

                        // 從：Julia statistical server 自定義的返回值信息中，提取子進程的 ID 號值;
                        if (strstr(buffer, " listening on") != NULL) {
                            IDsubprocess = strdup(buffer);
                            memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                            // printf("%s\n", IDsubprocess);
                            IDsubprocess = strtok(IDsubprocess, " ");
                            // if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                            //     snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                            // }
                            while( IDsubprocess != NULL ) {
                                if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                                    // printf("%s\n", IDsubprocess);
                                    if (strlen(buffer) > 0) {
                                        snprintf(buffer, sizeof(buffer), "%s%s%s", buffer, " ", IDsubprocess);
                                    } else {
                                        snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                                    }
                                    IDsubprocess = strtok(NULL, " ");
                                } else {
                                    break;
                                }
                            }
                            buffer[strlen(buffer)] = '\0';
                            IDsubprocess = strdup(buffer);
                            // printf("Subprocess ID: %s\n", IDsubprocess);
                        }
                    }
                    memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                }
            }

            if (strncmp(isBlock, "false", sizeof(isBlock)) == 0) {

                // 只讀取子進程程式指令執行的返回值的第一個橫向列（row）;
                if (fgets(buffer, sizeof(buffer), fstream) != NULL) {
                    // printf("%s\n", buffer);

                    // 從子進程的自定義返回值的第一個橫向列（row）的信息中，提取子進程的 ID 號值;
                    if (strlen(buffer) > 0) {

                        // 從：Julia statistical server 自定義的返回值的第一個橫向列（row）的信息中，提取子進程的 ID 號值;
                        if (strstr(buffer, " listening on") != NULL) {
                            IDsubprocess = strdup(buffer);
                            memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                            // printf("%s\n", IDsubprocess);
                            IDsubprocess = strtok(IDsubprocess, " ");
                            // if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                            //     snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                            // }
                            while( IDsubprocess != NULL ) {
                                if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                                    // printf("%s\n", IDsubprocess);
                                    if (strlen(buffer) > 0) {
                                        snprintf(buffer, sizeof(buffer), "%s%s%s", buffer, " ", IDsubprocess);
                                    } else {
                                        snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                                    }
                                    IDsubprocess = strtok(NULL, " ");
                                } else {
                                    break;
                                }
                            }
                            buffer[strlen(buffer)] = '\0';
                            IDsubprocess = strdup(buffer);
                            // printf("Subprocess ID: %s\n", IDsubprocess);
                        }
                    }
                    memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                }

                // // 循環讀取子進程程式指令執行的返回值;
                // while (fgets(buffer, sizeof(buffer), fstream) != NULL) {
                //     // printf("%s\n", buffer);
                //     // 從子進程的自定義返回值信息中，提取子進程的 ID 號值;
                //     if (strlen(buffer) > 0) {
                //         // 從：Julia statistical server 自定義的返回值信息中，提取子進程的 ID 號值;
                //         if (strstr(buffer, " listening on") != NULL) {
                //             IDsubprocess = strdup(buffer);
                //             memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                //             // printf("%s\n", IDsubprocess);
                //             IDsubprocess = strtok(IDsubprocess, " ");
                //             // if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                //             //     snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                //             // }
                //             while( IDsubprocess != NULL ) {
                //                 if ((strstr(IDsubprocess, "process") != NULL) || (strstr(IDsubprocess, "thread") != NULL) || (strstr(IDsubprocess, "task") != NULL)) {
                //                     // printf("%s\n", IDsubprocess);
                //                     if (strlen(buffer) > 0) {
                //                         snprintf(buffer, sizeof(buffer), "%s%s%s", buffer, " ", IDsubprocess);
                //                     } else {
                //                         snprintf(buffer, sizeof(buffer), "%s", IDsubprocess);
                //                     }
                //                     IDsubprocess = strtok(NULL, " ");
                //                 } else {
                //                     break;
                //                 }
                //             }
                //             buffer[strlen(buffer)] = '\0';
                //             IDsubprocess = strdup(buffer);
                //             // printf("Subprocess ID: %s\n", IDsubprocess);
                //             memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                //             break;
                //         }
                //     }
                //     memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
                // }
            }

            pcloseReturn = pclose(fstream);  // 關閉子進程程式指令執行的返回值的讀取管道;
            // printf("pclose return = %d\n", pcloseReturn);
            if (pcloseReturn == 1) {
                // printf("子進程（%s）程式指令爲空.\n", IDsubprocess);
                printf("subprocess program ( %s ) instruction is empty.\n", IDsubprocess);
            } else if (pcloseReturn == -1) {
                printf("創建子進程（%s）程式指令失敗.\n", IDsubprocess);
            } else if (pcloseReturn == 0x7f00) {
                printf("子進程（%s）程式指令錯誤無法執行.\n", IDsubprocess);
            } else if (pcloseReturn == 0) {
                // printf("子進程（%s）程式指令執行完畢.\n", IDsubprocess);
                printf("subprocess program ( %s ) instruction completed.\n", IDsubprocess);
                // if (WIFEXITED(pcloseReturn)) {
                //     printf("子進程程式指令執行完畢，返回值爲：%d\n", WEXITSTATUS(pcloseReturn));
                // } else if (WIFSIGNALED(pcloseReturn)) {
                //     printf("子進程程式指令被「中止」信號結束，「中止」信號值爲：%d\n", WTERMSIG(pcloseReturn));
                // } else if (WSTOPSIG(pcloseReturn)) {
                //     printf("子進程程式指令被「暫停」信號暫停，「暫停」信號值爲：%d\n", WSTOPSIG(pcloseReturn));
                // }
            } else {}
        }

        if (strlen(IDsubprocess) > 0) { free(IDsubprocess); }

    } else {

        printf("解釋器（Exempli gratia: Julia、Python、Node.js、Java）可執行檔啓動路徑參數爲空：\nexecutableFile = %s\n", executableFile);  // 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動路徑參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"、"C:/StatisticalServer/Python/Python311/python.exe"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"、"C:/StatisticalServer/Nodejs/node.exe"
        // printf("executableFile = %s\n", executableFile);  // 解釋器（Julia、Python、Node.js、Java）的二進制可執行檔啓動路徑參數："C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe"、"C:/StatisticalServer/Python/Python311/python.exe"、"C:/StatisticalServer/StatisticalServerPython/Scripts/python.exe"、"C:/StatisticalServer/Nodejs/node.exe"
        return 1;
    }

    if (strlen(configFile) > 0) {
        free(configFile);
        // configFile = NULL;
    }
    if (strlen(isBlock) > 0) {
        free(isBlock);
        // isBlock = NULL;
    }
    if (strlen(executableFile) > 0) {
        free(executableFile);
        // executableFile = NULL;
    }
    if (strlen(interpreterFile) > 0) {
        free(interpreterFile);
        // interpreterFile = NULL;
    }
    if (strlen(scriptFile) > 0) {
        free(scriptFile);
        // scriptFile = NULL;
    }
    if (strlen(configInstructions) > 0) {
        free(configInstructions);
        // configInstructions = NULL;
    }
    if (strlen(shellCodeScript) > 0) {
        free(shellCodeScript);
        // shellCodeScript = NULL;
    }

    return 0;
}
