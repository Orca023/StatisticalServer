# Julia_exe_path::Core.String = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(Base.Sys.BINDIR)), "julia.exe")), "\\" => "/"));  # C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe
# println(Julia_exe_path);  # C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe
# Julia_program_path::Core.String = Base.string(Base.replace(Base.string(Base.dirname(Base.Filesystem.abspath(Base.active_project()))), "\\" => "/"));  # C:/StatisticalServer/StatisticalServerJulia/
# println(Julia_program_path);  # C:/StatisticalServer/StatisticalServerJulia/
# Julia_script_path::Core.String = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.Filesystem.abspath(Base.@__FILE__))), "Quantitative_Data_Cleaning.jl")), "\\" => "/"));  # C:/StatisticalServer/StatisticalServerJulia/src/Quantitative_Data_Cleaning.jl
# println(Julia_script_path);  # C:/StatisticalServer/StatisticalServerJulia/src/Quantitative_Data_Cleaning.jl


#################################################################################;

# Title: Julia statistical algorithm server v20161211
# Explain: Julia market timing, Julia pick stock, Julia size position, Julia back testing, Julia indicators, Julia data cleaning
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在壬寅
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: julia-1.9.3-win64.exe
# Interpreter: julia-1.10.3-linux-x86_64.tar.gz
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: julia-1.10.3-linux-aarch64.tar.gz

# 使用説明：
# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
# Base.MainInclude.include("/home/QuantitativeTrading/QuantitativeTradingJulia/Quantitative_Data_Cleaning.jl");
# Base.MainInclude.include("C:/QuantitativeTrading/QuantitativeTradingJulia/Quantitative_Data_Cleaning.jl");
# Base.MainInclude.include("./Quantitative_Data_Cleaning.jl");

# 控制臺命令列運行指令：
# C:\> C:/QuantitativeTrading/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/QuantitativeTrading/QuantitativeTradingJulia/ C:/QuantitativeTrading/QuantitativeTradingJulia/src/Quantitative_Data_Cleaning.jl configFile=C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt input_K_Line=C:/QuantitativeTrading/Data/K-Day-source/ is_save_JLD=true output_jld_K_Line=C:/QuantitativeTrading/Data/steppingData.jld is_save_csv=false output_csv_K_Line=C:/QuantitativeTrading/Data/K-Day/ is_save_xlsx=false output_xlsx_K_Line=C:/QuantitativeTrading/Data/K-Day/
# root@localhost:~# /usr/julia/julia-1.10.3/bin/julia -p 4 --project=/home/QuantitativeTrading/QuantitativeTradingJulia/ /home/QuantitativeTrading/QuantitativeTradingJulia/src/Quantitative_Data_Cleaning.jl configFile=/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt input_K_Line=/home/QuantitativeTrading/Data/K-Day-source/ is_save_JLD=false output_jld_K_Line=/home/QuantitativeTrading/Data/steppingData.jld is_save_csv=false output_csv_K_Line=/home/QuantitativeTrading/Data/K-Day/ is_save_xlsx=false output_xlsx_K_Line=/home/QuantitativeTrading/Data/K-Day/

#################################################################################;


module Quantitative_Data_Cleaning  # 將本 Quantitative_Data_Cleaning.jl 脚本文檔定義爲一個模組（Module），可以被另一個 .jl 文檔使用 import .Quantitative_Data_Cleaning 方法導入的模組（Module）;
# Main.Quantitative_Data_Cleaning
# 對外部暴露顯示本模組内的變量值，允許其讀取與寫入操作;
export input_K_Line_Daily_file;
export is_save_JLD;
export output_jld_K_Line_Daily_file;
export is_save_csv;
export output_csv_K_Line_Daily_file_dir;
export is_save_xlsx;
export output_xlsx_K_Line_Daily_file_dir;
export configFile;
export stepping_data;


# 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;
Base.push!(LOAD_PATH, ".")  # 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;
# Base.push!(LOAD_PATH, Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.abspath(Base.@__FILE__))), "Quantitative_Data_Cleaning.jl")), "\\" => "/")));  # C:/StatisticalServer/StatisticalServerJulia/Quantitative_Data_Cleaning.jl
# Base.MainInclude.include(Base.filter(Base.contains(r".*\.jl$"), Base.Filesystem.readdir()));  # 在 Jupyterlab 中實現加載 Base.MainInclude.include("*.jl") 文檔，其中 r".*\.jl$" 為解析脚本文檔名的正則表達式;
# Base.MainInclude.include(popfirst!(ARGS));
# println(Base.PROGRAM_FILE)


using Statistics;  # 導入 Julia 的原生標準模組「Statistics」，用於數據統計計算;
using Dates;  # 導入 Julia 的原生標準模組「Dates」，用於處理時間和日期數據，也可以用全名 Main.Dates. 訪問模組内的方法（函數）;
using Distributed;  # 導入 Julia 的原生標準模組「Distributed」，用於提供并行化和分佈式功能;
# using Sockets;  # 導入 Julia 的原生標準模組「Sockets」，用於創建 TCP server 服務器;
# using Base64;  # 導入 Julia 的原生標準模組「Base64」，用於按照 Base64 方式編解碼字符串;
# using SharedArrays;

# Distributed.@everywhere using Dates, Distributed, Sockets, Base64;  # SharedArrays;  # 使用廣播關鍵字 Distributed.@everywhere 在所有子進程中加載指定模組或函數或變量;

# https://discourse.juliacn.com/t/topic/2969
# 如果想臨時更換pkg工具下載鏡像源，在julia解釋器環境命令行輸入命令：
# julia> ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
# 或者：
# Windows Powershell: $env:JULIA_PKG_SERVER = 'https://pkg.julialang.org'
# Linux/macOS Bash: export JULIA_PKG_SERVER="https://pkg.julialang.org"
# using Gadfly;  # 導入第三方擴展包「Gadfly」，用於繪圖，需要在控制臺先安裝第三方擴展包「Gadfly」：julia> using Pkg; Pkg.add("Gadfly") 成功之後才能使用;
# using Cairo;  # 導入第三方擴展包「Cairo」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Cairo」：julia> using Pkg; Pkg.add("Cairo") 成功之後才能使用;
# using Fontconfig;  # 導入第三方擴展包「Fontconfig」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Fontconfig」：julia> using Pkg; Pkg.add("Fontconfig") 成功之後才能使用;
# using Plots;  # 導入第三方擴展包「Plots」，用於繪圖，需要在控制臺先安裝第三方擴展包「Plots」：julia> using Pkg; Pkg.add("Plots") 成功之後才能使用;
using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# https://github.com/JuliaIO/JLD.jl
# using HDF5;
# # https://github.com/JuliaIO/HDF5.jl
using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# https://github.com/JuliaIO/JSON.jl
using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# https://github.com/JuliaData/CSV.jl
# https://csv.juliadata.org/stable/
using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# https://github.com/felipenoris/XLSX.jl
# https://felipenoris.github.io/XLSX.jl/stable/
# using Optim;  # 導入第三方擴展包「Optim」，用於通用形式優化問題求解（optimization），需要在控制臺先安裝第三方擴展包「Optim」：julia> using Pkg; Pkg.add("Optim") 成功之後才能使用;
# # https://julianlsolvers.github.io/Optim.jl/stable/
# # https://github.com/JuliaNLSolvers/Optim.jl
# using JuMP;  # 導入第三方擴展包「JuMP」，用於帶有約束條件的通用形式優化問題求解（optimization），需要在控制臺先安裝第三方擴展包「JuMP」：julia> using Pkg; Pkg.add("JuMP") 成功之後才能使用;
# using Gurobi;  # 導入第三方擴展包「Gurobi」，用於 JuMP 調用的求解器（underlying solver）做缐性、整數、二次、混合整數等問題優化，需要在控制臺先安裝第三方擴展包「Gurobi」：julia> using Pkg; Pkg.add("Gurobi") 成功之後才能使用;
# using Ipopt;  # 導入第三方擴展包「Ipopt」，用於 JuMP 調用的求解器（underlying solver）做非缐性問題優化，需要在控制臺先安裝第三方擴展包「Ipopt」：julia> using Pkg; Pkg.add("Ipopt") 成功之後才能使用;
# using Cbc;  # 導入第三方擴展包「Cbc」，用於 JuMP 調用的求解器（underlying solver）做整數、混合整數問題優化，需要在控制臺先安裝第三方擴展包「Cbc」：julia> using Pkg; Pkg.add("Cbc") 成功之後才能使用;
# using GLPK;  # 導入第三方擴展包「GLPK」，用於 JuMP 調用的求解器（underlying solver）做缐性問題優化，需要在控制臺先安裝第三方擴展包「GLPK」：julia> using Pkg; Pkg.add("GLPK") 成功之後才能使用;
# # https://jump.dev/
# # https://jump.dev/JuMP.jl/stable/
# # https://github.com/jump-dev/JuMP.jl
# using LsqFit;  # 導入第三方擴展包「LsqFit」，用於任意形式曲缐方程擬合（Curve Fitting），需要在控制臺先安裝第三方擴展包「LsqFit」：julia> using Pkg; Pkg.add("LsqFit") 成功之後才能使用;
# # https://julianlsolvers.github.io/LsqFit.jl/latest/
# # https://github.com/JuliaNLSolvers/LsqFit.jl
# using Interpolations;  # 導入第三方擴展包「Interpolations」，用於插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「Interpolations」：julia> using Pkg; Pkg.add("Interpolations") 成功之後才能使用;
# # https://juliamath.github.io/Interpolations.jl/stable/
# # https://github.com/JuliaMath/Interpolations.jl/
# using DataInterpolations;  # 導入第三方擴展包「DataInterpolations」，用於一維（1 Dimension）插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「DataInterpolations」：julia> using Pkg; Pkg.add("DataInterpolations") 成功之後才能使用;
# # https://github.com/SciML/DataInterpolations.jl
# using NLsolve;  # 導入第三方擴展包「NLsolve」，用於求解任意形式多元非缐性方程組，需要在控制臺先安裝第三方擴展包「NLsolve」：julia> using Pkg; Pkg.add("NLsolve") 成功之後才能使用;
# # https://github.com/JuliaNLSolvers/NLsolve.jl
# using Roots;  # 導入第三方擴展包「Roots」，用於求解任意形式一元非缐性方程，需要在控制臺先安裝第三方擴展包「Roots」：julia> using Pkg; Pkg.add("Roots") 成功之後才能使用;
# # https://juliamath.github.io/Roots.jl/stable
# # https://github.com/JuliaMath/Roots.jl
# using ForwardDiff;  # 導入第三方擴展包「ForwardDiff」，用於任意形式一元方程數值微分（自動微分）計算，需要在控制臺先安裝第三方擴展包「ForwardDiff」：julia> using Pkg; Pkg.add("ForwardDiff") 成功之後才能使用;
# # https://juliadiff.org/ForwardDiff.jl/stable/
# # https://github.com/JuliaDiff/ForwardDiff.jl
# using Calculus;  # 導入第三方擴展包「Calculus」，用於任意形式多元方程數值微分（自動微分）計算，需要在控制臺先安裝第三方擴展包「Calculus」：julia> using Pkg; Pkg.add("Calculus") 成功之後才能使用;
# # https://github.com/JuliaMath/Calculus.jl
# using Cubature;  # 導入第三方擴展包「Cubature」，用於任意形式多元方程數值積分（自動積分）計算，需要在控制臺先安裝第三方擴展包「Cubature」：julia> using Pkg; Pkg.add("Cubature") 成功之後才能使用;
# # https://github.com/JuliaMath/Cubature.jl
# using DifferentialEquations;  # 導入第三方擴展包「DifferentialEquations」，用於求解任意形式微分方程，需要在控制臺先安裝第三方擴展包「DifferentialEquations」：julia> using Pkg; Pkg.add("DifferentialEquations") 成功之後才能使用;
# # https://docs.sciml.ai/DiffEqDocs/stable/
# # https://github.com/SciML/DifferentialEquations.jl
# using Symbolics;  # 導入第三方擴展包「Symbolics」，用於符號計算，需要在控制臺先安裝第三方擴展包「Symbolics」：julia> using Pkg; Pkg.add("Symbolics") 成功之後才能使用;
# # https://symbolics.juliasymbolics.org/stable/
# # https://github.com/JuliaSymbolics/Symbolics.jl
# using SymPy;  # 導入第三方擴展包「SymPy」，用於符號計算，需要在控制臺先安裝第三方擴展包「SymPy」：julia> using Pkg; Pkg.add("SymPy") 成功之後才能使用;
# # https://jverzani.github.io/SymPyCore.jl/dev/
# # https://github.com/JuliaPy/SymPy.jl
# using TimeSeries;  # 導入第三方擴展包「TimeSeries」，用於連續型數據（continuous）的時間序列（Time Series）分析，需要在控制臺先安裝第三方擴展包「TimeSeries」：julia> using Pkg; Pkg.add("TimeSeries") 成功之後才能使用;
# # https://juliastats.org/TimeSeries.jl/latest/
# # https://github.com/JuliaStats/TimeSeries.jl
# using CountTimeSeries;  # 導入第三方擴展包「CountTimeSeries」，用於離散型數據（discrete）的時間序列（Time Series）分析，需要在控制臺先安裝第三方擴展包「CountTimeSeries」：julia> using Pkg; Pkg.add("CountTimeSeries") 成功之後才能使用;
# # https://github.com/ManuelStapper/CountTimeSeries.jl
# # https://github.com/ManuelStapper/CountTimeSeries.jl/blob/master/CountTimeSeries_documentation.pdf

# # https://github.com/JuliaIO/JSON.jl
# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# 自定義封裝的函數 JSONstring(Dict_Array) 將 Julia 字典（Dict）或一維數組（Array）對象轉換爲一個 JSON 格式的字符串;
# 注意，最多只能有 5 級字典（Dict）或一維數組（Array）對象嵌套，例如可以接受：{{{{}}}} 或者 [[[[]]]] 或者 {[{[]}]}  或者 [{[{}]}] 格式都可以轉換;
function JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
    return JSON.json(Dict_Array);
end
# 自定義封裝的函數 JSONparse(JSON_string) 將 JSON 格式的字符串轉換爲一個 Julia 字典（Dict）或一維數組（Array）對象;
# 注意，字符串中不能有 JSON 對象 {} 的嵌套，例如，不可以傳入 {{}} 格式的字符串，可以有 2 級一維數組對象 [] 的嵌套，例如，可以傳入 [[]] 格式的字符串，還可以傳入 {[[]]} 或者 [[[]]]  或者 [{[[]]}] 格式都可以轉換;
function JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}
    return JSON.parse(JSON_string);
end


Distributed.@everywhere using XLSX, CSV, JSON, JLD, Statistics, Gadfly, Cairo, Fontconfig;

# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
# Base.MainInclude.include("./Statis_Descript.jl");
# Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Statis_Descript.jl"));
# Base.Filesystem.joinpath(Base.@__DIR__, "Statis_Descript.jl")
# Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Statis_Descript.jl")
# Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Statis_Descript.jl")

# 匯入自定義的量化交易指標計算模組脚本文檔「./Quantitative_Indicators.jl」;
Base.MainInclude.include("./Quantitative_Indicators.jl");
# Base.MainInclude.include(Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.@__FILE__)), "Quantitative_Indicators.jl")), "\\" => "/")));  # "C:/StatisticalServer/StatisticalServerJulia/src/Quantitative_Indicators.jl"
# println(Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.@__FILE__)), "Quantitative_Indicators.jl")), "\\" => "/")));
# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["ticker_symbol"]["close_price"],  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Bool, Core.Nothing, Base.Missing}, 1},
#     Core.Int64(3);  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# );
# println("closing price growth rate", return_Intuitive_Momentum);
# return_Intuitive_Momentum_KLine = Intuitive_Momentum_KLine(
#     Base.Dict{Core.String, Core.Any}(
#         "date_transaction" => training_data["ticker_symbol"]["date_transaction"],  # 交易日期;
#         "turnover_volume" => training_data["ticker_symbol"]["turnover_volume"],  # 成交量;
#         # "turnover_amount" => training_data["ticker_symbol"]["turnover_amount"],  # 成交總金額;
#         "opening_price" => training_data["ticker_symbol"]["opening_price"],  # 開盤成交價;
#         "close_price" => training_data["ticker_symbol"]["close_price"],  # 收盤成交價;
#         "low_price" => training_data["ticker_symbol"]["low_price"],  # 最低成交價;
#         "high_price" => training_data["ticker_symbol"]["high_price"],  # 最高成交價;
#         # "focus" => training_data["ticker_symbol"]["focus"],  # 當日成交價重心;
#         # "amplitude" => training_data["ticker_symbol"]["amplitude"],  # 當日成交價絕對振幅;
#         # "amplitude_rate" => training_data["ticker_symbol"]["amplitude_rate"],  # 當日成交價相對振幅（%）;
#         # "opening_price_Standardization" => training_data["ticker_symbol"]["opening_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
#         # "closing_price_Standardization" => training_data["ticker_symbol"]["closing_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
#         # "low_price_Standardization" => training_data["ticker_symbol"]["low_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
#         # "high_price_Standardization" => training_data["ticker_symbol"]["high_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
#         "turnover_volume_growth_rate" => training_data["ticker_symbol"]["turnover_volume_growth_rate"],  # 成交量的成長率;
#         "opening_price_growth_rate" => training_data["ticker_symbol"]["opening_price_growth_rate"],  # 開盤價的成長率;
#         "closing_price_growth_rate" => training_data["ticker_symbol"]["closing_price_growth_rate"],  # 收盤價的成長率;
#         "closing_minus_opening_price_growth_rate" => training_data["ticker_symbol"]["closing_minus_opening_price_growth_rate"],  # 收盤價減開盤價的成長率;
#         "high_price_proportion" => training_data["ticker_symbol"]["high_price_proportion"],  # 收盤價和開盤價裏的最大值占最高價的比例;
#         "low_price_proportion" => training_data["ticker_symbol"]["low_price_proportion"],  # 最低價占收盤價和開盤價裏的最小值的比例;
#         # "turnover_rate" => training_data["ticker_symbol"]["turnover_rate"],  # 成交量換手率;
#         # "price_earnings" => training_data["ticker_symbol"]["price_earnings"],  # 每股收益（公司經營利潤率 ÷ 股本）;
#         # "book_value_per_share" => training_data["ticker_symbol"]["book_value_per_share"],  # 每股净值（公司净資產 ÷ 股本）;
#         # "capitalization" => training_data["ticker_symbol"]["capitalization"]  # 總市值;
#     ),
#     Core.Int64(3);  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = Core.nothing,  # [Core.Float64(Core.Int64(j) / Core.Int64(P1)) for j in 1:Core.Int64(P1)],
#     Intuitive_Momentum = Intuitive_Momentum
# );
# println("turnover volume growth rate", return_Intuitive_Momentum_KLine["P1_turnover_volume_growth_rate"]);
# println("opening price growth rate", return_Intuitive_Momentum_KLine["P1_opening_price_growth_rate"]);
# println("closing price growth rate", return_Intuitive_Momentum_KLine["P1_closing_price_growth_rate"]);
# println("closing minus opening price growth rate", return_Intuitive_Momentum_KLine["P1_closing_minus_opening_price_growth_rate"]);
# println("high price proportion", return_Intuitive_Momentum_KLine["P1_high_price_proportion"]);
# println("low price proportion", return_Intuitive_Momentum_KLine["P1_low_price_proportion"]);
# println("intuitive momentum indicator", return_Intuitive_Momentum_KLine["P1_Intuitive_Momentum"]);
Intuitive_Momentum(
    Series_Array,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
) = Main.Intuitive_Momentum(
    Series_Array,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
);
Intuitive_Momentum_KLine(
    KLine_Series_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # ::Core.Array{Core.Float64, 2} = testing_data,  # ::Core.Array{Core.Float64, 2} = Core.Array{Core.Float64, 2}(undef, (0, 0)), # ::Core.Array{Core.Array{Core.Float64, 1}, 1} = Core.Array{Core.Array{Core.Float64, 1}, 1}(),
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight,
    Intuitive_Momentum,
) = Main.Intuitive_Momentum_KLine(
    KLine_Series_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # ::Core.Array{Core.Float64, 2} = testing_data,  # ::Core.Array{Core.Float64, 2} = Core.Array{Core.Float64, 2}(undef, (0, 0)), # ::Core.Array{Core.Array{Core.Float64, 1}, 1} = Core.Array{Core.Array{Core.Float64, 1}, 1}(),
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight,
    Intuitive_Momentum
);



