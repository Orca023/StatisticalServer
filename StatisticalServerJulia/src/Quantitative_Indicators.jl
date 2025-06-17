# module Quantitative_Indicators
# Main.Quantitative_Indicators
Base.push!(LOAD_PATH, ".")  # 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;
# Base.MainInclude.include(Base.filter(Base.contains(r".*\.jl$"), Base.Filesystem.readdir()));  # 在 Jupyterlab 中實現加載 Base.MainInclude.include("*.jl") 文檔，其中 r".*\.jl$" 為解析脚本文檔名的正則表達式;
# Base.MainInclude.include(popfirst!(ARGS));
# println(Base.PROGRAM_FILE)


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
# Base.MainInclude.include("/home/QuantitativeTrading/QuantitativeTradingJulia/Quantitative_Indicators.jl");
# Base.MainInclude.include("C:/QuantitativeTrading/QuantitativeTradingJulia/Quantitative_Indicators.jl");
# Base.MainInclude.include("./Quantitative_Indicators.jl");

# 控制臺命令列運行指令：
# C:\> C:/QuantitativeTrading/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/QuantitativeTrading/QuantitativeTradingJulia/ C:/QuantitativeTrading/QuantitativeTradingJulia/QuantitativeTradingServer.jl configFile=C:/QuantitativeTrading/config.txt webPath=C:/QuantitativeTrading/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/QuantitativeTrading/Intermediary/ monitor_file=C:/QuantitativeTrading/Intermediary/intermediary_write_C.txt output_dir=C:/QuantitativeTrading/Intermediary/ output_file=C:/QuantitativeTrading/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/QuantitativeTrading/temp/
# root@localhost:~# /usr/julia/julia-1.10.3/bin/julia -p 4 --project=/home/QuantitativeTrading/QuantitativeTradingJulia/ /home/QuantitativeTrading/QuantitativeTradingJulia/QuantitativeTradingServer.jl configFile=/home/QuantitativeTrading/config.txt webPath=/home/QuantitativeTrading/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/QuantitativeTrading/Intermediary/ monitor_file=/home/QuantitativeTrading/Intermediary/intermediary_write_C.txt output_dir=/home/QuantitativeTrading/Intermediary/ output_file=/home/QuantitativeTrading/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/QuantitativeTrading/temp/

#################################################################################;


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
# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# # https://github.com/JuliaData/DataFrames.jl
# # https://dataframes.juliadata.org/stable/
# using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# https://github.com/JuliaIO/JLD.jl
# using HDF5;
# # https://github.com/JuliaIO/HDF5.jl
# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# # https://github.com/JuliaIO/JSON.jl
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# # https://github.com/JuliaData/CSV.jl
# # https://csv.juliadata.org/stable/
# using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# # https://github.com/felipenoris/XLSX.jl
# # https://felipenoris.github.io/XLSX.jl/stable/
# using Optim;  # 導入第三方擴展包「Optim」，用於通用形式優化問題求解（optimization），需要在控制臺先安裝第三方擴展包「Optim」：julia> using Pkg; Pkg.add("Optim") 成功之後才能使用;
# https://julianlsolvers.github.io/Optim.jl/stable/
# https://github.com/JuliaNLSolvers/Optim.jl
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

Distributed.@everywhere using Statistics, Dates, Distributed;

# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
# Base.MainInclude.include("./Statis_Descript.jl");
# Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Statis_Descript.jl"));
# Base.Filesystem.joinpath(Base.@__DIR__, "Statis_Descript.jl")
# Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Statis_Descript.jl")
# Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Statis_Descript.jl")

# 匯入自定義的日棒缐（K-Line）原始數據整理模組脚本文檔「./Quantitative_Data_Cleaning.jl」;
# Base.MainInclude.include("./Quantitative_Data_Cleaning.jl");



# 零（0）、量化指標：勢;

