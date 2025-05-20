/**************************************************************************

// Title: C language Criss v20161211
// Explain: C language socket server and socket client and file monitor
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
// C:\> C:\MinGW64\bin\gcc.exe C:/Criss/c/Interface.c C:/Criss/c/cjson/cJSON.c -o C:/Criss/c/Interface.exe -lm -lws2_32
// root@localhost:~# /usr/bin/gcc /home/Criss/c/Interface.c /home/Criss/c/cjson/cJSON.c -o /home/Criss/c/Interface.exe -lm
// 控制臺顯示中文字符指令;
// root@localhost:~# chcp 65001
// 運行指令：
// C:\> C:/Criss/c/Interface.exe configFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}
// root@localhost:~# /home/Criss/c/Interface.exe configFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}

***************************************************************************/


#ifndef Interface__h

    #define Interface__h

    #ifdef __cplusplus
        extern "C"
    #endif

    char* do_Data (int argc, char *argv);

    char* read_file_do_Function (
        char *monitor_file,
        char *monitor_dir,
        char* (*do_Function)(int, char *),
        char *output_dir,
        char *output_file,
        char *to_executable,
        char *to_script,
        float time_sleep
    );

    char* write_file_do_Function (
        char *monitor_file,
        char *monitor_dir,
        char* (*do_Function)(int, char *),
        char *output_dir,
        char *output_file,
        char *to_executable,
        char *to_script,
        float time_sleep,
        char *buffer_output_file
    );

    int file_Monitor (
        char *monitor_file,  // "C:/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt";
        char *monitor_dir,
        char* (*do_Function)(int, char *),
        char *output_dir,  // "C:/StatisticalServer/Intermediary";
        char *output_file,  // "C:/StatisticalServer/Intermediary/intermediary_write_C.txt";
        char *to_executable,
        char *to_script,
        char *temp_cache_IO_data_dir,
        float time_sleep,
        char* (*read_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float),
        char* (*write_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *)
    );

    int file_Monitor_Run (
        char *is_Monitor,
        char *monitor_file,  // "C:/StatisticalServer/Intermediary/intermediary_write_Nodejs.txt";
        char *monitor_dir,
        char* (*do_Function)(int, char *),
        char *output_dir,  // "C:/StatisticalServer/Intermediary";
        char *output_file,  // "C:/StatisticalServer/Intermediary/intermediary_write_C.txt";
        char *to_executable,
        char *to_script,
        char *temp_cache_IO_data_dir,
        float time_sleep,
        char* (*read_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float),
        char* (*write_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *),
        int (*file_Monitor)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, char *, float, char* (*)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float), char* (*)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *))
    );

    char* do_Request (int argc, char *argv);

    int socket_Server (
        char *host,  // Sockets.IPv6(0) or Sockets.IPv6("::1") or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
        int port,  // 0 ~ 65535，監聽埠號（端口）;
        char *IPversion,  // IPv6, IPv4;
        char *webPath,  // "C:/StatisticalServer/html";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
        char* (*do_Function)(int, char *),  // 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
        char *key,  // ":",  // "username:password",  # 自定義的訪問網站簡單驗證用戶名和密碼;
        char *session,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
        float time_sleep  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
    );

    char* do_Response (int argc, char *argv);

    int socket_Client (
        char *host,  // "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
        int port,  // 0 ~ 65535，監聽埠號（端口）;
        char *IPversion,  // "IPv6"、"IPv4";
        char *postData,  // Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
        char *requestURL,  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
        char *requestPath,  // "/" ;
        char *requestMethod,  // "POST", "GET";  // 請求方法;
        char *requestProtocol,  // "HTTP" ;
        char *requestConnection,  // "keep-alive", "close";
        char *requestFrom,  // "user@email.com" ;
        char *requestReferer,  // 鏈接來源，輸入值爲 URL 網址字符串;  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
        float time_out,  // 0, // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        char *Authorization,  // ":",  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
        char *Cookie,  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
        char* (*do_Function)(int, char *),  // 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
        // char *session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => TCP_Server.key),  // 保存網站的 Session 數據;
        float time_sleep  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
    );

#endif