# 測試集日棒缐（K Line Daily）數據標準化（Standardization）;
# ticker_symbol::Core.String = Base.string("002611");  # 流通代碼;
# shares_tradable::Core.UInt64 = Core.UInt64(200000);  # 可流通量;
# # date_transaction = Core.Array{Core.String, 1}();  # 交易日期;
# # date_transaction = Core.Array{Core.Any, 1}();  # 交易日期;
# # date_transaction = Core.Array{Dates.DateTime, 1}();  # 交易日期;
# date_transaction = Core.Array{Dates.Date, 1}();  # 交易日期;
# opening_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 交易日首筆成交價（開盤價）;
# close_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 交易日尾筆成交價（收盤價）;
# low_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 交易日最低成交價;
# high_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 交易日最高成交價;
# turnover_volume = Core.Array{Core.Union{Core.UInt64, Core.String, Core.Nothing}, 1}();  # 交易日總成交量;
# turnover_rate = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 交易日換手率;
# price_earnings = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 市盈率;
# book_value_per_share = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 净值;
# moving_average_5 = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 五日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_10 = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 十日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_20 = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 二十日尾筆成交價（收盤價）移動平均（Moving Average）;
# moving_average_30 = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 三十日尾筆成交價（收盤價）移動平均（Moving Average）;

# K_Line_Daily = Base.Dict{Core.String, Core.Any}(
#     Base.string(ticker_symbol) => Base.Dict{Core.String, Core.Any}(
#         "shares_tradable" => Core.UInt64(0),
#         # "date_transaction" => Core.Array{Dates.DateTime, 1}(),
#         "date_transaction" => Core.Array{Dates.Date, 1}(),
#         "opening_price" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "close_price" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "low_price" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "high_price" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "turnover_volume" => Core.Array{Core.Union{Core.UInt64, Core.String, Core.Nothing}, 1}(),
#         "turnover_rate" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "price_earnings" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "book_value_per_share" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "moving_average_5" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "moving_average_10" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "moving_average_20" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#         "moving_average_30" => Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}(),
#     )
# );

# K_Line_Daily = Base.Dict{Core.String, Core.Any}(
#     Base.string(ticker_symbol) => Base.Dict{Core.String, Core.Any}(
#         Base.string(date_transaction) => Base.Dict{Core.String, Core.Any}(
#             "opening_price" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "close_price" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "low_price" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "high_price" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "turnover_volume" => Core.Union{Core.UInt64, Core.String, Core.Nothing},
#             "turnover_rate" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "price_earnings" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "book_value_per_share" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "moving_average_5" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "moving_average_10" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "moving_average_20" => Core.Union{Core.Float16, Core.String, Core.Nothing},
#             "moving_average_30" => Core.Union{Core.Float16, Core.String, Core.Nothing}
#         ),
#     )
# );

# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
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

# # 將字符串（String）類型的日棒缐（K Line Daily）數據集，轉化爲 Julia 字典（Julia-Dictionary）類型的日棒缐（K Line Daily）數據集;
# input_K_Line_Daily_Dict = JSONparse(input_K_Line_Daily_String);
# # # 遍歷字典的鍵:值對;
# # for (key, value) in input_K_Line_Daily_Dict
# #     println("Key: $key, Value: $value");
# # end
# # # 遍歷字典的鍵;
# # for value in values(input_K_Line_Daily_Dict)
# #     println("Value: $value")
# # end
# # # 遍歷字典的值;
# # for key in keys(input_K_Line_Daily_Dict)
# #     println("Key: $key")
# # end

# # 創建日棒缐（K Line Daily）數據載體數組（Julia-Array）;
# date_transaction = Core.Array{Dates.Date, 1}();  # 測試集數據交易日期;
# opening_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日首筆成交價（開盤價）;
# close_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日尾筆成交價（收盤價）;
# low_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日最低成交價;
# high_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日最高成交價;
# turnover_volume = Core.Array{Core.Union{Core.UInt64, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日總成交量;
# turnover_rate = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據交易日換手率;
# price_earnings = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據市盈率;
# book_value_per_share = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing}, 1}();  # 測試集數據净值;

# # 從字典（Dictionary）類型的日棒缐（K Line Daily）數據集中逐個讀取數據;
# if Base.haskey(input_K_Line_Daily_Dict, "date_transaction") && Base.length(input_K_Line_Daily_Dict["date_transaction"]) > 0
#     date_transaction = input_K_Line_Daily_Dict["date_transaction"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "turnover_volume") && Base.length(input_K_Line_Daily_Dict["turnover_volume"]) > 0
#     turnover_volume = input_K_Line_Daily_Dict["turnover_volume"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "opening_price") && Base.length(input_K_Line_Daily_Dict["opening_price"]) > 0
#     opening_price = input_K_Line_Daily_Dict["opening_price"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "close_price") && Base.length(input_K_Line_Daily_Dict["close_price"]) > 0
#     close_price = input_K_Line_Daily_Dict["close_price"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "low_price") && Base.length(input_K_Line_Daily_Dict["low_price"]) > 0
#     low_price = input_K_Line_Daily_Dict["low_price"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "high_price") && Base.length(input_K_Line_Daily_Dict["high_price"]) > 0
#     high_price = input_K_Line_Daily_Dict["high_price"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "turnover_rate") && Base.length(input_K_Line_Daily_Dict["turnover_rate"]) > 0
#     turnover_rate = input_K_Line_Daily_Dict["turnover_rate"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "price_earnings") && Base.length(input_K_Line_Daily_Dict["price_earnings"]) > 0
#     price_earnings = input_K_Line_Daily_Dict["price_earnings"];
# end
# if Base.haskey(input_K_Line_Daily_Dict, "book_value_per_share") && Base.length(input_K_Line_Daily_Dict["book_value_per_share"]) > 0
#     book_value_per_share = input_K_Line_Daily_Dict["book_value_per_share"];
# end

# # 遍歷字典的鍵:值對;
# for (key, value) in input_K_Line_Daily_Dict
#     # println("Key: $key, Value: $value");
#     if Base.string(key) === Base.string("date_transaction")
#         date_transaction = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string(value[i]);
#         #         # # elseif value[i] <: Core.UInt
#         #         # #     # date_i = Core.UInt64(value[i]);
#         #         # #     # the_Unix_time = Dates.datetime2unix(now_day);  # 1.723206581518e9 seconds  # 轉換爲時間戳;
#         #         # #     # the_date_time = Dates.unix2datetime(the_Unix_time);  # 2024-08-09T12:29:41.518  # 將時間戳轉換爲時間對象;
#         #         # #     date_i = Dates.unix2datetime(value[i]);  # 將時間戳轉換爲時間對象;
#         #         # # elseif Core.isa(value[i], Dates.Date)
#         #         # #     date_i = Dates.Date(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(date_transaction, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     date_transaction = value;
#         # end
#     end
#     if Base.string(key) === Base.string("turnover_volume")
#         turnover_volume = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.UInt
#         #         # #     date_i = Core.UInt64(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(turnover_volume, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     turnover_volume = value;
#         # end
#     end
#     if Base.string(key) === Base.string("opening_price")
#         opening_price = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(opening_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     opening_price = value;
#         # end
#     end
#     if Base.string(key) === Base.string("close_price")
#         close_price = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(close_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     close_price = value;
#         # end
#     end
#     if Base.string(key) === Base.string("low_price")
#         low_price = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(low_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     low_price = value;
#         # end
#     end
#     if Base.string(key) === Base.string("high_price")
#         high_price = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(high_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     high_price = value;
#         # end
#     end
#     if Base.string(key) === Base.string("turnover_rate")
#         turnover_rate = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(turnover_rate, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     turnover_rate = value;
#         # end
#     end
#     if Base.string(key) === Base.string("price_earnings")
#         price_earnings = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(price_earnings, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     price_earnings = value;
#         # end
#     end
#     if Base.string(key) === Base.string("book_value_per_share")
#         book_value_per_share = value;
#         # if Base.typeof(value) <: Core.Array && Base.length(value) > 0
#         #     for i = 1:Base.length(value)
#         #         date_i = value[i];
#         #         # if Base.isnothing(value[i])
#         #         #     date_i = Core.nothing;
#         #         # elseif Core.isa(value[i], Core.String) && value[i] === ""
#         #         #     # Base.occursin("=", value[i])  # 判斷字符串中是否包含等號（"="）子字符串;
#         #         #     date_i = Base.string("");
#         #         # # elseif value[i] <: Core.Float
#         #         # #     date_i = Core.Float16(value[i]);
#         #         # else
#         #         #     date_i = value[i];
#         #         # end
#         #         Base.push!(book_value_per_share, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         #     end
#         # else
#         #     book_value_per_share = value;
#         # end
#     end
# end

# # 從字典（Dictionary）類型的日棒缐（K Line Daily）數據集中逐個讀取數據;
# if Base.isa(input_K_Line_Daily_Dict, Base.Dict) && Base.length(input_K_Line_Daily_Dict) > 0
#     # 遍歷字典的鍵:值對;
#     for (key, value) in in input_K_Line_Daily_Dict
#         # println("Key: $key, Value: $value");
#         date_i = key;
#         date_i = Dates.Date(date_i);
#         # if Core.isa(key, Core.String)
#         #     # key === "" # Base.occursin("=", key)  # 判斷字符串中是否包含等號（"="）子字符串;
#         #     date_i = key;
#         #     # date_i = Base.string(key);
#         #     date_i = Dates.Date(date_i);
#         # elseif key <: Core.UInt
#         #     # date_i = Core.UInt64(key);
#         #     # the_Unix_time = Dates.datetime2unix(now_day);  # 1.723206581518e9 seconds  # 轉換爲時間戳;
#         #     # the_date_time = Dates.unix2datetime(the_Unix_time);  # 2024-08-09T12:29:41.518  # 將時間戳轉換爲時間對象;
#         #     date_i = Dates.unix2datetime(key);  # 將時間戳轉換爲時間對象;
#         # elseif Core.isa(key, Dates.Date)
#         #     date_i = key;
#         # else
#         # end
#         Base.push!(date_transaction, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#         if Base.isa(value, Base.Dict) && Base.length(value) > 0
#             for (key_1, value_1) in value
#                 if Base.string(key_1) === Base.string("turnover_volume")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.UInt
#                     # #     date_i = Core.UInt64(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(turnover_volume, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("opening_price")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(opening_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("close_price")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(close_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("low_price")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(low_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("high_price")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(high_price, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("turnover_rate")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(turnover_rate, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("price_earnings")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(price_earnings, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#                 if Base.string(key_1) === Base.string("book_value_per_share")
#                     date_i = value_1;
#                     # if Base.isnothing(value_1)
#                     #     date_i = Core.nothing;
#                     # elseif Core.isa(value_1, Core.String) && value_1 === ""
#                     #     # Base.occursin("=", value_1)  # 判斷字符串中是否包含等號（"="）子字符串;
#                     #     date_i = Base.string("");
#                     # # elseif value_1 <: Core.Float
#                     # #     date_i = Core.Float16(value_1);
#                     # else
#                     #     date_i = value_1;
#                     # end
#                     Base.push!(book_value_per_share, date_i);  # 使用 push! 函數在數組末尾追加推入新元素;
#                 end
#             end
#         end
#     end
# end

# stepping_data = Base.Dict{Core.String, Core.Any}();
# stepping_data["date_transaction"] = date_transaction;
# stepping_data["turnover_volume"] = turnover_volume;
# stepping_data["opening_price"] = opening_price;
# stepping_data["close_price"] = close_price;
# stepping_data["low_price"] = low_price;
# stepping_data["high_price"] = high_price;
# stepping_data["turnover_rate"] = turnover_rate;
# stepping_data["price_earnings"] = price_earnings;
# stepping_data["book_value_per_share"] = book_value_per_share;

# # 嵌套的一維向量 Base.Vector[Base.Vector] 轉換為矩陣類型 Base.Matrix，同時對矩陣轉置;
# # (a, b) = Base.size(Xdata);
# a = Base.length(Xdata);
# b = Base.length(Xdata[1]);
# Xdata_matrix = Core.Array{Core.Float64, 2}(undef, (b, a));  # Core.Array{Core.Array{Core.Float64, 1}, 1}();
# # Xdata_matrix = Xdata';
# for i = 1:Base.length(Xdata)
#     # temp = Core.Array{Core.Float64, 1}();
#     for j = 1:Base.length(Xdata[i])
#         Xdata_matrix[j, i] = Xdata[i][j];
#         # Base.push!(temp, Xdata[i][j]);  # 使用 push! 函數在數組末尾追加推入新元素;
#     end
#     # Base.push!(Xdata_matrix, temp);  # 使用 push! 函數在數組末尾追加推入新元素;
# end
# Ydata_matrix = Core.nothing;
# if Core.Int64(Base.length(Ydata)) > Core.Int64(0) && Core.Int64(Base.length(Ydata)) === Core.Int64(Base.length(Xdata))
#     # (c, d) = Base.size(Ydata);
#     c = Base.length(Ydata);
#     d = Base.length(Ydata[1]);
#     Ydata_matrix = Core.Array{Core.Float64, 2}(undef, (d, c));  # Core.Array{Core.Array{Core.Float64, 1}, 1}();
#     # Ydata_matrix = Ydata';
#     for i = 1:Base.length(Ydata)
#         # temp = Core.Array{Core.Float64, 1}();
#         for j = 1:Base.length(Ydata[i])
#             Ydata_matrix[j, i] = Ydata[i][j];
#             # Base.push!(temp, Ydata[i][j]);  # 使用 push! 函數在數組末尾追加推入新元素;
#         end
#         # Base.push!(Ydata_matrix, temp);  # 使用 push! 函數在數組末尾追加推入新元素;
#     end
# end

# 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值;
input_K_Line_Daily_Data_String::Core.String = "";  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值;

# 預設參數初值;
input_K_Line_Daily_file::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.dirname(Base.@__FILE__)))), "Data", "K-Day-source"));
input_K_Line_Daily_file = "";
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/";
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv";
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
# print(input_K_Line_Daily_file, "\n");
is_save_JLD = false;  # true or false;
output_jld_K_Line_Daily_file::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.dirname(Base.@__FILE__)))), "Data", "steppingData.jld"));  # "C:/QuantitativeTrading/Data/steppingData.jld";
output_jld_K_Line_Daily_file = "";
# print(output_jld_K_Line_Daily_file, "\n");
is_save_csv = false;  # true or false;
output_csv_K_Line_Daily_file_dir::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.dirname(Base.@__FILE__)))), "Data", "K-Day"));  # "C:/QuantitativeTrading/Data/K-Day/";
output_csv_K_Line_Daily_file_dir = "";
# print(output_csv_K_Line_Daily_file_dir, "\n");
is_save_xlsx = false;  # true or false;
output_xlsx_K_Line_Daily_file_dir::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.dirname(Base.@__FILE__)))), "Data", "K-Day"));  # "C:/QuantitativeTrading/Data/K-Day/";
output_xlsx_K_Line_Daily_file_dir = "";
# print(output_xlsx_K_Line_Daily_file_dir, "\n");

# 從配置文檔（./config.txt）讀取傳入參數值;
configFile::Core.String = Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.@__FILE__))), "config.txt"));  # "C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt";
configFile = "";
# configFile = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.dirname(Base.dirname(Base.@__FILE__))), "config.txt")), "\\" => "/"));  # "C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt";
# configFile = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath("..")), "config.txt"));  # "C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt";
# configFile = Base.string(Base.replace(Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath("..")), "config.txt")), "\\" => "/"));  # "C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt";
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
                            global configFile = ARGSValue;  # 指定的配置文檔（config.txt）保存路徑全名："C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt" # "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt";
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
# "/home/QuantitativeTrading/QuantitativeTradingJulia/config.txt"
# "C:/QuantitativeTrading/QuantitativeTradingJulia/config.txt"
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

        catch err
            println("Config file = [ " * Base.string(configFile) * " ] change the permissions mode=0o777 fail.");
            # println("用於輸入運行參數的配置文檔: " * configFile * " 無法修改操作權限爲 mode=0o777 .");
            println(err);
            # println(Base.typeof(err));
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
                    # println("Config file = " * Base.string(configFile));
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

                            # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/" ; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv" ; "C:/QuantitativeTrading/Data/SZ#002611.xlsx" ;
                            if line_Key === "input_K_Line"
                                global input_K_Line_Daily_file = line_Value;  # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/"; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"; "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
                                # print("input K-Line file : ", input_K_Line_Daily_file, "\n");
                                continue;
                            end

                            # "true / false";
                            if line_Key === "is_save_JLD"
                                # global is_save_JLD = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global is_save_JLD = Base.parse(Bool, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                                # print("is save .jld : ", is_save_JLD, "\n");
                                continue;
                            end

                            # 用於輸出保存處理結果的（.jld）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.jld" ;
                            if line_Key === "output_jld_K_Line"
                                global output_jld_K_Line_Daily_file = line_Value;  # 用於輸出保存處理結果的（.jld）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.jld";
                                # print("output K-Line file ( .jld ) : ", output_jld_K_Line_Daily_file, "\n");
                                continue;
                            end

                            # "true / false";
                            if line_Key === "is_save_csv"
                                # global is_save_csv = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global is_save_csv = Base.parse(Bool, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                                # print("is save .csv : ", is_save_csv, "\n");
                                continue;
                            end

                            # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                            if line_Key === "output_csv_K_Line"
                                global output_csv_K_Line_Daily_file_dir = line_Value;  # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                                # print("output K-Line file ( .csv ) directory : ", output_csv_K_Line_Daily_file_dir, "\n");
                                continue;
                            end

                            # "true / false";
                            if line_Key === "is_save_xlsx"
                                # global is_save_xlsx = Base.Meta.parse(line_Value);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                                global is_save_xlsx = Base.parse(Bool, line_Value);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                                # print("is save .xlsx : ", is_save_xlsx, "\n");
                                continue;
                            end

                            # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                            if line_Key === "output_xlsx_K_Line"
                                global output_xlsx_K_Line_Daily_file_dir = line_Value;  # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                                # print("output K-Line file ( .xlsx ) directory : ", output_xlsx_K_Line_Daily_file_dir, "\n");
                                continue;
                            end

                            # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" => [Base.string(Dates.Date("2024-08-09"))], "turnover_volume" => [Core.Int64()], "opening_price" => [Core.Float64()], "close_price" => [Core.Float64()], "low_price" => [Core.Float64()], "high_price" => [Core.Float64()]}" ;
                            if line_Key === "K_Line_source"
                                global input_K_Line_Daily_Data_String = line_Value;  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" => [Base.string(Dates.Date("2024-08-09"))], "turnover_volume" => [Core.Int64()], "opening_price" => [Core.Float64()], "close_price" => [Core.Float64()], "low_price" => [Core.Float64()], "high_price" => [Core.Float64()]}" ;
                                # print("input K-Line source JSON string : ", input_K_Line_Daily_Data_String, "\n");
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

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    # Base.exit(0);
                    return ["error", "[ Ctrl ] + [ c ]", "[ Ctrl ] + [ c ] received, will be return Function."];

                else

                    println("Config file = [ " * Base.string(configFile) * " ] not read.");
                    # println("從用於輸入運行參數的配置文檔: " * configFile * " 中讀取數據發生錯誤.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));
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

                    # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/" ; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv" ; "C:/QuantitativeTrading/Data/SZ#002611.xlsx" ;
                    if ARGSIArray[1] === "input_K_Line"
                        global input_K_Line_Daily_file = ARGSValue;  # 待處理的日棒缐（K-Line）數據保存目錄（文檔） "C:/QuantitativeTrading/Data/K-Day/"; "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv"; "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
                        # print("input K-Line file : ", input_K_Line_Daily_file, "\n");
                        continue;
                    end

                    # "true / false";
                    if ARGSIArray[1] === "is_save_JLD"
                        # global is_save_JLD = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global is_save_JLD = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                        # print("is save .jld : ", is_save_JLD, "\n");
                        continue;
                    end

                    # 用於輸出保存處理結果的（.jld）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.jld" ;
                    if ARGSIArray[1] === "output_jld_K_Line"
                        global output_jld_K_Line_Daily_file = ARGSValue;  # 用於輸出保存處理結果的（.jld）類型的文檔 "C:/QuantitativeTrading/Data/steppingData.jld";
                        # print("output K-Line file ( .jld ) : ", output_jld_K_Line_Daily_file, "\n");
                        continue;
                    end

                    # "true / false";
                    if ARGSIArray[1] === "is_save_csv"
                        # global is_save_csv = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global is_save_csv = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                        # print("is save .csv : ", is_save_csv, "\n");
                        continue;
                    end

                    # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                    if ARGSIArray[1] === "output_csv_K_Line"
                        global output_csv_K_Line_Daily_file_dir = ARGSValue;  # 用於輸出保存處理結果的（.csv）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                        # print("output K-Line file ( .csv ) directory : ", output_csv_K_Line_Daily_file_dir, "\n");
                        continue;
                    end

                    # "true / false";
                    if ARGSIArray[1] === "is_save_xlsx"
                        # global is_save_xlsx = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global is_save_xlsx = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別處理結果保存文檔類型的開關 "true / false";
                        # print("is save .xlsx : ", is_save_xlsx, "\n");
                        continue;
                    end

                    # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                    if ARGSIArray[1] === "output_xlsx_K_Line"
                        global output_xlsx_K_Line_Daily_file_dir = ARGSValue;  # 用於輸出保存處理結果的（.xlsx）類型文檔的保存目錄 "C:/QuantitativeTrading/Data/K-Day/" ;
                        # print("output K-Line file ( .xlsx ) directory : ", output_xlsx_K_Line_Daily_file_dir, "\n");
                        continue;
                    end

                    # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" => [Base.string(Dates.Date("2024-08-09"))], "turnover_volume" => [Core.Int64()], "opening_price" => [Core.Float64()], "close_price" => [Core.Float64()], "low_price" => [Core.Float64()], "high_price" => [Core.Float64()]}" ;
                    if ARGSIArray[1] === "K_Line_source"
                        global input_K_Line_Daily_Data_String = ARGSValue;  # 初始日棒缐（K-Line）初始數據字典字符串，從控制臺傳入值 "{"date_transaction" => [Base.string(Dates.Date("2024-08-09"))], "turnover_volume" => [Core.Int64()], "opening_price" => [Core.Float64()], "close_price" => [Core.Float64()], "low_price" => [Core.Float64()], "high_price" => [Core.Float64()]}" ;
                        # print("input K-Line source JSON string : ", input_K_Line_Daily_Data_String, "\n");
                        continue;
                    end
                end
            end
        end
    end
