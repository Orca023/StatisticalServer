/**************************************************************************

// Title: C language Criss v20161211
// Explain: C language tcp server and tcp client and file monitor
// Author: 弘毅
// E-mail: 283640621@qq.com
// Telephont number: +86 18604537694
// Date: 歲在丙申
// Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
// Compiler: gcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0
// Operating system: Google-Pixel-2 Android-11 Termux-0.118 Ubuntu-22.04 Arm64 Qualcomm-Snapdragon-855
// Compiler: gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0

// 使用説明：
// 編譯指令：
// C:\> C:\MinGW64\bin\gcc.exe C:/Criss/c/StatisticalAlgorithmServer.c C:/Criss/c/Router.c C:/Criss/c/Interface.c C:/Criss/c/cjson/cJSON.c -o C:/Criss/c/StatisticalAlgorithmServer.exe -lm -lws2_32
// root@localhost:~# /usr/bin/gcc /home/Criss/c/StatisticalAlgorithmServer.c /home/Criss/c/Router.c /home/Criss/c/Interface.c /home/Criss/c/cjson/cJSON.c -o /home/Criss/c/StatisticalAlgorithmServer.exe -lm
// 控制臺顯示中文字符指令;
// root@localhost:~# chcp 65001
// 運行指令：
// C:\> C:/Criss/c/StatisticalAlgorithmServer.exe configFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}
// root@localhost:~# /home/Criss/c/StatisticalAlgorithmServer.exe configFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}

***************************************************************************/


// 導入 C 語言編譯器 : Linux-Ubuntu ( Android-Termux ) gcc or Windows MingW-W64 gcc 原生標準庫;
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
#include <pthread.h>
#include <malloc.h>

// 判斷作業系統 ( operating systems ) 類型 : Linux or Windows 的標識變量，以區分加載 C 語言編譯器 : Linux-Ubuntu ( Android-Termux ) gcc or Windows MingW-W64 gcc 的原生標準庫;
#if !defined(__WINDOWS__) && (defined(WIN32) || defined(WIN64) || defined(_MSC_VER) || defined(_WIN32))
    #define __WINDOWS__
#endif
// #if !defined(_WIN32_WINNT)
//     #define _WIN32_WINNT 0x501  // 取值：0x501 表示，如果是 Windows x86_32 位系統，則使用 Window XP 版本的 API 接口;
// #endif
#if !defined(__linux__)
    #define __linux__
#endif

// 判斷作業系統 ( operating systems ) 類型 : Linux or Windows 並據此區分加載 C 語言編譯器 : Linux-Ubuntu ( Android-Termux ) gcc or Windows MingW-W64 gcc 的原生標準庫;
#if defined(__WINDOWS__)
    // C 語言編譯器 : Windows MingW-W64 gcc 的原生標準庫;
    #include <ws2tcpip.h>
    #include <winsock2.h>
    #include <winsock.h>
    #include <stdint.h>
    #include <windows.h>
#elif defined(__linux__)
    // C 語言編譯器 : Linux-Ubuntu ( Android-Termux ) gcc 的原生標準庫;
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netinet/in.h>
    #include <sys/un.h>
    #include <netdb.h>
#else
    printf("Unknown operating system.\n");
    exit(1);
#endif


// 加載第三方擴展包;
#include "cJSON/cJSON.h"

/* Create a bunch of objects as demonstration. 使用第三方擴展包：cJSON.c 創建一個捆（聚束）對象，可以用於判斷使用 cJSON 擴展包定義的創建 JSON 對象是否成功; */
static int print_preallocated (cJSON *root) {
    /* declarations */
    /* 聲明變量 */
    char *out = NULL;
    char *buf = NULL;
    char *buf_fail = NULL;
    size_t len = 0;
    size_t len_fail = 0;

    /* formatted print 格式化打印輸出到顯示屏 */
    out = cJSON_Print(root);

    /* create buffer to succeed 當創建緩存成功時 */
    /* the extra 5 bytes are because of inaccuracies when reserving memory 額外的 5 個字節是因為創建存儲變量時内存誤差 */
    len = strlen(out) + 5;
    buf = (char*)malloc(len);
    if (buf == NULL) {
        printf("Failed to allocate memory.\n");
        exit(1);
    }

    /* create buffer to fail 當創建緩存失敗時 */
    len_fail = strlen(out);
    buf_fail = (char*)malloc(len_fail);
    if (buf_fail == NULL) {
        printf("Failed to allocate memory.\n");
        exit(1);
    }

    /* Print to buffer */
    if (!cJSON_PrintPreallocated(root, buf, (int)len, 1)) {
        printf("cJSON_PrintPreallocated failed!\n");
        if (strcmp(out, buf) != 0) {
            printf("cJSON_PrintPreallocated not the same as cJSON_Print!\n");
            printf("cJSON_Print result:\n%s\n", out);
            printf("cJSON_PrintPreallocated result:\n%s\n", buf);
        }
        free(out);
        free(buf_fail);
        free(buf);
        return -1;
    }

    /* success 如創建成功，則將變量值打印輸出到顯示屏 */
    // printf("%s\n", buf);

    /* force it to fail 强制指定爲失敗 */
    if (cJSON_PrintPreallocated(root, buf_fail, (int)len_fail, 1)) {
        printf("cJSON_PrintPreallocated failed to show error with insufficient memory!\n");
        printf("cJSON_Print result:\n%s\n", out);
        printf("cJSON_PrintPreallocated result:\n%s\n", buf_fail);
        free(out);
        free(buf_fail);
        free(buf);
        return -1;
    }

    free(out);  // 釋放堆内存;
    free(buf_fail);
    free(buf);
    return 0;
}