# 計算趨勢抽象指標（勢强）示意值;
function Intuitive_Momentum(
    Series_Array,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight = Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
)

    index_P1_random = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
    if Base.typeof(Series_Array) <: Core.Array && Base.length(Series_Array) > 0

        # index_P1_random = Core.Array{Core.Any, 1}();
        for i = 1:Base.length(Series_Array)

            index_P1 = Base.missing;  # Core.nothing;  # (-Base.Inf);  Core.Float64(0.0);
            if Core.Int64(i) >= Core.Int64(P1)

                # 用滑動筐遍歷序列數據截取指定區段;
                sliding_basket_Array = Series_Array[Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 用滑動筐遍歷序列數據截取指定區段;

                # 跳過序列中的第一個值，因爲第一個值無增長率;
                if Core.Int64(i) > Core.Int64(1)

                    # 計算强度（變化劇烈程度）示意;
                    # 增長率（正）纍計求和;
                    y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                    if Core.Int64(Base.length([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j]) : Core.Float64(0.0) for j in 1:Base.length(sliding_basket_Array)])) > Core.Int64(0)
                        # y_Positive = Core.Float64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Float64(sliding_basket_Array[j]) else Core.Float64(0.0) end for j in 1:Base.length(sliding_basket_Array)]));
                        y_Positive = Core.Float64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j]) : Core.Float64(0.0) for j in 1:Base.length(sliding_basket_Array)]));
                    end
                    # 衰退率（負）纍計求和;
                    y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                    if Core.Int64(Base.length([(Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j]) : Core.Float64(0.0) for j in 1:Base.length(sliding_basket_Array)])) > Core.Int64(0)
                        # y_Negative = Core.Float64(Base.sum([if Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0) Core.Float64(sliding_basket_Array[j]) else Core.Float64(0.0) end for j in 1:Base.length(sliding_basket_Array)]));
                        y_Negative = Core.Float64(Base.sum([(Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j]) : Core.Float64(0.0) for j in 1:Base.length(sliding_basket_Array)]));
                    end
                    # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                    # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                    # for j = 1:Base.length(sliding_basket_Array)
                    #     if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)
                    #         y_Positive = Core.Float64(y_Positive + sliding_basket_Array[j]);
                    #     elseif Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)
                    #         y_Negative = Core.Float64(y_Negative + sliding_basket_Array[j]);
                    #     else
                    #     end
                    # end

                    # # 計算恆度（持續度，同向變化歷時）示意;
                    # # 增長率（正）的可能性（頻率）示意;
                    # y_P_Positive = Core.Float64(1.0);  # 增長率（正）的可能性（頻率）示意;
                    # # 衰退率（負）的可能性（頻率）示意;
                    # y_P_Negative = Core.Float64(1.0);  # 衰退率（負）的可能性（頻率）示意;
                    # if Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)
                    #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    # end
                    # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                    # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                    # # for j = 1:Base.length(sliding_basket_Array)
                    # #     if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)
                    # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                    # #     elseif Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)
                    # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                    # #     else
                    # #     end
                    # # end
                    # # if Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)
                    # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(sliding_basket_Array)));
                    # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(sliding_basket_Array)));
                    # # end
                    if Base.isnothing(y_P_Positive)
                        # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                        y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    end
                    if Base.isnothing(y_P_Negative)
                        # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                        y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(sliding_basket_Array[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(sliding_basket_Array)])) / Core.Int64(Base.length(sliding_basket_Array)));
                    end

                    # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                    # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                    # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                    # 增長率（正）並衰退率（負）的纍加總計;
                    y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                    if Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)
                        # # y_total = Core.Float64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Float64(sliding_basket_Array[j] * y_P_Positive) else Core.Float64(sliding_basket_Array[j] * y_P_Negative) end for j in 1:Base.length(sliding_basket_Array)]));
                        # y_total = Core.Float64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j] * y_P_Positive) : Core.Float64(sliding_basket_Array[j] * y_P_Negative) for j in 1:Base.length(sliding_basket_Array)]));
                        # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        y_total = Core.Float64(Base.sum([Core.Float64(sliding_basket_Array[j]) for j in 1:Base.length(sliding_basket_Array)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # y_total = Core.Float64(Base.sum([Core.Float64(sliding_basket_Array[j] * y_P_Positive) for j in 1:Base.length(sliding_basket_Array)]));  # 每次交易利潤 × 頻率，纍加總計;
                    end

                    # 增長率（正）並衰退率（負）值的位置（重心）示意;
                    y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                    if Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)
                        y_focus = Core.Float64(Statistics.mean(sliding_basket_Array));
                    end

                    # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                    y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                    if Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)
                        if Core.Int64(Base.length(sliding_basket_Array)) === Core.Int64(1)
                            y_amplitude = Statistics.std(sliding_basket_Array; corrected = false);
                        elseif Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(1)
                            y_amplitude = Statistics.std(sliding_basket_Array; corrected = true);
                        else
                        end
                        y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                    end

                    # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                    # # weight = Core.Array{Core.Float64, 1}();
                    # if Base.typeof(weight) <: Core.Array && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                    #     # weight = [Core.Float64(1.0) for j in 1:Base.length(sliding_basket_Array)];
                    #     weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(sliding_basket_Array))) for j in 1:Base.length(sliding_basket_Array)];
                    # end
                    if Base.isnothing(weight)
                        # weight = Core.Array{Core.Float64, 1}();
                        # weight = [Core.Float64(1.0) for j in 1:Base.length(sliding_basket_Array)];
                        weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(sliding_basket_Array))) for j in 1:Base.length(sliding_basket_Array)];
                    end
                    # println(weight);

                    y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                    if (Base.typeof(sliding_basket_Array) <: Core.Array && Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)) && ((Base.typeof(weight) <: Core.Array || Base.typeof(weight) <: Base.Vector) && Core.Int64(Base.length(weight)) > Core.Int64(0))
                        # y = Core.Float64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Positive) else Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Negative) end for j in 1:Base.length(sliding_basket_Array)]));
                        y = Core.Float64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Positive) : Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Negative) for j in 1:Base.length(sliding_basket_Array)]));
                        # y = Core.Float64(Base.sum([Core.Float64(weight[j] * sliding_basket_Array[j]) for j in 1:Base.length(sliding_basket_Array)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        # for j = 1:Base.length(sliding_basket_Array)
                        #     # y = y + Core.Float64(weight[j] * sliding_basket_Array[j]);
                        #     if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)
                        #         y = y + Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Positive);
                        #     else
                        #         y = y + Core.Float64(weight[j] * sliding_basket_Array[j] * y_P_Negative);
                        #     end
                        # end
                    elseif (Base.typeof(sliding_basket_Array) <: Core.Array && Core.Int64(Base.length(sliding_basket_Array)) > Core.Int64(0)) && ((Base.typeof(weight) <: Core.Array || Base.typeof(weight) <: Base.Vector) && Core.Int64(Base.length(weight)) <= Core.Int64(0))
                        # y = Core.Float64(Base.sum([if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0) Core.Float64(sliding_basket_Array[j] * y_P_Positive) else Core.Float64(sliding_basket_Array[j] * y_P_Negative) end for j in 1:Base.length(sliding_basket_Array)]));
                        y = Core.Float64(Base.sum([(Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)) ? Core.Float64(sliding_basket_Array[j] * y_P_Positive) : Core.Float64(sliding_basket_Array[j] * y_P_Negative) for j in 1:Base.length(sliding_basket_Array)]));
                        # y = Core.Float64(Base.sum([Core.Float64(sliding_basket_Array[j]) for j in 1:Base.length(sliding_basket_Array)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        # for j = 1:Base.length(sliding_basket_Array)
                        #     # y = y + Core.Float64(sliding_basket_Array[j]);
                        #     if Core.Float64(sliding_basket_Array[j]) > Core.Float64(0.0)
                        #         y = y + Core.Float64(sliding_basket_Array[j] * y_P_Positive);
                        #     else
                        #         y = y + Core.Float64(sliding_basket_Array[j] * y_P_Negative);
                        #     end
                        # end
                    end

                    # # 優化目標變量合入風險因素優勢比 Logistic 化;
                    # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                    index_P1 = Core.Float64(y);
                end
            end
            Base.push!(index_P1_random, index_P1);  # 使用 push! 函數在數組末尾追加推入新元;
        end
    end

    return index_P1_random;
end
# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["002611"]["close_price"],  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Bool, Core.Nothing, Base.Missing}, 1},
#     Core.Int64(3);  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# );
# println("closing price growth rate", return_Intuitive_Momentum);