end

# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# https://github.com/JuliaData/CSV.jl
# https://csv.juliadata.org/stable/
# using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# https://github.com/felipenoris/XLSX.jl
# https://felipenoris.github.io/XLSX.jl/stable/
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/";
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/K-Day/SZ#002611.csv";
# input_K_Line_Daily_file = "C:/QuantitativeTrading/Data/SZ#002611.xlsx";
input_K_Line_Daily_Data = Base.Dict{Core.String, Core.Any}();
# input_K_Line_Daily_Data = Core.Array{Core.Any, 1}();
# 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
if Base.Filesystem.ispath(input_K_Line_Daily_file) && Base.Filesystem.isfile(input_K_Line_Daily_file)

    # file_path = Base.string(Base.Filesystem.dirname(input_K_Line_Daily_file));  # "C:/QuantitativeTrading/Data/K-Day";
    # file_name = Base.string(Base.basename(input_K_Line_Daily_file));  # "SZ#002611.csv" ;
    # file_name_2 = Base.string(Base.Filesystem.splitext(file_name)[2]);  # ".csv" ;
    # file_name_1 = Base.string(Base.Filesystem.splitext(file_name)[1]);  # "SZ#002611" ;
    # ticker_symbol = Base.string(Base.split(file_name_1, "#")[2]);  # "002611" ;

    local ticker_symbol = Base.string(Base.split(Base.string(Base.Filesystem.splitext(Base.string(Base.basename(input_K_Line_Daily_file)))[1]), "#")[2]);  # "002611" ;
    local input_K_Line_Daily_Data_I = Core.nothing;

    if Base.string(Base.Filesystem.splitext(input_K_Line_Daily_file)[2]) === Base.string(".csv") || Base.string(Base.Filesystem.splitext(input_K_Line_Daily_file)[2]) === Base.string(".txt")

        local input_K_Line_Daily_Data_Frame = CSV.read(
            input_K_Line_Daily_file,
            DataFrames.DataFrame;
            delim = ',',  # 指定 .csv 文件的分隔符號爲逗號（,）；
            skipto = 3,  # 跳過首 3 行;
            footerskip = 1,  # 跳過尾 1 行;
            # rows = 2:10,  # 祇讀取第 2 行至 10 行的數據;
            ignoreemptyrows = true,  # 跳過空行;
            # header = [:none],  # 無表頭，將第 1 行視爲與後相同的數據;
            # header = [:auto],  # 自動配置表頭;
            # header = 1,  # 設置第 1 行爲表頭;
            header = false,
            # header = [
            #     "date_transaction",
            #     "opening_price",
            #     "close_price",
            #     "low_price",
            #     "high_price",
            #     "turnover_volume"
            # ],
            # types = [
            #     Dates.Date,  # Core.String,
            #     Core.Float64,
            #     Core.Float64,
            #     Core.Float64,
            #     Core.Float64,
            #     Core.Int64,  # Core.UInt64
            #     Core.Float64
            # ]
        );
        # println(DataFrames.head(input_K_Line_Daily_Data_Frame, 7));

        input_K_Line_Daily_Data_I = DataFrames.DataFrame(
            DataFrames.names(input_K_Line_Daily_Data_Frame)[1] => [Dates.Date(Base.string(Base.strip(Base.string(Base.replace(Base.string(item), "/" => "-"))))) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[1])[:,1]],
            DataFrames.names(input_K_Line_Daily_Data_Frame)[2] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[2])[:,1]],
            DataFrames.names(input_K_Line_Daily_Data_Frame)[3] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[3])[:,1]],
            DataFrames.names(input_K_Line_Daily_Data_Frame)[4] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[4])[:,1]],
            DataFrames.names(input_K_Line_Daily_Data_Frame)[5] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[5])[:,1]],
            DataFrames.names(input_K_Line_Daily_Data_Frame)[6] => [Core.Int64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[6])[:,1]],  # Core.Int64
            DataFrames.names(input_K_Line_Daily_Data_Frame)[7] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[7])[:,1]],
        );
        # println(DataFrames.head(input_K_Line_Daily_Data_I, 7));
        # # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
        # #     input_K_Line_Daily_Data_XLSX[2:end, :],  # 使用矩陣 Matrix 數據填充數據框;
        # #     input_K_Line_Daily_Data_XLSX[1, :]  # :auto  # 指定數據框的列名稱;
        # # );
        # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
        #     eachcol(input_K_Line_Daily_Data_XLSX[2:end, :]),  # 使用矩陣 Matrix 數據填充數據框;
        #     Symbol.(input_K_Line_Daily_Data_XLSX[1, :])  # 指定數據框的列名稱;
        # );
        # for (name, col) in eachcol(input_K_Line_Daily_Data_I)
        #     # println("Column name: $name, Column values: $col");
        #     if Base.string(name) === Base.string("Transaction Date")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Dates.Date(Base.strip(Base.string(value)));  # 函數 Base.strip() 表示對傳入的字符串首尾去空格;
        #         end
        #     end
        #     if Base.string(name) === Base.string("Opening Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Close Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Low Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("High Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Turnover Volume")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.UInt64(Base.strip(Base.string(value)));
        #         end
        #     end
        # end

        input_K_Line_Daily_Data_Frame = Core.nothing;  # 釋放内存;

    elseif Base.string(Base.Filesystem.splitext(input_K_Line_Daily_file)[2]) === Base.string(".xlsx")

        # Excel_file_data = XLSX.readxlsx(input_K_Line_Daily_file);
        # XLSX.sheetnames(Excel_file_data);
        # Sheet1_data = Excel_file_data["Sheet1"];
        # Cell_2_2_data = Sheet1_data[2, 2];
        # Cell_2_2_data = Sheet1_data["B2"];
        # Range_B2_D5_data = Sheet1_data["A2:C4"];

        # input_K_Line_Daily_Data_XLSX = XLSX.readtable(
        #     input_K_Line_Daily_file,
        #     "Sheet1"  # 1
        # );

        local input_K_Line_Daily_Data_XLSX = XLSX.readdata(
            input_K_Line_Daily_file,
            1,  # "Sheet1",
            "A:G"  # "A2:G416"
        );
        # println(input_K_Line_Daily_Data_XLSX);

        local input_K_Line_Daily_Data_I = DataFrames.DataFrame(
            input_K_Line_Daily_Data_XLSX[1, :][1] => [Dates.Date(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 1]],
            input_K_Line_Daily_Data_XLSX[1, :][2] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 2]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 2]],
            input_K_Line_Daily_Data_XLSX[1, :][3] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 3]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 3]],
            input_K_Line_Daily_Data_XLSX[1, :][4] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 4]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 4]],
            input_K_Line_Daily_Data_XLSX[1, :][5] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],
            input_K_Line_Daily_Data_XLSX[1, :][6] => [Core.Int64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 6]],  # [Core.UInt64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 6]]  # Core.Int64
            input_K_Line_Daily_Data_XLSX[1, :][7] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 7]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],
        );
        # println(DataFrames.head(input_K_Line_Daily_Data_I, 7));
        # # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
        # #     input_K_Line_Daily_Data_XLSX[2:end, :],  # 使用矩陣 Matrix 數據填充數據框;
        # #     input_K_Line_Daily_Data_XLSX[1, :]  # :auto  # 指定數據框的列名稱;
        # # );
        # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
        #     eachcol(input_K_Line_Daily_Data_XLSX[2:end, :]),  # 使用矩陣 Matrix 數據填充數據框;
        #     Symbol.(input_K_Line_Daily_Data_XLSX[1, :])  # 指定數據框的列名稱;
        # );
        # for (name, col) in eachcol(input_K_Line_Daily_Data_I)
        #     # println("Column name: $name, Column values: $col");
        #     if Base.string(name) === Base.string("Transaction Date")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Dates.Date(Base.strip(Base.string(value)));  # 函數 Base.strip() 表示對傳入的字符串首尾去空格;
        #         end
        #     end
        #     if Base.string(name) === Base.string("Opening Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Close Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Low Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("High Price")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
        #         end
        #     end
        #     if Base.string(name) === Base.string("Turnover Volume")
        #         for (i, value) in DataFrames.enumerate(col)
        #             # println("Row: $i, values: $value");
        #             input_K_Line_Daily_Data_I[name][i] = Core.UInt64(Base.strip(Base.string(value)));
        #         end
        #     end
        # end

        input_K_Line_Daily_Data_XLSX = Core.nothing;  # 釋放内存;
    
    else
    end

    input_K_Line_Daily_Data[ticker_symbol] = input_K_Line_Daily_Data_I;
    # Base.push!(input_K_Line_Daily_Data, input_K_Line_Daily_Data_I);  # 使用 push! 函數在數組末尾追加推入新元素;

    input_K_Line_Daily_Data_I = Core.nothing;  # 釋放内存;

elseif Base.Filesystem.ispath(input_K_Line_Daily_file) && Base.Filesystem.isdir(input_K_Line_Daily_file)

    local dir_list_Arror = Base.Filesystem.readdir(input_K_Line_Daily_file);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
    # Base.length(Base.Filesystem.readdir(input_K_Line_Daily_file));
    # if Base.length(dir_list_Arror) > 0

        for item in dir_list_Arror

            # item === "SZ#002611.csv"
            # file_name_2 = Base.string(Base.Filesystem.splitext(item)[2]);  # ".csv" ;
            # file_name_1 = Base.string(Base.Filesystem.splitext(item)[1]);  # "SZ#002611" ;
            # ticker_symbol = Base.string(Base.split(file_name_1, "#")[2]);  # "002611" ;

            local ticker_symbol = Base.string(Base.split(Base.string(Base.Filesystem.splitext(item)[1]), "#")[2]);  # "002611" ;
            local input_K_Line_Daily_Data_I = Core.nothing;

            local item_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(input_K_Line_Daily_file), Base.string(item)));

            statsObj = Base.stat(item_path);

            if Base.Filesystem.isfile(item_path)

                if Base.string(Base.Filesystem.splitext(item_path)[2]) === Base.string(".csv") || Base.string(Base.Filesystem.splitext(item_path)[2]) === Base.string(".txt")

                    local input_K_Line_Daily_Data_Frame = CSV.read(
                        item_path,
                        DataFrames.DataFrame;
                        delim = ',',  # 指定 .csv 文件的分隔符號爲逗號（,）；
                        skipto = 3,  # 跳過首 3 行;
                        footerskip = 1,  # 跳過尾 1 行;
                        # rows = 2:10,  # 祇讀取第 2 行至 10 行的數據;
                        ignoreemptyrows = true,  # 跳過空行;
                        # header = [:none],  # 無表頭，將第 1 行視爲與後相同的數據;
                        # header = [:auto],  # 自動配置表頭;
                        # header = 1,  # 設置第 1 行爲表頭;
                        header = false,
                        # header = [
                        #     "date_transaction",
                        #     "opening_price",
                        #     "close_price",
                        #     "low_price",
                        #     "high_price",
                        #     "turnover_volume"
                        # ],
                        # types = [
                        #     Dates.Date,  # Core.String,
                        #     Core.Float64,
                        #     Core.Float64,
                        #     Core.Float64,
                        #     Core.Float64,
                        #     Core.Int64,  # Core.UInt64
                        #     Core.Float64
                        # ]
                    );
                    # println(DataFrames.head(input_K_Line_Daily_Data_Frame, 7));

                    input_K_Line_Daily_Data_I = DataFrames.DataFrame(
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[1] => [Dates.Date(Base.string(Base.strip(Base.string(Base.replace(Base.string(item), "/" => "-"))))) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[1])[:,1]],
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[2] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[2])[:,1]],
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[3] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[3])[:,1]],
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[4] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[4])[:,1]],
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[5] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[5])[:,1]],
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[6] => [Core.Int64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[6])[:,1]],  # Core.UInt64
                        DataFrames.names(input_K_Line_Daily_Data_Frame)[7] => [Core.Float64(item) for item in DataFrames.select(input_K_Line_Daily_Data_Frame, DataFrames.names(input_K_Line_Daily_Data_Frame)[7])[:,1]],
                    );
                    # println(DataFrames.head(input_K_Line_Daily_Data_I, 7));
                    # # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
                    # #     input_K_Line_Daily_Data_XLSX[2:end, :],  # 使用矩陣 Matrix 數據填充數據框;
                    # #     input_K_Line_Daily_Data_XLSX[1, :]  # :auto  # 指定數據框的列名稱;
                    # # );
                    # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
                    #     eachcol(input_K_Line_Daily_Data_XLSX[2:end, :]),  # 使用矩陣 Matrix 數據填充數據框;
                    #     Symbol.(input_K_Line_Daily_Data_XLSX[1, :])  # 指定數據框的列名稱;
                    # );
                    # for (name, col) in eachcol(input_K_Line_Daily_Data_I)
                    #     # println("Column name: $name, Column values: $col");
                    #     if Base.string(name) === Base.string("Transaction Date")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Dates.Date(Base.strip(Base.string(value)));  # 函數 Base.strip() 表示對傳入的字符串首尾去空格;
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Opening Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Close Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Low Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("High Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Turnover Volume")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.UInt64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    # end

                    input_K_Line_Daily_Data_Frame = Core.nothing;  # 釋放内存;

                elseif Base.string(Base.Filesystem.splitext(item_path)[2]) === Base.string(".xlsx")

                    # Excel_file_data = XLSX.readxlsx(item_path);
                    # XLSX.sheetnames(Excel_file_data);
                    # Sheet1_data = Excel_file_data["Sheet1"];
                    # Cell_2_2_data = Sheet1_data[2, 2];
                    # Cell_2_2_data = Sheet1_data["B2"];
                    # Range_B2_D5_data = Sheet1_data["A2:C4"];

                    # input_K_Line_Daily_Data_XLSX = XLSX.readtable(
                    #     item_path,
                    #     "Sheet1"  # 1
                    # );

                    local input_K_Line_Daily_Data_XLSX = XLSX.readdata(
                        item_path,
                        1,  # "Sheet1",
                        "A:G"  # "A2:G416"
                    );
                    # println(input_K_Line_Daily_Data_XLSX);

                    input_K_Line_Daily_Data_I = DataFrames.DataFrame(
                        input_K_Line_Daily_Data_XLSX[1, :][1] => [Dates.Date(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 1]],
                        input_K_Line_Daily_Data_XLSX[1, :][2] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 2]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 2]],
                        input_K_Line_Daily_Data_XLSX[1, :][3] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 3]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 3]],
                        input_K_Line_Daily_Data_XLSX[1, :][4] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 4]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 4]],
                        input_K_Line_Daily_Data_XLSX[1, :][5] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],
                        input_K_Line_Daily_Data_XLSX[1, :][6] => [Core.Int64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 6]],  # [Core.UInt64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 6]]  # Core.Int64
                        input_K_Line_Daily_Data_XLSX[1, :][7] => [Core.Float64(item) for item in input_K_Line_Daily_Data_XLSX[2:end, 7]],  # [Core.Float64(Base.string(Base.strip(Base.string(item)))) for item in input_K_Line_Daily_Data_XLSX[2:end, 5]],
                    );
                    # println(DataFrames.head(input_K_Line_Daily_Data_I, 7));
                    # # input_K_Line_Daily_Data_I = DataFrames.DataFrame(
                    # #     input_K_Line_Daily_Data_XLSX[2:end, :],  # 使用矩陣 Matrix 數據填充數據框;
                    # #     input_K_Line_Daily_Data_I_XLSX[1, :]  # :auto  # 指定數據框的列名稱;
                    # # );
                    # input_K_Line_Daily_Data = DataFrames.DataFrame(
                    #     eachcol(input_K_Line_Daily_Data_XLSX[2:end, :]),  # 使用矩陣 Matrix 數據填充數據框;
                    #     Symbol.(input_K_Line_Daily_Data_XLSX[1, :])  # 指定數據框的列名稱;
                    # );
                    # for (name, col) in eachcol(input_K_Line_Daily_Data_I)
                    #     # println("Column name: $name, Column values: $col");
                    #     if Base.string(name) === Base.string("Transaction Date")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Dates.Date(Base.strip(Base.string(value)));  # 函數 Base.strip() 表示對傳入的字符串首尾去空格;
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Opening Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Close Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Low Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("High Price")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.Float64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    #     if Base.string(name) === Base.string("Turnover Volume")
                    #         for (i, value) in DataFrames.enumerate(col)
                    #             # println("Row: $i, values: $value");
                    #             input_K_Line_Daily_Data_I[name][i] = Core.UInt64(Base.strip(Base.string(value)));
                    #         end
                    #     end
                    # end

                    input_K_Line_Daily_Data_XLSX = Core.nothing;  # 釋放内存;
                
                else
                end

            elseif Base.Filesystem.isdir(item_path)
            else
            end

            input_K_Line_Daily_Data[ticker_symbol] = input_K_Line_Daily_Data_I;
            # Base.push!(input_K_Line_Daily_Data, input_K_Line_Daily_Data_I);  # 使用 push! 函數在數組末尾追加推入新元素;end

            input_K_Line_Daily_Data_I = Core.nothing;  # 釋放内存;
        end

    # end

else
end

# 從控制臺傳入值，初始日棒缐（K-Line）初始數據字典字符串，轉換爲 Julia 的字典（Dict）類型;
if Core.isa(input_K_Line_Daily_Data_String, Core.String) && input_K_Line_Daily_Data_String !== ""
    input_K_Line_Daily_Data = JSONparse(input_K_Line_Daily_Data_String);  # 使用藉助第三方擴展包「JSON」裏的 JSON.parse() 函數創建的自定義的 JSONparse() 函數將 JSON 字符串轉換爲 Julia 字典（Dict）對象;