// 加載自定義的 C 語言模組代碼文檔;
#include "Interface.h"
#include "Router.h"


#define BUFFER_LEN 1024  // 定義讀取配置文檔（config.txt）每一行數據緩衝區 1024 個字符;
#define BUFFER_LEN_request 1024  // 定義用戶端發送的請求數據緩衝區 1024 個字符;
#define BUFFER_LEN_response 1024  // 定義服務端發送的響應數據緩衝區 1024 個字符;


// 區分操作系統 Windows MingW-w64 gcc 或 Linux-Ubuntu ( Android-Termux ) gcc 系統，如是 Windows 系統將獨有函數 _msize() 映射爲自定義的 sizeMalloc() 函數，如是 Linux 系統將獨有函數 malloc_usable_size() 映射爲自定義的 sizeMalloc() 函數;
#if defined(__WINDOWS__)
    #define sizeMalloc _msize
#elif defined(__linux__)
    #define sizeMalloc malloc_usable_size
#else
    printf("Unknown operating system.\n");
    exit(1);
#endif
// // 區分操作系統 Windows MingW-w64 gcc 或 Linux-Ubuntu ( Android-Termux ) gcc 系統，如是 Windows 系統將其替換爲「windows.h」包下的「Sleep()」函數，對於 Linux 系統將其替換爲「unistd.h」包下的「sleep()」函數，爲了代碼的可移植性，不應直接使用「Sleep()」和「sleep()」，而必須使用「timeSleep()」包裝函數;
// // #if defined(_WIN32) || defined(_WIN64)
// #if defined(__WINDOWS__)
//     #define timeSleep Sleep
// #elif defined(__linux__)
//     #define timeSleep sleep
// #else
//     printf("Unknown operating system.\n");
//     exit(1);
// #endif


// 定義信號處理函數;
static void signalHandler(int signum) {
    // printf("Interrupt signal (%d) received.\n", signum);
    // // 清理並關閉;
    // // 清理代碼，例如釋放資源，關閉文件等;
    // // 終止程序;
    // exit(signum);

    // 判斷信號值（signum）是否爲「Ctrl+c」;
    if (signum == 2) {
        printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
        exit(signum);
    }
}


char *NoteVersion = "C language tcp server and tcp client and file monitor Interface v20161211\nGoogle-Pixel-2 Android-11 Termux-0.118 Ubuntu-22.04 Arm64 Qualcomm-Snapdragon-855\ngcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nC socket server and client\nC file server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n";
char *NoteHelp = "C language tcp server and tcp client and file monitor Interface v20161211\nGoogle-Pixel-2 Android-11 Termux-0.118 Ubuntu-22.04 Arm64 Qualcomm-Snapdragon-855\ngcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nC socket server and client\nC file server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n\n--help -h ? --version -v\n\nconfigFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={\"Client_say\":\"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24T14:05:33.286\"}\n\nconfigFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={\"Client_say\":\"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24T14:05:33.286\"}\n";

