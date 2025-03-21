# module Router
# Main.Router
Base.push!(LOAD_PATH, ".")  # 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;
# Base.MainInclude.include(Base.filter(Base.contains(r".*\.jl$"), Base.Filesystem.readdir()));  # 在 Jupyterlab 中實現加載 Base.MainInclude.include("*.jl") 文檔，其中 r".*\.jl$" 為解析脚本文檔名的正則表達式;
# Base.MainInclude.include(popfirst!(ARGS));
# println(Base.PROGRAM_FILE)


#################################################################################;

# Title: Julia statistical algorithm server v20161211
# Explain: Julia file server, Julia http server, Julia http client
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在丙申
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: julia-1.9.3-win64.exe
# Interpreter: julia-1.10.3-linux-x86_64.tar.gz
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: julia-1.10.3-linux-aarch64.tar.gz

# 使用説明：
# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
# Base.MainInclude.include("/home/StatisticalServer/StatisticalServerJulia/Router.jl");
# Base.MainInclude.include("C:/StatisticalServer/StatisticalServerJulia/Router.jl");
# Base.MainInclude.include("./Router.jl");

# 控制臺命令列運行指令：
# C:\> C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl configFile=C:/StatisticalServer/config.txt webPath=C:/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/StatisticalServer/Intermediary/ monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=C:/StatisticalServer/Intermediary/ output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/StatisticalServer/temp/
# root@localhost:~# /usr/julia/julia-1.10.3/bin/julia -p 4 --project=/home/StatisticalServer/StatisticalServerJulia/ /home/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl configFile=/home/StatisticalServer/config.txt webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/

#################################################################################;


using Dates;  # 導入 Julia 的原生標準模組「Dates」，用於處理時間和日期數據，也可以用全名 Main.Dates. 訪問模組内的方法（函數）;
using Distributed;  # 導入 Julia 的原生標準模組「Distributed」，用於提供并行化和分佈式功能;
using Sockets;  # 導入 Julia 的原生標準模組「Sockets」，用於創建 TCP server 服務器;
using Base64;  # 導入 Julia 的原生標準模組「Base64」，用於按照 Base64 方式編解碼字符串;
# using SharedArrays;

Distributed.@everywhere using Dates, Distributed, Sockets, Base64;  # SharedArrays;  # 使用廣播關鍵字 Distributed.@everywhere 在所有子進程中加載指定模組或函數或變量;

# https://discourse.juliacn.com/t/topic/2969
# 如果想臨時更換pkg工具下載鏡像源，在julia解釋器環境命令行輸入命令：
# julia> ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
# 或者：
# Windows Powershell: $env:JULIA_PKG_SERVER = 'https://pkg.julialang.org'
# Linux/macOS Bash: export JULIA_PKG_SERVER="https://pkg.julialang.org"
using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# https://github.com/JuliaWeb/HTTP.jl
# https://juliaweb.github.io/HTTP.jl/stable/
# https://juliaweb.github.io/HTTP.jl/stable/server/
# https://juliaweb.github.io/HTTP.jl/stable/client/
# https://juliaweb.github.io/HTTP.jl/stable/reference/
# https://juliaweb.github.io/HTTP.jl/stable/examples/

using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# https://github.com/JuliaIO/JSON.jl
# JSON.parse - string or stream to Julia data structures
# s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
# j = JSON.parse(s)
# Dict{AbstractString,Any} with 2 entries:
#     "an_array" => {"string",9}
#     "a_number" => 5.0
# JSON.json - Julia data structures to a string
# JSON.json([2,3])
# "[2,3]"
# JSON.json(j)
# "{\"an_array\":[\"string\",9],\"a_number\":5.0}"

# using JSON3;  # 導入第三方擴展包「JSON3」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON3」：julia> using Pkg; Pkg.add("JSON3") 成功之後才能使用;
# # https://github.com/quinnj/JSON3.jl
# # read from file
# # json_string = Base.read("./my.json", String)
# # JSON3.read(json_string)
# # JSON3.read(json_string, T; kw...)
# # x = T()
# # JSON3.read!(json_string, x; kw...)
# # JSON3.write(x)
# # write to file
# # Base.open("./my.json", "w") do f
# #     JSON3.write(f, x)
# #     println(f)
# # end
# # write a pretty file
# # open("my.json", "w") do f
# #     JSON3.pretty(f, JSON3.write(x))
# #     println(f)
# # end

# using StructTypes  # 導入第三方擴展包「StructTypes」，需要在控制臺先安裝第三方擴展包「StructTypes」：julia> using Pkg; Pkg.add("StructTypes") 成功之後才能使用;


# # 導入第三方擴展包;
# using Regex;  # 正則表達式包;

# # 自定義函數，用於判斷一個字符串是否符合 IPv6 格式規則，或是符合 IPv4 格式規則;
# function CheckIP(address::Core.String)::Core.Union{Core.String, Core.Bool}
#     # using Regex;
#     IPv6_pattern = r"^(::)?([a-fA-F\d]{1,4}:){7}[a-fA-F\d]{1,4}(:[a-fA-F\d]{1,4}){0,3}$|^(?:(?!.*::.*::)(?:(?!.*::$)|(?!.*:$))(?:\w+:{1,3}\w*)+)$";
#     IPv4_pattern = r"^((25[0-5]|2[0-4][0-9]|1[0-9]{3}|[1-9][0-9]{0,1})(\.(25[0-5]|2[0-4][0-9]|1[0-9]{3}|[1-9][0-9]{0,1})){3})$";

#     if match(IPv6_pattern, address) !== Core.nothing
#         return "IPv6";
#     elseif match(IPv4_pattern, address) !== Core.nothing
#         return "IPv4";
#     else
#         return false;
#     end
# end
# # export CheckIP;


# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
Base.MainInclude.include("./Interpolation_Fitting.jl");  # 加載自定義算法模組，導入本地自定義 5PLC 方程等曲綫擬合函數模組;
# Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Interpolation_Fitting.jl"));
# Base.Filesystem.joinpath(Base.@__DIR__, "Interpolation_Fitting.jl")
# Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Interpolation_Fitting.jl")
# Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Interpolation_Fitting.jl")



# 示例函數，處理從硬盤文檔讀取到的JSON對象數據，然後返回處理之後的結果JSON對象，使用雙冒號::固定變量允許類型;
function do_data(data_Str::Core.String)::Core.String

    # print("當前協程 task: ", Base.current_task(), "\n");
    # print("當前協程 task 的 ID: ", Base.objectid(Base.current_task()), "\n");
    # print("當前綫程 thread 的 PID: ", Base.Threads.threadid(), "\n");
    # print("Julia 進程可用的綫程數目上綫: ", Base.Threads.nthreads(), "\n");
    # print("當前進程的 PID: ", Distributed.myid(), "\n");  # 需要事先加載原生的支持多進程標準模組 using Distributed 模組;
    # println(data_Str);
    request_form_value::Core.String = data_Str;  # 函數接收到的參數值;

    response_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_data_String::Core.String = "";

    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_data_Dict["Julia_say"] = Base.string(request_form_value);  # Base.Dict("Julia_say" => Base.string(request_form_value));
    response_data_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("Julia_say" => Base.string(request_form_value), "time" => string(return_file_creat_time));
    # println(response_data_Dict);

    # response_data_String = JSON.json(response_data_Dict);  # 使用第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    response_data_String = "{\"Julia_say\":\"" * Base.string(request_form_value) * "\",\"time\":\"" * Base.string(return_file_creat_time) * "\"}";  # 使用星號*拼接字符串;
    # println(response_data_String);

    return response_data_String;
end


# # 使用示例;
# is_monitor = false;  # true; # Boolean，用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
# monitor_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸入傳值的媒介目錄 "../Intermediary/";
# monitor_file = "D:/temp/intermediary_write_NodeJS.txt";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(monitor_dir, "intermediary_write_NodeJS.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於接收傳值的媒介文檔 "../Intermediary/intermediary_write_NodeJS.txt";
# output_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸出傳值的媒介目錄 "../Intermediary/";
# output_file = "D:/temp/intermediary_write_Julia.txt";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於輸出傳值的媒介文檔 "../Intermediary/intermediary_write_Julia.txt";
# temp_cache_IO_data_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_cache_IO_data_dir\";
# do_Function = do_data;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
# to_executable = "";  # C:/Progra~1/nodejs/node.exe";  # 上一層路徑下的Node.JS解釋器可執行檔路徑C:\nodejs\node.exe：Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node,exe")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的解釋器可執行文件 "..\\NodeJS\\node.exe"，Julia 解釋器可執行檔全名 println(Base.Sys.BINDIR)：C:\Julia 1.5.1\bin，;
# to_script = "";  # "C:/Users/china/Documents/Node.js/Criss/jl/test.js";  # 上一層路徑下的 JavaScript 脚本路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "Ruuter.js")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的被調用的脚本文檔 "../js/Ruuter.js";
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# number_Worker_threads = Core.UInt8(0);  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# isMonitorThreadsOrProcesses = 0;  # "Multi-Threading"; # "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
# # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# isDoTasksOrThreads = "Tasks";  # "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
# # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = monitor_file_Run(
#     is_monitor=is_monitor,  # 用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
#     monitor_file=monitor_file,  # 用於接收傳值的媒介文檔;
#     monitor_dir=monitor_dir,  # 用於輸入傳值的媒介目錄;
#     do_Function=do_Function,  # 用於接收執行數據處理功能的函數;
#     output_dir=output_dir,  # 用於輸出傳值的媒介目錄;
#     output_file=output_file,  # 用於輸出傳值的媒介文檔;
#     to_executable=to_executable,  # 用於對返回數據執行功能的解釋器二進制可執行檔;
#     to_script=to_script,  # 用於對返回數據執行功能的被調用的脚本文檔;
#     temp_cache_IO_data_dir=temp_cache_IO_data_dir,  # 用於暫存傳入傳出數據的臨時媒介文件夾;
#     number_Worker_threads=number_Worker_threads,  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目;
#     time_sleep=time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     read_file_do_Function=read_file_do_Function,  # 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
#     monitor_file_do_Function=monitor_file_do_Function,  # 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
#     isMonitorThreadsOrProcesses=isMonitorThreadsOrProcesses,  # 0 || "0" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     isDoTasksOrThreads=isDoTasksOrThreads # "Tasks" || "Multi-Threading"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])