end

# column_names = DataFrames.names(input_K_Line_Daily_Data);  # 獲取所有列名稱;
# 遍歷數據框（DataFrames.DataFrame）的所有列;
# for (name, col) in eachcol(input_K_Line_Daily_Data)
#     println("Column name: $name, Column values: $col");
# end
# for (i, value) in DataFrames.enumerate(input_K_Line_Daily_Data[:,1])
#     # println("Row: $i, values: $value");
#     input_K_Line_Daily_Data[:,1][i] = Dates.Date(Base.strip(Base.string(value)));  # 函數 Base.strip() 表示對傳入的字符串首尾去空格;
# end
# input_K_Line_Daily_Data[:,1] = [Dates.Date(Base.strip(Base.string(value))) for (i, value) in DataFrames.enumerate(input_K_Line_Daily_Data[:,1])];  # 將數據框（DataFrames.DataFrame）第 1 列的全部值轉換爲日期類型（Dates.Date），參數 [:,1] 表示獲取數據框（DataFrames.DataFrame）第 1 列的全部值;

# input_K_Line_Daily_Dict = Core.Array{Core.Any, 1}();
# for i in 1:Base.length(input_K_Line_Daily_Data)
#     input_K_Line_Daily_Dict_I = Base.Dict{Core.String, Core.Any}();
#     input_K_Line_Daily_Dict_I["date_transaction"] = input_K_Line_Daily_Data[i][:,1];  # 參數 [:,1] 表示獲取數據框（DataFrames.DataFrame）第 1 列的全部值;
#     # println(input_K_Line_Daily_Dict_I["date_transaction"]);
#     input_K_Line_Daily_Dict_I["opening_price"] = input_K_Line_Daily_Data[i][:,2];
#     # println(input_K_Line_Daily_Dict_I["opening_price"]);
#     input_K_Line_Daily_Dict_I["close_price"] = input_K_Line_Daily_Data[i][:,5];
#     # println(input_K_Line_Daily_Dict_I["close_price"]);
#     input_K_Line_Daily_Dict_I["low_price"] = input_K_Line_Daily_Data[i][:,4];
#     # println(input_K_Line_Daily_Dict_I["low_price"]);
#     input_K_Line_Daily_Dict_I["high_price"] = input_K_Line_Daily_Data[i][:,3];
#     # println(input_K_Line_Daily_Dict_I["high_price"]);
#     input_K_Line_Daily_Dict_I["turnover_volume"] = input_K_Line_Daily_Data[i][:,6];
#     # println(input_K_Line_Daily_Dict_I["turnover_volume"]);
#     input_K_Line_Daily_Dict_I["turnover_amount"] = input_K_Line_Daily_Data[i][:,7];
#     # println(input_K_Line_Daily_Dict_I["turnover_amount"]);

#     Base.push!(input_K_Line_Daily_Dict, input_K_Line_Daily_Dict_I);  # 使用 push! 函數在數組末尾追加推入新元素;

#     input_K_Line_Daily_Dict_I = Core.nothing;  # 釋放内存;
# end
input_K_Line_Daily_Dict = Base.Dict{Core.String, Core.Any}();
for (key, value) in input_K_Line_Daily_Data
    input_K_Line_Daily_Dict_I = Base.Dict{Core.String, Core.Any}();
    input_K_Line_Daily_Dict_I["date_transaction"] = value[:,1];  # 參數 [:,1] 表示獲取數據框（DataFrames.DataFrame）第 1 列的全部值;
    # println(input_K_Line_Daily_Dict_I["date_transaction"]);
    input_K_Line_Daily_Dict_I["opening_price"] = value[:,2];
    # println(input_K_Line_Daily_Dict_I["opening_price"]);
    input_K_Line_Daily_Dict_I["close_price"] = value[:,5];
    # println(input_K_Line_Daily_Dict_I["close_price"]);
    input_K_Line_Daily_Dict_I["low_price"] = value[:,4];
    # println(input_K_Line_Daily_Dict_I["low_price"]);
    input_K_Line_Daily_Dict_I["high_price"] = value[:,3];
    # println(input_K_Line_Daily_Dict_I["high_price"]);
    input_K_Line_Daily_Dict_I["turnover_volume"] = value[:,6];
    # println(input_K_Line_Daily_Dict_I["turnover_volume"]);
    input_K_Line_Daily_Dict_I["turnover_amount"] = value[:,7];
    # println(input_K_Line_Daily_Dict_I["turnover_amount"]);

    input_K_Line_Daily_Dict[key] = input_K_Line_Daily_Dict_I;

    input_K_Line_Daily_Dict_I = Core.nothing;  # 釋放内存;
end
# println(length(input_K_Line_Daily_Dict));
# println(keys(input_K_Line_Daily_Dict));

input_K_Line_Daily_Data = Core.nothing;  # 釋放内存;

