# module StatisticalAlgorithmServer
# Main.StatisticalAlgorithmServer
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
# Base.MainInclude.include("/home/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl");
# Base.MainInclude.include("C:/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl");
# Base.MainInclude.include("./StatisticalAlgorithmServer.jl");

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
Base.MainInclude.include("./Interface.jl");
# Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Interface.jl"));
# Base.Filesystem.joinpath(Base.@__DIR__, "Interface.jl")
# Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Interface.jl")
# Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Interface.jl")
Base.MainInclude.include("./Router.jl");  # 導入自定義的路由（Router）模組;

# Base.MainInclude.include("./Interpolation_Fitting.jl");  # 加載自定義算法模組，導入本地自定義 5PLC 方程等曲綫擬合函數模組;



# using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# Cookie Persistence;
mycookiejar::HTTP.CookieJar = HTTP.CookieJar();
# HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers)
# HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI)



# 配置預設值;
interface_Function = http_Server_Run;  # monitor_file_Run;  # TCP_Server_Run;  # http_Server_Run;  # TCP_Client;  # http_Client;
interface_Function_name_str = "http_Server";  # "file_Monitor";  # "tcp_Server";  # "http_Server";  # "tcp_Client";  # "http_Client";  "interface_File_Monitor";  # "interface_TCP_Server";  # "interface_http_Server";  # "interface_TCP_Client";  # "interface_http_Client";

# 配置當 interface_Function = monitor_file_Run 時的預設值;
is_monitor = true;  # true; # Boolean，用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
monitor_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸入傳值的媒介目錄 "../Intermediary/";
monitor_file = Base.Filesystem.joinpath(monitor_dir, "intermediary_write_C");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(monitor_dir, "intermediary_write_NodeJS.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於接收傳值的媒介文檔 "../Intermediary/intermediary_write_NodeJS.txt";
output_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸出傳值的媒介目錄 "../Intermediary/";
output_file = Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於輸出傳值的媒介文檔 "../Intermediary/intermediary_write_Julia.txt";
temp_cache_IO_data_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "temp");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "temp")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_cache_IO_data_dir\";
do_Function_data = do_data;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
to_executable = "";  # Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node.exe");  # C:/Progra~1/nodejs/node.exe";  # 上一層路徑下的Node.JS解釋器可執行檔路徑C:\nodejs\node.exe：Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node.exe")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的解釋器可執行文件 "..\\NodeJS\\node.exe"，Julia 解釋器可執行檔全名 println(Base.Sys.BINDIR)：C:\Julia 1.5.1\bin，;
to_script = "";  # Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "application.js");  # "C:/Users/china/Documents/Node.js/StatisticalServer/StatisticalServerJulia/test.js";  # 上一層路徑下的 JavaScript 脚本路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "Ruuter.js")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的被調用的脚本文檔 "../js/Ruuter.js";
time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
number_Worker_threads = Core.UInt8(0);  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
isMonitorThreadsOrProcesses = 0;  # "Multi-Threading"; # "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
# 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
isDoTasksOrThreads = "Tasks";  # "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
# 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
do_Function_name_str_data = "do_data";

# 配置當 interface_Function = TCP_Server_Run; interface_Function = http_Server_Run; 時的預設值;
webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# webPath = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(".")), "html"));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
host = Sockets.IPv6(0);  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
port = "10001";  # ::Core.Union{Core.String, Core.UInt8} = "10001";  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
key = "username:password";  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
session = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Core.String}("request_Key->username:password" => key); 自定義 session 值，Base.Dict 對象;
number_Worker_threads = Core.UInt8(0);  # Core.UInt8(1)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# readtimeout::Core.Int = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
readtimeout = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# verbose::Core.Bool = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
verbose = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
do_Function_Request = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 do_Request, "do_POST_root_directory";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 do_Request, "do_POST_root_directory";
isConcurrencyHierarchy = "Tasks";  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
do_Function_name_str_Request = "do_Request";

# 配置當 interface_Function = TCP_Client; interface_Function = http_Client; 時的預設值;
host = Sockets.IPv6("::1"); # ::Core.String = "127.0.0.1", # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
IPVersion = "IPv6";  # "IPv6"、"IPv4";
port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
proxy = Core.nothing;  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
URL = "";  # "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  # http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1
requestPath = "/";
requestMethod = "POST";  # "POST",  # "GET"; # 請求方法;
requestProtocol = "HTTP";  # Base.Unicode.lowercase(requestProtocol);  # 轉小寫字母;
Referrer = URL;  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
# time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
Basicbasicauth = true;  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
Cookie_name = "session_id";
Cookie_value = "request_Key->username:password";
# Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# println(Core.String(Base64.base64decode(Cookie_value)));
# println("Request Cook: ", Cookie);
query = Base.Dict{Core.String, Core.String}();  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23", "IP" => "24"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
requestFrom = "user@email.com";
do_Function_Response = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
time_sleep = Core.Float16(0.02);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
readtimeout = Core.Int(0);  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
connect_timeout = Core.Int(0);  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# http_Server = http_Server;
# worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# response_stream::Core.Union{Base.IOStream, Base.IOBuffer, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}, Core.Nothing, Core.Bool, Core.Int64} = Core.nothing;  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
response_stream = Core.nothing;  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
cookiejar = mycookiejar;  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
# total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.9.3 HTTP.request().");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
do_Function_name_str_Response = "do_Response";