# 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
function do_Request(request_Dict::Base.Dict{Core.String, Core.Any})::Core.String

    # print("當前協程 task: ", Base.current_task(), "\n");
    # print("當前協程 task 的 ID: ", Base.objectid(Base.current_task()), "\n");
    # print("當前綫程 thread 的 PID: ", Base.Threads.threadid(), "\n");
    # print("Julia 進程可用的綫程數目上綫: ", Base.Threads.nthreads(), "\n");
    # print("當前進程的 PID: ", Distributed.myid(), "\n");  # 需要事先加載原生的支持多進程標準模組 using Distributed 模組;
    # println(request_Dict);

    request_POST_String::Core.String = "";  # request_Dict["request_body_String"];  # 客戶端發送 post 請求時的請求體數據;
    request_POST_bytes_Array::Core.Union{Base.IOStream, Base.IOBuffer, Core.Nothing, Core.String, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}} = Base.IOBuffer();  # Core.Array{Core.UInt8, 1}();  # Core.Array{Core.UInt8, 1}();  # ::Core.Union{Base.Vector{Core.UInt8}, Core.String, Base.IOBuffer};
    request_POST_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}();
    request_Url::Core.String = "";  # request_Dict["Target"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
    request_Path::Core.String = "";  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
    request_Url_Query_String::Core.String = "";  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
    request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
    request_Authorization::Core.String = "";  # request_Dict["Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
    request_Cookie::Core.String = "";  # request_Dict["Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
    request_Nikename::Core.String = "";  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
    request_Password::Core.String = "";  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
    # request_time::Core.String = "";  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
    # request_Date::Core.String = "";  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
    request_IP::Core.String = "";  # request_Dict["request_IP"];  # 客戶端發送請求的 IP 地址字符串;
    # request_Method::Core.String = "";  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
    # request_Protocol::Core.String = "";  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "HTTP/1.1:"、"https:";
    request_User_Agent::Core.String = "";  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
    request_From::Core.String = "";  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;
    request_Host::Core.String = "";  # request_Dict["Host"];  # 客戶端發送請求的服務器名字和埠號值字符串 "127.0.0.1:8000"、"localhost:8000";
    if Base.length(request_Dict) > 0
        # Base.isa(request_Dict, Base.Dict)

        if Base.haskey(request_Dict, "request_body_String")
            request_POST_String = request_Dict["request_body_String"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_body_bytes_Array")
            request_POST_bytes_Array = request_Dict["request_body_bytes_Array"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_body_Dict")
            request_POST_Dict = request_Dict["request_body_Dict"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_Url")
            request_Url = request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
        elseif Base.haskey(request_Dict, "Target")
            request_Url = request_Dict["Target"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
        else
        end
        if Base.haskey(request_Dict, "request_Path")
            request_Path = request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
        end
        if Base.haskey(request_Dict, "request_Url_Query_String")
            request_Url_Query_String = request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
        end
        if Base.haskey(request_Dict, "request_Url_Query_Dict") && Base.isa(request_Dict["request_Url_Query_Dict"], Base.Dict)
            request_Url_Query_Dict = request_Dict["request_Url_Query_Dict"];  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
        end
        if Base.haskey(request_Dict, "Host")
            request_Host = request_Dict["Host"];  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.7:8000;
        end
        if Base.haskey(request_Dict, "Authorization")
            request_Authorization = request_Dict["Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
        end
        # println(request_Authorization);
        if Base.haskey(request_Dict, "Cookie")
            request_Cookie = request_Dict["Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
        end
        # println(request_Cookie);
        if Base.haskey(request_Dict, "request_Nikename")
            request_Nikename = request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
        end
        if Base.haskey(request_Dict, "request_Password")
            request_Password = request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
        end
        # if Base.haskey(request_Dict, "time")
        #     request_time = request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
        # end
        # if Base.haskey(request_Dict, "Date")
        #     request_Date = request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
        # end
        if Base.haskey(request_Dict, "request_IP")
            request_IP = request_Dict["request_IP"];  # 客戶端發送請求的 IP 地址字符串;
        end
        # if Base.haskey(request_Dict, "request_Method")
        #     request_Method = request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
        # end
        # if Base.haskey(request_Dict, "request_Protocol")
        #     request_Protocol = request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
        # end
        if Base.haskey(request_Dict, "User-Agent")
            request_User_Agent = request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
        end
        if Base.haskey(request_Dict, "From")
            request_From = request_Dict["From"];  # 客戶端發送請求的來源值字符串;
        end
        # if Base.haskey(request_Dict, "Host")
        #     request_Host = request_Dict["Host"];  # 客戶端發送請求的服務器名字值字符串 "127.0.0.1"、"localhost";
        # end
    end

    # if Base.length(request_Dict) === 0 || !Base.haskey(request_Dict, "Host") || request_Host === ""
    #     # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
    #     # println(host);
    #     # println(Base.typeof(host));
    #     # println(Core.isa(host, Sockets.IPv6));
    #     # println(Base.typeof(host) <: Sockets.IPv6);
    #     # println(Base.typeof(host) === Sockets.IPv6);
    #     # println(Core.isa(host, Sockets.IPv4));
    #     # println(Base.typeof(host) <: Sockets.IPv4);
    #     # println(Base.typeof(host) === Sockets.IPv4);
    #     # println(Base.typeof(Sockets.IPv4("0.0.0.0")));
    #     # println(Base.typeof(Sockets.IPv6("0")));
    #     # println(request_IP);
    #     if Base.haskey(request_Dict, "request_IP") && request_IP !== ""
    #         if Base.typeof(host) === Sockets.IPv6
    #             request_Host = Base.string("[", Base.string(request_IP), "]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
    #         elseif Base.typeof(host) === Sockets.IPv4
    #             request_Host = Base.string(Base.string(request_IP), ":", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.1:8000;
    #         else
    #         end
    #     # else
    #     #     if Base.typeof(host) === Sockets.IPv6
    #     #         if Base.string(host) === "localhost" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "::0" || Base.string(host) === "::1"
    #     #             request_Host = Base.string("[::1]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
    #     #         else
    #     #             request_Host = Base.string("[", Base.string(host), "]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
    #     #         end
    #     #     elseif Base.typeof(host) === Sockets.IPv4
    #     #         if Base.string(host) === "localhost" || Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
    #     #             request_Host = Base.string("127.0.0.1:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
    #     #         else
    #     #             request_Host = Base.string(Base.string(host), ":", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.1:8000;
    #     #         end
    #     #     else
    #     #     end
    #     end
    # end
    # # println(request_Host);

    # # 將客戶端請求 url 中的查詢字符串值解析為 Julia 字典類型;
    # # request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
    # if Base.isa(request_Url_Query_String, Core.String) && request_Url_Query_String !== ""
    #     if Base.occursin('&', request_Url_Query_String)
    #         # url_Query_Array = Core.Array{Core.Any, 1}();  # 聲明一個任意類型的空1維數組，可以使用 Base.push! 函數在數組末尾追加推入新元素;
    #         # url_Query_Array = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
    #         # 函數 Base.split(request_Url_Query_String, '&') 表示用等號字符'&'分割字符串為數組;
    #         for XXX in Base.split(request_Url_Query_String, '&')
    #             temp = Base.strip(XXX);  # Base.strip(str) 去除字符串首尾兩端的空格;
    #             temp = Base.convert(Core.String, temp);  # 使用 Base.convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
    #             # temp = Base.string(temp);
    #             if Base.isa(temp, Core.String) && Base.occursin('=', temp)
    #                 tempKey = Base.split(temp, '=')[1];
    #                 tempKey = Base.strip(tempKey);
    #                 tempKey = Base.convert(Core.String, tempKey);
    #                 tempKey = Base.string(tempKey);
    #                 # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #                 # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #                 # # Base64.base64decode("base64_Str");  # 解碼;
    #                 tempValue = Base.split(temp, '=')[2];
    #                 tempValue = Base.strip(tempValue);
    #                 tempValue = Base.convert(Core.String, tempValue);
    #                 tempValue = Base.string(tempValue);
    #                 # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #                 # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #                 # # Base64.base64decode("base64_Str");  # 解碼;
    #                 request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
    #             else
    #                 request_Url_Query_Dict[Base.string(temp)] = Base.string("");
    #             end
    #         end
    #     else
    #         if Base.isa(request_Url_Query_String, Core.String) && Base.occursin('=', request_Url_Query_String)
    #             tempKey = Base.split(request_Url_Query_String, '=')[1];
    #             tempKey = Base.strip(tempKey);
    #             tempKey = Base.convert(Core.String, tempKey);
    #             tempKey = Base.string(tempKey);
    #             # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #             # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #             # # Base64.base64decode("base64_Str");  # 解碼;
    #             tempValue = Base.split(request_Url_Query_String, '=')[2];
    #             tempValue = Base.strip(tempValue);
    #             tempValue = Base.convert(Core.String, tempValue);
    #             tempValue = Base.string(tempValue);
    #             # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #             # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #             # # Base64.base64decode("base64_Str");  # 解碼;
    #             request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
    #         else
    #             request_Url_Query_Dict[Base.string(request_Url_Query_String)] = Base.string("");
    #         end
    #     end
    # end

    # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
    request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
    # # request_data_Dict = Core.nothing;
    # if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
    #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
    #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    #     request_data_Dict = JSONparse(request_POST_String);  # 使用自定義函數 JSONparse() 將請求 Post 字符串解析為 Julia 字典（Dict）對象類型;
    # end
    # println(request_data_Dict);

    response_body_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_body_String::Core.String = "";

    # # require_data_Dict = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Int64}()聲明一個空字典並指定數據類型;
    # require_data_Dict = Base.Dict();  # 聲明一個空字典，函數接收到的參數;
    # # 使用自定義函數isStringJSON(request_form_value)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    # if isStringJSON(request_form_value)
    #     require_data_Dict = JSON.parse(request_form_value);  # 使用第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # else
    #     require_data_Dict["Client_say"] = data_Str;  # Base.Dict(data_Str);  # Base.Dict("aa" => 1, "bb" => 2, "cc" => 3);
    # end

    # 需要先加載 Julia 原生的 Dates 模組：using Dates;
    # 函數 Dates.now() 返回當前日期時間對象 2021-06-28T12:12:50.544，使用 Base.string(Dates.now()) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50.544。
    # 函數 Dates.time() 當前日期時間的 Unix 值 1.652232489777e9，UNIX 時間，或稱爲 POSIX 時間，是 UNIX 或類 UNIX 系統使用的時間表示方式：從 UTC 1970 年 1 月 1 日 0 時 0 分 0 秒起至現在的縂秒數，不考慮閏秒。
    # 函數 Dates.unix2datetime(Dates.time()) 將 Unix 時間轉化爲日期（時間）對象，使用 Base.string(Dates.unix2datetime(Dates.time())) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50。
    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_body_Dict["request_Url"] = Base.string(request_Url);  # Base.Dict("Target" => Base.string(request_Url));
    # response_body_Dict["request_Path"] = Base.string(request_Path);  # Base.Dict("request_Path" => Base.string(request_Path));
    # response_body_Dict["request_Url_Query_String"] = Base.string(request_Url_Query_String);  # Base.Dict("request_Url_Query_String" => Base.string(request_Url_Query_String));
    # response_body_Dict["request_POST"] = Base.string(request_POST_String);  # Base.Dict("request_POST" => Base.string(request_POST_String));
    response_body_Dict["request_Authorization"] = Base.string(request_Authorization);  # Base.Dict("request_Authorization" => Base.string(request_Authorization));
    response_body_Dict["request_Cookie"] = Base.string(request_Cookie);  # Base.Dict("request_Cookie" => Base.string(request_Cookie));
    # response_body_Dict["request_Nikename"] = Base.string(request_Nikename);  # Base.Dict("request_Nikename" => Base.string(request_Nikename));
    # response_body_Dict["request_Password"] = Base.string(request_Password);  # Base.Dict("request_Password" => Base.string(request_Password));
    response_body_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("request_POST" => Base.string(request_POST_String), "time" => string(return_file_creat_time));
    # response_body_Dict["Server_Authorization"] = Base.string(key);  # "username:password"，Base.Dict("Server_Authorization" => Base.string(key));
    response_body_Dict["Server_say"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
    response_body_Dict["error"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
    # println(response_body_Dict);

    # # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    # # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
    # response_body_String = JSONstring(response_body_Dict);
    # # 如果字符串長度太大，可以使用反斜杠 \ 來拆分跨行表示，例如 " a \ b" 這樣 a、b 可寫在兩行裏邊;
    # # 使用星號（*）拼接字符串;
    # # response_body_String = "{" * "\"" * "Target" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Url"]) * "\"" * "," * "\"" * "request_Path" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Path"]) * "\"" * "," * "\"" * "request_Url_Query_String" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Url_Query_String"]) * "\"" * "," * "\"" * "request_POST" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_POST"]) * "\"" * "," * "\"" * "request_Authorization" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Authorization"]) * "\"" * "," * "\"" * "request_Cookie" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Cookie"]) * "\"" * "," * "\"" * "request_Nikename" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Nikename"]) * "\"" * "," * "\"" * "request_Password" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Password"]) * "\"" * "," * "\"" * "Server_Authorization" * "\"" * ":" * "\"" * Base.string(response_body_Dict["Server_Authorization"]) * "\"" * "," * "\"" * "Server_say" * "\"" * ":" * "\"" * Base.string(response_body_Dict["Server_say"]) * "\"" * "," * "\"" * "error" * "\"" * ":" * "\"" * Base.string(response_body_Dict["error"]) * "\"" * "," * "\"" * "time" * "\"" * ":" * "\"" * Base.string(response_body_Dict["time"]) * "\"" * "}";  # 使用星號*拼接字符串;
    # # println(response_body_String);

    # webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
    web_path::Core.String = "";  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
    file_data::Core.String = "";  # 用於保存從硬盤讀取文檔中的數據;
    dir_list_Arror = Core.Array{Core.String, 1}();  # Core.Array{Core.Any, 1}(); # 用於保存從硬盤讀取文件夾中包含的子文檔和子文件夾名稱清單的字符串數組;

    fileName::Core.String = "";  # "/JuliaServer.jl" 自定義的待替換的文件路徑全名;
    # Base.isa(request_Url_Query_Dict, Base.Dict)
    if Base.haskey(request_Url_Query_Dict, "fileName")
        fileName = Base.string(request_Url_Query_Dict["fileName"]);  # "/JuliaServer.jl" 自定義的待替換的文件路徑全名;
    end
    if Base.haskey(request_Url_Query_Dict, "key")
        global key = Base.string(request_Url_Query_Dict["key"]);  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    elseif Base.haskey(request_Url_Query_Dict, "Key")
            global key = Base.string(request_Url_Query_Dict["Key"]);  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    elseif Base.haskey(request_Url_Query_Dict, "KEY")
        global key = Base.string(request_Url_Query_Dict["KEY"]);  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    end
    algorithmUser::Core.String = "";  # 使用算法的驗證賬號;
    if Base.haskey(request_Url_Query_Dict, "algorithmUser")
        algorithmUser = Base.string(request_Url_Query_Dict["algorithmUser"]);  # "username" 使用算法的驗證賬號;
    end
    algorithmPass::Core.String = "";  # 使用算法的驗證密碼;
    if Base.haskey(request_Url_Query_Dict, "algorithmPass")
        algorithmPass = Base.string(request_Url_Query_Dict["algorithmPass"]);  # "password" 使用算法的驗證賬號;
    end
    algorithmName::Core.String = "";  # "Fitting"、"Simulation" 具體算法的名稱;
    if Base.haskey(request_Url_Query_Dict, "algorithmName")
        algorithmName = Base.string(request_Url_Query_Dict["algorithmName"]);  # "Fitting"、"Simulation" 具體算法的名稱;
    end

    # println(request_Path);
    if request_Path === "/"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), "/index.html"));  # 拼接本地當前目錄下的請求文檔名;
        # println(web_path);

        file_data = "";

        Select_Statistical_Algorithms_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "SelectStatisticalAlgorithms.html"));  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # "<input id='AlgorithmsLC5PFitRadio' class='radio_type' type='radio' name='StatisticalAlgorithmsRadio' style='display: inline;' value='LC5PFit' checked='true'><label for='AlgorithmsLC5PFitRadio' id='AlgorithmsLC5PFitRadioTXET' class='radio_label' style='display: inline;'>5 parameter Logistic model fit</label> <input id='AlgorithmsLogisticFitRadio' class='radio_type' type='radio' name='StatisticalAlgorithmsRadio' style='display: inline;' value='LogisticFit'><label for='AlgorithmsLogisticFitRadio' id='AlgorithmsLogisticFitRadioTXET' class='radio_label' style='display: inline;'>Logistic model fit</label>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Select_Statistical_Algorithms_HTML_path) && Base.Filesystem.isfile(Select_Statistical_Algorithms_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Select_Statistical_Algorithms_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Select_Statistical_Algorithms_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Select_Statistical_Algorithms_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Select_Statistical_Algorithms_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Select_Statistical_Algorithms_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Select_Statistical_Algorithms_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Select_Statistical_Algorithms_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        Input_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "InputHTML.html"));  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # "<table id='LC5PFitInputTable' style='border-collapse:collapse; display: block;'><thead id='LC5PFitInputThead'><tr><th contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Input-1表頭名稱</th><th contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-2表頭名稱</th><th contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-3表頭名稱</th><th contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Input-4表頭名稱</th></tr></thead><tfoot id='LC5PFitInputTfoot'><tr><td contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Input-1表足名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-2表足名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-3表足名稱</td><td contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Input-4表足名稱</td></tr></tfoot><tbody id='LC5PFitInputTbody'><tr><td contenteditable='true' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>輸入Input-1名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Input-2名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Input-3名稱</td><td contenteditable='true' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>Input-4名稱</td></tr></tbody></table>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Input_HTML_path) && Base.Filesystem.isfile(Input_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Input_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Input_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Input_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Input_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Input_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Input_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Input_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        Output_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "OutputHTML.html"));  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # "<table id='LC5PFitOutputTable' style='border-collapse:collapse; display: block;'><thead id='LC5PFitOutputThead'><tr><th contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Output-1表頭名稱</th><th contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-2表頭名稱</th><th contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-3表頭名稱</th><th contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Output-4表頭名稱</th></tr></thead><tfoot id='LC5PFitOutputTfoot'><tr><td contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Output-1表足名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-2表足名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-3表足名稱</td><td contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Output-4表足名稱</td></tr></tfoot><tbody id='LC5PFitOutputTbody'><tr><td contenteditable='false' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>輸入Output-1名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Output-2名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Output-3名稱</td><td contenteditable='false' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>Output-4名稱</td></tr></tbody></table><canvas id='LC5PFitOutputCanvas' width='300' height='150' style='display: block;'></canvas>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Output_HTML_path) && Base.Filesystem.isfile(Output_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Output_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Output_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Output_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Output_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Output_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Output_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Output_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 替換 .html 文檔中指定的位置字符串;
        if file_data !== ""
            response_body_String = file_data;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Select_Statistical_Algorithms_HTML -->" => Select_Statistical_Algorithms_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Input_HTML -->" => Input_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Output_HTML -->" => Output_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        else
            response_body_Dict["Server_say"] = "文檔: " * web_path * " 爲空.";
            response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        end
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/index.html"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        file_data = "";

        Select_Statistical_Algorithms_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "SelectStatisticalAlgorithms.html"));  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # "<input id='AlgorithmsLC5PFitRadio' class='radio_type' type='radio' name='StatisticalAlgorithmsRadio' style='display: inline;' value='LC5PFit' checked='true'><label for='AlgorithmsLC5PFitRadio' id='AlgorithmsLC5PFitRadioTXET' class='radio_label' style='display: inline;'>5 parameter Logistic model fit</label> <input id='AlgorithmsLogisticFitRadio' class='radio_type' type='radio' name='StatisticalAlgorithmsRadio' style='display: inline;' value='LogisticFit'><label for='AlgorithmsLogisticFitRadio' id='AlgorithmsLogisticFitRadioTXET' class='radio_label' style='display: inline;'>Logistic model fit</label>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Select_Statistical_Algorithms_HTML_path) && Base.Filesystem.isfile(Select_Statistical_Algorithms_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Select_Statistical_Algorithms_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Select_Statistical_Algorithms_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Select_Statistical_Algorithms_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Select_Statistical_Algorithms_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Select_Statistical_Algorithms_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Select_Statistical_Algorithms_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " * Select_Statistical_Algorithms_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Select_Statistical_Algorithms_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        Input_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "InputHTML.html"));  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # "<table id='LC5PFitInputTable' style='border-collapse:collapse; display: block;'><thead id='LC5PFitInputThead'><tr><th contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Input-1表頭名稱</th><th contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-2表頭名稱</th><th contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-3表頭名稱</th><th contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Input-4表頭名稱</th></tr></thead><tfoot id='LC5PFitInputTfoot'><tr><td contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Input-1表足名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-2表足名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Input-3表足名稱</td><td contenteditable='true' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Input-4表足名稱</td></tr></tfoot><tbody id='LC5PFitInputTbody'><tr><td contenteditable='true' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>輸入Input-1名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Input-2名稱</td><td contenteditable='true' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Input-3名稱</td><td contenteditable='true' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>Input-4名稱</td></tr></tbody></table>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Input_HTML_path) && Base.Filesystem.isfile(Input_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Input_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Input_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Input_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Input_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Input_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Input_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " * Input_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Input_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        Output_HTML_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "OutputHTML.html"));  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # "<table id='LC5PFitOutputTable' style='border-collapse:collapse; display: block;'><thead id='LC5PFitOutputThead'><tr><th contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Output-1表頭名稱</th><th contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-2表頭名稱</th><th contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-3表頭名稱</th><th contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Output-4表頭名稱</th></tr></thead><tfoot id='LC5PFitOutputTfoot'><tr><td contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>輸入Output-1表足名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-2表足名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;'>Output-3表足名稱</td><td contenteditable='false' style='border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;'>Output-4表足名稱</td></tr></tfoot><tbody id='LC5PFitOutputTbody'><tr><td contenteditable='false' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>輸入Output-1名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Output-2名稱</td><td contenteditable='false' style='border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;'>Output-3名稱</td><td contenteditable='false' style='border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;'>Output-4名稱</td></tr></tbody></table><canvas id='LC5PFitOutputCanvas' width='300' height='150' style='display: block;'></canvas>";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(Output_HTML_path) && Base.Filesystem.isfile(Output_HTML_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(Output_HTML_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(Output_HTML_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(Output_HTML_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    Output_HTML = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(Output_HTML);
                else
                    response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(Output_HTML_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " * Output_HTML_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(Output_HTML_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(file_data);
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 替換 .html 文檔中指定的位置字符串;
        if file_data !== ""
            response_body_String = file_data;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Select_Statistical_Algorithms_HTML -->" => Select_Statistical_Algorithms_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Input_HTML -->" => Input_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            response_body_String = Base.string(Base.replace(response_body_String, "<!-- Output_HTML -->" => Output_HTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        else
            response_body_Dict["Server_say"] = "文檔: " * web_path * " 爲空.";
            response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        end
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/administrator.html"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        file_data = "";

        directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(webPath)

            dir_list_Arror = Base.Filesystem.readdir(webPath);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # Base.length(Base.Filesystem.readdir(webPath));
            # if Base.length(dir_list_Arror) > 0

                for item in dir_list_Arror

                    # if request_Path === "/"
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, item), "?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                    # elseif request_Path === "/index.html"
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    # else
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                    # end

                    if request_Host === ""
                        name_href_url_string = Base.string(Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    else
                        name_href_url_string = Base.string("http://", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("http://", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    end

                    downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
                    deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

                    statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))));

                    if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))))
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                        # directoryHTML = directoryHTML * "<tr><td><a href=\"javascript:" * Base.string(downloadFile_href_string) * "\">" * Base.string(item) * "</a></td><td>" * Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes") * "</td><td>" * Base.string(Dates.unix2datetime(statsObj.mtime)) * "</td><td><a href=\"javascript:" * Base.string(deleteFile_href_string) * "\">刪除</a></td></tr>";
                        directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
                    elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))))
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
                        # directoryHTML = directoryHTML * "<tr><td><a href=\"" * Base.string(name_href_url_string) * "\">" * Base.string(item) * "</a></td><td>" * Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes") * "</td><td>" * Base.string(Dates.unix2datetime(statsObj.mtime)) * "</td><td><a href=\"javascript:" * Base.string(deleteFile_href_string) * "\">刪除</a></td></tr>";
                        directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
                    else
                    end

                end

            # end

        else

            response_body_Dict["Server_say"] = "服務器的運行路徑: " * webPath * " 無法識別.";
            response_body_Dict["error"] = "Folder = { " * Base.string(webPath) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(file_data);
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 替換 .html 文檔中指定的位置字符串;
        if file_data !== ""
            response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        else
            response_body_Dict["Server_say"] = "文檔: " * web_path * " 爲空.";
            response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        end
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/uploadFile"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName === ""
            println("Upload file name empty { " * fileName * " }.");
            response_body_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " * Base.string(fileName) * " } 爲空.";
            response_body_Dict["error"] = "File name = { " * Base.string(fileName) * " } empty.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        web_path = "";
        if Base.string(fileName)[begin] === '/' || Base.string(fileName)[begin] === '\\'
            web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(Base.string(fileName)[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
        else
            web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(fileName)));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
        end

        # println(request_POST_String);
        # file_data = Base.string(request_POST_String);
        # println(file_data);

        file_data_UInt8Array = Core.Array{Core.UInt8, 1}();
        # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
        if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
            if Base.occursin("[", request_POST_String) && Base.occursin("]", request_POST_String) && request_POST_String !== "[]" && request_POST_String !== "\"[]\"" && request_POST_String !== "\\\"[]\\\""
                file_data_UInt8Array_String = "";
                if request_POST_String[begin] === '\\' && request_POST_String[begin+1] === '\"' && request_POST_String[begin+2] === '[' && request_POST_String[end-2] === ']' && request_POST_String[end-1] === '\\' && request_POST_String[end] === '\"'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+3:end-3]);  # 刪除數組字符串首端的 '\"[' 字符和尾端的 ']\"' 字符;
                elseif request_POST_String[begin] === '\"' && request_POST_String[begin+1] === '[' && request_POST_String[end-1] === ']' && request_POST_String[end] === '\"'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+2:end-2]);  # 刪除數組字符串首端的 '"[' 字符和尾端的 ']"' 字符;
                elseif request_POST_String[begin] === '[' && request_POST_String[end] === ']'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+1:end-1]);  # 刪除數組字符串首端的 '[' 字符和尾端的 ']' 字符;
                else
                end
                # println(file_data_UInt8Array_String);
                if file_data_UInt8Array_String !== "" && file_data_UInt8Array_String !== ","
                    if Base.occursin(",", file_data_UInt8Array_String)
                        file_data_UInt8Array = [Base.parse(Core.UInt8, X, base=10) for X = Base.split(file_data_UInt8Array_String, ",")];  # Julia 的數組推導式：[x+y for x=[[1,2] [3,4]], y=10:10:30 if isodd(x)] 返回值為：6-element Array{Int64,1}[11,13,21,23,31,33]，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                        # file_data_UInt8Array_String = Base.string("[", Base.string(Base.join(file_data_UInt8Array, ",")), "]");
                        # file_data_UInt8Array_String = "[" * Base.string(Base.join(file_data_UInt8Array, ",")) * "]";
                    else
                        Base.push!(file_data_UInt8Array, Base.parse(Core.UInt8, file_data_UInt8Array_String, base=10));  # 使用 push! 函數在數組末尾追加推入新元素，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                    end
                end
            end
        end

        # file_data_bytes_Array = Core.Array{Core.Any, 1}();  # 聲明一個 Core.Any 類型的空一維數組，客戶端 post 請求發送的字符串數據解析為 Julia 數組（Array）對象;
        # if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
        #     file_data_bytes_Array = JSONparse(request_POST_String);  # 使用自定義函數將 JSON 字符串轉換爲 Core.Any 類型的一維數組;
        #     # JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
        #     # JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}
        # end
        # println(file_data_bytes_Array);
        # file_data_UInt8Array = Core.Array{Core.UInt8, 1}();
        # # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
        # for i = 1:Base.length(file_data_bytes_Array)
        #     # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
        #     if Core.isa(file_data_bytes_Array[i], Core.UInt8)
        #         Base.push!(file_data_UInt8Array, file_data_bytes_Array[i]);  # 使用 push! 函數在數組末尾追加推入新元素;
        #     elseif Core.isa(file_data_bytes_Array[i], Core.String) && file_data_bytes_Array[i] !== ""
        #         Base.push!(file_data_UInt8Array, Base.parse(Core.UInt8, file_data_bytes_Array[i], base=10));  # 函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
        #     elseif Core.isa(file_data_bytes_Array[i], Core.Float64)
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     elseif Core.isa(file_data_bytes_Array[i], Core.Int64)
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     else
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     end
        # end
        # println(file_data_UInt8Array);
        # request_data_Dict = file_data_UInt8Array;

        # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的文檔是否存在，如果存在則判斷操作權限，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

            # 檢查待寫入文檔操作權限;
            if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                try
                    # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                    # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                    Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                    # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                    # 八進制值    說明
                    # 0o400      所有者可讀
                    # 0o200      所有者可寫
                    # 0o100      所有者可執行或搜索
                    # 0o40       群組可讀
                    # 0o20       群組可寫
                    # 0o10       群組可執行或搜索
                    # 0o4        其他人可讀
                    # 0o2        其他人可寫
                    # 0o1        其他人可執行或搜索
                    # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    # 數字	說明
                    # 7	可讀、可寫、可執行
                    # 6	可讀、可寫
                    # 5	可讀、可執行
                    # 4	唯讀
                    # 3	可寫、可執行
                    # 2	只寫
                    # 1	只可執行
                    # 0	沒有許可權
                    # 例如，八進制值 0o765 表示：
                    # 1) 、所有者可以讀取、寫入和執行該文檔；
                    # 2) 、群組可以讀和寫入該文檔；
                    # 3) 、其他人可以讀取和執行該文檔；
                    # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                catch err
                    println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "文檔 [ " * "/" * Base.string(fileName) * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .";  # "document [ file = " * "/" * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                    # response_body_Dict["Server_say"] = "文檔 [ " * Base.string(web_path) * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .";  # "document [ file = " * Base.string(web_path) * " ] change the permissions mode=0o777 fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            end

            # 同步刪除，已經存在的文檔，重新創建;
            try
                # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                Base.Filesystem.rm(web_path, force=true, recursive=false);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                # println("媒介文檔: " * web_path * " 已被刪除.");
            catch err
                println("文檔: " * web_path * " 無法刪除.");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法刪除.";  # "document [ file = " * "/" * Base.string(fileName) * " ] not delete.";
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法刪除.";  # "document [ file = " * Base.string(web_path) * " ] not delete.";
                response_body_Dict["error"] = Base.string(err);

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end

            # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
            # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

            # # 判斷文檔是否已經從硬盤刪除;
            # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)
            #     println("文檔: " * web_path * " 無法刪除.");

            #     response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法刪除.";  # "document [ output file = " * Base.string(web_path) * " ] not delete.";
            #     response_body_Dict["error"] = Base.string(err);

            #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_body_String = JSONstring(response_body_Dict);
            #     # println(response_body_String);
            #     # Base.exit(0);
            #     return response_body_String;
            # end
        else

            # 截取目標寫入目錄;
            writeDirectory::Core.String = "";
            # println(fileName);
            if Base.isa(fileName, Core.String) && Base.occursin('/', fileName)
                tempArray = Core.Array{Core.String, 1}();
                tempArray = Base.split(fileName, '/');
                if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
                    writeDirectory = "/";
                else
                    for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
                        if Core.Int64(i) === Core.Int64(1)
                            writeDirectory = Base.string(tempArray[i]);
                        else
                            writeDirectory = Base.string(writeDirectory) * "/" * Base.string(tempArray[i]);
                        end
                    end
                end
            elseif Base.isa(fileName, Core.String) && Base.occursin('\\', fileName)
                tempArray = Core.Array{Core.String, 1}();
                tempArray = Base.split(fileName, '\\');
                if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
                    writeDirectory = "\\";
                else
                    for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
                        if Core.Int64(i) === Core.Int64(1)
                            writeDirectory = Base.string(tempArray[i]);
                        else
                            writeDirectory = Base.string(writeDirectory) * "\\" * Base.string(tempArray[i]);
                        end
                    end
                end
            else
                writeDirectory = "/";
            end
            # println(writeDirectory);
            AbsolutewriteDirectory::Core.String = "";
            if Base.string(writeDirectory)[begin] === '/' || Base.string(writeDirectory)[begin] === '\\'
                AbsolutewriteDirectory = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), writeDirectory[begin+1:end]));
            else
                AbsolutewriteDirectory = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), writeDirectory));
            end
            # println(AbsolutewriteDirectory);

            # 判斷目標寫入目錄是否存在，如果不存在則創建;
            # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的寫入目錄（文件夾）是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            # 同步判斷，使用 Julia 原生模組 Base.Filesystem.isdir(AbsolutewriteDirectory) 方法判斷是否為目錄（文件夾）;
            if !(Base.Filesystem.ispath(AbsolutewriteDirectory) && Base.Filesystem.isdir(AbsolutewriteDirectory))
                # 同步創建，創建指定的寫入目錄（文件夾）;
                try
                    # 同步遞歸創建目錄 Base.Filesystem.mkpath(path::AbstractString; mode::Unsigned=0o777)，返回值(return) path;
                    Base.Filesystem.mkpath(AbsolutewriteDirectory, mode=0o777);  # 同遞歸創建目錄，返回值(return) path;
                    # println("目錄: " * AbsolutewriteDirectory * " 創建成功.");
                catch err

                    println("指定的寫入目錄（文件夾）: " * AbsolutewriteDirectory * " 無法創建.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法創建.\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                    # response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            end

            # 判斷指定的寫入目錄（文件夾）是否創建成功;
            if !(Base.Filesystem.ispath(AbsolutewriteDirectory) && Base.Filesystem.isdir(AbsolutewriteDirectory))

                println("指定的寫入目錄（文件夾） [ " * Base.string(AbsolutewriteDirectory) * " ] 無法被創建.");

                response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾） [ " * Base.string(writeDirectory) * " ] 無法被創建.\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            elseif Base.stat(AbsolutewriteDirectory).mode !== Core.UInt64(16822) && Base.stat(AbsolutewriteDirectory).mode !== Core.UInt64(16895)

                # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(AbsolutewriteDirectory) 函數讀取文檔信息，使用 Base.stat(AbsolutewriteDirectory).mode 方法提取文檔權限碼;
                # println("指定的寫入目錄（文件夾） [ " * AbsolutewriteDirectory * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                try
                    # 使用 Base.Filesystem.chmod(AbsolutewriteDirectory, mode=0o777; recursive=true) 函數修改文檔操作權限;
                    # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                    Base.Filesystem.chmod(AbsolutewriteDirectory, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                    # println("目錄: " * AbsolutewriteDirectory * " 操作權限成功修改爲 mode=0o777 .");

                    # 八進制值    說明
                    # 0o400      所有者可讀
                    # 0o200      所有者可寫
                    # 0o100      所有者可執行或搜索
                    # 0o40       群組可讀
                    # 0o20       群組可寫
                    # 0o10       群組可執行或搜索
                    # 0o4        其他人可讀
                    # 0o2        其他人可寫
                    # 0o1        其他人可執行或搜索
                    # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    # 數字	說明
                    # 7	可讀、可寫、可執行
                    # 6	可讀、可寫
                    # 5	可讀、可執行
                    # 4	唯讀
                    # 3	可寫、可執行
                    # 2	只寫
                    # 1	只可執行
                    # 0	沒有許可權
                    # 例如，八進制值 0o765 表示：
                    # 1) 、所有者可以讀取、寫入和執行該文檔；
                    # 2) 、群組可以讀和寫入該文檔；
                    # 3) 、其他人可以讀取和執行該文檔；
                    # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                catch err

                    println("指定的寫入目錄（文件夾）: " * Base.string(AbsolutewriteDirectory) * " 無法修改操作權限爲 mode=0o777 .");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法修改操作權限爲 mode=0o777 .\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
                    # response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            else
            end

            # # 判斷文件夾權限;
            # if !(Base.stat(AbsolutewriteDirectory).mode === Core.UInt64(16822) || Base.stat(AbsolutewriteDirectory).mode === Core.UInt64(16895))
            #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(AbsolutewriteDirectory) 函數讀取文檔信息，使用 Base.stat(AbsolutewriteDirectory).mode 方法提取文檔權限碼;
            #     println("指定的寫入目錄（文件夾）: " * AbsolutewriteDirectory * " 無法修改操作權限爲 mode=0o777 .");

            #     response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法修改操作權限爲 mode=0o777 .\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
            #     response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";

            #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_body_String = JSONstring(response_body_Dict);
            #     # println(response_body_String);
            #     # Base.exit(0);
            #     return response_body_String;
            # end
        end

        # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
        # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
        # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
        # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
        # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
        # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
        # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
        # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
        # Base.ismarked(io);  # Return true if stream s is marked;
        # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
        # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
        # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
        # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
        # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
        # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
        # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
        # Base.close(io);  # 關閉緩衝區;
        # println(a)
        # Base.redirect_stdout — Function
        # redirect_stdout([stream]) -> (rd, wr)
        # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
        # If called with the optional stream argument, then returns stream itself.
        # Base.redirect_stdout — Method
        # redirect_stdout(f::Function, stream)
        # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
        # Base.redirect_stderr — Function
        # redirect_stderr([stream]) -> (rd, wr)
        # Like redirect_stdout, but for stderr.
        # Base.redirect_stderr — Method
        # redirect_stderr(f::Function, stream)
        # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
        # Base.redirect_stdin — Function
        # redirect_stdin([stream]) -> (rd, wr)
        # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
        # Base.redirect_stdin — Method
        # redirect_stdin(f::Function, stream)
        # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        # 同步創建一個空的文檔;
        # Base.Filesystem.touch — Function
        # touch(path::AbstractString)
        # Update the last-modified timestamp on a file to the current time. Return path.
        output_file_path = Base.Filesystem.touch(web_path);  # 創建一個空文檔;
        if !(Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path))
            println("文檔: " * web_path * " 無法創建.");

            response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法創建.";
            # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法創建.";
            response_body_Dict["error"] = "document [ file = " * "/" * Base.string(fileName) * " ] not create.";
            # response_body_Dict["error"] = "document [ file = " * Base.string(web_path) * " ] not create.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        elseif Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
            # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
            println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            try
                # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                # 八進制值    說明
                # 0o400      所有者可讀
                # 0o200      所有者可寫
                # 0o100      所有者可執行或搜索
                # 0o40       群組可讀
                # 0o20       群組可寫
                # 0o10       群組可執行或搜索
                # 0o4        其他人可讀
                # 0o2        其他人可寫
                # 0o1        其他人可執行或搜索
                # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                # 數字	說明
                # 7	可讀、可寫、可執行
                # 6	可讀、可寫
                # 5	可讀、可執行
                # 4	唯讀
                # 3	可寫、可執行
                # 2	只寫
                # 1	只可執行
                # 0	沒有許可權
                # 例如，八進制值 0o765 表示：
                # 1) 、所有者可以讀取、寫入和執行該文檔；
                # 2) 、群組可以讀和寫入該文檔；
                # 3) 、其他人可以讀取和執行該文檔；
                # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            catch err
                println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法修改操作權限爲 mode=0o777 .";  # "document [ file = " * "/" * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法修改操作權限爲 mode=0o777 .";  # "document [ file = " * Base.string(web_path) * " ] change the permissions mode=0o777 fail.";
                response_body_Dict["error"] = Base.string(err);

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
        else
        end

        # 同步寫入文檔中的數據;
        fWIO = Core.nothing;  # ::IOStream;
        try
            # numBytes = Base.write(fWIO, file_data_UInt8Array);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，二進制字節數據，返回值為寫入的字節數;
            # numBytes = write(web_path, file_data);  # 一次全部寫入字符串數據到指定文檔中，字符串類型 "utf-8"，返回值為寫入的字節數;
            # # write(filename::AbstractString, x)
            # # Write the canonical binary representation of a value to the given I/O stream or file. Return the number of bytes written into the stream. See also print to write a text representation (with an encoding that may depend upon io).
            # # You can write multiple values with the same write call. i.e. the following are equivalent:
            # println(numBytes);
            # println(Base.stat(web_path).size);
            # println(Base.stat(web_path).mtime);
            # # println(Dates.now());  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
            # println(Base.stat(web_path).ctime);
            # # Base.displaysize([io::IO]) -> (lines, columns)
            # # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
            # # Base.countlines — Function
            # # Base.countlines(io::IO; eol::AbstractChar = '\n')
            # # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.
            # println(Base.countlines(web_path, eol='\\n'));


            # 在 Base.open() 函數中，還可以調用函數;
            # Base.open(Base.readline, "sdy.txt");
            # 也可以調用自定義函數;
            # readFunc(s::IOStream) = Base.read(s, Char);
            # Base.open(readFunc, "sdy.txt");
            # 還可以像Python中的 with open...as 的用法一樣打開文件;
            # Base.open("sdy.txt","r") do stream
            #     for line in eachline(stream)
            #         println(line);
            #     end
            # end
            # 也可以將上述程序定義成函數再用open操作;
            # function readFunc2(stream)
            #     for line in eachline(stream)
            #         println(line);
            #     end
            # end
            # Base.open(readFunc2, "sdy.txt");

            fWIO = Base.open(web_path, "w");
            # nb = countlines(fWIO);  # 計算文檔中數據行數;
            # seekstart(fWIO);  # 指針返回文檔的起始位置;

            # Keyword	Description				Default
            # read		open for reading		!write
            # write		open for writing		truncate | append
            # create	create if non-existent	!read & write | truncate | append
            # truncate	truncate to zero size	!read & write
            # append	seek to end				false

            # Mode	Description						Keywords
            # r		read							none
            # w		write, create, truncate			write = true
            # a		write, create, append			append = true
            # r+	read, write						read = true, write = true
            # w+	read, write, create, truncate	truncate = true, read = true
            # a+	read, write, create, append		append = true, read = true

            # 使用 iswritable(io) 函數判斷文檔是否可寫;
            if Base.iswritable(fWIO)

                # numBytes = Base.write(fWIO, file_data);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，字符串類型 "utf-8"，返回值為寫入的字節數;
                numBytes = Base.write(fWIO, file_data_UInt8Array);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，二進制字節數據，返回值為寫入的字節數;
                Base.flush(fWIO);  # 將當前寫入操作的緩衝區所有數據都提交給傳出傳入流;
                # println(numBytes);
                # println(Base.stat(web_path).size);
                # println(Base.stat(web_path).mtime);
                # println(Dates.now());  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
                # println(Base.stat(web_path).ctime);
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.
                # println(Base.countlines(web_path, eol='\n'));

                response_body_Dict["Server_say"] = "向文檔: " * Base.string(fileName) * " 中寫入 " * Base.string(numBytes) * " 字節(Bytes)數據.";  # "Write file ( " * Base.string(web_path) * " ) " * Base.string(numBytes) * " Bytes data.";
                # response_body_Dict["Server_say"] = "向文檔: " * Base.string(web_path) * " 中寫入 " * Base.string(numBytes) * " 字節(Bytes)數據.";  # "Write file ( " * Base.string(web_path) * " ) " * Base.string(numBytes) * " Bytes data.";
                response_body_Dict["error"] = "";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                # return response_body_String;
            else
                println("無法向文檔: " * Base.string(web_path) * " 寫入數據.");
                response_body_Dict["Server_say"] = "無法向文檔: " * Base.string(fileName) * " 寫入數據.";
                response_body_Dict["error"] = "file ( " * Base.string(fileName) * " ) unable to write.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end

            # io = Base.IOBuffer("JuliaLang is a GitHub organization");
            # Base.IOStream();  # 包裝 OS 文檔描述符的緩衝 I/O 流。主要用於表示 open 返回的文檔;
            # A buffered IO stream wrapping an OS file descriptor. Mostly used to represent files returned by open.
            # Base.write — Function
            # write(io::IO, x)
            # write(filename::AbstractString, x)
            # Write the canonical binary representation of a value to the given I/O stream or file. Return the number of bytes written into the stream. See also print to write a text representation (with an encoding that may depend upon io).
            # You can write multiple values with the same write call. i.e. the following are equivalent:
            # write(io, x, y...)
            # write(io, x) + write(io, y...)

            # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
            # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
            # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
            # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
            # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
            # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
            # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
            # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
            # Base.ismarked(io);  # Return true if stream s is marked;
            # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
            # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
            # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
            # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
            # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
            # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
            # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
            # Base.close(io);  # 關閉緩衝區;
            # println(a)
            # Base.redirect_stdout — Function
            # redirect_stdout([stream]) -> (rd, wr)
            # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
            # If called with the optional stream argument, then returns stream itself.
            # Base.redirect_stdout — Method
            # redirect_stdout(f::Function, stream)
            # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
            # Base.redirect_stderr — Function
            # redirect_stderr([stream]) -> (rd, wr)
            # Like redirect_stdout, but for stderr.
            # Base.redirect_stderr — Method
            # redirect_stderr(f::Function, stream)
            # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
            # Base.redirect_stdin — Function
            # redirect_stdin([stream]) -> (rd, wr)
            # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
            # Base.redirect_stdin — Method
            # redirect_stdin(f::Function, stream)
            # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        catch err

            if Core.isa(err, Core.InterruptException)

                print("\n");
                # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                println("[ Ctrl ] + [ c ] received, will be return Function.");

                # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                response_body_Dict["error"] = Base.string(err);

            else

                println("向文檔: " * web_path * " 中寫入數據發生錯誤.");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "向文檔: " * "/" * Base.string(fileName) * " 中寫入數據發生錯誤.";  # "document [ file = " * Base.string(web_path) * " ] not write."
                # response_body_Dict["Server_say"] = "向文檔: " * Base.string(fileName) * " 中寫入數據發生錯誤.";  # "document [ file = " * Base.string(web_path) * " ] not write."
                response_body_Dict["error"] = Base.string(err);

            end

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;

        finally
            # Base.flush(fWIO);  # 將當前寫入操作的緩衝區所有數據都提交給傳出傳入流;
            # # 使用 Base.eof() 函數判斷是否已經寫到最後一個位置;
            # if Base.eof(fWIO)
            #     Base.close(fWIO);  # Close an I/O stream. Performs a flush first;
            # end
            Base.close(fWIO);  # Close an I/O stream. Performs a flush first;
        end

        # response_body_String = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        fWIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        # Base.GC.gc();  # 内存回收函數 gc();

        return response_body_String;

    elseif request_Path === "/deleteFile"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName === ""
            println("Upload file name empty { " * fileName * " }.");
            response_body_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " * Base.string(fileName) * " } 爲空.";
            response_body_Dict["error"] = "File name = { " * Base.string(fileName) * " } empty.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        if fileName !== ""

            web_path = "";
            if Base.string(fileName)[begin] === '/' || Base.string(fileName)[begin] === '\\'
                web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(Base.string(fileName)[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
            else
                web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(fileName)));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
            end
            file_data = Base.string(request_POST_String);

            # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的文檔是否存在，如果存在則判斷操作權限，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

                # # 檢查待刪除文檔的操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 同步刪除，已經存在的文檔，重新創建;
                try
                    # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    Base.Filesystem.rm(web_path, force=true, recursive=false);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                    # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    # println("文檔: " * web_path * " 已被刪除.");
                catch err
                    println("文檔: " * web_path * " 無法刪除.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "文檔: " * Base.string(fileName) * " 無法刪除.";  # "document file = [ " * Base.string(fileName) * " ] not delete.";
                    # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] not delete.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
                # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

                # # 判斷文檔是否已經從硬盤刪除;
                # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)
                #     println("文檔: " * web_path * " 無法刪除.");

                #     response_body_Dict["Server_say"] = "文檔: " * Base.string(fileName) * " 無法被刪除.";  # "document file = [ " * Base.string(fileName) * " ] not delete.";
                #     response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] not delete.";

                #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_body_String = JSONstring(response_body_Dict);
                #     # println(response_body_String);
                #     # Base.exit(0);
                #     return response_body_String;
                # end
            elseif Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(web_path)

                # # 檢查待刪除目錄（文件夾）操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(16822) && Base.stat(web_path).mode !== Core.UInt64(16895)
                #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(monitor_dir) 函數讀取文檔信息，使用 Base.stat(monitor_dir).mode 方法提取文檔權限碼;
                #     # println("文件夾 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文件夾操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文件夾: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("目錄（文件夾）: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "目錄（文件夾）：[ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 同步刪除，已經存在的文檔，重新創建;
                try
                    # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    Base.Filesystem.rm(web_path, force=true, recursive=true);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                    # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    # println("目錄（文件夾）: " * web_path * " 已被刪除.");
                catch err
                    println("目錄（文件夾）: " * web_path * " 無法刪除.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(fileName) * " 無法刪除.";  # "directory = [ " * Base.string(fileName) * " ] not delete.";
                    # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] not delete.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
                # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

                # # 判斷目錄（文件夾）是否已經從硬盤刪除;
                # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)
                #     println("目錄（文件夾）: " * web_path * " 無法被刪除.");

                #     response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(fileName) * " 無法被刪除.";  # "directory = [ " * Base.string(fileName) * " ] not delete.";
                #     response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] not delete.";

                #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_body_String = JSONstring(response_body_Dict);
                #     # println(response_body_String);
                #     # Base.exit(0);
                #     return response_body_String;
                # end
            else

                println("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " * Base.string(web_path) * " } 無法識別.");
                # response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(web_path) * " } 無法識別.";
                response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(fileName) * " } 無法識別.";
                # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "file = { " * Base.string(fileName) * " } unrecognized.";
                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
        end

        # web_path_index_Html = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));
        # # web_path_index_Html::Core.String = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));
        # # file_data = Base.string(request_POST_String);
        # # web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        # println(fileName);
        # # 截取當前所在目錄（文件夾）;
        # currentDirectory::Core.String = "";
        # if Base.isa(fileName, Core.String) && Base.occursin('/', fileName)
        #     tempArray = Core.Array{Core.String, 1}();
        #     tempArray = Base.split(fileName, '/');
        #     if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
        #         currentDirectory = "/";
        #     else
        #         for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
        #             if Core.Int64(i) === Core.Int64(1)
        #                 currentDirectory = Base.string(tempArray[i]);
        #             else
        #                 currentDirectory = Base.string(currentDirectory) * "/" * Base.string(tempArray[i]);
        #             end
        #         end
        #     end
        # else
        #     currentDirectory = "/";
        # end
        # # println(currentDirectory);
        # if Base.string(currentDirectory)[begin] === '/' || Base.string(currentDirectory)[begin] === '\\'
        #     web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), currentDirectory[begin+1:end]));
        # else
        #     web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), currentDirectory));
        # end
        # # println(web_path);

        # # 讀取服務器返回的響應值文檔字符串;
        # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)

        #     directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

        #     # 同步讀取指定硬盤文件夾（當前所處目錄文件夾）下包含的内容名稱清單，返回字符串數組;
        #     dir_list_Arror = Base.Filesystem.readdir(web_path);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
        #     # Base.length(Base.Filesystem.readdir(web_path));
        #     # if Base.length(dir_list_Arror) > 0
        #         for item in dir_list_Arror

        #             name_href_url_string = "";
        #             delete_href_url_string = "";
        #             if currentDirectory === "/"
        #                 name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(currentDirectory, item), "?fileName=", Base.string(currentDirectory, item), "&Key=", Base.string(key), "#");
        #                 delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(currentDirectory, item), "&Key=", Base.string(key), "#");
        #             else
        #                 name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(currentDirectory, "/", item), "?fileName=", Base.string(currentDirectory, "/", item), "&Key=", Base.string(key), "#");
        #                 delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(currentDirectory, "/", item), "&Key=", Base.string(key), "#");
        #             end
        #             downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
        #             deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

        #             statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))));

        #             if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
        #                 directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
        #             elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
        #                 directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
        #             else
        #             end

        #         end
        #     # end

        #     # 同步讀取硬盤 .html 文檔，返回字符串;
        #     if Base.Filesystem.ispath(web_path_index_Html) && Base.Filesystem.isfile(web_path_index_Html)

        #         fRIO = Core.nothing;  # ::IOStream;
        #         try
        #             # line = Base.Filesystem.readlink(web_path_index_Html);  # 讀取文檔中的一行數據;
        #             # Base.readlines — Function
        #             # Base.readlines(io::IO=stdin; keep::Bool=false)
        #             # Base.readlines(filename::AbstractString; keep::Bool=false)
        #             # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
        #             # for line in eachline(web_path_index_Html)
        #             #     print(line);
        #             # end
        #             # Base.displaysize([io::IO]) -> (lines, columns)
        #             # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
        #             # Base.countlines — Function
        #             # Base.countlines(io::IO; eol::AbstractChar = '\n')
        #             # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

        #             # 在 Base.open() 函數中，還可以調用函數;
        #             # Base.open(Base.readline, "sdy.txt");
        #             # 也可以調用自定義函數;
        #             # readFunc(s::IOStream) = Base.read(s, Char);
        #             # Base.open(readFunc, "sdy.txt");
        #             # 還可以像Python中的 with open...as 的用法一樣打開文件;
        #             # Base.open("sdy.txt","r") do stream
        #             #     for line in eachline(stream)
        #             #         println(line);
        #             #     end
        #             # end
        #             # 也可以將上述程序定義成函數再用open操作;
        #             # function readFunc2(stream)
        #             #     for line in eachline(stream)
        #             #         println(line);
        #             #     end
        #             # end
        #             # Base.open(readFunc2, "sdy.txt");

        #             fRIO = Base.open(web_path_index_Html, "r");
        #             # nb = countlines(fRIO);  # 計算文檔中數據行數;
        #             # seekstart(fRIO);  # 指針返回文檔的起始位置;

        #             # Keyword	Description				Default
        #             # read		open for reading		!write
        #             # write		open for writing		truncate | append
        #             # create	create if non-existent	!read & write | truncate | append
        #             # truncate	truncate to zero size	!read & write
        #             # append	seek to end				false

        #             # Mode	Description						Keywords
        #             # r		read							none
        #             # w		write, create, truncate			write = true
        #             # a		write, create, append			append = true
        #             # r+	read, write						read = true, write = true
        #             # w+	read, write, create, truncate	truncate = true, read = true
        #             # a+	read, write, create, append		append = true, read = true

        #             # io = Base.IOBuffer("JuliaLang is a GitHub organization");
        #             # Base.read(io, Core.String);
        #             # "JuliaLang is a GitHub organization";
        #             # Base.read(filename::AbstractString, Core.String);
        #             # Read the entire contents of a file as a string.
        #             # Base.read(s::IOStream, nb::Integer; all=true);
        #             # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
        #             # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
        #             # Base.read(command::Cmd)
        #             # Run command and return the resulting output as an array of bytes.
        #             # Base.read(command::Cmd, Core.String)
        #             # Run command and return the resulting output as a String.
        #             # Base.read!(stream::IO, array::Union{Array, BitArray})
        #             # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
        #             # Read binary data from an I/O stream or file, filling in array.
        #             # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
        #             # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
        #             # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
        #             # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
        #             # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

        #             # 使用 isreadable(io) 函數判斷文檔是否可讀;
        #             if Base.isreadable(fRIO)
        #                 # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
        #                 file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
        #             else
        #                 response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 無法讀取數據.";
        #                 response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) unable to read.";

        #                 # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #                 # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #                 # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #                 # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #                 response_body_String = JSONstring(response_body_Dict);
        #                 # println(response_body_String);
        #                 # Base.exit(0);
        #                 return response_body_String;
        #             end

        #             # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
        #             # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
        #             # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
        #             # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
        #             # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
        #             # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
        #             # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
        #             # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
        #             # Base.ismarked(io);  # Return true if stream s is marked;
        #             # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
        #             # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
        #             # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
        #             # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
        #             # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
        #             # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
        #             # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
        #             # Base.close(io);  # 關閉緩衝區;
        #             # println(a)
        #             # Base.redirect_stdout — Function
        #             # redirect_stdout([stream]) -> (rd, wr)
        #             # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
        #             # If called with the optional stream argument, then returns stream itself.
        #             # Base.redirect_stdout — Method
        #             # redirect_stdout(f::Function, stream)
        #             # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
        #             # Base.redirect_stderr — Function
        #             # redirect_stderr([stream]) -> (rd, wr)
        #             # Like redirect_stdout, but for stderr.
        #             # Base.redirect_stderr — Method
        #             # redirect_stderr(f::Function, stream)
        #             # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
        #             # Base.redirect_stdin — Function
        #             # redirect_stdin([stream]) -> (rd, wr)
        #             # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
        #             # Base.redirect_stdin — Method
        #             # redirect_stdin(f::Function, stream)
        #             # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        #         catch err

        #             if Core.isa(err, Core.InterruptException)

        #                 print("\n");
        #                 # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
        #                 # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
        #                 println("[ Ctrl ] + [ c ] received, will be return Function.");

        #                 # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
        #                 # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

        #                 response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
        #                 response_body_Dict["error"] = Base.string(err);

        #             else

        #                 println("指定的文檔: " * web_path_index_Html * " 無法讀取.");
        #                 println(err);
        #                 # println(err.msg);
        #                 # println(Base.typeof(err));

        #                 response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path_index_Html) * " 無法讀取.";
        #                 response_body_Dict["error"] = Base.string(err);
        #             end

        #             # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #             # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #             # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #             # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #             response_body_String = JSONstring(response_body_Dict);
        #             # println(response_body_String);
        #             # Base.exit(0);
        #             return response_body_String;

        #         finally
        #             Base.close(fRIO);
        #         end

        #         fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        #         # Base.GC.gc();  # 内存回收函數 gc();

        #     else

        #         response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path_index_Html) * " 無法識別.";
        #         response_body_Dict["error"] = "File = { " * Base.string(web_path_index_Html) * " } unrecognized.";

        #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #         response_body_String = JSONstring(response_body_Dict);
        #         # println(response_body_String);
        #         return response_body_String;
        #     end
        #     # 替換 .html 文檔中指定的位置字符串;
        #     if file_data !== ""
        #         response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        #     else
        #         response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 爲空.";
        #         response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) empty.";

        #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #         response_body_String = JSONstring(response_body_Dict);
        #         # println(response_body_String);
        #         # Base.exit(0);
        #         return response_body_String;
        #     end
        #     # println(response_body_String);

        #     return response_body_String;

        # else

        #     # response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(web_path) * " 無法識別.";
        #     response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(currentDirectory) * " 無法識別.";
        #     response_body_Dict["error"] = "directory = { " * Base.string(currentDirectory) * " } unrecognized.";

        #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_body_String = JSONstring(response_body_Dict);
        #     # println(response_body_String);
        #     return response_body_String;
        # end

        return response_body_String;

    elseif request_Path === "/Polynomial3Fit"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit

        # 將客戶端請求 url 中的查詢字符串值解析為 Julia 字典類型;
        # request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
        if Base.isa(request_Url_Query_String, Core.String) && request_Url_Query_String !== ""
            if Base.occursin('&', request_Url_Query_String)
                # url_Query_Array = Core.Array{Core.Any, 1}();  # 聲明一個任意類型的空1維數組，可以使用 Base.push! 函數在數組末尾追加推入新元素;
                # url_Query_Array = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
                # 函數 Base.split(request_Url_Query_String, '&') 表示用等號字符'&'分割字符串為數組;
                for XXX in Base.split(request_Url_Query_String, '&')
                    temp = Base.strip(XXX);  # Base.strip(str) 去除字符串首尾兩端的空格;
                    temp = Base.convert(Core.String, temp);  # 使用 Base.convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                    # temp = Base.string(temp);
                    if Base.isa(temp, Core.String) && Base.occursin('=', temp)
                        tempKey = Base.split(temp, '=')[1];
                        tempKey = Base.strip(tempKey);
                        tempKey = Base.convert(Core.String, tempKey);
                        tempKey = Base.string(tempKey);
                        # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        tempValue = Base.split(temp, '=')[2];
                        tempValue = Base.strip(tempValue);
                        tempValue = Base.convert(Core.String, tempValue);
                        tempValue = Base.string(tempValue);
                        # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                    else
                        request_Url_Query_Dict[Base.string(temp)] = Base.string("");
                    end
                end
            else
                if Base.isa(request_Url_Query_String, Core.String) && Base.occursin('=', request_Url_Query_String)
                    tempKey = Base.split(request_Url_Query_String, '=')[1];
                    tempKey = Base.strip(tempKey);
                    tempKey = Base.convert(Core.String, tempKey);
                    tempKey = Base.string(tempKey);
                    # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    tempValue = Base.split(request_Url_Query_String, '=')[2];
                    tempValue = Base.strip(tempValue);
                    tempValue = Base.convert(Core.String, tempValue);
                    tempValue = Base.string(tempValue);
                    # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                else
                    request_Url_Query_Dict[Base.string(request_Url_Query_String)] = Base.string("");
                end
            end
        end
        # println(request_Url_Query_Dict);

        # # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # # println(request_POST_String);
        # if request_POST_String === ""
        #     println("Request post string empty { " * request_POST_String * " }.");
        #     response_body_Dict["Server_say"] = "上傳參數錯誤，請求 post 數據字符串 request POST String = { " * Base.string(request_POST_String) * " } 爲空.";
        #     response_body_Dict["error"] = "Request post string = { " * Base.string(request_POST_String) * " } empty.";
        #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_body_String = JSONstring(response_body_Dict);
        #     # println(response_body_String);
        #     return response_body_String;
        # end

        # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            request_data_Dict = JSONparse(request_POST_String);  # 使用自定義函數 JSONparse() 將請求 Post 字符串解析為 Julia 字典（Dict）對象類型;
        end
        # println(request_data_Dict);
        # request_data_Dict = Base.Dict{Core.String, Core.Any}(
        #     "trainXdata" => [
        #         0.00001,  # Core.Float64(0.00001),
        #         1,  # Core.Float64(1),
        #         2,  # Core.Float64(2),
        #         3,  # Core.Float64(3),
        #         4,  # Core.Float64(4),
        #         5,  # Core.Float64(5),
        #         6,  # Core.Float64(6),
        #         7,  # Core.Float64(7),
        #         8,  # Core.Float64(8),
        #         9,  # Core.Float64(9),
        #         10  # Core.Float64(10)
        #     ],
        #     "trainYdata_1" => [
        #         100,  # Core.Float64(100),
        #         200,  # Core.Float64(200),
        #         300,  # Core.Float64(300),
        #         400,  # Core.Float64(400),
        #         500,  # Core.Float64(500),
        #         600,  # Core.Float64(600),
        #         700,  # Core.Float64(700),
        #         800,  # Core.Float64(800),
        #         900,  # Core.Float64(900),
        #         1000,  # Core.Float64(1000),
        #         1100  # Core.Float64(1100)
        #     ],
        #     "trainYdata_2" => [
        #         98,  # Core.Float64(98),
        #         198,  # Core.Float64(198),
        #         298,  # Core.Float64(298),
        #         398,  # Core.Float64(398),
        #         498,  # Core.Float64(498),
        #         598,  # Core.Float64(598),
        #         698,  # Core.Float64(698),
        #         798,  # Core.Float64(798),
        #         898,  # Core.Float64(898),
        #         998,  # Core.Float64(998),
        #         1098  # Core.Float64(1098)
        #     ],
        #     "trainYdata_3" => [
        #         102,  # Core.Float64(102),
        #         202,  # Core.Float64(202),
        #         302,  # Core.Float64(302),
        #         402,  # Core.Float64(402),
        #         502,  # Core.Float64(502),
        #         602,  # Core.Float64(602),
        #         702,  # Core.Float64(702),
        #         802,  # Core.Float64(802),
        #         902,  # Core.Float64(902),
        #         1002,  # Core.Float64(1002),
        #         1102  # Core.Float64(1102)
        #     ],
        #     "weight" => [
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5  # Core.Float64(0.5)
        #     ],
        #     "Pdata_0" => [
        #         90,  # Core.Float64(90),
        #         4,  # Core.Float64(4),
        #         1,  # Core.Float64(1),
        #         1210  # Core.Float64(1210)
        #     ],
        #     "Plower" => [
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf"  # -Base.Inf
        #     ],
        #     "Pupper" => [
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf"  # +Base.Inf
        #     ],
        #     "testYdata_1" => [
        #         150,  # Core.Float64(150),
        #         200,  # Core.Float64(200),
        #         250,  # Core.Float64(250),
        #         350,  # Core.Float64(350),
        #         450,  # Core.Float64(450),
        #         550,  # Core.Float64(550),
        #         650,  # Core.Float64(650),
        #         750,  # Core.Float64(750),
        #         850,  # Core.Float64(850),
        #         950,  # Core.Float64(950),
        #         1050  # Core.Float64(1050)
        #     ],
        #     "testYdata_2" => [
        #         148,  # Core.Float64(148),
        #         198,  # Core.Float64(198),
        #         248,  # Core.Float64(248),
        #         348,  # Core.Float64(348),
        #         448,  # Core.Float64(448),
        #         548,  # Core.Float64(548),
        #         648,  # Core.Float64(648),
        #         748,  # Core.Float64(748),
        #         848,  # Core.Float64(848),
        #         948,  # Core.Float64(948),
        #         1048  # Core.Float64(1048)
        #     ],
        #     "testYdata_3" => [
        #         152,  # Core.Float64(152),
        #         202,  # Core.Float64(202),
        #         252,  # Core.Float64(252),
        #         352,  # Core.Float64(352),
        #         452,  # Core.Float64(452),
        #         552,  # Core.Float64(552),
        #         652,  # Core.Float64(652),
        #         752,  # Core.Float64(752),
        #         852,  # Core.Float64(852),
        #         952,  # Core.Float64(952),
        #         1052  # Core.Float64(1052)
        #     ],
        #     "testXdata" => [
        #         0.5,  # Core.Float64(0.5),
        #         1,  # Core.Float64(1),
        #         1.5,  # Core.Float64(1.5),
        #         2.5,  # Core.Float64(2.5),
        #         3.5,  # Core.Float64(3.5),
        #         4.5,  # Core.Float64(4.5),
        #         5.5,  # Core.Float64(5.5),
        #         6.5,  # Core.Float64(6.5),
        #         7.5,  # Core.Float64(7.5),
        #         8.5,  # Core.Float64(8.5),
        #         9.5  # Core.Float64(9.5)
        #     ],
        #     "trainYdata" => [
        #         [100, 98, 102],  # [Core.Float64(100), Core.Float64(98), Core.Float64(102)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [300, 298, 302],  # [Core.Float64(300), Core.Float64(298), Core.Float64(302)],
        #         [400, 398, 402],  # [Core.Float64(400), Core.Float64(398), Core.Float64(402)],
        #         [500, 498, 502],  # [Core.Float64(500), Core.Float64(498), Core.Float64(502)],
        #         [600, 598, 602],  # [Core.Float64(600), Core.Float64(598), Core.Float64(602)],
        #         [700, 698, 702],  # [Core.Float64(700), Core.Float64(698), Core.Float64(702)],
        #         [800, 798, 802],  # [Core.Float64(800), Core.Float64(798), Core.Float64(802)],
        #         [900, 898, 902],  # [Core.Float64(900), Core.Float64(898), Core.Float64(902)],
        #         [1000, 998, 1002],  # [Core.Float64(1000), Core.Float64(998), Core.Float64(1002)],
        #         [1100, 1098, 1102]  # [Core.Float64(1100), Core.Float64(1098), Core.Float64(1102)]
        #     ],
        #     "testYdata" => [
        #         [150, 148, 152],  # [Core.Float64(150), Core.Float64(148), Core.Float64(152)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [250, 248, 252],  # [Core.Float64(250), Core.Float64(248), Core.Float64(252)],
        #         [350, 348, 352],  # [Core.Float64(350), Core.Float64(348), Core.Float64(352)],
        #         [450, 448, 452],  # [Core.Float64(450), Core.Float64(448), Core.Float64(452)],
        #         [550, 548, 552],  # [Core.Float64(550), Core.Float64(548), Core.Float64(552)],
        #         [650, 648, 652],  # [Core.Float64(650), Core.Float64(648), Core.Float64(652)],
        #         [750, 748, 752],  # [Core.Float64(750), Core.Float64(748), Core.Float64(752)],
        #         [850, 848, 852],  # [Core.Float64(850), Core.Float64(848), Core.Float64(852)],
        #         [950, 948, 952],  # [Core.Float64(950), Core.Float64(948), Core.Float64(952)],
        #         [1050, 1048, 1052]  # [Core.Float64(1050), Core.Float64(1048), Core.Float64(1052)]
        #     ]
        # );

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            yMean = Core.Float64(Statistics.mean(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        # 求 Ydata 標準差向量;
        trainYdataSTD = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            ySTD = Core.Float64(Statistics.std(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        end

        training_data = Base.Dict{Core.String, Core.Any}();
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["trainXdata"], "Ydata" => request_data_Dict["trainYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "trainXdata")
                if (Base.typeof(request_data_Dict["trainXdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainXdata"])
                        if (Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # training_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                training_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainXdata"][i])
                                    # Base.push!(training_data_Xdata_i, Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Xdata"][i][j] = Core.Float64(request_data_Dict["trainXdata"][i][j]);
                                    # Base.push!(training_data["Xdata"][i], Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Xdata"], training_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainXdata"][i], Core.String) || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # Base.push!(training_data["Xdata"], Core.Float64(request_data_Dict["trainXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Xdata"][i] = Core.Float64(request_data_Dict["trainXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "trainYdata")
                if (Base.typeof(request_data_Dict["trainYdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainYdata"])
                        if (Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # training_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                training_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainYdata"][i])
                                    # Base.push!(training_data_Ydata_i, Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Ydata"][i][j] = Core.Float64(request_data_Dict["trainYdata"][i][j]);
                                    # Base.push!(training_data["Ydata"][i], Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Ydata"], training_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainYdata"][i], Core.String) || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # Base.push!(training_data["Ydata"], Core.Float64(request_data_Dict["trainYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Ydata"][i] = Core.Float64(request_data_Dict["trainYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(training_data);
        trainXdata = training_data["Xdata"];

        testing_data = Base.Dict{Core.String, Core.Any}();
        # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["testXdata"], "Ydata" => request_data_Dict["testYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "testXdata")
                if (Base.typeof(request_data_Dict["testXdata"]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testXdata"])
                        if (Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # testing_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testXdata"][i])
                                    # Base.push!(testing_data_Xdata_i, Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Xdata"][i][j] = Core.Float64(request_data_Dict["testXdata"][i][j]);
                                    # Base.push!(testing_data["Xdata"][i], Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Xdata"], testing_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testXdata"][i], Core.String) || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # Base.push!(testing_data["Xdata"], Core.Float64(request_data_Dict["testXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Xdata"][i] = Core.Float64(request_data_Dict["testXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "testYdata")
                if (Base.typeof(request_data_Dict["testYdata"]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testYdata"])
                        if (Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # testing_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testYdata"][i])
                                    # Base.push!(testing_data_Ydata_i, Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Ydata"][i][j] = Core.Float64(request_data_Dict["testYdata"][i][j]);
                                    # Base.push!(testing_data["Ydata"][i], Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Ydata"], testing_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testYdata"][i], Core.String) || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # Base.push!(testing_data["Ydata"], Core.Float64(request_data_Dict["testYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Ydata"][i] = Core.Float64(request_data_Dict["testYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(testing_data);

        # 擬合（Fit）迭代參數起始值;
        Pdata_0_P1 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P1_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^3);
            else
                Pdata_0_P1_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^3);
            end
            Base.push!(Pdata_0_P1, Pdata_0_P1_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P1 = Core.Float64(Statistics.mean(Pdata_0_P1));
        # println(Pdata_0_P1);
        Pdata_0_P2 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P2_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^2);
            else
                Pdata_0_P2_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^2);
            end
            Base.push!(Pdata_0_P2, Pdata_0_P2_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P2 = Core.Float64(Statistics.mean(Pdata_0_P2));
        # println(Pdata_0_P2);
        Pdata_0_P3 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P3_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^1);
            else
                Pdata_0_P3_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^1);
            end
            Base.push!(Pdata_0_P3, Pdata_0_P3_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P3 = Core.Float64(Statistics.mean(Pdata_0_P3));
        # println(Pdata_0_P3);
        Pdata_0_P4 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                # 符號 / 表示常規除法，符號 % 表示除法取餘，等價於 Base.rem() 函數，符號 ÷ 表示除法取整，符號 * 表示乘法，符號 ^ 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                Pdata_0_P4_I_1 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P3 * trainXdata[i]^1)) * Core.Float64(Pdata_0_P3 * trainXdata[i]^1));
                Pdata_0_P4_I_2 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P2 * trainXdata[i]^2)) * Core.Float64(Pdata_0_P2 * trainXdata[i]^2));
                Pdata_0_P4_I_3 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P1 * trainXdata[i]^3)) * Core.Float64(Pdata_0_P1 * trainXdata[i]^3));
                Pdata_0_P4_I = Core.Float64(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3);
            else
                Pdata_0_P4_I = Core.Float64(trainYdataMean[i] - trainXdata[i]);
            end
            Base.push!(Pdata_0_P4, Pdata_0_P4_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P4 = Core.Float64(Statistics.mean(Pdata_0_P4));
        # println(Pdata_0_P4);
        # Pdata_0 = Core.Array{Core.Float64, 1}();
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])));  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])));
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])));
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) for i in 1:Base.length(trainYdataMean)])));
        # # Base.push!(Pdata_0, Core.Float64(0.0));
        # Pdata_0 = [
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) for i in 1:Base.length(trainYdataMean)]))
        #     # Core.Float64(0.0)
        # ];
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
            # Core.Float64(0.0)
        ];
        if Base.haskey(request_data_Dict, "Pdata_0")
            if Base.length(request_data_Dict["Pdata_0"]) > 0
                # Pdata_0 = request_data_Dict["Pdata_0"];
                Pdata_0 = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pdata_0"])
                    Base.push!(Pdata_0, Core.Float64(request_data_Dict["Pdata_0"][i]));
                end
            end
        end
        # println(Pdata_0);

        # Plower = Core.Array{Core.Float64, 1}();
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Plower = [
            -Inf,
            -Inf,
            -Inf,
            -Inf
            # -Inf
        ];
        if Base.haskey(request_data_Dict, "Plower")
            if Base.length(request_data_Dict["Plower"]) > 0
                # Plower = request_data_Dict["Plower"];
                Plower = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Plower"])
                    if Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "+Base.Inf" || request_data_Dict["Plower"][i] === "+Inf" || request_data_Dict["Plower"][i] === "+inf" || request_data_Dict["Plower"][i] === "+Infinity" || request_data_Dict["Plower"][i] === "+infinity" || request_data_Dict["Plower"][i] === "Base.Inf" || request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "inf" || request_data_Dict["Plower"][i] === "Infinity" || request_data_Dict["Plower"][i] === "infinity")
                        Base.push!(Plower, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "-Base.Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "-inf" || request_data_Dict["Plower"][i] === "-Infinity" || request_data_Dict["Plower"][i] === "-infinity")
                        Base.push!(Plower, -Base.Inf);
                    else
                        Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    end
                    # if request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Plower"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Plower_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Plower, Plower_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Plower, err);
                    #     end
                    # else
                    #     Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    # end
                end
            end
        end
        # println(Plower);

        # Pupper = Core.Array{Core.Float64, 1}();
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Pupper = [
            +Inf,
            +Inf,
            +Inf,
            +Inf
            # +Inf
        ];
        if Base.haskey(request_data_Dict, "Pupper")
            if Base.length(request_data_Dict["Pupper"]) > 0
                # Pupper = request_data_Dict["Pupper"];
                Pupper = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pupper"])
                    if Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "+Base.Inf" || request_data_Dict["Pupper"][i] === "+Inf" || request_data_Dict["Pupper"][i] === "+inf" || request_data_Dict["Pupper"][i] === "+Infinity" || request_data_Dict["Pupper"][i] === "+infinity" || request_data_Dict["Pupper"][i] === "Base.Inf" || request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "inf" || request_data_Dict["Pupper"][i] === "Infinity" || request_data_Dict["Pupper"][i] === "infinity")
                        Base.push!(Pupper, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "-Base.Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "-inf" || request_data_Dict["Pupper"][i] === "-Infinity" || request_data_Dict["Pupper"][i] === "-infinity")
                        Base.push!(Pupper, -Base.Inf);
                    else
                        Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    end
                    # if request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Pupper"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Pupper_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Pupper, Pupper_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Pupper, err);
                    #     end
                    # else
                    #     Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    # end
                end
            end
        end
        # println(Pupper);

        weight = Core.Array{Core.Float64, 1}();
        # target = Core.Int64(2);  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i = 1:Base.length(trainYdataMean)
        #     wei = Base.exp((trainYdataMean[i] / trainYdataMean[target] - 1)^2 / ((-2) * af^2));
        #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        if Base.haskey(request_data_Dict, "weight")
            if Base.length(request_data_Dict["weight"]) > 0
                # weight = request_data_Dict["weight"];
                weight = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["weight"])
                    Base.push!(weight, Core.Float64(request_data_Dict["weight"][i]));
                end
            end
        end
        # println(weight);

        # 函數使用示例;
        # Xdata = [
        #     Core.Float64(0.0001),
        #     Core.Float64(1.0),
        #     Core.Float64(2.0),
        #     Core.Float64(3.0),
        #     Core.Float64(4.0),
        #     Core.Float64(5.0),
        #     Core.Float64(6.0),
        #     Core.Float64(7.0),
        #     Core.Float64(8.0),
        #     Core.Float64(9.0),
        #     Core.Float64(10.0)
        # ];  # 自變量 x 的實測數據;
        # Ydata = [
        #     [Core.Float64(1000.0), Core.Float64(2000.0), Core.Float64(3000.0)],
        #     [Core.Float64(2000.0), Core.Float64(3000.0), Core.Float64(4000.0)],
        #     [Core.Float64(3000.0), Core.Float64(4000.0), Core.Float64(5000.0)],
        #     [Core.Float64(4000.0), Core.Float64(5000.0), Core.Float64(6000.0)],
        #     [Core.Float64(5000.0), Core.Float64(6000.0), Core.Float64(7000.0)],
        #     [Core.Float64(6000.0), Core.Float64(7000.0), Core.Float64(8000.0)],
        #     [Core.Float64(7000.0), Core.Float64(8000.0), Core.Float64(9000.0)],
        #     [Core.Float64(8000.0), Core.Float64(9000.0), Core.Float64(10000.0)],
        #     [Core.Float64(9000.0), Core.Float64(10000.0), Core.Float64(11000.0)],
        #     [Core.Float64(10000.0), Core.Float64(11000.0), Core.Float64(12000.0)],
        #     [Core.Float64(11000.0), Core.Float64(12000.0), Core.Float64(13000.0)]
        # ];  # 應變量 y 的實測數據;
        # # 求 Ydata 均值向量;
        # YdataMean = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     yMean = Core.Float64(Statistics.mean(Ydata[i]));
        #     Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # # 求 Ydata 標準差向量;
        # YdataSTD = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     ySTD = Core.Float64(Statistics.std(Ydata[i]));
        #     Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata[begin+1:end-1], "Ydata" => Ydata[begin+1:end-1]);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # # testing_data = training_data;

        # Pdata_0 = [
        #     Base.findmin(YdataMean)[1] * 0.9,
        #     Statistics.mean(Xdata),
        #     (1 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]),
        #     Base.findmax(YdataMean)[1] * 1.1
        #     # Core.Float64(1)
        # ];

        # Plower = [
        #     -Inf,
        #     -Inf,
        #     -Inf,
        #     -Inf
        #     # -Inf
        # ];
        # Pupper = [
        #     +Inf,
        #     +Inf,
        #     +Inf,
        #     +Inf
        #     # +Inf
        # ];

        # weight = Core.Array{Core.Float64, 1}();
        # target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i = 1:Base.length(YdataMean)
        #     wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
        #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end

        # result = Polynomial3Fit(
        #     training_data;
        #     # Xdata,
        #     # Ydata;
        #     testing_data = testing_data,
        #     Pdata_0 = Pdata_0,
        #     weight = weight,
        #     Plower = Plower,
        #     Pupper = Pupper
        # );
        # println(result["Coefficient"]);
        # println(result["testData"]);
        # # Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]);
        # # Gadfly.title(Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]), "4-parameter logistic model weighted least square method curve fit");
        # Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"]));
        # Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"])), "4-parameter logistic model weighted least square method curve fit");
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Curvefit.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Curvefit.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Curvefit.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Curve-fit-image"]
        # # );
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Residual.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Residual.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Residual.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Residual-image"]
        # # );
        # # [Base.string(result["Coefficient"][1]), Base.string(result["Coefficient"][2]), Base.string(result["Coefficient"][3]), Base.string(result["Coefficient"][4])]
        # # Base.write(Base.stdout, Base.string(result["Coefficient"][1]) * "\n" * Base.string(result["Coefficient"][2]) * "\n" * Base.string(result["Coefficient"][3]) * "\n" * Base.string(result["Coefficient"][4]) * "\n");

        # 調用自定義函數 Polynomial3Fit() 擬合 Polynomial - 3 曲綫;
        response_body_Dict = Polynomial3Fit(
            training_data;
            # Xdata,
            # Ydata;
            testing_data = testing_data,
            Pdata_0 = Pdata_0,
            weight = weight,
            Plower = Plower,
            Pupper = Pupper
        );
        # println(response_body_Dict);

        # 刪除 JSON 對象中包含的圖片元素;
        if Base.haskey(response_body_Dict, "Curve-fit-image")
            Base.delete!(response_body_Dict, "Curve-fit-image");
        end
        if Base.haskey(response_body_Dict, "Residual-image")
            Base.delete!(response_body_Dict, "Residual-image");
        end

        # 向字典中添加元素;
        response_body_Dict["request_Url"] = Base.string(request_Url);  # Base.Dict("Target" => Base.string(request_Url));
        # response_body_Dict["request_Path"] = Base.string(request_Path);  # Base.Dict("request_Path" => Base.string(request_Path));
        # response_body_Dict["request_Url_Query_String"] = Base.string(request_Url_Query_String);  # Base.Dict("request_Url_Query_String" => Base.string(request_Url_Query_String));
        # response_body_Dict["request_POST"] = request_data_Dict;  # Base.Dict("request_POST" => request_data_Dict);
        # response_body_Dict["request_POST"] = Base.string(request_POST_String);  # Base.Dict("request_POST" => Base.string(request_POST_String));
        response_body_Dict["request_Authorization"] = Base.string(request_Authorization);  # Base.Dict("request_Authorization" => Base.string(request_Authorization));
        response_body_Dict["request_Cookie"] = Base.string(request_Cookie);  # Base.Dict("request_Cookie" => Base.string(request_Cookie));
        # response_body_Dict["request_Nikename"] = Base.string(request_Nikename);  # Base.Dict("request_Nikename" => Base.string(request_Nikename));
        # response_body_Dict["request_Password"] = Base.string(request_Cookie);  # Base.Dict("request_Password" => Base.string(request_Password));
        response_body_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("request_POST" => Base.string(request_POST_String), "time" => string(return_file_creat_time));
        # response_body_Dict["Server_Authorization"] = Base.string(key);  # Base.Dict("Server_Authorization" => Base.string(key));
        response_body_Dict["Server_say"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        response_body_Dict["error"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        # println(response_body_Dict);

        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        response_body_String = JSONstring(response_body_Dict);  # 使用自定義函數 JSONstring() 將函數返回值的 Julia 字典（Dict）對象轉換為 JSON 字符串類型;
        # println(response_body_String);

        # response_body_Dict = Base.Dict{Core.String, Core.Any}(
        #     "Coefficient" => [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation" => [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%" => [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%" => [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit" => [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower" => [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper" => [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual" => [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData" => Base.Dict{Core.String, Core.Any}(
        #         "Ydata" => [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals" => [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower" => [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper" => [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata" => [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit" => [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower" => [],
        #         "test-Yfit-Uncertainty-Upper" => [],
        #         "test-Residual" => [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     ),
        #     "request_Url" => "/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit",
        #     "request_Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        #     "request_Cookie" => "session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk",
        #     "time" => "2024-02-03 17:59:58.239794",
        #     "Server_say" => "",
        #     "error" => ""
        # );
        # response_body_String = JSONstring(response_body_Dict);

        return response_body_String;

    elseif request_Path === "/LC5PFit"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit

        # 將客戶端請求 url 中的查詢字符串值解析為 Julia 字典類型;
        # request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
        if Base.isa(request_Url_Query_String, Core.String) && request_Url_Query_String !== ""
            if Base.occursin('&', request_Url_Query_String)
                # url_Query_Array = Core.Array{Core.Any, 1}();  # 聲明一個任意類型的空1維數組，可以使用 Base.push! 函數在數組末尾追加推入新元素;
                # url_Query_Array = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
                # 函數 Base.split(request_Url_Query_String, '&') 表示用等號字符'&'分割字符串為數組;
                for XXX in Base.split(request_Url_Query_String, '&')
                    temp = Base.strip(XXX);  # Base.strip(str) 去除字符串首尾兩端的空格;
                    temp = Base.convert(Core.String, temp);  # 使用 Base.convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                    # temp = Base.string(temp);
                    if Base.isa(temp, Core.String) && Base.occursin('=', temp)
                        tempKey = Base.split(temp, '=')[1];
                        tempKey = Base.strip(tempKey);
                        tempKey = Base.convert(Core.String, tempKey);
                        tempKey = Base.string(tempKey);
                        # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        tempValue = Base.split(temp, '=')[2];
                        tempValue = Base.strip(tempValue);
                        tempValue = Base.convert(Core.String, tempValue);
                        tempValue = Base.string(tempValue);
                        # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                    else
                        request_Url_Query_Dict[Base.string(temp)] = Base.string("");
                    end
                end
            else
                if Base.isa(request_Url_Query_String, Core.String) && Base.occursin('=', request_Url_Query_String)
                    tempKey = Base.split(request_Url_Query_String, '=')[1];
                    tempKey = Base.strip(tempKey);
                    tempKey = Base.convert(Core.String, tempKey);
                    tempKey = Base.string(tempKey);
                    # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    tempValue = Base.split(request_Url_Query_String, '=')[2];
                    tempValue = Base.strip(tempValue);
                    tempValue = Base.convert(Core.String, tempValue);
                    tempValue = Base.string(tempValue);
                    # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                else
                    request_Url_Query_Dict[Base.string(request_Url_Query_String)] = Base.string("");
                end
            end
        end
        # println(request_Url_Query_Dict);

        # # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # # println(request_POST_String);
        # if request_POST_String === ""
        #     println("Request post string empty { " * request_POST_String * " }.");
        #     response_body_Dict["Server_say"] = "上傳參數錯誤，請求 post 數據字符串 request POST String = { " * Base.string(request_POST_String) * " } 爲空.";
        #     response_body_Dict["error"] = "Request post string = { " * Base.string(request_POST_String) * " } empty.";
        #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_body_String = JSONstring(response_body_Dict);
        #     # println(response_body_String);
        #     return response_body_String;
        # end

        # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            request_data_Dict = JSONparse(request_POST_String);  # 使用自定義函數 JSONparse() 將請求 Post 字符串解析為 Julia 字典（Dict）對象類型;
        end
        # println(request_data_Dict);
        # request_data_Dict = Base.Dict{Core.String, Core.Any}(
        #     "trainXdata" => [
        #         0.00001,  # Core.Float64(0.00001),
        #         1,  # Core.Float64(1),
        #         2,  # Core.Float64(2),
        #         3,  # Core.Float64(3),
        #         4,  # Core.Float64(4),
        #         5,  # Core.Float64(5),
        #         6,  # Core.Float64(6),
        #         7,  # Core.Float64(7),
        #         8,  # Core.Float64(8),
        #         9,  # Core.Float64(9),
        #         10  # Core.Float64(10)
        #     ],
        #     "trainYdata_1" => [
        #         100,  # Core.Float64(100),
        #         200,  # Core.Float64(200),
        #         300,  # Core.Float64(300),
        #         400,  # Core.Float64(400),
        #         500,  # Core.Float64(500),
        #         600,  # Core.Float64(600),
        #         700,  # Core.Float64(700),
        #         800,  # Core.Float64(800),
        #         900,  # Core.Float64(900),
        #         1000,  # Core.Float64(1000),
        #         1100  # Core.Float64(1100)
        #     ],
        #     "trainYdata_2" => [
        #         98,  # Core.Float64(98),
        #         198,  # Core.Float64(198),
        #         298,  # Core.Float64(298),
        #         398,  # Core.Float64(398),
        #         498,  # Core.Float64(498),
        #         598,  # Core.Float64(598),
        #         698,  # Core.Float64(698),
        #         798,  # Core.Float64(798),
        #         898,  # Core.Float64(898),
        #         998,  # Core.Float64(998),
        #         1098  # Core.Float64(1098)
        #     ],
        #     "trainYdata_3" => [
        #         102,  # Core.Float64(102),
        #         202,  # Core.Float64(202),
        #         302,  # Core.Float64(302),
        #         402,  # Core.Float64(402),
        #         502,  # Core.Float64(502),
        #         602,  # Core.Float64(602),
        #         702,  # Core.Float64(702),
        #         802,  # Core.Float64(802),
        #         902,  # Core.Float64(902),
        #         1002,  # Core.Float64(1002),
        #         1102  # Core.Float64(1102)
        #     ],
        #     "weight" => [
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5  # Core.Float64(0.5)
        #     ],
        #     "Pdata_0" => [
        #         90,  # Core.Float64(90),
        #         4,  # Core.Float64(4),
        #         1,  # Core.Float64(1),
        #         1210  # Core.Float64(1210)
        #     ],
        #     "Plower" => [
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf"  # -Base.Inf
        #     ],
        #     "Pupper" => [
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf"  # +Base.Inf
        #     ],
        #     "testYdata_1" => [
        #         150,  # Core.Float64(150),
        #         200,  # Core.Float64(200),
        #         250,  # Core.Float64(250),
        #         350,  # Core.Float64(350),
        #         450,  # Core.Float64(450),
        #         550,  # Core.Float64(550),
        #         650,  # Core.Float64(650),
        #         750,  # Core.Float64(750),
        #         850,  # Core.Float64(850),
        #         950,  # Core.Float64(950),
        #         1050  # Core.Float64(1050)
        #     ],
        #     "testYdata_2" => [
        #         148,  # Core.Float64(148),
        #         198,  # Core.Float64(198),
        #         248,  # Core.Float64(248),
        #         348,  # Core.Float64(348),
        #         448,  # Core.Float64(448),
        #         548,  # Core.Float64(548),
        #         648,  # Core.Float64(648),
        #         748,  # Core.Float64(748),
        #         848,  # Core.Float64(848),
        #         948,  # Core.Float64(948),
        #         1048  # Core.Float64(1048)
        #     ],
        #     "testYdata_3" => [
        #         152,  # Core.Float64(152),
        #         202,  # Core.Float64(202),
        #         252,  # Core.Float64(252),
        #         352,  # Core.Float64(352),
        #         452,  # Core.Float64(452),
        #         552,  # Core.Float64(552),
        #         652,  # Core.Float64(652),
        #         752,  # Core.Float64(752),
        #         852,  # Core.Float64(852),
        #         952,  # Core.Float64(952),
        #         1052  # Core.Float64(1052)
        #     ],
        #     "testXdata" => [
        #         0.5,  # Core.Float64(0.5),
        #         1,  # Core.Float64(1),
        #         1.5,  # Core.Float64(1.5),
        #         2.5,  # Core.Float64(2.5),
        #         3.5,  # Core.Float64(3.5),
        #         4.5,  # Core.Float64(4.5),
        #         5.5,  # Core.Float64(5.5),
        #         6.5,  # Core.Float64(6.5),
        #         7.5,  # Core.Float64(7.5),
        #         8.5,  # Core.Float64(8.5),
        #         9.5  # Core.Float64(9.5)
        #     ],
        #     "trainYdata" => [
        #         [100, 98, 102],  # [Core.Float64(100), Core.Float64(98), Core.Float64(102)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [300, 298, 302],  # [Core.Float64(300), Core.Float64(298), Core.Float64(302)],
        #         [400, 398, 402],  # [Core.Float64(400), Core.Float64(398), Core.Float64(402)],
        #         [500, 498, 502],  # [Core.Float64(500), Core.Float64(498), Core.Float64(502)],
        #         [600, 598, 602],  # [Core.Float64(600), Core.Float64(598), Core.Float64(602)],
        #         [700, 698, 702],  # [Core.Float64(700), Core.Float64(698), Core.Float64(702)],
        #         [800, 798, 802],  # [Core.Float64(800), Core.Float64(798), Core.Float64(802)],
        #         [900, 898, 902],  # [Core.Float64(900), Core.Float64(898), Core.Float64(902)],
        #         [1000, 998, 1002],  # [Core.Float64(1000), Core.Float64(998), Core.Float64(1002)],
        #         [1100, 1098, 1102]  # [Core.Float64(1100), Core.Float64(1098), Core.Float64(1102)]
        #     ],
        #     "testYdata" => [
        #         [150, 148, 152],  # [Core.Float64(150), Core.Float64(148), Core.Float64(152)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [250, 248, 252],  # [Core.Float64(250), Core.Float64(248), Core.Float64(252)],
        #         [350, 348, 352],  # [Core.Float64(350), Core.Float64(348), Core.Float64(352)],
        #         [450, 448, 452],  # [Core.Float64(450), Core.Float64(448), Core.Float64(452)],
        #         [550, 548, 552],  # [Core.Float64(550), Core.Float64(548), Core.Float64(552)],
        #         [650, 648, 652],  # [Core.Float64(650), Core.Float64(648), Core.Float64(652)],
        #         [750, 748, 752],  # [Core.Float64(750), Core.Float64(748), Core.Float64(752)],
        #         [850, 848, 852],  # [Core.Float64(850), Core.Float64(848), Core.Float64(852)],
        #         [950, 948, 952],  # [Core.Float64(950), Core.Float64(948), Core.Float64(952)],
        #         [1050, 1048, 1052]  # [Core.Float64(1050), Core.Float64(1048), Core.Float64(1052)]
        #     ]
        # );

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            yMean = Core.Float64(Statistics.mean(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        # 求 Ydata 標準差向量;
        trainYdataSTD = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            ySTD = Core.Float64(Statistics.std(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        end

        training_data = Base.Dict{Core.String, Core.Any}();
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["trainXdata"], "Ydata" => request_data_Dict["trainYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "trainXdata")
                if (Base.typeof(request_data_Dict["trainXdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainXdata"])
                        if (Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # training_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                training_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainXdata"][i])
                                    # Base.push!(training_data_Xdata_i, Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Xdata"][i][j] = Core.Float64(request_data_Dict["trainXdata"][i][j]);
                                    # Base.push!(training_data["Xdata"][i], Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Xdata"], training_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainXdata"][i], Core.String) || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # Base.push!(training_data["Xdata"], Core.Float64(request_data_Dict["trainXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Xdata"][i] = Core.Float64(request_data_Dict["trainXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "trainYdata")
                if (Base.typeof(request_data_Dict["trainYdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainYdata"])
                        if (Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # training_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                training_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainYdata"][i])
                                    # Base.push!(training_data_Ydata_i, Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Ydata"][i][j] = Core.Float64(request_data_Dict["trainYdata"][i][j]);
                                    # Base.push!(training_data["Ydata"][i], Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Ydata"], training_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainYdata"][i], Core.String) || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # Base.push!(training_data["Ydata"], Core.Float64(request_data_Dict["trainYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Ydata"][i] = Core.Float64(request_data_Dict["trainYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(training_data);
        trainXdata = training_data["Xdata"];

        testing_data = Base.Dict{Core.String, Core.Any}();
        # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["testXdata"], "Ydata" => request_data_Dict["testYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "testXdata")
                if (Base.typeof(request_data_Dict["testXdata"]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testXdata"])
                        if (Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # testing_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testXdata"][i])
                                    # Base.push!(testing_data_Xdata_i, Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Xdata"][i][j] = Core.Float64(request_data_Dict["testXdata"][i][j]);
                                    # Base.push!(testing_data["Xdata"][i], Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Xdata"], testing_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testXdata"][i], Core.String) || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # Base.push!(testing_data["Xdata"], Core.Float64(request_data_Dict["testXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Xdata"][i] = Core.Float64(request_data_Dict["testXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "testYdata")
                if (Base.typeof(request_data_Dict["testYdata"]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testYdata"])
                        if (Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # testing_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testYdata"][i])
                                    # Base.push!(testing_data_Ydata_i, Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Ydata"][i][j] = Core.Float64(request_data_Dict["testYdata"][i][j]);
                                    # Base.push!(testing_data["Ydata"][i], Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Ydata"], testing_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testYdata"][i], Core.String) || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # Base.push!(testing_data["Ydata"], Core.Float64(request_data_Dict["testYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Ydata"][i] = Core.Float64(request_data_Dict["testYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(testing_data);

        # 擬合（Fit）迭代參數起始值;
        # Pdata_0 = Core.Array{Core.Float64, 1}();
        # Base.push!(Pdata_0, Base.findmin(trainYdataMean)[1] * 0.9);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pdata_0, Statistics.mean(request_data_Dict["trainXdata"]));  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pdata_0, (1 - Base.findmin(trainYdataMean)[1] / Base.findmax(trainYdataMean)[1]) / (1 - Base.findmin(request_data_Dict["trainXdata"])[1] / Base.findmax(request_data_Dict["trainXdata"])[1]));  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pdata_0, Base.findmax(trainYdataMean)[1] * 1.1);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Pdata_0, Core.Float64(1));  # 使用 push! 函數在數組末尾追加推入新元素;
        Pdata_0 = [
            Base.findmin(trainYdataMean)[1] * 0.9,
            Statistics.mean(request_data_Dict["trainXdata"]),
            (1 - Base.findmin(trainYdataMean)[1] / Base.findmax(trainYdataMean)[1]) / (1 - Base.findmin(request_data_Dict["trainXdata"])[1] / Base.findmax(request_data_Dict["trainXdata"])[1]),
            Base.findmax(trainYdataMean)[1] * 1.1
            # Core.Float64(1)
        ];
        if Base.haskey(request_data_Dict, "Pdata_0")
            if Base.length(request_data_Dict["Pdata_0"]) > 0
                # Pdata_0 = request_data_Dict["Pdata_0"];
                Pdata_0 = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pdata_0"])
                    Base.push!(Pdata_0, Core.Float64(request_data_Dict["Pdata_0"][i]));
                end
            end
        end
        # println(Pdata_0);

        # Plower = Core.Array{Core.Float64, 1}();
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Plower = [
            -Inf,
            -Inf,
            -Inf,
            -Inf
            # -Inf
        ];
        if Base.haskey(request_data_Dict, "Plower")
            if Base.length(request_data_Dict["Plower"]) > 0
                # Plower = request_data_Dict["Plower"];
                Plower = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Plower"])
                    if Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "+Base.Inf" || request_data_Dict["Plower"][i] === "+Inf" || request_data_Dict["Plower"][i] === "+inf" || request_data_Dict["Plower"][i] === "+Infinity" || request_data_Dict["Plower"][i] === "+infinity" || request_data_Dict["Plower"][i] === "Base.Inf" || request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "inf" || request_data_Dict["Plower"][i] === "Infinity" || request_data_Dict["Plower"][i] === "infinity")
                        Base.push!(Plower, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "-Base.Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "-inf" || request_data_Dict["Plower"][i] === "-Infinity" || request_data_Dict["Plower"][i] === "-infinity")
                        Base.push!(Plower, -Base.Inf);
                    else
                        Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    end
                    # if request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Plower"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Plower_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Plower, Plower_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Plower, err);
                    #     end
                    # else
                    #     Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    # end
                end
            end
        end
        # println(Plower);

        # Pupper = Core.Array{Core.Float64, 1}();
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Pupper = [
            +Inf,
            +Inf,
            +Inf,
            +Inf
            # +Inf
        ];
        if Base.haskey(request_data_Dict, "Pupper")
            if Base.length(request_data_Dict["Pupper"]) > 0
                # Pupper = request_data_Dict["Pupper"];
                Pupper = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pupper"])
                    if Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "+Base.Inf" || request_data_Dict["Pupper"][i] === "+Inf" || request_data_Dict["Pupper"][i] === "+inf" || request_data_Dict["Pupper"][i] === "+Infinity" || request_data_Dict["Pupper"][i] === "+infinity" || request_data_Dict["Pupper"][i] === "Base.Inf" || request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "inf" || request_data_Dict["Pupper"][i] === "Infinity" || request_data_Dict["Pupper"][i] === "infinity")
                        Base.push!(Pupper, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "-Base.Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "-inf" || request_data_Dict["Pupper"][i] === "-Infinity" || request_data_Dict["Pupper"][i] === "-infinity")
                        Base.push!(Pupper, -Base.Inf);
                    else
                        Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    end
                    # if request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Pupper"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Pupper_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Pupper, Pupper_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Pupper, err);
                    #     end
                    # else
                    #     Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    # end
                end
            end
        end
        # println(Pupper);

        weight = Core.Array{Core.Float64, 1}();
        # target = Core.Int64(2);  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i = 1:Base.length(trainYdataMean)
        #     wei = Base.exp((trainYdataMean[i] / trainYdataMean[target] - 1)^2 / ((-2) * af^2));
        #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        if Base.haskey(request_data_Dict, "weight")
            if Base.length(request_data_Dict["weight"]) > 0
                # weight = request_data_Dict["weight"];
                weight = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["weight"])
                    Base.push!(weight, Core.Float64(request_data_Dict["weight"][i]));
                end
            end
        end
        # println(weight);

        # 函數使用示例;
        # Xdata = [
        #     Core.Float64(0.0001),
        #     Core.Float64(1.0),
        #     Core.Float64(2.0),
        #     Core.Float64(3.0),
        #     Core.Float64(4.0),
        #     Core.Float64(5.0),
        #     Core.Float64(6.0),
        #     Core.Float64(7.0),
        #     Core.Float64(8.0),
        #     Core.Float64(9.0),
        #     Core.Float64(10.0)
        # ];  # 自變量 x 的實測數據;
        # Ydata = [
        #     [Core.Float64(1000.0), Core.Float64(2000.0), Core.Float64(3000.0)],
        #     [Core.Float64(2000.0), Core.Float64(3000.0), Core.Float64(4000.0)],
        #     [Core.Float64(3000.0), Core.Float64(4000.0), Core.Float64(5000.0)],
        #     [Core.Float64(4000.0), Core.Float64(5000.0), Core.Float64(6000.0)],
        #     [Core.Float64(5000.0), Core.Float64(6000.0), Core.Float64(7000.0)],
        #     [Core.Float64(6000.0), Core.Float64(7000.0), Core.Float64(8000.0)],
        #     [Core.Float64(7000.0), Core.Float64(8000.0), Core.Float64(9000.0)],
        #     [Core.Float64(8000.0), Core.Float64(9000.0), Core.Float64(10000.0)],
        #     [Core.Float64(9000.0), Core.Float64(10000.0), Core.Float64(11000.0)],
        #     [Core.Float64(10000.0), Core.Float64(11000.0), Core.Float64(12000.0)],
        #     [Core.Float64(11000.0), Core.Float64(12000.0), Core.Float64(13000.0)]
        # ];  # 應變量 y 的實測數據;
        # # 求 Ydata 均值向量;
        # YdataMean = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     yMean = Core.Float64(Statistics.mean(Ydata[i]));
        #     Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # # 求 Ydata 標準差向量;
        # YdataSTD = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     ySTD = Core.Float64(Statistics.std(Ydata[i]));
        #     Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata[begin+1:end-1], "Ydata" => Ydata[begin+1:end-1]);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # # testing_data = training_data;

        # Pdata_0 = [
        #     Base.findmin(YdataMean)[1] * 0.9,
        #     Statistics.mean(Xdata),
        #     (1 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]),
        #     Base.findmax(YdataMean)[1] * 1.1
        #     # Core.Float64(1)
        # ];

        # Plower = [
        #     -Inf,
        #     -Inf,
        #     -Inf,
        #     -Inf
        #     # -Inf
        # ];
        # Pupper = [
        #     +Inf,
        #     +Inf,
        #     +Inf,
        #     +Inf
        #     # +Inf
        # ];

        # weight = Core.Array{Core.Float64, 1}();
        # target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i = 1:Base.length(YdataMean)
        #     wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
        #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end

        # result = LC5PFit(
        #     training_data;
        #     # Xdata,
        #     # Ydata;
        #     testing_data = testing_data,
        #     Pdata_0 = Pdata_0,
        #     weight = weight,
        #     Plower = Plower,
        #     Pupper = Pupper
        # );
        # println(result["Coefficient"]);
        # println(result["testData"]);
        # # Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]);
        # # Gadfly.title(Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]), "4-parameter logistic model weighted least square method curve fit");
        # Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"]));
        # Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"])), "4-parameter logistic model weighted least square method curve fit");
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Curvefit.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Curvefit.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Curvefit.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Curve-fit-image"]
        # # );
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Residual.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Residual.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Residual.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Residual-image"]
        # # );
        # # [Base.string(result["Coefficient"][1]), Base.string(result["Coefficient"][2]), Base.string(result["Coefficient"][3]), Base.string(result["Coefficient"][4])]
        # # Base.write(Base.stdout, Base.string(result["Coefficient"][1]) * "\n" * Base.string(result["Coefficient"][2]) * "\n" * Base.string(result["Coefficient"][3]) * "\n" * Base.string(result["Coefficient"][4]) * "\n");

        # 調用自定義函數 LC5PFit() 擬合 5PLC 曲綫;
        response_body_Dict = LC5PFit(
            training_data;
            # Xdata,
            # Ydata;
            testing_data = testing_data,
            Pdata_0 = Pdata_0,
            weight = weight,
            Plower = Plower,
            Pupper = Pupper
        );
        # println(response_body_Dict);

        # 刪除 JSON 對象中包含的圖片元素;
        if Base.haskey(response_body_Dict, "Curve-fit-image")
            Base.delete!(response_body_Dict, "Curve-fit-image");
        end
        if Base.haskey(response_body_Dict, "Residual-image")
            Base.delete!(response_body_Dict, "Residual-image");
        end

        # 向字典中添加元素;
        response_body_Dict["request_Url"] = Base.string(request_Url);  # Base.Dict("Target" => Base.string(request_Url));
        # response_body_Dict["request_Path"] = Base.string(request_Path);  # Base.Dict("request_Path" => Base.string(request_Path));
        # response_body_Dict["request_Url_Query_String"] = Base.string(request_Url_Query_String);  # Base.Dict("request_Url_Query_String" => Base.string(request_Url_Query_String));
        # response_body_Dict["request_POST"] = request_data_Dict;  # Base.Dict("request_POST" => request_data_Dict);
        # response_body_Dict["request_POST"] = Base.string(request_POST_String);  # Base.Dict("request_POST" => Base.string(request_POST_String));
        response_body_Dict["request_Authorization"] = Base.string(request_Authorization);  # Base.Dict("request_Authorization" => Base.string(request_Authorization));
        response_body_Dict["request_Cookie"] = Base.string(request_Cookie);  # Base.Dict("request_Cookie" => Base.string(request_Cookie));
        # response_body_Dict["request_Nikename"] = Base.string(request_Nikename);  # Base.Dict("request_Nikename" => Base.string(request_Nikename));
        # response_body_Dict["request_Password"] = Base.string(request_Cookie);  # Base.Dict("request_Password" => Base.string(request_Password));
        response_body_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("request_POST" => Base.string(request_POST_String), "time" => string(return_file_creat_time));
        # response_body_Dict["Server_Authorization"] = Base.string(key);  # Base.Dict("Server_Authorization" => Base.string(key));
        response_body_Dict["Server_say"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        response_body_Dict["error"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        # println(response_body_Dict);

        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        response_body_String = JSONstring(response_body_Dict);  # 使用自定義函數 JSONstring() 將函數返回值的 Julia 字典（Dict）對象轉換為 JSON 字符串類型;
        # println(response_body_String);

        # response_body_Dict = Base.Dict{Core.String, Core.Any}(
        #     "Coefficient" => [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation" => [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%" => [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%" => [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit" => [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower" => [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper" => [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual" => [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData" => Base.Dict{Core.String, Core.Any}(
        #         "Ydata" => [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals" => [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower" => [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper" => [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata" => [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit" => [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower" => [],
        #         "test-Yfit-Uncertainty-Upper" => [],
        #         "test-Residual" => [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     ),
        #     "request_Url" => "/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit",
        #     "request_Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        #     "request_Cookie" => "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk",
        #     "time" => "2024-02-03 17:59:58.239794",
        #     "Server_say" => "",
        #     "error" => ""
        # );
        # response_body_String = JSONstring(response_body_Dict);

        return response_body_String;

    elseif request_Path === "/Interpolation"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1

        # 將客戶端請求 url 中的查詢字符串值解析為 Julia 字典類型;
        # request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
        if Base.isa(request_Url_Query_String, Core.String) && request_Url_Query_String !== ""
            if Base.occursin('&', request_Url_Query_String)
                # url_Query_Array = Core.Array{Core.Any, 1}();  # 聲明一個任意類型的空1維數組，可以使用 Base.push! 函數在數組末尾追加推入新元素;
                # url_Query_Array = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
                # 函數 Base.split(request_Url_Query_String, '&') 表示用等號字符'&'分割字符串為數組;
                for XXX in Base.split(request_Url_Query_String, '&')
                    temp = Base.strip(XXX);  # Base.strip(str) 去除字符串首尾兩端的空格;
                    temp = Base.convert(Core.String, temp);  # 使用 Base.convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                    # temp = Base.string(temp);
                    if Base.isa(temp, Core.String) && Base.occursin('=', temp)
                        tempKey = Base.split(temp, '=')[1];
                        tempKey = Base.strip(tempKey);
                        tempKey = Base.convert(Core.String, tempKey);
                        tempKey = Base.string(tempKey);
                        # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        tempValue = Base.split(temp, '=')[2];
                        tempValue = Base.strip(tempValue);
                        tempValue = Base.convert(Core.String, tempValue);
                        tempValue = Base.string(tempValue);
                        # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                        # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                        # # Base64.base64decode("base64_Str");  # 解碼;
                        request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                    else
                        request_Url_Query_Dict[Base.string(temp)] = Base.string("");
                    end
                end
            else
                if Base.isa(request_Url_Query_String, Core.String) && Base.occursin('=', request_Url_Query_String)
                    tempKey = Base.split(request_Url_Query_String, '=')[1];
                    tempKey = Base.strip(tempKey);
                    tempKey = Base.convert(Core.String, tempKey);
                    tempKey = Base.string(tempKey);
                    # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    tempValue = Base.split(request_Url_Query_String, '=')[2];
                    tempValue = Base.strip(tempValue);
                    tempValue = Base.convert(Core.String, tempValue);
                    tempValue = Base.string(tempValue);
                    # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
                    # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
                    # # Base64.base64decode("base64_Str");  # 解碼;
                    request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
                else
                    request_Url_Query_Dict[Base.string(request_Url_Query_String)] = Base.string("");
                end
            end
        end
        # println(request_Url_Query_Dict);

        # # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # # println(request_POST_String);
        # if request_POST_String === ""
        #     println("Request post string empty { " * request_POST_String * " }.");
        #     response_body_Dict["Server_say"] = "上傳參數錯誤，請求 post 數據字符串 request POST String = { " * Base.string(request_POST_String) * " } 爲空.";
        #     response_body_Dict["error"] = "Request post string = { " * Base.string(request_POST_String) * " } empty.";
        #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_body_String = JSONstring(response_body_Dict);
        #     # println(response_body_String);
        #     return response_body_String;
        # end

        # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        # request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
        if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            request_data_Dict = JSONparse(request_POST_String);  # 使用自定義函數 JSONparse() 將請求 Post 字符串解析為 Julia 字典（Dict）對象類型;
        end
        # if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
        #     if Base.haskey(request_data_Dict, "trainXdata")
        #         if (Base.typeof(request_data_Dict["trainXdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"])) > Core.Int64(0)
        #             for i = 1:Base.length(request_data_Dict["trainXdata"])
        #                 if (Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"][i])) > Core.Int64(0)
        #                     for j = 1:Base.length(request_data_Dict["trainXdata"][i])
        #                         request_data_Dict["trainXdata"][i][j] = Core.Float64(request_data_Dict["trainXdata"][i][j]);
        #                     end
        #                 end
        #                 if Base.isa(request_data_Dict["trainXdata"][i], Core.String) || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Int64
        #                     request_data_Dict["trainXdata"][i] = Core.Float64(request_data_Dict["trainXdata"][i]);
        #                 end
        #             end
        #         end
        #     end
        #     if Base.haskey(request_data_Dict, "trainYdata")
        #         if (Base.typeof(request_data_Dict["trainYdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"])) > Core.Int64(0)
        #             for i = 1:Base.length(request_data_Dict["trainYdata"])
        #                 if (Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"][i])) > Core.Int64(0)
        #                     for j = 1:Base.length(request_data_Dict["trainYdata"][i])
        #                         request_data_Dict["trainYdata"][i][j] = Core.Float64(request_data_Dict["trainYdata"][i][j]);
        #                     end
        #                 end
        #                 if Base.isa(request_data_Dict["trainYdata"][i], Core.String) || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Int64
        #                     request_data_Dict["trainYdata"][i] = Core.Float64(request_data_Dict["trainYdata"][i]);
        #                 end
        #             end
        #         end
        #     end
        # end
        # println(request_data_Dict);
        # request_data_Dict = Base.Dict{Core.String, Core.Any}(
        #     "trainXdata" => [
        #         0.00001,  # Core.Float64(0.00001),
        #         1,  # Core.Float64(1),
        #         2,  # Core.Float64(2),
        #         3,  # Core.Float64(3),
        #         4,  # Core.Float64(4),
        #         5,  # Core.Float64(5),
        #         6,  # Core.Float64(6),
        #         7,  # Core.Float64(7),
        #         8,  # Core.Float64(8),
        #         9,  # Core.Float64(9),
        #         10  # Core.Float64(10)
        #     ],
        #     "trainYdata_1" => [
        #         100,  # Core.Float64(100),
        #         200,  # Core.Float64(200),
        #         300,  # Core.Float64(300),
        #         400,  # Core.Float64(400),
        #         500,  # Core.Float64(500),
        #         600,  # Core.Float64(600),
        #         700,  # Core.Float64(700),
        #         800,  # Core.Float64(800),
        #         900,  # Core.Float64(900),
        #         1000,  # Core.Float64(1000),
        #         1100  # Core.Float64(1100)
        #     ],
        #     "trainYdata_2" => [
        #         98,  # Core.Float64(98),
        #         198,  # Core.Float64(198),
        #         298,  # Core.Float64(298),
        #         398,  # Core.Float64(398),
        #         498,  # Core.Float64(498),
        #         598,  # Core.Float64(598),
        #         698,  # Core.Float64(698),
        #         798,  # Core.Float64(798),
        #         898,  # Core.Float64(898),
        #         998,  # Core.Float64(998),
        #         1098  # Core.Float64(1098)
        #     ],
        #     "trainYdata_3" => [
        #         102,  # Core.Float64(102),
        #         202,  # Core.Float64(202),
        #         302,  # Core.Float64(302),
        #         402,  # Core.Float64(402),
        #         502,  # Core.Float64(502),
        #         602,  # Core.Float64(602),
        #         702,  # Core.Float64(702),
        #         802,  # Core.Float64(802),
        #         902,  # Core.Float64(902),
        #         1002,  # Core.Float64(1002),
        #         1102  # Core.Float64(1102)
        #     ],
        #     "weight" => [
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5,  # Core.Float64(0.5),
        #         0.5  # Core.Float64(0.5)
        #     ],
        #     "Pdata_0" => [
        #         90,  # Core.Float64(90),
        #         4,  # Core.Float64(4),
        #         1,  # Core.Float64(1),
        #         1210  # Core.Float64(1210)
        #     ],
        #     "Plower" => [
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf",  # -Base.Inf,
        #         "-inf"  # -Base.Inf
        #     ],
        #     "Pupper" => [
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf",  # +Base.Inf,
        #         "+inf"  # +Base.Inf
        #     ],
        #     "testYdata_1" => [
        #         150,  # Core.Float64(150),
        #         200,  # Core.Float64(200),
        #         250,  # Core.Float64(250),
        #         350,  # Core.Float64(350),
        #         450,  # Core.Float64(450),
        #         550,  # Core.Float64(550),
        #         650,  # Core.Float64(650),
        #         750,  # Core.Float64(750),
        #         850,  # Core.Float64(850),
        #         950,  # Core.Float64(950),
        #         1050  # Core.Float64(1050)
        #     ],
        #     "testYdata_2" => [
        #         148,  # Core.Float64(148),
        #         198,  # Core.Float64(198),
        #         248,  # Core.Float64(248),
        #         348,  # Core.Float64(348),
        #         448,  # Core.Float64(448),
        #         548,  # Core.Float64(548),
        #         648,  # Core.Float64(648),
        #         748,  # Core.Float64(748),
        #         848,  # Core.Float64(848),
        #         948,  # Core.Float64(948),
        #         1048  # Core.Float64(1048)
        #     ],
        #     "testYdata_3" => [
        #         152,  # Core.Float64(152),
        #         202,  # Core.Float64(202),
        #         252,  # Core.Float64(252),
        #         352,  # Core.Float64(352),
        #         452,  # Core.Float64(452),
        #         552,  # Core.Float64(552),
        #         652,  # Core.Float64(652),
        #         752,  # Core.Float64(752),
        #         852,  # Core.Float64(852),
        #         952,  # Core.Float64(952),
        #         1052  # Core.Float64(1052)
        #     ],
        #     "testXdata" => [
        #         0.5,  # Core.Float64(0.5),
        #         1,  # Core.Float64(1),
        #         1.5,  # Core.Float64(1.5),
        #         2.5,  # Core.Float64(2.5),
        #         3.5,  # Core.Float64(3.5),
        #         4.5,  # Core.Float64(4.5),
        #         5.5,  # Core.Float64(5.5),
        #         6.5,  # Core.Float64(6.5),
        #         7.5,  # Core.Float64(7.5),
        #         8.5,  # Core.Float64(8.5),
        #         9.5  # Core.Float64(9.5)
        #     ],
        #     "trainYdata" => [
        #         [100, 98, 102],  # [Core.Float64(100), Core.Float64(98), Core.Float64(102)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [300, 298, 302],  # [Core.Float64(300), Core.Float64(298), Core.Float64(302)],
        #         [400, 398, 402],  # [Core.Float64(400), Core.Float64(398), Core.Float64(402)],
        #         [500, 498, 502],  # [Core.Float64(500), Core.Float64(498), Core.Float64(502)],
        #         [600, 598, 602],  # [Core.Float64(600), Core.Float64(598), Core.Float64(602)],
        #         [700, 698, 702],  # [Core.Float64(700), Core.Float64(698), Core.Float64(702)],
        #         [800, 798, 802],  # [Core.Float64(800), Core.Float64(798), Core.Float64(802)],
        #         [900, 898, 902],  # [Core.Float64(900), Core.Float64(898), Core.Float64(902)],
        #         [1000, 998, 1002],  # [Core.Float64(1000), Core.Float64(998), Core.Float64(1002)],
        #         [1100, 1098, 1102]  # [Core.Float64(1100), Core.Float64(1098), Core.Float64(1102)]
        #     ],
        #     "testYdata" => [
        #         [150, 148, 152],  # [Core.Float64(150), Core.Float64(148), Core.Float64(152)],
        #         [200, 198, 202],  # [Core.Float64(200), Core.Float64(198), Core.Float64(202)],
        #         [250, 248, 252],  # [Core.Float64(250), Core.Float64(248), Core.Float64(252)],
        #         [350, 348, 352],  # [Core.Float64(350), Core.Float64(348), Core.Float64(352)],
        #         [450, 448, 452],  # [Core.Float64(450), Core.Float64(448), Core.Float64(452)],
        #         [550, 548, 552],  # [Core.Float64(550), Core.Float64(548), Core.Float64(552)],
        #         [650, 648, 652],  # [Core.Float64(650), Core.Float64(648), Core.Float64(652)],
        #         [750, 748, 752],  # [Core.Float64(750), Core.Float64(748), Core.Float64(752)],
        #         [850, 848, 852],  # [Core.Float64(850), Core.Float64(848), Core.Float64(852)],
        #         [950, 948, 952],  # [Core.Float64(950), Core.Float64(948), Core.Float64(952)],
        #         [1050, 1048, 1052]  # [Core.Float64(1050), Core.Float64(1048), Core.Float64(1052)]
        #     ]
        # );

        # 解析配置客戶端 post 請求發送的運行參數;
        # 求 Ydata 均值向量;
        trainYdataMean = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            yMean = Core.Float64(Statistics.mean(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        # 求 Ydata 標準差向量;
        trainYdataSTD = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(request_data_Dict["trainYdata"])
            ySTD = Core.Float64(Statistics.std(request_data_Dict["trainYdata"][i]));
            Base.push!(trainYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        end

        training_data = Base.Dict{Core.String, Core.Any}();
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["trainXdata"], "Ydata" => request_data_Dict["trainYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "trainXdata")
                if (Base.typeof(request_data_Dict["trainXdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainXdata"])
                        if (Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainXdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # training_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                training_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainXdata"][i])
                                    # Base.push!(training_data_Xdata_i, Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Xdata"][i][j] = Core.Float64(request_data_Dict["trainXdata"][i][j]);
                                    # Base.push!(training_data["Xdata"][i], Core.Float64(request_data_Dict["trainXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Xdata"], training_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainXdata"][i], Core.String) || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainXdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Xdata"))
                                training_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainXdata"])));
                                # training_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Xdata")
                                # Base.push!(training_data["Xdata"], Core.Float64(request_data_Dict["trainXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Xdata"][i] = Core.Float64(request_data_Dict["trainXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "trainYdata")
                if (Base.typeof(request_data_Dict["trainYdata"]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["trainYdata"])
                        if (Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["trainYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["trainYdata"][i])) > Core.Int64(0)
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # training_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                training_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["trainYdata"][i])
                                    # Base.push!(training_data_Ydata_i, Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    training_data["Ydata"][i][j] = Core.Float64(request_data_Dict["trainYdata"][i][j]);
                                    # Base.push!(training_data["Ydata"][i], Core.Float64(request_data_Dict["trainYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(training_data["Ydata"], training_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # training_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["trainYdata"][i], Core.String) || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["trainYdata"][i]) <: Core.Int64
                            if Base.isa(training_data, Base.Dict) && ( ! Base.haskey(training_data, "Ydata"))
                                training_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["trainYdata"])));
                                # training_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(training_data, Base.Dict) && Base.haskey(training_data, "Ydata")
                                # Base.push!(training_data["Ydata"], Core.Float64(request_data_Dict["trainYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                training_data["Ydata"][i] = Core.Float64(request_data_Dict["trainYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(training_data);
        trainXdata = training_data["Xdata"];

        testing_data = Base.Dict{Core.String, Core.Any}();
        # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => request_data_Dict["testXdata"], "Ydata" => request_data_Dict["testYdata"]);
        if Base.isa(request_data_Dict, Base.Dict) && Core.Int64(Base.length(request_data_Dict)) > Core.Int64(0)
            if Base.haskey(request_data_Dict, "testXdata")
                if (Base.typeof(request_data_Dict["testXdata"]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testXdata"])
                        if (Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testXdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testXdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # testing_data_Xdata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testXdata"][i])
                                    # Base.push!(testing_data_Xdata_i, Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Xdata"][i][j] = Core.Float64(request_data_Dict["testXdata"][i][j]);
                                    # Base.push!(testing_data["Xdata"][i], Core.Float64(request_data_Dict["testXdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Xdata"], testing_data_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Xdata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testXdata"][i], Core.String) || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testXdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Xdata"))
                                testing_data["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testXdata"])));
                                # testing_data["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Xdata")
                                # Base.push!(testing_data["Xdata"], Core.Float64(request_data_Dict["testXdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Xdata"][i] = Core.Float64(request_data_Dict["testXdata"][i]);
                            end
                        end
                    end
                end
            end
            if Base.haskey(request_data_Dict, "testYdata")
                if (Base.typeof(request_data_Dict["testYdata"]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"])) > Core.Int64(0)
                    for i = 1:Base.length(request_data_Dict["testYdata"])
                        if (Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Array || Base.typeof(request_data_Dict["testYdata"][i]) <: Base.Vector) && Core.Int64(Base.length(request_data_Dict["testYdata"][i])) > Core.Int64(0)
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # testing_data_Ydata_i = Core.Array{Core.Float64, 1}();
                                testing_data["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"][i])));
                                for j = 1:Base.length(request_data_Dict["testYdata"][i])
                                    # Base.push!(testing_data_Ydata_i, Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                    testing_data["Ydata"][i][j] = Core.Float64(request_data_Dict["testYdata"][i][j]);
                                    # Base.push!(testing_data["Ydata"][i], Core.Float64(request_data_Dict["testYdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                end
                                # Base.push!(testing_data["Ydata"], testing_data_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                                # testing_data_Ydata_i = Core.nothing;
                            end
                        end
                        if Base.isa(request_data_Dict["testYdata"][i], Core.String) || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Float64 || Base.typeof(request_data_Dict["testYdata"][i]) <: Core.Int64
                            if Base.isa(testing_data, Base.Dict) && ( ! Base.haskey(testing_data, "Ydata"))
                                testing_data["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(request_data_Dict["testYdata"])));
                                # testing_data["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                            end
                            if Base.isa(testing_data, Base.Dict) && Base.haskey(testing_data, "Ydata")
                                # Base.push!(testing_data["Ydata"], Core.Float64(request_data_Dict["testYdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testing_data["Ydata"][i] = Core.Float64(request_data_Dict["testYdata"][i]);
                            end
                        end
                    end
                end
            end
        end
        # println(testing_data);

        # 擬合（Fit）迭代參數起始值;
        Pdata_0_P1 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P1_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^3);
            else
                Pdata_0_P1_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^3);
            end
            Base.push!(Pdata_0_P1, Pdata_0_P1_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P1 = Core.Float64(Statistics.mean(Pdata_0_P1));
        # println(Pdata_0_P1);
        Pdata_0_P2 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P2_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^2);
            else
                Pdata_0_P2_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^2);
            end
            Base.push!(Pdata_0_P2, Pdata_0_P2_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P2 = Core.Float64(Statistics.mean(Pdata_0_P2));
        # println(Pdata_0_P2);
        Pdata_0_P3 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                Pdata_0_P3_I = Core.Float64(trainYdataMean[i] / trainXdata[i]^1);
            else
                Pdata_0_P3_I = Core.Float64(trainYdataMean[i] - trainXdata[i]^1);
            end
            Base.push!(Pdata_0_P3, Pdata_0_P3_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P3 = Core.Float64(Statistics.mean(Pdata_0_P3));
        # println(Pdata_0_P3);
        Pdata_0_P4 = Core.Array{Core.Float64, 1}();
        for i = 1:Base.length(trainYdataMean)
            if Core.Float64(trainXdata[i]) !== Core.Float64(0.0)
                # 符號 / 表示常規除法，符號 % 表示除法取餘，等價於 Base.rem() 函數，符號 ÷ 表示除法取整，符號 * 表示乘法，符號 ^ 表示冪運算，符號 + 表示加法，符號 - 表示減法;
                Pdata_0_P4_I_1 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P3 * trainXdata[i]^1)) * Core.Float64(Pdata_0_P3 * trainXdata[i]^1));
                Pdata_0_P4_I_2 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P2 * trainXdata[i]^2)) * Core.Float64(Pdata_0_P2 * trainXdata[i]^2));
                Pdata_0_P4_I_3 = Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Pdata_0_P1 * trainXdata[i]^3)) * Core.Float64(Pdata_0_P1 * trainXdata[i]^3));
                Pdata_0_P4_I = Core.Float64(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3);
            else
                Pdata_0_P4_I = Core.Float64(trainYdataMean[i] - trainXdata[i]);
            end
            Base.push!(Pdata_0_P4, Pdata_0_P4_I);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
        Pdata_0_P4 = Core.Float64(Statistics.mean(Pdata_0_P4));
        # println(Pdata_0_P4);
        # Pdata_0 = Core.Array{Core.Float64, 1}();
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])));  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])));
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])));
        # Base.push!(Pdata_0, Core.Float64(Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) for i in 1:Base.length(trainYdataMean)])));
        # # Base.push!(Pdata_0, Core.Float64(0.0));
        # Pdata_0 = [
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])),
        #     Core.Float64(Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^1) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^1)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^2) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^2)) for i in 1:Base.length(trainYdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(trainYdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(trainYdataMean[i]/trainXdata[i]^3) for i in 1:Base.length(trainYdataMean)])) * trainXdata[i]^3)) for i in 1:Base.length(trainYdataMean)]))
        #     # Core.Float64(0.0)
        # ];
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
            # Core.Float64(0.0)
        ];
        if Base.haskey(request_data_Dict, "Pdata_0")
            if Base.length(request_data_Dict["Pdata_0"]) > 0
                # Pdata_0 = request_data_Dict["Pdata_0"];
                Pdata_0 = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pdata_0"])
                    Base.push!(Pdata_0, Core.Float64(request_data_Dict["Pdata_0"][i]));
                end
            end
        end
        # println(Pdata_0);

        # Plower = Core.Array{Core.Float64, 1}();
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Plower, -Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Plower = [
            -Inf,
            -Inf,
            -Inf,
            -Inf
            # -Inf
        ];
        if Base.haskey(request_data_Dict, "Plower")
            if Base.length(request_data_Dict["Plower"]) > 0
                # Plower = request_data_Dict["Plower"];
                Plower = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Plower"])
                    if Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "+Base.Inf" || request_data_Dict["Plower"][i] === "+Inf" || request_data_Dict["Plower"][i] === "+inf" || request_data_Dict["Plower"][i] === "+Infinity" || request_data_Dict["Plower"][i] === "+infinity" || request_data_Dict["Plower"][i] === "Base.Inf" || request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "inf" || request_data_Dict["Plower"][i] === "Infinity" || request_data_Dict["Plower"][i] === "infinity")
                        Base.push!(Plower, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Plower"][i], Core.String) && (request_data_Dict["Plower"][i] === "-Base.Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "-inf" || request_data_Dict["Plower"][i] === "-Infinity" || request_data_Dict["Plower"][i] === "-infinity")
                        Base.push!(Plower, -Base.Inf);
                    else
                        Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    end
                    # if request_data_Dict["Plower"][i] === "Inf" || request_data_Dict["Plower"][i] === "-Inf" || request_data_Dict["Plower"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Plower"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Plower_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Plower, Plower_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Plower, err);
                    #     end
                    # else
                    #     Base.push!(Plower, Core.Float64(request_data_Dict["Plower"][i]));
                    # end
                end
            end
        end
        # println(Plower);

        # Pupper = Core.Array{Core.Float64, 1}();
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        # # Base.push!(Pupper, +Inf);  # 使用 push! 函數在數組末尾追加推入新元素;
        Pupper = [
            +Inf,
            +Inf,
            +Inf,
            +Inf
            # +Inf
        ];
        if Base.haskey(request_data_Dict, "Pupper")
            if Base.length(request_data_Dict["Pupper"]) > 0
                # Pupper = request_data_Dict["Pupper"];
                Pupper = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["Pupper"])
                    if Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "+Base.Inf" || request_data_Dict["Pupper"][i] === "+Inf" || request_data_Dict["Pupper"][i] === "+inf" || request_data_Dict["Pupper"][i] === "+Infinity" || request_data_Dict["Pupper"][i] === "+infinity" || request_data_Dict["Pupper"][i] === "Base.Inf" || request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "inf" || request_data_Dict["Pupper"][i] === "Infinity" || request_data_Dict["Pupper"][i] === "infinity")
                        Base.push!(Pupper, +Base.Inf);
                    elseif Base.isa(request_data_Dict["Pupper"][i], Core.String) && (request_data_Dict["Pupper"][i] === "-Base.Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "-inf" || request_data_Dict["Pupper"][i] === "-Infinity" || request_data_Dict["Pupper"][i] === "-infinity")
                        Base.push!(Pupper, -Base.Inf);
                    else
                        Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    end
                    # if request_data_Dict["Pupper"][i] === "Inf" || request_data_Dict["Pupper"][i] === "-Inf" || request_data_Dict["Pupper"][i] === "+Inf"
                    #     try
                    #         codeText = Base.Meta.parse(request_data_Dict["Pupper"][i]);  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                    #         Pupper_Value = Base.MainInclude.eval(codeText);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                    #         Base.push!(Pupper, Pupper_Value);
                    #     catch err
                    #         println(err);
                    #         Base.push!(Pupper, err);
                    #     end
                    # else
                    #     Base.push!(Pupper, Core.Float64(request_data_Dict["Pupper"][i]));
                    # end
                end
            end
        end
        # println(Pupper);

        weight = Core.Array{Core.Float64, 1}();
        # target = Core.Int64(2);  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
        # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
        # for i = 1:Base.length(trainYdataMean)
        #     wei = Base.exp((trainYdataMean[i] / trainYdataMean[target] - 1)^2 / ((-2) * af^2));
        #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        if Base.haskey(request_data_Dict, "weight")
            if Base.length(request_data_Dict["weight"]) > 0
                # weight = request_data_Dict["weight"];
                weight = Core.Array{Core.Float64, 1}();
                for i = 1:Base.length(request_data_Dict["weight"])
                    Base.push!(weight, Core.Float64(request_data_Dict["weight"][i]));
                end
            end
        end
        # println(weight);

        # 插值（Interpolation）參數預設值;
        Interpolation_Method = Base.string("BSpline(Cubic)");  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
        λ = Core.UInt8(0);  # λ::Core.UInt8 = Core.UInt8(0);  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
        k = Core.UInt8(2);  # k::Core.UInt8 = Core.UInt8(2);  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
        d = Core.UInt8(Base.length(trainYdataMean) - 1);  # d::Core.UInt8 = Core.UInt8(Base.length(trainYdataMean) - 1);  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
        h = Core.UInt8(Base.length(trainYdataMean) - 1);  # h::Core.UInt8 = Core.UInt8(Base.length(trainYdataMean) - 1);  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
        if Base.isa(request_Url_Query_Dict, Base.Dict)
            # if Base.length(request_Url_Query_Dict) > 0
            if Base.haskey(request_Url_Query_Dict, "algorithmName")
                # if Base.isa(request_Url_Query_Dict["algorithmName"], Core.String) && request_Url_Query_Dict["algorithmName"] !== ""
                # Interpolation_Method = Base.string(request_Url_Query_Dict["algorithmName"]);  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
                Interpolation_Method = Base.string(Base.convert(Core.String, request_Url_Query_Dict["algorithmName"]));
            end
            if Base.haskey(request_Url_Query_Dict, "algorithmLambda")
                # if Base.typeof(request_Url_Query_Dict["algorithmLambda"]) <: Core.Int
                # λ = Core.Int64(request_Url_Query_Dict["algorithmLambda"]);  # λ::Core.UInt8 = Core.UInt8(0),  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
                # λ = Core.Int64(Base.round(Core.Float64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmLambda"])), digits = 0));
                λ = Core.Int64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmLambda"]));
                λ = Core.UInt8(λ);
            end
            if Base.haskey(request_Url_Query_Dict, "algorithmKei")
                # if Base.typeof(request_Url_Query_Dict["algorithmKei"]) <: Core.Int
                # k = Core.Int64(request_Url_Query_Dict["algorithmKei"]);  # k::Core.UInt8 = Core.UInt8(2),  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
                # k = Core.Int64(Base.round(Core.Float64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmKei"])), digits = 0));
                k = Core.Int64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmKei"]));
                k = Core.UInt8(k);
            end
            if Base.haskey(request_Url_Query_Dict, "algorithmDi")
                # if Base.typeof(request_Url_Query_Dict["algorithmDi"]) <: Core.Int
                # d = Core.Int64(request_Url_Query_Dict["algorithmDi"]);  # d::Core.UInt8 = Core.UInt8(Base.length(trainYdataMean) - 1),  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
                # d = Core.Int64(Base.round(Core.Float64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmDi"])), digits = 0));
                d = Core.Int64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmDi"]));
                d = Core.UInt8(d);
            end
            if Base.haskey(request_Url_Query_Dict, "algorithmEith")
                # if Base.typeof(request_Url_Query_Dict["algorithmEith"]) <: Core.Int
                # h = Core.Int64(request_Url_Query_Dict["algorithmEith"]);  # h::Core.UInt8 = Core.UInt8(Base.length(trainYdataMean) - 1)  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
                # h = Core.Int64(Base.round(Core.Float64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmEith"])), digits = 0));
                h = Core.Int64(Base.parse(Core.Float64, request_Url_Query_Dict["algorithmEith"]));
                h = Core.UInt8(h);
            end
        end
        # println(Interpolation_Method);
        # println(λ);
        # println(k);
        # println(d);
        # println(h);
        # println(Base.typeof(Interpolation_Method));
        # println(Base.typeof(λ));
        # println(Base.typeof(k));
        # println(Base.typeof(d));
        # println(Base.typeof(h));

        # 函數使用示例;
        # Xdata = [
        #     Core.Float64(0.0001),
        #     Core.Float64(1.0),
        #     Core.Float64(2.0),
        #     Core.Float64(3.0),
        #     Core.Float64(4.0),
        #     Core.Float64(5.0),
        #     Core.Float64(6.0),
        #     Core.Float64(7.0),
        #     Core.Float64(8.0),
        #     Core.Float64(9.0),
        #     Core.Float64(10.0)
        # ];  # 自變量 x 的實測數據;
        # # 應變量 y 的實測數據;
        # Ydata = [
        #     [Core.Float64(1000.0), Core.Float64(2000.0), Core.Float64(3000.0)],
        #     [Core.Float64(2000.0), Core.Float64(3000.0), Core.Float64(4000.0)],
        #     [Core.Float64(3000.0), Core.Float64(4000.0), Core.Float64(5000.0)],
        #     [Core.Float64(4000.0), Core.Float64(5000.0), Core.Float64(6000.0)],
        #     [Core.Float64(5000.0), Core.Float64(6000.0), Core.Float64(7000.0)],
        #     [Core.Float64(6000.0), Core.Float64(7000.0), Core.Float64(8000.0)],
        #     [Core.Float64(7000.0), Core.Float64(8000.0), Core.Float64(9000.0)],
        #     [Core.Float64(8000.0), Core.Float64(9000.0), Core.Float64(10000.0)],
        #     [Core.Float64(9000.0), Core.Float64(10000.0), Core.Float64(11000.0)],
        #     [Core.Float64(10000.0), Core.Float64(11000.0), Core.Float64(12000.0)],
        #     [Core.Float64(11000.0), Core.Float64(12000.0), Core.Float64(13000.0)]
        # ];  # 應變量 y 的實測數據;
        # # Ydata = [
        # #     [Core.Float64(1000.0)],
        # #     [Core.Float64(2000.0)],
        # #     [Core.Float64(3000.0)],
        # #     [Core.Float64(4000.0)],
        # #     [Core.Float64(5000.0)],
        # #     [Core.Float64(6000.0)],
        # #     [Core.Float64(7000.0)],
        # #     [Core.Float64(8000.0)],
        # #     [Core.Float64(9000.0)],
        # #     [Core.Float64(10000.0)],
        # #     [Core.Float64(11000.0)]
        # # ];  # 應變量 y 的實測數據;
        # # 求 Ydata 均值向量;
        # YdataMean = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     yMean = Core.Float64(Statistics.mean(Ydata[i]));
        #     Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # # 求 Ydata 標準差向量;
        # YdataSTD = Core.Array{Core.Float64, 1}();
        # for i = 1:Base.length(Ydata)
        #     ySTD = Core.Float64(Statistics.std(Ydata[i]));
        #     Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
        # end
        # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => YdataMean);

        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => YdataMean);
        # testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => YdataMean);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => YdataMean[begin+1:end-1]);
        # # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata[begin+1:end-1]);
        # # testing_data = training_data;

        # Interpolation_Method = Base.string("BSpline(Cubic)");  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
        # λ = Core.UInt8(0);  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
        # k = Core.UInt8(2);  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
        # d = Core.UInt8(Base.length(training_data["Ydata"]) - 1);  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
        # h = Core.UInt8(Base.length(training_data["Ydata"]) - 1);  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;

        # result = MathInterpolation(
        #     training_data;
        #     # Xdata,
        #     # Ydata;
        #     testing_data = testing_data,
        #     Interpolation_Method = Interpolation_Method,  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
        #     λ = λ,  # Core.UInt8(0);  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
        #     k = k,  # Core.UInt8(2);  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
        #     d = d,  # Core.UInt8(Base.length(training_data["Ydata"]) - 1);  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
        #     h = h  # Core.UInt8(Base.length(training_data["Ydata"]) - 1);  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
        # );
        # println(result["testData"]);
        # if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0
        #     # Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]);
        #     # Gadfly.title(Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]), Base.string("Interpolation : " * Interpolation_Method * " curve"));
        #     Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"]));
        #     Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"])), Base.string("Interpolation : " * Interpolation_Method * " curve"));
        # elseif (!Base.haskey(testing_data, "Xdata") || Base.length(testing_data["Xdata"]) <= 0) && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0
        #     Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]));
        #     Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"])), Base.string("Interpolation : " * Interpolation_Method * " curve"));
        # elseif Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && (!Base.haskey(testing_data, "Ydata") || Base.length(testing_data["Ydata"]) <= 0)
        #     Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]));
        #     Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"])), Base.string("Interpolation : " * Interpolation_Method * " curve"));
        # else
        # end
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Curvefit.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Curvefit.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Curvefit.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Curve-fit-image"]
        # # );
        # # Gadfly.draw(
        # #     Gadfly.SVG(
        # #         "./Residual.svg",
        # #         21cm,
        # #         21cm
        # #     ),  # 保存爲 .svg 格式圖片;
        # #     # Gadfly.PDF(
        # #     #     "Residual.pdf",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .pdf 格式圖片;
        # #     # Gadfly.PNG(
        # #     #     "Residual.png",
        # #     #     21cm,
        # #     #     21cm
        # #     # ),  # 保存爲 .png 格式圖片;
        # #     result["Residual-image"]
        # # );
        # # [Base.string(result["Coefficient"][1]), Base.string(result["Coefficient"][2]), Base.string(result["Coefficient"][3]), Base.string(result["Coefficient"][4])]
        # # Base.write(Base.stdout, Base.string(result["Coefficient"][1]) * "\n" * Base.string(result["Coefficient"][2]) * "\n" * Base.string(result["Coefficient"][3]) * "\n" * Base.string(result["Coefficient"][4]) * "\n");

        # 調用自定義函數 MathInterpolation() 插值（Interpolation）曲綫;
        response_body_Dict = MathInterpolation(
            training_data;
            # Xdata,
            # Ydata;
            testing_data = testing_data,
            Interpolation_Method = Interpolation_Method,  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
            λ = λ,  # λ::Core.UInt8 = Core.UInt8(0),  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
            k = k,  # k::Core.UInt8 = Core.UInt8(2),  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
            d = d,  # d::Core.UInt8 = Core.UInt8(Base.length(training_data["Ydata"]) - 1),  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
            h = h  # h::Core.UInt8 = Core.UInt8(Base.length(training_data["Ydata"]) - 1)  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
        );
        # println(response_body_Dict);

        # 刪除 JSON 對象中包含的圖片元素;
        if Base.haskey(response_body_Dict, "Curve-fit-image")
            Base.delete!(response_body_Dict, "Curve-fit-image");
        end
        if Base.haskey(response_body_Dict, "Residual-image")
            Base.delete!(response_body_Dict, "Residual-image");
        end

        # 向字典中添加元素;
        response_body_Dict["request_Url"] = Base.string(request_Url);  # Base.Dict("Target" => Base.string(request_Url));
        # response_body_Dict["request_Path"] = Base.string(request_Path);  # Base.Dict("request_Path" => Base.string(request_Path));
        # response_body_Dict["request_Url_Query_String"] = Base.string(request_Url_Query_String);  # Base.Dict("request_Url_Query_String" => Base.string(request_Url_Query_String));
        # response_body_Dict["request_POST"] = request_data_Dict;  # Base.Dict("request_POST" => request_data_Dict);
        # response_body_Dict["request_POST"] = Base.string(request_POST_String);  # Base.Dict("request_POST" => Base.string(request_POST_String));
        response_body_Dict["request_Authorization"] = Base.string(request_Authorization);  # Base.Dict("request_Authorization" => Base.string(request_Authorization));
        response_body_Dict["request_Cookie"] = Base.string(request_Cookie);  # Base.Dict("request_Cookie" => Base.string(request_Cookie));
        # response_body_Dict["request_Nikename"] = Base.string(request_Nikename);  # Base.Dict("request_Nikename" => Base.string(request_Nikename));
        # response_body_Dict["request_Password"] = Base.string(request_Cookie);  # Base.Dict("request_Password" => Base.string(request_Password));
        response_body_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("request_POST" => Base.string(request_POST_String), "time" => string(return_file_creat_time));
        # response_body_Dict["Server_Authorization"] = Base.string(key);  # Base.Dict("Server_Authorization" => Base.string(key));
        response_body_Dict["Server_say"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        response_body_Dict["error"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
        # println(response_body_Dict);

        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        response_body_String = JSONstring(response_body_Dict);  # 使用自定義函數 JSONstring() 將函數返回值的 Julia 字典（Dict）對象轉換為 JSON 字符串類型;
        # println(response_body_String);

        # response_body_Dict = Base.Dict{Core.String, Core.Any}(
        #     "Coefficient" => [
        #         100.007982422761,
        #         42148.4577551448,
        #         1.0001564001486,
        #         4221377.92224082
        #     ],
        #     "Coefficient-StandardDeviation" => [
        #         0.00781790123184812,
        #         2104.76673086505,
        #         0.0000237490808220821,
        #         210359.023599377
        #     ],
        #     "Coefficient-Confidence-Lower-95%" => [
        #         99.9908250045862,
        #         37529.2688077105,
        #         1.0001042796499,
        #         3759717.22485611
        #     ],
        #     "Coefficient-Confidence-Upper-95%" => [
        #         100.025139840936,
        #         46767.6467025791,
        #         1.00020852064729,
        #         4683038.61962554
        #     ],
        #     "Yfit" => [
        #         100.008980483748,
        #         199.99155580718,
        #         299.992070696316,
        #         399.99603100866,
        #         500.000567344017,
        #         600.00431688223,
        #         700.006476967595,
        #         800.006517272442,
        #         900.004060927778,
        #         999.998826196417,
        #         1099.99059444852
        #     ],
        #     "Yfit-Uncertainty-Lower" => [
        #         99.0089499294379,
        #         198.991136273453,
        #         298.990136898385,
        #         398.991624763274,
        #         498.99282487668,
        #         598.992447662226,
        #         698.989753032473,
        #         798.984266632803,
        #         898.975662941844,
        #         998.963708008532,
        #         1098.94822805642
        #     ],
        #     "Yfit-Uncertainty-Upper" => [
        #         101.00901103813,
        #         200.991951293373,
        #         300.993902825086,
        #         401.000210884195,
        #         501.007916682505,
        #         601.015588680788,
        #         701.022365894672,
        #         801.027666045591,
        #         901.031064750697,
        #         1001.0322361364,
        #         1101.0309201882
        #     ],
        #     "Residual" => [
        #         0.00898048374801874,
        #         -0.00844419281929731,
        #         -0.00792930368334055,
        #         -0.00396899133920669,
        #         0.000567344017326831,
        #         0.00431688223034143,
        #         0.00647696759551763,
        #         0.00651727244257926,
        #         0.00406092777848243,
        #         -0.00117380358278751,
        #         -0.00940555147826671
        #     ],
        #     "testData" => Base.Dict{Core.String, Core.Any}(
        #         "Ydata" => [
        #             [150, 148, 152],
        #             [200, 198, 202],
        #             [250, 248, 252],
        #             [350, 348, 352],
        #             [450, 448, 452],
        #             [550, 548, 552],
        #             [650, 648, 652],
        #             [750, 748, 752],
        #             [850, 848, 852],
        #             [950, 948, 952],
        #             [1050, 1048, 1052]
        #         ],
        #         "test-Xvals" => [
        #             0.500050586546119,
        #             1.00008444458554,
        #             1.50008923026377,
        #             2.50006143908055,
        #             3.50001668919562,
        #             4.49997400999207,
        #             5.49994366811569,
        #             6.49993211621922,
        #             7.49994379302719,
        #             8.49998194168741,
        #             9.50004903674755
        #         ],
        #         "test-Xvals-Uncertainty-Lower" => [
        #             0.499936310423273,
        #             0.999794808816128,
        #             1.49963107921017,
        #             2.49927920023971,
        #             3.49892261926065,
        #             4.49857747071072,
        #             5.4982524599721,
        #             6.4979530588239,
        #             7.49768303155859,
        #             8.49744512880161,
        #             9.49724144950174
        #         ],
        #         "test-Xvals-Uncertainty-Upper" => [
        #             0.500160692642957,
        #             1.00036584601127,
        #             1.50053513648402,
        #             2.5008235803856,
        #             3.50108303720897,
        #             4.50133543331854,
        #             5.50159259771137,
        #             6.50186196458511,
        #             7.50214864756277,
        #             8.50245638268284,
        #             9.50278802032924
        #         ],
        #         "Xdata" => [
        #             0.5,
        #             1,
        #             1.5,
        #             2.5,
        #             3.5,
        #             4.5,
        #             5.5,
        #             6.5,
        #             7.5,
        #             8.5,
        #             9.5
        #         ],
        #         "test-Yfit" => [
        #             149.99283432168886,
        #             199.98780598165467,
        #             249.98704946506768,
        #             349.9910371559672,
        #             449.9975369446911,
        #             550.0037557953037,
        #             650.0081868763082,
        #             750.0098833059892,
        #             850.0081939375959,
        #             950.002643218264,
        #             1049.9928684998304
        #         ],
        #         "test-Yfit-Uncertainty-Lower" => [],
        #         "test-Yfit-Uncertainty-Upper" => [],
        #         "test-Residual" => [
        #             [0.000050586546119],
        #             [0.00008444458554],
        #             [0.00008923026377],
        #             [0.00006143908055],
        #             [0.00001668919562],
        #             [-0.00002599000793],
        #             [-0.0000563318843],
        #             [-0.00006788378077],
        #             [-0.0000562069728],
        #             [-0.00001805831259],
        #             [0.00004903674755]
        #         ]
        #     ),
        #     "request_Url" => "/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1",
        #     "request_Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
        #     "request_Cookie" => "session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk",
        #     "time" => "2024-02-03 17:59:58.239794",
        #     "Server_say" => "",
        #     "error" => ""
        # );
        # response_body_String = JSONstring(response_body_Dict);

        return response_body_String;

    else

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        # web_path_index_Html::Core.String = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "administrator.html"));
        web_path_index_Html = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "administrator.html"));
        file_data = "";

        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

            # # 檢查待讀取文檔的操作權限;
            # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
            #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
            #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            #     try
            #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
            #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
            #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
            #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

            #         # 八進制值    說明
            #         # 0o400      所有者可讀
            #         # 0o200      所有者可寫
            #         # 0o100      所有者可執行或搜索
            #         # 0o40       群組可讀
            #         # 0o20       群組可寫
            #         # 0o10       群組可執行或搜索
            #         # 0o4        其他人可讀
            #         # 0o2        其他人可寫
            #         # 0o1        其他人可執行或搜索
            #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
            #         # 數字	說明
            #         # 7	可讀、可寫、可執行
            #         # 6	可讀、可寫
            #         # 5	可讀、可執行
            #         # 4	唯讀
            #         # 3	可寫、可執行
            #         # 2	只寫
            #         # 1	只可執行
            #         # 0	沒有許可權
            #         # 例如，八進制值 0o765 表示：
            #         # 1) 、所有者可以讀取、寫入和執行該文檔；
            #         # 2) 、群組可以讀和寫入該文檔；
            #         # 3) 、其他人可以讀取和執行該文檔；
            #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
            #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            #     catch err
            #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
            #         println(err);
            #         # println(err.msg);
            #         # println(Base.typeof(err));

            #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         response_body_Dict["error"] = Base.string(err);

            #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_body_String = JSONstring(response_body_Dict);
            #         # println(response_body_String);
            #         # Base.exit(0);
            #         return response_body_String;
            #     end
            # end

            # 同步讀取硬盤文檔，返回字符串;
            if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

                # # 檢查待讀取文檔的操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 獲取待讀取文檔的大小，單位：字節（Bytes），1 字節（Bytes） = 8 比特（bits），1 比特（bits）即 1 個二進制位，一個英文字母占用 1 個字節，一個漢字符占用 2 個字節;
                # file_size = Core.Int64(Core.Int64(Base.stat(web_path).size) * Core.Int64(8));  # 查看文檔大小，單位：字節（Bytes），1 字節（Bytes） = 8 比特（bits），1 比特（bits）即 1 個二進制位，一個英文字母占用 1 個字節，一個漢字符占用 2 個字節，乘以 8 表示轉換爲二進制比特（bits）數;
                # Base.ceil() 函數表示向上取整，Base.cld(x1, x2) 函數表示向上取整除法 x1 ÷ x2;
                file_size = Core.Int64(Base.stat(web_path).size);
                # println(file_size);

                # fRIO = Core.nothing;  # ::IOStream;
                try
                    # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                    # Base.readlines — Function
                    # Base.readlines(io::IO=stdin; keep::Bool=false)
                    # Base.readlines(filename::AbstractString; keep::Bool=false)
                    # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                    # for line in eachline(web_path)
                    #     print(line);
                    # end
                    # Base.displaysize([io::IO]) -> (lines, columns)
                    # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                    # Base.countlines — Function
                    # Base.countlines(io::IO; eol::AbstractChar = '\n')
                    # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                    # 在 Base.open() 函數中，還可以調用函數;
                    # Base.open(Base.readline, "sdy.txt");
                    # 也可以調用自定義函數;
                    # readFunc(s::IOStream) = Base.read(s, Char);
                    # Base.open(readFunc, "sdy.txt");
                    # 還可以像Python中的 with open...as 的用法一樣打開文件;
                    # Base.open("sdy.txt","r") do stream
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # 也可以將上述程序定義成函數再用open操作;
                    # function readFunc2(stream)
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # Base.open(readFunc2, "sdy.txt");

                    fRIO = Base.open(web_path, "r");
                    # nb = countlines(fRIO);  # 計算文檔中數據行數;
                    # seekstart(fRIO);  # 指針返回文檔的起始位置;

                    # Keyword	Description				Default
                    # read		open for reading		!write
                    # write		open for writing		truncate | append
                    # create	create if non-existent	!read & write | truncate | append
                    # truncate	truncate to zero size	!read & write
                    # append	seek to end				false

                    # Mode	Description						Keywords
                    # r		read							none
                    # w		write, create, truncate			write = true
                    # a		write, create, append			append = true
                    # r+	read, write						read = true, write = true
                    # w+	read, write, create, truncate	truncate = true, read = true
                    # a+	read, write, create, append		append = true, read = true

                    # 使用 isreadable(io) 函數判斷文檔是否可讀;
                    if Base.isreadable(fRIO)

                        # Base.read!(filename::AbstractString, array::Core.Union{Core.Array, Base.BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                        file_data_bytes_Array = Core.Array{Core.UInt8}(Core.undef, file_size);  # 創建一個長度為待讀取文檔大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）的一維 Core.UInt8 類型的數組;
                        # Base.readbytes!(web_path, file_data_bytes_Array, nb=Base.length(file_data_bytes_Array); all=true);  # 一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型，注意承接讀取到的數據的數組長度必須大於等於待讀取文檔的大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）;
                        Base.read!(web_path, file_data_bytes_Array);  # 一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型，注意承接讀取到的數據的數組長度必須大於等於待讀取文檔的大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）;
                        # println(file_data_bytes_Array);
                        # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
                        file_data_UInt8Array = Core.Array{Core.Any, 1}();  # 注意，自定義的數組轉字符串函數 JSONstring() 只能接受 Core.Any 類型的一維數組;
                        # for X in file_data_bytes_Array
                        #     X = Base.convert(Core.String, Base.bitstring(X));  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量，函數 Base.bitstring() 表示將二進制數字轉爲二進制數字的字符串，例如 Base.bitstring(11100101) === "11100101";
                        #     Base.push!(file_data_UInt8Array, X);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
                        # end
                        for i = 1:Base.length(file_data_bytes_Array)
                            # Base.push!(file_data_UInt8Array, Base.string(Base.bitstring(file_data_bytes_Array[i])));  # 使用 push! 函數在數組末尾追加推入新元素，函數 Base.bitstring() 表示將二進制數字轉爲二進制數字的字符串，例如 Base.bitstring(11100101) === "11100101";
                            Base.push!(file_data_UInt8Array, Core.UInt8(file_data_bytes_Array[i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                        end
                        # println(file_data_UInt8Array);
                        # file_data = Base.string("[", Base.string(Base.join(file_data_UInt8Array, ",")), "]");
                        file_data = "[" * Base.string(Base.join(file_data_UInt8Array, ",")) * "]";
                        # file_data_UInt8Array = [Base.parse(Core.UInt8, X, base=10) for X=Base.split(file_data, ",")];  # Julia 的數組推導式：[x+y for x=[[1,2] [3,4]], y=10:10:30 if isodd(x)] 返回值為：6-element Array{Int64,1}[11,13,21,23,31,33]，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                        # file_data = JSONstring(file_data_UInt8Array);  # 使用自定義函數將 Core.Any 類型的一維數組轉換爲 JSON 字符串;
                        # JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
                        # JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}

                        # file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                        # println(file_data);

                    else

                        println("指定的文檔: " * Base.string(request_Path) * " 無法讀取數據.";);
                        # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法讀取數據.";
                        response_body_Dict["Server_say"] = "文檔: " * Base.string(request_Path) * " 無法讀取數據.";
                        # response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";
                        response_body_Dict["error"] = "File ( " * Base.string(request_Path) * " ) unable to read.";

                        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                        response_body_String = JSONstring(response_body_Dict);
                        # println(response_body_String);
                        # Base.exit(0);
                        return response_body_String;
                    end

                    # 讀取輸入輸出的管道流（IOStream）中的數據保存在指定的内存緩衝區（Base.IOBuffer）中;
                    # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                    # Base.read(io, Core.String);
                    # "JuliaLang is a GitHub organization";
                    # Base.read(filename::AbstractString, Core.String);
                    # Read the entire contents of a file as a string.
                    # Base.read(s::IOStream, nb::Integer; all=true);
                    # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                    # Base.read(command::Cmd)
                    # Run command and return the resulting output as an array of bytes.
                    # Base.read(command::Cmd, Core.String)
                    # Run command and return the resulting output as a String.
                    # Base.read!(stream::IO, array::Union{Array, BitArray})
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                    # Read binary data from an I/O stream or file, filling in array.
                    # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                    # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                    # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                    # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                    # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                    # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                    # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                    # Base.ismarked(io);  # Return true if stream s is marked;
                    # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                    # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                    # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                    # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                    # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                    # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                    # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                    # Base.close(io);  # 關閉緩衝區;
                    # println(a)
                    # Base.redirect_stdout — Function
                    # redirect_stdout([stream]) -> (rd, wr)
                    # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                    # If called with the optional stream argument, then returns stream itself.
                    # Base.redirect_stdout — Method
                    # redirect_stdout(f::Function, stream)
                    # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                    # Base.redirect_stderr — Function
                    # redirect_stderr([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stderr.
                    # Base.redirect_stderr — Method
                    # redirect_stderr(f::Function, stream)
                    # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                    # Base.redirect_stdin — Function
                    # redirect_stdin([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                    # Base.redirect_stdin — Method
                    # redirect_stdin(f::Function, stream)
                    # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

                catch err

                    if Core.isa(err, Core.InterruptException)

                        print("\n");
                        # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                        # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                        println("[ Ctrl ] + [ c ] received, will be return Function.");

                        # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                        # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                        response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                        response_body_Dict["error"] = Base.string(err);

                    else

                        println("指定的文檔: " * web_path * " 無法讀取.");
                        println(err);
                        # println(err.msg);
                        # println(Base.typeof(err));

                        response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(request_Path) * " 無法讀取.";
                        # response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path) * " 無法讀取.";
                        response_body_Dict["error"] = Base.string(err);
                    end

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;

                finally
                    Base.close(fRIO);
                end

                fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
                # Base.GC.gc();  # 内存回收函數 gc();

            else

                # response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path) * " 無法識別.";
                response_body_Dict["Server_say"] = "請求文檔: " * Base.string(request_Path) * " 無法識別.";
                # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "File = { " * Base.string(request_Path) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end

            if file_data !== ""
                # response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
                response_body_String = Base.string(file_data);
            else
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 爲空.";
                response_body_Dict["Server_say"] = "文檔: " * Base.string(request_Path) * " 爲空.";
                # response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";
                response_body_Dict["error"] = "File ( " * Base.string(request_Path) * " ) empty.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
            # println(response_body_String);

            return response_body_String;

        elseif Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(web_path)

            # # 檢查待讀取目錄（文件夾）操作權限;
            # if Base.stat(web_path).mode !== Core.UInt64(16822) && Base.stat(web_path).mode !== Core.UInt64(16895)
            #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(monitor_dir) 函數讀取文檔信息，使用 Base.stat(monitor_dir).mode 方法提取文檔權限碼;
            #     # println("文件夾 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            #     try
            #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文件夾操作權限;
            #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
            #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
            #         # println("文件夾: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

            #         # 八進制值    說明
            #         # 0o400      所有者可讀
            #         # 0o200      所有者可寫
            #         # 0o100      所有者可執行或搜索
            #         # 0o40       群組可讀
            #         # 0o20       群組可寫
            #         # 0o10       群組可執行或搜索
            #         # 0o4        其他人可讀
            #         # 0o2        其他人可寫
            #         # 0o1        其他人可執行或搜索
            #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
            #         # 數字	說明
            #         # 7	可讀、可寫、可執行
            #         # 6	可讀、可寫
            #         # 5	可讀、可執行
            #         # 4	唯讀
            #         # 3	可寫、可執行
            #         # 2	只寫
            #         # 1	只可執行
            #         # 0	沒有許可權
            #         # 例如，八進制值 0o765 表示：
            #         # 1) 、所有者可以讀取、寫入和執行該文檔；
            #         # 2) 、群組可以讀和寫入該文檔；
            #         # 3) 、其他人可以讀取和執行該文檔；
            #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
            #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            #     catch err
            #         println("目錄（文件夾）: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
            #         println(err);
            #         # println(err.msg);
            #         # println(Base.typeof(err));

            #         response_body_Dict["Server_say"] = "目錄（文件夾）：[ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         response_body_Dict["error"] = Base.string(err);

            #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_body_String = JSONstring(response_body_Dict);
            #         # println(response_body_String);
            #         # Base.exit(0);
            #         return response_body_String;
            #     end
            # end

            directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

            # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
            if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)

                dir_list_Arror = Base.Filesystem.readdir(web_path);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
                # Base.length(Base.Filesystem.readdir(web_path));
                # if Base.length(dir_list_Arror) > 0

                    for item in dir_list_Arror

                        # if request_Path === "/"
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, item), "?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                        # elseif request_Path === "/index.html"
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # else
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # end
                        name_href_url_string = Base.string("http://", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("http://", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
                        deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

                        statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))));

                        if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                            directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
                        elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
                            directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
                        else
                        end

                    end

                # end

            else

                # response_body_Dict["Server_say"] = "服務器的運行路徑: " * Base.string(web_path) * " 無法識別.";
                response_body_Dict["Server_say"] = "服務器的運行路徑: " * Base.string(request_Path) * " 無法識別.";
                # response_body_Dict["error"] = "Folder = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "Folder = { " * Base.string(request_Path) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
            # 同步讀取硬盤 .html 文檔，返回字符串;
            if Base.Filesystem.ispath(web_path_index_Html) && Base.Filesystem.isfile(web_path_index_Html)

                fRIO = Core.nothing;  # ::IOStream;
                try
                    # line = Base.Filesystem.readlink(web_path_index_Html);  # 讀取文檔中的一行數據;
                    # Base.readlines — Function
                    # Base.readlines(io::IO=stdin; keep::Bool=false)
                    # Base.readlines(filename::AbstractString; keep::Bool=false)
                    # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                    # for line in eachline(web_path_index_Html)
                    #     print(line);
                    # end
                    # Base.displaysize([io::IO]) -> (lines, columns)
                    # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                    # Base.countlines — Function
                    # Base.countlines(io::IO; eol::AbstractChar = '\n')
                    # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                    # 在 Base.open() 函數中，還可以調用函數;
                    # Base.open(Base.readline, "sdy.txt");
                    # 也可以調用自定義函數;
                    # readFunc(s::IOStream) = Base.read(s, Char);
                    # Base.open(readFunc, "sdy.txt");
                    # 還可以像Python中的 with open...as 的用法一樣打開文件;
                    # Base.open("sdy.txt","r") do stream
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # 也可以將上述程序定義成函數再用open操作;
                    # function readFunc2(stream)
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # Base.open(readFunc2, "sdy.txt");

                    fRIO = Base.open(web_path_index_Html, "r");
                    # nb = countlines(fRIO);  # 計算文檔中數據行數;
                    # seekstart(fRIO);  # 指針返回文檔的起始位置;

                    # Keyword	Description				Default
                    # read		open for reading		!write
                    # write		open for writing		truncate | append
                    # create	create if non-existent	!read & write | truncate | append
                    # truncate	truncate to zero size	!read & write
                    # append	seek to end				false

                    # Mode	Description						Keywords
                    # r		read							none
                    # w		write, create, truncate			write = true
                    # a		write, create, append			append = true
                    # r+	read, write						read = true, write = true
                    # w+	read, write, create, truncate	truncate = true, read = true
                    # a+	read, write, create, append		append = true, read = true

                    # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                    # Base.read(io, Core.String);
                    # "JuliaLang is a GitHub organization";
                    # Base.read(filename::AbstractString, Core.String);
                    # Read the entire contents of a file as a string.
                    # Base.read(s::IOStream, nb::Integer; all=true);
                    # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                    # Base.read(command::Cmd)
                    # Run command and return the resulting output as an array of bytes.
                    # Base.read(command::Cmd, Core.String)
                    # Run command and return the resulting output as a String.
                    # Base.read!(stream::IO, array::Union{Array, BitArray})
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                    # Read binary data from an I/O stream or file, filling in array.
                    # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                    # 使用 isreadable(io) 函數判斷文檔是否可讀;
                    if Base.isreadable(fRIO)
                        # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                        file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    else
                        response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 無法讀取數據.";
                        response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) unable to read.";

                        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                        response_body_String = JSONstring(response_body_Dict);
                        # println(response_body_String);
                        # Base.exit(0);
                        return response_body_String;
                    end

                    # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                    # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                    # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                    # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                    # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                    # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                    # Base.ismarked(io);  # Return true if stream s is marked;
                    # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                    # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                    # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                    # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                    # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                    # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                    # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                    # Base.close(io);  # 關閉緩衝區;
                    # println(a)
                    # Base.redirect_stdout — Function
                    # redirect_stdout([stream]) -> (rd, wr)
                    # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                    # If called with the optional stream argument, then returns stream itself.
                    # Base.redirect_stdout — Method
                    # redirect_stdout(f::Function, stream)
                    # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                    # Base.redirect_stderr — Function
                    # redirect_stderr([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stderr.
                    # Base.redirect_stderr — Method
                    # redirect_stderr(f::Function, stream)
                    # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                    # Base.redirect_stdin — Function
                    # redirect_stdin([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                    # Base.redirect_stdin — Method
                    # redirect_stdin(f::Function, stream)
                    # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

                catch err

                    if Core.isa(err, Core.InterruptException)

                        print("\n");
                        # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                        # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                        println("[ Ctrl ] + [ c ] received, will be return Function.");

                        # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                        # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                        response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                        response_body_Dict["error"] = Base.string(err);

                    else

                        println("指定的文檔: " * web_path_index_Html * " 無法讀取.");
                        println(err);
                        # println(err.msg);
                        # println(Base.typeof(err));

                        response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path_index_Html) * " 無法讀取.";
                        response_body_Dict["error"] = Base.string(err);
                    end

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;

                finally
                    Base.close(fRIO);
                end

                fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
                # Base.GC.gc();  # 内存回收函數 gc();

            else

                response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path_index_Html) * " 無法識別.";
                response_body_Dict["error"] = "File = { " * Base.string(web_path_index_Html) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
            # 替換 .html 文檔中指定的位置字符串;
            if file_data !== ""
                response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            else
                response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 爲空.";
                response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) empty.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
            # println(response_body_String);

            return response_body_String;

        else

            println("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " * Base.string(web_path) * " } 無法識別.");
            # response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(web_path) * " } 無法識別.";
            response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(request_Path) * " } 無法識別.";
            # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
            response_body_Dict["error"] = "File = { " * Base.string(request_Path) * " } unrecognized.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        return response_body_String;
    end