// 控制臺傳參，直接使用 gcc 的：main() 函數參數，獲取從控制臺傳入的參數，注意 C 語言的 main() 函數的參數是兩個，第一個是參數的數量（參數數組的長度），第二個是參數的數組;
int main (int argc, char *argv[]) {

    // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;
    signal(SIGINT, signalHandler);  // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;

    // 判斷控制臺命令行是否有傳入參數，若有傳入參數，則繼續判斷是否爲：查詢信息指令;
    if (argc > 1) {
        // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
        // 使用函數：strncmp(argv[1], "--version", sizeof(argv[1])) == 0 判斷兩個字符串是否相等;
        if ((strncmp(argv[1], "--version", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-v", sizeof(argv[1])) == 0)) {
            printf("%s\n", NoteVersion);
            return 0;  // 跳出函數，中止運行後續的代碼;
        }
        // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
        if ((strncmp(argv[1], "--help", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-h", sizeof(argv[1])) == 0) || (strncmp(argv[1], "?", sizeof(argv[1])) == 0)) {
            printf("%s\n", NoteHelp);
            return 0;  // 跳出函數，中止運行後續的代碼;
        }
    }

    // 獲取當前時間
    time_t current_time;
    time(&current_time); 
    // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
    struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
    // 定義一個足夠大的字符串來保存日期和時間
    char now_time_string[80];
    // 使用 strftime 將時間格式化為字符串
    // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
    // printf("當前時間是：%s\n", now_time_string);
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
    strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
    // printf("UTC time: %s\n", now_time_string);
    memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    char *configFile = "";  // 配置文檔的保存路徑參數："C:/Criss/config.txt"

    char *isBlock = "";  // 子進程中的，控制臺命令行程式，運行時，是否阻塞主進程後續代碼的執行;
    // isBlock = "true";  // 初始預設值爲："true"，即：阻塞主進程後續代碼的執行;
    // printf("isBlock = %s\n", isBlock);

    char *interface_Function_name_str = "";  // 判斷啓動服務器（server）或是用戶端（client）程式;
    interface_Function_name_str = "tcp_Server";  // "file_Monitor";  // "tcp_Server";  // "http_Server";  // "tcp_Client";  // "http_Client";  // "interface_File_Monitor";  // "interface_TCP_Server";  // "interface_http_Server";  // "interface_TCP_Client";  // "interface_http_Client";
    // printf("interface Function name = %s\n", interface_Function_name_str);

    char *IPversion = "IPv6";  // "IPv6"、"IPv4";
    int serverPORT = -1;  // 定義服務器端（server）監聽埠號整型數據儲存變量;
    serverPORT = 10001;  // 定義服務器端（server）預設埠號整數;
    char *serverIPaddress = "";  // 聲明服務器端（server）監聽 IPv4 or IPv6 地址字符串型數據儲存變量;
    serverIPaddress = "::0";  // "::0";  // "0.0.0.0";  // 定義服務器端（server）預設 IPv4 or IPv6 地址字符串;
    int clientPORT = -1;  // 定義用戶端（client）鏈接埠號整型數據儲存變量;
    clientPORT = 10001;  // 定義用戶端（client）預設埠號整數;
    char *clientIPaddress = "";  // 聲明用戶端（client）鏈接 IPv4 or IPv6 地址字符串型數據儲存變量;
    clientIPaddress = "::1";  // "::1";  // "127.0.0.1";  // 定義用戶端（client）預設 IPv4 or IPv6 地址字符串;

    char *sessionString = "";  // "{\"request_Key->username:password\":\"username:password\"}";
    sessionString = "{\"request_Key->username:password\":\"username:password\"}";
    char *postData = "";
    postData = "{\"Client_say\":\"language C Socket client connection. 在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24 14:05:33.286\"}";
    char *requestURL = "";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // "http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1";
    requestURL = "http://username:password@localhost:10001/";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";
    char *requestPath = "/";
    char *requestMethod = "POST";  // "POST",  // "GET";  // 請求方法;
    char *requestProtocol = "HTTP";
    char *requestConnection = "keep-alive";  // "keep-alive", "close";
    char *requestReferer = "http://username:password@localhost:10001/";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // "http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1";
    char *Authorization = "";  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
    Authorization = "Basic username:password -> Basic dXNlcm5hbWU6cGFzc3dvcmQ=";  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
    char *Cookie = "";  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
    Cookie = "Session_ID=request_Key->username:password -> Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
    char *requestFrom = "user@email.com";
    float time_out = 0.0; // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;

    char *webPath = "";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
    char *key = ":";  // "username:password"; // 自定義的訪問網站簡單驗證用戶名和密碼;
    float time_sleep = 0.0;
    // sleep(time_sleep);

    char *is_Monitor = "true";  // 判斷持續監聽目標文檔，亦或是執行一次，取："true" 或 "1" 表示持續監聽，取："false" 或 "0" 表示執行一次;
    char *monitor_file = "C:/Criss/Intermediary/intermediary_write_Julia.txt";
    char *monitor_dir = "C:/Criss/Intermediary";
    char *output_dir = "C:/Criss/Intermediary";
    char *output_file = "C:/Criss/Intermediary/intermediary_write_C.txt";
    char *to_executable = "C:/Criss/Julia/Julia-1.9.3/bin/julia.exe";
    char *to_script = "C:/Criss/CrissJulia/src/StatisticalAlgorithmServer.jl";
    char *temp_cache_IO_data_dir = "C:/Criss/temp";


    // 1.1、解析預設的配置文檔（C:/Criss/config.txt）的保存路徑參數：configFile;
    
    // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
    // printf("The full path to the executable is :\n%s\n", argv[0]);
    // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);  // "C:/Criss/Interface.exe"
    // const int Argument0Length = strlen(argv[0]);  // 獲取傳入的第一個參數：argv[0]，即：當前運行的二進制可執行檔完整路徑，的字符串的長度;
    // printf("當前運行的二進制可執行檔完整路徑:\n%s\n長度爲：%d 個字符.\n", argv[0], Argument0Length);  // 24
    // 備份控制臺傳入參數;
    // char copyArgv0[Argument0Length + 1];
    // strncpy(copyArgv0, argv[0], sizeof(copyArgv0) - 1);  // 字符串數組傳值，淺拷貝;
    // copyArgv0[sizeof(copyArgv0) - 1] = '\0';
    // 備份控制臺傳入參數;
    char *copyArgv0 = strdup(argv[0]);  // 函數：strdup(argv[0]) 表示，指針傳值，深拷貝，需要 free(copyArgv0) 釋放内存;
    // printf("%s\n", argv[0]);  // "C:/Criss/Interface.exe"
    // printf("%s\n", copyArgv0);  // "C:/Criss/Interface.exe"
    // const int lengthCopyArgv0 = strlen(copyArgv0);
    // printf("%d\n", lengthCopyArgv0);  // 42

    char *defaultConfigFileDirectory = "";  // "C:/Criss"
    defaultConfigFileDirectory = dirname(copyArgv0);
    // printf("預設配置文檔的保存位置爲：\n%s\n", defaultConfigFileDirectory);  // "C:/Criss"
    const int lengthDefaultConfigFileDirectory = strlen(defaultConfigFileDirectory);
    // printf("%d\n", lengthDefaultConfigFileDirectory);  // 20

    char *configFileName = "config.txt";  // "C:/Criss/config.txt"
    const int lengthConfigFileName = strlen(configFileName);
    // printf("%d\n", lengthConfigFileName);  // 10

    char defaultConfigFilePath[lengthDefaultConfigFileDirectory + 1 + lengthConfigFileName + 1];  // "C:/Criss/config.txt"
    snprintf(defaultConfigFilePath, sizeof(defaultConfigFilePath), "%s%s%s", defaultConfigFileDirectory, "/", configFileName);
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/Criss/config.txt"
    const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31
    defaultConfigFilePath[lengthDefaultConfigFilePath] = '\0';
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/Criss/config.txt"
    // const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31

    configFile = strdup(defaultConfigFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // configFile = defaultConfigFilePath;
    // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/Criss/config.txt"
    // const int lengthDefaultConfigFilePath = strlen(configFile);
    // printf("%d\n", lengthDefaultConfigFilePath);  // 31

    defaultConfigFileDirectory = NULL;
    configFileName = NULL;


    // 1.2、解析預設的服務端（socket server）運行空間目錄文檔（C:/Criss/html/）的保存路徑參數：webPath;
    char *defaultWebPathDirectory = "";  // "C:/Criss"
    defaultWebPathDirectory = dirname(copyArgv0);
    // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPathDirectory);  // "C:/Criss"
    const int lengthDefaultWebPathDirectory = strlen(defaultWebPathDirectory);
    // printf("%d\n", lengthDefaultWebPath);  // 20

    char *webPathName = "html";  // "C:/Criss/html"
    const int lengthWebPathName = strlen(webPathName);
    // printf("%d\n", lengthWebPathName);  // 4

    char defaultWebPath[lengthDefaultWebPathDirectory + 1 + lengthWebPathName + 1];  // "C:/Criss/html"
    snprintf(defaultWebPath, sizeof(defaultWebPath), "%s%s%s", defaultWebPathDirectory, "/", webPathName);
    // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPath);  // "C:/Criss/html"
    const int lengthDefaultWebPath = strlen(defaultWebPath);
    // printf("%d\n", lengthDefaultWebPath);  // 25
    defaultWebPath[lengthDefaultWebPath] = '\0';
    // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPath);  // "C:/Criss/html"
    // const int lengthDefaultWebPath = strlen(defaultWebPath);
    // printf("%d\n", lengthDefaultWebPath);  // 25

    webPath = strdup(defaultWebPath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
    // webPath = defaultConfigFilePath;
    // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", webPath);  // "C:/Criss/html"
    // const int lengthWebPath = strlen(webPath);
    // printf("%d\n", lengthWebPath);  // 25

    defaultWebPathDirectory = NULL;
    webPathName = NULL;

    free(copyArgv0);  // 釋放内存;


    // 2、讀取控制臺傳入的配置文檔（C:/Criss/config.txt）的保存路徑參數：configFile;
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


    // 3、讀取配置文檔（C:/Criss/config.txt）中記錄的參數：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
    // printf("配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/Criss/config.txt";
    // 讀取配置文檔：configFile 中的參數;
    if (strlen(configFile) > 0) {

        FILE *file = fopen(configFile, "rt");  // rt、rb、wt、wb、a、r+、w+、a+;

        if (file == NULL) {

            // printf("無法打開配置文檔：\nconfigFile = %s\n", configFile);
            // // return 1;
        }

        if (file != NULL) {
            // printf("正在使用配置文檔：\nconfigFile = %s\n", configFile);  // "C:/Criss/config.txt";
            printf("configFile = %s\n", configFile);  // "C:/Criss/config.txt";

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

                    // 刪除配置文檔（C:/Criss/config.txt）中，每個橫向列（row）字符串末尾可能存在的換行符回車符號（Enter）：'\n'，代之以字符串結束標志符號：'\0'，字符串長度會縮短 1 位;
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

                    // 提取配置文檔（C:/Criss/config.txt）中，每個橫向列（row）字符串中，指定的參數值：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
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

                                    if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        isBlock = strdup(ArgumentValue);
                                        // printf("%s\n", isBlock);
                                    }

                                    if (strncmp(ArgumentKey, "is_monitor", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        is_Monitor = strdup(ArgumentValue);
                                        // printf("%s\n", is_Monitor);
                                    }

                                    if (strncmp(ArgumentKey, "monitor_dir", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        monitor_dir = strdup(ArgumentValue);
                                        // printf("%s\n", monitor_dir);
                                    }

                                    if (strncmp(ArgumentKey, "monitor_file", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        monitor_file = strdup(ArgumentValue);
                                        // printf("%s\n", monitor_file);
                                    }

                                    if (strncmp(ArgumentKey, "output_dir", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        output_dir = strdup(ArgumentValue);
                                        // printf("%s\n", output_dir);
                                    }

                                    if (strncmp(ArgumentKey, "output_file", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        output_file = strdup(ArgumentValue);
                                        // printf("%s\n", output_file);
                                    }

                                    if (strncmp(ArgumentKey, "temp_cache_IO_data_dir", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        temp_cache_IO_data_dir = strdup(ArgumentValue);
                                        // printf("%s\n", temp_cache_IO_data_dir);
                                    }

                                    if (strncmp(ArgumentKey, "interface_Function", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        interface_Function_name_str = strdup(ArgumentValue);
                                        // printf("%s\n", interface_Function_name_str);
                                    }

                                    if (strncmp(ArgumentKey, "serverHOST", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        serverIPaddress = strdup(ArgumentValue);
                                        // printf("%s\n", serverIPaddress);
                                    }

                                    if (strncmp(ArgumentKey, "serverPORT", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        serverPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                                        // serverPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                                        // if (errno == ERANGE && (serverPORT == LONG_MAX || serverPORT == LONG_MIN)) {
                                        //     printf("數字轉換過程中發生溢出.\n");
                                        // } else if (endptr == ArgumentValue) {
                                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                                        // } else {
                                        //     printf("轉換結果: %ld\n", serverPORT);
                                        // }
                                        // printf("%d\n", serverPORT);
                                    }

                                    if (strncmp(ArgumentKey, "clientHOST", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        clientIPaddress = strdup(ArgumentValue);
                                        // printf("%s\n", clientIPaddress);
                                    }

                                    if (strncmp(ArgumentKey, "clientPORT", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        clientPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                                        // clientPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                                        // if (errno == ERANGE && (clientPORT == LONG_MAX || clientPORT == LONG_MIN)) {
                                        //     printf("數字轉換過程中發生溢出.\n");
                                        // } else if (endptr == ArgumentValue) {
                                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                                        // } else {
                                        //     printf("轉換結果: %ld\n", clientPORT);
                                        // }
                                        // printf("%d\n", clientPORT);
                                    }

                                    if (strncmp(ArgumentKey, "IPversion", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        IPversion = strdup(ArgumentValue);  // "IPv6", "IPv4";
                                        // printf("%s\n", IPversion);
                                    }

                                    if (strncmp(ArgumentKey, "webPath", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        webPath = strdup(ArgumentValue);
                                        // printf("%s\n", webPath);
                                    }

                                    if (strncmp(ArgumentKey, "key", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        key = strdup(ArgumentValue);
                                        // printf("%s\n", key);
                                    }

                                    if (strncmp(ArgumentKey, "time_sleep", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        time_sleep = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
                                        // time_sleep = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                                        // time_sleep = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                                        // if (errno == ERANGE && (time_sleep == LONG_MAX || time_sleep == LONG_MIN)) {
                                        //     printf("數字轉換過程中發生溢出.\n");
                                        // } else if (endptr == ArgumentValue) {
                                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                                        // } else {
                                        //     printf("轉換結果: %ld\n", time_sleep);
                                        // }
                                        // printf("%d\n", time_sleep);
                                    }

                                    if (strncmp(ArgumentKey, "time_out", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        time_out = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
                                        // time_out = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                                        // time_out = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                                        // if (errno == ERANGE && (time_out == LONG_MAX || time_out == LONG_MIN)) {
                                        //     printf("數字轉換過程中發生溢出.\n");
                                        // } else if (endptr == ArgumentValue) {
                                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                                        // } else {
                                        //     printf("轉換結果: %ld\n", time_out);
                                        // }
                                        // printf("%d\n", time_out);
                                    }

                                    if (strncmp(ArgumentKey, "requestURL", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestURL = strdup(ArgumentValue);
                                        // printf("%s\n", requestURL);
                                    }

                                    if (strncmp(ArgumentKey, "requestPath", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestPath = strdup(ArgumentValue);
                                        // printf("%s\n", requestPath);
                                    }

                                    if (strncmp(ArgumentKey, "requestConnection", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestConnection = strdup(ArgumentValue);
                                        // printf("%s\n", requestConnection);
                                    }

                                    if (strncmp(ArgumentKey, "requestFrom", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestFrom = strdup(ArgumentValue);
                                        // printf("%s\n", requestFrom);
                                    }

                                    if (strncmp(ArgumentKey, "requestReferer", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestReferer = strdup(ArgumentValue);
                                        // printf("%s\n", requestReferer);
                                    }

                                    if (strncmp(ArgumentKey, "requestMethod", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        requestMethod = strdup(ArgumentValue);
                                        // printf("%s\n", requestMethod);
                                    }

                                    if (strncmp(ArgumentKey, "requestAuthorization", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        Authorization = strdup(ArgumentValue);
                                        // printf("%s\n", Authorization);
                                    }

                                    if (strncmp(ArgumentKey, "requestCookie", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        Cookie = strdup(ArgumentValue);
                                        // printf("%s\n", Cookie);
                                    }

                                    if (strncmp(ArgumentKey, "session", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        sessionString = strdup(ArgumentValue);
                                        // printf("%s\n", sessionString);
                                    }

                                    if (strncmp(ArgumentKey, "requestData", sizeof(ArgumentKey)) == 0) {
                                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                                        postData = strdup(ArgumentValue);
                                        // printf("%s\n", postData);
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

        // printf("配置文檔的保存路徑參數爲空：\nconfigFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/Criss/config.txt"
        // // printf("configFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/Criss/config.txt"
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

                    if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        isBlock = strdup(ArgumentValue);
                        // printf("%s\n", isBlock);
                    }

                    if (strncmp(ArgumentKey, "is_monitor", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        is_Monitor = strdup(ArgumentValue);
                        // printf("%s\n", is_Monitor);
                    }

                    if (strncmp(ArgumentKey, "monitor_dir", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        monitor_dir = strdup(ArgumentValue);
                        // printf("%s\n", monitor_dir);
                    }

                    if (strncmp(ArgumentKey, "monitor_file", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        monitor_file = strdup(ArgumentValue);
                        // printf("%s\n", monitor_file);
                    }

                    if (strncmp(ArgumentKey, "output_dir", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        output_dir = strdup(ArgumentValue);
                        // printf("%s\n", output_dir);
                    }

                    if (strncmp(ArgumentKey, "output_file", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        output_file = strdup(ArgumentValue);
                        // printf("%s\n", output_file);
                    }

                    if (strncmp(ArgumentKey, "temp_cache_IO_data_dir", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        temp_cache_IO_data_dir = strdup(ArgumentValue);
                        // printf("%s\n", temp_cache_IO_data_dir);
                    }

                    if (strncmp(ArgumentKey, "interface_Function", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        interface_Function_name_str = strdup(ArgumentValue);
                        // printf("%s\n", interface_Function_name_str);
                    }

                    if (strncmp(ArgumentKey, "serverHOST", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        serverIPaddress = strdup(ArgumentValue);
                        // printf("%s\n", serverIPaddress);
                    }

                    if (strncmp(ArgumentKey, "serverPORT", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        serverPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                        // serverPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                        // if (errno == ERANGE && (serverPORT == LONG_MAX || serverPORT == LONG_MIN)) {
                        //     printf("數字轉換過程中發生溢出.\n");
                        // } else if (endptr == ArgumentValue) {
                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                        // } else {
                        //     printf("轉換結果: %ld\n", serverPORT);
                        // }
                        // printf("%d\n", serverPORT);
                    }

                    if (strncmp(ArgumentKey, "clientHOST", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        clientIPaddress = strdup(ArgumentValue);
                        // printf("%s\n", clientIPaddress);
                    }

                    if (strncmp(ArgumentKey, "clientPORT", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        clientPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                        // clientPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                        // if (errno == ERANGE && (clientPORT == LONG_MAX || clientPORT == LONG_MIN)) {
                        //     printf("數字轉換過程中發生溢出.\n");
                        // } else if (endptr == ArgumentValue) {
                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                        // } else {
                        //     printf("轉換結果: %ld\n", clientPORT);
                        // }
                        // printf("%d\n", clientPORT);
                    }

                    if (strncmp(ArgumentKey, "IPversion", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        IPversion = strdup(ArgumentValue);  // "IPv6", "IPv4";
                        // printf("%s\n", IPversion);
                    }

                    if (strncmp(ArgumentKey, "webPath", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        webPath = strdup(ArgumentValue);
                        // printf("%s\n", webPath);
                    }

                    if (strncmp(ArgumentKey, "key", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        key = strdup(ArgumentValue);
                        // printf("%s\n", key);
                    }

                    if (strncmp(ArgumentKey, "time_sleep", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        time_sleep = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
                        // time_sleep = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                        // time_sleep = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                        // if (errno == ERANGE && (time_sleep == LONG_MAX || time_sleep == LONG_MIN)) {
                        //     printf("數字轉換過程中發生溢出.\n");
                        // } else if (endptr == ArgumentValue) {
                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                        // } else {
                        //     printf("轉換結果: %ld\n", time_sleep);
                        // }
                        // printf("%d\n", time_sleep);
                    }

                    if (strncmp(ArgumentKey, "time_out", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        time_out = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
                        // time_out = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
                        // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
                        // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
                        // time_out = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
                        // if (errno == ERANGE && (time_out == LONG_MAX || time_out == LONG_MIN)) {
                        //     printf("數字轉換過程中發生溢出.\n");
                        // } else if (endptr == ArgumentValue) {
                        //     printf("轉換失敗，因為沒有有效的數字.\n");
                        // } else {
                        //     printf("轉換結果: %ld\n", time_out);
                        // }
                        // printf("%d\n", time_out);
                    }

                    if (strncmp(ArgumentKey, "requestURL", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestURL = strdup(ArgumentValue);
                        // printf("%s\n", requestURL);
                    }

                    if (strncmp(ArgumentKey, "requestPath", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestPath = strdup(ArgumentValue);
                        // printf("%s\n", requestPath);
                    }

                    if (strncmp(ArgumentKey, "requestConnection", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestConnection = strdup(ArgumentValue);
                        // printf("%s\n", requestConnection);
                    }

                    if (strncmp(ArgumentKey, "requestFrom", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestFrom = strdup(ArgumentValue);
                        // printf("%s\n", requestFrom);
                    }

                    if (strncmp(ArgumentKey, "requestReferer", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestReferer = strdup(ArgumentValue);
                        // printf("%s\n", requestReferer);
                    }

                    if (strncmp(ArgumentKey, "requestMethod", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        requestMethod = strdup(ArgumentValue);
                        // printf("%s\n", requestMethod);
                    }

                    if (strncmp(ArgumentKey, "requestAuthorization", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        Authorization = strdup(ArgumentValue);
                        // printf("%s\n", Authorization);
                    }

                    if (strncmp(ArgumentKey, "requestCookie", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        Cookie = strdup(ArgumentValue);
                        // printf("%s\n", Cookie);
                    }

                    if (strncmp(ArgumentKey, "session", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        sessionString = strdup(ArgumentValue);
                        // printf("%s\n", sessionString);
                    }

                    if (strncmp(ArgumentKey, "requestData", sizeof(ArgumentKey)) == 0) {
                        // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
                        postData = strdup(ArgumentValue);
                        // printf("%s\n", postData);
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


    // 5、啓動 socket server 或 socket client 或 file monitor 程式;
    if (strncmp(interface_Function_name_str, "tcp_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "TCP_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_TCP_Server", sizeof(interface_Function_name_str)) == 0) {
        socket_Server (
            serverIPaddress,  // Sockets.IPv6(0) or Sockets.IPv6("::1") or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
            serverPORT,  // 0 ~ 65535，監聽埠號（端口）;
            IPversion,  // "IPv6"、"IPv4";
            webPath,  // "C:/Criss/html";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
            do_Request_2,  // 函數對象：do_Request，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
            key,  // ":",  // "username:password",  # 自定義的訪問網站簡單驗證用戶名和密碼;
            sessionString,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
            time_sleep  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        );
    } else if (strncmp(interface_Function_name_str, "http_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_http_Server", sizeof(interface_Function_name_str)) == 0) {
    } else if (strncmp(interface_Function_name_str, "tcp_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "TCP_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_TCP_Client", sizeof(interface_Function_name_str)) == 0) {
        socket_Client (
            clientIPaddress,  // "::1" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
            clientPORT,  // 0 ~ 65535，監聽埠號（端口）;
            IPversion,  // "IPv6"、"IPv4";
            postData,  // Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
            requestURL,  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
            requestPath,  // "/" ;
            requestMethod,  // "POST",  // "GET";  // 請求方法;
            requestProtocol,  // "HTTP" ;
            requestConnection,  // "keep-alive", "close";
            requestFrom,  // "user@email.com" ;
            requestReferer,  // 鏈接來源，輸入值爲 URL 網址字符串;  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
            time_out,  // 0, // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
            Authorization,  // ":",  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
            Cookie,  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
            do_Response_2,  // 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
            // sessionString,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
            time_sleep  // 0,  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        );
    } else if (strncmp(interface_Function_name_str, "http_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_http_Client", sizeof(interface_Function_name_str)) == 0) {
    } else if (strncmp(interface_Function_name_str, "file_Monitor", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "File_Monitor", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_File_Monitor", sizeof(interface_Function_name_str)) == 0) {
        file_Monitor_Run(
            is_Monitor,
            monitor_file,
            monitor_dir,
            do_Data_2,
            output_dir,
            output_file,
            to_executable,
            to_script,
            temp_cache_IO_data_dir,
            time_sleep,
            read_file_do_Function_2,
            write_file_do_Function_2,
            file_Monitor
        );
    } else {}


    // 釋放内存;
    if (strlen(configFile) > 0) {
        free(configFile);
        // configFile = NULL;
    }
    if (strlen(interface_Function_name_str) > 0) {
        free(interface_Function_name_str);
        // interface_Function_name_str = NULL;
    }
    // if (serverPORT > 0) {
    //     free(serverPORT);
    //     // serverPORT = NULL;
    // }
    if (strlen(serverIPaddress) > 0) {
        free(serverIPaddress);
        // serverIPaddress = NULL;
    }
    // if (clientPORT > 0) {
    //     free(clientPORT);
    //     // clientPORT = NULL;
    // }
    if (strlen(clientIPaddress) > 0) {
        free(clientIPaddress);
        // clientIPaddress = NULL;
    }
    if (strlen(IPversion) > 0) {
        free(IPversion);
        // IPversion = NULL;
    }
    if (strlen(webPath) > 0) {
        free(webPath);
        // webPath = NULL;
    }
    if (strlen(requestURL) > 0) {
        free(requestURL);
        // requestURL = NULL;
    }
    if (strlen(requestPath) > 0) {
        free(requestPath);
        // requestPath = NULL;
    }
    if (strlen(requestConnection) > 0) {
        free(requestConnection);
        // requestConnection = NULL;
    }
    if (strlen(requestFrom) > 0) {
        free(requestFrom);
        // requestFrom = NULL;
    }
    if (strlen(requestReferer) > 0) {
        free(requestReferer);
        // requestReferer = NULL;
    }
    if (strlen(Authorization) > 0) {
        free(Authorization);
        // Authorization = NULL;
    }
    if (strlen(Cookie) > 0) {
        free(Cookie);
        // Cookie = NULL;
    }
    if (strlen(monitor_file) > 0) {
        free(monitor_file);
        // monitor_file = NULL;
    }
    if (strlen(monitor_dir) > 0) {
        free(monitor_dir);
        // monitor_dir = NULL;
    }
    if (strlen(output_dir) > 0) {
        free(output_dir);
        // output_dir = NULL;
    }
    if (strlen(output_file) > 0) {
        free(output_file);
        // output_file = NULL;
    }
    if (strlen(temp_cache_IO_data_dir) > 0) {
        free(temp_cache_IO_data_dir);
        // temp_cache_IO_data_dir = NULL;
    }
    // if (strlen(to_executable) > 0) {
    //     free(to_executable);
    //     // to_executable = NULL;
    // }
    // if (strlen(to_script) > 0) {
    //     free(to_script);
    //     // to_script = NULL;
    // }
    if (strlen(key) > 0) {
        free(key);
        // key = NULL;
    }
    if (strlen(sessionString) > 0) {
        free(sessionString);
        // sessionString = NULL;
    }
    if (strlen(postData) > 0) {
        free(postData);
        // postData = NULL;
    }
    // if (strlen(isBlock) > 0) {
    //     free(isBlock);
    //     // isBlock = NULL;
    // }

    return 0;
}