configFile::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.@__FILE__))), "config.txt"));  # "C:/StatisticalServer/StatisticalServerJulia/config.txt" # "/home/StatisticalServer/StatisticalServerJulia/config.txt";
# configFile = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.@__FILE__))), "config.txt")), "\\" => "/"));  # "C:/StatisticalServer/StatisticalServerJulia/config.txt" # "/home/StatisticalServer/StatisticalServerJulia/config.txt";
# configFile = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath("..")), "config.txt"));  # "C:/StatisticalServer/StatisticalServerJulia/config.txt" # "/home/StatisticalServer/StatisticalServerJulia/config.txt";
# configFile = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath("..")), "config.txt")), "\\" => "/"));  # "C:/StatisticalServer/StatisticalServerJulia/config.txt" # "/home/StatisticalServer/StatisticalServerJulia/config.txt";
# print(configFile, "\n");
# 控制臺傳參，通過 Base.ARGS 數組獲取從控制臺傳入的參數;
# println(Base.typeof(Base.ARGS));
# println(Base.ARGS);
# println(Base.PROGRAM_FILE);  # 通過命令行啓動的，當前正在執行的 Julia 脚本文檔路徑;
# 使用 Base.typeof("abcd") == String 方法判斷對象是否是一個字符串;
# for X in Base.ARGS
#     println(X)
# end
# for X ∈ Base.ARGS
#     println(X)
# end
if Base.length(Base.ARGS) > 0
    for i = 1:Base.length(Base.ARGS)
        # println("Base.ARGS" * Base.string(i) * ": " * Base.string(Base.ARGS[i]));  # 通過 Base.ARGS 數組獲取從控制臺傳入的參數;
        # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
        if Core.isa(Base.ARGS[i], Core.String) && Base.ARGS[i] !== "" && Base.occursin("=", Base.ARGS[i])

            ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();  # 聲明一個聯合類型的空1維數組;
            # ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
            # 函數 Base.split(Base.ARGS[i], '=') 表示用等號字符'='分割字符串為數組;
            for x in Base.split(Base.ARGS[i], '=')
                x = Base.convert(Core.String, x);  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                Base.push!(ARGSIArray, x);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
            end

            if Base.length(ARGSIArray) > 1

                ARGSValue = "";
                # ARGSValue = join(Base.deleteat!(Base.deepcopy(ARGSIArray), 1), "=");  # 使用 Base.deepcopy() 標注數組深拷貝傳值複製，這樣在使用 Base.deleteat!(ARGSIArray, 1) 函數刪除第一個元素時候就不會改變原數組 ARGSIArray，否則為淺拷貝傳址複製，使用 deleteat!(ARGSIArray, 1) 刪除第一個元素的時候會影響原數組 ARGSIArray 的值，然後將數組從第二個元素起直至末尾拼接為一個字符串;
                for j = 2:Base.length(ARGSIArray)
                    if j === 2
                        ARGSValue = ARGSValue * ARGSIArray[j];  # 使用星號*拼接字符串;
                    else
                        ARGSValue = ARGSValue * "=" * ARGSIArray[j];
                    end
                end

                # try
                #     g = Base.Meta.parse(Base.string(ARGSIArray[1]) * "=" * Base.string(ARGSValue));  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                #     Base.MainInclude.eval(g);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                #     println(Base.string(ARGSIArray[1]) * " = " * "\$" * Base.string(ARGSIArray[1]));
                # catch err
                #     println(err);
                # end

                # if ARGSValue !== ""

                    if ARGSIArray[1] === "configFile"
                        if ARGSValue !== ""
                            global configFile = ARGSValue;  # 指定的配置文檔（config.txt）保存路徑全名："C:/StatisticalServer/StatisticalServerJulia/config.txt" # "/home/StatisticalServer/StatisticalServerJulia/config.txt";
                        else
                            global configFile = "";
                        end
                        # print("Config file: ", configFile, "\n");
                        break;
                    end
                # end
            end
        end
    end
end