end


# # 媒介服務器函數服務端（後端） TCP_Server() 使用説明;
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6(0);  # "::1";  # "0.0.0.0";  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# key = "username:password";  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# do_Function = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_POST_root_directory";
# number_Worker_threads = 0;#Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# TCP_Server = TCP_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = TCP_Server_Run(
#     host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     do_Function = do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
#     key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
#     session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
#     number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
#     TCP_Server = TCP_Server
# );
# # println(typeof(a))
# # println(a[1])
# # println(a[2])
# # println(a[3])

# 媒介服務器函數服務端（後端） http_Server() 使用説明;
# # using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# # using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# # Base.MainInclude.include("./Interface.jl");
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6(0);  # "::1";  # "0.0.0.0";  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# key = "username:password";  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# do_Function = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_POST_root_directory";
# number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# readtimeout = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# verbose = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# http_Server = http_Server;
# worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;

# # a = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}(Core.Core.undef, 3);  # Core.nothing;
# # Base.Vector{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}}(Core.Core.undef, 3);  # Core.nothing;
# a = http_Server_Run(
#     host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     do_Function = do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
#     key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
#     session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
#     number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     readtimeout = readtimeout,  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
#     verbose = verbose,  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
#     isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
#     http_Server = http_Server
# );
# # println(typeof(a))  # Base.Vector{Core.Any};
# # println(Base.length(a));  # 3;
# # println(a)
# # println(a[1])
# # println(a[2])
# # println(a[3])



