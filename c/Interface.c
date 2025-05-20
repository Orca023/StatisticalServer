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


// 1、File server;

// 硬盤文檔服務器端（file_Monitor）的自定義函數，用於處理硬盤文檔用戶端寫入（write）的請求數據;
char* do_Data (int argc, char *argv) {

    // // 獲取當前時間
    // time_t current_time;
    // time(&current_time); 
    // // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
    // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
    // // 定義一個足夠大的字符串來保存日期和時間
    // char now_time_string[80];
    // // 使用 strftime 將時間格式化為字符串
    // // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
    // // printf("當前時間是：%s\n", now_time_string);
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
    // // printf("UTC time: %s\n", now_time_string);
    // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    int i = 0;
    // size_t argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    int argv_len = 1024;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    char *byteArray = (char*)malloc(argv_len * sizeof(char));
    // char byteArray[argv_len];
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory allocation failed.\n");
        return ("Memory allocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    // 重新分配内存以适应新长度;
    byteArray = (char*)realloc(byteArray, argv_len * sizeof(char));  // 重新分配内存以适应新长度;
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory reallocation failed.\n");
        return ("Memory reallocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));

    // // 使用for循环遍历字符串;
    // for (i = 0; argv[i] != '\0'; i++) {
    //     // printf("%c", argv[i]);
    //     if (i < sizeMalloc(byteArray)) {
    //         byteArray[i] = argv[i];
    //     }
    // }
    // byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // byteArray[sizeMalloc(byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    // 響應值，將運算結果變量 argv 傳值複製到響應值變量 byteArray 内;
    strncpy(byteArray, argv, sizeMalloc(byteArray) - 1);  // 確保留出空間給終止字符：'\0';
    byteArray[sizeMalloc(byteArray) - 1] = '\0';  // 確保終止字符：'\0' 存在;
    // strcpy(byteArray, argv);
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    return byteArray;
}
// char *result = do_Data(0, "");
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;


// 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
char* read_file_do_Function (
    char *monitor_file,  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    char *monitor_dir,
    char* (*do_Function)(int, char *),
    char *output_dir,  // "C:/Criss/Intermediary";
    char *output_file,  // "C:/Criss/Intermediary/intermediary_write_C.txt";
    char *to_executable,
    char *to_script,
    float time_sleep
) {

    // 代碼首部自定義的常量：BUFFER_LEN_request = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求用於傳入數據的（監聽文檔）monitor_file 内最多不得超過 1024 個字符;
    char* buffer_monitor_file_byteArray = (char*)malloc(BUFFER_LEN_request * sizeof(char));
    // 檢查 malloc 是否成功;
    if (buffer_monitor_file_byteArray == NULL) {
        // perror("Error, read_file_do_Function : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
        printf("Error, read_file_do_Function : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
        return "Error, read_file_do_Function : Memory allocation failed monitor_file.";
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取内存緩衝區的字節（8*bit）數;

    // printf("用於傳入數據的（監聽文檔）（monitor_file）的保存路徑爲：\n%s\n", monitor_file);  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    // 讀取用於傳入數據的（監聽文檔）：monitor_file 内傳入的待計算處理的數據;
    if (strlen(monitor_file) > 0) {

        FILE *file = fopen(monitor_file, "rb");  // rt、rb、wt、wb、a、r+、w+、a+;

        if (file == NULL) {
            // perror("Error, read_file_do_Function : open failed monitor_file [ %s ].\n", monitor_file);
            // printf("無法打開用於傳入數據的（監聽文檔）：\nmonitor file = %s\n", monitor_file);
            printf("Error, read_file_do_Function : open failed monitor_file [ %s ].\n", monitor_file);
            fclose(file);  // 關閉文檔;
            return "Error, read_file_do_Function : open failed monitor_file.";
            // exit(1);
        }

        if (file != NULL) {
            // printf("正在讀取用於傳入數據的（監聽文檔）：\nmonitor_file = %s\n", monitor_file);  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
            // printf("monitor_file = %s\n", monitor_file);  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";

            // 使用：fread(buffer_monitor_file_byteArray, length_monitor_file, 1, file) 函數，一次讀入文檔中的全部内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
            fseek(file, 0, SEEK_END);  // 定位文檔指針到文檔末尾;
            long length_monitor_file = ftell(file);  // 計算文檔所包含的字符個數長度;
            length_monitor_file = length_monitor_file + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0'（值爲：NULL）;
            // printf("monitor file string length : %d\n", length_monitor_file);
            // 重新分配内存以适应新长度;
            buffer_monitor_file_byteArray = (char*)realloc(buffer_monitor_file_byteArray, length_monitor_file * sizeof(char));  // 修改自定義聲明的緩衝區内存大小，重新動態内存分配以適應新長度，按照上一步識別的文檔大小，申請内存緩衝區存儲文檔内容;
            // 檢查 malloc 是否成功;
            if (buffer_monitor_file_byteArray == NULL) {
                // perror("Error, read_file_do_Function : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                printf("Error, read_file_do_Function : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                fclose(file);  // 關閉文檔;
                return "Error, read_file_do_Function : Memory reallocation failed monitor_file.";  // 或者適當的錯誤處理;
                // exit(1);
            }
            // printf("Input string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取内存緩衝區的字節（8*bit）數;
            fseek(file, 0, SEEK_SET);  // 將文檔指針重新移動到文檔的開頭;
            fread(buffer_monitor_file_byteArray, length_monitor_file, 1, file);  // 讀入文檔中的全部内容到内存緩衝區（buffer_monitor_file_byteArray）;
            // size_t bytes_readen = fread(buffer_monitor_file_byteArray, length_monitor_file, 1, file);  // 讀入文檔中的全部内容到内存緩衝區（buffer_monitor_file_byteArray）;
            // if (bytes_readen != length_monitor_file) {
            //     // perror("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
            //     // printf("錯誤讀取用於傳入數據的（監聽文檔）：\nmonitor file = %s\n", monitor_file);
            //     printf("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
            //     fclose(file);  // 關閉文檔;
            //     // return "Error, read_file_do_Function : read failed monitor_file.";
            //     // exit(1);
            // }
            // printf("bytes readen : %d\n", bytes_readen);
            // printf("length monitor file : %d\n", (length_monitor_file - 1));
            // buffer_monitor_file_byteArray[length_monitor_file] = '\0';  // 在内存緩衝區（buffer_monitor_file_byteArray）儲存的文檔内容的末尾添加字符串結束字符（'\0'）（值爲：NULL）;
            // printf("monitor file string :\n%s\n", buffer_monitor_file_byteArray);
            fclose(file);  // 關閉文檔;
            // free(buffer_monitor_file_byteArray);  // 釋放内存緩衝區（buffer_monitor_file_byteArray）;

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
            // free(buffer_monitor_file_byteArray);  // 釋放内存緩衝區（buffer_monitor_file_byteArray）;

            // // 使用：fgets(buffer_monitor_file_byteArray, sizeof(buffer_monitor_file_byteArray), file) 函數，逐個橫向列（row）讀入文檔中的内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
            // char buffer_monitor_file_byteArray[BUFFER_LEN_request];  // 代碼首部自定義的常量：BUFFER_LEN_request = 1024，靜態申請内存緩衝區（buffer_monitor_file_byteArray），存儲文檔每一個橫向列（row）中的内容，要求監聽文檔：monitor_file 中每一個橫向列（row）最多不得超過 1024 個字符;
            // while (fgets(buffer_monitor_file_byteArray, sizeof(buffer_monitor_file_byteArray), file) != NULL) {
            //     // printf("%s\n", buffer_monitor_file_byteArray);
            //     memset(buffer_monitor_file_byteArray, 0, sizeof(buffer_monitor_file_byteArray));  // 初始化清空内存緩衝區（buffer_monitor_file_byteArray）;
            // }
            // fclose(file);  // 關閉文檔;
            // free(buffer_monitor_file_byteArray);  // 釋放内存緩衝區（buffer_monitor_file_byteArray）;
        }

    } else {

        // printf("用於傳入數據的（監聽文檔）的保存路徑參數爲空：\nmonitor_file = %s\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        printf("Unrecognized monitor_file : [ %s ].\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        // return ("monitor_file = %s\n", monitor_file);
        // exit(1);
    }

    // free(buffer_monitor_file_byteArray);  // 釋放内存緩衝區（buffer_monitor_file_byteArray）;

    return buffer_monitor_file_byteArray;
}
// char *result = read_file_do_Function(
//     monitor_file,
//     monitor_dir,
//     do_Data,
//     output_dir,
//     output_file,
//     to_executable,
//     to_script,
//     time_sleep
// );
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;


// 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
char* write_file_do_Function (
    char *monitor_file,  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    char *monitor_dir,
    char* (*do_Function)(int, char *),
    char *output_dir,  // "C:/Criss/Intermediary";
    char *output_file,  // "C:/Criss/Intermediary/intermediary_write_C.txt";
    char *to_executable,
    char *to_script,
    float time_sleep,
    char *buffer_output_file
) {

    int i = 0, j = 0;  // 聲明循環變量;

    // size_t buffer_output_file_length = strlen(buffer_output_file) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
    int buffer_output_file_length = BUFFER_LEN_response;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
    // printf("output file string length : %d\n", buffer_output_file_length);
    char *buffer_output_file_byteArray = (char*)malloc(buffer_output_file_length * sizeof(char));
    // char buffer_output_file_byteArray[BUFFER_LEN_response];  // 代碼首部自定義的常量：BUFFER_LEN_response = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求用於傳出數據的（輸出文檔）output_file 内最多不得超過 1024 個字符;
    // 檢查 malloc 是否成功;
    if (buffer_output_file_byteArray == NULL) {
        // perror("Error, write_file_do_Function : Memory allocation failed output_file [ %s ].\n", output_file);
        printf("Error, write_file_do_Function : Memory allocation failed output_file [ %s ].\n", output_file);
        return "Error, write_file_do_Function : Memory allocation failed output_file."; // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));  // 函數：sizeMalloc(buffer_output_file_byteArray) 表示獲取堆内存緩衝區（buffer）字節數（8 * bit）的長度;
    buffer_output_file_length = strlen(buffer_output_file) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
    // printf("output file string length : %d\n", buffer_output_file_length);
    // 重新分配内存以适应新长度;
    buffer_output_file_byteArray = (char*)realloc(buffer_output_file_byteArray, buffer_output_file_length * sizeof(char));  // 重新分配内存以适应新长度;
    // 檢查 malloc 是否成功;
    if (buffer_output_file_byteArray == NULL) {
        // perror("Error, write_file_do_Function : Memory reallocation failed output_file [ %s ].\n", output_file);
        printf("Error, write_file_do_Function : Memory reallocation failed output_file [ %s ].\n", output_file);
        return "Error, write_file_do_Function : Memory reallocation failed output_file."; // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));  // 函數：sizeMalloc(buffer_output_file_byteArray) 表示獲取堆内存緩衝區（buffer）字節數（8 * bit）的長度;

    // // 使用for循环遍历字符串;
    // // int i = 0;
    // for (i = 0; buffer_output_file[i] != '\0'; i++) {
    //     // printf("%c", buffer_output_file[i]);
    //     if (i < sizeMalloc(buffer_output_file_byteArray)) {
    //         buffer_output_file_byteArray[i] = buffer_output_file[i];
    //     }
    // }
    // buffer_output_file_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
    // printf("output file string :\n%s\n", buffer_output_file_byteArray);

    // 響應值，將運算結果變量 buffer_output_file 傳值複製到響應值變量 buffer_output_file_byteArray 内;
    strncpy(buffer_output_file_byteArray, buffer_output_file, sizeMalloc(buffer_output_file_byteArray) - 1);  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
    // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
    // strcpy(buffer_output_file_byteArray, buffer_output_file);
    // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
    // printf("output file string :\n%s\n", buffer_output_file_byteArray);

    // printf("用於傳出數據的（輸出文檔）（output_file）的保存路徑爲：\n%s\n", output_file);  // "C:/Criss/Intermediary/intermediary_write_C.txt";
    // 寫入用於傳出數據的（輸出文檔）：output_file 計算結果數據;
    if (strlen(output_file) > 0) {

        FILE *file = fopen(output_file, "wb");  // rt、rb、wt、wb、a、r+、w+、a+;

        if (file == NULL) {
            // perror("Error, write_file_do_Function : open failed output_file [ %s ].\n", output_file);
            // printf("無法打開用於傳出數據的（輸出文檔）：\noutput file = %s\n", output_file);
            printf("Error, write_file_do_Function : open failed output_file [ %s ].\n", output_file);
            fclose(file);  // 關閉文檔;
            return "Error, write_file_do_Function : open failed output_file.";
            // exit(1);
        }

        if (file != NULL) {
            // printf("正在寫入用於傳出數據的（輸出文檔）：\noutput_file = %s\n", output_file);  // "C:/Criss/Intermediary/intermediary_write_C.txt";
            // printf("output_file = %s\n", output_file);  // "C:/Criss/Intermediary/intermediary_write_C.txt";

            // // 寫入二進位數組只有一個元素時（例如圖片、音頻數據）等數據至硬體文檔;
            // size_t bytes_written = fwrite(buffer_output_file_byteArray, sizeof(buffer_output_file_byteArray[0]), 1, file);  // 寫入二進位數據（例如圖片、音頻數據）至硬體文檔;

            // // 寫入整型二進位數據（例如圖片、音頻數據）至硬體文檔;
            // size_t bytes_written = fwrite(buffer_output_file_byteArray, sizeof(int), (sizeMalloc(buffer_output_file_byteArray) / sizeof(int)), file);  // 寫入整型二進位數據（例如圖片、音頻數據）至硬體文檔;
            // if (bytes_written != (sizeMalloc(buffer_output_file_byteArray) / sizeof(int))) {
            //     // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
            //     // printf("錯誤寫入用於傳出數據的（輸出文檔）：\noutput_file = %s\n", output_file);
            //     printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
            //     fclose(file);  // 關閉文檔;
            //     // return "Error, write_file_do_Function : write failed output_file.";
            //     // exit(1);
            // }
            // // // 使用 for 循环遍历寫入整型二進位字節;
            // // // int i = 0;
            // // for (i = 0; i < sizeMalloc(buffer_output_file_byteArray); i++) {
            // //     // printf("%c", buffer_output_file_byteArray[i]);
            // //     fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // // }
            // printf("bytes_written : %d\n", bytes_written);
            // printf("bytes_written : %d\n", (buffer_output_file_length - 1));

            // 寫入字符串至硬體文檔，但不包括字符串末位的終止符：'\0'（值爲：NULL）;
            size_t bytes_written = fwrite(buffer_output_file_byteArray, sizeof(char), (buffer_output_file_length - 1), file);  // 寫入字符串至硬體文檔，但不包括字符串末位的終止符：'\0'（值爲：NULL）;
            // printf("%d\n", ((buffer_output_file_length - 1) / sizeof(char)));
            // printf(bytes_written == ((buffer_output_file_length - 1) / sizeof(char)) ? "true" : "false");
            if (bytes_written != ((buffer_output_file_length - 1) / sizeof(char))) {
                // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                // printf("錯誤寫入用於傳出數據的（輸出文檔）：\noutput_file = %s\n", output_file);
                printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                fclose(file);  // 關閉文檔;
                return "Error, write_file_do_Function : write failed output_file.";
                // exit(1);
            }
            // // 使用 for 循环遍历寫入字符;
            // // int i = 0;
            // for (i = 0; buffer_output_file_byteArray[i] != '\0'; i++) {
            //     // printf("%c", buffer_output_file_byteArray[i]);
            //     if (buffer_output_file_byteArray[i] != '\0') {
            //         fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            //     }
            // }
            // printf("bytes_written : %d\n", bytes_written);
            // printf("length output file buffer : %d\n", (buffer_output_file_length - 1));

            // // 寫入一列（Row）數據;
            // fputs("一列（Row）數據\n", file);  // 寫入一列（Row）數據;
            // // // 使用 for 循环遍历寫入字符;
            // // // int i = 0;
            // // for (i = 0; buffer_output_file_byteArray[i] != '\0'; i++) {
            // //     // printf("%c", buffer_output_file_byteArray[i]);
            // //     if (buffer_output_file_byteArray[i] != '\n') {
            // //         fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // //         break;  // 遇到換行符則，則中斷 for 循環，並同時跳出 for 循環;
            // //     }
            // //     if (buffer_output_file_byteArray[i] != '\0') {
            // //         fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // //     }
            // // }
            // // // 使用 for 循环遍历寫入整型二進位字節;
            // // // int i = 0;
            // // for (i = 0; i < sizeMalloc(buffer_output_file_byteArray); i++) {
            // //     // printf("%c", buffer_output_file_byteArray[i]);
            // //     if (buffer_output_file_byteArray[i] != '\n') {
            // //         fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // //         break;  // 遇到換行符則，則中斷 for 循環，並同時跳出 for 循環;
            // //     }
            // //     fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // // }

            // // 寫入一個字符（Character）數據;
            // fputc('\n', file);  // 寫入一個字符（Character）數據;
            // // // 使用 for 循环遍历寫入字符;
            // // // int i = 0;
            // // for (i = 0; buffer_output_file_byteArray[i] != '\0'; i++) {
            // //     // printf("%c", buffer_output_file_byteArray[i]);
            // //     if (buffer_output_file_byteArray[i] != '\0') {
            // //         fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // //     }
            // // }
            // // // 使用 for 循环遍历寫入整型二進位字節;
            // // // int i = 0;
            // // for (i = 0; i < sizeMalloc(buffer_output_file_byteArray); i++) {
            // //     // printf("%c", buffer_output_file_byteArray[i]);
            // //     fputc(buffer_output_file_byteArray[i], file);  // 寫入一個字符（Character）數據;
            // // }

            fclose(file);  // 關閉文檔;
        }

    } else {

        // printf("用於傳出數據的（輸出文檔）的保存路徑參數爲空：\noutput_file = %s\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
        printf("Unrecognized output_file : [ %s ].\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
        // // return ("output_file = %s\n", output_file);
        // // exit(1);
    }

    // free(buffer_output_file_byteArray);  // 釋放内存緩衝區（buffer_output_file_byteArray）;

    return buffer_output_file_byteArray;
}
// char *result = write_file_do_Function(
//     monitor_file,
//     monitor_dir,
//     do_Data,
//     output_dir,
//     output_file,
//     to_executable,
//     to_script,
//     time_sleep,
//     buffer_output_file
// );
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;


// 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
int file_Monitor (
    char *monitor_file,  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    char *monitor_dir,
    char* (*do_Function)(int, char *),
    char *output_dir,  // "C:/Criss/Intermediary";
    char *output_file,  // "C:/Criss/Intermediary/intermediary_write_C.txt";
    char *to_executable,
    char *to_script,
    char *temp_cache_IO_data_dir,
    float time_sleep,
    char* (*read_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float),
    char* (*write_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *)
) {
    // // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;
    // signal(SIGINT, signalHandler);  // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;

    // printf("用於傳入數據的（監聽文檔）（monitor_file）的保存路徑爲：\n%s\n", monitor_file);  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    // 讀取用於傳入數據的（監聽文檔）：monitor_file 内傳入的待計算處理的數據;
    if (strlen(monitor_file) > 0) {
        printf("listening to the path : [ %s ] ...\n", monitor_file);

        // 獲取當前時間
        time_t current_time;
        time(&current_time); 
        struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
        // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
        // 定義一個足夠大的字符串來保存日期和時間
        char now_time_string[80];
        // 使用 strftime 將時間格式化為字符串
        // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
        // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
        // printf("當前時間是：%s\n", now_time_string);
        // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
        // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
        // printf("UTC time: %s\n", now_time_string);
        // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

        while (1) {

            // // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;
            // signal(SIGINT, signalHandler);  // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;

            if (access(monitor_file, F_OK) != -1) {

                time(&current_time); 
                local_time = localtime(&current_time);  // 將時間轉換為本地時間;
                memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;
                strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", local_time);
                printf("%s %s %s\n", now_time_string, monitor_file, output_file);

                char *result_read_file_do_Function = read_file_do_Function(
                    monitor_file,
                    monitor_dir,
                    do_Function,
                    output_dir,
                    output_file,
                    to_executable,
                    to_script,
                    time_sleep
                );
                if (result_read_file_do_Function == NULL) {
                    // perror("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    printf("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, read_file_do_Function : read failed monitor_file.";
                    // exit(1);
                }

                // 判斷讀取文檔動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                if (strncmp(result_read_file_do_Function, "Error,", 6) == 0) {
                    // perror("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    printf("%s\n", result_read_file_do_Function);
                    printf("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, read_file_do_Function : read failed monitor_file.";
                    // exit(1);
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(result_read_file_do_Function, "exit", sizeof(result_read_file_do_Function)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", result_read_file_do_Function);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(result_read_file_do_Function, 0x00, sizeof(result_read_file_do_Function));
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    break;
                    // return "Client request : [ exit ] received, Program aborted.";
                    // exit(signum);
                    // exit(2);
                }

                int buffer_monitor_file_length = BUFFER_LEN_request;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("monitor file string length : %d\n", buffer_monitor_file_length);
                // char buffer_monitor_file_byteArray[BUFFER_LEN_request];  // 代碼首部自定義的常量：BUFFER_LEN_request = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求用於傳入數據的（監聽文檔）monitor_file 内最多不得超過 1024 個字符;
                char* buffer_monitor_file_byteArray = (char*)malloc(buffer_monitor_file_length * sizeof(char));
                // 檢查 malloc 是否成功;
                if (buffer_monitor_file_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
                    // printf("file_Monitor : monitor file Memory allocation failed.\n");
                    printf("Error, file_Monitor : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, file_Monitor : Memory allocation failed monitor_file.";  // 或者適當的錯誤處理;
                    // exit(1);
                }
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                buffer_monitor_file_length = strlen(result_read_file_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("monitor file string length : %d\n", buffer_monitor_file_length);
                // 重新分配内存以适应新长度;
                buffer_monitor_file_byteArray = (char*)realloc(buffer_monitor_file_byteArray, buffer_monitor_file_length * sizeof(char));  // 重新分配内存以适应新长度;
                // 檢查 malloc 是否成功;
                if (buffer_monitor_file_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                    // printf("Error, file_Monitor : output file Memory reallocation failed.\n");
                    printf("Error, file_Monitor : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, file_Monitor : Memory reallocation failed monitor_file.";  // 或者適當的錯誤處理;
                    // exit(1);
                }
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取堆内存緩衝區（buffer）字節數（8 * bit）的長度;

                // // 使用for循环遍历字符串;
                // // int i = 0;
                // for (i = 0; result_read_file_do_Function[i] != '\0'; i++) {
                //     // printf("%c", result_read_file_do_Function[i]);
                //     if (i < sizeMalloc(buffer_monitor_file_byteArray)) {
                //         buffer_monitor_file_byteArray[i] = result_read_file_do_Function[i];
                //     }
                // }
                // buffer_monitor_file_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // buffer_monitor_file_byteArray[sizeMalloc(buffer_monitor_file_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));
                // printf("monitor file string :\n%s\n", buffer_monitor_file_byteArray);

                // 響應值，將保存讀取傳入文檔數據的變量 result_read_file_do_Function 傳值複製到内存緩衝區變量 buffer_monitor_file_byteArray 内;
                strncpy(buffer_monitor_file_byteArray, result_read_file_do_Function, (sizeMalloc(buffer_monitor_file_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                // buffer_monitor_file_byteArray[sizeMalloc(buffer_monitor_file_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                // strcpy(buffer_monitor_file_byteArray, result_read_file_do_Function);
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));
                // printf("monitor file string :\n%s\n", buffer_monitor_file_byteArray);

                free(result_read_file_do_Function);  // 釋放内存防止溢出;

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(buffer_monitor_file_byteArray, "exit", (sizeMalloc(buffer_monitor_file_byteArray) - 1)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_monitor_file_byteArray);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                //     free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                //     // continue;  // 跳過本輪循環;
                //     break;  // 跳出 while 循環;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     // exit(signum);
                //     // exit(2);
                // }


                char *result_do_Function = do_Function(
                    0,
                    buffer_monitor_file_byteArray
                );
                if (result_do_Function == NULL) {
                    // perror("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    printf("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, do_Function : do failed monitor_file.";
                    // exit(1);
                }

                // 判斷計算處理動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                if (strncmp(result_do_Function, "Error,", 6) == 0) {
                    // perror("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    printf("%s\n", result_do_Function);
                    printf("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, do_Function : do failed monitor_file.";
                    // exit(1);
                }

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(result_do_Function, "exit", sizeof(result_do_Function)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", result_do_Function);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                //     free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                //     free(result_do_Function);  // 釋放内存防止溢出;
                //     break;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     // exit(signum);
                //     // exit(2);
                // }

                int buffer_return_do_Function_length = BUFFER_LEN_response;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("do_Function return string length : %d\n", buffer_return_do_Function_length);
                // char buffer_return_do_Function_byteArray[BUFFER_LEN_response];  // 代碼首部自定義的常量：BUFFER_LEN_response = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求最多不得超過 1024 個字符;
                char* buffer_return_do_Function_byteArray = (char*)malloc(buffer_return_do_Function_length * sizeof(char));
                // 檢查 malloc 是否成功;
                if (buffer_return_do_Function_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory allocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    // printf("file_Monitor : return_do_Function Memory allocation failed.\n");
                    printf("Error, file_Monitor : Memory allocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, file_Monitor : Memory allocation failed return_do_Function monitor_file.";  // 或者適當的錯誤處理;
                    // exit(1);
                }
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                buffer_return_do_Function_length = strlen(result_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("do_Function return string length : %d\n", buffer_return_do_Function_length);
                // 重新分配内存以适应新长度;
                buffer_return_do_Function_byteArray = (char*)realloc(buffer_return_do_Function_byteArray, buffer_return_do_Function_length * sizeof(char));  // 重新分配内存以适应新长度;
                // 檢查 malloc 是否成功;
                if (buffer_return_do_Function_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    // printf("Error, file_Monitor : return_do_Function Memory reallocation failed.\n");
                    printf("Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return "Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file.";  // 或者適當的錯誤處理;
                    // exit(1);
                }
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_length));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區（buffer）字節數（8 * bit）的長度;

                // // 使用for循环遍历字符串;
                // // int i = 0;
                // for (i = 0; result_do_Function[i] != '\0'; i++) {
                //     // printf("%c", result_do_Function[i]);
                //     if (i < sizeMalloc(buffer_return_do_Function_byteArray)) {
                //         buffer_return_do_Function_byteArray[i] = result_do_Function[i];
                //     }
                // }
                // buffer_return_do_Function_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // buffer_return_do_Function_byteArray[sizeMalloc(buffer_return_do_Function_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));
                // printf("do_Function return string :\n%s\n", buffer_return_do_Function_byteArray);

                // 響應值，將保存計算結果數據的變量 result_do_Function 傳值複製到内存緩衝區變量 buffer_return_do_Function_byteArray 内;
                strncpy(buffer_return_do_Function_byteArray, result_do_Function, (sizeMalloc(buffer_return_do_Function_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                // buffer_return_do_Function_byteArray[sizeMalloc(buffer_return_do_Function_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                // strcpy(buffer_return_do_Function_byteArray, result_do_Function);
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));
                // printf("do_Function return string :\n%s\n", buffer_return_do_Function_byteArray);

                free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                free(result_do_Function);  // 釋放内存防止溢出;

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(buffer_return_do_Function_byteArray, "exit", (sizeMalloc(buffer_return_do_Function_byteArray) - 1)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_return_do_Function_byteArray);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                //     free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                //     // continue;  // 跳過本輪循環;
                //     break;  // 跳出 while 循環;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     // exit(signum);
                //     // exit(2);
                // }


                // 當完成讀取文檔數據動作之後，刪除監聽文檔（monitor_file）;
                size_t return_remove_monitor_file = remove(monitor_file);
                if (return_remove_monitor_file != 0) {
                    // printf("當完成讀取文檔數據動作之後，嘗試刪除監聽文檔時發生錯誤.\nmonitor_file = [ %s ].\n", monitor_file);
                    printf("Error, file_Monitor : remove failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    // continue;  // 跳過本輪循環;
                    break;  // 跳出 while 循環;
                    // return "Error, file_Monitor : remove failed monitor_file.";
                    // exit(signum);
                    // exit(2);
                }


                // printf("用於傳出數據的（輸出文檔）（output_file）的保存路徑爲：\n%s\n", output_file);  // "C:/Criss/Intermediary/intermediary_write_C.txt";
                // 寫入用於傳出數據的（輸出文檔）：output_file 計算結果數據;
                if (strlen(output_file) > 0) {

                    if (access(output_dir, F_OK) != -1) {

                        char *result_write_file_do_Function = write_file_do_Function(
                            monitor_file,
                            monitor_dir,
                            do_Function,
                            output_dir,
                            output_file,
                            to_executable,
                            to_script,
                            time_sleep,
                            buffer_return_do_Function_byteArray
                        );
                        if (result_write_file_do_Function == NULL) {
                            // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            continue;  // 跳過本輪循環;
                            // break;  // 跳出 while 循環;
                            // return "Error, write_file_do_Function : write failed output_file.";
                            // exit(1);
                        }

                        // 判斷寫入文檔動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                        if (strncmp(result_write_file_do_Function, "Error,", 6) == 0) {
                            // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            printf("%s\n", result_write_file_do_Function);
                            printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            continue;  // 跳過本輪循環;
                            // break;  // 跳出 while 循環;
                            // return "Error, write_file_do_Function : write failed output_file.";
                            // exit(1);
                        }

                        // // 判斷信號值（signum）是否爲「Ctrl+c」;
                        // // if (signum == 2) {
                        // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                        // if (strncmp(result_write_file_do_Function, "exit", sizeof(result_write_file_do_Function)) == 0) {
                        //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", result_write_file_do_Function);
                        //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        //     memset(buffer_return_do_Function_byteArray, 0x00, sizeof(buffer_return_do_Function_byteArray));
                        //     free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                        //     free(result_write_file_do_Function);  // 釋放内存防止溢出;
                        //     break;
                        //     // return "Client request : [ exit ] received, Program aborted.";
                        //     // exit(signum);
                        //     // exit(2);
                        // }

                        int buffer_output_file_length = BUFFER_LEN_response;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                        // printf("output file string length : %d\n", buffer_output_file_length);
                        // char buffer_output_file_byteArray[BUFFER_LEN_response];  // 代碼首部自定義的常量：BUFFER_LEN_response = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求最多不得超過 1024 個字符;
                        char* buffer_output_file_byteArray = (char*)malloc(buffer_output_file_length * sizeof(char));
                        // 檢查 malloc 是否成功;
                        if (buffer_output_file_byteArray == NULL) {
                            // perror("Error, file_Monitor : Memory allocation failed output_file [ %s ].\n", output_file);
                            // printf("file_Monitor : output_file Memory allocation failed.\n");
                            printf("Error, file_Monitor : Memory allocation failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                            free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                            continue;  // 跳過本輪循環;
                            // break;  // 跳出 while 循環;
                            // return "Error, file_Monitor : Memory allocation failed output_file.";  // 或者適當的錯誤處理;
                            // exit(1);
                        }
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                        buffer_output_file_length = strlen(result_write_file_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                        // printf("output file string length : %d\n", buffer_output_file_length);
                        // 重新分配内存以适应新长度;
                        buffer_output_file_byteArray = (char*)realloc(buffer_output_file_byteArray, buffer_output_file_length * sizeof(char));  // 重新分配内存以适应新长度;
                        // 檢查 malloc 是否成功;
                        if (buffer_output_file_byteArray == NULL) {
                            // perror("Error, file_Monitor : Memory reallocation failed output_file [ %s ].\n", output_file);
                            // printf("Error, file_Monitor : output_file Memory reallocation failed.\n");
                            printf("Error, file_Monitor : Memory reallocation failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                            free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                            continue;  // 跳過本輪循環;
                            // break;  // 跳出 while 循環;
                            // return "Error, file_Monitor : Memory reallocation failed output_file.";  // 或者適當的錯誤處理;
                            // exit(1);
                        }
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_length));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區（buffer）字節數（8 * bit）的長度;

                        // // 使用for循环遍历字符串;
                        // // int i = 0;
                        // for (i = 0; result_write_file_do_Function[i] != '\0'; i++) {
                        //     // printf("%c", result_write_file_do_Function[i]);
                        //     if (i < sizeMalloc(buffer_output_file_byteArray)) {
                        //         buffer_output_file_byteArray[i] = result_write_file_do_Function[i];
                        //     }
                        // }
                        // buffer_output_file_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                        // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
                        // printf("output file string :\n%s\n", buffer_output_file_byteArray);

                        // 響應值，將保存寫入文檔函數返回數據的變量 result_write_file_do_Function 傳值複製到内存緩衝區變量 buffer_output_file_byteArray 内;
                        strncpy(buffer_output_file_byteArray, result_write_file_do_Function, (sizeMalloc(buffer_output_file_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                        // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                        // strcpy(buffer_output_file_byteArray, result_write_file_do_Function);
                        // printf("output file return string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
                        // printf("output file return string :\n%s\n", buffer_output_file_byteArray);

                        free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                        free(result_write_file_do_Function);  // 釋放内存防止溢出;

                        // // 判斷信號值（signum）是否爲「Ctrl+c」;
                        // // if (signum == 2) {
                        // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                        // if (strncmp(buffer_output_file_byteArray, "exit", (sizeMalloc(buffer_output_file_byteArray) - 1)) == 0) {
                        //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_output_file_byteArray);
                        //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        //     memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                        //     free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                        //     // continue;  // 跳過本輪循環;
                        //     break;  // 跳出 while 循環;
                        //     // return "Client request : [ exit ] received, Program aborted.";
                        //     // exit(signum);
                        //     // exit(2);
                        // }

                        free(buffer_output_file_byteArray);  // 釋放内存防止溢出;

                    } else {
                        // printf("用於傳出數據的（輸出文檔）的保存路徑（文件夾）無法識別：\noutput_dir = %s\n", output_dir);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/";
                        // printf("Unrecognized output_directory : [ %s ].\n", output_dir);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/";
                        // continue;  // 跳過本輪循環;
                        // break;  // 跳出 while 循環;
                        // return ("Unrecognized output_dir : [ %s ].\n", output_dir);
                        // exit(1);
                    }

                } else {
                    // printf("用於傳出數據的（輸出文檔）的保存路徑參數爲空：\noutput_file = %s\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
                    // printf("Unrecognized output_file : [ %s ].\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
                    // continue;  // 跳過本輪循環;
                    // break;  // 跳出 while 循環;
                    // return ("Unrecognized output_file : [ %s ].\n", output_file);
                    // exit(1);
                }

            } else {
                // printf("用於傳入數據的（監聽文檔）的保存路徑參數爲空：\nmonitor_file = %s\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
                // printf("Unrecognized monitor_file : [ %s ].\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
                // return ("Unrecognized monitor_file : [ %s ].\n", monitor_file);
                // exit(1);
            }

            memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

            sleep(time_sleep);  // 暫停，延時等待;
        }

        // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    } else {
        // printf("用於傳入數據的（監聽文檔）的保存路徑參數爲空：\nmonitor_file = %s\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        printf("Unrecognized monitor_file : [ %s ].\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        // // return ("Unrecognized monitor_file : [ %s ].\n", monitor_file);
        // // exit(1);
    }

    return 0;
}


// 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
int file_Monitor_Run (
    char *is_Monitor,
    char *monitor_file,  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    char *monitor_dir,
    char* (*do_Function)(int, char *),
    char *output_dir,  // "C:/Criss/Intermediary";
    char *output_file,  // "C:/Criss/Intermediary/intermediary_write_C.txt";
    char *to_executable,
    char *to_script,
    char *temp_cache_IO_data_dir,
    float time_sleep,
    char* (*read_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float),
    char* (*write_file_do_Function)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *),
    int (*file_Monitor)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, char *, float, char* (*)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float), char* (*)(char *, char *, char* (*)(int, char *), char *, char *, char *, char *, float, char *))
) {
    // // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;
    // signal(SIGINT, signalHandler);  // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;

    // printf("用於傳入數據的（監聽文檔）（monitor_file）的保存路徑爲：\n%s\n", monitor_file);  // "C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
    // 讀取用於傳入數據的（監聽文檔）：monitor_file 内傳入的待計算處理的數據;
    if (strlen(monitor_file) > 0) {

        if (strncmp(is_Monitor, "1", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "true", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "True", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "TRUE", sizeof(is_Monitor)) == 0) {

            file_Monitor(
                monitor_file,
                monitor_dir,
                do_Function,
                output_dir,
                output_file,
                to_executable,
                to_script,
                temp_cache_IO_data_dir,
                time_sleep,
                read_file_do_Function,
                write_file_do_Function
            );

        } else if (strncmp(is_Monitor, "0", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "false", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "False", sizeof(is_Monitor)) == 0 || strncmp(is_Monitor, "FALSE", sizeof(is_Monitor)) == 0) {

            if (access(monitor_file, F_OK) != -1) {

                // 獲取當前時間
                time_t current_time;
                time(&current_time); 
                struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
                // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
                // 定義一個足夠大的字符串來保存日期和時間
                char now_time_string[80];
                memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;
                // 使用 strftime 將時間格式化為字符串
                // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
                // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
                // printf("當前時間是：%s\n", now_time_string);
                // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
                // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
                // printf("UTC time: %s\n", now_time_string);
                strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", local_time);
                printf("%s %s %s\n", now_time_string, monitor_file, output_file);
                memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

                char *result_read_file_do_Function = read_file_do_Function(
                    monitor_file,
                    monitor_dir,
                    do_Function,
                    output_dir,
                    output_file,
                    to_executable,
                    to_script,
                    time_sleep
                );
                if (result_read_file_do_Function == NULL) {
                    // perror("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    printf("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    // return "Error, read_file_do_Function : read failed monitor_file.";
                    return 1;
                    // exit(1);
                }

                // 判斷讀取文檔動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                if (strncmp(result_read_file_do_Function, "Error,", 6) == 0) {
                    // perror("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    printf("%s\n", result_read_file_do_Function);
                    printf("Error, read_file_do_Function : read failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    // return "Error, read_file_do_Function : read failed monitor_file.";
                    return 1;
                    // exit(1);
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(result_read_file_do_Function, "exit", sizeof(result_read_file_do_Function)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", result_read_file_do_Function);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(result_read_file_do_Function, 0x00, sizeof(result_read_file_do_Function));
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    // return "Client request : [ exit ] received, Program aborted.";
                    return 2;
                    // exit(signum);
                    // exit(2);
                }

                int buffer_monitor_file_length = BUFFER_LEN_request;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("monitor file string length : %d\n", buffer_monitor_file_length);
                // char buffer_monitor_file_byteArray[BUFFER_LEN_request];  // 代碼首部自定義的常量：BUFFER_LEN_request = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求用於傳入數據的（監聽文檔）monitor_file 内最多不得超過 1024 個字符;
                char* buffer_monitor_file_byteArray = (char*)malloc(buffer_monitor_file_length * sizeof(char));
                // 檢查 malloc 是否成功;
                if (buffer_monitor_file_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
                    // printf("file_Monitor : monitor file Memory allocation failed.\n");
                    printf("Error, file_Monitor : Memory allocation failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    // return "Error, file_Monitor : Memory allocation failed monitor_file.";  // 或者適當的錯誤處理;
                    return 1;
                    // exit(1);
                }
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                buffer_monitor_file_length = strlen(result_read_file_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("monitor file string length : %d\n", buffer_monitor_file_length);
                // 重新分配内存以适应新长度;
                buffer_monitor_file_byteArray = (char*)realloc(buffer_monitor_file_byteArray, buffer_monitor_file_length * sizeof(char));  // 重新分配内存以适应新长度;
                // 檢查 malloc 是否成功;
                if (buffer_monitor_file_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                    // printf("Error, file_Monitor : output file Memory reallocation failed.\n");
                    printf("Error, file_Monitor : Memory reallocation failed monitor_file [ %s ].\n", monitor_file);
                    free(result_read_file_do_Function);  // 釋放内存防止溢出;
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    // return "Error, file_Monitor : Memory reallocation failed monitor_file."; // 或者適當的錯誤處理;
                    return 1;
                    // exit(1);
                }
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));  // 函數：sizeMalloc(buffer_monitor_file_byteArray) 表示獲取堆内存緩衝區（buffer）字節數（8 * bit）的長度;

                // // 使用for循环遍历字符串;
                // // int i = 0;
                // for (i = 0; result_read_file_do_Function[i] != '\0'; i++) {
                //     // printf("%c", result_read_file_do_Function[i]);
                //     if (i < sizeMalloc(buffer_monitor_file_byteArray)) {
                //         buffer_monitor_file_byteArray[i] = result_read_file_do_Function[i];
                //     }
                // }
                // buffer_monitor_file_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // buffer_monitor_file_byteArray[sizeMalloc(buffer_monitor_file_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));
                // printf("monitor file string :\n%s\n", buffer_monitor_file_byteArray);

                // 響應值，將保存讀取傳入文檔數據的變量 result_read_file_do_Function 傳值複製到内存緩衝區變量 buffer_monitor_file_byteArray 内;
                strncpy(buffer_monitor_file_byteArray, result_read_file_do_Function, (sizeMalloc(buffer_monitor_file_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                // buffer_monitor_file_byteArray[sizeMalloc(buffer_monitor_file_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                // strcpy(buffer_monitor_file_byteArray, result_read_file_do_Function);
                // printf("monitor file string length : %d\n", sizeMalloc(buffer_monitor_file_byteArray));
                // printf("monitor file string :\n%s\n", buffer_monitor_file_byteArray);

                free(result_read_file_do_Function);  // 釋放内存防止溢出;

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(buffer_monitor_file_byteArray, "exit", (sizeMalloc(buffer_monitor_file_byteArray) - 1)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_monitor_file_byteArray);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                //     free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     return 2;
                //     // exit(signum);
                //     // exit(2);
                // }


                char *result_do_Function = do_Function(
                    0,
                    buffer_monitor_file_byteArray
                );
                if (result_do_Function == NULL) {
                    // perror("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    printf("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // return "Error, do_Function : do failed monitor_file.";
                    return 1;
                    // exit(1);
                }

                // 判斷計算處理動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                if (strncmp(result_do_Function, "Error,", 6) == 0) {
                    // perror("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    printf("%s\n", result_do_Function);
                    printf("Error, do_Function : do failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // return "Error, do_Function : do failed monitor_file.";
                    return 1;
                    // exit(1);
                }

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(result_do_Function, "exit", sizeof(result_do_Function)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", result_do_Function);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_monitor_file_byteArray, 0x00, sizeof(buffer_monitor_file_byteArray));
                //     free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                //     free(result_do_Function);  // 釋放内存防止溢出;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     return 2;
                //     // exit(signum);
                //     // exit(2);
                // }

                int buffer_return_do_Function_length = BUFFER_LEN_response;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("do_Function return string length : %d\n", buffer_return_do_Function_length);
                // char buffer_return_do_Function_byteArray[BUFFER_LEN_response];  // 代碼首部自定義的常量：BUFFER_LEN_response = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求最多不得超過 1024 個字符;
                char* buffer_return_do_Function_byteArray = (char*)malloc(buffer_return_do_Function_length * sizeof(char));
                // 檢查 malloc 是否成功;
                if (buffer_return_do_Function_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory allocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    // printf("file_Monitor : return_do_Function Memory allocation failed.\n");
                    printf("Error, file_Monitor : Memory allocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    // return "Error, file_Monitor : Memory allocation failed return_do_Function monitor_file.";  // 或者適當的錯誤處理;
                    return 1;
                    // exit(1);
                }
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                buffer_return_do_Function_length = strlen(result_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                // printf("do_Function return string length : %d\n", buffer_return_do_Function_length);
                // 重新分配内存以适应新长度;
                buffer_return_do_Function_byteArray = (char*)realloc(buffer_return_do_Function_byteArray, buffer_return_do_Function_length * sizeof(char));  // 重新分配内存以适应新长度;
                // 檢查 malloc 是否成功;
                if (buffer_return_do_Function_byteArray == NULL) {
                    // perror("Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    // printf("Error, file_Monitor : return_do_Function Memory reallocation failed.\n");
                    printf("Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_monitor_file_byteArray, 0x00, sizeMalloc(buffer_monitor_file_byteArray));
                    free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                    free(result_do_Function);  // 釋放内存防止溢出;
                    // memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    // return "Error, file_Monitor : Memory reallocation failed return_do_Function monitor_file.";  // 或者適當的錯誤處理;
                    return 1;
                    // exit(1);
                }
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_length));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區（buffer）字節數（8 * bit）的長度;

                // // 使用for循环遍历字符串;
                // // int i = 0;
                // for (i = 0; result_do_Function[i] != '\0'; i++) {
                //     // printf("%c", result_do_Function[i]);
                //     if (i < sizeMalloc(buffer_return_do_Function_byteArray)) {
                //         buffer_return_do_Function_byteArray[i] = result_do_Function[i];
                //     }
                // }
                // buffer_return_do_Function_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // buffer_return_do_Function_byteArray[sizeMalloc(buffer_return_do_Function_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));
                // printf("do_Function return string :\n%s\n", buffer_return_do_Function_byteArray);

                // 響應值，將保存計算結果數據的變量 result_do_Function 傳值複製到内存緩衝區變量 buffer_return_do_Function_byteArray 内;
                strncpy(buffer_return_do_Function_byteArray, result_do_Function, (sizeMalloc(buffer_return_do_Function_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                // buffer_return_do_Function_byteArray[sizeMalloc(buffer_return_do_Function_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                // strcpy(buffer_return_do_Function_byteArray, result_do_Function);
                // printf("do_Function return string length : %d\n", sizeMalloc(buffer_return_do_Function_byteArray));
                // printf("do_Function return string :\n%s\n", buffer_return_do_Function_byteArray);

                free(buffer_monitor_file_byteArray);  // 釋放内存防止溢出;
                free(result_do_Function);  // 釋放内存防止溢出;

                // // 判斷信號值（signum）是否爲「Ctrl+c」;
                // // if (signum == 2) {
                // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                // if (strncmp(buffer_return_do_Function_byteArray, "exit", (sizeMalloc(buffer_return_do_Function_byteArray) - 1)) == 0) {
                //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_return_do_Function_byteArray);
                //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                //     memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                //     free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                //     // return "Client request : [ exit ] received, Program aborted.";
                //     return 2;
                //     // exit(signum);
                //     // exit(2);
                // }


                // 當完成讀取文檔數據動作之後，刪除監聽文檔（monitor_file）;
                size_t return_remove_monitor_file = remove(monitor_file);
                if (return_remove_monitor_file != 0) {
                    // printf("當完成讀取文檔數據動作之後，嘗試刪除監聽文檔時發生錯誤.\nmonitor_file = [ %s ].\n", monitor_file);
                    printf("Error, file_Monitor : remove failed monitor_file [ %s ].\n", monitor_file);
                    memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                    free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                    // return "Error, file_Monitor : remove failed monitor_file.";
                    return 1;
                    // exit(signum);
                    // exit(2);
                }


                // printf("用於傳出數據的（輸出文檔）（output_file）的保存路徑爲：\n%s\n", output_file);  // "C:/Criss/Intermediary/intermediary_write_C.txt";
                // 寫入用於傳出數據的（輸出文檔）：output_file 計算結果數據;
                if (strlen(output_file) > 0) {

                    if (access(output_dir, F_OK) != -1) {

                        char *result_write_file_do_Function = write_file_do_Function(
                            monitor_file,
                            monitor_dir,
                            do_Function,
                            output_dir,
                            output_file,
                            to_executable,
                            to_script,
                            time_sleep,
                            buffer_return_do_Function_byteArray
                        );
                        if (result_write_file_do_Function == NULL) {
                            // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // return "Error, write_file_do_Function : write failed output_file.";
                            return 1;
                            // exit(1);
                        }

                        // 判斷寫入文檔動作是否發生錯誤（函數返回值的前 6 個字符是否爲："Error,"）;
                        if (strncmp(result_write_file_do_Function, "Error,", 6) == 0) {
                            // perror("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            printf("%s\n", result_write_file_do_Function);
                            printf("Error, write_file_do_Function : write failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // return "Error, write_file_do_Function : write failed output_file.";
                            return 1;
                            // exit(1);
                        }

                        // // 判斷信號值（signum）是否爲「Ctrl+c」;
                        // // if (signum == 2) {
                        // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                        // if (strncmp(result_write_file_do_Function, "exit", sizeof(result_write_file_do_Function)) == 0) {
                        //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", result_write_file_do_Function);
                        //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        //     memset(buffer_return_do_Function_byteArray, 0x00, sizeof(buffer_return_do_Function_byteArray));
                        //     free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                        //     free(result_write_file_do_Function);  // 釋放内存防止溢出;
                        //     // return "Client request : [ exit ] received, Program aborted.";
                        //     return 1;
                        //     // exit(signum);
                        //     // exit(2);
                        // }

                        int buffer_output_file_length = BUFFER_LEN_response;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                        // printf("output file string length : %d\n", buffer_output_file_length);
                        // char buffer_output_file_byteArray[BUFFER_LEN_response];  // 代碼首部自定義的常量：BUFFER_LEN_response = 1024，靜態申請内存緩衝區（buffer），存儲文檔的所有内容，要求最多不得超過 1024 個字符;
                        char* buffer_output_file_byteArray = (char*)malloc(buffer_output_file_length * sizeof(char));
                        // 檢查 malloc 是否成功;
                        if (buffer_output_file_byteArray == NULL) {
                            // perror("Error, file_Monitor : Memory allocation failed output_file [ %s ].\n", output_file);
                            // printf("file_Monitor : output_file Memory allocation failed.\n");
                            printf("Error, file_Monitor : Memory allocation failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                            free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                            // return "Error, file_Monitor : Memory allocation failed output_file.";  // 或者適當的錯誤處理;
                            return 1;
                            // exit(1);
                        }
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區的字節（8 * bit）數;

                        buffer_output_file_length = strlen(result_write_file_do_Function) + 1;  // 函數：strlen() 獲取指針指向的字符串字節數（8 * bit）的長度，不包括末位終止字符：'\0'（值爲：NULL）;
                        // printf("output file string length : %d\n", buffer_output_file_length);
                        // 重新分配内存以适应新长度;
                        buffer_output_file_byteArray = (char*)realloc(buffer_output_file_byteArray, buffer_output_file_length * sizeof(char));  // 重新分配内存以适应新长度;
                        // 檢查 malloc 是否成功;
                        if (buffer_output_file_byteArray == NULL) {
                            // perror("Error, file_Monitor : Memory reallocation failed output_file [ %s ].\n", output_file);
                            // printf("Error, file_Monitor : output_file Memory reallocation failed.\n");
                            printf("Error, file_Monitor : Memory reallocation failed output_file [ %s ].\n", output_file);
                            memset(buffer_return_do_Function_byteArray, 0x00, sizeMalloc(buffer_return_do_Function_byteArray));
                            free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                            free(result_write_file_do_Function);  // 釋放内存防止溢出;
                            // memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                            free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                            // return "Error, file_Monitor : Memory reallocation failed output_file."; // 或者適當的錯誤處理;
                            return 1;
                            // exit(1);
                        }
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_length));  // 函數：sizeMalloc() 表示獲取内存堆（malloc）緩衝區（buffer）字節數（8 * bit）的長度;

                        // // 使用for循环遍历字符串;
                        // // int i = 0;
                        // for (i = 0; result_write_file_do_Function[i] != '\0'; i++) {
                        //     // printf("%c", result_write_file_do_Function[i]);
                        //     if (i < sizeMalloc(buffer_output_file_byteArray)) {
                        //         buffer_output_file_byteArray[i] = result_write_file_do_Function[i];
                        //     }
                        // }
                        // buffer_output_file_byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                        // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                        // printf("output file string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
                        // printf("output file string :\n%s\n", buffer_output_file_byteArray);

                        // 響應值，將保存寫入文檔函數返回數據的變量 result_write_file_do_Function 傳值複製到内存緩衝區變量 buffer_output_file_byteArray 内;
                        strncpy(buffer_output_file_byteArray, result_write_file_do_Function, (sizeMalloc(buffer_output_file_byteArray) - 1));  // 確保留出空間給終止字符：'\0'（值爲：NULL）;
                        // buffer_output_file_byteArray[sizeMalloc(buffer_output_file_byteArray) - 1] = '\0';  // 確保終止字符：'\0'（值爲：NULL）存在;
                        // strcpy(buffer_output_file_byteArray, result_write_file_do_Function);
                        // printf("output file return string length : %d\n", sizeMalloc(buffer_output_file_byteArray));
                        // printf("output file return string :\n%s\n", buffer_output_file_byteArray);

                        free(buffer_return_do_Function_byteArray);  // 釋放内存防止溢出;
                        free(result_write_file_do_Function);  // 釋放内存防止溢出;

                        // // 判斷信號值（signum）是否爲「Ctrl+c」;
                        // // if (signum == 2) {
                        // // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                        // if (strncmp(buffer_output_file_byteArray, "exit", (sizeMalloc(buffer_output_file_byteArray) - 1)) == 0) {
                        //     // printf("Client request : [ %s ] received.\nProgram aborted.\n", buffer_output_file_byteArray);
                        //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        //     memset(buffer_output_file_byteArray, 0x00, sizeMalloc(buffer_output_file_byteArray));
                        //     free(buffer_output_file_byteArray);  // 釋放内存防止溢出;
                        //     // return "Client request : [ exit ] received, Program aborted.";
                        //     return 2;
                        //     // exit(signum);
                        //     // exit(2);
                        // }

                        free(buffer_output_file_byteArray);  // 釋放内存防止溢出;

                    } else {
                        // printf("用於傳出數據的（輸出文檔）的保存路徑（文件夾）無法識別：\noutput_dir = %s\n", output_dir);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/";
                        printf("Unrecognized output_directory : [ %s ].\n", output_dir);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/";
                        // return ("Unrecognized output_directory : [ %s ].\n", output_dir);
                        // exit(1);
                    }

                } else {
                    // printf("用於傳出數據的（輸出文檔）的保存路徑參數爲空：\noutput_file = %s\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
                    printf("Unrecognized output_file : [ %s ].\n", output_file);  // 用於傳出數據的（輸出文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_C.txt";
                    // return ("Unrecognized output_file : [ %s ].\n", output_file);
                    // exit(1);
                }

            } else {
                // printf("用於傳入數據的（監聽文檔）的保存路徑參數爲空：\nmonitor_file = %s\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
                printf("Unrecognized monitor_file : [ %s ].\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
                // return ("Unrecognized monitor_file : [ %s ].\n", monitor_file);
                // exit(1);
            }

        } else {}

    } else {
        // printf("用於傳入數據的（監聽文檔）的保存路徑參數爲空：\nmonitor_file = %s\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        printf("Unrecognized monitor_file : [ %s ].\n", monitor_file);  // 用於傳入數據的（監聽文檔）的保存路徑參數："C:/Criss/Intermediary/intermediary_write_Nodejs.txt";
        // return ("Unrecognized monitor_file : [ %s ].\n", monitor_file);
        // exit(1);
    }

    return 0;
}


// 2、Socket server and client;

// 判斷是否爲 Windows 作業系統，還是 Linux 作業系統;
#if defined(__WINDOWS__)

    // 主程序創建子進程（thread）執行用戶端請求數據計算處理時，將 ClientThread() 函數傳入子進程執行具體動作;
    static DWORD WINAPI ClientThread (LPVOID lpParameter) {

        SOCKET CientSocket = (SOCKET)lpParameter;
        int Ret = 0;
        // 服務端（Server）從用戶端（Client）接收請求（Request）數據的儲存變量;
        char RecvBuffer[BUFFER_LEN_request];  // 服務端（Server）從用戶端（Client）接收請求（Request）數據的儲存變量;
        // 服務端（Server）向用戶端（Client）發送的響應（Response）數據字符串;
        char response_Data[BUFFER_LEN_response] = "{\"Server_say\":\"這裏是 C 服務端 ( Server ) 響應 ( Response ) 的數據字符串; this is response string data.\"}";  // 服務端（Server）向用戶端（Client）發送的響應（Response）數據字符串;

        while (1) {

            memset(RecvBuffer, 0x00, sizeMalloc(RecvBuffer));
            Ret = recv(CientSocket, RecvBuffer, sizeof(RecvBuffer), 0);
            if (Ret == 0 || Ret == SOCKET_ERROR) {
                printf("Client disconnect.\n");
                break;
                // return 1;
                // exit(1);
            }
            printf("Client request information :\n%s\n", RecvBuffer);

            // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
            if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                memset(RecvBuffer, 0x00, sizeMalloc(RecvBuffer));
                break;
                // return 2;
                // exit(signum);
                // exit(2);
            }

            // write(CientSocket, response_Data, sizeof(response_Data));
            Ret = send(CientSocket, response_Data, strlen(response_Data), 0);
            // if ( Ret == 0 || Ret == SOCKET_ERROR ) {
            //     printf("Error, Server response write failed.%s\n", Ret);
            //     break;
            //     // return 1;
            //     // exit(1);
            // }
            printf("Server response information :\n%s\n", response_Data);
        }

        return 0;
    }

#elif defined(__linux__)

#else
    printf("Unknown operating system.\n");
    exit(1);
#endif


// 服務器端（http_server）的自定義函數，用於處理用戶端（client）發送的請求數據;
char* do_Request (int argc, char *argv) {

    // // 獲取當前時間
    // time_t current_time;
    // time(&current_time); 
    // // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
    // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
    // // 定義一個足夠大的字符串來保存日期和時間
    // char now_time_string[80];
    // // 使用 strftime 將時間格式化為字符串
    // // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
    // // printf("當前時間是：%s\n", now_time_string);
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
    // // printf("UTC time: %s\n", now_time_string);
    // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    int i = 0;
    // size_t argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    int argv_len = 1024;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    char *byteArray = (char*)malloc(argv_len * sizeof(char));
    // char byteArray[argv_len];
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory allocation failed.\n");
        return ("Memory allocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    // 重新分配内存以适应新长度;
    byteArray = (char*)realloc(byteArray, argv_len * sizeof(char));  // 重新分配内存以适应新长度;
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory reallocation failed.\n");
        return ("Memory reallocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));

    // // 使用for循环遍历字符串;
    // for (i = 0; argv[i] != '\0'; i++) {
    //     // printf("%c", argv[i]);
    //     if (i < sizeMalloc(byteArray)) {
    //         byteArray[i] = argv[i];
    //     }
    // }
    // byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // byteArray[sizeMalloc(byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    // 響應值，將運算結果變量 argv 傳值複製到響應值變量 byteArray 内;
    strncpy(byteArray, argv, sizeMalloc(byteArray) - 1);  // 確保留出空間給終止字符：'\0';
    byteArray[sizeMalloc(byteArray) - 1] = '\0';  // 確保終止字符：'\0' 存在;
    // strcpy(byteArray, argv);
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    return byteArray;
}
// char *result = do_Request(0, "");
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;


// 用戶端（http_client）的自定義函數，用於處理服務器端（server）發送的請求數據;
char* do_Response (int argc, char *argv) {

    // // 獲取當前時間
    // time_t current_time;
    // time(&current_time); 
    // // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
    // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
    // // 定義一個足夠大的字符串來保存日期和時間
    // char now_time_string[80];
    // // 使用 strftime 將時間格式化為字符串
    // // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
    // // printf("當前時間是：%s\n", now_time_string);
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
    // // printf("UTC time: %s\n", now_time_string);
    // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    int i = 0;
    // size_t argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    int argv_len = 1024;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    char *byteArray = (char*)malloc(argv_len * sizeof(char));
    // char byteArray[argv_len];
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory allocation failed.\n");
        return ("Memory allocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    argv_len = strlen(argv) + 1;  // 函數：strlen() 獲取指針指向的字符串的長度，不包括末位終止字符：'\0';
    // printf("Input string length : %d\n", argv_len);
    // 重新分配内存以适应新长度;
    byteArray = (char*)realloc(byteArray, argv_len * sizeof(char));  // 重新分配内存以适应新长度;
    // 檢查 malloc 是否成功;
    if (byteArray == NULL) {
        printf("Memory reallocation failed.\n");
        return ("Memory reallocation failed."); // 或者適當的錯誤處理;
        // exit(1);
    }
    // printf("Input string length : %d\n", sizeMalloc(byteArray));

    // // 使用for循环遍历字符串;
    // for (i = 0; argv[i] != '\0'; i++) {
    //     // printf("%c", argv[i]);
    //     if (i < sizeMalloc(byteArray)) {
    //         byteArray[i] = argv[i];
    //     }
    // }
    // byteArray[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // byteArray[sizeMalloc(byteArray) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    // 響應值，將運算結果變量 argv 傳值複製到響應值變量 byteArray 内;
    strncpy(byteArray, argv, sizeMalloc(byteArray) - 1);  // 確保留出空間給終止字符：'\0';
    byteArray[sizeMalloc(byteArray) - 1] = '\0';  // 確保終止字符：'\0' 存在;
    // strcpy(byteArray, argv);
    // printf("Input string length : %d\n", sizeMalloc(byteArray));
    // printf("Input string :\n%s\n", byteArray);

    return byteArray;
}
// char *result = do_Response(0, "");
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;


// 自定義的服務器端（http_server）函數程式;
// tcp_Server_「Sockets.Sockets.listen」;
int socket_Server (
    char *host,  // "::0" or "::1" or "127.0.0.1"; 監聽主機域名 Host domain name;
    int port,  // 0 ~ 65535，監聽埠號（端口）;
    char *IPversion,  // "IPv6", "IPv4";
    char *webPath,  // "C:/Criss/html";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
    char* (*do_Function)(int, char *),  // 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
    char *key,  // ":",  // "username:password",  # 自定義的訪問網站簡單驗證用戶名和密碼;
    char *session,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    float time_sleep  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
) {
    // // 獲取當前時間
    // time_t current_time;
    // time(&current_time); 
    // // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
    // struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
    // // 定義一個足夠大的字符串來保存日期和時間
    // char now_time_string[80];
    // // 使用 strftime 將時間格式化為字符串
    // // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
    // // printf("當前時間是：%s\n", now_time_string);
    // // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
    // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
    // // printf("UTC time: %s\n", now_time_string);
    // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，從服務器端（Server）向用戶端返回的響應（Response）資訊;
    char message_returned_from_server_when_Handshake_successful[BUFFER_LEN] = "Handshake successful between client and server.";  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，從服務器端（Server）向用戶端返回的響應（Response）資訊;
    // 服務端（Server）從用戶端（Client）接收請求（Request）數據的儲存變量;
    char RecvBuffer[BUFFER_LEN_request];  // 服務端（Server）從用戶端（Client）接收請求（Request）數據的儲存變量;
    // 服務端（Server）向用戶端（Client）發送的響應（Response）數據字符串;
    char response_Data[BUFFER_LEN_response] = "";  // 服務端（Server）向用戶端（Client）發送的響應（Response）數據字符串;
    char requestConnection[16];  // "Connection:close\r\n",  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
    memset(requestConnection, 0x00, sizeof(requestConnection));

    // 區分操作系統 Windows MingW-w64 gcc 或 Linux-Ubuntu ( Android-Termux ) gcc 系統;
    #if defined(__WINDOWS__)

        WSADATA Ws;
        SOCKET ServerSocket, ClientSocket;
        HANDLE hThread = NULL;
        int backlog = SOMAXCONN;  // 參數：SOMAXCONN 是定義在：Winsock2.h 頭文檔内的常量，表示在監聽 Socket 上可以排隊的最大連接數，通常 Windows 上是 5 ;

        // 判斷服務器（Server）監聽 IP 地址版本："IPv6" or "IPv4"，據此創建相對應的套接字（Socket）對象;
        if (strncmp(IPversion, "IPv4", sizeof(IPversion)) == 0) {

            int socket_desc = 0;
            struct sockaddr_in ServerAddr, ClientAddr;
            int Ret = 0;
            int AddrLen = 0;

            // Initialization Windows Socket
            if (WSAStartup(MAKEWORD(2,2), &Ws) != 0) {
                printf("Initialization Windows Socket Failed.\n");
                return 1;
            }

            // Create socket
            ServerSocket = socket(AF_INET , SOCK_STREAM , IPPROTO_TCP);
            if (ServerSocket == -1) {
                printf("Could not create socket.\n");
                WSACleanup();  // 初始化重置清空;
                // closesocket(ServerSocket);
                return 1;
            }

            // 寫入自定義的監聽地址;
            // 判斷自定義傳入的監聽主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            AddrLen = sizeof(ServerAddr);
            socket_desc = 0;
            socket_desc = WSAStringToAddressA(host, AF_INET, NULL, (struct sockaddr *)&ServerAddr, &AddrLen);
            if (socket_desc != 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                closesocket(ServerSocket);
                return 1;
            }
            AddrLen = 0;
            socket_desc = 0;  // 復位還原;
            // if (inet_pton(AF_INET, host, &ServerAddr.sin_addr) <= 0) {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ServerSocket);
            //     return 1;
            // }
            memset(&ServerAddr, 0x00, sizeof(ServerAddr));  // 將 ServerAddr 的所有位初始化爲零;
            memset(ServerAddr.sin_zero, 0x00, 8);
            ServerAddr.sin_family = AF_INET;
            // ServerAddr.sin_addr.s_addr = inet_addr(host);
            AddrLen = sizeof(ServerAddr);
            WSAStringToAddressA(host, AF_INET, NULL, (struct sockaddr *)&ServerAddr, &AddrLen);
            // inet_pton(AF_INET, host, &ServerAddr.sin_addr);
            ServerAddr.sin_port = htons(port);

            // Bind Socket
            Ret = 0;
            Ret = bind(ServerSocket, (struct sockaddr *)&ServerAddr, sizeof(ServerAddr));
            if (Ret != 0) {
                printf("Bind socket failed.\n");
                closesocket(ServerSocket);
                return 1;
            }

            // listen
            Ret = 0;
            Ret = listen(ServerSocket, backlog);
            if (Ret != 0) {
                printf("Listen socket failed.\n");
                closesocket(ServerSocket);
                return 1;
            }

            printf("Listen socket host : [ %s ], port : [ %d ] successful.\n", host, port);

            while (1) {

                // 等待用戶端（Client）的交握（握手）（首次鏈接）（Handshake）請求;
                AddrLen = sizeof(ClientAddr);
                ClientSocket = accept(ServerSocket, (struct sockaddr *)&ClientAddr, &AddrLen);
                if (ClientSocket == INVALID_SOCKET) {
                    printf("Accept client Handshake failed.\n");
                    // closesocket(ClientSocket);
                    break;
                }

                // 當服務器端（Server）與用戶端（Client）交握（握手）（首次鏈接）（Handshake）動作成功時，從服務器端（Server）向用戶端返回響應（Response）資訊;
                // write(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
                send(ClientSocket, message_returned_from_server_when_Handshake_successful, strlen(message_returned_from_server_when_Handshake_successful), 0);
                // send(ClientSocket, message, strlen(message), 0);

                printf("Client Handshake successful.\n");
                printf("listening to the host : [ %s ], port : [ %d ] ...\n", host, port);

                // // 創建一個子進程（thread），接收用戶端（Client）發送的請求（request）數據，并計算處理，然後將處理結果返回給用戶端;
                // hThread = CreateThread(NULL, 0, ClientThread, (LPVOID)ClientSocket, 0, NULL);
                // if (hThread == NULL) {
                //     printf("Create thread failed.\n");
                //     break;
                // }
                // CloseHandle(hThread);

                while (1) {

                    memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    Ret = 0;
                    // Ret = read(ClientSocket, RecvBuffer, sizeof(RecvBuffer));
                    Ret = recv(ClientSocket, RecvBuffer, sizeof(RecvBuffer), 0);
                    if (Ret == 0 || Ret == SOCKET_ERROR) {
                        // printf("Error, reading from socket client failed.\n");
                        printf("Client disconnect.\n");
                        // closesocket(ClientSocket);
                        break;
                    }
                    printf("Client request information :\n%s\n", RecvBuffer);

                    // 判斷信號值（signum）是否爲「Ctrl+c」;
                    // if (signum == 2) {
                    // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                    if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                        // printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                        // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        // closesocket(ClientSocket);
                        // exit(signum);
                        // exit(2);
                        break;
                    }

                    // 讀取用戶端（Client）請求（request）頭數據中的參數「Connection」的值;
                    memset(requestConnection, 0x00, sizeof(requestConnection));
                    // 使用：strstr() 函數檢查字符串："Hello World" 中是否包含字符串："World"，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
                    char *find_Head_Connection_begin = strstr(RecvBuffer, "Connection:");
                    if (find_Head_Connection_begin != NULL) {
                        find_Head_Connection_begin = find_Head_Connection_begin + strlen("Connection:");
                        char *find_Head_Connection_end = strstr(find_Head_Connection_begin, "\\r\\n");
                        if (find_Head_Connection_end != NULL) {
                            if ((find_Head_Connection_end - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, (find_Head_Connection_end - find_Head_Connection_begin));
                            }
                        } else {
                            if (((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, ((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin));
                            }
                        }
                        // requestConnection[sizeof(requestConnection) - 1] = '\0'; // 確保終止字符：'\0' 存在;
                    }
                    // printf("Client request head [ Connection ] : [ %s ].\n", requestConnection);

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    memset(response_Data, 0x00, sizeof(response_Data));
                    // // 使用for循环遍历字符串;
                    // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    //     // printf("%c", result_do_Function[i]);
                    //     if (i < sizeof(response_Data)) {
                    //         response_Data[i] = result_do_Function[i];
                    //     }
                    // }
                    // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // printf("responsed string length : %d\n", sizeof(response_Data));
                    // printf("responsed string :\n%s\n", response_Data);
                    strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;

                    Ret = 0;
                    // Ret = write(ClientSocket, response_Data, sizeof(response_Data));
                    // Ret = write(ClientSocket, response_Data, strlen(response_Data));
                    Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret == SOCKET_ERROR) {
                    //     printf("Send information error.\n");
                    //     closesocket(ClientSocket);
                    //     // memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    printf("Server response information :\n%s\n", response_Data);

                    // // 讀取從鍵盤輸入的資訊並發給用戶端，形似 QQ 通訊軟體;
                    // // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // char SendBuffer[BUFFER_LEN_response];  // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // // cin.getline(response_Data, sizeof(response_Data));
                    // printf("Enter the send informations :\n");
                    // // scanf("%s", response_Data);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // fgets(response_Data, sizeof(response_Data), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // // printf("%s\n", response_Data);
                    // // 刪除字符串末尾的換行符號（\n）;
                    // if (strlen(response_Data) > 0 && response_Data[strlen(response_Data) - 1] == '\n') {
                    //     response_Data[strlen(response_Data) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                    // }
                    // // char temp[100]; // 用於存儲不包含 \n 的部分
                    // // size_t len = strcspn(response_Data, "\n"); // 找到 \n 的位置;
                    // // strncpy(temp, response_Data, len); // 複製不包括 \n 的部分到 temp;
                    // // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                    // // char *token = strtok(response_Data, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                    // // printf("%s\n", response_Data);
                    // Ret = 0;
                    // // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                    // Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret == SOCKET_ERROR) {
                    //     printf("Send information error.\n");
                    //     closesocket(ClientSocket);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // printf("waiting ...\n");

                    // 檢查是否斷開與用戶端的鏈接;
                    // char requestConnection[16];  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                    if (strncmp(requestConnection, "close", sizeof(requestConnection)) == 0) {
                        closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    } else if (strncmp(requestConnection, "keep-alive", sizeof(requestConnection)) == 0) {
                        // closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        // memset(requestConnection, 0x00, sizeof(requestConnection));
                        // break;
                    } else {
                        closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    }
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // closesocket(ClientSocket);
                    // exit(signum);
                    // exit(2);
                    break;
                }
            }

            closesocket(ServerSocket);  // 關閉 Socket 服務端（Server）對象;
            closesocket(ClientSocket);  // 關閉 Socket 用戶端（Client）對象;
            WSACleanup();  // 初始化重置清空;

        } else if (strncmp(IPversion, "IPv6", sizeof(IPversion)) == 0) {

            int socket_desc = 0;
            struct sockaddr_in6 ServerAddr, ClientAddr;
            int Ret = 0;
            int AddrLen = 0;

            // Initialization Windows Socket
            if (WSAStartup(MAKEWORD(2,2), &Ws) != 0) {
                printf("Initialization Windows Socket Failed.\n");
                return 1;
            }

            // Create socket
            ServerSocket = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
            if (ServerSocket == INVALID_SOCKET) {
                printf("Could not create socket.\n");
                // closesocket(ServerSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // 寫入自定義的監聽地址;
            // 判斷自定義傳入的監聽主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            AddrLen = sizeof(ServerAddr);
            socket_desc = 0;
            socket_desc = WSAStringToAddressA(host, AF_INET6, NULL, (struct sockaddr *)&ServerAddr, &AddrLen);
            if (socket_desc != 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                closesocket(ServerSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }
            AddrLen = 0;
            socket_desc = 0;  // 復位還原;
            // if (inet_pton(AF_INET6, host, &ServerAddr.sin6_addr) <= 0) {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ServerSocket);
            //     return 1;
            // }
            memset(&ServerAddr, 0x00, sizeof(ServerAddr));  // 將 ServerAddr 的所有位初始化爲零;
            // ZeroMemory(&ServerAddr, sizeof(ServerAddr));  // 將 ServerAddr 的所有位初始化爲零;
            ServerAddr.sin6_family = AF_INET6;  // 使用 IPv6 地址族;
            AddrLen = sizeof(ServerAddr);
            WSAStringToAddressA(host, AF_INET6, NULL, (struct sockaddr *)&ServerAddr, &AddrLen);
            // inet_pton(AF_INET6, host, &ServerAddr.sin6_addr);  // 指定接收自定義 IPv6 地址主機請求鏈接;
            // if (strncmp(host, "::0", sizeof(host)) == 0) {
            //     ServerAddr.sin6_addr = in6addr_any;  // 使用：in6addr_any 常量表示允許接收來自網絡中所有 IPv6 地址的主機請求鏈接;
            // } else if (strncmp(host, "::1", sizeof(host)) == 0) {
            //     ServerAddr.sin6_addr = in6addr_loopback;  // 使用：in6addr_loopback 常量表示只允許接收來自本機 localhost（IPv6）的鏈接請求;
            // } else {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ServerSocket);
            //     WSACleanup();  // 初始化重置清空;
            //     return 1;
            // }
            ServerAddr.sin6_port = htons(port);  // 埠號，需以網絡字節序設置;

            // Bind Socket
            Ret = 0;
            Ret = bind(ServerSocket, (struct sockaddr *)&ServerAddr, sizeof(ServerAddr));
            if (Ret != 0) {
                printf("Bind socket failed.\n");
                closesocket(ServerSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // listen
            Ret = 0;
            Ret = listen(ServerSocket, backlog);
            if (Ret != 0) {
                printf("Listen socket failed.\n");
                closesocket(ServerSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            printf("Listen socket host : [ %s ], port : [ %d ] successful.\n", host, port);

            while (1) {

                // 等待用戶端（Client）的交握（握手）（首次鏈接）（Handshake）請求;
                AddrLen = sizeof(ClientAddr);
                ClientSocket = accept(ServerSocket, (struct sockaddr *)&ClientAddr, &AddrLen);
                if (ClientSocket == INVALID_SOCKET) {
                    printf("Accept client Handshake failed.\n");
                    // closesocket(ClientSocket);
                    break;
                }

                // 當服務器端（Server）與用戶端（Client）交握（握手）（首次鏈接）（Handshake）動作成功時，從服務器端（Server）向用戶端返回響應（Response）資訊;
                // write(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
                send(ClientSocket, message_returned_from_server_when_Handshake_successful, strlen(message_returned_from_server_when_Handshake_successful), 0);
                // send(ClientSocket, message, strlen(message), 0);

                printf("Client Handshake successful.\n");
                printf("listening to the host : [ %s ], port : [ %d ] ...\n", host, port);

                // // 創建一個子進程（thread），接收用戶端（Client）發送的請求（request）數據，并計算處理，然後將處理結果返回給用戶端;
                // hThread = CreateThread(NULL, 0, ClientThread, (LPVOID)ClientSocket, 0, NULL);
                // if (hThread == NULL) {
                //     printf("Create thread failed.\n");
                //     break;
                // }
                // CloseHandle(hThread);

                while (1) {

                    memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    Ret = 0;
                    // Ret = read(ClientSocket, RecvBuffer, sizeof(RecvBuffer));
                    Ret = recv(ClientSocket, RecvBuffer, sizeof(RecvBuffer), 0);
                    if (Ret == 0 || Ret == SOCKET_ERROR) {
                        // printf("Error, reading from socket client failed.\n");
                        printf("Client disconnect.\n");
                        // closesocket(ClientSocket);
                        break;
                    }
                    printf("Client request information :\n%s\n", RecvBuffer);

                    // 判斷信號值（signum）是否爲「Ctrl+c」;
                    // if (signum == 2) {
                    // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                    if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                        // printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                        // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        // closesocket(ClientSocket);
                        // exit(signum);
                        // exit(2);
                        break;
                    }

                    // 讀取用戶端（Client）請求（request）頭數據中的參數「Connection」的值;
                    memset(requestConnection, 0x00, sizeof(requestConnection));
                    // 使用：strstr() 函數檢查字符串："Hello World" 中是否包含字符串："World"，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
                    char *find_Head_Connection_begin = strstr(RecvBuffer, "Connection:");
                    if (find_Head_Connection_begin != NULL) {
                        find_Head_Connection_begin = find_Head_Connection_begin + strlen("Connection:");
                        char *find_Head_Connection_end = strstr(find_Head_Connection_begin, "\\r\\n");
                        if (find_Head_Connection_end != NULL) {
                            if ((find_Head_Connection_end - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, (find_Head_Connection_end - find_Head_Connection_begin));
                            }
                        } else {
                            if (((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, ((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin));
                            }
                        }
                        // requestConnection[sizeof(requestConnection) - 1] = '\0'; // 確保終止字符：'\0' 存在;
                    }
                    // printf("Client request head [ Connection ] : [ %s ].\n", requestConnection);

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    memset(response_Data, 0x00, sizeof(response_Data));
                    // // 使用for循环遍历字符串;
                    // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    //     // printf("%c", result_do_Function[i]);
                    //     if (i < sizeof(response_Data)) {
                    //         response_Data[i] = result_do_Function[i];
                    //     }
                    // }
                    // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // printf("responsed string length : %d\n", sizeof(response_Data));
                    // printf("responsed string :\n%s\n", response_Data);
                    strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;

                    Ret = 0;
                    // Ret = write(ClientSocket, response_Data, sizeof(response_Data));
                    // Ret = write(ClientSocket, response_Data, strlen(response_Data));
                    Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret == SOCKET_ERROR) {
                    //     printf("Send information error.\n");
                    //     closesocket(ClientSocket);
                    //     // memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    printf("Server response information :\n%s\n", response_Data);

                    // // 讀取從鍵盤輸入的資訊並發給用戶端，形似 QQ 通訊軟體;
                    // // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // char SendBuffer[BUFFER_LEN_response];  // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // // cin.getline(response_Data, sizeof(response_Data));
                    // printf("Enter the send informations :\n");
                    // // scanf("%s", response_Data);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // fgets(response_Data, sizeof(response_Data), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // // printf("%s\n", response_Data);
                    // // 刪除字符串末尾的換行符號（\n）;
                    // if (strlen(response_Data) > 0 && response_Data[strlen(response_Data) - 1] == '\n') {
                    //     response_Data[strlen(response_Data) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                    // }
                    // // char temp[100]; // 用於存儲不包含 \n 的部分
                    // // size_t len = strcspn(response_Data, "\n"); // 找到 \n 的位置;
                    // // strncpy(temp, response_Data, len); // 複製不包括 \n 的部分到 temp;
                    // // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                    // // char *token = strtok(response_Data, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                    // // printf("%s\n", response_Data);
                    // Ret = 0;
                    // // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                    // Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret == SOCKET_ERROR) {
                    //     printf("Send information error.\n");
                    //     closesocket(ClientSocket);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // printf("waiting ...\n");

                    // 檢查是否斷開與用戶端的鏈接;
                    // char requestConnection[16];  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                    if (strncmp(requestConnection, "close", sizeof(requestConnection)) == 0) {
                        closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    } else if (strncmp(requestConnection, "keep-alive", sizeof(requestConnection)) == 0) {
                        // closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        // memset(requestConnection, 0x00, sizeof(requestConnection));
                        // break;
                    } else {
                        closesocket(ClientSocket);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    }
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // closesocket(ClientSocket);
                    // exit(signum);
                    // exit(2);
                    break;
                }
            }

            closesocket(ServerSocket);  // 關閉 Socket 服務端（Server）對象;
            closesocket(ClientSocket);  // 關閉 Socket 用戶端（Client）對象;
            WSACleanup();  // 初始化重置清空;

        } else {
            // perror("Invalid address version not supported : [ %s ].\n", IPversion);
            printf("Invalid address version not supported : [ %s ].\n", IPversion);
            return 1;
        }

    #elif defined(__linux__)

        int sockfdServer = 0, sockfdClient = 0;
        int backlog = 5;  // 參數：SOMAXCONN 是定義在：Winsock2.h 頭文檔内的常量，表示在監聽 Socket 上可以排隊的最大連接數，通常 Windows 上是 5 ;

        // 判斷服務器（Server）監聽 IP 地址版本："IPv6" or "IPv4"，據此創建相對應的套接字（Socket）對象;
        if (strncmp(IPversion, "IPv4", sizeof(IPversion)) == 0) {

            int Ret = 0;
            struct sockaddr_in ServerAddr, ClientAddr;
            socklen_t AddrLen = 0;

            // Create socket，創建 socket;
            sockfdServer = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (sockfdServer < 0) {
                printf("Could not create socket.\n");
                // close(sockfdServer);
                return 1;
                // exit(1);
            }

            // 寫入自定義的監聽地址;
            // 判斷自定義傳入的監聽主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            if (inet_pton(AF_INET, host, &ServerAddr.sin_addr) <= 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                close(sockfdServer);
                return 1;
            }
            memset(&ServerAddr, 0x00, sizeof(ServerAddr));  // 將 ServerAddr 的所有位初始化爲零;
            memset(ServerAddr.sin_zero, 0x00, 8);
            ServerAddr.sin_family = AF_INET;
            // ServerAddr.sin_addr.s_addr = inet_addr(host);
            inet_pton(AF_INET, host, &ServerAddr.sin_addr);
            ServerAddr.sin_port = htons(port);

            // Bind Socket。綁定 socket 至指定主機 IP 埠號;
            Ret = 0;
            Ret = bind(sockfdServer, (struct sockaddr *)&ServerAddr, sizeof(ServerAddr));
            if (Ret < 0) {
                printf("Bind socket failed.\n");
                close(sockfdServer);
                return 1;
                // exit(1);
            }

            // listen，監聽鏈接請求;
            Ret = 0;
            Ret = listen(sockfdServer, backlog);
            if (Ret != 0) {
                printf("Listen socket failed.\n");
                close(sockfdServer);
                return 1;
            }

            printf("Listen socket host : [ %s ], port : [ %d ] successful.\n", host, port);

            while (1) {

                // 等待用戶端（Client）的交握（握手）（首次鏈接）（Handshake）請求;
                AddrLen = sizeof(ClientAddr);
                sockfdClient = accept(sockfdServer, (struct sockaddr *)&ClientAddr, &AddrLen);
                if (sockfdClient < 0) {
                    // perror("Accept client Handshake failed.\n");
                    printf("Accept client Handshake failed.\n");
                    break;
                    // return 1;
                    // exit(1);
                }

                // 當服務器端（Server）與用戶端（Client）交握（握手）（首次鏈接）（Handshake）動作成功時，從服務器端（Server）向用戶端返回響應（Response）資訊;
                // write(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
                send(sockfdClient, message_returned_from_server_when_Handshake_successful, strlen(message_returned_from_server_when_Handshake_successful), 0);

                printf("Client Handshake successful.\n");
                printf("listening to the host : [ %s ], port : [ %d ] ...\n", host, port);

                // // 創建一個子進程（thread），接收用戶端（Client）發送的請求（request）數據，并計算處理，然後將處理結果返回給用戶端;
                // hThread = CreateThread(NULL, 0, ClientThread, (LPVOID)ClientSocket, 0, NULL);
                // if (hThread == NULL) {
                //     printf("Create thread failed.\n");
                //     break;
                // }
                // CloseHandle(hThread);

                while (1) {
                    memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    Ret = 0;
                    // Ret = read(sockfdClient, RecvBuffer, sizeof(RecvBuffer));
                    Ret = recv(sockfdClient, RecvBuffer, sizeof(RecvBuffer), 0);
                    if (Ret < 0) {
                        // printf("Error, reading from socket client failed.\n");
                        printf("Client disconnect.\n");
                        // close(sockfdClient);
                        break;
                    }
                    printf("Client request information :\n%s\n", RecvBuffer);

                    // 判斷信號值（signum）是否爲「Ctrl+c」;
                    // if (signum == 2) {
                    // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                    if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                        // printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                        // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        // close(sockfdClient);
                        // exit(signum);
                        // exit(2);
                        break;
                    }

                    // 讀取用戶端（Client）請求（request）頭數據中的參數「Connection」的值;
                    memset(requestConnection, 0x00, sizeof(requestConnection));
                    // 使用：strstr() 函數檢查字符串："Hello World" 中是否包含字符串："World"，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
                    char *find_Head_Connection_begin = strstr(RecvBuffer, "Connection:");
                    if (find_Head_Connection_begin != NULL) {
                        find_Head_Connection_begin = find_Head_Connection_begin + strlen("Connection:");
                        char *find_Head_Connection_end = strstr(find_Head_Connection_begin, "\\r\\n");
                        if (find_Head_Connection_end != NULL) {
                            if ((find_Head_Connection_end - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, (find_Head_Connection_end - find_Head_Connection_begin));
                            }
                        } else {
                            if (((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, ((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin));
                            }
                        }
                        // requestConnection[sizeof(requestConnection) - 1] = '\0'; // 確保終止字符：'\0' 存在;
                    }
                    // printf("Client request head [ Connection ] : [ %s ].\n", requestConnection);

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    memset(response_Data, 0x00, sizeof(response_Data));
                    // // 使用for循环遍历字符串;
                    // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    //     // printf("%c", result_do_Function[i]);
                    //     if (i < sizeof(response_Data)) {
                    //         response_Data[i] = result_do_Function[i];
                    //     }
                    // }
                    // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // printf("responsed string length : %d\n", sizeof(response_Data));
                    // printf("responsed string :\n%s\n", response_Data);
                    strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;

                    Ret = 0;
                    // Ret = write(sockfdClient, response_Data, sizeof(response_Data));
                    // Ret = write(sockfdClient, response_Data, strlen(response_Data));
                    Ret = send(sockfdClient, response_Data, strlen(response_Data), 0);
                    // if (Ret < 0) {
                    //     printf("Send information error.\n");
                    //     close(sockfdClient);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    printf("Server response information :\n%s\n", response_Data);

                    // // 讀取從鍵盤輸入的資訊並發給用戶端，形似 QQ 通訊軟體;
                    // // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // char SendBuffer[BUFFER_LEN_response];  // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // // cin.getline(response_Data, sizeof(response_Data));
                    // printf("Enter the send informations :\n");
                    // // scanf("%s", response_Data);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // fgets(response_Data, sizeof(response_Data), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // // printf("%s\n", response_Data);
                    // // 刪除字符串末尾的換行符號（\n）;
                    // if (strlen(response_Data) > 0 && response_Data[strlen(response_Data) - 1] == '\n') {
                    //     response_Data[strlen(response_Data) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                    // }
                    // // char temp[100]; // 用於存儲不包含 \n 的部分
                    // // size_t len = strcspn(response_Data, "\n"); // 找到 \n 的位置;
                    // // strncpy(temp, response_Data, len); // 複製不包括 \n 的部分到 temp;
                    // // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                    // // char *token = strtok(response_Data, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                    // // printf("%s\n", response_Data);
                    // Ret = 0;
                    // // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                    // Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret < 0) {
                    //     printf("Send information error.\n");
                    //     close(sockfdClient);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // printf("waiting ...\n");

                    // 檢查是否斷開與用戶端的鏈接;
                    // char requestConnection[16];  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                    if (strncmp(requestConnection, "close", sizeof(requestConnection)) == 0) {
                        close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    } else if (strncmp(requestConnection, "keep-alive", sizeof(requestConnection)) == 0) {
                        // close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        // memset(requestConnection, 0x00, sizeof(requestConnection));
                        // break;
                    } else {
                        close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    }
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // close(sockfdClient);
                    // exit(signum);
                    // exit(2);
                    break;
                }
            }

            close(sockfdServer);  // 關閉 Socket 服務端（Server）對象;
            close(sockfdClient);  // 關閉 Socket 用戶端（Client）對象;

        } else if (strncmp(IPversion, "IPv6", sizeof(IPversion)) == 0) {

            int Ret = 0;
            struct sockaddr_in6 ServerAddr, ClientAddr;
            socklen_t AddrLen = 0;

            // Create socket，創建 socket;
            sockfdServer = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
            if (sockfdServer < 0) {
                printf("Could not create socket.\n");
                // close(sockfdServer);
                return 1;
                // exit(1);
            }

            // 寫入自定義的監聽地址;
            // 判斷自定義傳入的監聽主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            if (inet_pton(AF_INET6, host, &ServerAddr.sin6_addr) <= 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                close(sockfdServer);
                return 1;
            }
            memset(&ServerAddr, 0x00, sizeof(ServerAddr));  // 將 ServerAddr 的所有位初始化爲零;
            ServerAddr.sin6_family = AF_INET6;  // 使用 IPv6 地址族;
            inet_pton(AF_INET6, host, &ServerAddr.sin6_addr);  // 指定接收自定義 IPv6 地址主機請求鏈接;
            // if (strncmp(host, "::0", sizeof(host)) == 0) {
            //     ServerAddr.sin6_addr = in6addr_any;  // 使用：in6addr_any 常量表示允許接收來自網絡中所有 IPv6 地址的主機請求鏈接;
            // } else if (strncmp(host, "::1", sizeof(host)) == 0) {
            //     ServerAddr.sin6_addr = in6addr_loopback;  // 使用：in6addr_loopback 常量表示只允許接收來自本機 localhost（IPv6）的鏈接請求;
            // } else {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ServerSocket);
            //     WSACleanup();  // 初始化重置清空;
            //     return 1;
            // }
            ServerAddr.sin6_port = htons(port);  // 埠號，需以網絡字節序設置;

            // Bind Socket。綁定 socket 至指定主機 IP 埠號;
            Ret = 0;
            Ret = bind(sockfdServer, (struct sockaddr *)&ServerAddr, sizeof(ServerAddr));
            if (Ret < 0) {
                printf("Bind socket failed.\n");
                close(sockfdServer);
                return 1;
                // exit(1);
            }

            // listen，監聽鏈接請求;
            Ret = 0;
            Ret = listen(sockfdServer, backlog);
            if (Ret != 0) {
                printf("Listen socket failed.\n");
                close(sockfdServer);
                return 1;
            }

            printf("Listen socket host : [ %s ], port : [ %d ] successful.\n", host, port);

            while (1) {

                // 等待用戶端（Client）的交握（握手）（首次鏈接）（Handshake）請求;
                AddrLen = sizeof(ClientAddr);
                sockfdClient = accept(sockfdServer, (struct sockaddr *)&ClientAddr, &AddrLen);
                if (sockfdClient < 0) {
                    // perror("Accept client Handshake failed.\n");
                    printf("Accept client Handshake failed.\n");
                    break;
                    // return 1;
                    // exit(1);
                }

                // 當服務器端（Server）與用戶端（Client）交握（握手）（首次鏈接）（Handshake）動作成功時，從服務器端（Server）向用戶端返回響應（Response）資訊;
                // write(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
                send(sockfdClient, message_returned_from_server_when_Handshake_successful, strlen(message_returned_from_server_when_Handshake_successful), 0);

                printf("Client Handshake successful.\n");
                printf("listening to the host : [ %s ], port : [ %d ] ...\n", host, port);

                // // 創建一個子進程（thread），接收用戶端（Client）發送的請求（request）數據，并計算處理，然後將處理結果返回給用戶端;
                // hThread = CreateThread(NULL, 0, ClientThread, (LPVOID)ClientSocket, 0, NULL);
                // if (hThread == NULL) {
                //     printf("Create thread failed.\n");
                //     break;
                // }
                // CloseHandle(hThread);

                while (1) {
                    memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    Ret = 0;
                    // Ret = read(sockfdClient, RecvBuffer, sizeof(RecvBuffer));
                    Ret = recv(sockfdClient, RecvBuffer, sizeof(RecvBuffer), 0);
                    if (Ret < 0) {
                        // printf("Error, reading from socket client failed.\n");
                        printf("Client disconnect.\n");
                        // close(sockfdClient);
                        break;
                    }
                    printf("Client request information :\n%s\n", RecvBuffer);

                    // 判斷信號值（signum）是否爲「Ctrl+c」;
                    // if (signum == 2) {
                    // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                    if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                        // printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                        // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                        // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        // close(sockfdClient);
                        // exit(signum);
                        // exit(2);
                        break;
                    }

                    // 讀取用戶端（Client）請求（request）頭數據中的參數「Connection」的值;
                    memset(requestConnection, 0x00, sizeof(requestConnection));
                    // 使用：strstr() 函數檢查字符串："Hello World" 中是否包含字符串："World"，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
                    char *find_Head_Connection_begin = strstr(RecvBuffer, "Connection:");
                    if (find_Head_Connection_begin != NULL) {
                        find_Head_Connection_begin = find_Head_Connection_begin + strlen("Connection:");
                        char *find_Head_Connection_end = strstr(find_Head_Connection_begin, "\\r\\n");
                        if (find_Head_Connection_end != NULL) {
                            if ((find_Head_Connection_end - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, (find_Head_Connection_end - find_Head_Connection_begin));
                            }
                        } else {
                            if (((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin) > (sizeof(requestConnection) - 1)) {
                                strncpy(requestConnection, find_Head_Connection_begin, (sizeof(requestConnection) - 1));
                            } else {
                                strncpy(requestConnection, find_Head_Connection_begin, ((RecvBuffer + strlen(RecvBuffer)) - find_Head_Connection_begin));
                            }
                        }
                        // requestConnection[sizeof(requestConnection) - 1] = '\0'; // 確保終止字符：'\0' 存在;
                    }
                    // printf("Client request head [ Connection ] : [ %s ].\n", requestConnection);

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    memset(response_Data, 0x00, sizeof(response_Data));
                    // // 使用for循环遍历字符串;
                    // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    //     // printf("%c", result_do_Function[i]);
                    //     if (i < sizeof(response_Data)) {
                    //         response_Data[i] = result_do_Function[i];
                    //     }
                    // }
                    // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // printf("responsed string length : %d\n", sizeof(response_Data));
                    // printf("responsed string :\n%s\n", response_Data);
                    strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;

                    Ret = 0;
                    // Ret = write(sockfdClient, response_Data, sizeof(response_Data));
                    // Ret = write(sockfdClient, response_Data, strlen(response_Data));
                    Ret = send(sockfdClient, response_Data, strlen(response_Data), 0);
                    // if (Ret < 0) {
                    //     printf("Send information error.\n");
                    //     close(sockfdClient);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    printf("Server response information :\n%s\n", response_Data);

                    // // 讀取從鍵盤輸入的資訊並發給用戶端，形似 QQ 通訊軟體;
                    // // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // char SendBuffer[BUFFER_LEN_response];  // 服務端（Server）向用戶端（Client）發送響應（Response）數據的儲存變量;
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // // cin.getline(response_Data, sizeof(response_Data));
                    // printf("Enter the send informations :\n");
                    // // scanf("%s", response_Data);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // fgets(response_Data, sizeof(response_Data), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                    // // printf("%s\n", response_Data);
                    // // 刪除字符串末尾的換行符號（\n）;
                    // if (strlen(response_Data) > 0 && response_Data[strlen(response_Data) - 1] == '\n') {
                    //     response_Data[strlen(response_Data) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                    // }
                    // // char temp[100]; // 用於存儲不包含 \n 的部分
                    // // size_t len = strcspn(response_Data, "\n"); // 找到 \n 的位置;
                    // // strncpy(temp, response_Data, len); // 複製不包括 \n 的部分到 temp;
                    // // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                    // // char *token = strtok(response_Data, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                    // // printf("%s\n", response_Data);
                    // Ret = 0;
                    // // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                    // Ret = send(ClientSocket, response_Data, strlen(response_Data), 0);
                    // if (Ret < 0) {
                    //     printf("Send information error.\n");
                    //     close(sockfdClient);
                    //     memset(response_Data, 0x00, sizeof(response_Data));
                    //     break;
                    // }
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // printf("waiting ...\n");

                    // 檢查是否斷開與用戶端的鏈接;
                    // char requestConnection[16];  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
                    if (strncmp(requestConnection, "close", sizeof(requestConnection)) == 0) {
                        close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    } else if (strncmp(requestConnection, "keep-alive", sizeof(requestConnection)) == 0) {
                        // close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        // memset(requestConnection, 0x00, sizeof(requestConnection));
                        // break;
                    } else {
                        close(sockfdClient);
                        memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                        memset(response_Data, 0x00, sizeof(response_Data));
                        memset(requestConnection, 0x00, sizeof(requestConnection));
                        break;
                    }
                }

                // 判斷信號值（signum）是否爲「Ctrl+c」;
                // if (signum == 2) {
                // 判斷用戶端（Client）發送的請求（Request）信息是否爲字符串「"exit"」，如是則中止運行;
                if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    printf("Client request : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(response_Data, 0x00, sizeof(response_Data));
                    // close(sockfdClient);
                    // exit(signum);
                    // exit(2);
                    break;
                }
            }

            close(sockfdServer);  // 關閉 Socket 服務端（Server）對象;
            close(sockfdClient);  // 關閉 Socket 用戶端（Client）對象;

        } else {
            // perror("Invalid address version not supported : [ %s ].\n", IPversion);
            printf("Invalid address version not supported : [ %s ].\n", IPversion);
            return 1;
        }

    #else
        printf("Unknown operating system.\n");
        return 1;
        // exit(1);
    #endif

    return 0;
}

// 自定義的用戶端（http_client）函數程式;
// tcp_Client_「Sockets.Sockets.connect」;
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
) {
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
    // memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

    // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
    char SendBuffer[BUFFER_LEN_request];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
    // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
    char RecvBuffer[BUFFER_LEN_response];  // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
    // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;
    char message_returned_from_server_when_Handshake_successful[BUFFER_LEN];  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;

    // // 客戶端向服務器端發送的請求字符串;
    // request_String = Base.string(
    //     Line_1 + "\r\n",  // "GET / HTTP/1.1",
    //     "Host: " + Base.string(host) + ":" + Base.string(port) + "\r\n",  // "Host: 127.0.0.1:8000",
    //     "Connection: close" + "\r\n",  // "close", "keep-alive", // 'keep-alive' 維持客戶端和服務端的鏈接關係，當一個網頁打開完成後，客戶端和服務器之間用於傳輸 HTTP 數據的 TCP 鏈接不會關閉，如果客戶端再次訪問這個服務器上的網頁，會繼續使用這一條已經建立的鏈接;
    //     "Cookie: " + cookie_value + "\r\n",  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
    //     "Authorization: " + authorization_value + "\r\n",  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
    //     "Accept-Charset: utf-8" + "\r\n",
    //     // "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" + "\r\n",
    //     "Accept-Language: zh-TW,zh;q=0.9" + "\r\n",  // "zh-Hant-TW; q=0.8, zh-Hant; q=0.7, zh-Hans-CN; q=0.7, zh-Hans; q=0.5, en-US, en; q=0.3";
    //     "Content-Type:" + "text/html, text/plain; charset=utf-8" + "\r\n",  // 響應數據類型;
    //     // "Content-Type: text/plain, text/html; charset=utf-8" + "\r\n",  // "application/x-www-form-urlencoded; charset=utf-8"
    //     // "Cache-Control: no-cache" + "\r\n",
    //     // "Upgrade: " + "HTTP/1.0, HTTP/1.1, HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11" + "\r\n",
    //     // "Accept: " + "*/*" + "\r\n",
    //     // "Accept-Encoding: gzip, deflate, br" + "\r\n",
    //     "Content-Length: " + Base.string(strlen(postData)) + "\r\n",
    //     // "sec-ch-ua: \"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
    //     // "sec-ch-ua-mobile: 0",
    //     // "Upgrade-Insecure-Requests: 1",
    //     // "Purpose: prefetch",
    //     // "Sec-Fetch-Site: none",
    //     // "Sec-Fetch-Mode: navigate",
    //     // "Sec-Fetch-User: 1",
    //     // "Sec-Fetch-Dest: document",
    //     "Date: " + Base.string(now_time_string) + "\r\n",  // "2021/8/22 02:02:33"，服務端向客戶端返回響應的時間;
    //     "User-Agent: " + UserAgent + "\r\n",  // "Julia-1.6.2 Sockets.connect."，"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36";
    //     "From: " + requestFrom + "\r\n\r\n",  // "user@email.com",
    //     postData
    // );

    // // 合成請求頭（html head）和請求體（html body）數據;
    // int SendBuffer_length = strlen(requestMethod) + 1 + strlen(requestPath) + 1 + strlen(requestProtocol) + 1 + 1 + strlen("Host:") + strlen(host) + strlen(":") + 4 + 1 + 1 + strlen("Connection:") + strlen(requestConnection) + 1 + 1 + strlen("Cookie:") + strlen(Cookie) + 1 + 1 + strlen("Authorization:") + strlen(Authorization) + 1 + 1 + strlen("Accept-Charset:") + strlen("utf-8") + 1 + 1 + strlen("Accept-Language:") + strlen("zh-TW,zh;q=0.9") + 1 + 1 + strlen("Content-Type:") + strlen("text/html,text/plain;charset=utf-8") + 1 + 1 + strlen("Content-Length:") + 4 + 1 + 1 + strlen("From:") + strlen(requestFrom) +  1 + 1 + strlen("Date:") + strlen(now_time_string) + 1 + 1 + strlen("User-Agent:") + strlen("C-socket-connect.") + 1 + 1 + 1 + 1 + strlen(postData) + 1;
    // char SendBuffer[SendBuffer_length];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
    // memset(SendBuffer, 0x00, sizeof(SendBuffer));  // 初始化 SendBuff 重置爲 0 值;
    // snprintf(SendBuffer, sizeof(SendBuffer), "%s%s%s%s%s%s%s%s%s%s%d%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%d%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s", requestMethod, " ", requestPath, " ", requestProtocol, "\\r", "\\n", "Host:", host, ":", port, "\\r", "\\n", "Connection:", requestConnection, "\\r", "\\n", "Cookie:", Cookie, "\\r", "\\n", "Authorization:", Authorization, "\\r", "\\n", "Accept-Charset:", "utf-8", "\\r", "\\n", "Accept-Language:", "zh-TW,zh;q=0.9", "\\r", "\\n", "Content-Type:", "text/html,text/plain;charset=utf-8", "\\r", "\\n", "Content-Length:", strlen(postData), "\\r", "\\n", "From:", requestFrom, "\\r", "\\n", "Date:", now_time_string, "\\r", "\\n", "User-Agent:", "C-socket-connect.", "\\r", "\\n", "\\r", "\\n", postData);
    // // printf("用戶端（Client）向服務端發送的請求（request）數據爲：\n%s\n", SendBuffer);
    // // SendBuffer_length = strlen(SendBuffer);
    // // printf("%d\n", SendBuffer_length);
    // // SendBuffer[strlen(SendBuffer)] = '\0';
    // // printf("用戶端（Client）向服務端發送的請求（request）數據爲：\n%s\n", SendBuffer);
    // // SendBuffer_length = strlen(SendBuffer);
    // // printf("%d\n", SendBuffer_length);
    // // postData = strdup(SendBuffer);  // 函數：strdup(SendBuffer) 表示，指針傳值，深拷貝，需要 free(postData) 釋放内存;
    // // postData_length = strlen(postData);
    // // free(postData);
    // // postData = NULL;

    // 區分操作系統 Windows MingW-w64 gcc 或 Linux-Ubuntu ( Android-Termux ) gcc 系統;
    #if defined(__WINDOWS__)

        WSADATA Ws;
        SOCKET ClientSocket;
        HANDLE hThread = NULL;

        // 判斷服務器（Server）監聽 IP 地址版本："IPv6" or "IPv4"，據此創建相對應的套接字（Socket）對象;
        if (strncmp(IPversion, "IPv4", sizeof(IPversion)) == 0) {

            int socket_desc = 0;
            struct sockaddr_in ClientAddr;
            int Ret = 0;
            int AddrLen = 0;
            // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            // char SendBuffer[BUFFER_LEN_request];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            int str_len = 0;
            // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // char RecvBuffer[BUFFER_LEN_response];  // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;
            // char message_returned_from_server_when_Handshake_successful[BUFFER_LEN];  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;

            // Initialization Windows Socket; 初始化 Windows 作業系統通訊端接口對象（套接字）（插座）;
            if (WSAStartup(MAKEWORD(2, 2), &Ws) != 0) {
                printf("Initialization Windows Socket Failed.\n");
                return 1;
            }

            // Create Socket; 創建通訊端接口對象（套接字）（插座）;
            ClientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (ClientSocket == INVALID_SOCKET) {
                printf("Create socket failed.\n");
                // closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // 讀取自定義的鏈接主機 IP 埠號;
            // 判斷自定義傳入的鏈接主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            AddrLen = sizeof(ClientAddr);
            socket_desc = 0;
            socket_desc = WSAStringToAddressA(host, AF_INET, NULL, (struct sockaddr *)&ClientAddr, &AddrLen);
            if (socket_desc != 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }
            AddrLen = 0;
            socket_desc = 0;  // 復位還原;
            // if (inet_pton(AF_INET, host, &ClientAddr.sin_addr) <= 0) {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ClientSocket);
            //     return 1;
            // }
            memset(&ClientAddr, 0x00, sizeof(ClientAddr));  // 將 ClientAddr 的所有位初始化爲零;
            memset(ClientAddr.sin_zero, 0x00, 8);
            ClientAddr.sin_family = AF_INET;
            // ClientAddr.sin_addr.s_addr = inet_addr(host);
            AddrLen = sizeof(ClientAddr);
            WSAStringToAddressA(host, AF_INET, NULL, (struct sockaddr *)&ClientAddr, &AddrLen);
            // inet_pton(AF_INET, host, &ClientAddr.sin_addr);
            ClientAddr.sin_port = htons(port);

            // 發送鏈接服務器端（Server）交握（握手）（首次鏈接）（Handshake）請求;
            Ret = 0;
            Ret = connect(ClientSocket, (struct sockaddr *)&ClientAddr, sizeof(ClientAddr));
            if (Ret == SOCKET_ERROR) {
                printf("Connect socket failed.\n");
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            } else {
                printf("Connect socket host : [ %s ] port : [ %d ] successful.\n", host, port);
            }

            // 當用戶端（Client）與服務器端（Server）交握（握手）（首次鏈接）（Handshake）成功時，讀取從服務器端（Server）返回的響應（Response）資訊字符串;
            str_len = 0;
            // read(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
            str_len = recv(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful), 0);
            if (str_len >= 0) {
                message_returned_from_server_when_Handshake_successful[str_len] = '\0';
                printf("Handshake successful.\n");
                printf("Server return :\n%s\n", message_returned_from_server_when_Handshake_successful);
                printf("connecting to the host : [ %s ] port : [ %d ] ...\n", host, port);
            // } else if (str_len == 0) {
            //     printf("Connection ( Handshake ) closed.\n");
            //     closesocket(ClientSocket);
            //     return 1;
            } else {
                // perror("recv failed.\n");
                printf("Receive message from server when Handshake failed.\n");
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // 循環向服務器端（Server）發送請求（Request）數據並從向服務器端（Server）接收響應（Response）數據;
            while (1) {

                memset(SendBuffer, 0x00, sizeof(SendBuffer));
                // cin.getline(SendBuffer, sizeof(SendBuffer));
                printf("Enter the send informations :\n");
                // scanf("%s", SendBuffer);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                fgets(SendBuffer, sizeof(SendBuffer), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                // printf("%s\n", SendBuffer);
                // 刪除字符串末尾的換行符號（\n）;
                if (strlen(SendBuffer) > 0 && SendBuffer[strlen(SendBuffer) - 1] == '\n') {
                    SendBuffer[strlen(SendBuffer) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                }
                // char temp[100]; // 用於存儲不包含 \n 的部分
                // size_t len = strcspn(SendBuffer, "\n"); // 找到 \n 的位置;
                // strncpy(temp, SendBuffer, len); // 複製不包括 \n 的部分到 temp;
                // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                // char *token = strtok(SendBuffer, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                // printf("%s\n", SendBuffer);

                Ret = 0;
                // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                Ret = send(ClientSocket, SendBuffer, strlen(SendBuffer), 0);
                if (Ret == SOCKET_ERROR) {
                    printf("Send information error.\n");
                    break;
                }

                // 當鍵盤輸入值爲字符串「"exit"」時，中止 while 循環;
                if (strncmp(SendBuffer, "exit", sizeof(SendBuffer)) == 0) {
                    printf("Standard input (stdio) : [ %s ] received.\nProgram aborted.\n", SendBuffer);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    // exit(2);
                    break;
                }

                memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                // printf("from server receiving ...\n");
                str_len = 0;
                // str_len = read(ClientSocket, RecvBuffer, sizeof(RecvBuffer) - 1);
                str_len = recv(ClientSocket, RecvBuffer, sizeof(RecvBuffer), 0);
                if (str_len < 0) {
                    // printf("Error, reading from socket server failed.\n");
                    printf("Server disconnect.\n");
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    break;
                    // return 1;
                    // exit(1);
                } else {
                    printf("Server response information :\n%s\n", RecvBuffer);

                    // // 判斷服務端（Server）發送的響應（response）信息是否爲字符串「"exit"」，如是則中止運行;
                    // if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    //     printf("Server response : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    //     // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    //     // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    //     // exit(signum);
                    //     // exit(2);
                    //     break;
                    // }

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    // char response_Data[BUFFER_LEN_response];
                    // // memset(response_Data, 0x00, sizeof(response_Data));
                    // // // 使用for循环遍历字符串;
                    // // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    // //     // printf("%c", result_do_Function[i]);
                    // //     if (i < sizeof(response_Data)) {
                    // //         response_Data[i] = result_do_Function[i];
                    // //     }
                    // // }
                    // // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // printf("responsed string length : %d\n", sizeof(response_Data));
                    // // printf("responsed string :\n%s\n", response_Data);
                    // strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;
                }
            }

            closesocket(ClientSocket);  // 關閉 Socket 用戶端（Client）對象;
            WSACleanup();  // 初始化重置清空;

        } else if (strncmp(IPversion, "IPv6", sizeof(IPversion)) == 0) {

            int socket_desc = 0;
            struct sockaddr_in6 ClientAddr;
            int Ret = 0;
            int AddrLen = 0;
            // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            // char SendBuffer[BUFFER_LEN_request];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            int str_len = 0;
            // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // char RecvBuffer[BUFFER_LEN_response];  // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;
            // char message_returned_from_server_when_Handshake_successful[BUFFER_LEN];  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;

            // Initialization Windows Socket; 初始化 Windows 作業系統通訊端接口對象（套接字）（插座）;
            if (WSAStartup(MAKEWORD(2, 2), &Ws) != 0) {
                printf("Initialization Windows Socket Failed.\n");
                return 1;
            }

            // Create Socket; 創建通訊端接口對象（套接字）（插座）;
            ClientSocket = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
            if (ClientSocket == INVALID_SOCKET) {
                printf("Could not create socket.\n");
                // closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // 寫入自定義的監聽地址;
            // 判斷自定義傳入的監聽主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            AddrLen = sizeof(ClientAddr);
            socket_desc = 0;
            socket_desc = WSAStringToAddressA(host, AF_INET6, NULL, (struct sockaddr *)&ClientAddr, &AddrLen);
            if (socket_desc != 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }
            AddrLen = 0;
            socket_desc = 0;  // 復位還原;
            // if (inet_pton(AF_INET6, host, &ClientAddr.sin6_addr) <= 0) {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ClientSocket);
            //     return 1;
            // }
            memset(&ClientAddr, 0x00, sizeof(ClientAddr));  // 將 ClientAddr 的所有位初始化爲零;
            // ZeroMemory(&ClientAddr, sizeof(ClientAddr));  // 將 ClientAddr 的所有位初始化爲零;
            ClientAddr.sin6_family = AF_INET6;  // 使用 IPv6 地址族;
            AddrLen = sizeof(ClientAddr);
            WSAStringToAddressA(host, AF_INET6, NULL, (struct sockaddr *)&ClientAddr, &AddrLen);
            // inet_pton(AF_INET6, host, &ClientAddr.sin6_addr);  // 指定接收自定義 IPv6 地址主機請求鏈接;
            // if (strncmp(host, "::0", sizeof(host)) == 0) {
            //     ClientAddr.sin6_addr = in6addr_any;  // 使用：in6addr_any 常量表示允許接收來自網絡中所有 IPv6 地址的主機請求鏈接;
            // } else if (strncmp(host, "::1", sizeof(host)) == 0) {
            //     ClientAddr.sin6_addr = in6addr_loopback;  // 使用：in6addr_loopback 常量表示只允許接收來自本機 localhost（IPv6）的鏈接請求;
            // } else {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     closesocket(ClientSocket);
            //     WSACleanup();  // 初始化重置清空;
            //     return 1;
            // }
            ClientAddr.sin6_port = htons(port);  // 埠號，需以網絡字節序設置;

            // 發送鏈接服務器端（Server）交握（握手）（首次鏈接）（Handshake）請求;
            Ret = 0;
            Ret = connect(ClientSocket, (struct sockaddr *)&ClientAddr, sizeof(ClientAddr));
            if (Ret == SOCKET_ERROR) {
                printf("Connect socket failed.\n");
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            } else {
                printf("Connect socket host : [ %s ] port : [ %d ] successful.\n", host, port);
            }

            // 當用戶端（Client）與服務器端（Server）交握（握手）（首次鏈接）（Handshake）成功時，讀取從服務器端（Server）返回的響應（Response）資訊字符串;
            str_len = 0;
            // read(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
            str_len = recv(ClientSocket, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful), 0);
            if (str_len >= 0) {
                message_returned_from_server_when_Handshake_successful[str_len] = '\0';
                printf("Handshake successful.\n");
                printf("Server return :\n%s\n", message_returned_from_server_when_Handshake_successful);
                printf("connecting to the host : [ %s ] port : [ %d ] ...\n", host, port);
            // } else if (str_len == 0) {
            //     printf("Connection ( Handshake ) closed.\n");
            //     closesocket(ClientSocket);
            //     return 1;
            } else {
                // perror("recv failed.\n");
                printf("Receive message from server when Handshake failed.\n");
                closesocket(ClientSocket);
                WSACleanup();  // 初始化重置清空;
                return 1;
            }

            // 循環向服務器端（Server）發送請求（Request）數據並從向服務器端（Server）接收響應（Response）數據;
            while (1) {

                memset(SendBuffer, 0x00, sizeof(SendBuffer));
                // cin.getline(SendBuffer, sizeof(SendBuffer));
                printf("Enter the send informations :\n");
                // scanf("%s", SendBuffer);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                fgets(SendBuffer, sizeof(SendBuffer), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                // printf("%s\n", SendBuffer);
                // 刪除字符串末尾的換行符號（\n）;
                if (strlen(SendBuffer) > 0 && SendBuffer[strlen(SendBuffer) - 1] == '\n') {
                    SendBuffer[strlen(SendBuffer) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                }
                // char temp[100]; // 用於存儲不包含 \n 的部分
                // size_t len = strcspn(SendBuffer, "\n"); // 找到 \n 的位置;
                // strncpy(temp, SendBuffer, len); // 複製不包括 \n 的部分到 temp;
                // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                // char *token = strtok(SendBuffer, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                // printf("%s\n", SendBuffer);

                Ret = 0;
                // Ret = send(ClientSocket, SendBuffer, (int)strlen(SendBuffer), 0);
                Ret = send(ClientSocket, SendBuffer, strlen(SendBuffer), 0);
                if (Ret == SOCKET_ERROR) {
                    printf("Send information error.\n");
                    break;
                }

                // 當鍵盤輸入值爲字符串「"exit"」時，中止 while 循環;
                if (strncmp(SendBuffer, "exit", sizeof(SendBuffer)) == 0) {
                    printf("Standard input (stdio) : [ %s ] received.\nProgram aborted.\n", SendBuffer);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    // exit(2);
                    break;
                }

                memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                // printf("from server receiving ...\n");
                str_len = 0;
                // str_len = read(ClientSocket, RecvBuffer, sizeof(RecvBuffer) - 1);
                str_len = recv(ClientSocket, RecvBuffer, sizeof(RecvBuffer), 0);
                if (str_len < 0) {
                    // printf("Error, reading from socket server failed.\n");
                    printf("Server disconnect.\n");
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    break;
                    // return 1;
                    // exit(1);
                } else {
                    printf("Server response information :\n%s\n", RecvBuffer);

                    // // 判斷服務端（Server）發送的響應（response）信息是否爲字符串「"exit"」，如是則中止運行;
                    // if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    //     printf("Server response : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    //     // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    //     // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    //     // exit(signum);
                    //     // exit(2);
                    //     break;
                    // }

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    // char response_Data[BUFFER_LEN_response];
                    // // memset(response_Data, 0x00, sizeof(response_Data));
                    // // // 使用for循环遍历字符串;
                    // // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    // //     // printf("%c", result_do_Function[i]);
                    // //     if (i < sizeof(response_Data)) {
                    // //         response_Data[i] = result_do_Function[i];
                    // //     }
                    // // }
                    // // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // printf("responsed string length : %d\n", sizeof(response_Data));
                    // // printf("responsed string :\n%s\n", response_Data);
                    // strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;
                }
            }

            closesocket(ClientSocket);  // 關閉 Socket 用戶端（Client）對象;
            WSACleanup();  // 初始化重置清空;

        } else {
            // perror("Invalid address version not supported : [ %s ].\n", IPversion);
            printf("Invalid address version not supported : [ %s ].\n", IPversion);
            return 1;
        }

    #elif defined(__linux__)

        int sockfdClient = 0;

        // 判斷服務器（Server）監聽 IP 地址版本："IPv6" or "IPv4"，據此創建相對應的套接字（Socket）對象;
        if (strncmp(IPversion, "IPv4", sizeof(IPversion)) == 0) {

            struct sockaddr_in ClientAddr;
            int Ret = 0;
            // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            // char SendBuffer[BUFFER_LEN_request];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            int str_len;
            // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // char RecvBuffer[BUFFER_LEN_response];  // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;
            // char message_returned_from_server_when_Handshake_successful[BUFFER_LEN];  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;

            // Create Socket; 創建通訊端接口對象（套接字）（插座）;
            sockfdClient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (sockfdClient < 0) {
                // perror("Create socket failed.\n");
                printf("Create socket failed.\n");
                // close(sockfdClient);
                return 1;
                // exit(1)
            }

            // 讀取自定義的鏈接主機 IP 埠號;
            // 判斷自定義傳入的鏈接主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            if (inet_pton(AF_INET, host, &ClientAddr.sin_addr) <= 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                close(sockfdClient);
                return 1;
            }
            memset(&ClientAddr, 0x00, sizeof(ClientAddr));  // 將 ClientAddr 的所有位初始化爲零;
            memset(ClientAddr.sin_zero, 0x00, 8);
            ClientAddr.sin_family = AF_INET;
            // ClientAddr.sin_addr.s_addr = inet_addr(host);
            inet_pton(AF_INET, host, &ClientAddr.sin_addr);
            ClientAddr.sin_port = htons(port);

            // 發送鏈接服務器端（Server）交握（握手）（首次鏈接）（Handshake）請求;
            Ret = 0;
            Ret = connect(sockfdClient, (struct sockaddr *)&ClientAddr, sizeof(ClientAddr));
            if (Ret < 0) {
                printf("Connect socket failed.\n");
                close(sockfdClient);
                return 1;
            } else {
                printf("Connect socket host : [ %s ] port : [ %d ] successful.\n", host, port);
            }

            // 當用戶端（Client）與服務器端（Server）交握（握手）（首次鏈接）（Handshake）成功時，讀取從服務器端（Server）返回的響應（Response）資訊字符串;
            str_len = 0;
            // read(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
            str_len = recv(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful), 0);
            if (str_len >= 0) {
                message_returned_from_server_when_Handshake_successful[str_len] = '\0';
                printf("Handshake successful.\n");
                printf("Server return :\n%s\n", message_returned_from_server_when_Handshake_successful);
                printf("connecting to the host : [ %s ] port : [ %d ] ...\n", host, port);
            // } else if (str_len == 0) {
            //     printf("Connection ( Handshake ) closed.\n");
            //     close(sockfdClient);
            //     return 1;
            } else {
                // perror("recv failed.\n");
                printf("Receive message from server when Handshake failed.\n");
                close(sockfdClient);
                return 1;
            }

            // 循環向服務器端（Server）發送請求（Request）數據並從向服務器端（Server）接收響應（Response）數據;
            while (1) {
                memset(SendBuffer, 0x00, sizeof(SendBuffer));
                // cin.getline(SendBuffer, sizeof(SendBuffer));
                printf("Enter the send informations :\n");
                // scanf("%s", SendBuffer);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                fgets(SendBuffer, sizeof(SendBuffer), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                // printf("%s\n", SendBuffer);
                // 刪除字符串末尾的換行符號（\n）;
                if (strlen(SendBuffer) > 0 && SendBuffer[strlen(SendBuffer) - 1] == '\n') {
                    SendBuffer[strlen(SendBuffer) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                }
                // char temp[100]; // 用於存儲不包含 \n 的部分
                // size_t len = strcspn(SendBuffer, "\n"); // 找到 \n 的位置;
                // strncpy(temp, SendBuffer, len); // 複製不包括 \n 的部分到 temp;
                // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                // char *token = strtok(SendBuffer, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                // printf("%s\n", SendBuffer);

                Ret = 0;
                Ret = send(sockfdClient, SendBuffer, strlen(SendBuffer), 0);
                if (Ret < 0) {
                    printf("Send information error.\n");
                    break;
                }

                // 當鍵盤輸入值爲字符串「"exit"」時，中止 while 循環;
                if (strncmp(SendBuffer, "exit", sizeof(SendBuffer)) == 0) {
                    printf("Standard input (stdio) : [ %s ] received.\nProgram aborted.\n", SendBuffer);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    // exit(2);
                    break;
                }

                memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                // printf("from server receiving ...\n");
                str_len = 0;
                // str_len = read(sockfdClient, RecvBuffer, sizeof(RecvBuffer) - 1);
                str_len = recv(sockfdClient, RecvBuffer, sizeof(RecvBuffer), 0);
                if (str_len < 0) {
                    // printf("Error, reading from socket server failed.\n");
                    printf("Server disconnect.\n");
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    break;
                    // return 1;
                    // exit(1);
                } else {
                    printf("Server response information :\n%s\n", RecvBuffer);

                    // // 判斷服務端（Server）發送的響應（response）信息是否爲字符串「"exit"」，如是則中止運行;
                    // if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    //     printf("Server response : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    //     // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    //     // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    //     // exit(signum);
                    //     // exit(2);
                    //     break;
                    // }

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    // char response_Data[BUFFER_LEN_response];
                    // // memset(response_Data, 0x00, sizeof(response_Data));
                    // // // 使用for循环遍历字符串;
                    // // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    // //     // printf("%c", result_do_Function[i]);
                    // //     if (i < sizeof(response_Data)) {
                    // //         response_Data[i] = result_do_Function[i];
                    // //     }
                    // // }
                    // // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // printf("responsed string length : %d\n", sizeof(response_Data));
                    // // printf("responsed string :\n%s\n", response_Data);
                    // strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;
                }
            }

            close(sockfdClient);  // 關閉 Socket 用戶端（Client）對象;

        } else if (strncmp(IPversion, "IPv6", sizeof(IPversion)) == 0) {

            struct sockaddr_in6 ClientAddr;
            int Ret = 0;
            // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            // char SendBuffer[BUFFER_LEN_request];  // 用戶端（Client）向服務端（Server）發送請求（Request）數據的儲存變量;
            int str_len;
            // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // char RecvBuffer[BUFFER_LEN_response];  // 用戶端（Client）從服務端（Server）接收響應（Response）數據的儲存變量;
            // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;
            // char message_returned_from_server_when_Handshake_successful[BUFFER_LEN];  // 當服務器端（Server）收到從用戶端（Client）發來的交握（握手）（首次鏈接）（Handshake）請求，並且交握（握手）（首次鏈接）（Handshake）成功時，用於接收從服務器端（Server）向用戶端返回的響應（Response）資訊的儲存變量;

            // Create Socket; 創建通訊端接口對象（套接字）（插座）;
            sockfdClient = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
            if (sockfdClient < 0) {
                // perror("Create socket failed.\n");
                printf("Create socket failed.\n");
                // close(sockfdClient);
                return 1;
                // exit(1)
            }

            // 讀取自定義的鏈接主機 IP 埠號;
            // 判斷自定義傳入的鏈接主機 IP 地址參數是否合規，將主機 IP 地址轉換爲網絡字節序的二進位形式;
            if (inet_pton(AF_INET6, host, &ClientAddr.sin6_addr) <= 0) {
                // perror("Invalid address not supported : [ %s ].\n", host);
                printf("Invalid address not supported : [ %s ].\n", host);
                close(sockfdClient);
                return 1;
            }
            memset(&ClientAddr, 0x00, sizeof(ClientAddr));  // 將 ClientAddr 的所有位初始化爲零;
            ClientAddr.sin6_family = AF_INET6;  // 使用 IPv6 地址族;
            inet_pton(AF_INET6, host, &ClientAddr.sin6_addr);  // 指定接收自定義 IPv6 地址主機請求鏈接;
            // if (strncmp(host, "::0", sizeof(host)) == 0) {
            //     ClientAddr.sin6_addr = in6addr_any;  // 使用：in6addr_any 常量表示允許接收來自網絡中所有 IPv6 地址的主機請求鏈接;
            // } else if (strncmp(host, "::1", sizeof(host)) == 0) {
            //     ClientAddr.sin6_addr = in6addr_loopback;  // 使用：in6addr_loopback 常量表示只允許接收來自本機 localhost（IPv6）的鏈接請求;
            // } else {
            //     // perror("Invalid address not supported : [ %s ].\n", host);
            //     printf("Invalid address not supported : [ %s ].\n", host);
            //     close(sockfdClient);
            //     return 1;
            // }
            ClientAddr.sin6_port = htons(port);  // 埠號，需以網絡字節序設置;

            // 發送鏈接服務器端（Server）交握（握手）（首次鏈接）（Handshake）請求;
            Ret = 0;
            Ret = connect(sockfdClient, (struct sockaddr *)&ClientAddr, sizeof(ClientAddr));
            if (Ret < 0) {
                printf("Connect socket failed.\n");
                close(sockfdClient);
                return 1;
            } else {
                printf("Connect socket host : [ %s ] port : [ %d ] successful.\n", host, port);
            }

            // 當用戶端（Client）與服務器端（Server）交握（握手）（首次鏈接）（Handshake）成功時，讀取從服務器端（Server）返回的響應（Response）資訊字符串;
            str_len = 0;
            // read(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful));
            str_len = recv(sockfdClient, message_returned_from_server_when_Handshake_successful, sizeof(message_returned_from_server_when_Handshake_successful), 0);
            if (str_len >= 0) {
                message_returned_from_server_when_Handshake_successful[str_len] = '\0';
                printf("Handshake successful.\n");
                printf("Server return :\n%s\n", message_returned_from_server_when_Handshake_successful);
                printf("connecting to the host : [ %s ] port : [ %d ] ...\n", host, port);
            // } else if (str_len == 0) {
            //     printf("Connection ( Handshake ) closed.\n");
            //     close(sockfdClient);
            //     return 1;
            } else {
                // perror("recv failed.\n");
                printf("Receive message from server when Handshake failed.\n");
                close(sockfdClient);
                return 1;
            }

            // 循環向服務器端（Server）發送請求（Request）數據並從向服務器端（Server）接收響應（Response）數據;
            while (1) {

                memset(SendBuffer, 0x00, sizeof(SendBuffer));
                // cin.getline(SendBuffer, sizeof(SendBuffer));
                printf("Enter the send informations :\n");
                // scanf("%s", SendBuffer);  // 使用函數：scanf() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                fgets(SendBuffer, sizeof(SendBuffer), stdin);  // 使用函數：fgets() 讀取從鍵盤輸入的字符串，並保存至自定義的 SendBuffer 字符串數組;
                // printf("%s\n", SendBuffer);
                // 刪除字符串末尾的換行符號（\n）;
                if (strlen(SendBuffer) > 0 && SendBuffer[strlen(SendBuffer) - 1] == '\n') {
                    SendBuffer[strlen(SendBuffer) - 1] = '\0'; // 覆蓋 \n 為字符串終結符;
                }
                // char temp[100]; // 用於存儲不包含 \n 的部分
                // size_t len = strcspn(SendBuffer, "\n"); // 找到 \n 的位置;
                // strncpy(temp, SendBuffer, len); // 複製不包括 \n 的部分到 temp;
                // temp[len] = '\0'; // 確保 temp 是正確終結的字符串;
                // char *token = strtok(SendBuffer, "\n");  // 函數：strtok() 表示分割字符串，本例使用換行符號（\n）分割字符串，即刪除原字符串末尾的換行符號（\n）;
                // printf("%s\n", SendBuffer);

                Ret = 0;
                Ret = send(sockfdClient, SendBuffer, strlen(SendBuffer), 0);
                if (Ret < 0) {
                    printf("Send information error.\n");
                    break;
                }

                // 當鍵盤輸入值爲字符串「"exit"」時，中止 while 循環;
                if (strncmp(SendBuffer, "exit", sizeof(SendBuffer)) == 0) {
                    printf("Standard input (stdio) : [ %s ] received.\nProgram aborted.\n", SendBuffer);
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    // exit(2);
                    break;
                }

                memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                // printf("from server receiving ...\n");
                str_len = 0;
                // str_len = read(sockfdClient, RecvBuffer, sizeof(RecvBuffer) - 1);
                str_len = recv(sockfdClient, RecvBuffer, sizeof(RecvBuffer), 0);
                if (str_len < 0) {
                    // printf("Error, reading from socket server failed.\n");
                    printf("Server disconnect.\n");
                    // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    break;
                    // return 1;
                    // exit(1);
                } else {
                    printf("Server response information :\n%s\n", RecvBuffer);

                    // // 判斷服務端（Server）發送的響應（response）信息是否爲字符串「"exit"」，如是則中止運行;
                    // if (strncmp(RecvBuffer, "exit", sizeof(RecvBuffer)) == 0) {
                    //     printf("Server response : [ %s ] received.\nProgram aborted.\n", RecvBuffer);
                    //     // printf("Standard input (stdio) : %s , Interrupt signal (%d) received.\nProgram aborted.\n", "[ Ctrl + c ]", signum);
                    //     // memset(RecvBuffer, 0x00, sizeof(RecvBuffer));
                    //     // memset(SendBuffer, 0x00, sizeof(SendBuffer));
                    //     // exit(signum);
                    //     // exit(2);
                    //     break;
                    // }

                    // 自定義函數 do_Function() 處理計算請求數據;
                    char *result_do_Function = "";
                    result_do_Function = do_Function(0, RecvBuffer);
                    // printf("do_Function result string length : %d\n", sizeMalloc(result_do_Function));
                    // printf("do_Function result string length : %d\n", strlen(result_do_Function));

                    // // 響應值，將運算結果變量 result_do_Function 傳值複製到響應值變量 response_Data 内;
                    // char response_Data[BUFFER_LEN_response];
                    // // memset(response_Data, 0x00, sizeof(response_Data));
                    // // // 使用for循环遍历字符串;
                    // // for (i = 0; result_do_Function[i] != '\0'; i++) {
                    // //     // printf("%c", result_do_Function[i]);
                    // //     if (i < sizeof(response_Data)) {
                    // //         response_Data[i] = result_do_Function[i];
                    // //     }
                    // // }
                    // // response_Data[i] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0'（NULL）存在;
                    // // printf("responsed string length : %d\n", sizeof(response_Data));
                    // // printf("responsed string :\n%s\n", response_Data);
                    // strncpy(response_Data, result_do_Function, sizeof(response_Data) - 1); // 確保留出空間給終止字符：'\0';
                    // response_Data[sizeof(response_Data) - 1] = '\0'; // 確保終止字符：'\0' 存在;

                    free(result_do_Function);  // 釋放内存防止溢出;
                }
            }

            close(sockfdClient);  // 關閉 Socket 用戶端（Client）對象;

        } else {
            // perror("Invalid address version not supported : [ %s ].\n", IPversion);
            printf("Invalid address version not supported : [ %s ].\n", IPversion);
            return 1;
        }

    #else
        printf("Unknown operating system.\n");
        return 1;
        // exit(1);
    #endif

    return 0;
}


// char *NoteVersion = "C language tcp server and tcp client and file monitor Interface v20161211\nGoogle-Pixel-2 Android-11 Termux-0.118 Ubuntu-22.04 Arm64 Qualcomm-Snapdragon-855\ngcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nC socket server and client\nC file server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n";
// char *NoteHelp = "C language tcp server and tcp client and file monitor Interface v20161211\nGoogle-Pixel-2 Android-11 Termux-0.118 Ubuntu-22.04 Arm64 Qualcomm-Snapdragon-855\ngcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0\nWindows10 x86_64 Inter(R)-Core(TM)-m3-6Y30\ngcc (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0\nC socket server and client\nC file server\n283640621@qq.com\n+8618604537694\n弘毅\n歲在丙申\n\n--help -h ? --version -v\n\nconfigFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={\"Client_say\":\"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24T14:05:33.286\"}\n\nconfigFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={\"Client_say\":\"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24T14:05:33.286\"}\n";

// // 控制臺傳參，直接使用 gcc 的：main() 函數參數，獲取從控制臺傳入的參數，注意 C 語言的 main() 函數的參數是兩個，第一個是參數的數量（參數數組的長度），第二個是參數的數組;
// int main (int argc, char *argv[]) {

//     // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;
//     signal(SIGINT, signalHandler);  // 註冊信號 SIGINT 和對應的處理函數，當收到鍵盤輸入「Ctrl+c」時，中止（exit）進程;

//     // 判斷控制臺命令行是否有傳入參數，若有傳入參數，則繼續判斷是否爲：查詢信息指令;
//     if (argc > 1) {
//         // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
//         // 使用函數：strncmp(argv[1], "--version", sizeof(argv[1])) == 0 判斷兩個字符串是否相等;
//         if ((strncmp(argv[1], "--version", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-v", sizeof(argv[1])) == 0)) {
//             printf("%s\n", NoteVersion);
//             return 0;  // 跳出函數，中止運行後續的代碼;
//         }
//         // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
//         if ((strncmp(argv[1], "--help", sizeof(argv[1])) == 0) || (strncmp(argv[1], "-h", sizeof(argv[1])) == 0) || (strncmp(argv[1], "?", sizeof(argv[1])) == 0)) {
//             printf("%s\n", NoteHelp);
//             return 0;  // 跳出函數，中止運行後續的代碼;
//         }
//     }

//     // 獲取當前時間
//     time_t current_time;
//     time(&current_time); 
//     // struct tm *local_time = localtime(&current_time);  // 將時間轉換為本地時間;
//     struct tm *timeinfo = gmtime(&current_time);  // 將當前時間轉換為 UTC 時間;
//     // 定義一個足夠大的字符串來保存日期和時間
//     char now_time_string[80];
//     // 使用 strftime 將時間格式化為字符串
//     // "%Y-%m-%d %H:%M:%S" 是日期和時間的格式，你可以根據需要更改格式;
//     // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S %Z", local_time);
//     // printf("當前時間是：%s\n", now_time_string);
//     // strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S Universal Time Coordinated", timeinfo);
//     strftime(now_time_string, sizeof(now_time_string), "%Y-%m-%d %H:%M:%S", timeinfo);
//     // printf("UTC time: %s\n", now_time_string);
//     memset(now_time_string, 0, sizeof(now_time_string));  // 清空字符串數組;

//     char *configFile = "";  // 配置文檔的保存路徑參數："C:/Criss/config.txt"

//     char *isBlock = "";  // 子進程中的，控制臺命令行程式，運行時，是否阻塞主進程後續代碼的執行;
//     // isBlock = "true";  // 初始預設值爲："true"，即：阻塞主進程後續代碼的執行;
//     // printf("isBlock = %s\n", isBlock);

//     char *interface_Function_name_str = "";  // 判斷啓動服務器（server）或是用戶端（client）程式;
//     interface_Function_name_str = "tcp_Server";  // "file_Monitor";  // "tcp_Server";  // "http_Server";  // "tcp_Client";  // "http_Client";  // "interface_File_Monitor";  // "interface_TCP_Server";  // "interface_http_Server";  // "interface_TCP_Client";  // "interface_http_Client";
//     // printf("interface Function name = %s\n", interface_Function_name_str);

//     char *IPversion = "IPv6";  // "IPv6"、"IPv4";
//     int serverPORT = -1;  // 定義服務器端（server）監聽埠號整型數據儲存變量;
//     serverPORT = 10001;  // 定義服務器端（server）預設埠號整數;
//     char *serverIPaddress = "";  // 聲明服務器端（server）監聽 IPv4 or IPv6 地址字符串型數據儲存變量;
//     serverIPaddress = "::0";  // "::0";  // "0.0.0.0";  // 定義服務器端（server）預設 IPv4 or IPv6 地址字符串;
//     int clientPORT = -1;  // 定義用戶端（client）鏈接埠號整型數據儲存變量;
//     clientPORT = 10001;  // 定義用戶端（client）預設埠號整數;
//     char *clientIPaddress = "";  // 聲明用戶端（client）鏈接 IPv4 or IPv6 地址字符串型數據儲存變量;
//     clientIPaddress = "::1";  // "::1";  // "127.0.0.1";  // 定義用戶端（client）預設 IPv4 or IPv6 地址字符串;

//     char *sessionString = "";  // "{\"request_Key->username:password\":\"username:password\"}";
//     sessionString = "{\"request_Key->username:password\":\"username:password\"}";
//     char *postData = "";
//     postData = "{\"Client_say\":\"language C Socket client connection. 在這裏輸入向服務端發送的待處理的數據.\",\"time\":\"2021-04-24 14:05:33.286\"}";
//     char *requestURL = "";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // "http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1";
//     requestURL = "http://username:password@localhost:10001/";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";
//     char *requestPath = "/";
//     char *requestMethod = "POST";  // "POST",  // "GET";  // 請求方法;
//     char *requestProtocol = "HTTP";
//     char *requestConnection = "keep-alive";  // "keep-alive", "close";
//     char *requestReferer = "http://username:password@localhost:10001/";  // "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // "http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1";
//     char *Authorization = "";  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
//     Authorization = "Basic username:password -> Basic dXNlcm5hbWU6cGFzc3dvcmQ=";  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
//     char *Cookie = "";  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
//     Cookie = "Session_ID=request_Key->username:password -> Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
//     char *requestFrom = "user@email.com";
//     float time_out = 0.0; // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;

//     char *webPath = "";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
//     char *key = ":";  // "username:password"; // 自定義的訪問網站簡單驗證用戶名和密碼;
//     float time_sleep = 0.0;
//     // sleep(time_sleep);

//     char *is_Monitor = "true";  // 判斷持續監聽目標文檔，亦或是執行一次，取："true" 或 "1" 表示持續監聽，取："false" 或 "0" 表示執行一次;
//     char *monitor_file = "C:/Criss/Intermediary/intermediary_write_Julia.txt";
//     char *monitor_dir = "C:/Criss/Intermediary";
//     char *output_dir = "C:/Criss/Intermediary";
//     char *output_file = "C:/Criss/Intermediary/intermediary_write_C.txt";
//     char *to_executable = "C:/Criss/Julia/Julia-1.9.3/bin/julia.exe";
//     char *to_script = "C:/Criss/CrissJulia/src/StatisticalAlgorithmServer.jl";
//     char *temp_cache_IO_data_dir = "C:/Criss/temp";


//     // 1.1、解析預設的配置文檔（C:/Criss/config.txt）的保存路徑參數：configFile;
    
//     // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
//     // printf("The full path to the executable is :\n%s\n", argv[0]);
//     // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);  // "C:/Criss/Interface.exe"
//     // const int Argument0Length = strlen(argv[0]);  // 獲取傳入的第一個參數：argv[0]，即：當前運行的二進制可執行檔完整路徑，的字符串的長度;
//     // printf("當前運行的二進制可執行檔完整路徑:\n%s\n長度爲：%d 個字符.\n", argv[0], Argument0Length);  // 24
//     // 備份控制臺傳入參數;
//     // char copyArgv0[Argument0Length + 1];
//     // strncpy(copyArgv0, argv[0], sizeof(copyArgv0) - 1);  // 字符串數組傳值，淺拷貝;
//     // copyArgv0[sizeof(copyArgv0) - 1] = '\0';
//     // 備份控制臺傳入參數;
//     char *copyArgv0 = strdup(argv[0]);  // 函數：strdup(argv[0]) 表示，指針傳值，深拷貝，需要 free(copyArgv0) 釋放内存;
//     // printf("%s\n", argv[0]);  // "C:/Criss/Interface.exe"
//     // printf("%s\n", copyArgv0);  // "C:/Criss/Interface.exe"
//     // const int lengthCopyArgv0 = strlen(copyArgv0);
//     // printf("%d\n", lengthCopyArgv0);  // 42

//     char *defaultConfigFileDirectory = "";  // "C:/Criss"
//     defaultConfigFileDirectory = dirname(copyArgv0);
//     // printf("預設配置文檔的保存位置爲：\n%s\n", defaultConfigFileDirectory);  // "C:/Criss"
//     const int lengthDefaultConfigFileDirectory = strlen(defaultConfigFileDirectory);
//     // printf("%d\n", lengthDefaultConfigFileDirectory);  // 20

//     char *configFileName = "config.txt";  // "C:/Criss/config.txt"
//     const int lengthConfigFileName = strlen(configFileName);
//     // printf("%d\n", lengthConfigFileName);  // 10

//     char defaultConfigFilePath[lengthDefaultConfigFileDirectory + 1 + lengthConfigFileName + 1];  // "C:/Criss/config.txt"
//     snprintf(defaultConfigFilePath, sizeof(defaultConfigFilePath), "%s%s%s", defaultConfigFileDirectory, "/", configFileName);
//     // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/Criss/config.txt"
//     const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
//     // printf("%d\n", lengthDefaultConfigFilePath);  // 31
//     defaultConfigFilePath[lengthDefaultConfigFilePath] = '\0';
//     // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", defaultConfigFilePath);  // "C:/Criss/config.txt"
//     // const int lengthDefaultConfigFilePath = strlen(defaultConfigFilePath);
//     // printf("%d\n", lengthDefaultConfigFilePath);  // 31

//     configFile = strdup(defaultConfigFilePath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//     // configFile = defaultConfigFilePath;
//     // printf("預設的配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/Criss/config.txt"
//     // const int lengthDefaultConfigFilePath = strlen(configFile);
//     // printf("%d\n", lengthDefaultConfigFilePath);  // 31

//     defaultConfigFileDirectory = NULL;
//     configFileName = NULL;


//     // 1.2、解析預設的服務端（socket server）運行空間目錄文檔（C:/Criss/html/）的保存路徑參數：webPath;
//     char *defaultWebPathDirectory = "";  // "C:/Criss"
//     defaultWebPathDirectory = dirname(copyArgv0);
//     // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPathDirectory);  // "C:/Criss"
//     const int lengthDefaultWebPathDirectory = strlen(defaultWebPathDirectory);
//     // printf("%d\n", lengthDefaultWebPath);  // 20

//     char *webPathName = "html";  // "C:/Criss/html"
//     const int lengthWebPathName = strlen(webPathName);
//     // printf("%d\n", lengthWebPathName);  // 4

//     char defaultWebPath[lengthDefaultWebPathDirectory + 1 + lengthWebPathName + 1];  // "C:/Criss/html"
//     snprintf(defaultWebPath, sizeof(defaultWebPath), "%s%s%s", defaultWebPathDirectory, "/", webPathName);
//     // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPath);  // "C:/Criss/html"
//     const int lengthDefaultWebPath = strlen(defaultWebPath);
//     // printf("%d\n", lengthDefaultWebPath);  // 25
//     defaultWebPath[lengthDefaultWebPath] = '\0';
//     // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", defaultWebPath);  // "C:/Criss/html"
//     // const int lengthDefaultWebPath = strlen(defaultWebPath);
//     // printf("%d\n", lengthDefaultWebPath);  // 25

//     webPath = strdup(defaultWebPath);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//     // webPath = defaultConfigFilePath;
//     // printf("預設服務器運行的本地硬盤根目錄爲：\n%s\n", webPath);  // "C:/Criss/html"
//     // const int lengthWebPath = strlen(webPath);
//     // printf("%d\n", lengthWebPath);  // 25

//     defaultWebPathDirectory = NULL;
//     webPathName = NULL;

//     free(copyArgv0);  // 釋放内存;


//     // 2、讀取控制臺傳入的配置文檔（C:/Criss/config.txt）的保存路徑參數：configFile;
//     // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
//     // printf("The full path to the executable is :\n%s\n", argv[0]);
//     // printf("Input %d arguments from the console.\n", argc);
//     // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);
//     // printf("控制臺共傳入 %d 個參數.\n", argc);
//     // 獲取控制臺傳入的配置文檔：configFile 的完整路徑;
//     const char *Delimiter = "=";
//     for(int i = 1; i < argc; i++) {
//         // printf("參數 %d: %s\n", i, argv[i]);

//         // 獲取傳入參數字符串的長度;
//         // const int ArgumentLength = strlen(argv[i]);
//         // const int ArgumentLength = 0;
//         // while (argv[i][ArgumentLength] != '\0') {
//         //     ArgumentLength = ArgumentLength + 1;
//         // }
//         // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, argv[i], ArgumentLength);

//         // 備份控制臺傳入參數;
//         // char copyArgvI[ArgumentLength + 1];
//         // strncpy(copyArgvI, argv[i], sizeof(copyArgvI));  // 字符串數組傳值，淺拷貝;
//         // copyArgvI[sizeof(copyArgvI)] = '\0';

//         // 備份控制臺傳入參數;
//         char *copyArgvI = strdup(argv[i]);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//         // printf("%s\n", argv[i]);
//         // printf("%s\n", copyArgvI);
//         const int ArgumentLength = strlen(copyArgvI);
//         // printf("%d\n", ArgumentLength);

//         // // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
//         // // 使用函數：strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0 判斷兩個字符串是否相等;
//         // if ((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0)) {
//         //     printf(NoteVersion);
//         // }
//         // // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
//         // if ((strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0)) {
//         //     printf(NoteHelp);
//         // }

//         // 若控制臺命令列傳入參數非："--version" 或 "-v" 或 "--help" 或 "-h" 或 "?" 時，則執行如下解析字符串參數;
//         if (!((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0))) {

//             char *ArgumentKey = "";
//             char *ArgumentValue = "";
//             char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
//             // const char *Delimiter = "=";
//             char *DelimiterIndex = "";

//             // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
//             // DelimiterIndex = strstr(argv[i], Delimiter);
//             DelimiterIndex = strstr(copyArgvI, Delimiter);
//             // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
//             // printf(Delimiter);
//             // printf(argv[i]);
//             // printf(DelimiterIndex);
//             if (DelimiterIndex != NULL) {
//                 // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

//                 // 使用 strtok_r() 函數分割字符串;
//                 // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
//                 // while(ArgumentKey != NULL) {
//                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                 //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
//                 //     ArgumentKey = strtok_r(NULL, Delimiter);
//                 // }
//                 // printf("控制臺傳入參數 %d: 字符串：'%s' 的名稱爲：'%s'\n", i, argv[i], ArgumentKey);
//                 const int ArgumentKeyLength = strlen(ArgumentKey);
//                 // printf("%d\n", ArgumentKeyLength);
//                 ArgumentValue = saveArgumentValue;
//                 // printf("控制臺傳入參數 %d: 字符串：'%s' 的值爲：'%s'\n", i, argv[i], ArgumentValue);
//                 const int ArgumentValueLength = strlen(ArgumentValue);
//                 // printf("%d\n", ArgumentValueLength);

//                 // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
//                 // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
//                 // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
//                 // printf("參數 %d: %s\n", i, buffer);

//                 // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 if (ArgumentKey != NULL) {

//                     // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
//                     if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

//                         // const int ArgumentValueLength = strlen(ArgumentValue);
//                         // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                         // for(int g = 0; g < ArgumentValueLength; g++) {
//                         //     configFile[g] = ArgumentValue[g];
//                         // }
//                         // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                         // char configFile[ArgumentValueLength + 1];
//                         // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                         // configFile[sizeof(configFile) - 1] = '\0';

//                         configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//                         // printf("%s\n", configFile);
//                     }

//                     // if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
//                     //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                     //     isBlock = strdup(ArgumentValue);
//                     //     // printf("%s\n", isBlock);
//                     // }

//                 } else {

//                     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//                     configFile = strdup(ArgumentValue);

//                     // const int ArgumentValueLength = strlen(ArgumentValue);
//                     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                     // for(int g = 0; g < ArgumentValueLength; g++) {
//                     //     configFile[g] = ArgumentValue[g];
//                     // }
//                     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                     // char configFile[ArgumentValueLength + 1];
//                     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                     // configFile[sizeof(configFile) - 1] = '\0';

//                 }

//             } else {

//                 // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//                 configFile = strdup(ArgumentValue);

//                 // const int ArgumentValueLength = strlen(ArgumentValue);
//                 // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                 // for(int g = 0; g < ArgumentValueLength; g++) {
//                 //     configFile[g] = ArgumentValue[g];
//                 // }
//                 // configFile[ArgumentValueLength] = '\0'; // 字符串末尾添加結束標記;

//                 // char configFile[ArgumentValueLength + 1];
//                 // strncpy(configFile, ArgumentValue, sizeof(configFile));  // 字符串數組傳值，淺拷貝;
//                 // configFile[sizeof(configFile)] = '\0';

//             }
//         }

//         free(copyArgvI);
//     }
//     // printf("控制臺傳入的配置文檔（config.txt）完整路徑爲：\n%s\n", configFile);


//     // 3、讀取配置文檔（C:/Criss/config.txt）中記錄的參數：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
//     // printf("配置文檔（config.txt）的保存路徑爲：\n%s\n", configFile);  // "C:/Criss/config.txt";
//     // 讀取配置文檔：configFile 中的參數;
//     if (strlen(configFile) > 0) {

//         FILE *file = fopen(configFile, "rt");  // rt、rb、wt、wb、a、r+、w+、a+;

//         if (file == NULL) {

//             // printf("無法打開配置文檔：\nconfigFile = %s\n", configFile);
//             // // return 1;
//         }

//         if (file != NULL) {
//             // printf("正在使用配置文檔：\nconfigFile = %s\n", configFile);  // "C:/Criss/config.txt";
//             printf("configFile = %s\n", configFile);  // "C:/Criss/config.txt";

//             // // 使用：fread(buffer, size, 1, file) 函數，一次讀入文檔中的全部内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
//             // fseek(file, 0, SEEK_END);  // 定位文檔指針到文檔末尾;
//             // long size = ftell(file);  // 計算文檔所包含的字符個數長度;
//             // fseek(file, 0, SEEK_SET);  // 將文檔指針重新移動到文檔的開頭;
//             // char *buffer = (char *)malloc(size + 1);  // 動態内存分配，按照上一部識別的文檔大小，申請内存緩衝區存儲文檔内容;
//             // fread(buffer, size, 1, file);  // 讀入文檔中的全部内容到内存緩衝區（buffer）;
//             // buffer[size] = '\0';  // 在内存緩衝區（buffer）儲存的文檔内容的末尾添加字符串結束字符（'\0'）;
//             // printf("%s\n", buffer);
//             // fclose(file);  // 關閉文檔;
//             // free(buffer);  // 釋放内存緩衝區（buffer）;

//             // // 使用：Character = fgetc(file) 函數，逐字符讀入文檔中的内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
//             // int Character;
//             // int flag;
//             // flag = 1;
//             // while (flag) {
//             //     // 逐字符讀入文檔中的内容;
//             //     Character = fgetc(file);  // 從文檔中讀取一個字符;
//             //     // EOF == -1，判斷指針是否已經後移到文檔末尾;
//             //     if (c == EOF) {
//             //         flag = 0;
//             //         break;  // 跳出 while(){} 循環;
//             //     }
//             //     printf("%c", Character);
//             // }
//             // fclose(file);  // 關閉文檔;

//             // 使用：fgets(buffer, sizeof(buffer), file) 函數，逐個橫向列（row）讀入文檔中的内容，包含每個橫向列（row）末尾的換行符回車符號（Enter）：'\n';
//             char buffer[BUFFER_LEN];  // BUFFER_LEN = 1024 // 代碼首部自定義的常量：BUFFER_LEN = 1024，靜態申請内存緩衝區（buffer），存儲文檔每一個橫向列（row）中的内容，要求配置文檔：config.txt 中每一個橫向列（row）最多不得超過 1024 個字符;
//             while (fgets(buffer, sizeof(buffer), file) != NULL) {
//                 // printf("%s\n", buffer);

//                 // 獲取傳入參數字符串的長度;
//                 // const int ArgumentLength = strlen(buffer);
//                 // const int ArgumentLength = 0;
//                 // while (buffer[ArgumentLength] != '\0') {
//                 //     ArgumentLength = ArgumentLength + 1;
//                 // }
//                 // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, buffer, ArgumentLength);

//                 // 備份控制臺傳入參數;
//                 // char copyArgvI[ArgumentLength + 1];
//                 // strncpy(copyArgvI, buffer, sizeof(copyArgvI) - 1);  // 字符串數組傳值，淺拷貝;
//                 // copyArgvI[sizeof(copyArgvI) - 1] = '\0';

//                 // 備份控制臺傳入參數;
//                 char *copyArgvI = buffer;
//                 // copyArgvI = strdup(buffer);  // 函數：strdup(buffer) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//                 // printf("%s\n", buffer);
//                 // printf("%s\n", copyArgvI);
//                 const int ArgumentLength = strlen(copyArgvI);
//                 // printf("%d\n", ArgumentLength);
//                 // if (ArgumentLength > 0 && *copyArgvI != '\n') {
//                 if (ArgumentLength > 0) {

//                     // // 使用：for(){} 循環，遍歷字符串，查找注釋符號井號字符（'#'），並將之替換爲字符串結束標志符號（'\0'），即從注釋符號井號（#）處截斷字符串;
//                     // printf("%s\n", copyArgvI);
//                     // const int ArgumentLength = strlen(copyArgvI);
//                     // printf("%d\n", strlen(copyArgvI));
//                     // for (int i = 0; i < ArgumentLength; i++) {
//                     //     printf("%c\n", *copyArgvI);
//                     //     // 判斷當前指向的字符，是否爲注釋符號井號字符（'#'），若是井號字符（'#'），則將之替換爲字符串結束標志符號（'\0'），若非井號字符（'#'）則保持不變;
//                     //     if (*copyArgvI == '#') {
//                     //         *copyArgvI = '\0';
//                     //     }
//                     //     copyArgvI++;  // 每輪循環後，自動向後偏移一位指向;
//                     // }
//                     // // 將字符串指針，重新指向字符串的首地址;
//                     // copyArgvI = copyArgvI - ArgumentLength;
//                     // printf("%s\n", copyArgvI);
//                     // const int ArgumentLength = strlen(copyArgvI);
//                     // printf("%d\n", strlen(copyArgvI));

//                     // 刪除配置文檔（C:/Criss/config.txt）中，每個橫向列（row）字符串末尾可能存在的換行符回車符號（Enter）：'\n'，代之以字符串結束標志符號：'\0'，字符串長度會縮短 1 位;
//                     // printf("%c ~ %c ~ %c\n", *copyArgvI, *(copyArgvI + ArgumentLength - 2), *(copyArgvI + ArgumentLength));  // *copyArgvI 爲字符串的首字符，*(copyArgvI + ArgumentLength - 2) 爲字符串的尾字符，*(copyArgvI + ArgumentLength - 1) 爲字符串末端的換行符回車符號（Enter）== '\n'，*(copyArgvI + ArgumentLength) 爲字符串末端的結束標志符號 == '\0' ;
//                     // printf("%c\n", (copyArgvI + ArgumentLength - 1));
//                     if (*(copyArgvI + ArgumentLength - 1) == '\n') {
//                         *(copyArgvI + ArgumentLength - 1) = '\0';
//                     } else {
//                         *(copyArgvI + ArgumentLength) = '\0';
//                     }
//                     // printf("%s\n", copyArgvI);
//                     const int ArgumentLength = strlen(copyArgvI);
//                     // printf("%d\n", ArgumentLength);

//                     // // 使用：strstr() 函數檢查字符串：haystack 中是否包含字符串：needle，若包含返回第一次出現的地址，若不好含則返回 NULL 值;
//                     // const char *haystack = "Hello World";
//                     // const char *needle = "World";
//                     // char *result = strstr(haystack, needle);
//                     // if (result != NULL) {
//                     //     printf("字符串：'%s' 中包含子字符串：'%s' , 位置在：'%s'\n", haystack, needle, result);
//                     // } else {
//                     //     printf("字符串：'%s' 中不包含子字符串：'%s'\n", haystack, needle);
//                     // }

//                     // 提取配置文檔（C:/Criss/config.txt）中，每個橫向列（row）字符串中，指定的參數值：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
//                     if (ArgumentLength > 0) {
//                         // printf("%s\n", copyArgvI);

//                         // 判斷當前橫向列（row）字符串的參數，是否被井號（#）注釋掉;
//                         if (*copyArgvI != '#') {
//                             // printf("%s\n", copyArgvI);

//                             // // 使用：for(){} 循環，遍歷字符串，查找注釋符號井號字符（'#'），並將之替換爲字符串結束標志符號（'\0'），即從注釋符號井號（#）處截斷字符串;
//                             // printf("%s\n", copyArgvI);
//                             // const int ArgumentLength = strlen(copyArgvI);
//                             // printf("%d\n", strlen(copyArgvI));
//                             // for (int i = 0; i < ArgumentLength; i++) {
//                             //     printf("%c\n", *copyArgvI);
//                             //     // 判斷當前指向的字符，是否爲注釋符號井號字符（'#'），若是井號字符（'#'），則將之替換爲字符串結束標志符號（'\0'），若非井號字符（'#'）則保持不變;
//                             //     if (*copyArgvI == '#') {
//                             //         *copyArgvI = '\0';
//                             //     }
//                             //     copyArgvI++;  // 每輪循環後，自動向後偏移一位指向;
//                             // }
//                             // // 將字符串指針，重新指向字符串的首地址;
//                             // copyArgvI = copyArgvI - ArgumentLength;
//                             // printf("%s\n", copyArgvI);
//                             // const int ArgumentLength = strlen(copyArgvI);
//                             // printf("%d\n", strlen(copyArgvI));

//                             char *ArgumentKey = "";
//                             char *ArgumentValue = "";
//                             char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
//                             // const char *Delimiter = "=";
//                             char *DelimiterIndex = "";

//                             // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
//                             // DelimiterIndex = strstr(argv[i], Delimiter);
//                             DelimiterIndex = strstr(copyArgvI, Delimiter);
//                             // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
//                             // printf(Delimiter);
//                             // printf(argv[i]);
//                             // printf(DelimiterIndex);
//                             if (DelimiterIndex != NULL) {
//                                 // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

//                                 // 使用 strtok_r() 函數分割字符串;
//                                 // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                                 ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                                 // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
//                                 // while(ArgumentKey != NULL) {
//                                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                                 //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
//                                 //     ArgumentKey = strtok_r(NULL, Delimiter);
//                                 // }
//                                 // printf("控制臺傳入參數字符串的名稱爲：%s\n", ArgumentKey);
//                                 const int ArgumentKeyLength = strlen(ArgumentKey);
//                                 // printf("%d\n", ArgumentKeyLength);
//                                 ArgumentValue = saveArgumentValue;
//                                 // printf("控制臺傳入參數字符串的值爲：%s\n", ArgumentValue);
//                                 const int ArgumentValueLength = strlen(ArgumentValue);
//                                 // printf("%d\n", ArgumentValueLength);

//                                 // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
//                                 // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
//                                 // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
//                                 // printf("參數 %d: %s\n", i, buffer);

//                                 // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                                 if (ArgumentKey != NULL) {

//                                     // // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
//                                     // if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
//                                     //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

//                                     //     // const int ArgumentValueLength = strlen(ArgumentValue);
//                                     //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                                     //     // for(int g = 0; g < ArgumentValueLength; g++) {
//                                     //     //     configFile[g] = ArgumentValue[g];
//                                     //     // }
//                                     //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                                     //     // char configFile[ArgumentValueLength + 1];
//                                     //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                                     //     // configFile[sizeof(configFile) - 1] = '\0';

//                                     //     configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//                                     //     // printf("%s\n", configFile);
//                                     // }

//                                     if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         isBlock = strdup(ArgumentValue);
//                                         // printf("%s\n", isBlock);
//                                     }

//                                     if (strncmp(ArgumentKey, "is_monitor", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         is_Monitor = strdup(ArgumentValue);
//                                         // printf("%s\n", is_Monitor);
//                                     }

//                                     if (strncmp(ArgumentKey, "monitor_dir", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         monitor_dir = strdup(ArgumentValue);
//                                         // printf("%s\n", monitor_dir);
//                                     }

//                                     if (strncmp(ArgumentKey, "monitor_file", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         monitor_file = strdup(ArgumentValue);
//                                         // printf("%s\n", monitor_file);
//                                     }

//                                     if (strncmp(ArgumentKey, "output_dir", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         output_dir = strdup(ArgumentValue);
//                                         // printf("%s\n", output_dir);
//                                     }

//                                     if (strncmp(ArgumentKey, "output_file", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         output_file = strdup(ArgumentValue);
//                                         // printf("%s\n", output_file);
//                                     }

//                                     if (strncmp(ArgumentKey, "temp_cache_IO_data_dir", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         temp_cache_IO_data_dir = strdup(ArgumentValue);
//                                         // printf("%s\n", temp_cache_IO_data_dir);
//                                     }

//                                     if (strncmp(ArgumentKey, "interface_Function", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         interface_Function_name_str = strdup(ArgumentValue);
//                                         // printf("%s\n", interface_Function_name_str);
//                                     }

//                                     if (strncmp(ArgumentKey, "serverHOST", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         serverIPaddress = strdup(ArgumentValue);
//                                         // printf("%s\n", serverIPaddress);
//                                     }

//                                     if (strncmp(ArgumentKey, "serverPORT", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         serverPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                                         // serverPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                                         // if (errno == ERANGE && (serverPORT == LONG_MAX || serverPORT == LONG_MIN)) {
//                                         //     printf("數字轉換過程中發生溢出.\n");
//                                         // } else if (endptr == ArgumentValue) {
//                                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                                         // } else {
//                                         //     printf("轉換結果: %ld\n", serverPORT);
//                                         // }
//                                         // printf("%d\n", serverPORT);
//                                     }

//                                     if (strncmp(ArgumentKey, "clientHOST", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         clientIPaddress = strdup(ArgumentValue);
//                                         // printf("%s\n", clientIPaddress);
//                                     }

//                                     if (strncmp(ArgumentKey, "clientPORT", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         clientPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                                         // clientPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                                         // if (errno == ERANGE && (clientPORT == LONG_MAX || clientPORT == LONG_MIN)) {
//                                         //     printf("數字轉換過程中發生溢出.\n");
//                                         // } else if (endptr == ArgumentValue) {
//                                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                                         // } else {
//                                         //     printf("轉換結果: %ld\n", clientPORT);
//                                         // }
//                                         // printf("%d\n", clientPORT);
//                                     }

//                                     if (strncmp(ArgumentKey, "IPversion", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         IPversion = strdup(ArgumentValue);  // "IPv6", "IPv4";
//                                         // printf("%s\n", IPversion);
//                                     }

//                                     if (strncmp(ArgumentKey, "webPath", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         webPath = strdup(ArgumentValue);
//                                         // printf("%s\n", webPath);
//                                     }

//                                     if (strncmp(ArgumentKey, "key", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         key = strdup(ArgumentValue);
//                                         // printf("%s\n", key);
//                                     }

//                                     if (strncmp(ArgumentKey, "time_sleep", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         time_sleep = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
//                                         // time_sleep = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                                         // time_sleep = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                                         // if (errno == ERANGE && (time_sleep == LONG_MAX || time_sleep == LONG_MIN)) {
//                                         //     printf("數字轉換過程中發生溢出.\n");
//                                         // } else if (endptr == ArgumentValue) {
//                                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                                         // } else {
//                                         //     printf("轉換結果: %ld\n", time_sleep);
//                                         // }
//                                         // printf("%d\n", time_sleep);
//                                     }

//                                     if (strncmp(ArgumentKey, "time_out", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         time_out = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
//                                         // time_out = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                                         // time_out = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                                         // if (errno == ERANGE && (time_out == LONG_MAX || time_out == LONG_MIN)) {
//                                         //     printf("數字轉換過程中發生溢出.\n");
//                                         // } else if (endptr == ArgumentValue) {
//                                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                                         // } else {
//                                         //     printf("轉換結果: %ld\n", time_out);
//                                         // }
//                                         // printf("%d\n", time_out);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestURL", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestURL = strdup(ArgumentValue);
//                                         // printf("%s\n", requestURL);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestPath", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestPath = strdup(ArgumentValue);
//                                         // printf("%s\n", requestPath);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestConnection", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestConnection = strdup(ArgumentValue);
//                                         // printf("%s\n", requestConnection);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestFrom", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestFrom = strdup(ArgumentValue);
//                                         // printf("%s\n", requestFrom);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestReferer", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestReferer = strdup(ArgumentValue);
//                                         // printf("%s\n", requestReferer);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestMethod", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         requestMethod = strdup(ArgumentValue);
//                                         // printf("%s\n", requestMethod);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestAuthorization", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         Authorization = strdup(ArgumentValue);
//                                         // printf("%s\n", Authorization);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestCookie", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         Cookie = strdup(ArgumentValue);
//                                         // printf("%s\n", Cookie);
//                                     }

//                                     if (strncmp(ArgumentKey, "session", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         sessionString = strdup(ArgumentValue);
//                                         // printf("%s\n", sessionString);
//                                     }

//                                     if (strncmp(ArgumentKey, "requestData", sizeof(ArgumentKey)) == 0) {
//                                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                                         postData = strdup(ArgumentValue);
//                                         // printf("%s\n", postData);
//                                     }

//                                 // } else {

//                                 //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//                                 //     configFile = strdup(ArgumentValue);

//                                 //     // const int ArgumentValueLength = strlen(ArgumentValue);
//                                 //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                                 //     // for(int g = 0; g < ArgumentValueLength; g++) {
//                                 //     //     configFile[g] = ArgumentValue[g];
//                                 //     // }
//                                 //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                                 //     // char configFile[ArgumentValueLength + 1];
//                                 //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                                 //     // configFile[sizeof(configFile) - 1] = '\0';

//                                 }

//                             // } else {

//                             //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//                             //     configFile = strdup(ArgumentValue);

//                             //     // const int ArgumentValueLength = strlen(ArgumentValue);
//                             //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                             //     // for(int g = 0; g < ArgumentValueLength; g++) {
//                             //     //     configFile[g] = ArgumentValue[g];
//                             //     // }
//                             //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                             //     // char configFile[ArgumentValueLength + 1];
//                             //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                             //     // configFile[sizeof(configFile) - 1] = '\0';

//                             }
//                         }
//                     }
//                 }
//                 copyArgvI = NULL;  // 清空指針;
//                 memset(buffer, 0, sizeof(buffer));  // 釋放内存緩衝區（buffer）;
//             }

//             fclose(file);  // 關閉文檔;
//         }

//     } else {

//         // printf("配置文檔的保存路徑參數爲空：\nconfigFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/Criss/config.txt"
//         // // printf("configFile = %s\n", configFile);  // 配置文檔的保存路徑參數："C:/Criss/config.txt"
//         // // return 1;
//     }


//     // 4、讀取控制臺傳入的其他參數：executableFile, interpreterFile, scriptFile, configInstructions, isBlock;
//     // 其中：argv[0] 的返回值爲二進制可執行檔完整路徑名稱「/main.exe」;
//     // printf("The full path to the executable is :\n%s\n", argv[0]);
//     // printf("Input %d arguments from the console.\n", argc);
//     // printf("當前運行的二進制可執行檔完整路徑爲：\n%s\n", argv[0]);
//     // printf("控制臺共傳入 %d 個參數.\n", argc);
//     // 獲取控制臺傳入的配置文檔：configFile 的完整路徑;
//     // const char *Delimiter = "=";
//     for(int i = 1; i < argc; i++) {
//         // printf("參數 %d: %s\n", i, argv[i]);

//         // 獲取傳入參數字符串的長度;
//         // const int ArgumentLength = strlen(argv[i]);
//         // const int ArgumentLength = 0;
//         // while (argv[i][ArgumentLength] != '\0') {
//         //     ArgumentLength = ArgumentLength + 1;
//         // }
//         // printf("控制臺傳入參數 %s: %s 的長度爲：%d 個字符.\n", i, argv[i], ArgumentLength);

//         // 備份控制臺傳入參數;
//         // char copyArgvI[ArgumentLength + 1];
//         // strncpy(copyArgvI, argv[i], sizeof(copyArgvI) - 1);  // 字符串數組傳值，淺拷貝;
//         // copyArgvI[sizeof(copyArgvI) - 1] = '\0';

//         // 備份控制臺傳入參數;
//         char *copyArgvI = strdup(argv[i]);  // 函數：strdup(argv[i]) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//         // printf("%s\n", argv[i]);
//         // printf("%s\n", copyArgvI);
//         const int ArgumentLength = strlen(copyArgvI);
//         // printf("%d\n", ArgumentLength);

//         // // 若控制臺命令列傳入參數爲："--version" 或 "-v" 時，則在控制臺命令列輸出版本信息;
//         // // 使用函數：strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0 判斷兩個字符串是否相等;
//         // if ((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0)) {
//         //     printf(NoteVersion);
//         // }
//         // // 若控制臺命令列傳入參數爲："--help" 或 "-h" 或 "?" 時，則在控制臺命令列輸出版本信息;
//         // if ((strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0)) {
//         //     printf(NoteHelp);
//         // }

//         // 若控制臺命令列傳入參數非："--version" 或 "-v" 或 "--help" 或 "-h" 或 "?" 時，則執行如下解析字符串參數;
//         if (!((strncmp(copyArgvI, "--version", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-v", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "--help", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "-h", sizeof(copyArgvI)) == 0) || (strncmp(copyArgvI, "?", sizeof(copyArgvI)) == 0))) {

//             char *ArgumentKey = "";
//             char *ArgumentValue = "";
//             char *saveArgumentValue = "";  // 保存函數：ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue) 分割等號字符（=）之後的第 2 個子字符串，即：ArgumentValue，分割等號字符（=）之後的第 1 個子字符串爲：ArgumentKey;
//             // const char *Delimiter = "=";
//             char *DelimiterIndex = "";

//             // 使用：strstr() 函數檢查從控制臺傳入的參數（arguments）數組：argv 的元素中是否包含 "=" 字符，若包含 "=" 字符，返回第一次出現的位置，若不含 "=" 字符，則返回 NULL 值;
//             // DelimiterIndex = strstr(argv[i], Delimiter);
//             DelimiterIndex = strstr(copyArgvI, Delimiter);
//             // printf("參數 %d: %s 中含有的第一個等號字符(%s)的位置在: %s\n", i, copyArgvI, Delimiter, DelimiterIndex);
//             // printf(Delimiter);
//             // printf(argv[i]);
//             // printf(DelimiterIndex);
//             if (DelimiterIndex != NULL) {
//                 // printf("控制臺傳入參數字符串：'%s' 中包含子字符串（分隔符）：'%s' , 位置在：'%s'\n", argv[i], Delimiter, DelimiterIndex);

//                 // 使用 strtok_r() 函數分割字符串;
//                 // ArgumentKey = strtok_r(argv[i], Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 ArgumentKey = strtok_r(copyArgvI, Delimiter, &saveArgumentValue);  // 獲取使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 // // 持續向後使用字符 "=" 分割字符串，並持續提取分割後的第一個子字符串;
//                 // while(ArgumentKey != NULL) {
//                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                 //     printf("Input argument: '%s' name: '%s'\n", argv[i], ArgumentKey);
//                 //     // 繼續獲取後續被字符 "=" 分割的第一個子字符串，之後對 strtok_r() 函數的循環調用，第一個參數應使用：NULL 值，表示函數應繼續在之前找到的位置繼續向後查找;
//                 //     ArgumentKey = strtok_r(NULL, Delimiter);
//                 // }
//                 // printf("控制臺傳入參數 %d: 字符串：'%s' 的名稱爲：'%s'\n", i, argv[i], ArgumentKey);
//                 const int ArgumentKeyLength = strlen(ArgumentKey);
//                 // printf("%d\n", ArgumentKeyLength);
//                 ArgumentValue = saveArgumentValue;
//                 // printf("控制臺傳入參數 %d: 字符串：'%s' 的值爲：'%s'\n", i, argv[i], ArgumentValue);
//                 const int ArgumentValueLength = strlen(ArgumentValue);
//                 // printf("%d\n", ArgumentValueLength);

//                 // // 函數：snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue) 表示拼接字符串：ArgumentKey, "=", saveArgumentValue 保存至字符串數組（char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1]）：buffer 字符串數組；注意，需要變量：buffer 事先聲明有足夠的長度儲存拼接之後的新字符串，長度需要大於三個字符串長度之和：strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1，用以保存最後一位字符串結束標志：'\0'，否則會内存溢出;
//                 // char buffer[strlen(ArgumentKey) + strlen("=") + strlen(saveArgumentValue) + 1];
//                 // snprintf(buffer, sizeof(buffer), "%s%s%s", ArgumentKey, "=", saveArgumentValue);
//                 // printf("參數 %d: %s\n", i, buffer);

//                 // 判斷是否已經獲取成功使用字符 "=" 分割後的第一個子字符串，參數名稱;
//                 if (ArgumentKey != NULL) {

//                     // // 使用函數：strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0 判斷兩個字符串是否相等;
//                     // if (strncmp(ArgumentKey, "configFile", sizeof(ArgumentKey)) == 0) {
//                     //     // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);

//                     //     // const int ArgumentValueLength = strlen(ArgumentValue);
//                     //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                     //     // for(int g = 0; g < ArgumentValueLength; g++) {
//                     //     //     configFile[g] = ArgumentValue[g];
//                     //     // }
//                     //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                     //     // char configFile[ArgumentValueLength + 1];
//                     //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                     //     // configFile[sizeof(configFile) - 1] = '\0';

//                     //     configFile = strdup(ArgumentValue);  // 函數：strdup(ArgumentValue) 表示，指針傳值，深拷貝，需要 free(copyArgvI) 釋放内存;
//                     //     // printf("%s\n", configFile);
//                     // }

//                     if (strncmp(ArgumentKey, "isBlock", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         isBlock = strdup(ArgumentValue);
//                         // printf("%s\n", isBlock);
//                     }

//                     if (strncmp(ArgumentKey, "is_monitor", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         is_Monitor = strdup(ArgumentValue);
//                         // printf("%s\n", is_Monitor);
//                     }

//                     if (strncmp(ArgumentKey, "monitor_dir", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         monitor_dir = strdup(ArgumentValue);
//                         // printf("%s\n", monitor_dir);
//                     }

//                     if (strncmp(ArgumentKey, "monitor_file", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         monitor_file = strdup(ArgumentValue);
//                         // printf("%s\n", monitor_file);
//                     }

//                     if (strncmp(ArgumentKey, "output_dir", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         output_dir = strdup(ArgumentValue);
//                         // printf("%s\n", output_dir);
//                     }

//                     if (strncmp(ArgumentKey, "output_file", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         output_file = strdup(ArgumentValue);
//                         // printf("%s\n", output_file);
//                     }

//                     if (strncmp(ArgumentKey, "temp_cache_IO_data_dir", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         temp_cache_IO_data_dir = strdup(ArgumentValue);
//                         // printf("%s\n", temp_cache_IO_data_dir);
//                     }

//                     if (strncmp(ArgumentKey, "interface_Function", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         interface_Function_name_str = strdup(ArgumentValue);
//                         // printf("%s\n", interface_Function_name_str);
//                     }

//                     if (strncmp(ArgumentKey, "serverHOST", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         serverIPaddress = strdup(ArgumentValue);
//                         // printf("%s\n", serverIPaddress);
//                     }

//                     if (strncmp(ArgumentKey, "serverPORT", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         serverPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                         // serverPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                         // if (errno == ERANGE && (serverPORT == LONG_MAX || serverPORT == LONG_MIN)) {
//                         //     printf("數字轉換過程中發生溢出.\n");
//                         // } else if (endptr == ArgumentValue) {
//                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                         // } else {
//                         //     printf("轉換結果: %ld\n", serverPORT);
//                         // }
//                         // printf("%d\n", serverPORT);
//                     }

//                     if (strncmp(ArgumentKey, "clientHOST", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         clientIPaddress = strdup(ArgumentValue);
//                         // printf("%s\n", clientIPaddress);
//                     }

//                     if (strncmp(ArgumentKey, "clientPORT", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         clientPORT = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                         // clientPORT = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                         // if (errno == ERANGE && (clientPORT == LONG_MAX || clientPORT == LONG_MIN)) {
//                         //     printf("數字轉換過程中發生溢出.\n");
//                         // } else if (endptr == ArgumentValue) {
//                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                         // } else {
//                         //     printf("轉換結果: %ld\n", clientPORT);
//                         // }
//                         // printf("%d\n", clientPORT);
//                     }

//                     if (strncmp(ArgumentKey, "IPversion", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         IPversion = strdup(ArgumentValue);  // "IPv6", "IPv4";
//                         // printf("%s\n", IPversion);
//                     }

//                     if (strncmp(ArgumentKey, "webPath", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         webPath = strdup(ArgumentValue);
//                         // printf("%s\n", webPath);
//                     }

//                     if (strncmp(ArgumentKey, "key", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         key = strdup(ArgumentValue);
//                         // printf("%s\n", key);
//                     }

//                     if (strncmp(ArgumentKey, "time_sleep", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         time_sleep = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
//                         // time_sleep = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                         // time_sleep = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                         // if (errno == ERANGE && (time_sleep == LONG_MAX || time_sleep == LONG_MIN)) {
//                         //     printf("數字轉換過程中發生溢出.\n");
//                         // } else if (endptr == ArgumentValue) {
//                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                         // } else {
//                         //     printf("轉換結果: %ld\n", time_sleep);
//                         // }
//                         // printf("%d\n", time_sleep);
//                     }

//                     if (strncmp(ArgumentKey, "time_out", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         time_out = atof(ArgumentValue);  // 函數 atof() 表示將字符串數字轉換爲浮點型數字;
//                         // time_out = atoi(ArgumentValue);  // 函數 atoi() 表示將字符串數字轉換爲整型數字;
//                         // char *endptr;  // 函數 strtol() 的第二個參數：endptr 是一個指向字符指針的指針，它會被更新為指向字符串中第一個無法轉換的字符的位置;
//                         // errno = 0;  // 重置 errno 以確保正確檢查錯誤;
//                         // time_out = strtol(ArgumentValue, &endptr, 10);  // 參數 10 表示按照十進制轉換;
//                         // if (errno == ERANGE && (time_out == LONG_MAX || time_out == LONG_MIN)) {
//                         //     printf("數字轉換過程中發生溢出.\n");
//                         // } else if (endptr == ArgumentValue) {
//                         //     printf("轉換失敗，因為沒有有效的數字.\n");
//                         // } else {
//                         //     printf("轉換結果: %ld\n", time_out);
//                         // }
//                         // printf("%d\n", time_out);
//                     }

//                     if (strncmp(ArgumentKey, "requestURL", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestURL = strdup(ArgumentValue);
//                         // printf("%s\n", requestURL);
//                     }

//                     if (strncmp(ArgumentKey, "requestPath", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestPath = strdup(ArgumentValue);
//                         // printf("%s\n", requestPath);
//                     }

//                     if (strncmp(ArgumentKey, "requestConnection", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestConnection = strdup(ArgumentValue);
//                         // printf("%s\n", requestConnection);
//                     }

//                     if (strncmp(ArgumentKey, "requestFrom", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestFrom = strdup(ArgumentValue);
//                         // printf("%s\n", requestFrom);
//                     }

//                     if (strncmp(ArgumentKey, "requestReferer", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestReferer = strdup(ArgumentValue);
//                         // printf("%s\n", requestReferer);
//                     }

//                     if (strncmp(ArgumentKey, "requestMethod", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         requestMethod = strdup(ArgumentValue);
//                         // printf("%s\n", requestMethod);
//                     }

//                     if (strncmp(ArgumentKey, "requestAuthorization", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         Authorization = strdup(ArgumentValue);
//                         // printf("%s\n", Authorization);
//                     }

//                     if (strncmp(ArgumentKey, "requestCookie", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         Cookie = strdup(ArgumentValue);
//                         // printf("%s\n", Cookie);
//                     }

//                     if (strncmp(ArgumentKey, "session", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         sessionString = strdup(ArgumentValue);
//                         // printf("%s\n", sessionString);
//                     }

//                     if (strncmp(ArgumentKey, "requestData", sizeof(ArgumentKey)) == 0) {
//                         // printf("控制臺傳入參數：'%s' '%s' '%s'\n", ArgumentKey, Delimiter, ArgumentValue);
//                         postData = strdup(ArgumentValue);
//                         // printf("%s\n", postData);
//                     }

//                 // } else {

//                 //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//                 //     configFile = strdup(ArgumentValue);

//                 //     // const int ArgumentValueLength = strlen(ArgumentValue);
//                 //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//                 //     // for(int g = 0; g < ArgumentValueLength; g++) {
//                 //     //     configFile[g] = ArgumentValue[g];
//                 //     // }
//                 //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//                 //     // char configFile[ArgumentValueLength + 1];
//                 //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//                 //     // configFile[sizeof(configFile) - 1] = '\0';

//                 }

//             // } else {

//             //     // printf("控制臺傳入參數字符串：'%s' 中不包含子字符串（分隔符）：'%s'\n", argv[i], Delimiter);
//             //     configFile = strdup(ArgumentValue);

//             //     // const int ArgumentValueLength = strlen(ArgumentValue);
//             //     // // printf("控制臺傳入參數值(value)的長度爲：%d 個字符.\n", ArgumentValueLength);

//             //     // for(int g = 0; g < ArgumentValueLength; g++) {
//             //     //     configFile[g] = ArgumentValue[g];
//             //     // }
//             //     // configFile[ArgumentValueLength + 1] = '\0'; // 字符串末尾添加結束標記;

//             //     // char configFile[ArgumentValueLength + 1];
//             //     // strncpy(configFile, ArgumentValue, sizeof(configFile) - 1);  // 字符串數組傳值，淺拷貝;
//             //     // configFile[sizeof(configFile) - 1] = '\0';

//             }
//         }

//         free(copyArgvI);
//     }


//     // 5、啓動 socket server 或 socket client 或 file monitor 程式;
//     if (strncmp(interface_Function_name_str, "tcp_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "TCP_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_TCP_Server", sizeof(interface_Function_name_str)) == 0) {
//         socket_Server (
//             serverIPaddress,  // Sockets.IPv6(0) or Sockets.IPv6("::1") or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
//             serverPORT,  // 0 ~ 65535，監聽埠號（端口）;
//             IPversion,  // "IPv6"、"IPv4";
//             webPath,  // "C:/Criss/html";  // 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的 html 路徑;
//             do_Request,  // 函數對象：do_Request，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//             key,  // ":",  // "username:password",  # 自定義的訪問網站簡單驗證用戶名和密碼;
//             sessionString,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
//             time_sleep  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
//         );
//     } else if (strncmp(interface_Function_name_str, "http_Server", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_http_Server", sizeof(interface_Function_name_str)) == 0) {
//     } else if (strncmp(interface_Function_name_str, "tcp_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "TCP_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_TCP_Client", sizeof(interface_Function_name_str)) == 0) {
//         socket_Client (
//             clientIPaddress,  // "::1" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
//             clientPORT,  // 0 ~ 65535，監聽埠號（端口）;
//             IPversion,  // "IPv6"、"IPv4";
//             postData,  // Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
//             requestURL,  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
//             requestPath,  // "/" ;
//             requestMethod,  // "POST",  // "GET";  // 請求方法;
//             requestProtocol,  // "HTTP" ;
//             requestConnection,  // "keep-alive", "close";
//             requestFrom,  // "user@email.com" ;
//             requestReferer,  // 鏈接來源，輸入值爲 URL 網址字符串;  // Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  // 請求網址 URL："http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  // http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1;
//             time_out,  // 0, // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
//             Authorization,  // ":",  // "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
//             Cookie,  // "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
//             do_Response,  // 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
//             // sessionString,  // "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
//             time_sleep  // 0,  // 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
//         );
//     } else if (strncmp(interface_Function_name_str, "http_Client", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_http_Client", sizeof(interface_Function_name_str)) == 0) {
//     } else if (strncmp(interface_Function_name_str, "file_Monitor", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "File_Monitor", sizeof(interface_Function_name_str)) == 0 || strncmp(interface_Function_name_str, "interface_File_Monitor", sizeof(interface_Function_name_str)) == 0) {
//         file_Monitor_Run(
//             is_Monitor,
//             monitor_file,
//             monitor_dir,
//             do_Data,
//             output_dir,
//             output_file,
//             to_executable,
//             to_script,
//             temp_cache_IO_data_dir,
//             time_sleep,
//             read_file_do_Function,
//             write_file_do_Function,
//             file_Monitor
//         );
//     } else {}


//     // 釋放内存;
//     if (strlen(configFile) > 0) {
//         free(configFile);
//         // configFile = NULL;
//     }
//     if (strlen(interface_Function_name_str) > 0) {
//         free(interface_Function_name_str);
//         // interface_Function_name_str = NULL;
//     }
//     // if (serverPORT > 0) {
//     //     free(serverPORT);
//     //     // serverPORT = NULL;
//     // }
//     if (strlen(serverIPaddress) > 0) {
//         free(serverIPaddress);
//         // serverIPaddress = NULL;
//     }
//     // if (clientPORT > 0) {
//     //     free(clientPORT);
//     //     // clientPORT = NULL;
//     // }
//     if (strlen(clientIPaddress) > 0) {
//         free(clientIPaddress);
//         // clientIPaddress = NULL;
//     }
//     if (strlen(IPversion) > 0) {
//         free(IPversion);
//         // IPversion = NULL;
//     }
//     if (strlen(webPath) > 0) {
//         free(webPath);
//         // webPath = NULL;
//     }
//     if (strlen(requestURL) > 0) {
//         free(requestURL);
//         // requestURL = NULL;
//     }
//     if (strlen(requestPath) > 0) {
//         free(requestPath);
//         // requestPath = NULL;
//     }
//     if (strlen(requestConnection) > 0) {
//         free(requestConnection);
//         // requestConnection = NULL;
//     }
//     if (strlen(requestFrom) > 0) {
//         free(requestFrom);
//         // requestFrom = NULL;
//     }
//     if (strlen(requestReferer) > 0) {
//         free(requestReferer);
//         // requestReferer = NULL;
//     }
//     if (strlen(Authorization) > 0) {
//         free(Authorization);
//         // Authorization = NULL;
//     }
//     if (strlen(Cookie) > 0) {
//         free(Cookie);
//         // Cookie = NULL;
//     }
//     if (strlen(monitor_file) > 0) {
//         free(monitor_file);
//         // monitor_file = NULL;
//     }
//     if (strlen(monitor_dir) > 0) {
//         free(monitor_dir);
//         // monitor_dir = NULL;
//     }
//     if (strlen(output_dir) > 0) {
//         free(output_dir);
//         // output_dir = NULL;
//     }
//     if (strlen(output_file) > 0) {
//         free(output_file);
//         // output_file = NULL;
//     }
//     if (strlen(temp_cache_IO_data_dir) > 0) {
//         free(temp_cache_IO_data_dir);
//         // temp_cache_IO_data_dir = NULL;
//     }
//     // if (strlen(to_executable) > 0) {
//     //     free(to_executable);
//     //     // to_executable = NULL;
//     // }
//     // if (strlen(to_script) > 0) {
//     //     free(to_script);
//     //     // to_script = NULL;
//     // }
//     if (strlen(key) > 0) {
//         free(key);
//         // key = NULL;
//     }
//     if (strlen(sessionString) > 0) {
//         free(sessionString);
//         // sessionString = NULL;
//     }
//     if (strlen(postData) > 0) {
//         free(postData);
//         // postData = NULL;
//     }
//     // if (strlen(isBlock) > 0) {
//     //     free(isBlock);
//     //     // isBlock = NULL;
//     // }

//     return 0;
// }