# 計算日棒缐趨勢抽象指標（勢强）示意值;
function Intuitive_Momentum_KLine(
    KLine_Series_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # ::Core.Array{Core.Float64, 2} = testing_data,  # ::Core.Array{Core.Float64, 2} = Core.Array{Core.Float64, 2}(undef, (0, 0)), # ::Core.Array{Core.Array{Core.Float64, 1}, 1} = Core.Array{Core.Array{Core.Float64, 1}, 1}(),
    P1;  # 觀察收益率歷史向前推的交易日長度;
    y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
    y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
    weight = Core.nothing,
    Intuitive_Momentum = (arguments) -> begin return arguments; end
)
    # index_PickStock_P1 = Core.Float64((index_PickStock_P1_turnover_volume_growth_rate) + ((index_PickStock_P1_opening_price_growth_rate + index_PickStock_P1_closing_price_growth_rate) * (index_PickStock_P1_closing_minus_opening_price_growth_rate * index_PickStock_P1_high_price_proportion * index_PickStock_P1_low_price_proportion)));  # 選股指標，勢強示意;

    index_P1_random = Base.Dict{Core.String, Core.Any}();
    if Base.isa(KLine_Series_Dict, Base.Dict) && Base.length(KLine_Series_Dict) > 0
        if (Base.haskey(KLine_Series_Dict, "date_transaction") && Base.typeof(KLine_Series_Dict["date_transaction"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "turnover_volume") && Base.typeof(KLine_Series_Dict["turnover_volume"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "opening_price") && Base.typeof(KLine_Series_Dict["opening_price"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "close_price") && Base.typeof(KLine_Series_Dict["close_price"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "low_price") && Base.typeof(KLine_Series_Dict["low_price"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "high_price") && Base.typeof(KLine_Series_Dict["high_price"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "turnover_volume_growth_rate") && Base.typeof(KLine_Series_Dict["turnover_volume_growth_rate"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "opening_price_growth_rate") && Base.typeof(KLine_Series_Dict["opening_price_growth_rate"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "closing_price_growth_rate") && Base.typeof(KLine_Series_Dict["closing_price_growth_rate"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "closing_minus_opening_price_growth_rate") && Base.typeof(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "high_price_proportion") && Base.typeof(KLine_Series_Dict["high_price_proportion"]) <: Core.Array) && (Base.haskey(KLine_Series_Dict, "low_price_proportion") && Base.typeof(KLine_Series_Dict["low_price_proportion"]) <: Core.Array)
            # index_P1_random["P1_turnover_volume_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_opening_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_closing_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_closing_minus_opening_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_high_price_proportion"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_low_price_proportion"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            # index_P1_random["P1_Intuitive_Momentum"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}(Base.undef, Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1]));
            index_P1_random["P1_turnover_volume_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_opening_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_closing_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_closing_minus_opening_price_growth_rate"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_high_price_proportion"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_low_price_proportion"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            index_P1_random["P1_Intuitive_Momentum"] = Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1}();
            for i = 1:Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1])
                if Core.Int64(i) <= Core.Int64(Base.findmin([Base.length(KLine_Series_Dict["date_transaction"]), Base.length(KLine_Series_Dict["turnover_volume"]), Base.length(KLine_Series_Dict["opening_price"]), Base.length(KLine_Series_Dict["close_price"]), Base.length(KLine_Series_Dict["low_price"]), Base.length(KLine_Series_Dict["high_price"]), Base.length(KLine_Series_Dict["turnover_volume_growth_rate"]), Base.length(KLine_Series_Dict["opening_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_price_growth_rate"]), Base.length(KLine_Series_Dict["closing_minus_opening_price_growth_rate"]), Base.length(KLine_Series_Dict["high_price_proportion"]), Base.length(KLine_Series_Dict["low_price_proportion"])])[1])
                    if Core.Int64(i) < Core.Int64(P1) || Core.Int64(i) <= Core.Int64(1)

                        Base.push!(index_P1_random["P1_turnover_volume_growth_rate"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_opening_price_growth_rate"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_closing_price_growth_rate"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_closing_minus_opening_price_growth_rate"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_high_price_proportion"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_low_price_proportion"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;
                        Base.push!(index_P1_random["P1_Intuitive_Momentum"], Base.missing);  # 使用 push! 函數在數組末尾追加推入新元;

                    elseif Core.Int64(i) >= Core.Int64(P1) && Core.Int64(i) > Core.Int64(1)
    
                        # x0 = KLine_Series_Dict["date_transaction"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 交易日期;
                        # x1 = KLine_Series_Dict["turnover_volume"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 成交量;
                        # x2 = KLine_Series_Dict["turnover_amount"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 成交總金額;
                        # x3 = KLine_Series_Dict["opening_price"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 開盤成交價;
                        # x4 = KLine_Series_Dict["close_price"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤成交價;
                        # x5 = KLine_Series_Dict["low_price"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 最低成交價;
                        # x6 = KLine_Series_Dict["high_price"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 最高成交價;
                        # x7 = KLine_Series_Dict["focus"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 當日成交價重心;
                        # x8 = KLine_Series_Dict["amplitude"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 當日成交價絕對振幅;
                        # x9 = KLine_Series_Dict["amplitude_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 當日成交價相對振幅（%）;
                        # x10 = KLine_Series_Dict["opening_price_Standardization"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
                        # x11 = KLine_Series_Dict["closing_price_Standardization"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
                        # x12 = KLine_Series_Dict["low_price_Standardization"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
                        # x13 = KLine_Series_Dict["high_price_Standardization"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
                        x14 = KLine_Series_Dict["turnover_volume_growth_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 成交量的成長率;
                        x15 = KLine_Series_Dict["opening_price_growth_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 開盤價的成長率;
                        x16 = KLine_Series_Dict["closing_price_growth_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價的成長率;
                        x17 = KLine_Series_Dict["closing_minus_opening_price_growth_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價減開盤價的成長率;
                        x18 = KLine_Series_Dict["high_price_proportion"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價和開盤價裏的最大值占最高價的比例;
                        x19 = KLine_Series_Dict["low_price_proportion"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 最低價占收盤價和開盤價裏的最小值的比例;
                        # x20 = KLine_Series_Dict["turnover_rate"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 成交量換手率;
                        # x21 = KLine_Series_Dict["price_earnings"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 每股收益（公司經營利潤率 ÷ 股本）;
                        # x22 = KLine_Series_Dict["book_value_per_share"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 每股净值（公司净資產 ÷ 股本）;
                        # x23 = KLine_Series_Dict["capitalization"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 總市值;
                        # x24 = KLine_Series_Dict["moving_average_5"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價 5 日滑動平均缐;
                        # x25 = KLine_Series_Dict["moving_average_10"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價 10 日滑動平均缐;
                        # x26 = KLine_Series_Dict["moving_average_20"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價 20 日滑動平均缐;
                        # x27 = KLine_Series_Dict["moving_average_30"][Core.Int64(Core.Int64(i) - Core.Int64(P1) + Core.Int64(1)):1:i];  # 收盤價 30 日滑動平均缐;

                        # # 成交量指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Float64(x14[j]) : Core.Float64(0.0) for j in 1:Base.length(x14)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x14[j]) > Core.Float64(0.0) Core.Float64(x14[j]) else Core.Float64(0.0) end for j in 1:Base.length(x14)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Float64(x14[j]) : Core.Float64(0.0) for j in 1:Base.length(x14)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x14[j]) < Core.Float64(0.0)) ? Core.Float64(x14[j]) : Core.Float64(0.0) for j in 1:Base.length(x14)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x14[j]) < Core.Float64(0.0) Core.Float64(x14[j]) else Core.Float64(0.0) end for j in 1:Base.length(x14)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x14[j]) < Core.Float64(0.0)) ? Core.Float64(x14[j]) : Core.Float64(0.0) for j in 1:Base.length(x14)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x14)
                        # #     if Core.Float64(x14[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x14[j]);
                        # #     elseif Core.Float64(x14[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x14[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x14)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x14[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x14)])) / Core.Int64(Base.length(x14)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x14)])) / Core.Int64(Base.length(x14)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x14[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x14)])) / Core.Int64(Base.length(x14)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x14[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x14)])) / Core.Int64(Base.length(x14)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x14)
                        # #     if Core.Float64(x14[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x14[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x14)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x14)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x14)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x14)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x14[j]) > Core.Float64(0.0) Core.Float64(x14[j] * y_P_Positive) else Core.Float64(x14[j] * y_P_Negative) end for j in 1:Base.length(x14)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Float64(x14[j] * y_P_Positive) : Core.Float64(x14[j] * y_P_Negative) for j in 1:Base.length(x14)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x14[j]) for j in 1:Base.length(x14)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x14[j] * y_P_Positive) for j in 1:Base.length(x14)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x14)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x14));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x14)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x14)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x14; corrected = false);
                        #     elseif Core.Int64(Base.length(x14)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x14; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x14)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x14))) for j in 1:Base.length(x14)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x14)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x14[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x14[j] * y_P_Positive) else Core.Float64(weight[j] * x14[j] * y_P_Negative) end for j in 1:Base.length(x14)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x14[j] * y_P_Positive) : Core.Float64(weight[j] * x14[j] * y_P_Negative) for j in 1:Base.length(x14)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x14[j]) for j in 1:Base.length(x14)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x14)
                        #     #     # y = y + Core.Float64(weight[j] * x14[j]);
                        #     #     if Core.Float64(x14[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x14[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x14[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x14)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x14[j]) > Core.Float64(0.0) Core.Float64(x14[j] * y_P_Positive) else Core.Float64(x14[j] * y_P_Negative) end for j in 1:Base.length(x14)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x14[j]) > Core.Float64(0.0)) ? Core.Float64(x14[j] * y_P_Positive) : Core.Float64(x14[j] * y_P_Negative) for j in 1:Base.length(x14)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x14[j]) for j in 1:Base.length(x14)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x14)
                        #     #     # y = y + Core.Float64(x14[j]);
                        #     #     if Core.Float64(x14[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x14[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x14[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_turnover_volume_growth_rate = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x14,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_turnover_volume_growth_rate = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_turnover_volume_growth_rate"], Core.Float64(index_PickStock_P1_turnover_volume_growth_rate));  # 使用 push! 函數在數組末尾追加推入新元;

                        # # 開盤價指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Float64(x15[j]) : Core.Float64(0.0) for j in 1:Base.length(x15)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x15[j]) > Core.Float64(0.0) Core.Float64(x15[j]) else Core.Float64(0.0) end for j in 1:Base.length(x15)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Float64(x15[j]) : Core.Float64(0.0) for j in 1:Base.length(x15)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x15[j]) < Core.Float64(0.0)) ? Core.Float64(x15[j]) : Core.Float64(0.0) for j in 1:Base.length(x15)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x15[j]) < Core.Float64(0.0) Core.Float64(x15[j]) else Core.Float64(0.0) end for j in 1:Base.length(x15)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x15[j]) < Core.Float64(0.0)) ? Core.Float64(x15[j]) : Core.Float64(0.0) for j in 1:Base.length(x15)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x15)
                        # #     if Core.Float64(x15[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x15[j]);
                        # #     elseif Core.Float64(x15[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x15[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x15)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x15[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x15)])) / Core.Int64(Base.length(x15)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x15)])) / Core.Int64(Base.length(x15)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x15[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x15)])) / Core.Int64(Base.length(x15)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x15[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x15)])) / Core.Int64(Base.length(x15)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x15)
                        # #     if Core.Float64(x15[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x15[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x15)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x15)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x15)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x15)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x15[j]) > Core.Float64(0.0) Core.Float64(x15[j] * y_P_Positive) else Core.Float64(x15[j] * y_P_Negative) end for j in 1:Base.length(x15)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Float64(x15[j] * y_P_Positive) : Core.Float64(x15[j] * y_P_Negative) for j in 1:Base.length(x15)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x15[j]) for j in 1:Base.length(x15)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x15[j] * y_P_Positive) for j in 1:Base.length(x15)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x15)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x15));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x15)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x15)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x15; corrected = false);
                        #     elseif Core.Int64(Base.length(x15)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x15; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x15)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x15))) for j in 1:Base.length(x15)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x15)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x15[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x15[j] * y_P_Positive) else Core.Float64(weight[j] * x15[j] * y_P_Negative) end for j in 1:Base.length(x15)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x15[j] * y_P_Positive) : Core.Float64(weight[j] * x15[j] * y_P_Negative) for j in 1:Base.length(x15)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x15[j]) for j in 1:Base.length(x15)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x15)
                        #     #     # y = y + Core.Float64(weight[j] * x15[j]);
                        #     #     if Core.Float64(x15[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x15[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x15[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x15)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x15[j]) > Core.Float64(0.0) Core.Float64(x15[j] * y_P_Positive) else Core.Float64(x15[j] * y_P_Negative) end for j in 1:Base.length(x15)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x15[j]) > Core.Float64(0.0)) ? Core.Float64(x15[j] * y_P_Positive) : Core.Float64(x15[j] * y_P_Negative) for j in 1:Base.length(x15)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x15[j]) for j in 1:Base.length(x15)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x15)
                        #     #     # y = y + Core.Float64(x15[j]);
                        #     #     if Core.Float64(x15[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x15[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x15[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_opening_price_growth_rate = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x15,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_opening_price_growth_rate = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_opening_price_growth_rate"], Core.Float64(index_PickStock_P1_opening_price_growth_rate));  # 使用 push! 函數在數組末尾追加推入新元;

                        # # 收盤價指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Float64(x16[j]) : Core.Float64(0.0) for j in 1:Base.length(x16)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x16[j]) > Core.Float64(0.0) Core.Float64(x16[j]) else Core.Float64(0.0) end for j in 1:Base.length(x16)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Float64(x16[j]) : Core.Float64(0.0) for j in 1:Base.length(x16)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x16[j]) < Core.Float64(0.0)) ? Core.Float64(x16[j]) : Core.Float64(0.0) for j in 1:Base.length(x16)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x16[j]) < Core.Float64(0.0) Core.Float64(x16[j]) else Core.Float64(0.0) end for j in 1:Base.length(x16)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x16[j]) < Core.Float64(0.0)) ? Core.Float64(x16[j]) : Core.Float64(0.0) for j in 1:Base.length(x16)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x16)
                        # #     if Core.Float64(x16[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x16[j]);
                        # #     elseif Core.Float64(x16[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x16[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x16)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x16[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x16)])) / Core.Int64(Base.length(x16)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x16)])) / Core.Int64(Base.length(x16)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x16[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x16)])) / Core.Int64(Base.length(x16)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x16[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x16)])) / Core.Int64(Base.length(x16)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x16)
                        # #     if Core.Float64(x16[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x16[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x16)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x16)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x16)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x16)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x16[j]) > Core.Float64(0.0) Core.Float64(x16[j] * y_P_Positive) else Core.Float64(x16[j] * y_P_Negative) end for j in 1:Base.length(x16)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Float64(x16[j] * y_P_Positive) : Core.Float64(x16[j] * y_P_Negative) for j in 1:Base.length(x16)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x16[j]) for j in 1:Base.length(x16)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x16[j] * y_P_Positive) for j in 1:Base.length(x16)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x16)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x16));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x16)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x16)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x16; corrected = false);
                        #     elseif Core.Int64(Base.length(x16)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x16; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x16)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x16))) for j in 1:Base.length(x16)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x16)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x16[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x16[j] * y_P_Positive) else Core.Float64(weight[j] * x16[j] * y_P_Negative) end for j in 1:Base.length(x16)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x16[j] * y_P_Positive) : Core.Float64(weight[j] * x16[j] * y_P_Negative) for j in 1:Base.length(x16)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x16[j]) for j in 1:Base.length(x16)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x16)
                        #     #     # y = y + Core.Float64(weight[j] * x16[j]);
                        #     #     if Core.Float64(x16[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x16[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x16[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x16)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x16[j]) > Core.Float64(0.0) Core.Float64(x16[j] * y_P_Positive) else Core.Float64(x16[j] * y_P_Negative) end for j in 1:Base.length(x16)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x16[j]) > Core.Float64(0.0)) ? Core.Float64(x16[j] * y_P_Positive) : Core.Float64(x16[j] * y_P_Negative) for j in 1:Base.length(x16)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x16[j]) for j in 1:Base.length(x16)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x16)
                        #     #     # y = y + Core.Float64(x16[j]);
                        #     #     if Core.Float64(x16[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x16[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x16[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_closing_price_growth_rate = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x16,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_closing_price_growth_rate = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_closing_price_growth_rate"], Core.Float64(index_PickStock_P1_closing_price_growth_rate));  # 使用 push! 函數在數組末尾追加推入新元;

                        # # 開盤價與收盤價差值（日情緒）指標;
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Float64(x17[j]) : Core.Float64(0.0) for j in 1:Base.length(x17)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x17[j]) > Core.Float64(0.0) Core.Float64(x17[j]) else Core.Float64(0.0) end for j in 1:Base.length(x17)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Float64(x17[j]) : Core.Float64(0.0) for j in 1:Base.length(x17)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x17[j]) < Core.Float64(0.0)) ? Core.Float64(x17[j]) : Core.Float64(0.0) for j in 1:Base.length(x17)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x17[j]) < Core.Float64(0.0) Core.Float64(x17[j]) else Core.Float64(0.0) end for j in 1:Base.length(x17)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x17[j]) < Core.Float64(0.0)) ? Core.Float64(x17[j]) : Core.Float64(0.0) for j in 1:Base.length(x17)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x17)
                        # #     if Core.Float64(x17[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x17[j]);
                        # #     elseif Core.Float64(x17[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x17[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x17)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x17[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x17)])) / Core.Int64(Base.length(x17)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x17)])) / Core.Int64(Base.length(x17)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x17[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x17)])) / Core.Int64(Base.length(x17)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x17[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x17)])) / Core.Int64(Base.length(x17)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x17)
                        # #     if Core.Float64(x17[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x17[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x17)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x17)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x17)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x17)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x17[j]) > Core.Float64(0.0) Core.Float64(x17[j] * y_P_Positive) else Core.Float64(x17[j] * y_P_Negative) end for j in 1:Base.length(x17)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Float64(x17[j] * y_P_Positive) : Core.Float64(x17[j] * y_P_Negative) for j in 1:Base.length(x17)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x17[j]) for j in 1:Base.length(x17)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x17[j] * y_P_Positive) for j in 1:Base.length(x17)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x17)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x17));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x17)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x17)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x17; corrected = false);
                        #     elseif Core.Int64(Base.length(x17)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x17; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x17)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x17))) for j in 1:Base.length(x17)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x17)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x17[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x17[j] * y_P_Positive) else Core.Float64(weight[j] * x17[j] * y_P_Negative) end for j in 1:Base.length(x17)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x17[j] * y_P_Positive) : Core.Float64(weight[j] * x17[j] * y_P_Negative) for j in 1:Base.length(x17)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x17[j]) for j in 1:Base.length(x17)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x17)
                        #     #     # y = y + Core.Float64(weight[j] * x17[j]);
                        #     #     if Core.Float64(x17[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x17[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x17[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x17)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x17[j]) > Core.Float64(0.0) Core.Float64(x17[j] * y_P_Positive) else Core.Float64(x17[j] * y_P_Negative) end for j in 1:Base.length(x17)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x17[j]) > Core.Float64(0.0)) ? Core.Float64(x17[j] * y_P_Positive) : Core.Float64(x17[j] * y_P_Negative) for j in 1:Base.length(x17)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x17[j]) for j in 1:Base.length(x17)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x17)
                        #     #     # y = y + Core.Float64(x17[j]);
                        #     #     if Core.Float64(x17[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x17[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x17[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_closing_minus_opening_price_growth_rate = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x17,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_closing_minus_opening_price_growth_rate = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_closing_minus_opening_price_growth_rate"], Core.Float64(index_PickStock_P1_closing_minus_opening_price_growth_rate));  # 使用 push! 函數在數組末尾追加推入新元;

                        # # 最高價挑高（日情緒）指標
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Float64(x18[j]) : Core.Float64(0.0) for j in 1:Base.length(x18)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x18[j]) > Core.Float64(0.0) Core.Float64(x18[j]) else Core.Float64(0.0) end for j in 1:Base.length(x18)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Float64(x18[j]) : Core.Float64(0.0) for j in 1:Base.length(x18)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x18[j]) < Core.Float64(0.0)) ? Core.Float64(x18[j]) : Core.Float64(0.0) for j in 1:Base.length(x18)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x18[j]) < Core.Float64(0.0) Core.Float64(x18[j]) else Core.Float64(0.0) end for j in 1:Base.length(x18)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x18[j]) < Core.Float64(0.0)) ? Core.Float64(x18[j]) : Core.Float64(0.0) for j in 1:Base.length(x18)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x18)
                        # #     if Core.Float64(x18[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x18[j]);
                        # #     elseif Core.Float64(x18[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x18[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x18)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x18[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x18)])) / Core.Int64(Base.length(x18)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x18)])) / Core.Int64(Base.length(x18)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x18[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x18)])) / Core.Int64(Base.length(x18)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x18[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x18)])) / Core.Int64(Base.length(x18)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x18)
                        # #     if Core.Float64(x18[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x18[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x18)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x18)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x18)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x18)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x18[j]) > Core.Float64(0.0) Core.Float64(x18[j] * y_P_Positive) else Core.Float64(x18[j] * y_P_Negative) end for j in 1:Base.length(x18)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Float64(x18[j] * y_P_Positive) : Core.Float64(x18[j] * y_P_Negative) for j in 1:Base.length(x18)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x18[j]) for j in 1:Base.length(x18)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x18[j] * y_P_Positive) for j in 1:Base.length(x18)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x18)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x18));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x18)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x18)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x18; corrected = false);
                        #     elseif Core.Int64(Base.length(x18)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x18; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x18)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x18))) for j in 1:Base.length(x18)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x18)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x18[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x18[j] * y_P_Positive) else Core.Float64(weight[j] * x18[j] * y_P_Negative) end for j in 1:Base.length(x18)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x18[j] * y_P_Positive) : Core.Float64(weight[j] * x18[j] * y_P_Negative) for j in 1:Base.length(x18)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x18[j]) for j in 1:Base.length(x18)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x18)
                        #     #     # y = y + Core.Float64(weight[j] * x18[j]);
                        #     #     if Core.Float64(x18[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x18[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x18[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x18)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x18[j]) > Core.Float64(0.0) Core.Float64(x18[j] * y_P_Positive) else Core.Float64(x18[j] * y_P_Negative) end for j in 1:Base.length(x18)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x18[j]) > Core.Float64(0.0)) ? Core.Float64(x18[j] * y_P_Positive) : Core.Float64(x18[j] * y_P_Negative) for j in 1:Base.length(x18)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x18[j]) for j in 1:Base.length(x18)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x18)
                        #     #     # y = y + Core.Float64(x18[j]);
                        #     #     if Core.Float64(x18[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x18[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x18[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_high_price_proportion = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x18,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_high_price_proportion = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_high_price_proportion"], Core.Float64(index_PickStock_P1_high_price_proportion));  # 使用 push! 函數在數組末尾追加推入新元;

                        # # 最低價落低（日情緒）指標
                        # # 計算强度（變化劇烈程度）示意;
                        # # 增長率（正）纍計求和;
                        # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Float64(x19[j]) : Core.Float64(0.0) for j in 1:Base.length(x19)])) > Core.Int64(0)
                        #     # y_Positive = Core.Float64(Base.sum([if Core.Float64(x19[j]) > Core.Float64(0.0) Core.Float64(x19[j]) else Core.Float64(0.0) end for j in 1:Base.length(x19)]));
                        #     y_Positive = Core.Float64(Base.sum([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Float64(x19[j]) : Core.Float64(0.0) for j in 1:Base.length(x19)]));
                        # end
                        # # 衰退率（負）纍計求和;
                        # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # if Core.Int64(Base.length([(Core.Float64(x19[j]) < Core.Float64(0.0)) ? Core.Float64(x19[j]) : Core.Float64(0.0) for j in 1:Base.length(x19)])) > Core.Int64(0)
                        #     # y_Negative = Core.Float64(Base.sum([if Core.Float64(x19[j]) < Core.Float64(0.0) Core.Float64(x19[j]) else Core.Float64(0.0) end for j in 1:Base.length(x19)]));
                        #     y_Negative = Core.Float64(Base.sum([(Core.Float64(x19[j]) < Core.Float64(0.0)) ? Core.Float64(x19[j]) : Core.Float64(0.0) for j in 1:Base.length(x19)]));
                        # end
                        # # y_Positive = Core.Float64(0.0);  # 增長率（正）纍計求和;
                        # # y_Negative = Core.Float64(0.0);  # 衰退率（負）纍計求和;
                        # # for j = 1:Base.length(x19)
                        # #     if Core.Float64(x19[j]) > Core.Float64(0.0)
                        # #         y_Positive = Core.Float64(y_Positive + x19[j]);
                        # #     elseif Core.Float64(x19[j]) < Core.Float64(0.0)
                        # #         y_Negative = Core.Float64(y_Negative + x19[j]);
                        # #     else
                        # #     end
                        # # end

                        # # 計算恆度（持續度，同向變化歷時）示意;
                        # # 增長率（正）的可能性（頻率）示意;
                        # y_P_Positive = Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # 衰退率（負）的可能性（頻率）示意;
                        # y_P_Negative = Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # if Core.Int64(Base.length(x19)) > Core.Int64(0)
                        #     # y_P_Positive = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x19[j]) > Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x19)])) / Core.Int64(Base.length(x19)));
                        #     y_P_Positive = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x19)])) / Core.Int64(Base.length(x19)));
                        #     # y_P_Negative = Core.Float64(Core.Int64(Base.sum([if Core.Float64(x19[j]) < Core.Float64(0.0) Core.Int64(1) else Core.Int64(0) end for j in 1:Base.length(x19)])) / Core.Int64(Base.length(x19)));
                        #     y_P_Negative = Core.Float64(Core.Int64(Base.sum([(Core.Float64(x19[j]) < Core.Float64(0.0)) ? Core.Int64(1) : Core.Int64(0) for j in 1:Base.length(x19)])) / Core.Int64(Base.length(x19)));
                        # end
                        # # y_P_Positive = Core.Int64(0);  # Core.Float64(0.0);  # 增長率（正）的可能性（頻率）示意;
                        # # y_P_Negative = Core.Int64(0);  # Core.Float64(0.0);  # 衰退率（負）的可能性（頻率）示意;
                        # # for j = 1:Base.length(x19)
                        # #     if Core.Float64(x19[j]) > Core.Float64(0.0)
                        # #         y_P_Positive = Core.UInt64(Core.UInt64(y_P_Positive) + Core.UInt64(1));
                        # #     elseif Core.Float64(x19[j]) < Core.Float64(0.0)
                        # #         y_P_Negative = Core.UInt64(Core.UInt64(y_P_Negative) + Core.UInt64(1));
                        # #     else
                        # #     end
                        # # end
                        # # if Core.Int64(Base.length(x19)) > Core.Int64(0)
                        # #     y_P_Positive = Core.Float64(Core.UInt64(y_P_Positive) / Core.UInt64(Base.length(x19)));
                        # #     y_P_Negative = Core.Float64(Core.UInt64(y_P_Negative) / Core.UInt64(Base.length(x19)));
                        # # end

                        # # # y = Core.Float64(y_Positive * y_P_Positive);  # 增長率（正） × 頻率，纍加總計;
                        # # # y = Core.Float64(y_Negative * y_P_Negative);  # 衰退率（負） × 頻率，纍加總計;
                        # # y = Core.Float64(y_Positive * y_P_Positive) - Core.Float64(y_Negative * y_P_Negative);

                        # # 增長率（正）並衰退率（負）的纍加總計;
                        # y_total = Core.Float64(0.0);  # 增長率（正）並衰退率（負）的纍加總計;
                        # if Core.Int64(Base.length(x19)) > Core.Int64(0)
                        #     # # y_total = Core.Float64(Base.sum([if Core.Float64(x19[j]) > Core.Float64(0.0) Core.Float64(x19[j] * y_P_Positive) else Core.Float64(x19[j] * y_P_Negative) end for j in 1:Base.length(x19)]));
                        #     # y_total = Core.Float64(Base.sum([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Float64(x19[j] * y_P_Positive) : Core.Float64(x19[j] * y_P_Negative) for j in 1:Base.length(x19)]));
                        #     # y_total = Core.Float64(y_Positive * y_P_Positive) + Core.Float64(y_Negative * y_P_Negative);
                        #     y_total = Core.Float64(Base.sum([Core.Float64(x19[j]) for j in 1:Base.length(x19)]));  # 每次交易利潤 × 頻率，纍加總計;
                        #     # y_total = Core.Float64(Base.sum([Core.Float64(x19[j] * y_P_Positive) for j in 1:Base.length(x19)]));  # 每次交易利潤 × 頻率，纍加總計;
                        # end

                        # # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # y_focus = Core.Float64(0.0);  # 增長率（正）並衰退率（負）值的位置（重心）示意;
                        # if Core.Int64(Base.length(x19)) > Core.Int64(0)
                        #     y_focus = Core.Float64(Statistics.mean(x19));
                        # end

                        # # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # y_amplitude = Core.Float64(0.0);  # amplitude_rate;  # 增長率（正）並衰退率（負）值的尺度（振幅）示意;
                        # if Core.Int64(Base.length(x19)) > Core.Int64(0)
                        #     if Core.Int64(Base.length(x19)) === Core.Int64(1)
                        #         y_amplitude = Statistics.std(x19; corrected = false);
                        #     elseif Core.Int64(Base.length(x19)) > Core.Int64(1)
                        #         y_amplitude = Statistics.std(x19; corrected = true);
                        #     else
                        #     end
                        #     y_amplitude = Core.Float64(y_amplitude);  # amplitude_rate;
                        # end

                        # # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        # # weight = Core.Array{Core.Float64, 1}();
                        # # weight = [Core.Float64(1.0) for j in 1:Base.length(x19)];
                        # weight = [Core.Float64(Core.Int64(j) / Core.Int64(Base.length(x19))) for j in 1:Base.length(x19)];
                        # # println(weight);

                        # y = Core.Float64(0.0);  # 優化目標變量之一，加權增長率（增長率 × 可能性 × 權重）總計示意;
                        # if Core.Int64(Base.length(x19)) > Core.Int64(0) && Core.Int64(Base.length(weight)) > Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x19[j]) > Core.Float64(0.0) Core.Float64(weight[j] * x19[j] * y_P_Positive) else Core.Float64(weight[j] * x19[j] * y_P_Negative) end for j in 1:Base.length(x19)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Float64(weight[j] * x19[j] * y_P_Positive) : Core.Float64(weight[j] * x19[j] * y_P_Negative) for j in 1:Base.length(x19)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(weight[j] * x19[j]) for j in 1:Base.length(x19)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x19)
                        #     #     # y = y + Core.Float64(weight[j] * x19[j]);
                        #     #     if Core.Float64(x19[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(weight[j] * x19[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(weight[j] * x19[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # elseif Core.Int64(Base.length(x19)) > Core.Int64(0) && Core.Int64(Base.length(weight)) <= Core.Int64(0)
                        #     # y = Core.Float64(Base.sum([if Core.Float64(x19[j]) > Core.Float64(0.0) Core.Float64(x19[j] * y_P_Positive) else Core.Float64(x19[j] * y_P_Negative) end for j in 1:Base.length(x19)]));
                        #     y = Core.Float64(Base.sum([(Core.Float64(x19[j]) > Core.Float64(0.0)) ? Core.Float64(x19[j] * y_P_Positive) : Core.Float64(x19[j] * y_P_Negative) for j in 1:Base.length(x19)]));
                        #     # y = Core.Float64(Base.sum([Core.Float64(x19[j]) for j in 1:Base.length(x19)]));  # 每次交易利潤 × 頻率 × 權重，加權纍加總計;
                        #     # y = Core.Float64(0.0);  # 每次交易利潤 × 頻率，纍加總計;
                        #     # for j = 1:Base.length(x19)
                        #     #     # y = y + Core.Float64(x19[j]);
                        #     #     if Core.Float64(x19[j]) > Core.Float64(0.0)
                        #     #         y = y + Core.Float64(x19[j] * y_P_Positive);
                        #     #     else
                        #     #         y = y + Core.Float64(x19[j] * y_P_Negative);
                        #     #     end
                        #     # end
                        # end

                        # # # 優化目標變量合入風險因素優勢比 Logistic 化;
                        # # y = Core.Float64(y * Core.Float64(y_Positive / y_Negative));  # 增長率 × 優勢比;

                        # index_PickStock_P1_low_price_proportion = Core.Float64(y);

                        y = Intuitive_Momentum(
                            x19,  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Nothing, Base.Missing}, 1},
                            P1;  # 觀察收益率歷史向前推的交易日長度;
                            y_P_Positive = y_P_Positive,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
                            y_P_Negative = y_P_Negative,  # Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
                            weight = weight  # Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
                        );
                        index_PickStock_P1_low_price_proportion = Core.Float64(y[Core.Int64(Base.length(y))]);
                        Base.push!(index_P1_random["P1_low_price_proportion"], Core.Float64(index_PickStock_P1_low_price_proportion));  # 使用 push! 函數在數組末尾追加推入新元;

                        # 選股指標，勢強示意;
                        # Base.abs(index_PickStock_P1_turnover_volume_growth_rate)
                        index_PickStock_P1 = Core.Float64((index_PickStock_P1_turnover_volume_growth_rate) + ((index_PickStock_P1_opening_price_growth_rate + index_PickStock_P1_closing_price_growth_rate) * (index_PickStock_P1_closing_minus_opening_price_growth_rate * index_PickStock_P1_high_price_proportion * index_PickStock_P1_low_price_proportion)));  # 選股指標，勢強示意;
                        Base.push!(index_P1_random["P1_Intuitive_Momentum"], Core.Float64(index_PickStock_P1));  # 使用 push! 函數在數組末尾追加推入新元;
                    else
                    end
                end
            end
        end
    end

    return index_P1_random;