# using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# Cookie Persistence;
mycookiejar::HTTP.CookieJar = HTTP.CookieJar();
# HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers)
# HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI)

# 示例函數，處理從服務器端返回的響應信息;
function do_Response(response_Dict::Core.Union{Core.String, Base.Dict})::Core.Union{Core.String, Base.Dict}

    # print("當前協程 task: ", Base.current_task(), "\n");
    # print("當前協程 task 的 ID: ", Base.objectid(Base.current_task()), "\n");
    # print("當前綫程 thread 的 PID: ", Base.Threads.threadid(), "\n");
    # print("Julia 進程可用的綫程數目上綫: ", Base.Threads.nthreads(), "\n");
    # print("當前進程的 PID: ", Distributed.myid(), "\n");  # 需要事先加載原生的支持多進程標準模組 using Distributed 模組;
    # println(data_Str);

    if Base.length(request_Dict) > 0
        # Base.isa(request_Dict, Base.Dict)

        if Base.haskey(request_Dict, "request_IP")
        end
        if Base.haskey(request_Dict, "request_Path")
        end
        if Base.haskey(request_Dict, "request_Method")
        end
    end

    request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    request_data_Dict = request_Dict;
    request_form_value::Core.String = request_data_Dict["request_Data"];  # 函數接收到的參數值;

    response_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_data_String::Core.String = "";

    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_data_Dict["Julia_say"] = Base.string(request_form_value);  # Base.Dict("Julia_say" => Base.string(request_form_value));
    response_data_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("Julia_say" => Base.string(request_form_value), "time" => string(return_file_creat_time));
    # println(response_data_Dict);

    # response_data_String = JSON.json(response_data_Dict);  # 使用第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    response_data_String = "{\"Julia_say\":\"" * Base.string(request_form_value) * "\",\"time\":\"" * Base.string(return_file_creat_time) * "\"}";  # 使用星號*拼接字符串;
    # println(response_data_String);

    return response_data_String;
