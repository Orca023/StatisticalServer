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
// C:\> C:\MinGW64\bin\gcc.exe C:/Criss/c/Router.c C:/Criss/c/Interface.c C:/Criss/c/cjson/cJSON.c -o C:/Criss/c/Router.exe -lm -lws2_32
// root@localhost:~# /usr/bin/gcc /home/Criss/c/Router.c /home/Criss/c/Interface.c /home/Criss/c/cjson/cJSON.c -o /home/Criss/c/Router.exe -lm
// 控制臺顯示中文字符指令;
// root@localhost:~# chcp 65001
// 運行指令：
// C:\> C:/Criss/c/Router.exe configFile=C:/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=C:/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=C:/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}
// root@localhost:~# /home/Criss/c/Router.exe configFile=/home/Criss/c/config.txt interface_Function=tcp_Server is_monitor=true monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_C.txt temp_cache_IO_data_dir=/home/Criss/temp/ key=username:password IPversion=IPv6 serverHOST=::0 serverPORT=10001 webPath=/home/Criss/html/ time_sleep=1.0 time_out=1.0 clientHOST=::1 clientPORT=10001 requestConnection=keep-alive requestPath=/ requestData={"Client_say":"language-C-Socket-client-connection-在這裏輸入向服務端發送的待處理的數據.","time":"2021-04-24T14:05:33.286"}

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