end
# return_Intuitive_Momentum_KLine = Intuitive_Momentum_KLine(
#     Base.Dict{Core.String, Core.Any}(
#         "date_transaction" => training_data["002611"]["date_transaction"],  # 交易日期;
#         "turnover_volume" => training_data["002611"]["turnover_volume"],  # 成交量;
#         # "turnover_amount" => training_data["002611"]["turnover_amount"],  # 成交總金額;
#         "opening_price" => training_data["002611"]["opening_price"],  # 開盤成交價;
#         "close_price" => training_data["002611"]["close_price"],  # 收盤成交價;
#         "low_price" => training_data["002611"]["low_price"],  # 最低成交價;
#         "high_price" => training_data["002611"]["high_price"],  # 最高成交價;
#         # "focus" => training_data["002611"]["focus"],  # 當日成交價重心;
#         # "amplitude" => training_data["002611"]["amplitude"],  # 當日成交價絕對振幅;
#         # "amplitude_rate" => training_data["002611"]["amplitude_rate"],  # 當日成交價相對振幅（%）;
#         # "opening_price_Standardization" => training_data["002611"]["opening_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
#         # "closing_price_Standardization" => training_data["002611"]["closing_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
#         # "low_price_Standardization" => training_data["002611"]["low_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
#         # "high_price_Standardization" => training_data["002611"]["high_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
#         "turnover_volume_growth_rate" => training_data["002611"]["turnover_volume_growth_rate"],  # 成交量的成長率;
#         "opening_price_growth_rate" => training_data["002611"]["opening_price_growth_rate"],  # 開盤價的成長率;
#         "closing_price_growth_rate" => training_data["002611"]["closing_price_growth_rate"],  # 收盤價的成長率;
#         "closing_minus_opening_price_growth_rate" => training_data["002611"]["closing_minus_opening_price_growth_rate"],  # 收盤價減開盤價的成長率;
#         "high_price_proportion" => training_data["002611"]["high_price_proportion"],  # 收盤價和開盤價裏的最大值占最高價的比例;
#         "low_price_proportion" => training_data["002611"]["low_price_proportion"],  # 最低價占收盤價和開盤價裏的最小值的比例;
#         # "turnover_rate" => training_data["002611"]["turnover_rate"],  # 成交量換手率;
#         # "price_earnings" => training_data["002611"]["price_earnings"],  # 每股收益（公司經營利潤率 ÷ 股本）;
#         # "book_value_per_share" => training_data["002611"]["book_value_per_share"],  # 每股净值（公司净資產 ÷ 股本）;
#         # "capitalization" => training_data["002611"]["capitalization"]  # 總市值;
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