# 計算加載數據中不包括的，自定義的觀測數據參數;
if Base.isa(input_K_Line_Daily_Dict, Base.Dict) && Base.length(input_K_Line_Daily_Dict) > 0
    for (key, value) in input_K_Line_Daily_Dict
        # println(key);
        if Base.isa(value, Base.Dict) && Base.length(value) > 0
            if (Base.haskey(value, "date_transaction") && Base.typeof(value["date_transaction"]) <: Core.Array && Base.length(value["date_transaction"]) > 0) && (Base.haskey(value, "turnover_volume") && Base.typeof(value["turnover_volume"]) <: Core.Array && Base.length(value["turnover_volume"]) > 0) && (Base.haskey(value, "opening_price") && Base.typeof(value["opening_price"]) <: Core.Array && Base.length(value["opening_price"]) > 0) && (Base.haskey(value, "close_price") && Base.typeof(value["close_price"]) <: Core.Array && Base.length(value["close_price"]) > 0) && (Base.haskey(value, "low_price") && Base.typeof(value["low_price"]) <: Core.Array && Base.length(value["low_price"]) > 0) && (Base.haskey(value, "high_price") && Base.typeof(value["high_price"]) <: Core.Array && Base.length(value["high_price"]) > 0)
                # 計算訓練集日棒缐（K Line Daily）數據本徵（characteristic）;
                local K_Line_focus = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                local K_Line_amplitude = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                local K_Line_amplitude_rate = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                local K_Line_opening_price_Standardization = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                local K_Line_closing_price_Standardization = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                local K_Line_low_price_Standardization = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                local K_Line_high_price_Standardization = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                local K_Line_turnover_rate = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 交易日換手率;
                local K_Line_price_earnings = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 每股市盈率;
                local K_Line_book_value_per_share = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 每股净值;
                local K_Line_capitalization = Core.Array{Core.Union{Core.Float64, Core.String, Core.Nothing, Base.Missing}, 1}();  # 總市值;
                local K_Line_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間成交股票數量的變化率值的序列;
                local K_Line_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間開盤股票價格的變化率值的序列;
                local K_Line_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算相鄰兩個交易日之間收盤股票價格的變化率值的序列;
                local K_Line_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票收盤價格減去開盤價格的變化率值的序列;
                local K_Line_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列;
                local K_Line_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據，計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列;
                local K_Line_sum_2_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_2_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_3_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_5_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_7_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_sum_10_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                local K_Line_average_5_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                local K_Line_average_10_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                local K_Line_average_20_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                local K_Line_average_30_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                local Pdata_0 = Core.Array{Core.Float64, 1}();  # 擬合優化迭代初始值;
                local Plower = Core.Array{Core.Float64, 1}();  # 擬合優化的約束上限值;
                local Pupper = Core.Array{Core.Float64, 1}();  # 擬合優化的約束下限值;
                local weight = Core.Array{Core.Float64, 1}();  # 加權擬合優化自變量（Independent variable , X）的權重值;

                # 計算訓練集日棒缐（K Line Daily）數據的最少數目（minimum count time series）;
                # minimum_count_time_series::Core.Int64 = Core.Int64(0);
                # minimum_count_time_series = (+Base.Inf);
                local minimum_count_time_series = Core.Int64(Base.findmin([Base.length(value["date_transaction"]), Base.length(value["turnover_volume"]), Base.length(value["opening_price"]), Base.length(value["close_price"]), Base.length(value["low_price"]), Base.length(value["high_price"])])[1]);
                # minimum_count_time_series = Core.Int64(Base.findmin([Base.length(date_transaction), Base.length(turnover_volume), Base.length(opening_price), Base.length(close_price), Base.length(low_price), Base.length(high_price)])[1]);

                if minimum_count_time_series > 0

                    # for i = 1:Base.length(value["opening_price"])
                    # for i = 1:Base.length(opening_price)
                    for i = 1:minimum_count_time_series

                        # 計算訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                        # K_Line_focus = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的重心值（Focus）;
                        date_i_focus = Statistics.mean([value["opening_price"][i], value["close_price"][i], value["low_price"][i], value["high_price"][i]]);
                        # date_i_focus = Statistics.mean([opening_price[i], close_price[i], low_price[i], high_price[i]]);
                        date_i_focus = Core.Float16(date_i_focus);
                        Base.push!(K_Line_focus, date_i_focus);  # 使用 push! 函數在數組末尾追加推入新元素;

                        # 計算訓練集日棒缐（K Line Daily）數據的變化程度標示值（振幅）（Amplitude）;
                        # K_Line_amplitude = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（絕對振幅）（Amplitude）;
                        date_i_amplitude = Statistics.std(
                            [
                                value["opening_price"][i],  # opening_price[i],
                                value["close_price"][i],  # close_price[i],
                                value["low_price"][i],  # low_price[i],
                                value["high_price"][i]  # high_price[i]
                            ];
                            corrected = true
                        );
                        # if Core.Int64(Base.length([opening_price[i], close_price[i], low_price[i], high_price[i]])) === Core.Int64(1)
                        #     date_i_amplitude = Statistics.std([opening_price[i], close_price[i], low_price[i], high_price[i]]; corrected=false);
                        # elseif Core.Int64(Base.length([opening_price[i], close_price[i], low_price[i], high_price[i]])) > Core.Int64(1)
                        #     date_i_amplitude = Statistics.std([opening_price[i], close_price[i], low_price[i], high_price[i]]; corrected=true);
                        # else
                        # end
                        date_i_amplitude = Core.Float16(date_i_amplitude);
                        Base.push!(K_Line_amplitude, date_i_amplitude);  # 使用 push! 函數在數組末尾追加推入新元素;
                        # K_Line_amplitude_rate = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據的變化程度標示（相對振幅（%））（Amplitude%）;
                        date_i_amplitude_rate = Core.Float16(date_i_amplitude);  # Base.missing;  # Core.nothing;  # +Base.Inf;
                        if Core.Float16(date_i_focus) === Core.Float16(0.0)
                            date_i_amplitude_rate = (+Base.Inf);  # Core.Float16(date_i_amplitude);
                        else
                            date_i_amplitude_rate = Core.Float16(date_i_amplitude / date_i_focus);
                        end
                        Base.push!(K_Line_amplitude_rate, date_i_amplitude_rate);  # 使用 push! 函數在數組末尾追加推入新元素;

                        # 訓練集日棒缐（K Line Daily）數據標準化（Standardization）轉換;
                        date_i_opening_price_Standardization = value["opening_price"][i];  # 訓練集日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化;
                        date_i_closing_price_Standardization = value["close_price"][i];  # 訓練集日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化;
                        date_i_low_price_Standardization = value["low_price"][i];  # 訓練集日棒缐（K Line Daily）數據交易日最低成交價標準化;
                        date_i_high_price_Standardization = value["high_price"][i];  # 訓練集日棒缐（K Line Daily）數據交易日最高成交價標準化;
                        # if Core.Float16(value["amplitude"][i]) === Core.Float16(0.0)
                        if Core.Float16(date_i_amplitude) === Core.Float16(0.0)
                            date_i_opening_price_Standardization = Core.Float16(value["opening_price"][i] - date_i_focus);
                            date_i_closing_price_Standardization = Core.Float16(value["close_price"][i] - date_i_focus);
                            date_i_low_price_Standardization = Core.Float16(value["low_price"][i] - date_i_focus);
                            date_i_high_price_Standardization = Core.Float16(value["high_price"][i] - date_i_focus);
                        else
                            date_i_opening_price_Standardization = Core.Float16((value["opening_price"][i] - date_i_focus) / date_i_amplitude);
                            date_i_closing_price_Standardization = Core.Float16((value["close_price"][i] - date_i_focus) / date_i_amplitude);
                            date_i_low_price_Standardization = Core.Float16((value["low_price"][i] - date_i_focus) / date_i_amplitude);
                            date_i_high_price_Standardization = Core.Float16((value["high_price"][i] - date_i_focus) / date_i_amplitude);
                        end
                        Base.push!(K_Line_opening_price_Standardization, date_i_opening_price_Standardization);  # 使用 push! 函數在數組末尾追加推入新元素;
                        Base.push!(K_Line_closing_price_Standardization, date_i_closing_price_Standardization);
                        Base.push!(K_Line_low_price_Standardization, date_i_low_price_Standardization);
                        Base.push!(K_Line_high_price_Standardization, date_i_high_price_Standardization);

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間成交股票數量的變化率值的序列，並保存入 1 維數組;
                        # K_Line_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算相鄰兩個交易日之間成交股票數量的變化率值的序列;
                        date_i_turnover_volume_growth_rate = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i > 1
                            if Core.Int64(value["turnover_volume"][i - 1]) !== Core.Int64(0)
                                date_i_turnover_volume_growth_rate = Core.Float16(Core.Float64(value["turnover_volume"][i] / value["turnover_volume"][i - 1]) - Core.Float64(1.0));
                            elseif Core.Int64(value["turnover_volume"][i - 1]) === Core.Int64(0) && Core.Int64(value["turnover_volume"][i]) === Core.Int64(0)
                                date_i_turnover_volume_growth_rate = Core.Float16(0.0);
                                # date_i_turnover_volume_growth_rate = Base.missing;
                                # date_i_turnover_volume_growth_rate = Core.nothing;
                            elseif Core.Int64(value["turnover_volume"][i - 1]) === Core.Int64(0) && Core.Int64(value["turnover_volume"][i]) > Core.Int64(0)
                                date_i_turnover_volume_growth_rate = (+Base.Inf);
                            elseif Core.Int64(value["turnover_volume"][i - 1]) === Core.Int64(0) && Core.Int64(value["turnover_volume"][i]) < Core.Int64(0)
                                date_i_turnover_volume_growth_rate = (-Base.Inf);
                            else
                            end
                        end
                        # println(date_i_turnover_volume_growth_rate);
                        Base.push!(K_Line_turnover_volume_growth_rate, date_i_turnover_volume_growth_rate);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間開盤股票價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算相鄰兩個交易日之間開盤股票價格的變化率值的序列;
                        date_i_opening_price_growth_rate = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i > 1
                            if Core.Float64(value["opening_price"][i - 1]) !== Core.Float64(0.0)
                                date_i_opening_price_growth_rate = Core.Float16(Core.Float64(value["opening_price"][i] / value["opening_price"][i - 1]) - Core.Float64(1.0));
                            elseif Core.Float64(value["opening_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["opening_price"][i]) === Core.Float64(0.0)
                                date_i_opening_price_growth_rate = Core.Float16(0.0);
                                # date_i_opening_price_growth_rate = Base.missing;
                                # date_i_opening_price_growth_rate = Core.nothing;
                            elseif Core.Float64(value["opening_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["opening_price"][i]) > Core.Float64(0.0)
                                date_i_opening_price_growth_rate = (+Base.Inf);
                            elseif Core.Float64(value["opening_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["opening_price"][i]) < Core.Float64(0.0)
                                date_i_opening_price_growth_rate = (-Base.Inf);
                            else
                            end
                        end
                        # println(date_i_opening_price_growth_rate);
                        Base.push!(K_Line_opening_price_growth_rate, date_i_opening_price_growth_rate);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 計算訓練集日棒缐（K Line Daily）數據相鄰兩個交易日之間收盤股票價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算相鄰兩個交易日之間收盤股票價格的變化率值的序列;
                        date_i_closing_price_growth_rate = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i > 1
                            if Core.Float64(value["close_price"][i - 1]) !== Core.Float64(0.0)
                                date_i_closing_price_growth_rate = Core.Float16(Core.Float64(value["close_price"][i] / value["close_price"][i - 1]) - Core.Float64(1.0));
                            elseif Core.Float64(value["close_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) === Core.Float64(0.0)
                                date_i_closing_price_growth_rate = Core.Float16(0.0);
                                # date_i_closing_price_growth_rate = Base.missing;
                                # date_i_closing_price_growth_rate = Core.nothing;
                            elseif Core.Float64(value["close_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) > Core.Float64(0.0)
                                date_i_closing_price_growth_rate = (+Base.Inf);
                            elseif Core.Float64(value["close_price"][i - 1]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) < Core.Float64(0.0)
                                date_i_closing_price_growth_rate = (-Base.Inf);
                            else
                            end
                        end
                        # println(date_i_closing_price_growth_rate);
                        Base.push!(K_Line_closing_price_growth_rate, date_i_closing_price_growth_rate);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票收盤價格減去開盤價格的變化率值的序列，並保存入 1 維數組;
                        # K_Line_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算每個交易日股票收盤價格減去開盤價格的變化率值的序列;
                        date_i_closing_minus_opening_price_growth_rate = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if Core.Float64(value["opening_price"][i]) !== Core.Float64(0.0)
                            date_i_closing_minus_opening_price_growth_rate = Core.Float16(Core.Float64(value["close_price"][i] / value["opening_price"][i]) - Core.Float64(1.0));
                        elseif Core.Float64(value["opening_price"][i]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) === Core.Float64(0.0)
                            date_i_closing_minus_opening_price_growth_rate = Core.Float16(0.0);
                            # date_i_closing_minus_opening_price_growth_rate = Base.missing;
                            # date_i_closing_minus_opening_price_growth_rate = Core.nothing;
                        elseif Core.Float64(value["opening_price"][i]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) > Core.Float64(0.0)
                            date_i_closing_minus_opening_price_growth_rate = (+Base.Inf);
                        elseif Core.Float64(value["opening_price"][i]) === Core.Float64(0.0) && Core.Float64(value["close_price"][i]) < Core.Float64(0.0)
                            date_i_closing_minus_opening_price_growth_rate = (-Base.Inf);
                        else
                        end
                        # println(date_i_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_closing_minus_opening_price_growth_rate, date_i_closing_minus_opening_price_growth_rate);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列，並保存入 1 維數組;
                        # K_Line_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算每個交易日股票收盤價和開盤價裏的最大值占最高價的比例值的序列;
                        date_i_high_price_proportion = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if Core.Float64(value["high_price"][i]) !== Core.Float64(0.0)
                            date_i_high_price_proportion = Core.Float16(Core.Float64(Base.findmax([value["opening_price"][i], value["close_price"][i]])[1]) / Core.Float64(value["high_price"][i]));
                        elseif Core.Float64(value["high_price"][i]) === Core.Float64(0.0) && Core.Float64(Base.findmax([value["opening_price"][i], value["close_price"][i]])[1]) === Core.Float64(0.0)
                            date_i_high_price_proportion = Core.Float16(0.0);
                            # date_i_high_price_proportion = Base.missing;
                            # date_i_high_price_proportion = Core.nothing;
                        elseif Core.Float64(value["high_price"][i]) === Core.Float64(0.0) && Core.Float64(Base.findmax([value["opening_price"][i], value["close_price"][i]])[1]) > Core.Float64(0.0)
                            date_i_high_price_proportion = (+Base.Inf);
                        elseif Core.Float64(value["high_price"][i]) === Core.Float64(0.0) && Core.Float64(Base.findmax([value["opening_price"][i], value["close_price"][i]])[1]) < Core.Float64(0.0)
                            date_i_high_price_proportion = (-Base.Inf);
                        else
                        end
                        # println(date_i_high_price_proportion);
                        Base.push!(K_Line_high_price_proportion, date_i_high_price_proportion);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 計算訓練集日棒缐（K Line Daily）數據每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列，並保存入 1 維數組;
                        # K_Line_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();  # 計算每個交易日股票最低價占收盤價和開盤價裏的最小值的比例值的序列;
                        date_i_low_price_proportion = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if Core.Float64(Base.findmin([value["opening_price"][i], value["close_price"][i]])[1]) !== Core.Float64(0.0)
                            date_i_low_price_proportion = Core.Float16(Core.Float64(value["low_price"][i]) / Core.Float64(Base.findmin([value["opening_price"][i], value["close_price"][i]])[1]));
                        elseif Core.Float64(Base.findmin([value["opening_price"][i], value["close_price"][i]])[1]) === Core.Float64(0.0) && Core.Float64(value["low_price"][i]) === Core.Float64(0.0)
                            date_i_low_price_proportion = Core.Float16(0.0);
                            # date_i_low_price_proportion = Base.missing;
                            # date_i_low_price_proportion = Core.nothing;
                        elseif Core.Float64(Base.findmin([value["opening_price"][i], value["close_price"][i]])[1]) === Core.Float64(0.0) && Core.Float64(value["low_price"][i]) > Core.Float64(0.0)
                            date_i_low_price_proportion = (+Base.Inf);
                        elseif Core.Float64(Base.findmin([value["opening_price"][i], value["close_price"][i]])[1]) === Core.Float64(0.0) && Core.Float64(value["low_price"][i]) < Core.Float64(0.0)
                            date_i_low_price_proportion = (-Base.Inf);
                        else
                        end
                        # println(date_i_low_price_proportion);
                        Base.push!(K_Line_low_price_proportion, date_i_low_price_proportion);  # 使用 push! 函數在數組末尾追加推入新元;

                        # K_Line_sum_2_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_2_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        date_i_sum_2_turnover_volume_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_closing_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_closing_minus_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_high_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_low_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_2_KLine_Intuitive_Momentum = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        if Core.Int64(i) >= Core.Int64(2) && Core.Int64(i) > Core.Int64(1)

                            x0 = value["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 交易日期;
                            x1 = value["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 成交量;
                            # x2 = value["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 成交總金額;
                            x3 = value["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 開盤成交價;
                            x4 = value["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 收盤成交價;
                            x5 = value["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 最低成交價;
                            x6 = value["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 最高成交價;
                            # x7 = K_Line_focus[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 當日成交價重心;
                            # x8 = K_Line_amplitude[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 成交量換手率;
                            # x21 = value["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(2) + Core.Int64(1)):1:i];  # 總市值;

                            y = Intuitive_Momentum_KLine(
                                Base.Dict{Core.String, Core.Any}(
                                    "date_transaction" => x0,
                                    "turnover_volume" => x1,
                                    # "turnover_volume" => x2,
                                    "opening_price" => x3,
                                    "close_price" => x4,
                                    "low_price" => x5,
                                    "high_price" => x6,
                                    # "focus" => x7,
                                    # "amplitude" => x8,
                                    # "amplitude_rate" => x9,
                                    # "opening_price_Standardization" => x10,
                                    # "closing_price_Standardization" => x11,
                                    # "low_price_Standardization" => x12,
                                    # "high_price_Standardization" => x13,
                                    "turnover_volume_growth_rate" => x14,
                                    "opening_price_growth_rate" => x15,
                                    "closing_price_growth_rate" => x16,
                                    "closing_minus_opening_price_growth_rate" => x17,
                                    "high_price_proportion" => x18,
                                    "low_price_proportion" => x19
                                ),
                                Core.Int64(2);  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = Core.nothing,  # Core.Array{Core.Float16, 1}([Core.Float16(Core.Int64(1) / Core.Int64(2)), Core.Float16(Core.Int64(2) / Core.Int64(2))]),
                                Intuitive_Momentum = Intuitive_Momentum
                            );
                            date_i_sum_2_turnover_volume_growth_rate = Core.Float16(y["P1_turnover_volume_growth_rate"][Core.Int64(Base.length(y["P1_turnover_volume_growth_rate"]))]);
                            date_i_sum_2_opening_price_growth_rate = Core.Float16(y["P1_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_opening_price_growth_rate"]))]);
                            date_i_sum_2_closing_price_growth_rate = Core.Float16(y["P1_closing_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_price_growth_rate"]))]);
                            date_i_sum_2_closing_minus_opening_price_growth_rate = Core.Float16(y["P1_closing_minus_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_minus_opening_price_growth_rate"]))]);
                            date_i_sum_2_high_price_proportion = Core.Float16(y["P1_high_price_proportion"][Core.Int64(Base.length(y["P1_high_price_proportion"]))]);
                            date_i_sum_2_low_price_proportion = Core.Float16(y["P1_low_price_proportion"][Core.Int64(Base.length(y["P1_low_price_proportion"]))]);
                            date_i_sum_2_KLine_Intuitive_Momentum = Core.Float16(y["P1_Intuitive_Momentum"][Core.Int64(Base.length(y["P1_Intuitive_Momentum"]))]);
                        end
                        Base.push!(K_Line_sum_2_turnover_volume_growth_rate, date_i_sum_2_turnover_volume_growth_rate);
                        Base.push!(K_Line_sum_2_opening_price_growth_rate, date_i_sum_2_opening_price_growth_rate);
                        Base.push!(K_Line_sum_2_closing_price_growth_rate, date_i_sum_2_closing_price_growth_rate);
                        Base.push!(K_Line_sum_2_closing_minus_opening_price_growth_rate, date_i_sum_2_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_sum_2_high_price_proportion, date_i_sum_2_high_price_proportion);
                        Base.push!(K_Line_sum_2_low_price_proportion, date_i_sum_2_low_price_proportion);
                        Base.push!(K_Line_sum_2_KLine_Intuitive_Momentum, date_i_sum_2_KLine_Intuitive_Momentum);  # 使用 push! 函數在數組末尾追加推入新元;

                        # K_Line_sum_3_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_3_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        date_i_sum_3_turnover_volume_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_closing_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_closing_minus_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_high_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_low_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_3_KLine_Intuitive_Momentum = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        if Core.Int64(i) >= Core.Int64(3) && Core.Int64(i) > Core.Int64(1)

                            x0 = value["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 交易日期;
                            x1 = value["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 成交量;
                            # x2 = value["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 成交總金額;
                            x3 = value["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 開盤成交價;
                            x4 = value["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 收盤成交價;
                            x5 = value["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 最低成交價;
                            x6 = value["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 最高成交價;
                            # x7 = K_Line_focus[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 當日成交價重心;
                            # x8 = K_Line_amplitude[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 成交量換手率;
                            # x21 = value["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(3) + Core.Int64(1)):1:i];  # 總市值;

                            y = Intuitive_Momentum_KLine(
                                Base.Dict{Core.String, Core.Any}(
                                    "date_transaction" => x0,
                                    "turnover_volume" => x1,
                                    # "turnover_volume" => x2,
                                    "opening_price" => x3,
                                    "close_price" => x4,
                                    "low_price" => x5,
                                    "high_price" => x6,
                                    # "focus" => x7,
                                    # "amplitude" => x8,
                                    # "amplitude_rate" => x9,
                                    # "opening_price_Standardization" => x10,
                                    # "closing_price_Standardization" => x11,
                                    # "low_price_Standardization" => x12,
                                    # "high_price_Standardization" => x13,
                                    "turnover_volume_growth_rate" => x14,
                                    "opening_price_growth_rate" => x15,
                                    "closing_price_growth_rate" => x16,
                                    "closing_minus_opening_price_growth_rate" => x17,
                                    "high_price_proportion" => x18,
                                    "low_price_proportion" => x19
                                ),
                                Core.Int64(3);  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = Core.nothing,  # Core.Array{Core.Float16, 1}([Core.Float16(Core.Int64(1) / Core.Int64(3)), Core.Float16(Core.Int64(2) / Core.Int64(3)), Core.Float16(Core.Int64(3) / Core.Int64(3))]),
                                Intuitive_Momentum = Intuitive_Momentum
                            );
                            date_i_sum_3_turnover_volume_growth_rate = Core.Float16(y["P1_turnover_volume_growth_rate"][Core.Int64(Base.length(y["P1_turnover_volume_growth_rate"]))]);
                            date_i_sum_3_opening_price_growth_rate = Core.Float16(y["P1_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_opening_price_growth_rate"]))]);
                            date_i_sum_3_closing_price_growth_rate = Core.Float16(y["P1_closing_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_price_growth_rate"]))]);
                            date_i_sum_3_closing_minus_opening_price_growth_rate = Core.Float16(y["P1_closing_minus_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_minus_opening_price_growth_rate"]))]);
                            date_i_sum_3_high_price_proportion = Core.Float16(y["P1_high_price_proportion"][Core.Int64(Base.length(y["P1_high_price_proportion"]))]);
                            date_i_sum_3_low_price_proportion = Core.Float16(y["P1_low_price_proportion"][Core.Int64(Base.length(y["P1_low_price_proportion"]))]);
                            date_i_sum_3_KLine_Intuitive_Momentum = Core.Float16(y["P1_Intuitive_Momentum"][Core.Int64(Base.length(y["P1_Intuitive_Momentum"]))]);
                        end
                        Base.push!(K_Line_sum_3_turnover_volume_growth_rate, date_i_sum_3_turnover_volume_growth_rate);
                        Base.push!(K_Line_sum_3_opening_price_growth_rate, date_i_sum_3_opening_price_growth_rate);
                        Base.push!(K_Line_sum_3_closing_price_growth_rate, date_i_sum_3_closing_price_growth_rate);
                        Base.push!(K_Line_sum_3_closing_minus_opening_price_growth_rate, date_i_sum_3_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_sum_3_high_price_proportion, date_i_sum_3_high_price_proportion);
                        Base.push!(K_Line_sum_3_low_price_proportion, date_i_sum_3_low_price_proportion);
                        Base.push!(K_Line_sum_3_KLine_Intuitive_Momentum, date_i_sum_3_KLine_Intuitive_Momentum);  # 使用 push! 函數在數組末尾追加推入新元;

                        # K_Line_sum_5_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_5_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        date_i_sum_5_turnover_volume_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_closing_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_closing_minus_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_high_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_low_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_5_KLine_Intuitive_Momentum = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        if Core.Int64(i) >= Core.Int64(5) && Core.Int64(i) > Core.Int64(1)

                            x0 = value["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 交易日期;
                            x1 = value["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 成交量;
                            # x2 = value["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 成交總金額;
                            x3 = value["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 開盤成交價;
                            x4 = value["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 收盤成交價;
                            x5 = value["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 最低成交價;
                            x6 = value["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 最高成交價;
                            # x7 = K_Line_focus[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 當日成交價重心;
                            # x8 = K_Line_amplitude[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 成交量換手率;
                            # x21 = value["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):1:i];  # 總市值;

                            y = Intuitive_Momentum_KLine(
                                Base.Dict{Core.String, Core.Any}(
                                    "date_transaction" => x0,
                                    "turnover_volume" => x1,
                                    # "turnover_volume" => x2,
                                    "opening_price" => x3,
                                    "close_price" => x4,
                                    "low_price" => x5,
                                    "high_price" => x6,
                                    # "focus" => x7,
                                    # "amplitude" => x8,
                                    # "amplitude_rate" => x9,
                                    # "opening_price_Standardization" => x10,
                                    # "closing_price_Standardization" => x11,
                                    # "low_price_Standardization" => x12,
                                    # "high_price_Standardization" => x13,
                                    "turnover_volume_growth_rate" => x14,
                                    "opening_price_growth_rate" => x15,
                                    "closing_price_growth_rate" => x16,
                                    "closing_minus_opening_price_growth_rate" => x17,
                                    "high_price_proportion" => x18,
                                    "low_price_proportion" => x19
                                ),
                                Core.Int64(5);  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = Core.nothing,  # Core.Array{Core.Float16, 1}([Core.Float16(Core.Int64(1) / Core.Int64(5)), Core.Float16(Core.Int64(2) / Core.Int64(5)), Core.Float16(Core.Int64(3) / Core.Int64(5)), Core.Float16(Core.Int64(4) / Core.Int64(5)), Core.Float16(Core.Int64(5) / Core.Int64(5))]),
                                Intuitive_Momentum = Intuitive_Momentum
                            );
                            date_i_sum_5_turnover_volume_growth_rate = Core.Float16(y["P1_turnover_volume_growth_rate"][Core.Int64(Base.length(y["P1_turnover_volume_growth_rate"]))]);
                            date_i_sum_5_opening_price_growth_rate = Core.Float16(y["P1_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_opening_price_growth_rate"]))]);
                            date_i_sum_5_closing_price_growth_rate = Core.Float16(y["P1_closing_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_price_growth_rate"]))]);
                            date_i_sum_5_closing_minus_opening_price_growth_rate = Core.Float16(y["P1_closing_minus_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_minus_opening_price_growth_rate"]))]);
                            date_i_sum_5_high_price_proportion = Core.Float16(y["P1_high_price_proportion"][Core.Int64(Base.length(y["P1_high_price_proportion"]))]);
                            date_i_sum_5_low_price_proportion = Core.Float16(y["P1_low_price_proportion"][Core.Int64(Base.length(y["P1_low_price_proportion"]))]);
                            date_i_sum_5_KLine_Intuitive_Momentum = Core.Float16(y["P1_Intuitive_Momentum"][Core.Int64(Base.length(y["P1_Intuitive_Momentum"]))]);
                        end
                        Base.push!(K_Line_sum_5_turnover_volume_growth_rate, date_i_sum_5_turnover_volume_growth_rate);
                        Base.push!(K_Line_sum_5_opening_price_growth_rate, date_i_sum_5_opening_price_growth_rate);
                        Base.push!(K_Line_sum_5_closing_price_growth_rate, date_i_sum_5_closing_price_growth_rate);
                        Base.push!(K_Line_sum_5_closing_minus_opening_price_growth_rate, date_i_sum_5_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_sum_5_high_price_proportion, date_i_sum_5_high_price_proportion);
                        Base.push!(K_Line_sum_5_low_price_proportion, date_i_sum_5_low_price_proportion);
                        Base.push!(K_Line_sum_5_KLine_Intuitive_Momentum, date_i_sum_5_KLine_Intuitive_Momentum);  # 使用 push! 函數在數組末尾追加推入新元;

                        # K_Line_sum_7_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_7_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        date_i_sum_7_turnover_volume_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_closing_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_closing_minus_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_high_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_low_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_7_KLine_Intuitive_Momentum = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        if Core.Int64(i) >= Core.Int64(7) && Core.Int64(i) > Core.Int64(1)

                            x0 = value["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 交易日期;
                            x1 = value["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 成交量;
                            # x2 = value["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 成交總金額;
                            x3 = value["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 開盤成交價;
                            x4 = value["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 收盤成交價;
                            x5 = value["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 最低成交價;
                            x6 = value["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 最高成交價;
                            # x7 = K_Line_focus[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 當日成交價重心;
                            # x8 = K_Line_amplitude[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 成交量換手率;
                            # x21 = value["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(7) + Core.Int64(1)):1:i];  # 總市值;

                            y = Intuitive_Momentum_KLine(
                                Base.Dict{Core.String, Core.Any}(
                                    "date_transaction" => x0,
                                    "turnover_volume" => x1,
                                    # "turnover_volume" => x2,
                                    "opening_price" => x3,
                                    "close_price" => x4,
                                    "low_price" => x5,
                                    "high_price" => x6,
                                    # "focus" => x7,
                                    # "amplitude" => x8,
                                    # "amplitude_rate" => x9,
                                    # "opening_price_Standardization" => x10,
                                    # "closing_price_Standardization" => x11,
                                    # "low_price_Standardization" => x12,
                                    # "high_price_Standardization" => x13,
                                    "turnover_volume_growth_rate" => x14,
                                    "opening_price_growth_rate" => x15,
                                    "closing_price_growth_rate" => x16,
                                    "closing_minus_opening_price_growth_rate" => x17,
                                    "high_price_proportion" => x18,
                                    "low_price_proportion" => x19
                                ),
                                Core.Int64(7);  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = Core.nothing,  # Core.Array{Core.Float16, 1}([Core.Float16(Core.Int64(1) / Core.Int64(7)), Core.Float16(Core.Int64(2) / Core.Int64(7)), Core.Float16(Core.Int64(3) / Core.Int64(7)), Core.Float16(Core.Int64(4) / Core.Int64(7)), Core.Float16(Core.Int64(5) / Core.Int64(7)), Core.Float16(Core.Int64(6) / Core.Int64(7)), Core.Float16(Core.Int64(7) / Core.Int64(7))]),
                                Intuitive_Momentum = Intuitive_Momentum
                            );
                            date_i_sum_7_turnover_volume_growth_rate = Core.Float16(y["P1_turnover_volume_growth_rate"][Core.Int64(Base.length(y["P1_turnover_volume_growth_rate"]))]);
                            date_i_sum_7_opening_price_growth_rate = Core.Float16(y["P1_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_opening_price_growth_rate"]))]);
                            date_i_sum_7_closing_price_growth_rate = Core.Float16(y["P1_closing_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_price_growth_rate"]))]);
                            date_i_sum_7_closing_minus_opening_price_growth_rate = Core.Float16(y["P1_closing_minus_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_minus_opening_price_growth_rate"]))]);
                            date_i_sum_7_high_price_proportion = Core.Float16(y["P1_high_price_proportion"][Core.Int64(Base.length(y["P1_high_price_proportion"]))]);
                            date_i_sum_7_low_price_proportion = Core.Float16(y["P1_low_price_proportion"][Core.Int64(Base.length(y["P1_low_price_proportion"]))]);
                            date_i_sum_7_KLine_Intuitive_Momentum = Core.Float16(y["P1_Intuitive_Momentum"][Core.Int64(Base.length(y["P1_Intuitive_Momentum"]))]);
                        end
                        Base.push!(K_Line_sum_7_turnover_volume_growth_rate, date_i_sum_7_turnover_volume_growth_rate);
                        Base.push!(K_Line_sum_7_opening_price_growth_rate, date_i_sum_7_opening_price_growth_rate);
                        Base.push!(K_Line_sum_7_closing_price_growth_rate, date_i_sum_7_closing_price_growth_rate);
                        Base.push!(K_Line_sum_7_closing_minus_opening_price_growth_rate, date_i_sum_7_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_sum_7_high_price_proportion, date_i_sum_7_high_price_proportion);
                        Base.push!(K_Line_sum_7_low_price_proportion, date_i_sum_7_low_price_proportion);
                        Base.push!(K_Line_sum_7_KLine_Intuitive_Momentum, date_i_sum_7_KLine_Intuitive_Momentum);  # 使用 push! 函數在數組末尾追加推入新元;

                        # K_Line_sum_10_turnover_volume_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_closing_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_closing_minus_opening_price_growth_rate = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_high_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_low_price_proportion = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        # K_Line_sum_10_KLine_Intuitive_Momentum = Core.Array{Core.Union{Core.String, Core.Float16, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
                        date_i_sum_10_turnover_volume_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_closing_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_closing_minus_opening_price_growth_rate = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_high_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_low_price_proportion = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        date_i_sum_10_KLine_Intuitive_Momentum = Base.missing;  # Core.Float16(0.0);  # Core.nothing;
                        if Core.Int64(i) >= Core.Int64(10) && Core.Int64(i) > Core.Int64(1)

                            x0 = value["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 交易日期;
                            x1 = value["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 成交量;
                            # x2 = value["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 成交總金額;
                            x3 = value["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 開盤成交價;
                            x4 = value["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 收盤成交價;
                            x5 = value["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 最低成交價;
                            x6 = value["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 最高成交價;
                            # x7 = K_Line_focus[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 當日成交價重心;
                            # x8 = K_Line_amplitude[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                            # x9 = K_Line_amplitude_rate[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                            # x10 = K_Line_opening_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                            # x11 = K_Line_closing_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                            # x12 = K_Line_low_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                            # x13 = K_Line_high_price_Standardization[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                            x14 = K_Line_turnover_volume_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 成交量的成長率;
                            x15 = K_Line_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                            x16 = K_Line_closing_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                            x17 = K_Line_closing_minus_opening_price_growth_rate[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                            x18 = K_Line_high_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                            x19 = K_Line_low_price_proportion[Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                            # x20 = value["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 成交量換手率;
                            # x21 = value["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                            # x22 = value["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                            # x23 = value["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):1:i];  # 總市值;

                            y = Intuitive_Momentum_KLine(
                                Base.Dict{Core.String, Core.Any}(
                                    "date_transaction" => x0,
                                    "turnover_volume" => x1,
                                    # "turnover_volume" => x2,
                                    "opening_price" => x3,
                                    "close_price" => x4,
                                    "low_price" => x5,
                                    "high_price" => x6,
                                    # "focus" => x7,
                                    # "amplitude" => x8,
                                    # "amplitude_rate" => x9,
                                    # "opening_price_Standardization" => x10,
                                    # "closing_price_Standardization" => x11,
                                    # "low_price_Standardization" => x12,
                                    # "high_price_Standardization" => x13,
                                    "turnover_volume_growth_rate" => x14,
                                    "opening_price_growth_rate" => x15,
                                    "closing_price_growth_rate" => x16,
                                    "closing_minus_opening_price_growth_rate" => x17,
                                    "high_price_proportion" => x18,
                                    "low_price_proportion" => x19
                                ),
                                Core.Int64(10);  # 觀察收益率歷史向前推的交易日長度;
                                y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                                y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                                weight = Core.nothing,  # Core.Array{Core.Float16, 1}([Core.Float16(Core.Int64(1) / Core.Int64(10)), Core.Float16(Core.Int64(2) / Core.Int64(10)), Core.Float16(Core.Int64(3) / Core.Int64(10)), Core.Float16(Core.Int64(4) / Core.Int64(10)), Core.Float16(Core.Int64(5) / Core.Int64(10)), Core.Float16(Core.Int64(6) / Core.Int64(10)), Core.Float16(Core.Int64(7) / Core.Int64(10)), Core.Float16(Core.Int64(8) / Core.Int64(10)), Core.Float16(Core.Int64(9) / Core.Int64(10)), Core.Float16(Core.Int64(10) / Core.Int64(10))]),
                                Intuitive_Momentum = Intuitive_Momentum
                            );
                            date_i_sum_10_turnover_volume_growth_rate = Core.Float16(y["P1_turnover_volume_growth_rate"][Core.Int64(Base.length(y["P1_turnover_volume_growth_rate"]))]);
                            date_i_sum_10_opening_price_growth_rate = Core.Float16(y["P1_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_opening_price_growth_rate"]))]);
                            date_i_sum_10_closing_price_growth_rate = Core.Float16(y["P1_closing_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_price_growth_rate"]))]);
                            date_i_sum_10_closing_minus_opening_price_growth_rate = Core.Float16(y["P1_closing_minus_opening_price_growth_rate"][Core.Int64(Base.length(y["P1_closing_minus_opening_price_growth_rate"]))]);
                            date_i_sum_10_high_price_proportion = Core.Float16(y["P1_high_price_proportion"][Core.Int64(Base.length(y["P1_high_price_proportion"]))]);
                            date_i_sum_10_low_price_proportion = Core.Float16(y["P1_low_price_proportion"][Core.Int64(Base.length(y["P1_low_price_proportion"]))]);
                            date_i_sum_10_KLine_Intuitive_Momentum = Core.Float16(y["P1_Intuitive_Momentum"][Core.Int64(Base.length(y["P1_Intuitive_Momentum"]))]);
                        end
                        Base.push!(K_Line_sum_10_turnover_volume_growth_rate, date_i_sum_10_turnover_volume_growth_rate);
                        Base.push!(K_Line_sum_10_opening_price_growth_rate, date_i_sum_10_opening_price_growth_rate);
                        Base.push!(K_Line_sum_10_closing_price_growth_rate, date_i_sum_10_closing_price_growth_rate);
                        Base.push!(K_Line_sum_10_closing_minus_opening_price_growth_rate, date_i_sum_10_closing_minus_opening_price_growth_rate);
                        Base.push!(K_Line_sum_10_high_price_proportion, date_i_sum_10_high_price_proportion);
                        Base.push!(K_Line_sum_10_low_price_proportion, date_i_sum_10_low_price_proportion);
                        Base.push!(K_Line_sum_10_KLine_Intuitive_Momentum, date_i_sum_10_KLine_Intuitive_Momentum);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                        # K_Line_average_5_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 5 日滑動平均值（closing price average 5）;
                        date_i_average_5_closing_price = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i >= 5
                            date_i_average_5_closing_price = Core.Float16(Core.Float64(Base.sum([value["close_price"][k] for k in Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):i])) / Core.Int64(5));
                            # x_sum_5 = Core.Float64(0.0);
                            # for k = Core.Int64(Core.Int64(i) - Core.Int64(5) + Core.Int64(1)):i
                            #     x_sum_5 = Core.Float64(Core.Float64(x_sum_5) + Core.Float64(value["close_price"][k]));
                            # end
                            # date_i_average_5_closing_price = Core.Float16(Core.Float64(x_sum_5) / Core.Int64(5));
                        end
                        # println(date_i_average_5_closing_price);
                        Base.push!(K_Line_average_5_closing_price, date_i_average_5_closing_price);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                        # K_Line_average_10_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 10 日滑動平均值（closing price average 10）;
                        date_i_average_10_closing_price = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i >= 10
                            date_i_average_10_closing_price = Core.Float16(Core.Float64(Base.sum([value["close_price"][k] for k in Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):i])) / Core.Int64(10));
                            # x_sum_10 = Core.Float64(0.0);
                            # for k = Core.Int64(Core.Int64(i) - Core.Int64(10) + Core.Int64(1)):i
                            #     x_sum_10 = Core.Float64(Core.Float64(x_sum_10) + Core.Float64(value["close_price"][k]));
                            # end
                            # date_i_average_10_closing_price = Core.Float16(Core.Float64(x_sum_10) / Core.Int64(10));
                        end
                        # println(date_i_average_10_closing_price);
                        Base.push!(K_Line_average_10_closing_price, date_i_average_10_closing_price);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                        # K_Line_average_20_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 20 日滑動平均值（closing price average 20）;
                        date_i_average_20_closing_price = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i >= 20
                            date_i_average_20_closing_price = Core.Float16(Core.Float64(Base.sum([value["close_price"][k] for k in Core.Int64(Core.Int64(i) - Core.Int64(20) + Core.Int64(1)):i])) / Core.Int64(20));
                            # x_sum_20 = Core.Float64(0.0);
                            # for k = Core.Int64(Core.Int64(i) - Core.Int64(20) + Core.Int64(1)):i
                            #     x_sum_20 = Core.Float64(Core.Float64(x_sum_20) + Core.Float64(value["close_price"][k]));
                            # end
                            # date_i_average_20_closing_price = Core.Float16(Core.Float64(x_sum_20) / Core.Int64(20));
                        end
                        # println(date_i_average_20_closing_price);
                        Base.push!(K_Line_average_20_closing_price, date_i_average_20_closing_price);  # 使用 push! 函數在數組末尾追加推入新元;

                        # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                        # K_Line_average_30_closing_price = Core.Array{Core.Union{Core.Float16, Core.String, Core.Nothing, Base.Missing}, 1}();  # 訓練集日棒缐（K Line Daily）數據收盤價的 30 日滑動平均值（closing price average 30）;
                        date_i_average_30_closing_price = Core.Float16(0.0);  # Base.missing;  # Core.nothing;
                        if i >= 30
                            date_i_average_30_closing_price = Core.Float16(Core.Float64(Base.sum([value["close_price"][k] for k in Core.Int64(Core.Int64(i) - Core.Int64(30) + Core.Int64(1)):i])) / Core.Int64(30));
                            # x_sum_30 = Core.Float64(0.0);
                            # for k = Core.Int64(Core.Int64(i) - Core.Int64(30) + Core.Int64(1)):i
                            #     x_sum_30 = Core.Float64(Core.Float64(x_sum_30) + Core.Float64(value["close_price"][k]));
                            # end
                            # date_i_average_30_closing_price = Core.Float16(Core.Float64(x_sum_30) / Core.Int64(30));
                        end
                        # println(date_i_average_30_closing_price);
                        Base.push!(K_Line_average_30_closing_price, date_i_average_30_closing_price);  # 使用 push! 函數在數組末尾追加推入新元;
                    end

                    # 計算擬合優化迭代的各項輸入參數值;
                    # y = Base.log(x);  # Base.log(Base.MathConstants.ℯ, x);  # 對數函數;
                    # y = Base.exp(x);  # Base.MathConstants.ℯ ^ x;  # 指數函數;
                    # Base.findmin([2, 1, 0, -1, -2])[1];  # 求最小值;
                    # Base.findmax([-2, -1, 0, 1, 2])[1];  # 求最大值;

                    # 觀測值（Observation）;
                    # 求 Ydata 均值向量;
                    local YdataMean = K_Line_focus;
                    # YdataMean = Core.Array{Core.Float64, 1}();
                    # for i = 1:Base.length(Ydata)
                    #     if Base.typeof(Ydata[i]) <: Core.Array
                    #         yMean = Core.Float64(Statistics.mean(Ydata[i]));
                    #         Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                    #     else
                    #         yMean = Core.Float64(Ydata[i]);
                    #         Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                    #     end
                    # end
                    # println(YdataMean);
                    # 求 Ydata 標準差向量;
                    local YdataSTD = K_Line_amplitude;
                    # YdataSTD = Core.Array{Core.Float64, 1}();
                    # for i = 1:Base.length(Ydata)
                    #     if Base.typeof(Ydata[i]) <: Core.Array
                    #         if Core.Int64(Base.length(Ydata[i])) === Core.Int64(1)
                    #             ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=false));
                    #             Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    #         elseif Core.Int64(Base.length(Ydata[i])) > Core.Int64(1)
                    #             ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=true));
                    #             Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    #         end
                    #     else
                    #         ySTD = Core.Float64(0.0);
                    #         Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    #     end
                    # end
                    # println(YdataSTD);
                    # 求 Xdata 均值向量;
                    Xdata = [Core.Int64(i) for i in 1:Base.length(YdataMean)];
                    # Xdata = date_transaction;
                    # Xdata = stepping_data["date_transaction"];
                    # println(Xdata);

                    Pdata_0 = [
                        Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])),
                        Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])),
                        Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])),
                        Core.Float64(Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) for i in 1:Base.length(YdataMean)]))
                    ];

                    Plower = [
                        -Base.Inf,
                        -Base.Inf,
                        -Base.Inf,
                        -Base.Inf
                    ];
                    Pupper = [
                        +Base.Inf,
                        +Base.Inf,
                        +Base.Inf,
                        +Base.Inf
                    ];

                    # weight = Core.Array{Core.Float64, 1}();
                    target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
                    af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
                    for i = 1:Base.length(YdataMean)
                        wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
                        wei = Core.Float64(wei);
                        Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
                    end
                    # println(weight);
                end
                input_K_Line_Daily_Dict[key]["focus"] = K_Line_focus;
                input_K_Line_Daily_Dict[key]["amplitude"] = K_Line_amplitude;
                input_K_Line_Daily_Dict[key]["amplitude_rate"] = K_Line_amplitude_rate;
                input_K_Line_Daily_Dict[key]["opening_price_Standardization"] = K_Line_opening_price_Standardization;
                input_K_Line_Daily_Dict[key]["closing_price_Standardization"] = K_Line_closing_price_Standardization;
                input_K_Line_Daily_Dict[key]["low_price_Standardization"] = K_Line_low_price_Standardization;
                input_K_Line_Daily_Dict[key]["high_price_Standardization"] = K_Line_high_price_Standardization;
                input_K_Line_Daily_Dict[key]["turnover_rate"] = K_Line_turnover_rate;
                input_K_Line_Daily_Dict[key]["price_earnings"] = K_Line_price_earnings;
                input_K_Line_Daily_Dict[key]["book_value_per_share"] = K_Line_book_value_per_share;
                input_K_Line_Daily_Dict[key]["capitalization"] = K_Line_capitalization;
                input_K_Line_Daily_Dict[key]["turnover_volume_growth_rate"] = K_Line_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["opening_price_growth_rate"] = K_Line_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["closing_price_growth_rate"] = K_Line_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["closing_minus_opening_price_growth_rate"] = K_Line_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["high_price_proportion"] = K_Line_high_price_proportion;
                input_K_Line_Daily_Dict[key]["low_price_proportion"] = K_Line_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_2_turnover_volume_growth_rate"] = K_Line_sum_2_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_2_opening_price_growth_rate"] = K_Line_sum_2_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_2_closing_price_growth_rate"] = K_Line_sum_2_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_2_closing_minus_opening_price_growth_rate"] = K_Line_sum_2_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_2_high_price_proportion"] = K_Line_sum_2_high_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_2_low_price_proportion"] = K_Line_sum_2_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_2_KLine_Intuitive_Momentum"] = K_Line_sum_2_KLine_Intuitive_Momentum;
                input_K_Line_Daily_Dict[key]["sum_3_turnover_volume_growth_rate"] = K_Line_sum_3_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_3_opening_price_growth_rate"] = K_Line_sum_3_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_3_closing_price_growth_rate"] = K_Line_sum_3_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_3_closing_minus_opening_price_growth_rate"] = K_Line_sum_3_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_3_high_price_proportion"] = K_Line_sum_3_high_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_3_low_price_proportion"] = K_Line_sum_3_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_3_KLine_Intuitive_Momentum"] = K_Line_sum_3_KLine_Intuitive_Momentum;
                input_K_Line_Daily_Dict[key]["sum_5_turnover_volume_growth_rate"] = K_Line_sum_5_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_5_opening_price_growth_rate"] = K_Line_sum_5_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_5_closing_price_growth_rate"] = K_Line_sum_5_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_5_closing_minus_opening_price_growth_rate"] = K_Line_sum_5_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_5_high_price_proportion"] = K_Line_sum_5_high_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_5_low_price_proportion"] = K_Line_sum_5_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_5_KLine_Intuitive_Momentum"] = K_Line_sum_5_KLine_Intuitive_Momentum;
                input_K_Line_Daily_Dict[key]["sum_7_turnover_volume_growth_rate"] = K_Line_sum_7_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_7_opening_price_growth_rate"] = K_Line_sum_7_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_7_closing_price_growth_rate"] = K_Line_sum_7_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_7_closing_minus_opening_price_growth_rate"] = K_Line_sum_7_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_7_high_price_proportion"] = K_Line_sum_7_high_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_7_low_price_proportion"] = K_Line_sum_7_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_7_KLine_Intuitive_Momentum"] = K_Line_sum_7_KLine_Intuitive_Momentum;
                input_K_Line_Daily_Dict[key]["sum_10_turnover_volume_growth_rate"] = K_Line_sum_10_turnover_volume_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_10_opening_price_growth_rate"] = K_Line_sum_10_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_10_closing_price_growth_rate"] = K_Line_sum_10_closing_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_10_closing_minus_opening_price_growth_rate"] = K_Line_sum_10_closing_minus_opening_price_growth_rate;
                input_K_Line_Daily_Dict[key]["sum_10_high_price_proportion"] = K_Line_sum_10_high_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_10_low_price_proportion"] = K_Line_sum_10_low_price_proportion;
                input_K_Line_Daily_Dict[key]["sum_10_KLine_Intuitive_Momentum"] = K_Line_sum_10_KLine_Intuitive_Momentum;
                input_K_Line_Daily_Dict[key]["average_5_closing_price"] = K_Line_average_5_closing_price;
                input_K_Line_Daily_Dict[key]["average_10_closing_price"] = K_Line_average_10_closing_price;
                input_K_Line_Daily_Dict[key]["average_20_closing_price"] = K_Line_average_20_closing_price;
                input_K_Line_Daily_Dict[key]["average_30_closing_price"] = K_Line_average_30_closing_price;
                input_K_Line_Daily_Dict[key]["Pdata_0"] = Pdata_0;
                input_K_Line_Daily_Dict[key]["Plower"] = Plower;
                input_K_Line_Daily_Dict[key]["Pupper"] = Pupper;
                input_K_Line_Daily_Dict[key]["weight"] = weight;

                # 釋放内存;
                K_Line_focus = Core.nothing;
                K_Line_amplitude = Core.nothing;
                K_Line_amplitude_rate = Core.nothing;
                K_Line_opening_price_Standardization = Core.nothing;
                K_Line_closing_price_Standardization = Core.nothing;
                K_Line_low_price_Standardization = Core.nothing;
                K_Line_high_price_Standardization = Core.nothing;
                K_Line_turnover_rate = Core.nothing;
                K_Line_price_earnings = Core.nothing;
                K_Line_book_value_per_share = Core.nothing;
                K_Line_capitalization = Core.nothing;
                K_Line_turnover_volume_growth_rate = Core.nothing;
                K_Line_opening_price_growth_rate = Core.nothing;
                K_Line_closing_price_growth_rate = Core.nothing;
                K_Line_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_high_price_proportion = Core.nothing;
                K_Line_low_price_proportion = Core.nothing;
                K_Line_sum_2_turnover_volume_growth_rate = Core.nothing;
                K_Line_sum_2_opening_price_growth_rate = Core.nothing;
                K_Line_sum_2_closing_price_growth_rate = Core.nothing;
                K_Line_sum_2_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_sum_2_high_price_proportion = Core.nothing;
                K_Line_sum_2_low_price_proportion = Core.nothing;
                K_Line_sum_2_KLine_Intuitive_Momentum = Core.nothing;
                K_Line_sum_3_turnover_volume_growth_rate = Core.nothing;
                K_Line_sum_3_opening_price_growth_rate = Core.nothing;
                K_Line_sum_3_closing_price_growth_rate = Core.nothing;
                K_Line_sum_3_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_sum_3_high_price_proportion = Core.nothing;
                K_Line_sum_3_low_price_proportion = Core.nothing;
                K_Line_sum_3_KLine_Intuitive_Momentum = Core.nothing;
                K_Line_sum_5_turnover_volume_growth_rate = Core.nothing;
                K_Line_sum_5_opening_price_growth_rate = Core.nothing;
                K_Line_sum_5_closing_price_growth_rate = Core.nothing;
                K_Line_sum_5_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_sum_5_high_price_proportion = Core.nothing;
                K_Line_sum_5_low_price_proportion = Core.nothing;
                K_Line_sum_5_KLine_Intuitive_Momentum = Core.nothing;
                K_Line_sum_7_turnover_volume_growth_rate = Core.nothing;
                K_Line_sum_7_opening_price_growth_rate = Core.nothing;
                K_Line_sum_7_closing_price_growth_rate = Core.nothing;
                K_Line_sum_7_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_sum_7_high_price_proportion = Core.nothing;
                K_Line_sum_7_low_price_proportion = Core.nothing;
                K_Line_sum_7_KLine_Intuitive_Momentum = Core.nothing;
                K_Line_sum_10_turnover_volume_growth_rate = Core.nothing;
                K_Line_sum_10_opening_price_growth_rate = Core.nothing;
                K_Line_sum_10_closing_price_growth_rate = Core.nothing;
                K_Line_sum_10_closing_minus_opening_price_growth_rate = Core.nothing;
                K_Line_sum_10_high_price_proportion = Core.nothing;
                K_Line_sum_10_low_price_proportion = Core.nothing;
                K_Line_sum_10_KLine_Intuitive_Momentum = Core.nothing;
                K_Line_average_5_closing_price = Core.nothing;
                K_Line_average_10_closing_price = Core.nothing;
                K_Line_average_20_closing_price = Core.nothing;
                K_Line_average_30_closing_price = Core.nothing;
                Pdata_0 = Core.nothing;
                Plower = Core.nothing;
                Pupper = Core.nothing;
                weight = Core.nothing;
            end
        end
    end