end


# # 媒介服務器函數客戶端（前端） TCP_Client() 使用説明;
# host = Sockets.IPv6("::1");  # "::1";  # "127.0.0.1"; # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# URL = "";
# requestPath = "/";
# requestMethod = "GET";  # "POST",  # "GET"; # 請求方法;
# requestProtocol = "HTTP";
# # time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
# Cookie_name = "session_id";
# Cookie_value = "request_Key->username:password";
# # Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
# Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# # println(Core.String(Base64.base64decode(Cookie_value)));
# # println("Request Cook: ", Cookie);
# requestFrom = "user@email.com";
# # do_Function = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# # session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# # number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# # time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# # isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# # TCP_Server = TCP_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect.");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = TCP_Client(
#     host,  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     IPVersion=IPVersion,  # "IPv6"、"IPv4";
#     postData=postData,  # ::Core.Union{Core.String, Base.Dict} = "";  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
#     URL=URL,  # ::Core.String = "",
#     requestPath=requestPath,  # ::Core.String = "/",
#     requestMethod=requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
#     requestProtocol=requestProtocol,  # ::Core.String = "HTTP",
#     # time_out=time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     Authorization=Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
#     Cookie=Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
#     requestFrom=requestFrom,  # ::Core.String = "user@email.com",
#     # do_Function=do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
#     # session=session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => TCP_Server.key),  # 保存網站的 Session 數據;
#     # number_Worker_threads=number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     # time_sleep=time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     # isConcurrencyHierarchy=isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict=worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number=total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])