# # 函數使用示例;
# using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# # https://github.com/JuliaIO/JLD.jl
# # using HDF5;
# # https://github.com/JuliaIO/HDF5.jl
# # using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# # https://github.com/JuliaData/DataFrames.jl
# # https://dataframes.juliadata.org/stable/
# JLD_K_Line_Daily_file = "C:/QuantitativeTrading/Data/steppingData.jld";
# # stepping_data = Base.Dict{Core.String, Core.Any}();
# stepping_data = JLD.load(
#     JLD_K_Line_Daily_file,
#     "stepping_data"
# );
# # println(stepping_data);
# # JLD.save(
# #     JLD_K_Line_Daily_file,
# #     "stepping_data",
# #     stepping_data
# # );


# training_data = Base.Dict{Core.String, Core.Any}();
# training_data = stepping_data;

# testing_data = Base.Dict{Core.String, Core.Any}();
# testing_data = stepping_data;


# return_Intuitive_Momentum = Intuitive_Momentum(
#     training_data["002611"]["close_price"],  # ::Core.Array{Core.Union{Core.String, Core.Float64, Core.Int64, Core.UInt64, Core.Bool, Core.Nothing, Base.Missing}, 1},
#     Core.Int64(3);  # 觀察收益率歷史向前推的交易日長度;
#     y_P_Positive = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 增長率（正）的可能性（頻率）示意;
#     y_P_Negative = Core.nothing,  # ::Core.Float64 = Core.Float64(1.0),  # 衰退率（負）的可能性（頻率）示意;
#     weight = Core.nothing  # Core.Array{Core.Float64, 1}()  # [Core.Float64(Core.Int64(i) / Core.Int64(P1)) for i in 1:Core.Int64(P1)]  # ::Core.Array{Core.Any, 1} = Core.Array{Core.Float64, 1}()  # 每計增長率的權重（weight）值，距離當下時長的倒數（直覺推理有效性示意）;
# );
# println("closing price growth rate", return_Intuitive_Momentum);