// // 加載自定義的 C 語言模組代碼文檔;
// #include "Interface.h"


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
char* do_Data_2 (int argc, char *argv) {

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


    // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // char *session_request_Key = "";
    // cJSON *sessionJSON = cJSON_CreateObject();  // 創建空 JSON 對象;  // {"request_Key->username:password":"username:password"};  // 保存網站的 Session 數據;
    // // 使用自定義函數：print_preallocated() 判斷創建是否成功，如失敗則釋放内存並中止後續程式執行;
    // if (print_preallocated(sessionJSON) != 0) {
    //     printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //     cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     return 1;
    // }
    // // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // if (strlen(session) > 0) {

    //     sessionJSON = cJSON_Parse(session);  // 將 JSON 字符串解析爲 C 語言的 cJSON 對象;
    //     if (sessionJSON == NULL) {
    //         printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //         return 1;
    //     } else {

    //         // printf("%s\n", cJSON_PrintUnformatted(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串原始狀態打印（無空格）;
    //         // printf("%s\n", cJSON_Print(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串格式化打印;
    //         // char *session = cJSON_PrintUnformatted(sessionJSON);
    //         // printf("%s\n", session);
    //         // char *session = cJSON_Print(sessionJSON);
    //         // printf("%s\n", session);
    //         // free(session);  // 釋放内存;

    //         // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組或 JSON 對象長度;
    //         int size = cJSON_GetArraySize(sessionJSON);
    //         printf("Number of key-value pairs: %d\n", size);

    //         // // 獲取擴展包 cJSON 定義的 JSON 對象長度;
    //         // int count = 0;
    //         // cJSON *item = sessionJSON->child;
    //         // while (item != NULL) {
    //         //     count++;
    //         //     item = item->next;
    //         // }
    //         // printf("Number of key-value pairs: %d\n", count);
    //         // cJSON_Delete(item);  // 釋放内存;

    //         // 判斷擴展包 cJSON 定義的 JSON 對象内是否包含指定的鍵（key）;
    //         if (cJSON_HasObjectItem(sessionJSON, "request_Key->username:password")) {
    //             printf("Key 'request_Key->username:password' exists.\n");
    //         } else {
    //             printf("Key 'request_Key->username:password' does not exist.\n");
    //         }

    //         // 判斷是否爲 cJSON 定義的 JSON 對象;
    //         if (sessionJSON != NULL && cJSON_IsObject(sessionJSON)) {
    //             // 創建一個數組來保存 key 字符串;
    //             cJSON *keys_array = cJSON_CreateArray(); // 創建一個數組來保存 key 字符串;
    //             // 遍歷擴展包 cJSON 定義的 JSON 對象内包含的所有鍵（key）;
    //             cJSON *keys = sessionJSON->child;
    //             while (keys != NULL) {
    //                 printf("Key: %s\n", keys->string);
    //                 // 將鍵存儲到某個數據結構中，如數組或鏈表等;
    //                 cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // if (keys->string) {
    //                 //     printf("Key: %s\n", keys->string);
    //                 //     // 如果當前項是 key 字符串，則添加到數組中;
    //                 //     cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // } else if (keys->string == cJSON_Object) {
    //                 //     // 如果當前項是 cJSON 對象嵌套，遞歸遍歷;
    //                 // } else {}
    //                 keys = keys->next;
    //             }
    //             cJSON_Delete(keys);  // 釋放内存;
    //             printf("%s\n", cJSON_PrintUnformatted(keys_array));
    //             cJSON_Delete(keys_array);  // 釋放内存;
    //         } else {
    //             printf("Error parsing JSON or JSON is not an object.\n");
    //         }

    //         // // 調用 cJSON *cJSON_GetObjectItem(const cJSON *object, const char *string) 函數對關聯數組（JSON 對象）取值;
    //         // cJSON *details = cJSON_GetObjectItem(sessionJSON, "details");  // 擴展包 cJSON 定義的 JSON 對象按照指定鍵（key）取值（value）;
    //         // cJSON *age = cJSON_GetObjectItem(details, "age");
    //         // printf("Age: %s\n", cJSON_PrintUnformatted(age));
    //         // cJSON *numbers = cJSON_GetObjectItem(sessionJSON, "numbers");
    //         // // 調用 cJSON *cJSON_GetArrayItem(const cJSON *array, int index) 函數對數組取值;
    //         // cJSON *number_1 = cJSON_GetArrayItem(numbers, 0);  // 擴展包 cJSON 定義的數組按照指定下標序號取值;
    //         // printf("number 1: %s\n", cJSON_PrintUnformatted(number_1));
    //         // // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組對象長度;
    //         // int size_1 = cJSON_GetArraySize(numbers);
    //         // printf("Number of item in Array: %d\n", size_1);
    //         // cJSON_Delete(details);
    //         // cJSON_Delete(age);
    //         // cJSON_Delete(numbers);
    //         // cJSON_Delete(number_1);

    //         session_request_Key = cJSON_PrintUnformatted(cJSON_GetObjectItem(sessionJSON, "request_Key->username:password"));
    //         // printf("session request key: %s\n", session_request_Key);
    //         // free(session_request_Key);

    //     }

    // } else {
    //     // session = "{\"request_Key->username:password\":\"username:password\"}";
    //     // printf("Session not configured.");
    //     // cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     // return 1;
    // }

    // free(session);
    // cJSON_Delete(sessionJSON);  // 釋放内存;
    // // cJSON_Delete(session_request_Key);
    // free(session_request_Key);
}
// char *result = do_Data_2(0, "");
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
char* read_file_do_Function_2 (
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
// char *result = write_file_do_Function_2(
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


// 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
char* write_file_do_Function_2 (
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
// char *result = write_file_do_Function_2(
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
//     free(result); // 释放内存
// } else {
//     printf("Memory allocation failed.\n");
// }


// 2、Socket server and client;

// 服務器端（http_server）的自定義函數，用於處理用戶端（client）發送的請求數據;
char* do_Request_2 (int argc, char *argv) {

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


    // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // char *session_request_Key = "";
    // cJSON *sessionJSON = cJSON_CreateObject();  // 創建空 JSON 對象;  // {"request_Key->username:password":"username:password"};  // 保存網站的 Session 數據;
    // // 使用自定義函數：print_preallocated() 判斷創建是否成功，如失敗則釋放内存並中止後續程式執行;
    // if (print_preallocated(sessionJSON) != 0) {
    //     printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //     cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     return 1;
    // }
    // // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // if (strlen(session) > 0) {

    //     sessionJSON = cJSON_Parse(session);  // 將 JSON 字符串解析爲 C 語言的 cJSON 對象;
    //     if (sessionJSON == NULL) {
    //         printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //         return 1;
    //     } else {

    //         // printf("%s\n", cJSON_PrintUnformatted(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串原始狀態打印（無空格）;
    //         // printf("%s\n", cJSON_Print(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串格式化打印;
    //         // char *session = cJSON_PrintUnformatted(sessionJSON);
    //         // printf("%s\n", session);
    //         // char *session = cJSON_Print(sessionJSON);
    //         // printf("%s\n", session);
    //         // free(session);  // 釋放内存;

    //         // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組或 JSON 對象長度;
    //         int size = cJSON_GetArraySize(sessionJSON);
    //         printf("Number of key-value pairs: %d\n", size);

    //         // // 獲取擴展包 cJSON 定義的 JSON 對象長度;
    //         // int count = 0;
    //         // cJSON *item = sessionJSON->child;
    //         // while (item != NULL) {
    //         //     count++;
    //         //     item = item->next;
    //         // }
    //         // printf("Number of key-value pairs: %d\n", count);
    //         // cJSON_Delete(item);  // 釋放内存;

    //         // 判斷擴展包 cJSON 定義的 JSON 對象内是否包含指定的鍵（key）;
    //         if (cJSON_HasObjectItem(sessionJSON, "request_Key->username:password")) {
    //             printf("Key 'request_Key->username:password' exists.\n");
    //         } else {
    //             printf("Key 'request_Key->username:password' does not exist.\n");
    //         }

    //         // 判斷是否爲 cJSON 定義的 JSON 對象;
    //         if (sessionJSON != NULL && cJSON_IsObject(sessionJSON)) {
    //             // 創建一個數組來保存 key 字符串;
    //             cJSON *keys_array = cJSON_CreateArray(); // 創建一個數組來保存 key 字符串;
    //             // 遍歷擴展包 cJSON 定義的 JSON 對象内包含的所有鍵（key）;
    //             cJSON *keys = sessionJSON->child;
    //             while (keys != NULL) {
    //                 printf("Key: %s\n", keys->string);
    //                 // 將鍵存儲到某個數據結構中，如數組或鏈表等;
    //                 cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // if (keys->string) {
    //                 //     printf("Key: %s\n", keys->string);
    //                 //     // 如果當前項是 key 字符串，則添加到數組中;
    //                 //     cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // } else if (keys->string == cJSON_Object) {
    //                 //     // 如果當前項是 cJSON 對象嵌套，遞歸遍歷;
    //                 // } else {}
    //                 keys = keys->next;
    //             }
    //             cJSON_Delete(keys);  // 釋放内存;
    //             printf("%s\n", cJSON_PrintUnformatted(keys_array));
    //             cJSON_Delete(keys_array);  // 釋放内存;
    //         } else {
    //             printf("Error parsing JSON or JSON is not an object.\n");
    //         }

    //         // // 調用 cJSON *cJSON_GetObjectItem(const cJSON *object, const char *string) 函數對關聯數組（JSON 對象）取值;
    //         // cJSON *details = cJSON_GetObjectItem(sessionJSON, "details");  // 擴展包 cJSON 定義的 JSON 對象按照指定鍵（key）取值（value）;
    //         // cJSON *age = cJSON_GetObjectItem(details, "age");
    //         // printf("Age: %s\n", cJSON_PrintUnformatted(age));
    //         // cJSON *numbers = cJSON_GetObjectItem(sessionJSON, "numbers");
    //         // // 調用 cJSON *cJSON_GetArrayItem(const cJSON *array, int index) 函數對數組取值;
    //         // cJSON *number_1 = cJSON_GetArrayItem(numbers, 0);  // 擴展包 cJSON 定義的數組按照指定下標序號取值;
    //         // printf("number 1: %s\n", cJSON_PrintUnformatted(number_1));
    //         // // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組對象長度;
    //         // int size_1 = cJSON_GetArraySize(numbers);
    //         // printf("Number of item in Array: %d\n", size_1);
    //         // cJSON_Delete(details);
    //         // cJSON_Delete(age);
    //         // cJSON_Delete(numbers);
    //         // cJSON_Delete(number_1);

    //         session_request_Key = cJSON_PrintUnformatted(cJSON_GetObjectItem(sessionJSON, "request_Key->username:password"));
    //         // printf("session request key: %s\n", session_request_Key);
    //         // free(session_request_Key);

    //     }

    // } else {
    //     // session = "{\"request_Key->username:password\":\"username:password\"}";
    //     // printf("Session not configured.");
    //     // cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     // return 1;
    // }

    // free(session);
    // cJSON_Delete(sessionJSON);  // 釋放内存;
    // // cJSON_Delete(session_request_Key);
    // free(session_request_Key);
}
// char *result = do_Request_2(0, "");
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
char* do_Response_2 (int argc, char *argv) {

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


    // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // char *session_request_Key = "";
    // cJSON *sessionJSON = cJSON_CreateObject();  // 創建空 JSON 對象;  // {"request_Key->username:password":"username:password"};  // 保存網站的 Session 數據;
    // // 使用自定義函數：print_preallocated() 判斷創建是否成功，如失敗則釋放内存並中止後續程式執行;
    // if (print_preallocated(sessionJSON) != 0) {
    //     printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //     cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     return 1;
    // }
    // // char *session = "{\"request_Key->username:password\":\"username:password\"}";  // 保存網站的 Session 數據;
    // if (strlen(session) > 0) {

    //     sessionJSON = cJSON_Parse(session);  // 將 JSON 字符串解析爲 C 語言的 cJSON 對象;
    //     if (sessionJSON == NULL) {
    //         printf("Error before: [%s]\n", cJSON_GetErrorPtr());
    //         return 1;
    //     } else {

    //         // printf("%s\n", cJSON_PrintUnformatted(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串原始狀態打印（無空格）;
    //         // printf("%s\n", cJSON_Print(sessionJSON));  // 將 JSON 對象序列化爲 JSON 字符串格式化打印;
    //         // char *session = cJSON_PrintUnformatted(sessionJSON);
    //         // printf("%s\n", session);
    //         // char *session = cJSON_Print(sessionJSON);
    //         // printf("%s\n", session);
    //         // free(session);  // 釋放内存;

    //         // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組或 JSON 對象長度;
    //         int size = cJSON_GetArraySize(sessionJSON);
    //         printf("Number of key-value pairs: %d\n", size);

    //         // // 獲取擴展包 cJSON 定義的 JSON 對象長度;
    //         // int count = 0;
    //         // cJSON *item = sessionJSON->child;
    //         // while (item != NULL) {
    //         //     count++;
    //         //     item = item->next;
    //         // }
    //         // printf("Number of key-value pairs: %d\n", count);
    //         // cJSON_Delete(item);  // 釋放内存;

    //         // 判斷擴展包 cJSON 定義的 JSON 對象内是否包含指定的鍵（key）;
    //         if (cJSON_HasObjectItem(sessionJSON, "request_Key->username:password")) {
    //             printf("Key 'request_Key->username:password' exists.\n");
    //         } else {
    //             printf("Key 'request_Key->username:password' does not exist.\n");
    //         }

    //         // 判斷是否爲 cJSON 定義的 JSON 對象;
    //         if (sessionJSON != NULL && cJSON_IsObject(sessionJSON)) {
    //             // 創建一個數組來保存 key 字符串;
    //             cJSON *keys_array = cJSON_CreateArray(); // 創建一個數組來保存 key 字符串;
    //             // 遍歷擴展包 cJSON 定義的 JSON 對象内包含的所有鍵（key）;
    //             cJSON *keys = sessionJSON->child;
    //             while (keys != NULL) {
    //                 printf("Key: %s\n", keys->string);
    //                 // 將鍵存儲到某個數據結構中，如數組或鏈表等;
    //                 cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // if (keys->string) {
    //                 //     printf("Key: %s\n", keys->string);
    //                 //     // 如果當前項是 key 字符串，則添加到數組中;
    //                 //     cJSON_AddItemToArray(keys_array, cJSON_CreateString(keys->string));
    //                 // } else if (keys->string == cJSON_Object) {
    //                 //     // 如果當前項是 cJSON 對象嵌套，遞歸遍歷;
    //                 // } else {}
    //                 keys = keys->next;
    //             }
    //             cJSON_Delete(keys);  // 釋放内存;
    //             printf("%s\n", cJSON_PrintUnformatted(keys_array));
    //             cJSON_Delete(keys_array);  // 釋放内存;
    //         } else {
    //             printf("Error parsing JSON or JSON is not an object.\n");
    //         }

    //         // // 調用 cJSON *cJSON_GetObjectItem(const cJSON *object, const char *string) 函數對關聯數組（JSON 對象）取值;
    //         // cJSON *details = cJSON_GetObjectItem(sessionJSON, "details");  // 擴展包 cJSON 定義的 JSON 對象按照指定鍵（key）取值（value）;
    //         // cJSON *age = cJSON_GetObjectItem(details, "age");
    //         // printf("Age: %s\n", cJSON_PrintUnformatted(age));
    //         // cJSON *numbers = cJSON_GetObjectItem(sessionJSON, "numbers");
    //         // // 調用 cJSON *cJSON_GetArrayItem(const cJSON *array, int index) 函數對數組取值;
    //         // cJSON *number_1 = cJSON_GetArrayItem(numbers, 0);  // 擴展包 cJSON 定義的數組按照指定下標序號取值;
    //         // printf("number 1: %s\n", cJSON_PrintUnformatted(number_1));
    //         // // 使用 cJSON *cJSON_GetArraySize() 函數來獲取擴展包 cJSON 定義的數組對象長度;
    //         // int size_1 = cJSON_GetArraySize(numbers);
    //         // printf("Number of item in Array: %d\n", size_1);
    //         // cJSON_Delete(details);
    //         // cJSON_Delete(age);
    //         // cJSON_Delete(numbers);
    //         // cJSON_Delete(number_1);

    //         session_request_Key = cJSON_PrintUnformatted(cJSON_GetObjectItem(sessionJSON, "request_Key->username:password"));
    //         // printf("session request key: %s\n", session_request_Key);
    //         // free(session_request_Key);

    //     }

    // } else {
    //     // session = "{\"request_Key->username:password\":\"username:password\"}";
    //     // printf("Session not configured.");
    //     // cJSON_Delete(sessionJSON);
    //     // exit(EXIT_FAILURE);
    //     // return 1;
    // }

    // free(session);
    // cJSON_Delete(sessionJSON);  // 釋放内存;
    // // cJSON_Delete(session_request_Key);
    // free(session_request_Key);
}
// char *result = do_Response_2(0, "");
// if (result != NULL) {
//     for (int i = 0; i < 8; i++) {
//         printf("%02X ", result[i]);
//     }
//     printf("\n");
// } else {
//     printf("Memory allocation failed.\n");
// }
// free(result); // 释放内存防止溢出;