# # 使用 Julia 語言的第三方擴展包「HTTP」製作的，媒介服務器函數客戶端（前端） http_Client() 使用説明;
# # using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# # using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# # Base.MainInclude.include("./Interface.jl");
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6("::1"); # ::Core.String = "127.0.0.1", # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# proxy = Core.nothing;  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
# URL = "";  # "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  # http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1
# requestPath = "/";
# requestMethod = "POST";  # "POST",  # "GET"; # 請求方法;
# requestProtocol = "HTTP";  # Base.Unicode.lowercase(requestProtocol);  # 轉小寫字母;
# Referrer = URL;  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
# # time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
# Basicbasicauth = true;  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
# Cookie_name = "session_id";
# Cookie_value = "request_Key->username:password";
# # Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
# Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# # println(Core.String(Base64.base64decode(Cookie_value)));
# # println("Request Cook: ", Cookie);
# query = Base.Dict{Core.String, Core.String}();  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23", "IP" => "24"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
# requestFrom = "user@email.com";
# # do_Function = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# # session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# # number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# # time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# readtimeout = Core.Int(0);  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# connect_timeout = Core.Int(0);  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
# # isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# # http_Server = http_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# response_stream::Core.Union{Base.IOStream, Base.IOBuffer, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}, Core.Nothing, Core.Bool, Core.Int64} = Core.nothing;  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
# cookiejar = mycookiejar;  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);

# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.9.3 HTTP.request().");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = http_Client(
#     host,  # ::Core.String,  # "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
#     port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String};  # 0 ~ 65535，監聽埠號（端口）;
#     IPVersion = IPVersion,  # "IPv6"、"IPv4";
#     postData = postData,  # ::Core.Union{Core.String, Base.Dict} = "",  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
#     proxy = proxy,  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
#     requestPath = requestPath,  # ::Core.String = "/",
#     requestProtocol = requestProtocol,  # ::Core.String = "HTTP",
#     query = query,  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
#     URL = URL,  # ::Core.String = "",  # Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  # 請求網址 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
#     requestMethod = requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
#     # time_out = time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     readtimeout = readtimeout,  # ::Core.Int = Core.Int(0),  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
#     connect_timeout = connect_timeout,  # ::Core.Int = Core.Int(30),  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
#     Authorization = Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
#     Basicbasicauth = Basicbasicauth,  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
#     Cookie = Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
#     Referrer = Referrer,  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
#     requestFrom = requestFrom,  # ::Core.String = "user@email.com",
#     # do_Function = do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
#     # session = session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => http_Server.key),  # 保存網站的 Session 數據;
#     # number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     # time_sleep = time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     # isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     response_stream = response_stream,  # Core.nothing,  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
#     cookiejar = cookiejar  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])