# 讀取配置文檔（config.txt）裏的參數;
# "/home/StatisticalServer/StatisticalServerJulia/config.txt"
# "C:/StatisticalServer/StatisticalServerJulia/config.txt"
if Core.isa(configFile, Core.String) && configFile !== ""

    # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的用於傳入數據的媒介文檔是否存在，如果不存在，則中止函數退出，如果存在則判斷操作權限，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
    # 同步判斷，使用 Julia 原生模組 Base.Filesystem.isfile(configFile) 方法判斷是否為文檔;
    if !(Base.Filesystem.ispath(configFile) && Base.Filesystem.isfile(configFile))
        println("Config file = [ " * Base.string(configFile) * " ] unrecognized.");
        # println("用於輸入運行參數的配置文檔: " * configFile * " 無法識別或不存在.");
        # return ["error", configFile, "document [ Config file = " * Base.string(configFile) * " ] unrecognized."];
    elseif Base.stat(configFile).mode !== Core.UInt64(33206) && Base.stat(configFile).mode !== Core.UInt64(33279)
        # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(configFile) 函數讀取文檔信息，使用 Base.stat(configFile).mode 方法提取文檔權限碼;
        # println("用於輸入運行參數的配置文檔 [ " * configFile * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
        try
            # 使用 Base.Filesystem.chmod(configFile, mode=0o777; recursive=false) 函數修改文檔操作權限;
            # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
            Base.Filesystem.chmod(configFile, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
            # println("文檔: " * configFile * " 操作權限成功修改爲 mode=0o777 .");

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

        catch err1
            println("Config file = [ " * Base.string(configFile) * " ] change the permissions mode=0o777 fail.");
            # println("用於輸入運行參數的配置文檔: " * configFile * " 無法修改操作權限爲 mode=0o777 .");
            println(err1);
            # println(Base.typeof(err1));
            # return ["error", configFile, "document [ Config file = " * Base.string(configFile) * " ] change the permissions mode=0o777 fail."];
        end
    else
    end

    # 同步讀取，讀取用於輸入運行參數的配置文檔中的數據;
    if Base.Filesystem.ispath(configFile) && Base.Filesystem.isfile(configFile)

        if Base.stat(configFile).mode === Core.UInt64(33206) || Base.stat(configFile).mode === Core.UInt64(33279)

            config_file_RIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(configFile);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(configFile)
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

                global config_file_RIO = Base.open(configFile, "r");
                # nb = countlines(config_file_RIO);  # 計算文檔中數據行數;
                # seekstart(config_file_RIO);  # 指針返回文檔的起始位置;

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

                # io = IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Vector{UInt8} of the bytes read.
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
                if Base.isreadable(config_file_RIO)
                    println("Config file = " * Base.string(configFile));
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    # data_Str::Core.String = "";
                    # data_Str = Base.read(config_file_RIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;

                    # lines = String[];
                    # lines = Base.readlines(config_file_RIO; keep=false);  # 逐橫向列讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;  # Base.readlines(io::IO=stdin; keep::Bool=false);Base.readlines(filename::AbstractString; keep::Bool=false);
                    # for line in lines
                    #     println(line);
                    # end
                    # lines = Core.nothing;

                    line_I::Core.UInt8 = Core.UInt8(0);
                    # for line in eachline(configFile)
                    for line in eachline(config_file_RIO)
                        # println(line);

                        line_I = line_I + Core.UInt8(1);
                        line_Key::Core.String = "";
                        line_Value::Core.String = "";

                        if Core.isa(line, Core.String) && line !== ""

                            # 判斷字符串是否包含換行符號（\r\n）;
                            if Base.occursin("\r\n", line)
                                line = Base.string(Base.replace(Base.string(line), "\r\n" => ""));  # 刪除行尾的換行符（\r\n）;
                            elseif Base.occursin("\r", line)
                                line = Base.string(Base.replace(Base.string(line), "\r" => ""));  # 刪除行尾的換行符（\r）;
                            elseif Base.occursin("\n", line)
                                line = Base.string(Base.replace(Base.string(line), "\n" => ""));  # 刪除行尾的換行符（\n）;
                            else
                                # line = Base.string(Base.strip(Base.string(line), [' ']));  # 刪除行首尾的空格字符（' '）;
                            end

                            line = Base.string(Base.strip(Base.string(line), [' ']));  # 刪除行首尾的空格字符（' '）;
    
                            # 判斷字符串是否含有等號字符（=）連接符（Key=Value），若含有等號字符（=），則以等號字符（=）分割字符串;
                            if Base.occursin("=", line)

                                ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();  # 聲明一個聯合類型的空1維數組;
                                # ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
                                # 函數 Base.split(line, '=') 表示用等號字符'='分割字符串為數組;
                                for x in Base.split(line, '=')
                                    x = Base.convert(Core.String, x);  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                                    Base.push!(ARGSIArray, x);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
                                end

                                if Base.length(ARGSIArray) === 1
                                    if Core.isa(ARGSIArray[1], Core.String) && ARGSIArray[1] !== ""
                                        line_Key = Base.string(Base.strip(Base.string(ARGSIArray[1]), [' ']));
                                    end
                                end

                                if Base.length(ARGSIArray) > 1

                                    ARGSValue = "";
                                    # ARGSValue = join(Base.deleteat!(Base.deepcopy(ARGSIArray), 1), "=");  # 使用 Base.deepcopy() 標注數組深拷貝傳值複製，這樣在使用 Base.deleteat!(ARGSIArray, 1) 函數刪除第一個元素時候就不會改變原數組 ARGSIArray，否則為淺拷貝傳址複製，使用 deleteat!(ARGSIArray, 1) 刪除第一個元素的時候會影響原數組 ARGSIArray 的值，然後將數組從第二個元素起直至末尾拼接為一個字符串;
                                    for j = 2:Base.length(ARGSIArray)
                                        if j === 2
                                            ARGSValue = ARGSValue * ARGSIArray[j];  # 使用星號*拼接字符串;
                                        else
                                            ARGSValue = ARGSValue * "=" * ARGSIArray[j];
                                        end
                                    end

                                    # try
                                    #     g = Base.Meta.parse(Base.string(ARGSIArray[1]) * "=" * Base.string(ARGSValue));  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                                    #     Base.MainInclude.eval(g);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                                    #     println(Base.string(ARGSIArray[1]) * " = " * "\$" * Base.string(ARGSIArray[1]));
                                    # catch err
                                    #     println(err);
                                    # end

                                    if Core.isa(ARGSIArray[1], Core.String) && ARGSIArray[1] !== ""
                                        line_Key = Base.string(Base.strip(Base.string(ARGSIArray[1]), [' ']));  # 刪除字符串首尾的空格字符（' '）;
                                    end

                                    if Core.isa(ARGSValue, Core.String) && ARGSValue !== ""
                                        line_Value = Base.string(Base.strip(Base.string(ARGSValue), [' ']));  # 刪除字符串首尾的空格字符（' '）;
                                    end
                                end
                            else
                                line_Value = Base.string(line);
                            end
                            # println(line_Key);
                            # println(line_Value);

                            # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                            # 用於接收執行功能的函數 do_Function = "do_data"; "do_Request";
                            if line_Key === "interface_Function"

                                global interface_Function_name_str = line_Value;
                                # global interface_Function = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;

                                if line_Value === "file_Monitor"
                                    global interface_Function = monitor_file_Run;
                                    global interface_Function_name_str = "interface_File_Monitor";
        
                                    global do_Function_name_str_data = "do_data";
                                    global do_Function_data = do_data;
                                    # global do_Function = do_data;
                                end

                                if line_Value === "TCP_Server"
                                    global interface_Function = TCP_Server_Run;
                                    global interface_Function_name_str = "interface_TCP_Server";
        
                                    global do_Function_name_str_Request = "do_Request";
                                    global do_Function_Request = do_Request;
                                    # global do_Function = do_Request;
                                end

                                if line_Value === "http_Server"
                                    global interface_Function = http_Server_Run;
                                    global interface_Function_name_str = "interface_http_Server";
        
                                    global do_Function_name_str_Request = "do_Request";
                                    global do_Function_Request = do_Request;
                                    # global do_Function = do_Request;
                                end

                                if line_Value === "TCP_Client"
                                    global interface_Function = TCP_Client;
                                    global interface_Function_name_str = "interface_TCP_Client";
        
                                    global do_Function_name_str_Response = "do_Response";
                                    global do_Function_Response = do_Response;
                                    # global do_Function = do_Response;
                                end

                                if line_Value === "http_Client"
                                    global interface_Function = http_Client;
                                    global interface_Function_name_str = "interface_http_Client";
        
                                    global do_Function_name_str_Response = "do_Response";
                                    global do_Function_Response = do_Response;
                                    # global do_Function = do_Response;
                                end

                                # print("interface Function: ", interface_Function_name_str, "\n");
                                # print("do Function: ", do_Function_name_str_Request, "\n");
                                continue;
                            end

                            if line_Key === "is_monitor"
                                # global is_monitor = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global is_monitor = Base.parse(Bool, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                                # print("is monitor: ", is_monitor, "\n");
                                continue;
                            end
        
                            if line_Key === "monitor_file"
                                global monitor_file = line_Value;  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                                # print("monitor file: ", monitor_file, "\n");
                                continue;
                            end
        
                            if line_Key === "monitor_dir"
                                global monitor_dir = line_Value;  # 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                                # print("monitor dir: ", monitor_dir, "\n");
                                continue;
                            end
        
                            if line_Key === "output_dir"
                                global output_dir = line_Value;  # 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                                # print("output dir: ", output_dir, "\n");
                                continue;
                            end
        
                            if line_Key === "output_file"
                                global output_file = line_Value;  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Julia.txt";
                                # print("output file: ", output_file, "\n");
                                continue;
                            end
        
                            if line_Key === "temp_cache_IO_data_dir"
                                global temp_cache_IO_data_dir = line_Value;  # 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 Base.@__DIR__;
                                # print("Temporary cache IO data directory: ", temp_cache_IO_data_dir, "\n");
                                continue;
                            end
        
                            if line_Key === "to_executable"
                                global to_executable = line_Value;  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                                # print("to executable: ", to_executable, "\n");
                                continue;
                            end
        
                            if line_Key === "to_script"
                                global to_script = line_Value;  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                                # print("to script: ", to_script, "\n");
                                continue;
                            end
        
                            if line_Key === "time_sleep"
                                # CheckString(line_Value, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                                # global is_monitor = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global time_sleep = Base.parse(Core.Float64, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的長整型(Core.UInt64)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
                                # print("time sleep: ", time_sleep, "\n");
                                continue;
                            end
        
                            if line_Key === "number_Worker_threads"
                                # CheckString(line_Value, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                                # global is_monitor = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global number_Worker_threads = Base.parse(UInt8, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(UInt8)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                                # print("number Worker threads: ", number_Worker_threads, "\n");
                                continue;
                            end
        
                            if line_Key === "isMonitorThreadsOrProcesses"
                                global isMonitorThreadsOrProcesses = line_Value;  # 0 || "0" || "Multi-Threading" || "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
                                # print("isMonitorThreadsOrProcesses: ", isMonitorThreadsOrProcesses, "\n");
                                # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                                # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                                # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                                # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                                # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                                continue;
                            end
        
                            if line_Key === "isDoTasksOrThreads"
                                global isDoTasksOrThreads = line_Value;  # "Tasks" || "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                                # print("isDoTasksOrThreads: ", isDoTasksOrThreads, "\n");
                                # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                                # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                                # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                                continue;
                            end
        
                            if line_Key === "do_Function"
        
                                if line_Value === "do_data"
        
                                    # 使用函數 Base.@isdefined(do_data) 判斷 do_data 變量是否已經被聲明過;
                                    if Base.@isdefined(do_data)
                                        # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                        # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                        # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                        if Base.typeof(do_data) <: Function
                                            global do_Function = do_data;
                                        else
                                            println("傳入的參數，指定的變量「" * line_Value * "」不是一個函數類型的變量.");
                                            # global do_Function = Core.nothing;  # 置空;
                                            global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                        end
                                    else
                                        println("傳入的參數，指定的變量「" * line_Value * "」未定義.");
                                        # global do_Function = Core.nothing;  # 置空;
                                        global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    end
        
                                    # try
                                    #     if length(methods(do_data)) > 0
                                    #         global do_Function = do_data;
                                    #     else
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     end
                                    # catch err
                                    #     # println(err);
                                    #     # println(Base.typeof(err));
                                    #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                                    #     if Core.isa(err, Core.UndefVarError)
                                    #         println(err.var, " not defined.");
                                    #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     else
                                    #         println(err);
                                    #     end
                                    # finally
                                    #     # global do_Function = Core.nothing;  # 置空;
                                    #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    # end
                                end
        
                                if line_Value === "do_Request"
        
                                    # 使用函數 Base.@isdefined(do_Request) 判斷 do_Request 變量是否已經被聲明過;
                                    if Base.@isdefined(do_Request)
                                        # 使用 Core.isa(do_Request, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判別 do_Request 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                        # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                        # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                        if Base.typeof(do_Request) <: Function
                                            global do_Function = do_Request;
                                        else
                                            println("傳入的參數，指定的變量「" * line_Value * "」不是一個函數類型的變量.");
                                            # global do_Function = Core.nothing;  # 置空;
                                            global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                        end
                                    else
                                        println("傳入的參數，指定的變量「" * line_Value * "」未定義.");
                                        # global do_Function = Core.nothing;  # 置空;
                                        global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    end
        
                                    # try
                                    #     if length(methods(do_Request)) > 0
                                    #         global do_Function = do_Request;
                                    #     else
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     end
                                    # catch err
                                    #     # println(err);
                                    #     # println(Base.typeof(err));
                                    #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                                    #     if Core.isa(err, Core.UndefVarError)
                                    #         println(err.var, " not defined.");
                                    #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     else
                                    #         println(err);
                                    #     end
                                    # finally
                                    #     # global do_Function = Core.nothing;  # 置空;
                                    #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    # end
                                end
        
                                if line_Value === "do_Response"
        
                                    # 使用函數 Base.@isdefined(do_Response) 判斷 do_Response 變量是否已經被聲明過;
                                    if Base.@isdefined(do_Response)
                                        # 使用 Core.isa(do_Response, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判別 do_Response 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                        # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                        # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                        if Base.typeof(do_Response) <: Function
                                            global do_Function = do_Response;
                                        else
                                            println("傳入的參數，指定的變量「" * line_Value * "」不是一個函數類型的變量.");
                                            # global do_Function = Core.nothing;  # 置空;
                                            global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                        end
                                    else
                                        println("傳入的參數，指定的變量「" * line_Value * "」未定義.");
                                        # global do_Function = Core.nothing;  # 置空;
                                        global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    end
        
                                    # try
                                    #     if length(methods(do_Response)) > 0
                                    #         global do_Function = do_Response;
                                    #     else
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     end
                                    # catch err
                                    #     # println(err);
                                    #     # println(Base.typeof(err));
                                    #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                                    #     if Core.isa(err, Core.UndefVarError)
                                    #         println(err.var, " not defined.");
                                    #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                                    #         # global do_Function = Core.nothing;  # 置空;
                                    #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    #     else
                                    #         println(err);
                                    #     end
                                    # finally
                                    #     # global do_Function = Core.nothing;  # 置空;
                                    #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                    # end
                                end
        
                                # if line_Value !== "do_data" && line_Value !== "do_data"
                                #     # global do_Function = Core.nothing;  # 置空;
                                #     global do_Function = (argument) -> argument;  # 匿名函數，直接返回傳入參數做返回值;
                                # end
        
                                # print("do Function: ", do_Function, "\n");
                                continue;
                            end
        
                            if line_Key === "host"
                                global host = line_Value;  # 用於輸出傳值的媒介目錄 "../temp/";
                                if Base.string(host) === "::0" || Base.string(host) === "::1" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "1"
                                    # || CheckIP(Base.string(host)) === "IPv6"
                                    global host = Sockets.IPv6(host);  # Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::0" or "::1" or "localhost"; 監聽主機域名 Host domain name;
                                elseif Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
                                    # || CheckIP(Base.string(host)) === "IPv4"
                                    global host = Sockets.IPv4(host);  # Sockets.IPv4("0.0.0.0");  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
                                elseif Base.string(host) === "localhost"
                                    global host = Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
                                else
                                    println("Error: host IP [ " * Base.string(host) * " ] unrecognized.");
                                    # return false
                                end
                                # print("host: ", Base.string(host), "\n");
                                continue;
                            end
        
                            if line_Key === "IPVersion"
                                global IPVersion = line_Value;  # "IPv6"、"IPv4";
                                # print("IP Version: ", IPVersion, "\n");
                                continue;
                            end
        
                            if line_Key === "port"
                                global port = line_Value;  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
                                global port = Base.parse(Core.UInt64, port);
                                # print("port: ", Base.string(port), "\n");
                                continue;
                            end
        
                            if line_Key === "key"
                                if Base.string(line_Value) === "nothing" || Base.string(line_Value) === ""
                                    global key = "";
                                    # global key = Core.nothing;
                                else
                                    global key = Base.string(line_Value);  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                                end
                                # print("key: ", key, "\n");
                                continue;
                            end
        
                            if line_Key === "session"
                                # global session = line_Value;  # 用於輸入傳值的媒介目錄 "../temp/";
                                # g = Base.Meta.parse(Base.string(line_Key) * Base.string(line_Value));
                                g = Base.Meta.parse("session=" * Base.string(line_Value));
                                Base.MainInclude.eval(g);
                                # print("session: ", session, "\n");
                                continue;
                            end
        
                            if line_Key === "isConcurrencyHierarchy"
                                global isConcurrencyHierarchy = line_Value;  # "Tasks" || "Multi-Threading" || "Multi-Processes"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                                # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
                                # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                                # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                                # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                                # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                                # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                                continue;
                            end
        
                            if line_Key === "Authorization"
                                global Authorization = line_Value;  # 客戶端發送的請求頭中的 Authorizater 參數值;
                                # print("Authorization: ", Authorization, "\n");
                                continue;
                            end
        
                            if line_Key === "Cookie"
                                global Cookie = line_Value;  # 客戶端發送的請求頭中的 Cookie 參數值;
                                # print("Cookie: ", Cookie, "\n");
                                continue;
                            end
        
                            if line_Key === "URL"
                                global URL = line_Value;
                                # print("URL: ", URL, "\n");
                                continue;
                            end
        
                            if line_Key === "proxy"
                                global proxy = line_Value;
                                # print("Proxy: ", proxy, "\n");
                                continue;
                            end
        
                            if line_Key === "Referrer"
                                global Referrer = line_Value;
                                # print("Referrer: ", Referrer, "\n");
                                continue;
                            end
        
                            if line_Key === "query"
                                # https://github.com/JuliaIO/JSON.jl
                                # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
                                # s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
                                # j = JSON.parse(s)
                                # Dict{AbstractString,Any} with 2 entries:
                                #     "an_array" => {"string",9}
                                #     "a_number" => 5.0
                                global query = JSON.parse(line_Value);
                                # print("query: ", line_Value, "\n");
                                # print("query: ", "\n");
                                # print(query);
                                continue;
                            end
        
                            if line_Key === "readtimeout"
                                # CheckString(line_Value, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                                # global is_monitor = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global readtimeout = Base.parse(Core.Int, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                                # print("Read Timeout: ", readtimeout, "\n");
                                continue;
                            end
        
                            if line_Key === "connecttimeout"
                                # CheckString(line_Value, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                                # global is_monitor = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global connect_timeout = Base.parse(Core.Int, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                                # print("Connect Timeout: ", connect_timeout, "\n");
                                continue;
                            end
        
                            if line_Key === "verbose"
                                # global verbose = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global verbose = Base.parse(Core.Bool, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                                # print("verbose: ", verbose, "\n");
                                continue;
                            end
        
                            if line_Key === "requestFrom"
                                global requestFrom = line_Value;  # 客戶端發送的請求頭中的 From 參數值;
                                # print("requestFrom: ", requestFrom, "\n");
                                continue;
                            end
        
                            if line_Key === "requestPath"
                                global requestPath = line_Value;
                                # print("requestPath: ", requestPath, "\n");
                                continue;
                            end
        
                            if line_Key === "requestMethod"
                                global requestMethod = line_Value;
                                # print("requestMethod: ", requestMethod, "\n");
                                continue;
                            end
        
                            if line_Key === "requestProtocol"
                                global requestProtocol = line_Value;
                                # print("requestProtocol: ", requestProtocol, "\n");
                                continue;
                            end
        
                            if line_Key === "postData"
                                # global postData = line_Value;  # 用於輸入傳值的媒介目錄 "../temp/";
                                # g = Base.Meta.parse(Base.string(line_Key) * Base.string(line_Value));
                                # g = Base.Meta.parse("postData=" * Base.string(line_Value));
                                # Base.MainInclude.eval(g);
                                global postData = Base.string(line_Value);
                                # print("postData: ", postData, "\n");
                                continue;
                            end
        
                            if line_Key === "webPath"
                                global webPath = line_Value;  # 用於輸入服務器的根目錄 "../";
                                # print("webPath: ", webPath, "\n");
                                continue;
                            end
                        end
                    end
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（IOBuffer）;
                # io = Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（IOBuffer）;
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

            catch err2

                if Core.isa(err2, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err2) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    # Base.exit(0);
                    return ["error", "[ Ctrl ] + [ c ]", "[ Ctrl ] + [ c ] received, will be return Function."];

                else

                    println("Config file = [ " * Base.string(configFile) * " ] not read.");
                    # println("從用於輸入運行參數的配置文檔: " * configFile * " 中讀取數據發生錯誤.");
                    println(err2);
                    # println(err2.msg);
                    # println(Base.typeof(err2));
                    # return ["error", configFile, "document [ Config file = " * Base.string(configFile) * " ] not read."];
                end

            finally
                Base.close(config_file_RIO);
            end

            config_file_RIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();
        end

        # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
        # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

        # nowTime = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
        # println(Base.string(nowTime));
    end
end

# 控制臺傳參，通過 Base.ARGS 數組獲取從控制臺傳入的參數;
# println(Base.typeof(Base.ARGS));
# println(Base.ARGS);
# println(Base.PROGRAM_FILE);  # 通過命令行啓動的，當前正在執行的 Julia 脚本文檔路徑;
# 使用 Base.typeof("abcd") == String 方法判斷對象是否是一個字符串;
# for X in Base.ARGS
#     println(X)
# end
# for X ∈ Base.ARGS
#     println(X)
# end
if Base.length(Base.ARGS) > 0
    for i = 1:Base.length(Base.ARGS)
        # println("Base.ARGS" * Base.string(i) * ": " * Base.string(Base.ARGS[i]));  # 通過 Base.ARGS 數組獲取從控制臺傳入的參數;
        # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
        if Core.isa(Base.ARGS[i], Core.String) && Base.ARGS[i] !== "" && Base.occursin("=", Base.ARGS[i])

            ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();  # 聲明一個聯合類型的空1維數組;
            # ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
            # 函數 Base.split(Base.ARGS[i], '=') 表示用等號字符'='分割字符串為數組;
            for x in Base.split(Base.ARGS[i], '=')
                x = Base.convert(Core.String, x);  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                Base.push!(ARGSIArray, x);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
            end

            if Base.length(ARGSIArray) > 1

                ARGSValue = "";
                # ARGSValue = join(Base.deleteat!(Base.deepcopy(ARGSIArray), 1), "=");  # 使用 Base.deepcopy() 標注數組深拷貝傳值複製，這樣在使用 Base.deleteat!(ARGSIArray, 1) 函數刪除第一個元素時候就不會改變原數組 ARGSIArray，否則為淺拷貝傳址複製，使用 deleteat!(ARGSIArray, 1) 刪除第一個元素的時候會影響原數組 ARGSIArray 的值，然後將數組從第二個元素起直至末尾拼接為一個字符串;
                for j = 2:Base.length(ARGSIArray)
                    if j === 2
                        ARGSValue = ARGSValue * ARGSIArray[j];  # 使用星號*拼接字符串;
                    else
                        ARGSValue = ARGSValue * "=" * ARGSIArray[j];
                    end
                end

                # try
                #     g = Base.Meta.parse(Base.string(ARGSIArray[1]) * "=" * Base.string(ARGSValue));  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                #     Base.MainInclude.eval(g);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                #     println(Base.string(ARGSIArray[1]) * " = " * "\$" * Base.string(ARGSIArray[1]));
                # catch err
                #     println(err);
                # end

                if ARGSValue !== ""

                    # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                    # 用於接收執行功能的函數 do_Function = "do_data"; "do_Request";
                    if ARGSIArray[1] === "interface_Function"

                        global interface_Function_name_str = ARGSValue;
                        # global interface_Function = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;

                        if ARGSValue === "File_Monitor"
                            global interface_Function = monitor_file_Run;
                            global interface_Function_name_str = "interface_File_Monitor";

                            global do_Function_name_str_data = "do_data";
                            global do_Function_data = do_data;
                            # global do_Function = do_data;
                        end

                        if ARGSValue === "TCP_Server"
                            global interface_Function = TCP_Server_Run;
                            global interface_Function_name_str = "interface_TCP_Server";

                            global do_Function_name_str_Request = "do_Request";
                            global do_Function_Request = do_Request;
                            # global do_Function = do_Request;
                        end

                        if ARGSValue === "http_Server"
                            global interface_Function = http_Server_Run;
                            global interface_Function_name_str = "interface_http_Server";

                            global do_Function_name_str_Request = "do_Request";
                            global do_Function_Request = do_Request;
                            # global do_Function = do_Request;
                        end

                        if ARGSValue === "TCP_Client"
                            global interface_Function = TCP_Client;
                            global interface_Function_name_str = "interface_TCP_Client";

                            global do_Function_name_str_Response = "do_Response";
                            global do_Function_Response = do_Response;
                            # global do_Function = do_Response;
                        end

                        if ARGSValue === "http_Client"
                            global interface_Function = http_Client;
                            global interface_Function_name_str = "interface_http_Client";

                            global do_Function_name_str_Response = "do_Response";
                            global do_Function_Response = do_Response;
                            # global do_Function = do_Response;
                        end

                        # print("interface Function: ", interface_Function_name_str, "\n");
                        # print("do Function: ", do_Function_name_str_Request, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "is_monitor"
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global is_monitor = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                        # print("is monitor: ", is_monitor, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "monitor_file"
                        global monitor_file = ARGSValue;  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                        # print("monitor file: ", monitor_file, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "monitor_dir"
                        global monitor_dir = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                        # print("monitor dir: ", monitor_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "output_dir"
                        global output_dir = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                        # print("output dir: ", output_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "output_file"
                        global output_file = ARGSValue;  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Julia.txt";
                        # print("output file: ", output_file, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "temp_cache_IO_data_dir"
                        global temp_cache_IO_data_dir = ARGSValue;  # 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 Base.@__DIR__;
                        # print("Temporary cache IO data directory: ", temp_cache_IO_data_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "to_executable"
                        global to_executable = ARGSValue;  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                        # print("to executable: ", to_executable, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "to_script"
                        global to_script = ARGSValue;  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                        # print("to script: ", to_script, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "time_sleep"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global time_sleep = Base.parse(Core.Float64, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的長整型(Core.UInt64)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
                        # print("time sleep: ", time_sleep, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "number_Worker_threads"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global number_Worker_threads = Base.parse(UInt8, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(UInt8)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("number Worker threads: ", number_Worker_threads, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "isMonitorThreadsOrProcesses"
                        global isMonitorThreadsOrProcesses = ARGSValue;  # 0 || "0" || "Multi-Threading" || "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isMonitorThreadsOrProcesses: ", isMonitorThreadsOrProcesses, "\n");
                        # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                        # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                        continue;
                    end

                    if ARGSIArray[1] === "isDoTasksOrThreads"
                        global isDoTasksOrThreads = ARGSValue;  # "Tasks" || "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isDoTasksOrThreads: ", isDoTasksOrThreads, "\n");
                        # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        continue;
                    end

                    if ARGSIArray[1] === "do_Function"

                        if ARGSValue === "do_data"

                            # 使用函數 Base.@isdefined(do_data) 判斷 do_data 變量是否已經被聲明過;
                            if Base.@isdefined(do_data)
                                # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_data) <: Function
                                    global do_Function = do_data;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_data)) > 0
                            #         global do_Function = do_data;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        if ARGSValue === "do_Request"

                            # 使用函數 Base.@isdefined(do_Request) 判斷 do_Request 變量是否已經被聲明過;
                            if Base.@isdefined(do_Request)
                                # 使用 Core.isa(do_Request, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判別 do_Request 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_Request) <: Function
                                    global do_Function = do_Request;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_Request)) > 0
                            #         global do_Function = do_Request;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        if ARGSValue === "do_Response"

                            # 使用函數 Base.@isdefined(do_Response) 判斷 do_Response 變量是否已經被聲明過;
                            if Base.@isdefined(do_Response)
                                # 使用 Core.isa(do_Response, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判別 do_Response 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_Response) <: Function
                                    global do_Function = do_Response;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_Response)) > 0
                            #         global do_Function = do_Response;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        # if ARGSValue !== "do_data" && ARGSValue !== "do_data"
                        #     # global do_Function = Core.nothing;  # 置空;
                        #     global do_Function = (argument) -> argument;  # 匿名函數，直接返回傳入參數做返回值;
                        # end

                        # print("do Function: ", do_Function, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "webPath"
                        global webPath = ARGSValue;  # 用於輸入服務器的根目錄 "../";
                        # print("webPath: ", webPath, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "host"
                        global host = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/";
                        if Base.string(host) === "::0" || Base.string(host) === "::1" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "1"
                            # || CheckIP(Base.string(host)) === "IPv6"
                            global host = Sockets.IPv6(host);  # Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::0" or "::1" or "localhost"; 監聽主機域名 Host domain name;
                        elseif Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
                            # || CheckIP(Base.string(host)) === "IPv4"
                            global host = Sockets.IPv4(host);  # Sockets.IPv4("0.0.0.0");  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
                        elseif Base.string(host) === "localhost"
                            global host = Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
                        else
                            println("Error: host IP [ " * Base.string(host) * " ] unrecognized.");
                            # return false
                        end
                        # print("host: ", Base.string(host), "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "IPVersion"
                        global IPVersion = ARGSValue;  # "IPv6"、"IPv4";
                        # print("IP Version: ", IPVersion, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "port"
                        global port = ARGSValue;  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
                        global port = Base.parse(Core.UInt64, port);
                        # print("port: ", Base.string(port), "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "key"
                        if Base.string(ARGSValue) === "nothing" || Base.string(ARGSValue) === ""
                            global key = "";
                            # global key = Core.nothing;
                        else
                            global key = Base.string(ARGSValue);  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                        end
                        # print("key: ", key, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "session"
                        # global session = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
                        # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
                        g = Base.Meta.parse("session=" * Base.string(ARGSValue));
                        Base.MainInclude.eval(g);
                        # print("session: ", session, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "isConcurrencyHierarchy"
                        global isConcurrencyHierarchy = ARGSValue;  # "Tasks" || "Multi-Threading" || "Multi-Processes"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
                        # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                        # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                        continue;
                    end

                    if ARGSIArray[1] === "Authorization"
                        global Authorization = ARGSValue;  # 客戶端發送的請求頭中的 Authorizater 參數值;
                        # print("Authorization: ", Authorization, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "Cookie"
                        global Cookie = ARGSValue;  # 客戶端發送的請求頭中的 Cookie 參數值;
                        # print("Cookie: ", Cookie, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "URL"
                        global URL = ARGSValue;
                        # print("URL: ", URL, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "proxy"
                        global proxy = ARGSValue;
                        # print("Proxy: ", proxy, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "Referrer"
                        global Referrer = ARGSValue;
                        # print("Referrer: ", Referrer, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "query"
                        # https://github.com/JuliaIO/JSON.jl
                        # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
                        # s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
                        # j = JSONparse(s)  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # # j = JSON.parse(s)  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # Dict{AbstractString,Any} with 2 entries:
                        #     "an_array" => {"string",9}
                        #     "a_number" => 5.0
                        global query = JSONparse(ARGSValue);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # global query = JSON.parse(ARGSValue);  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # print("query: ", ARGSValue, "\n");
                        # print("query: ", "\n");
                        # print(query);
                        continue;
                    end

                    if ARGSIArray[1] === "readtimeout"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global readtimeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("Read Timeout: ", readtimeout, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "connecttimeout"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global connect_timeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("Connect Timeout: ", connect_timeout, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "verbose"
                        # global verbose = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global verbose = Base.parse(Core.Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                        # print("verbose: ", verbose, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestFrom"
                        global requestFrom = ARGSValue;  # 客戶端發送的請求頭中的 From 參數值;
                        # print("requestFrom: ", requestFrom, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestPath"
                        global requestPath = ARGSValue;
                        # print("requestPath: ", requestPath, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestMethod"
                        global requestMethod = ARGSValue;
                        # print("requestMethod: ", requestMethod, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestProtocol"
                        global requestProtocol = ARGSValue;
                        # print("requestProtocol: ", requestProtocol, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "postData"
                        # global postData = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
                        # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
                        # g = Base.Meta.parse("postData=" * Base.string(ARGSValue));
                        # Base.MainInclude.eval(g);
                        global postData = Base.string(ARGSValue);
                        # print("postData: ", postData, "\n");
                        continue;
                    end
                end
            end
        end
    end
end

result_Array = Core.nothing;
# result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
if interface_Function_name_str === "file_Monitor" || interface_Function_name_str === "interface_File_Monitor"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        is_monitor = is_monitor,  # 用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
        monitor_file = monitor_file,  # 用於接收傳值的媒介文檔;
        monitor_dir = monitor_dir,  # 用於輸入傳值的媒介目錄;
        do_Function = do_Function_data,  # do_Function,  # 用於接收執行數據處理功能的函數;
        output_dir = output_dir,  # 用於輸出傳值的媒介目錄;
        output_file = output_file,  # 用於輸出傳值的媒介文檔;
        to_executable = to_executable,  # 用於對返回數據執行功能的解釋器二進制可執行檔;
        to_script = to_script,  # 用於對返回數據執行功能的被調用的脚本文檔;
        temp_cache_IO_data_dir = temp_cache_IO_data_dir,  # 用於暫存傳入傳出數據的臨時媒介文件夾;
        number_Worker_threads = number_Worker_threads,  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目;
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        read_file_do_Function = read_file_do_Function,  # 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
        monitor_file_do_Function = monitor_file_do_Function,  # 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
        isMonitorThreadsOrProcesses = isMonitorThreadsOrProcesses,  # 0 || "0" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        isDoTasksOrThreads = isDoTasksOrThreads # "Tasks" || "Multi-Threading"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "tcp_Server" || interface_Function_name_str === "interface_TCP_Server"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        do_Function = do_Function_Request,  # do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
        key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
        session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
        number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
        TCP_Server = TCP_Server
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "http_Server" || interface_Function_name_str === "interface_http_Server"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        do_Function = do_Function_Request,  # do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
        key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
        session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
        number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        readtimeout = readtimeout,  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
        verbose = verbose,  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
        isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
        http_Server = http_Server
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "tcp_Client" || interface_Function_name_str === "interface_TCP_Client"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = TCP_Client(
        host,  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        IPVersion=IPVersion,  # "IPv6"、"IPv4";
        postData=postData,  # ::Core.Union{Core.String, Base.Dict} = "";  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
        URL=URL,  # ::Core.String = "",
        requestPath=requestPath,  # ::Core.String = "/",
        requestMethod=requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
        requestProtocol=requestProtocol,  # ::Core.String = "HTTP",
        # time_out=time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        Authorization=Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
        Cookie=Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
        requestFrom=requestFrom,  # ::Core.String = "user@email.com",
        # do_Function=do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
        # session=session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => TCP_Server.key),  # 保存網站的 Session 數據;
        # number_Worker_threads=number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        # time_sleep=time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        # isConcurrencyHierarchy=isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict=worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number=total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
    result = do_Function_Response(result_Array);
    # println(result);
elseif interface_Function_name_str === "http_Client" || interface_Function_name_str === "interface_http_Client"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = http_Client(
        host,  # ::Core.String,  # "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
        port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String};  # 0 ~ 65535，監聽埠號（端口）;
        IPVersion = IPVersion,  # "IPv6"、"IPv4";
        postData = postData,  # ::Core.Union{Core.String, Base.Dict} = "",  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
        proxy = proxy,  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
        requestPath = requestPath,  # ::Core.String = "/",
        requestProtocol = requestProtocol,  # ::Core.String = "HTTP",
        query = query,  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
        URL = URL,  # ::Core.String = "",  # Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  # 請求網址 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
        requestMethod = requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
        # time_out = time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        readtimeout = readtimeout,  # ::Core.Int = Core.Int(0),  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
        connect_timeout = connect_timeout,  # ::Core.Int = Core.Int(30),  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
        Authorization = Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
        Basicbasicauth = Basicbasicauth,  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
        Cookie = Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
        Referrer = Referrer,  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
        requestFrom = requestFrom,  # ::Core.String = "user@email.com",
        # do_Function = do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
        # session = session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => http_Server.key),  # 保存網站的 Session 數據;
        # number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        # time_sleep = time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        # isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        response_stream = response_stream,  # Core.nothing,  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
        cookiejar = cookiejar  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
    result = do_Function_Response(result_Array);
    # println(result);
else
end
# # result_Array = interface_Function();
# println(typeof(result_Array));
# println(result_Array[1]);
# println(result_Array[2]);
# println(result_Array[3]);

# 需要先加載 Julia 原生的 Dates 模組：using Dates;
# 函數 Dates.now() 返回當前日期時間對象 2021-06-28T12:12:50.544，使用 Base.string(Dates.now()) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50.544。
# 函數 Dates.time() 當前日期時間的 Unix 值 1.652232489777e9，UNIX 時間，或稱爲 POSIX 時間，是 UNIX 或類 UNIX 系統使用的時間表示方式：從 UTC 1970 年 1 月 1 日 0 時 0 分 0 秒起至現在的縂秒數，不考慮閏秒。
# 函數 Dates.unix2datetime(Dates.time()) 將 Unix 時間轉化爲日期（時間）對象，使用 Base.string(Dates.unix2datetime(Dates.time())) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50。
return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
# println(Base.string(Dates.now()))

result_text = "";
if interface_Function_name_str === "file_Monitor" || interface_Function_name_str === "interface_File_Monitor"

    if is_monitor === true
        result_text = "code:0";
    end

    if is_monitor === false
        if Base.typeof(result_Array) <: Core.Array && Base.length(result_Array) >= 3 && Core.isa(result_Array[2], Core.String) && Core.isa(result_Array[3], Core.String) && Core.isa(do_Function_name_str_data, Core.String) && do_Function_name_str_data !== ""
            return_info_JSON = Base.Dict{Core.String, Core.Any}(
                "Server_say" => Base.Dict{Core.String, Core.Any}(
                    "output_file" => Base.string(result_Array[2]),
                    "monitor_file" => Base.string(result_Array[3]),
                    "do_Function" => Base.string(do_Function_name_str_data)
                ),
                "time" => Base.string(return_file_creat_time)
            );
            result_text = join(Base.string(["code:0", JSONstring(return_info_JSON)]), "\n");
            # result_text = '{"Server_say":{"output_file":"' * Base.string(result_Array[2]) * '","monitor_file":"' * Base.string(result_Array[3]) * '","do_Function":"' * Base.string(do_Function_name_str_data) * '"},"time":"' * Base.string(return_file_creat_time) * '"}'
        elseif Base.typeof(result_Array) <: Core.Array && Base.length(result_Array) >= 3 && Core.isa(result_Array[2], Core.String) && Core.isa(result_Array[3], Core.String)
            return_info_JSON = Base.Dict{Core.String, Core.Any}(
                "Server_say" => Base.Dict{Core.String, Core.Any}(
                    "output_file" => Base.string(result_Array[2]),
                    "monitor_file" => Base.string(result_Array[3]),
                    "do_Function" => ""
                ),
                "time" => Base.string(return_file_creat_time)
            );
            result_text = join(Base.string(["code:0", JSONstring(return_info_JSON)]), "\n");
            # result_text = '{"Server_say":{"output_file":"' * Base.string(result_Array[2]) * '","monitor_file":"' * Base.string(result_Array[3]) * '","do_Function":""},"time":"' * Base.string(return_file_creat_time) * '"}'
        else
            result_text = "code:-1";
        end
    end

elseif interface_Function_name_str === "tcp_Server" || interface_Function_name_str === "interface_TCP_Server"
    result_text = "code:0";
elseif interface_Function_name_str === "http_Server" || interface_Function_name_str === "Interface_http_Server"
    result_text = "code:0";
elseif interface_Function_name_str === "tcp_Client" || interface_Function_name_str === "interface_TCP_Client"
    # println(JSONparse(result_Array[3]));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
    # result_text = join(Base.string(["code:0", JSONstring(result_Array)]), "\n");
    # result_text = JSONstring(result_Array);
    result_text = "code:0";
elseif interface_Function_name_str === "http_Client" || interface_Function_name_str === "interface_http_Client"
    # println(JSONparse(result_Array[3]));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
    # result_text = join(Base.string(["code:0", JSONstring(result_Array)]), "\n");
    # result_text = JSONstring(result_Array);
    result_text = "code:0";
else
end
# 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
println(result_text);  # 將運算結果寫到操作系統控制臺;