end

stepping_data = input_K_Line_Daily_Dict;

input_K_Line_Daily_Dict = Core.nothing;  # 釋放内存;


# training_data = Base.Dict{Core.String, Core.Any}();
# training_data = stepping_data;

# testing_data = Base.Dict{Core.String, Core.Any}();
# testing_data = stepping_data;


# using Dates;
# using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# https://github.com/JuliaIO/JLD.jl
# using HDF5;
# https://github.com/JuliaIO/HDF5.jl
# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# 將字典（Base.Dict）類型數據，寫入磁盤（hide disk）的 Julia 語言特有類型的 JLD 類型（.jld）的變量存儲文檔;
# is_save_JLD = true;
if is_save_JLD
    # output_jld_K_Line_Daily_file = "C:/QuantitativeTrading/Data/steppingData.jld";
    JLD.save(
        output_jld_K_Line_Daily_file,
        "stepping_data",
        stepping_data
    );
    # stepping_data = JLD.load(
    #     output_jld_K_Line_Daily_file,
    #     "stepping_data"
    # );
    # println(stepping_data);

    # output_jld_K_Line_Daily_file = "C:/QuantitativeTrading/Data/testingData.jld";
    # JLD.save(
    #     output_jld_K_Line_Daily_file,
    #     "testing_data",
    #     testing_data
    # );
    # # testing_data = JLD.load(
    # #     output_jld_K_Line_Daily_file,
    # #     "testing_data"
    # # );
    # # println(testing_data);