# return_Intuitive_Momentum_KLine = Intuitive_Momentum_KLine(
#     Base.Dict{Core.String, Core.Any}(
#         "date_transaction" => training_data["002611"]["date_transaction"],  # 交易日期;
#         "turnover_volume" => training_data["002611"]["turnover_volume"],  # 成交量;
#         # "turnover_amount" => training_data["002611"]["turnover_amount"],  # 成交總金額;
#         "opening_price" => training_data["002611"]["opening_price"],  # 開盤成交價;
#         "close_price" => training_data["002611"]["close_price"],  # 收盤成交價;
#         "low_price" => training_data["002611"]["low_price"],  # 最低成交價;
#         "high_price" => training_data["002611"]["high_price"],  # 最高成交價;
#         # "focus" => training_data["002611"]["focus"],  # 當日成交價重心;
#         # "amplitude" => training_data["002611"]["amplitude"],  # 當日成交價絕對振幅;
#         # "amplitude_rate" => training_data["002611"]["amplitude_rate"],  # 當日成交價相對振幅（%）;
#         # "opening_price_Standardization" => training_data["002611"]["opening_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日首筆成交價（開盤價）標準化值;
#         # "closing_price_Standardization" => training_data["002611"]["closing_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日尾筆成交價（收盤價）標準化值;
#         # "low_price_Standardization" => training_data["002611"]["low_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最低成交價標準化值;
#         # "high_price_Standardization" => training_data["002611"]["high_price_Standardization"],  # 日棒缐（K Line Daily）數據交易日最高成交價標準化值;
#         "turnover_volume_growth_rate" => training_data["002611"]["turnover_volume_growth_rate"],  # 成交量的成長率;
#         "opening_price_growth_rate" => training_data["002611"]["opening_price_growth_rate"],  # 開盤價的成長率;
#         "closing_price_growth_rate" => training_data["002611"]["closing_price_growth_rate"],  # 收盤價的成長率;
#         "closing_minus_opening_price_growth_rate" => training_data["002611"]["closing_minus_opening_price_growth_rate"],  # 收盤價減開盤價的成長率;
#         "high_price_proportion" => training_data["002611"]["high_price_proportion"],  # 收盤價和開盤價裏的最大值占最高價的比例;
#         "low_price_proportion" => training_data["002611"]["low_price_proportion"],  # 最低價占收盤價和開盤價裏的最小值的比例;
#         # "turnover_rate" => training_data["002611"]["turnover_rate"],  # 成交量換手率;
#         # "price_earnings" => training_data["002611"]["price_earnings"],  # 每股收益（公司經營利潤率 ÷ 股本）;
#         # "book_value_per_share" => training_data["002611"]["book_value_per_share"],  # 每股净值（公司净資產 ÷ 股本）;
#         # "capitalization" => training_data["002611"]["capitalization"]  # 總市值;
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
