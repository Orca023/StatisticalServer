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
// C:\> C:\MinGW64\bin\gcc.exe C:/Criss/c/application.c C:/Criss/c/Interface.c C:/Criss/c/cjson/cJSON.c -o C:/Criss/c/application.exe -lm -lws2_32
// root@localhost:~# /usr/bin/gcc /home/Criss/c/application.c /home/Criss/c/Interface.c /home/Criss/c/cjson/cJSON.c -o /home/Criss/c/application.exe -lm
// 控制臺顯示中文字符指令;
// root@localhost:~# chcp 65001
// 運行指令：
// C:\> C:/Criss/c/application.exe configFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}
// root@localhost:~# /home/Criss/c/application.exe configFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}

***************************************************************************/


#ifndef Router__h

    #define Router__h

    #ifdef __cplusplus
        extern "C"
    #endif

    char* do_Data_2 (int argc, char *argv);

    char* read_file_do_Function_2 (
        char *monitor_file,
        char *monitor_dir,
        char* (*do_Function)(int, char *),
        char *output_dir,
        char *output_file,
        char *to_executable,
        char *to_script,
        float time_sleep
    );

    char* write_file_do_Function_2 (
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

    char* do_Request_2 (int argc, char *argv);

    char* do_Response_2 (int argc, char *argv);

#endif