end

# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# https://github.com/JuliaData/CSV.jl
# https://csv.juliadata.org/stable/
# 將字典（Base.Dict）類型數據，寫入磁盤（hide disk）的（.csv）類型的文檔;
# is_save_csv = false;
if is_save_csv
    # output_csv_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/";
    # Base.keys(stepping_data);
    for (key, value) in stepping_data
        local output_K_Line_Daily_file_name = Base.string(Base.string(key) * ".csv");
        local output_K_Line_Daily_file_I = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(output_csv_K_Line_Daily_file_dir), Base.string(output_K_Line_Daily_file_name)));
        local stepping_data_I_Equal_Length = Base.copy(value);  # Base.copy(stepping_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
        stepping_data_I_Equal_Length["date_transaction"] = [Base.string(Dates.format(stepping_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(stepping_data_I_Equal_Length["date_transaction"])];  # Dates.format(stepping_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-ddTHH:MM:SS.sss");  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;
        # Base.delete!(stepping_data_I_Equal_Length, "Pdata_0");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "Plower");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "Pupper");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "weight");  # 刪除字典中不等長的列;
        # 補齊字典中不等長的列，以 Base.missing 值填充;
        local max_row = Core.UInt(Base.maximum(Base.length, Base.values(stepping_data_I_Equal_Length)));
        for (key1, value1) in stepping_data_I_Equal_Length
            if Core.UInt(Base.length(value1)) < Core.UInt(max_row)
                stepping_data_I_Equal_Length[key1] = [(Core.UInt(i) <= Core.UInt(Base.length(value1))) ? value1[i] : Base.missing for i in Core.UInt(1):Core.UInt(max_row)];
                # for i = Core.UInt(Base.length(value1) + 1):Core.UInt(max_row)
                #     Base.push!(stepping_data_I_Equal_Length[key1], Base.missing);  # 補齊字典中不等長的列，以 Base.missing 值填充，使用 push! 函數在數組末尾追加推入新元素;
                # end
            end
        end
        local stepping_data_I_Frame = DataFrames.DataFrame(stepping_data_I_Equal_Length);  # 將字典（Base.Dict）類型的數據包裝爲數據框（DataFrames.DataFrame）類型的數據，因爲函數 CSV.write() 祇支持數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
        CSV.write(
            output_K_Line_Daily_file_I,
            stepping_data_I_Frame;
            writeheader = true,
            delim = ',',
            # quotechar = '"',
            # escapechar = '\\',
            newline = '\n',  # '\r\n',
            dateformat = "yyyy-mm-dd",  # "yyyy-mm-ddTHH:MM:SS.sss",
            # codechars = 0x01,
            # quotemark_string = "\"\"",
            # quotemark_char = "\"\"",
            # header = DataFrames.names(stepping_data_I_Frame),  # false, # Base.keys(value), # ["Column1", "Column2", "Column3"], # fieldnames(eltype(data)),
            append = false
        );
        stepping_data_I_Equal_Length = Core.nothing;  # 釋放内存;
        stepping_data_I_Frame = Core.nothing;  # 釋放内存;
    end

    # output_csv_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/";
    # # Base.keys(testing_data);
    # for (key, value) in testing_data
    #     local testing_K_Line_Daily_file_name = Base.string(Base.string(key) * ".csv");
    #     local testing_K_Line_Daily_file_I = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(output_csv_K_Line_Daily_file_dir), Base.string(testing_K_Line_Daily_file_name)));
    #     local testing_data_I_Equal_Length = Base.copy(value);  # Base.copy(testing_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
    #     testing_data_I_Equal_Length["date_transaction"] = [Base.string(Dates.format(testing_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(testing_data_I_Equal_Length["date_transaction"])];  # Dates.format(testing_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-ddTHH:MM:SS.sss");  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;
    #     # Base.delete!(testing_data_I_Equal_Length, "Pdata_0");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "Plower");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "Pupper");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "weight");  # 刪除字典中不等長的列;
    #     # 補齊字典中不等長的列，以 Base.missing 值填充;
    #     local max_row = Core.UInt(Base.maximum(Base.length, Base.values(testing_data_I_Equal_Length)));
    #     for (key1, value1) in testing_data_I_Equal_Length
    #         if Core.UInt(Base.length(value1)) < Core.UInt(max_row)
    #             testing_data_I_Equal_Length[key1] = [(Core.UInt(i) <= Core.UInt(Base.length(value1))) ? value1[i] : Base.missing for i in Core.UInt(1):Core.UInt(max_row)];
    #             # for i = Core.UInt(Base.length(value1) + 1):Core.UInt(max_row)
    #             #     Base.push!(testing_data_I_Equal_Length[key1], Base.missing);  # 補齊字典中不等長的列，以 Base.missing 值填充，使用 push! 函數在數組末尾追加推入新元素;
    #             # end
    #         end
    #     end
    #     local testing_data_I_Frame = DataFrames.DataFrame(testing_data_I_Equal_Length);  # 將字典（Base.Dict）類型的數據包裝爲數據框（DataFrames.DataFrame）類型的數據，因爲函數 CSV.write() 祇支持數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
    #     CSV.write(
    #         testing_K_Line_Daily_file_I,
    #         testing_data_I_Frame;
    #         writeheader = true,
    #         delim = ',',
    #         # quotechar = '"',
    #         # escapechar = '\\',
    #         newline = '\n',  # '\r\n',
    #         dateformat = "yyyy-mm-dd",  # "yyyy-mm-ddTHH:MM:SS.sss",
    #         # codechars = 0x01,
    #         # quotemark_string = "\"\"",
    #         # quotemark_char = "\"\"",
    #         # header = DataFrames.names(testing_data_I_Frame),  # false, # Base.keys(value), # ["Column1", "Column2", "Column3"], # fieldnames(eltype(data)),
    #         append = false
    #     );
    #     testing_data_I_Equal_Length = Core.nothing;  # 釋放内存;
    #     testing_data_I_Frame = Core.nothing;  # 釋放内存;
    # end
end

# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# https://github.com/JuliaData/DataFrames.jl
# https://dataframes.juliadata.org/stable/
# using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# https://github.com/felipenoris/XLSX.jl
# https://felipenoris.github.io/XLSX.jl/stable/
# 將字典（Base.Dict）類型數據，寫入磁盤（hide disk）的 Excel（.xlsx）類型的文檔;
# is_save_xlsx = false;
if is_save_xlsx
    # output_xlsx_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/";
    # Base.keys(stepping_data);
    for (key, value) in stepping_data
        local output_K_Line_Daily_file_name = Base.string(Base.string(key) * ".xlsx");
        local output_K_Line_Daily_file_I = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(output_xlsx_K_Line_Daily_file_dir), Base.string(output_K_Line_Daily_file_name)));
        local stepping_data_I_Equal_Length = Base.copy(value);  # Base.copy(stepping_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
        stepping_data_I_Equal_Length["date_transaction"] = [Base.string(Dates.format(stepping_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(stepping_data_I_Equal_Length["date_transaction"])];  # Dates.format(stepping_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-ddTHH:MM:SS.sss");  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;
        # Base.delete!(stepping_data_I_Equal_Length, "Pdata_0");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "Plower");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "Pupper");  # 刪除字典中不等長的列;
        # Base.delete!(stepping_data_I_Equal_Length, "weight");  # 刪除字典中不等長的列;
        # 補齊字典中不等長的列，以 Base.missing 值填充;
        local max_row = Core.UInt(Base.maximum(Base.length, Base.values(stepping_data_I_Equal_Length)));
        for (key1, value1) in stepping_data_I_Equal_Length
            if Core.UInt(Base.length(value1)) < Core.UInt(max_row)
                stepping_data_I_Equal_Length[key1] = [(Core.UInt(i) <= Core.UInt(Base.length(value1))) ? value1[i] : Base.missing for i in Core.UInt(1):Core.UInt(max_row)];
                # for i = Core.UInt(Base.length(value1) + 1):Core.UInt(max_row)
                #     Base.push!(stepping_data_I_Equal_Length[key1], Base.missing);  # 補齊字典中不等長的列，以 Base.missing 值填充，使用 push! 函數在數組末尾追加推入新元素;
                # end
            end
        end
        # # 創建新的 Excel（.xlsx）文檔，並寫入 Julia 的字典（Base.Dict）數據;
        # XLSX.openxlsx(output_K_Line_Daily_file_I, mode = "w") do xf
        #     sheet = xf[1];
        #     XLSX.rename!(sheet, Base.string(key));
        #     # sheet = XLSX.addsheet!(xf, "sheet2");  # 增加新的工作簿（Sheet）;
        #     for i in 1:Base.keys(stepping_data_I_Equal_Length)
        #         # 使用函數 Base.cat() 拼接數組;
        #         local column_I = Base.cat(
        #             [Base.string(Base.keys(stepping_data_I_Equal_Length)[i])],
        #             stepping_data_I_Equal_Length(Base.keys(stepping_data_I_Equal_Length)[i]),
        #             dims = 1
        #         );
        #         sheet[i,:] = column_I;
        #     end
        # end
        local stepping_data_I_Frame = DataFrames.DataFrame(stepping_data_I_Equal_Length);  # 將字典（Base.Dict）類型的數據包裝爲數據框（DataFrames.DataFrame）類型的數據，因爲函數 CSV.write() 祇支持數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
        XLSX.openxlsx(output_K_Line_Daily_file_I, mode = "w") do xf
            sheet = xf[1];
            XLSX.rename!(sheet, Base.string(key));
            # sheet = XLSX.addsheet!(xf, "sheet2");  # 增加新的工作簿（Sheet）;
            XLSX.writetable!(
                sheet,
                Base.collect(DataFrames.eachcol(stepping_data_I_Frame)),
                DataFrames.names(stepping_data_I_Frame);
                anchor_cell = XLSX.CellRef("A1")
            );
        end
        # XLSX.writetable(
        #     output_K_Line_Daily_file_I,
        #     Base.collect(DataFrames.eachcol(stepping_data_I_Frame)),
        #     DataFrames.names(stepping_data_I_Frame);
        #     sheetname = Base.string(key),
        #     anchor_cell = "A1",
        #     overwrite = true
        # );
        stepping_data_I_Equal_Length = Core.nothing;  # 釋放内存;
        stepping_data_I_Frame = Core.nothing;  # 釋放内存;
    end

    # output_xlsx_K_Line_Daily_file_dir = "C:/QuantitativeTrading/Data/K-Day/";
    # # Base.keys(testing_data);
    # for (key, value) in testing_data
    #     local testing_K_Line_Daily_file_name = Base.string(Base.string(key) * ".xlsx");
    #     local testing_K_Line_Daily_file_I = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(output_xlsx_K_Line_Daily_file_dir), Base.string(testing_K_Line_Daily_file_name)));
    #     local testing_data_I_Equal_Length = Base.copy(value);  # Base.copy(testing_data[key]);  # 深複製（傳值）字典副本，以防原字典數據被修改;
    #     testing_data_I_Equal_Length["date_transaction"] = [Base.string(Dates.format(testing_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(testing_data_I_Equal_Length["date_transaction"])];  # Dates.format(testing_data_I_Equal_Length["date_transaction"][i], "yyyy-mm-ddTHH:MM:SS.sss");  # 將日期（Dates.Date）類型數據轉換爲字符串（Core.String）類型數據;
    #     # Base.delete!(testing_data_I_Equal_Length, "Pdata_0");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "Plower");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "Pupper");  # 刪除字典中不等長的列;
    #     # Base.delete!(testing_data_I_Equal_Length, "weight");  # 刪除字典中不等長的列;
    #     # 補齊字典中不等長的列，以 Base.missing 值填充;
    #     local max_row = Core.UInt(Base.maximum(Base.length, Base.values(testing_data_I_Equal_Length)));
    #     for (key1, value1) in testing_data_I_Equal_Length
    #         if Core.UInt(Base.length(value1)) < Core.UInt(max_row)
    #             testing_data_I_Equal_Length[key1] = [(Core.UInt(i) <= Core.UInt(Base.length(value1))) ? value1[i] : Base.missing for i in Core.UInt(1):Core.UInt(max_row)];
    #             # for i = Core.UInt(Base.length(value1) + 1):Core.UInt(max_row)
    #             #     Base.push!(testing_data_I_Equal_Length[key1], Base.missing);  # 補齊字典中不等長的列，以 Base.missing 值填充，使用 push! 函數在數組末尾追加推入新元素;
    #             # end
    #         end
    #     end
    #     # # 創建新的 Excel（.xlsx）文檔，並寫入 Julia 的字典（Base.Dict）數據;
    #     # XLSX.openxlsx(testing_K_Line_Daily_file_I, mode = "w") do xf
    #     #     sheet = xf[1];
    #     #     XLSX.rename!(sheet, Base.string(key));
    #     #     # sheet = XLSX.addsheet!(xf, "sheet2");  # 增加新的工作簿（Sheet）;
    #     #     for i in 1:Base.keys(testing_data_I_Equal_Length)
    #     #         # 使用函數 Base.cat() 拼接數組;
    #     #         local column_I = Base.cat(
    #     #             [Base.string(Base.keys(testing_data_I_Equal_Length)[i])],
    #     #             testing_data_I_Equal_Length(Base.keys(testing_data_I_Equal_Length)[i]),
    #     #             dims = 1
    #     #         );
    #     #         sheet[i,:] = column_I;
    #     #     end
    #     # end
    #     local testing_data_I_Frame = DataFrames.DataFrame(testing_data_I_Equal_Length);  # 將字典（Base.Dict）類型的數據包裝爲數據框（DataFrames.DataFrame）類型的數據，因爲函數 CSV.write() 祇支持數據框（DataFrames.DataFrame）類型的數據寫入 .csv 文檔;
    #     XLSX.openxlsx(testing_K_Line_Daily_file_I, mode = "w") do xf
    #         sheet = xf[1];
    #         XLSX.rename!(sheet, Base.string(key));
    #         # sheet = XLSX.addsheet!(xf, "sheet2");  # 增加新的工作簿（Sheet）;
    #         XLSX.writetable!(
    #             sheet,
    #             Base.collect(DataFrames.eachcol(testing_data_I_Frame)),
    #             DataFrames.names(testing_data_I_Frame);
    #             anchor_cell = XLSX.CellRef("A1")
    #         );
    #     end
    #     # XLSX.writetable(
    #     #     testing_K_Line_Daily_file_I,
    #     #     Base.collect(DataFrames.eachcol(testing_data_I_Frame)),
    #     #     DataFrames.names(testing_data_I_Frame);
    #     #     sheetname = Base.string(key),
    #     #     anchor_cell = "A1",
    #     #     overwrite = true
    #     # );
    #     testing_data_I_Equal_Length = Core.nothing;  # 釋放内存;
    #     testing_data_I_Frame = Core.nothing;  # 釋放内存;
    # end
end

# # http://gadflyjl.org/stable/gallery/geometries/#[Geom.segment](@ref)
# # 繪圖;
# is_visualization = false;
# img1 = Core.nothing;
# img2 = Core.nothing;
# if is_visualization

#     set_default_plot_size(21cm, 21cm);  # 設定畫布規格;

#     # 繪製訓練集折缐圖示;
#     # img1 = Core.nothing;
#     if Base.isa(stepping_data, Base.Dict) && Base.length(stepping_data) > 0
#         stepping_data_Index = stepping_data["002611"];

#         points1 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["focus"],  # YdataMean,  # Ydata,
#             Geom.point,
#             color = [colorant"black"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#             Theme(
#                 line_width = 1pt,
#                 point_size = 1pt,
#                 point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#             )
#         );
#         smoothline1 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["focus"],  # YdataMean,  # Yvals,
#             # ymin = stepping_data_Index["low_price"],  # YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
#             # ymax = stepping_data_Index["high_price"],  # YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
#             Geom.line,  # Geom.smooth,
#             # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
#             Theme(
#                 # point_size = 5pt,
#                 line_width = 1.0pt,
#                 line_style = [:solid],  # :dot
#                 default_color = "black",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#                 alphas = [1],
#                 # lowlight_color = c->"gray"
#             )  # color = [colorant"red"],
#         );
#         smoothline2 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["low_price"],  # YvalsUncertaintyLower,
#             Geom.line,  # Geom.smooth,
#             Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"yellow"],  # "brown", "purple"
#         );
#         smoothline3 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["high_price"],  # YvalsUncertaintyUpper,
#             Geom.line,  # Geom.smooth,
#             Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"yellow"],  # "brown", "purple"
#         );
#         # 繪製置信區間填充圖;
#         ribbonline1 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             # y = stepping_data_Index["focus"],  # YdataMean,  # Yvals,
#             ymin = stepping_data_Index["low_price"],  # YvalsUncertaintyLower,
#             ymax = stepping_data_Index["high_price"],  # YvalsUncertaintyUpper,
#             # Geom.line,  # Geom.smooth,
#             Geom.ribbon(fill = true),
#             Theme(
#                 # point_size = 5pt,
#                 line_width = 0.1pt,
#                 line_style = [:dot],  # :solid
#                 default_color = "gray",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#                 alphas = [0.5],
#                 # lowlight_color = c->"gray"
#             )  # color = [colorant"red"],
#         );
#         smoothline4 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["opening_price"],  # YvalsUncertaintyLower,
#             Geom.line,  # Geom.smooth,
#             Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"red"],
#         );
#         smoothline5 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             y = stepping_data_Index["close_price"],  # YvalsUncertaintyUpper,
#             Geom.line,  # Geom.smooth,
#             Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"green"],
#         );
#         # 繪製置信區間填充圖;
#         ribbonline2 = Gadfly.layer(
#             x = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#             # y = stepping_data_Index["focus"],  # YdataMean,  # Yvals,
#             ymin = [Core.Float64(Base.findmin([Core.Float64(stepping_data_Index["opening_price"][i]), Core.Float64(stepping_data_Index["close_price"][i])])[1]) for i in 1:Base.length(stepping_data_Index["focus"])],  # stepping_data_Index["opening_price"],  # YvalsUncertaintyLower,
#             ymax = [Core.Float64(Base.findmax([Core.Float64(stepping_data_Index["opening_price"][i]), Core.Float64(stepping_data_Index["close_price"][i])])[1]) for i in 1:Base.length(stepping_data_Index["focus"])],  # stepping_data_Index["close_price"],  # YvalsUncertaintyUpper,
#             # Geom.line,  # Geom.smooth,
#             Geom.ribbon(fill = true),
#             Theme(
#                 # point_size = 5pt,
#                 line_width = 0.1pt,
#                 line_style = [:dot],  # :solid
#                 default_color = "gray",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#                 alphas = [0.5],
#                 # lowlight_color = c->"gray"
#             )  # color = [colorant"red"],
#         );
#         # buy_x = Core.Array{Core.Int64, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Core.Int64(training_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("buy")) ? Core.Int64(training_result["date_transaction"][i][6]) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # buy_y = Core.Array{Core.Float64, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Core.Float64(training_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("buy")) ? Core.Float64(training_result["date_transaction"][i][3]) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # buy_label = Core.Array{Core.String, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("buy")) ? Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # for i in 1:Base.length(training_result["date_transaction"])
#         #     if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy")
#         #         # Base.push!(buy_x, training_result["date_transaction"][i][1]);
#         #         Base.push!(buy_x, Core.Int64(training_result["date_transaction"][i][6]));
#         #         Base.push!(buy_y, Core.Float64(training_result["date_transaction"][i][3]));
#         #         Base.push!(buy_label, Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])));
#         #     end
#         # end
#         # points2 = Gadfly.layer(
#         #     x = buy_x,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Core.Int64(training_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     y = buy_y,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Core.Float64(training_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],  # stepping_data_Index["focus"],  # YdataMean,  # Ydata,
#         #     Geom.point,
#         #     label = buy_label,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("buy") Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],
#         #     Geom.label(
#         #         position = :above,  # :left, :right, :above, :below, :centered, or :dynamic
#         #         hide_overlaps = true
#         #     ),
#         #     color = [colorant"red"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#         #     Theme(
#         #         line_width = 1pt,
#         #         point_size = 3pt,
#         #         point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#         #     )
#         # );
#         # sell_x = Core.Array{Core.Int64, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Core.Int64(training_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("sell")) ? Core.Int64(training_result["date_transaction"][i][6]) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # sell_y = Core.Array{Core.Float64, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Core.Float64(training_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("sell")) ? Core.Float64(training_result["date_transaction"][i][3]) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # sell_label = Core.Array{Core.String, 1}();
#         # # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])];
#         # # [(Base.string(training_result["date_transaction"][i][2]) === Base.string("sell")) ? Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) : Core.nothing for i in 1:Base.length(training_result["date_transaction"])];
#         # for i in 1:Base.length(training_result["date_transaction"])
#         #     if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell")
#         #         # Base.push!(sell_x, training_result["date_transaction"][i][1]);
#         #         Base.push!(sell_x, Core.Int64(training_result["date_transaction"][i][6]));
#         #         Base.push!(sell_y, Core.Float64(training_result["date_transaction"][i][3]));
#         #         Base.push!(sell_label, Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])));
#         #     end
#         # end
#         # points3 = Gadfly.layer(
#         #     x = sell_x,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Core.Int64(training_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     y = sell_y,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Core.Float64(training_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],  # stepping_data_Index["focus"],  # YdataMean,  # Ydata,
#         #     Geom.point,
#         #     label = sell_label,  # [if Base.string(training_result["date_transaction"][i][2]) === Base.string("sell") Base.string(Base.string(training_result["date_transaction"][i][2]) * " " * Base.string(training_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(training_result["date_transaction"])],
#         #     Geom.label(
#         #         position = :above,  # :left, :right, :above, :below, :centered, or :dynamic
#         #         hide_overlaps = true
#         #     ),
#         #     color = [colorant"green"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#         #     Theme(
#         #         line_width = 1pt,
#         #         point_size = 3pt,
#         #         point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#         #     )
#         # );
#         img1 = Gadfly.plot(
#             points1,
#             # smoothline1,
#             smoothline2,
#             smoothline3,
#             ribbonline1,
#             # smoothline4,
#             # smoothline5,
#             # ribbonline2,
#             # points2,
#             # points3,
#             # Guide.xlabel("Independent Variable ( x )"),
#             Guide.xlabel("transaction date"),
#             # Guide.ylabel("Dependent Variable ( y )"),
#             Guide.ylabel("transaction price"),
#             # Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"]),
#             Guide.xticks(
#                 # ticks = [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # 設置 X 軸刻度值;
#                 # ticks = [Base.string(Dates.format(stepping_data_Index["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # 設置 X 軸刻度標簽的文本;
#                 # orientation = :vertical,  # 刻度標簽文本旋轉九十度垂直顯示;
#                 label = false
#             ),
#             # Guide.yticks(
#             #     ticks = [Core.Int64(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(stepping_data_Index["low_price"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(stepping_data_Index["high_price"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度值;
#             #     ticks = [Base.string(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(stepping_data_Index["low_price"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(stepping_data_Index["high_price"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度標簽的文本;
#             #     # ticks = [Core.Int64(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(stepping_data_Index["focus"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(stepping_data_Index["focus"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度值;
#             #     # ticks = [Base.string(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(stepping_data_Index["focus"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(stepping_data_Index["focus"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度標簽的文本;
#             #     orientation = :horizontal,  # 刻度標簽文本水平顯示;
#             #     label = true
#             # ),
#             Guide.title("market timing model ( training )")
#         );
#         # img1 = Gadfly.plot(
#         #     x = stepping_data_Index["date_transaction"],  # [Base.string(Dates.format(stepping_data_Index["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(stepping_data_Index["date_transaction"])],  # stepping_data_Index["date_transaction"],  # Xdata,
#         #     open = stepping_data_Index["opening_price"],
#         #     high = stepping_data_Index["high_price"],
#         #     low = stepping_data_Index["low_price"],
#         #     close = stepping_data_Index["close_price"],
#         #     Geom.candlestick,
#         #     Scale.color_discrete_manual("green", "red"),
#         #     Scale.x_discrete,
#         #     Guide.title("market timing model ( training )"),
#         #     # points2,
#         #     # points3,
#         #     # Guide.manual_discrete_key("Strategy Trading", ["buy", "sell"]; ["blue", "blue"]),
#         #     # Guide.manual_discrete_key(title="Strategy Trading", labels=["buy", "sell"]; pos=[], color=["blue", "blue"], shape=[], size=[]),
#         # );
#         # Gadfly.draw(
#         #     Gadfly.SVG(
#         #         "./Curvefit.svg",
#         #         21cm,
#         #         21cm
#         #     ),  # 保存爲 .svg 格式圖片;
#         #     # Gadfly.PDF(
#         #     #     "Curvefit.pdf",
#         #     #     21cm,
#         #     #     21cm
#         #     # ),  # 保存爲 .pdf 格式圖片;
#         #     # Gadfly.PNG(
#         #     #     "Curvefit.png",
#         #     #     21cm,
#         #     #     21cm
#         #     # ),  # 保存爲 .png 格式圖片;
#         #     img1
#         # );
#     end

#     # # 繪製測試集折缐圖示;
#     # # img2 = Core.nothing;
#     # if Base.isa(testing_data, Base.Dict) && Base.length(testing_data) > 0
#     #     testing_data_Index = testing_data["002611"];

#     #     points1 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["focus"],  # YdataMean,  # Ydata,
#     #         Geom.point,
#     #         color = [colorant"black"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #         Theme(
#     #             line_width = 1pt,
#     #             point_size = 1pt,
#     #             point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#     #         )
#     #     );
#     #     smoothline1 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["focus"],  # YdataMean,  # Yvals,
#     #         # ymin = testing_data_Index["low_price"],  # YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
#     #         # ymax = testing_data_Index["high_price"],  # YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
#     #         Geom.line,  # Geom.smooth,
#     #         # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
#     #         Theme(
#     #             # point_size = 5pt,
#     #             line_width = 1.0pt,
#     #             line_style = [:solid],  # :dot
#     #             default_color = "black",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #             alphas = [1],
#     #             # lowlight_color = c->"gray"
#     #         )  # color = [colorant"red"],
#     #     );
#     #     smoothline2 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["low_price"],  # YvalsUncertaintyLower,
#     #         Geom.line,  # Geom.smooth,
#     #         Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"yellow"],  # "brown", "purple"
#     #     );
#     #     smoothline3 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["high_price"],  # YvalsUncertaintyUpper,
#     #         Geom.line,  # Geom.smooth,
#     #         Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"yellow"],  # "brown", "purple"
#     #     );
#     #     # 繪製置信區間填充圖;
#     #     ribbonline1 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         # y = testing_data_Index["focus"],  # YdataMean,  # Yvals,
#     #         ymin = testing_data_Index["low_price"],  # YvalsUncertaintyLower,
#     #         ymax = testing_data_Index["high_price"],  # YvalsUncertaintyUpper,
#     #         # Geom.line,  # Geom.smooth,
#     #         Geom.ribbon(fill = true),
#     #         Theme(
#     #             # point_size = 5pt,
#     #             line_width = 0.1pt,
#     #             line_style = [:dot],  # :solid
#     #             default_color = "gray",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #             alphas = [0.5],
#     #             # lowlight_color = c->"gray"
#     #         )  # color = [colorant"red"],
#     #     );
#     #     smoothline4 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["opening_price"],  # YvalsUncertaintyLower,
#     #         Geom.line,  # Geom.smooth,
#     #         Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"red"],
#     #     );
#     #     smoothline5 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         y = testing_data_Index["close_price"],  # YvalsUncertaintyUpper,
#     #         Geom.line,  # Geom.smooth,
#     #         Theme(line_width=0.5pt, line_style=[:dot], default_color="black", alphas=[0.3],)  # color=[colorant"green"],
#     #     );
#     #     # 繪製置信區間填充圖;
#     #     ribbonline2 = Gadfly.layer(
#     #         x = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #         # y = testing_data_Index["focus"],  # YdataMean,  # Yvals,
#     #         ymin = [Core.Float64(Base.findmin([Core.Float64(testing_data_Index["opening_price"][i]), Core.Float64(testing_data_Index["close_price"][i])])[1]) for i in 1:Base.length(testing_data_Index["focus"])],  # testing_data_Index["opening_price"],  # YvalsUncertaintyLower,
#     #         ymax = [Core.Float64(Base.findmax([Core.Float64(testing_data_Index["opening_price"][i]), Core.Float64(testing_data_Index["close_price"][i])])[1]) for i in 1:Base.length(testing_data_Index["focus"])],  # testing_data_Index["close_price"],  # YvalsUncertaintyUpper,
#     #         # Geom.line,  # Geom.smooth,
#     #         Geom.ribbon(fill = true),
#     #         Theme(
#     #             # point_size = 5pt,
#     #             line_width = 0.1pt,
#     #             line_style = [:dot],  # :solid
#     #             default_color = "gray",  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #             alphas = [0.5],
#     #             # lowlight_color = c->"gray"
#     #         )  # color = [colorant"red"],
#     #     );
#     #     # buy_x = Core.Array{Core.Int64, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Core.Int64(test_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("buy")) ? Core.Int64(test_result["date_transaction"][i][6]) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # buy_y = Core.Array{Core.Float64, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Core.Float64(test_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("buy")) ? Core.Float64(test_result["date_transaction"][i][3]) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # buy_label = Core.Array{Core.String, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("buy")) ? Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # for i in 1:Base.length(test_result["date_transaction"])
#     #     #     if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy")
#     #     #         # Base.push!(buy_x, test_result["date_transaction"][i][1]);
#     #     #         Base.push!(buy_x, Core.Int64(test_result["date_transaction"][i][6]));
#     #     #         Base.push!(buy_y, Core.Float64(test_result["date_transaction"][i][3]));
#     #     #         Base.push!(buy_label, Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])));
#     #     #     end
#     #     # end
#     #     # points2 = Gadfly.layer(
#     #     #     x = buy_x,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Core.Int64(test_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     y = buy_y,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Core.Float64(test_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],  # testing_data_Index["focus"],  # YdataMean,  # Ydata,
#     #     #     Geom.point,
#     #     #     label = buy_label,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("buy") Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],
#     #     #     Geom.label(
#     #     #         position = :above,  # :left, :right, :above, :below, :centered, or :dynamic
#     #     #         hide_overlaps = true
#     #     #     ),
#     #     #     color = [colorant"red"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #     #     Theme(
#     #     #         line_width = 1pt,
#     #     #         point_size = 3pt,
#     #     #         point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#     #     #     )
#     #     # );
#     #     # sell_x = Core.Array{Core.Int64, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Core.Int64(test_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("sell")) ? Core.Int64(test_result["date_transaction"][i][6]) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # sell_y = Core.Array{Core.Float64, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Core.Float64(test_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("sell")) ? Core.Float64(test_result["date_transaction"][i][3]) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # sell_label = Core.Array{Core.String, 1}();
#     #     # # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])];
#     #     # # [(Base.string(test_result["date_transaction"][i][2]) === Base.string("sell")) ? Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) : Core.nothing for i in 1:Base.length(test_result["date_transaction"])];
#     #     # for i in 1:Base.length(test_result["date_transaction"])
#     #     #     if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell")
#     #     #         # Base.push!(sell_x, test_result["date_transaction"][i][1]);
#     #     #         Base.push!(sell_x, Core.Int64(test_result["date_transaction"][i][6]));
#     #     #         Base.push!(sell_y, Core.Float64(test_result["date_transaction"][i][3]));
#     #     #         Base.push!(sell_label, Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])));
#     #     #     end
#     #     # end
#     #     # points3 = Gadfly.layer(
#     #     #     x = sell_x,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Core.Int64(test_result["date_transaction"][i][6]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     y = sell_y,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Core.Float64(test_result["date_transaction"][i][3]) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],  # testing_data_Index["focus"],  # YdataMean,  # Ydata,
#     #     #     Geom.point,
#     #     #     label = sell_label,  # [if Base.string(test_result["date_transaction"][i][2]) === Base.string("sell") Base.string(Base.string(test_result["date_transaction"][i][2]) * " " * Base.string(test_result["date_transaction"][i][5])) else Core.nothing end for i in 1:Base.length(test_result["date_transaction"])],
#     #     #     Geom.label(
#     #     #         position = :above,  # :left, :right, :above, :below, :centered, or :dynamic
#     #     #         hide_overlaps = true
#     #     #     ),
#     #     #     color = [colorant"green"],  # "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige", "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan", "darkgoldenrod", "darkgray", "darkgrey", "darkgreen", "darkkhaki", "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred", "darksalmon", "darkseagreen", "darkslateblue", "darkslategray", "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite", "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod", "gray", "grey", "green", "greenyellow", "honeydew", "hotpink", "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush", "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan", "lightgoldenrodyellow", "lightgray", "lightgrey", "lightpink", "lightsalmon"
#     #     #     Theme(
#     #     #         line_width = 1pt,
#     #     #         point_size = 3pt,
#     #     #         point_shapes = [Gadfly.Shape.vline],  # Gadfly.Shape.circle, Gadfly.Shape.square, Gadfly.Shape.diamond, Gadfly.Shape.cross, Gadfly.Shape.xcross, Gadfly.Shape.utriangle, Gadfly.Shape.dtriangle, Gadfly.Shape.star1, Gadfly.Shape.star2, Gadfly.Shape.hexagon, Gadfly.Shape.octagon, Gadfly.Shape.hline, Gadfly.Shape.vline, Gadfly.Shape.ltriangle, Gadfly.Shape.rtriangle
#     #     #     )
#     #     # );
#     #     img2 = Gadfly.plot(
#     #         points1,
#     #         # smoothline1,
#     #         smoothline2,
#     #         smoothline3,
#     #         ribbonline1,
#     #         # smoothline4,
#     #         # smoothline5,
#     #         # ribbonline2,
#     #         # points2,
#     #         # points3,
#     #         # Guide.xlabel("Independent Variable ( x )"),
#     #         Guide.xlabel("transaction date"),
#     #         # Guide.ylabel("Dependent Variable ( y )"),
#     #         Guide.ylabel("transaction price"),
#     #         # Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"]),
#     #         Guide.xticks(
#     #             # ticks = [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # 設置 X 軸刻度值;
#     #             # ticks = [Base.string(Dates.format(testing_data_Index["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # 設置 X 軸刻度標簽的文本;
#     #             # orientation = :vertical,  # 刻度標簽文本旋轉九十度垂直顯示;
#     #             label = false
#     #         ),
#     #         # Guide.yticks(
#     #         #     ticks = [Core.Int64(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(testing_data_Index["low_price"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(testing_data_Index["high_price"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度值;
#     #         #     ticks = [Base.string(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(testing_data_Index["low_price"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(testing_data_Index["high_price"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度標簽的文本;
#     #         #     # ticks = [Core.Int64(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(testing_data_Index["focus"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(testing_data_Index["focus"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度值;
#     #         #     # ticks = [Base.string(i) for i in Core.Int64(Base.floor(Core.Float64(Core.Float64(Base.findmin(testing_data_Index["focus"])[1]) * Core.Float64(0.9)))):Core.Int64(Base.ceil(Core.Float64(Core.Float64(Base.findmax(testing_data_Index["focus"])[1]) * Core.Float64(1.1))))],  # 設置 Y 軸刻度標簽的文本;
#     #         #     orientation = :horizontal,  # 刻度標簽文本水平顯示;
#     #         #     label = true
#     #         # ),
#     #         Guide.title("market timing model ( test )")
#     #     );
#     #     # img2 = Gadfly.plot(
#     #     #     x = testing_data_Index["date_transaction"],  # [Base.string(Dates.format(testing_data_Index["date_transaction"][i], "yyyy-mm-dd")) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # [Core.Int64(i) for i in 1:Base.length(testing_data_Index["date_transaction"])],  # testing_data_Index["date_transaction"],  # Xdata,
#     #     #     open = testing_data_Index["opening_price"],
#     #     #     high = testing_data_Index["high_price"],
#     #     #     low = testing_data_Index["low_price"],
#     #     #     close = testing_data_Index["close_price"],
#     #     #     Geom.candlestick,
#     #     #     Scale.color_discrete_manual("green", "red"),
#     #     #     Scale.x_discrete,
#     #     #     Guide.title("market timing model ( test )"),
#     #     #     # points2,
#     #     #     # points3,
#     #     #     # Guide.manual_discrete_key("Strategy Trading", ["buy", "sell"]; ["blue", "blue"]),
#     #     #     # Guide.manual_discrete_key(title="Strategy Trading", labels=["buy", "sell"]; pos=[], color=["blue", "blue"], shape=[], size=[]),
#     #     # );
#     #     # Gadfly.draw(
#     #     #     Gadfly.SVG(
#     #     #         "./Curvefit.svg",
#     #     #         21cm,
#     #     #         21cm
#     #     #     ),  # 保存爲 .svg 格式圖片;
#     #     #     # Gadfly.PDF(
#     #     #     #     "Curvefit.pdf",
#     #     #     #     21cm,
#     #     #     #     21cm
#     #     #     # ),  # 保存爲 .pdf 格式圖片;
#     #     #     # Gadfly.PNG(
#     #     #     #     "Curvefit.png",
#     #     #     #     21cm,
#     #     #     #     21cm
#     #     #     # ),  # 保存爲 .png 格式圖片;
#     #     #     img2
#     #     # );
#     # end

#     # # Gadfly.hstack(img1, img2);
#     # # Gadfly.title(Gadfly.hstack(img1, img2), "market timing model optimization");
#     # Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2));
#     # Gadfly.title(Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2)), "market timing model optimization");

#     Gadfly.vstack(Gadfly.hstack(img1));
# end

# print(Base.string("configFile=" * Base.string(configFile) * "\n" * "input_K_Line=" * Base.string(input_K_Line_Daily_file) * "\n" * "is_save_JLD=" * Base.string(is_save_JLD) * "\n" * "output_jld_K_Line=" * Base.string(output_jld_K_Line_Daily_file) * "\n" * "is_save_csv=" * Base.string(is_save_csv) * "\n" * "output_csv_K_Line=" * Base.string(output_csv_K_Line_Daily_file_dir) * "\n" * "is_save_xlsx=" * Base.string(is_save_xlsx) * "\n" * "output_xlsx_K_Line=" * Base.string(output_xlsx_K_Line_Daily_file_dir)));
Base.write(Base.stdout, Base.string("configFile=" * Base.string(configFile) * "\n" * "input_K_Line=" * Base.string(input_K_Line_Daily_file) * "\n" * "is_save_JLD=" * Base.string(is_save_JLD) * "\n" * "output_jld_K_Line=" * Base.string(output_jld_K_Line_Daily_file) * "\n" * "is_save_csv=" * Base.string(is_save_csv) * "\n" * "output_csv_K_Line=" * Base.string(output_csv_K_Line_Daily_file_dir) * "\n" * "is_save_xlsx=" * Base.string(is_save_xlsx) * "\n" * "output_xlsx_K_Line=" * Base.string(output_xlsx_K_Line_Daily_file_dir)));
Base.write(Base.stdout, Base.string("\r\n\r\n"));  # 寫入區隔符（"\r\n\r\n"）;
Base.write(Base.stdout, Base.string(JSONstring(stepping_data)));  # 使用藉助第三方擴展包「JSON」裏的 JSON.json() 函數創建的自定義的 JSONstring() 函數將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
end  # 封閉前對應塊語句：module Quantitative_Data_Cleaning

Base.exit(0);
