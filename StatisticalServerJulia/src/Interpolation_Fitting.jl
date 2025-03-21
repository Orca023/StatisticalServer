# module Interpolation_Fitting
# Main.Interpolation_Fitting
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
# Base.MainInclude.include("/home/StatisticalServer/StatisticalServerJulia/Interpolation_Fitting.jl");
# Base.MainInclude.include("C:/StatisticalServer/StatisticalServerJulia/Interpolation_Fitting.jl");
# Base.MainInclude.include("./Interpolation_Fitting.jl");

# 控制臺命令列運行指令：
# C:\> C:/StatisticalServer/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/StatisticalServer/StatisticalServerJulia/ C:/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl configFile=C:/StatisticalServer/config.txt webPath=C:/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/StatisticalServer/Intermediary/ monitor_file=C:/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=C:/StatisticalServer/Intermediary/ output_file=C:/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/StatisticalServer/temp/
# root@localhost:~# /usr/julia/julia-1.10.3/bin/julia -p 4 --project=/home/StatisticalServer/StatisticalServerJulia/ /home/StatisticalServer/StatisticalServerJulia/StatisticalAlgorithmServer.jl configFile=/home/StatisticalServer/config.txt webPath=/home/StatisticalServer/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/StatisticalServer/Intermediary/ monitor_file=/home/StatisticalServer/Intermediary/intermediary_write_C.txt output_dir=/home/StatisticalServer/Intermediary/ output_file=/home/StatisticalServer/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/StatisticalServer/temp/

#################################################################################;


using Statistics;  # 導入 Julia 的原生標準模組「Statistics」，用於數據統計計算;
# using Dates;  # 導入 Julia 的原生標準模組「Dates」，用於處理時間和日期數據，也可以用全名 Main.Dates. 訪問模組内的方法（函數）;
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
using Gadfly;  # 導入第三方擴展包「Gadfly」，用於繪圖，需要在控制臺先安裝第三方擴展包「Gadfly」：julia> using Pkg; Pkg.add("Gadfly") 成功之後才能使用;
using Cairo;  # 導入第三方擴展包「Cairo」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Cairo」：julia> using Pkg; Pkg.add("Cairo") 成功之後才能使用;
using Fontconfig;  # 導入第三方擴展包「Fontconfig」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Fontconfig」：julia> using Pkg; Pkg.add("Fontconfig") 成功之後才能使用;
# using Plots;  # 導入第三方擴展包「Plots」，用於繪圖，需要在控制臺先安裝第三方擴展包「Plots」：julia> using Pkg; Pkg.add("Plots") 成功之後才能使用;
# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
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
using LsqFit;  # 導入第三方擴展包「LsqFit」，用於任意形式曲缐方程擬合（Curve Fitting），需要在控制臺先安裝第三方擴展包「LsqFit」：julia> using Pkg; Pkg.add("LsqFit") 成功之後才能使用;
# https://julianlsolvers.github.io/LsqFit.jl/latest/
# https://github.com/JuliaNLSolvers/LsqFit.jl
using Interpolations;  # 導入第三方擴展包「Interpolations」，用於插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「Interpolations」：julia> using Pkg; Pkg.add("Interpolations") 成功之後才能使用;
# https://juliamath.github.io/Interpolations.jl/stable/
# https://github.com/JuliaMath/Interpolations.jl/
using DataInterpolations;  # 導入第三方擴展包「DataInterpolations」，用於一維（1 Dimension）插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「DataInterpolations」：julia> using Pkg; Pkg.add("DataInterpolations") 成功之後才能使用;
# https://github.com/SciML/DataInterpolations.jl
# using NLsolve;  # 導入第三方擴展包「NLsolve」，用於求解任意形式多元非缐性方程組，需要在控制臺先安裝第三方擴展包「NLsolve」：julia> using Pkg; Pkg.add("NLsolve") 成功之後才能使用;
# # https://github.com/JuliaNLSolvers/NLsolve.jl
using Roots;  # 導入第三方擴展包「Roots」，用於求解任意形式一元非缐性方程，需要在控制臺先安裝第三方擴展包「Roots」：julia> using Pkg; Pkg.add("Roots") 成功之後才能使用;
# https://juliamath.github.io/Roots.jl/stable
# https://github.com/JuliaMath/Roots.jl
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

Distributed.@everywhere using LsqFit, Roots, Interpolations, DataInterpolations, Statistics, Gadfly, Cairo, Fontconfig;



# 任意形式一元方程函數曲缐擬合（Curve Fitting）使用第三方擴展包「LsqFit」：LsqFit.@. f(x, A) = A[2] - A[1]*x; LsqFit.curve_fit();


# using LsqFit;  # 導入第三方擴展包「LsqFit」，用於任意形式曲缐方程擬合（Curve Fitting），需要在控制臺先安裝第三方擴展包「LsqFit」：julia> using Pkg; Pkg.add("LsqFit") 成功之後才能使用;
# https://julianlsolvers.github.io/LsqFit.jl/latest/
# https://github.com/JuliaNLSolvers/LsqFit.jl
# 邏輯 5 參數模型（5-parameter logistic curve）曲缐擬合 f(x, P) = P[4] - (P[4] - P[1])/((1.0 + (x/P[2])^P[3])^P[5]) ;
function LC5PFit(
    training_data::Base.Dict{Core.String, Core.Any};
    testing_data::Base.Dict{Core.String, Core.Any} = training_data,
    Pdata_0 = Core.Array{Core.Float64, 1}(),
    weight = Core.Array{Core.Float64, 1}(),
    Plower = [-Base.Inf, -Base.Inf, -Base.Inf, -Base.Inf],
    Pupper = [+Base.Inf, +Base.Inf, +Base.Inf, +Base.Inf]
) ::Base.Dict{Core.String, Core.Any}

    trainingData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(training_data, Base.Dict) && Core.Int64(Base.length(training_data)) > Core.Int64(0)
        if Base.haskey(training_data, "Xdata")
            if (Base.typeof(training_data["Xdata"]) <: Core.Array || Base.typeof(training_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Xdata"])
                    if (Base.typeof(training_data["Xdata"][i]) <: Core.Array || Base.typeof(training_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # trainingData_Xdata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"][i])));
                            for j = 1:Base.length(training_data["Xdata"][i])
                                # Base.push!(trainingData_Xdata_i, Core.Float64(training_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Xdata"][i][j] = Core.Float64(training_data["Xdata"][i][j]);
                                # Base.push!(trainingData["Xdata"][i], Core.Float64(training_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            end
                            # Base.push!(trainingData["Xdata"], trainingData_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                            # trainingData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Xdata"][i], Core.String) || Base.typeof(training_data["Xdata"][i]) <: Core.Float64 || Base.typeof(training_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # Base.push!(trainingData["Xdata"], Core.Float64(training_data["Xdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            trainingData["Xdata"][i] = Core.Float64(training_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(training_data, "Ydata")
            if (Base.typeof(training_data["Ydata"]) <: Core.Array || Base.typeof(training_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Ydata"])
                    if (Base.typeof(training_data["Ydata"][i]) <: Core.Array || Base.typeof(training_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # trainingData_Ydata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"][i])));
                            for j = 1:Base.length(training_data["Ydata"][i])
                                # Base.push!(trainingData_Ydata_i, Core.Float64(training_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Ydata"][i][j] = Core.Float64(training_data["Ydata"][i][j]);
                                # Base.push!(trainingData["Ydata"][i], Core.Float64(training_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            end
                            # Base.push!(trainingData["Ydata"], trainingData_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                            # trainingData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Ydata"][i], Core.String) || Base.typeof(training_data["Ydata"][i]) <: Core.Float64 || Base.typeof(training_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # Base.push!(trainingData["Ydata"], Core.Float64(training_data["Ydata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            trainingData["Ydata"][i] = Core.Float64(training_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
    end
    # Xdata::Core.Array{Core.Float64, 1} = trainingData["Xdata"];
    # Ydata::Core.Array{Core.Array{Core.Float64, 1}, 1} = trainingData["Ydata"];
    Xdata = trainingData["Xdata"];
    # println(Xdata);
    Ydata = trainingData["Ydata"];
    # println(Ydata);

    # 求 Ydata 均值向量;
    YdataMean = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            yMean = Core.Float64(Statistics.mean(Ydata[i]));
            Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        else
            yMean = Core.Float64(Ydata[i]);
            Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
    end
    # println(YdataMean);
    # 求 Ydata 標準差向量;
    YdataSTD = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            if Core.Int64(Base.length(Ydata[i])) === Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=false));
                Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
            elseif Core.Int64(Base.length(Ydata[i])) > Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=true));
                Base.push!(YdataSTD, ySTD);
            end
        else
            ySTD = Core.Float64(0.0);
            Base.push!(YdataSTD, ySTD);
        end
    end
    # println(YdataSTD);

    # 參數初始值;
    Pdata_0_P1 = Base.findmin(YdataMean)[1] * 0.9;
    Pdata_0_P4 = Base.findmax(YdataMean)[1] * 1.1;

    ln_Xdata = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Xdata)
        ln_x = Base.log(Xdata[i]);  # Base.log(Base.MathConstants.ℯ, Xdata[i]);
        Base.push!(ln_Xdata, ln_x);  # 使用 push! 函數在數組末尾追加推入新元素;
    end

    ln_YdataMean = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(YdataMean)
        temp = (YdataMean[i] - Pdata_0_P1) / (Pdata_0_P4 - YdataMean[i]);
        ln_y = Base.log(temp);  # Base.log(Base.MathConstants.ℯ, temp);
        Base.push!(ln_YdataMean, ln_y);  # 使用 push! 函數在數組末尾追加推入新元素;
    end

    LsqFit.@. f1(x, A) = A[2] - A[1]*x;

    fitA = LsqFit.curve_fit(
        f1,
        ln_Xdata,
        ln_YdataMean,
        [
            (1.0 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1.0 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]),
            Statistics.mean(Xdata)
        ];
    );

    A1 = LsqFit.coef(fitA)[1];
    A2 = LsqFit.coef(fitA)[2];

    Pdata_0_P3 = A1;  # (1.0 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1.0 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]);
    Pdata_0_P2 = Base.exp(A2 / Pdata_0_P3);  # Base.MathConstants.ℯ ^ (A2 / Pdata_0_P3);

    Pdata_0_P5 = Core.Float64(1.0);

    # Pdata_0 = Core.Array{Core.Float64, 1}();
    # Pdata_0 = [
    #     Base.findmin(YdataMean)[1] * 0.9,
    #     Statistics.mean(Xdata),
    #     (1 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]),
    #     Base.findmax(YdataMean)[1] * 1.1
    #     # Core.Float64(1)
    # ];
    if Core.Int64(Base.length(Pdata_0)) === Core.Int64(0)
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
            # Pdata_0_P5
        ];
    end
    # println(Pdata_0);

    # # 參數值上下限;
    # # Plower = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();
    # Plower = [
    #     -Base.Inf,  # P[1];
    #     -Base.Inf,  # P[2];
    #     -Base.Inf,  # P[3];
    #     -Base.Inf  # P[4];
    #     # -Base.Inf  # P[5];
    # ];
    # println(Plower);
    # # Pupper = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}()
    # Pupper = [
    #     +Base.Inf,  # P[1];
    #     +Base.Inf,  # P[2];
    #     +Base.Inf,  # P[3];
    #     +Base.Inf  # P[4];
    #     # +Base.Inf  # P[5];
    # ];
    # println(Pupper);

    # # 變量實測值擬合權重;
    # weight = Core.Array{Core.Float64, 1}();
    # # 使用高斯核賦權法;
    # target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
    # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
    # for i = 1:Base.length(YdataMean)
    #     wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
    #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
    # end
    # # # 使用方差倒數值賦權法;
    # # for i = 1:Base.length(YdataSTD)
    # #     wei = 1 / YdataSTD[i];  # Statistics.std(Ydata[i]), Statistics.var(Ydata[i]);
    # #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
    # # end
    # println(weight);

    # https://github.com/JuliaNLSolvers/LsqFit.jl
    # https://ww2.mathworks.cn/matlabcentral/fileexchange/38043-five-parameters-logistic-regression-there-and-back-again
    # 自定義的邏輯四參數模型（4-parameter logistic model）方程;
    # function fit_model(x, P1, P2, P3, P4)
    #     y = P4 - (P4 - P1)/(1.0 + (x/P2)^P3);  # 邏輯四參數模型（4-parameter logistic model）方程;
    #     return y;
    # end
    # LsqFit.@. LC5Pmodel(x, P) = (fit_model(x, P[1], P[2], P[3], P[4]););
    LsqFit.@. LC4Pmodel(x, P) = P[4] - (P[4] - P[1])/(1.0 + (x/P[2])^P[3]);  # 邏輯四參數模型（4-parameter logistic model）方程;
    # 必須將自變量作爲第一個參數，將待估參數作爲單獨的數組參數;
    # 應變量 y 為反應度光强度（relative light unit,RLU）;
    # 自變量 x 為含量劑量濃度（Dosage Concentration）;
    # 參數 P[1] 為 –∞ ≈ 0 劑量時的反應度相對光子數，是模型方程曲綫負向最小值漸近綫;
    # 參數 P[2] 為反應度相對光子數的最大值與最小值之差的一半時的含量劑量濃度值，即 y = ( ymax – ymin ) ÷ 2 對應的 x 值;
    # 參數 P[3] 為模型方程曲綫的斜率;
    # 參數 P[4] 為 +∞ 劑量時的反應度相對光子數，是模型方程曲綫正向最大值漸近綫;

    # # 自定義的邏輯五參數模型（5-parameter logistic model）方程;
    # # function fit_model(x, P1, P2, P3, P4, P5)
    # #     y = P4 - (P4 - P1)/((1.0 + (x/P2)^P3)^P5);  # 邏輯五參數模型（5-parameter logistic model）方程;
    # #     return y;
    # # end
    # # LsqFit.@. LC5Pmodel(x, P) = (fit_model(x, P[1], P[2], P[3], P[4], P[5]););
    # LsqFit.@. LC5Pmodel(x, P) = P[4] - (P[4] - P[1])/((1.0 + (x/P[2])^P[3])^P[5]);  # 邏輯五參數模型（5-parameter logistic model）方程;
    # # 必須將自變量作爲第一個參數，將待估參數作爲單獨的數組參數;
    # # 應變量 y 為反應度光强度（relative light unit,RLU）;
    # # 自變量 x 為含量劑量濃度（Dosage Concentration）;
    # # 參數 P[1] 為 –∞ ≈ 0 劑量時的反應度相對光子數，是模型方程曲綫負向最小值漸近綫;
    # # 參數 P[2] 為反應度相對光子數的最大值與最小值之差的一半時的含量劑量濃度值，即 y = ( ymax – ymin ) ÷ 2 對應的 x 值;
    # # 參數 P[3] 為模型方程曲綫的斜率;
    # # 參數 P[4] 為 +∞ 劑量時的反應度相對光子數，是模型方程曲綫正向最大值漸近綫;
    # # 參數 P[5] 為不對稱因子，當參數 P[5] = 1 時，函數曲綫是圍繞拐點的對稱圖形，5 參數模型退化等效於 4 參數模型;

    # # The finite difference method is used above to approximate the Jacobian.
    # # Alternatively, a function which calculates it exactly can be supplied instead.
    # function jacobian_model(x, P)
    #     J = Array{Float64}(undef, length(x), length(P))
    #     @. J[:,1] = exp(-x*P[2])     #dmodel/dP[1]
    #     @. @views J[:,2] = -x*P[1]*J[:,1] #dmodel/dP[2], thanks to @views we don't allocate memory for the J[:,1] slice
    #     J
    # end

    # function jacobian_inplace(J::Array{Float64,2}, x, P)
    #     @. J[:,1] = exp(-x*P[2])
    #     @. @views J[:,2] = -x*P[1]*J[:,1]
    # end

    # function Avv!(dir_deriv,p,v)
    #     v1 = v[1]
    #     v2 = v[2]
    #     for i=1:length(xdata)
    #         #compute all the elements of the Hessian matrix
    #         h11 = 0
    #         h12 = (-xdata[i] * exp(-xdata[i] * p[2]))
    #         #h21 = h12
    #         h22 = (xdata[i]^2 * p[1] * exp(-xdata[i] * p[2]))

    #         # manually compute v'Hv. This whole process might seem cumbersome, but
    #         # allocating temporary matrices quickly becomes REALLY expensive and might even
    #         # render the use of geodesic acceleration terribly inefficient
    #         dir_deriv[i] = h11*v1^2 + 2*h12*v1*v2 + h22*v2^2

    #     end
    # end

    # 使用第三方擴展包「LsqFit」中的「curve_fit()」函數，使用非綫性最小二乘法擬合曲綫方程;
    # fit = curve_fit(model, jacobian_model, xdata, ydata, p0_bounds; lower=lowerLimit, upper=upperLimit, autodiff=:finiteforward, avv!=Avv!, lambda=0, min_step_quality=0, inplace=true)
    # fit = curve_fit(model, [jacobian], x, y, [w,] p0; kwargs...):
    # model: function that takes two arguments (x, params)
    # jacobian: (optional) function that returns the Jacobian matrix of model
    # x: the independent variable
    # y: the dependent variable that constrains model
    # w: (optional) weight applied to the residual; can be a vector (of length(x) size or empty) or matrix (inverse covariance matrix)
    # p0: initial guess of the model parameters
    # kwargs: tuning parameters for fitting, passed to levenberg_marquardt, such as maxIter, show_trace or lower and upper bounds
    # fit: composite type of results (LsqFitResult)
    # This performs a fit using a non-linear iteration to minimize the (weighted) residual between the model and the dependent variable data (y). The weight (w) can be neglected (as per the example) to perform an unweighted fit. An unweighted fit is the numerical equivalent of w=1 for each point (although unweighted error estimates are handled differently from weighted error estimates even when the weights are uniform).
    # 加權最小二乘法擬合，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.confidence_interval(fit, 0.05;) 求解擬合得到的參數解的 95% 水平的致信區間;
    if Base.length(weight) > 0
        fit = LsqFit.curve_fit(
            LC4Pmodel,  # LC5Pmodel,
            Xdata,
            YdataMean,  # Ydata,
            weight,  # 自定義的擬合權重向量;
            Pdata_0;
            lower=Plower,
            upper=Pupper,
            # avv!=Avv!,
            # lambda=0,
            # min_step_quality=0
            autodiff=:finiteforward
        );
    elseif Core.Int64(Base.length(weight)) === Core.Int64(0)
        fit = LsqFit.curve_fit(
            LC4Pmodel,  # LC5Pmodel,
            Xdata,
            YdataMean,  # Ydata,
            # weight,  # 自定義的擬合權重向量;
            Pdata_0;
            lower=Plower,
            upper=Pupper,
            # avv!=Avv!,
            # lambda=0,
            # min_step_quality=0
            autodiff=:finiteforward
        );
    end
    # fit is a composite type (LsqFitResult), with some interesting values:
    #	dof(fit): degrees of freedom 擬合自由度
    #	coef(fit): best fit parameters 擬合得到的參數值
    #	fit.resid: residuals = vector of residuals 擬合殘差向量
    #	fit.jacobian: estimated Jacobian at solution 擬合解的參數估計雅可比（jacobian）矩陣;
    # println(LsqFit.coef(fit));  # LsqFit.coef(fit) 擬合得到的參數值;
    # println(LsqFit.dof(fit));  # LsqFit.dof(fit) 擬合自由度;
    # println(fit.resid);  # fit.resid 擬合殘差向量;
    # println(fit.jacobian);  # fit.jacobian 擬合解的參數估計雅可比（jacobian）矩陣;
    # Base.write(Base.stdout, LsqFit.coef(fit) * "\n");
    # [Base.string(LsqFit.coef(fit)[1]), Base.string(LsqFit.coef(fit)[2]), Base.string(LsqFit.coef(fit)[3]), Base.string(LsqFit.coef(fit)[4])]
    # Base.write(Base.stdout, fit.resid * "\n");
    # [Base.string(fit.resid[1]), Base.string(fit.resid[2]), Base.string(fit.resid[3]), Base.string(fit.resid[4]), Base.string(fit.resid[5]), Base.string(fit.resid[6]), Base.string(fit.resid[7]), Base.string(fit.resid[8]), Base.string(fit.resid[9]), Base.string(fit.resid[10]), Base.string(fit.resid[11])]

    P1 = LsqFit.coef(fit)[1];
    P2 = LsqFit.coef(fit)[2];
    P3 = LsqFit.coef(fit)[3];
    P4 = LsqFit.coef(fit)[4];
    # P5 = LsqFit.coef(fit)[5];

    # # sigma = stderror(fit; atol, rtol):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # atol: absolute tolerance for negativity check
    # # rtol: relative tolerance for negativity check
    # # This returns the error or uncertainty of each parameter fit to the model and already scaled by the associated degrees of freedom. Please note, this is a LOCAL quantity calculated from the Jacobian of the model evaluated at the best fit point and NOT the result of a parameter exploration.
    # # If no weights are provided for the fits, the variance is estimated from the mean squared error of the fits. If weights are provided, the weights are assumed to be the inverse of the variances or of the covariance matrix, and errors are estimated based on these and the Jacobian, assuming a linearization of the model around the minimum squared error point.
    # sigma = Core.Array{Core.Any, 1}();
    # if Core.Int64(Base.length(weight)) === Core.Int64(0)
    #     sigma = LsqFit.stderror(fit;);
    #     println(sigma);
    # end

    sdP1 = Core.nothing;
    sdP2 = Core.nothing;
    sdP3 = Core.nothing;
    sdP4 = Core.nothing;
    # sdP5 = Core.nothing;

    # # margin_of_error = margin_error(fit, alpha=0.05; atol, rtol):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # alpha: significance level
    # # atol: absolute tolerance for negativity check
    # # rtol: relative tolerance for negativity check
    # # This returns the product of standard error and critical value of each parameter at alpha significance level.
    margin_of_error = Core.Array{Core.Any, 1}();  # 擬合得到的參數解的標準差，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.margin_error(fit, 0.05;) 求解擬合得到的參數解的標準差;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        margin_of_error = LsqFit.margin_error(fit, 0.317;);  # 求解的 1SD 的值，標準正態分佈大約 68.3% 的概率分佈在 +-1SD 之間，0.317 = 1- 0.683 ;
        # println(margin_of_error);  # margin_of_error 擬合參數解的標準差;
        # Base.write(Base.stdout, margin_of_error * "\n");
        # [Base.string(margin_of_error[1]), Base.string(margin_of_error[2]), Base.string(margin_of_error[3]), Base.string(margin_of_error[4])]

        sdP1 = margin_of_error[1];
        sdP2 = margin_of_error[2];
        sdP3 = margin_of_error[3];
        sdP4 = margin_of_error[4];
        # sdP5 = margin_of_error[5];
    end
    # confidence_interval = confidence_interval(fit, alpha=0.05; atol, rtol):
    # fit: result of curve_fit (a LsqFitResult type)
    # alpha: significance level
    # atol: absolute tolerance for negativity check
    # rtol: relative tolerance for negativity check
    # This returns confidence interval of each parameter at alpha significance level.
    confidence_inter = Core.Array{Core.Any, 1}();  # 擬合得到的參數解的 95% 水平的致信區間，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.confidence_interval(fit, 0.05;) 求解擬合得到的參數解的 95% 水平的致信區間;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        confidence_inter = LsqFit.confidence_interval(fit, 0.05;);  # 求解擬合得到的參數解的 95% 水平的致信區間;
        # println(confidence_inter);  # confidence_inter 擬合參數解的 95% 水平的致信區間;
        # Base.write(Base.stdout, confidence_inter * "\n");
        # [Base.string(confidence_inter[1][1]), Base.string(confidence_inter[2][1]), Base.string(confidence_inter[3][1]), Base.string(confidence_inter[4][1])]
        # [Base.string(confidence_inter[1][2]), Base.string(confidence_inter[2][2]), Base.string(confidence_inter[3][2]), Base.string(confidence_inter[4][2])]
    end

    # # covar = estimate_covar(fit):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # covar: parameter covariance matrix calculated from the Jacobian of the model at the fit point, using the weights (if specified) as the inverse covariance of observations
    # # This returns the parameter covariance matrix evaluated at the best fit point.
    # covar = LsqFit.estimate_covar(fit;);
    # println(covar);

    # 計算擬合的應變量 Yvals 值;
    Yvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
    for i = 1:Base.length(Xdata)
        yv = P4 - (P4 - P1) / (1.0 + (Xdata[i] / P2)^P3);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
        # yv = P4 - (P4 - P1) / ((1.0 + (Xdata[i] / P2)^P3)^P5);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
        Base.push!(Yvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
    end

    # 計算擬合的應變量 Yvals 誤差上下限;
    # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
    # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
    # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
    YvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
    YvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        for i = 1:Base.length(Xdata)
            yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / (1.0 + (Xdata[i] / (P2 - sdP2))^(P3 - sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            # yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / ((1.0 + (Xdata[i] / (P2 - sdP2))^(P3 - sdP3))^(P5 - sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            yvLower = Yvals[i] - Base.sqrt((Yvals[i] - yvsd)^2 + YdataSTD[i]^2);
            Base.push!(YvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

            yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / (1.0 + (Xdata[i] / (P2 + sdP2))^(P3 + sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            # yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / ((1.0 + (Xdata[i] / (P2 + sdP2))^(P3 + sdP3))^(P5 + sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            yvUpper = Yvals[i] + Base.sqrt((yvsd - Yvals[i])^2 + YdataSTD[i]^2);
            Base.push!(YvalsUncertaintyUpper, yvUpper);
        end
    end

    # 計算擬合殘差;
    # Residual = Core.Array{Core.Float64, 2}();  # 擬合殘差向量;
    # for i = 1:Base.length(fit.resid)
    #     for j = 1:Base.length(fit.resid[i])
    #         resi = Core.Float64(fit.resid[i][j]);
    #         Base.push!(Residual[i], resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    #     end
    # end
    Residual = Core.Array{Core.Float64, 1}();  # 擬合殘差向量;
    for i = 1:Base.length(fit.resid)
        resi = Core.Float64(fit.resid[i]);
        Base.push!(Residual, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    # Residual = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # 擬合殘差向量;
    # for i = 1:Base.length(Ydata)
    #     # resi = Core.Float64(Core.Float64(YdataMean[i]) - Core.Float64(Yvals[i]));
    #     trainingResidual_1D = Core.Array{Core.Float64, 1}();
    #     for j = 1:Base.length(Ydata[i])
    #         resi = Core.Float64(Core.Float64(Ydata[i][j]) - Core.Float64(Yvals[i]));
    #         Base.push!(trainingResidual_1D, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    #     end
    #     Base.push!(Residual, trainingResidual_1D);  # 使用 push! 函數在數組末尾追加推入新元素;
    # end
    # testData["Residual"] = Residual;

    # 計算測試集數據的擬合值;
    testData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(testing_data, Base.Dict) && Base.length(testing_data) > 0

        testData = testing_data;
        if Base.haskey(testing_data, "Xdata")
            if (Base.typeof(testing_data["Xdata"]) <: Core.Array || Base.typeof(testing_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    if (Base.typeof(testing_data["Xdata"][i]) <: Core.Array || Base.typeof(testing_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # testData_Xdata_i = Core.Array{Core.Float64, 1}();
                            testData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"][i])));
                            for j = 1:Base.length(testing_data["Xdata"][i])
                                # Base.push!(testData_Xdata_i, Core.Float64(testing_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Xdata"][i][j] = Core.Float64(testing_data["Xdata"][i][j]);
                                # Base.push!(testData["Xdata"][i], Core.Float64(testing_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            end
                            # Base.push!(testData["Xdata"], testData_Xdata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                            # testData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Xdata"][i], Core.String) || Base.typeof(testing_data["Xdata"][i]) <: Core.Float64 || Base.typeof(testing_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # Base.push!(testData["Xdata"], Core.Float64(testing_data["Xdata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            testData["Xdata"][i] = Core.Float64(testing_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(testing_data, "Ydata")
            if (Base.typeof(testing_data["Ydata"]) <: Core.Array || Base.typeof(testing_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Ydata"])
                    if (Base.typeof(testing_data["Ydata"][i]) <: Core.Array || Base.typeof(testing_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # testData_Ydata_i = Core.Array{Core.Float64, 1}();
                            testData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"][i])));
                            for j = 1:Base.length(testing_data["Ydata"][i])
                                # Base.push!(testData_Ydata_i, Core.Float64(testing_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Ydata"][i][j] = Core.Float64(testing_data["Ydata"][i][j]);
                                # Base.push!(testData["Ydata"][i], Core.Float64(testing_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            end
                            # Base.push!(testData["Ydata"], testData_Ydata_i);  # 使用 push! 函數在數組末尾追加推入新元素;
                            # testData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Ydata"][i], Core.String) || Base.typeof(testing_data["Ydata"][i]) <: Core.Float64 || Base.typeof(testing_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # Base.push!(testData["Ydata"], Core.Float64(testing_data["Ydata"][i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                            testData["Ydata"][i] = Core.Float64(testing_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
        testing_data = testData;

        if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
            for i = 1:Base.length(testing_data["Xdata"])
                yv = P4 - (P4 - P1) / (1.0 + (testing_data["Xdata"][i] / P2)^P3);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                # yv = P4 - (P4 - P1) / ((1.0 + (testing_data["Xdata"][i] / P2)^P3)^P5);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                Base.push!(testYvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
            end
            testData["test-Yfit"] = testYvals;

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if Core.Int64(Base.length(weight)) === Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                    # yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3))^(P5 - sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                    yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

                    yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                    # yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3))^(P5 + sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                    yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyUpper, yvUpper);
                end
            end
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower;
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper;

            # 計算測試集數據的擬合殘差;
            # testResidual = Core.Array{Core.Float64, 1}();  # 擬合殘差向量;
            testResidual = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # 擬合殘差向量;
            for i = 1:Base.length(testing_data["Ydata"])
                # resi = Core.Float64(Core.Float64(testYdataMean[i]) - Core.Float64(testYvals[i]));
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    testResidual_1D = Core.Array{Core.Float64, 1}();
                    for j = 1:Base.length(testing_data["Ydata"][i])
                        resi = Core.Float64(Core.Float64(testing_data["Ydata"][i][j]) - Core.Float64(testYvals[i]));
                        Base.push!(testResidual_1D, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
                    end
                    Base.push!(testResidual, testResidual_1D);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    resi = Core.Float64(Core.Float64(testing_data["Ydata"][i]) - Core.Float64(testYvals[i]));
                    Base.push!(testResidual, [resi]);  # 使用 push! 函數在數組末尾追加推入新元素;
                end
            end
            testData["test-Residual"] = testResidual;

        elseif (!Base.haskey(testing_data, "Xdata") || Base.length(testing_data["Xdata"]) <= 0) && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = Core.Array{Core.Float64, 1}();  # 應變量 X 的擬合值;
            for i = 1:Base.length(testYdataMean)
                xv = ((((P4 - P1) / (P4 - testYdataMean[i])) - 1.0)^(1.0 / P3)) * P2;  # ((((P4 - P1) / (P4 - x[i])) - 1.0)^(1.0 / P3)) * P2;
                # xv = (((((P4 - P1) / (P4 - testYdataMean[i])))^(1.0 / P5) - 1.0)^(1.0 / P3)) * P2;  # (((((P4 - P1) / (P4 - x[i])))^(1.0 / P5) - 1.0)^(1.0 / P3)) * P2;
                Base.push!(testXvals, xv);  # 使用 push! 函數在數組末尾追加推入新元;
            end
            testData["test-Xvals"] = testXvals;

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if Core.Int64(Base.length(weight)) === Core.Int64(0)
                # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲方程擬合（Curve Fitting）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
                testXdataSTD = Core.Array{Core.Float64, 1}();
                for j = 1:Base.length(testYdataSTD)
                    xv = Base.abs((((((P4 - P1) / (P4 - testYdataMean[j])) - 1.0)^(1.0 / P3)) * P2) - (((((P4 - P1) / (P4 - (testYdataMean[j] + testYdataSTD[j]))) - 1.0)^(1.0 / P3)) * P2));
                    # xv = Base.abs(((((((P4 - P1) / (P4 - testYdataMean[j])))^(1.0 / P5) - 1.0)^(1.0 / P3)) * P2) - ((((((P4 - P1) / (P4 - (testYdataMean[j] + testYdataSTD[j]))))^(1.0 / P5) - 1.0)^(1.0 / P3)) * P2));
                    Base.push!(testXdataSTD, xv);  # 使用 push! 函數在數組末尾追加推入新元;
                end
                # 通過方程擬合算法（Curve Fitting Algorithm）的標準差（Standard Deviation）（擬合獲得方程參數的標準差），轉換爲擬合（Curve Fitting）之後的 X 值的擬合算法（Curve Fitting Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲擬合（Curve Fitting）之後的 X 值的總標準差（Standard Deviation）;
                for i = 1:Base.length(testYdataMean)
                    xvsd = (((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - testYdataMean[i])) - 1.0)^(1.0 / (P3 - sdP3))) * (P2 - sdP2);  # (((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - x[i])) - 1.0)^(1.0 / (P3 - sdP3))) * (P2 - sdP2);
                    # xvsd = ((((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - testYdataMean[i])))^(1.0 / (P5 - sdP5)) - 1.0)^(1.0 / (P3 - sdP3))) * (P2 - sdP2);  # ((((((P4 - sdP4) - (P1 - sdP1)) / ((P4 - sdP4) - x[i])))^(1.0 / (P5 - sdP5)) - 1.0)^(1.0 / (P3 - sdP3))) * (P2 - sdP2);
                    xvLower = testXvals[i] - Base.sqrt((testXvals[i] - xvsd)^2 + testXdataSTD[i]^2);
                    Base.push!(testXvalsUncertaintyLower, xvLower);  # 使用 push! 函數在數組末尾追加推入新元;

                    xvsd = (((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - testYdataMean[i])) - 1.0)^(1.0 / (P3 + sdP3))) * (P2 + sdP2);  # (((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - x[i])) - 1.0)^(1.0 / (P3 + sdP3))) * (P2 + sdP2);
                    # xvsd = ((((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - testYdataMean[i])))^(1.0 / (P5 + sdP5)) - 1.0)^(1.0 / (P3 + sdP3))) * (P2 + sdP2);  # ((((((P4 + sdP4) - (P1 + sdP1)) / ((P4 + sdP4) - x[i])))^(1.0 / (P5 + sdP5)) - 1.0)^(1.0 / (P3 + sdP3))) * (P2 + sdP2);
                    xvUpper = testXvals[i] + Base.sqrt((xvsd - testXvals[i])^2 + testXdataSTD[i]^2);
                    Base.push!(testXvalsUncertaintyUpper, xvUpper);
                end
            end
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower;
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper;

        elseif Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && (!Base.haskey(testing_data, "Ydata") || Base.length(testing_data["Ydata"]) <= 0)

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
            for i = 1:Base.length(testing_data["Xdata"])
                yv = P4 - (P4 - P1) / (1.0 + (testing_data["Xdata"][i] / P2)^P3);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                # yv = P4 - (P4 - P1) / ((1.0 + (testing_data["Xdata"][i] / P2)^P3)^P5);  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                Base.push!(testYvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
            end
            testData["test-Yfit"] = testYvals;

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if Core.Int64(Base.length(weight)) === Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                    # yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3))^(P5 - sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                    yvLower = Core.Float64(yvsd);
                    # yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2);
                    # yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

                    yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
                    # yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3))^(P5 + sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
                    yvUpper = Core.Float64(yvsd);
                    # yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2);
                    # yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyUpper, yvUpper);
                end
            end
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower;
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper;

        else
        end
    end

    # http://gadflyjl.org/stable/gallery/geometries/#[Geom.segment](@ref)
    # 繪圖;
    img1 = Core.nothing;
    img2 = Core.nothing;
    if true

        set_default_plot_size(21cm, 21cm);  # 設定畫布規格;
    
        # 繪製擬合散點圖;
        # img1 = Core.nothing;
        if Core.Int64(Base.length(weight)) === Core.Int64(0)
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],  # :dot
                    default_color="red",  # gray
                    alphas=[1],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # 繪製置信區間填充圖;
            ribbonline1 = Gadfly.layer(
                x=Xdata,
                # y=Yvals,
                ymin=YvalsUncertaintyLower,
                ymax=YvalsUncertaintyUpper,
                # Geom.smooth,
                Geom.ribbon(fill=true),
                Theme(
                    # point_size=5pt,
                    line_width=0.1pt,
                    line_style=[:dot],  # :solid
                    default_color="gray",  # grey
                    alphas=[0.5],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # smoothline2 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyLower,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            # smoothline3 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyUpper,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # smoothline2,
                # smoothline3,
                ribbonline1,
                Guide.title("4-parameter logistic model"),
                Guide.xlabel("Dosage"),
                Guide.ylabel("relative light unit , RLU"),
                Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"])
            );
        elseif Base.length(weight) > 0
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],
                    default_color="red",
                    alphas=[1],
                    # default_color="gray"  # grey
                )  # color=[colorant"red"],
            );
            # # 繪製置信區間填充圖;
            # ribbonline1 = Gadfly.layer(
            #     x=Xdata,
            #     # y=Yvals,
            #     ymin=YvalsUncertaintyLower,
            #     ymax=YvalsUncertaintyUpper,
            #     # Geom.smooth,
            #     Geom.ribbon(fill=true),
            #     Theme(
            #         # point_size=5pt,
            #         line_width=0.1pt,
            #         line_style=[:dot],  # :solid
            #         default_color="gray",  # grey
            #         alphas=[0.5],
            #         # lowlight_color=c->"gray"
            #     )  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # ribbonline1,
                Guide.title("4-parameter logistic model"),
                Guide.xlabel("Dosage"),
                Guide.ylabel("relative light unit , RLU"),
                Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"])
            );
        end
        # Gadfly.draw(
        #     Gadfly.SVG(
        #         "./Curvefit.svg",
        #         21cm,
        #         21cm
        #     ),  # 保存爲 .svg 格式圖片;
        #     # Gadfly.PDF(
        #     #     "Curvefit.pdf",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .pdf 格式圖片;
        #     # Gadfly.PNG(
        #     #     "Curvefit.png",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .png 格式圖片;
        #     img1
        # );
    
        # 繪製擬合殘差圖;
        points2 = Gadfly.layer(
            x=Xdata,
            y=Residual,
            Geom.point,
            # Geom.line,
            # Geom.abline,
            # Geom.smooth(method=:loess, smoothing=0.9),
            color=[colorant"blue"],
            Theme(line_width=1pt)
        );
        line2 = Gadfly.layer(
            x=[Base.findmin(Xdata)[1], Base.findmax(Xdata)[1]],
            y=[Statistics.mean(Residual), Statistics.mean(Residual)],
            Geom.line,
            Theme(
                # point_size=5pt,
                line_width=1.0pt,
                line_style=[:solid],
                default_color="red",
                alphas=[1]
            )  # color=[colorant"red"],
        );
        img2 = Gadfly.plot(
            points2,
            line2,
            # Guide.title("Residual ~ 4-parameter logistic model"),
            Guide.xlabel("Dosage"),
            Guide.ylabel("Residual"),
            # Guide.manual_discrete_key("", ["Residual", "Residual mean"]; color=["blue", "red"])
        );
        # Gadfly.draw(
        #     Gadfly.SVG(
        #         "./Residual.svg",
        #         21cm,
        #         21cm
        #     ),  # 保存爲 .svg 格式圖片;
        #     # Gadfly.PDF(
        #     #     "Residual.pdf",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .pdf 格式圖片;
        #     # Gadfly.PNG(
        #     #     "Residual.png",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .png 格式圖片;
        #     img2
        # );
    
        # # Gadfly.hstack(img1, img2);
        # # Gadfly.title(Gadfly.hstack(img1, img2), "4-parameter logistic model weighted least square method curve fit");
        # Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2));
        # Gadfly.title(Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2)), "4-parameter logistic model weighted least square method curve fit");
    end

    resultDict = Base.Dict{Core.String, Core.Any}();
    if Base.length(weight) > 0
        resultDict["Coefficient"] = LsqFit.coef(fit);
        resultDict["Residual"] = fit.resid;
        resultDict["Yfit"] = Yvals;
        resultDict["Coefficient-StandardDeviation"] = [];
        resultDict["Coefficient-Confidence-Lower-95%"] = [];
        resultDict["Coefficient-Confidence-Upper-95%"] = [];
        resultDict["Yfit-Uncertainty-Lower"] = [];  # 擬合的應變量 Yvals 誤差下限;
        resultDict["Yfit-Uncertainty-Upper"] = [];  # 擬合的應變量 Yvals 誤差上限;
        resultDict["testData"] = testData;  # 傳入測試數據集的計算結果;
        resultDict["Curve-fit-image"] = img1;  # 擬合曲綫繪圖;
        resultDict["Residual-image"] = img2;  # 擬合殘差繪圖;
    elseif Core.Int64(Base.length(weight)) === Core.Int64(0)
        resultDict["Coefficient"] = LsqFit.coef(fit);
        resultDict["Residual"] = fit.resid;
        resultDict["Yfit"] = Yvals;
        resultDict["Coefficient-StandardDeviation"] = margin_of_error;  # 擬合得到的參數解的標準差;
        resultDict["Coefficient-Confidence-Lower-95%"] = [confidence_inter[1][1], confidence_inter[2][1], confidence_inter[3][1], confidence_inter[4][1]];
        resultDict["Coefficient-Confidence-Upper-95%"] = [confidence_inter[1][2], confidence_inter[2][2], confidence_inter[3][2], confidence_inter[4][2]];
        resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower;  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper;  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["testData"] = testData;  # 傳入測試數據集的計算結果;
        resultDict["Curve-fit-image"] = img1;  # 擬合曲綫繪圖;
        resultDict["Residual-image"] = img2;  # 擬合殘差繪圖;
    end
    # println(resultDict);

    return resultDict;
end


# # 函數使用示例;
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
# # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => YdataMean);

# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata[begin+1:end-1], "Ydata" => Ydata[begin+1:end-1]);
# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
# testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => YdataMean[begin+1:end-1]);
# # testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => Ydata[begin+1:end-1]);
# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata);
# # testing_data = training_data;

# Pdata_0 = [
#     Base.findmin(YdataMean)[1] * 0.9,
#     Statistics.mean(Xdata),
#     (1 - Base.findmin(YdataMean)[1] / Base.findmax(YdataMean)[1]) / (1 - Base.findmin(Xdata)[1] / Base.findmax(Xdata)[1]),
#     Base.findmax(YdataMean)[1] * 1.1
#     # Core.Float64(1)
# ];

# Plower = [
#     -Base.Inf,
#     -Base.Inf,
#     -Base.Inf,
#     -Base.Inf
#     # -Base.Inf
# ];
# Pupper = [
#     +Base.Inf,
#     +Base.Inf,
#     +Base.Inf,
#     +Base.Inf
#     # +Base.Inf
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


# using LsqFit;  # 導入第三方擴展包「LsqFit」，用於任意形式曲缐方程擬合（Curve Fitting），需要在控制臺先安裝第三方擴展包「LsqFit」：julia> using Pkg; Pkg.add("LsqFit") 成功之後才能使用;
# https://julianlsolvers.github.io/LsqFit.jl/latest/
# https://github.com/JuliaNLSolvers/LsqFit.jl
# using Roots;  # 導入第三方擴展包「Roots」，用於求解任意形式一元非缐性方程，需要在控制臺先安裝第三方擴展包「Roots」：julia> using Pkg; Pkg.add("Roots") 成功之後才能使用;
# https://juliamath.github.io/Roots.jl/stable
# https://github.com/JuliaMath/Roots.jl
# 3 階多項式（Polynomial(Cubic)）曲缐擬合 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 ;
function Polynomial3Fit(
    training_data::Base.Dict{Core.String, Core.Any};
    testing_data::Base.Dict{Core.String, Core.Any} = training_data,
    Pdata_0 = Core.Array{Core.Float64, 1}(),
    weight = Core.Array{Core.Float64, 1}(),
    Plower = [-Base.Inf, -Base.Inf, -Base.Inf, -Base.Inf],
    Pupper = [+Base.Inf, +Base.Inf, +Base.Inf, +Base.Inf]
) ::Base.Dict{Core.String, Core.Any}

    trainingData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(training_data, Base.Dict) && Core.Int64(Base.length(training_data)) > Core.Int64(0)
        if Base.haskey(training_data, "Xdata")
            if (Base.typeof(training_data["Xdata"]) <: Core.Array || Base.typeof(training_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Xdata"])
                    if (Base.typeof(training_data["Xdata"][i]) <: Core.Array || Base.typeof(training_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # trainingData_Xdata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"][i])));
                            for j = 1:Base.length(training_data["Xdata"][i])
                                # Base.push!(trainingData_Xdata_i, Core.Float64(training_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Xdata"][i][j] = Core.Float64(training_data["Xdata"][i][j]);
                                # Base.push!(trainingData["Xdata"][i], Core.Float64(training_data["Xdata"][i][j]));
                            end
                            # Base.push!(trainingData["Xdata"], trainingData_Xdata_i);
                            # trainingData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Xdata"][i], Core.String) || Base.typeof(training_data["Xdata"][i]) <: Core.Float64 || Base.typeof(training_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # Base.push!(trainingData["Xdata"], Core.Float64(training_data["Xdata"][i]));
                            trainingData["Xdata"][i] = Core.Float64(training_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(training_data, "Ydata")
            if (Base.typeof(training_data["Ydata"]) <: Core.Array || Base.typeof(training_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Ydata"])
                    if (Base.typeof(training_data["Ydata"][i]) <: Core.Array || Base.typeof(training_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # trainingData_Ydata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"][i])));
                            for j = 1:Base.length(training_data["Ydata"][i])
                                # Base.push!(trainingData_Ydata_i, Core.Float64(training_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Ydata"][i][j] = Core.Float64(training_data["Ydata"][i][j]);
                                # Base.push!(trainingData["Ydata"][i], Core.Float64(training_data["Ydata"][i][j]));
                            end
                            # Base.push!(trainingData["Ydata"], trainingData_Ydata_i);
                            # trainingData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Ydata"][i], Core.String) || Base.typeof(training_data["Ydata"][i]) <: Core.Float64 || Base.typeof(training_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # Base.push!(trainingData["Ydata"], Core.Float64(training_data["Ydata"][i]));
                            trainingData["Ydata"][i] = Core.Float64(training_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
    end
    # Xdata::Core.Array{Core.Float64, 1} = trainingData["Xdata"];
    # Ydata::Core.Array{Core.Array{Core.Float64, 1}, 1} = trainingData["Ydata"];
    Xdata = trainingData["Xdata"];
    # println(Xdata);
    Ydata = trainingData["Ydata"];
    # println(Ydata);

    # 求 Ydata 均值向量;
    YdataMean = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            yMean = Core.Float64(Statistics.mean(Ydata[i]));
            Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        else
            yMean = Core.Float64(Ydata[i]);
            Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        end
    end
    # println(YdataMean);
    # 求 Ydata 標準差向量;
    YdataSTD = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            if Core.Int64(Base.length(Ydata[i])) === Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=false));
                Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
            elseif Core.Int64(Base.length(Ydata[i])) > Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=true));
                Base.push!(YdataSTD, ySTD);
            end
        else
            ySTD = Core.Float64(0.0);
            Base.push!(YdataSTD, ySTD);
        end
    end
    # println(YdataSTD);

    # 參數初始值;
    Pdata_0_P1 = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(YdataMean)
        if Core.Float64(Xdata[i]) !== Core.Float64(0.0)
            Pdata_0_P1_I = Core.Float64(YdataMean[i] / Xdata[i]^3);
        else
            Pdata_0_P1_I = Core.Float64(YdataMean[i] - Xdata[i]^3);
        end
        Base.push!(Pdata_0_P1, Pdata_0_P1_I);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    Pdata_0_P1 = Core.Float64(Statistics.mean(Pdata_0_P1));
    # println(Pdata_0_P1);

    Pdata_0_P2 = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(YdataMean)
        if Core.Float64(Xdata[i]) !== Core.Float64(0.0)
            Pdata_0_P2_I = Core.Float64(YdataMean[i] / Xdata[i]^2);
        else
            Pdata_0_P2_I = Core.Float64(YdataMean[i] - Xdata[i]^2);
        end
        Base.push!(Pdata_0_P2, Pdata_0_P2_I);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    Pdata_0_P2 = Core.Float64(Statistics.mean(Pdata_0_P2));
    # println(Pdata_0_P2);

    Pdata_0_P3 = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(YdataMean)
        if Core.Float64(Xdata[i]) !== Core.Float64(0.0)
            Pdata_0_P3_I = Core.Float64(YdataMean[i] / Xdata[i]^1);
        else
            Pdata_0_P3_I = Core.Float64(YdataMean[i] - Xdata[i]^1);
        end
        Base.push!(Pdata_0_P3, Pdata_0_P3_I);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    Pdata_0_P3 = Core.Float64(Statistics.mean(Pdata_0_P3));
    # println(Pdata_0_P3);

    Pdata_0_P4 = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(YdataMean)
        if Core.Float64(Xdata[i]) !== Core.Float64(0.0)
            # 符號 / 表示常規除法，符號 % 表示除法取餘，等價於 Base.rem() 函數，符號 ÷ 表示除法取整，符號 * 表示乘法，符號 ^ 表示冪運算，符號 + 表示加法，符號 - 表示減法;
            Pdata_0_P4_I_1 = Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Pdata_0_P3 * Xdata[i]^1)) * Core.Float64(Pdata_0_P3 * Xdata[i]^1));
            Pdata_0_P4_I_2 = Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Pdata_0_P2 * Xdata[i]^2)) * Core.Float64(Pdata_0_P2 * Xdata[i]^2));
            Pdata_0_P4_I_3 = Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Pdata_0_P1 * Xdata[i]^3)) * Core.Float64(Pdata_0_P1 * Xdata[i]^3));
            Pdata_0_P4_I = Core.Float64(Pdata_0_P4_I_1 + Pdata_0_P4_I_2 + Pdata_0_P4_I_3);
        else
            Pdata_0_P4_I = Core.Float64(YdataMean[i] - Xdata[i]);
        end
        Base.push!(Pdata_0_P4, Pdata_0_P4_I);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    Pdata_0_P4 = Core.Float64(Statistics.mean(Pdata_0_P4));
    # println(Pdata_0_P4);

    # Pdata_0 = Core.Array{Core.Float64, 1}();
    # Pdata_0 = [
    #     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])),
    #     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])),
    #     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])),
    #     Core.Float64(Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) for i in 1:Base.length(YdataMean)]))
    # ];
    if Core.Int64(Base.length(Pdata_0)) === Core.Int64(0)
        Pdata_0 = [
            Pdata_0_P1,
            Pdata_0_P2,
            Pdata_0_P3,
            Pdata_0_P4
        ];
    end
    # println(Pdata_0);

    # # 參數值上下限;
    # # Plower = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();
    # Plower = [
    #     -Base.Inf,  # P[1];
    #     -Base.Inf,  # P[2];
    #     -Base.Inf,  # P[3];
    #     -Base.Inf  # P[4];
    # ];
    # # println(Plower);
    # # Pupper = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}()
    # Pupper = [
    #     +Base.Inf,  # P[1];
    #     +Base.Inf,  # P[2];
    #     +Base.Inf,  # P[3];
    #     +Base.Inf  # P[4];
    # ];
    # # println(Pupper);

    # # 變量實測值擬合權重;
    # weight = Core.Array{Core.Float64, 1}();
    # # 使用高斯核賦權法;
    # target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
    # af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
    # for i = 1:Base.length(YdataMean)
    #     wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
    #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
    # end
    # # # 使用方差倒數值賦權法;
    # # for i = 1:Base.length(YdataSTD)
    # #     wei = 1 / YdataSTD[i];  # Statistics.std(Ydata[i]), Statistics.var(Ydata[i]);
    # #     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
    # # end
    # # println(weight);

    # https://github.com/JuliaNLSolvers/LsqFit.jl
    # https://ww2.mathworks.cn/matlabcentral/fileexchange/38043-five-parameters-logistic-regression-there-and-back-again
    # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
    # function fit_model(x, P1, P2, P3, P4)
    #     y = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
    #     return y;
    # end
    # LsqFit.@. f_fit_model(x, P) = (fit_model(x, P[1], P[2], P[3], P[4]););
    LsqFit.@. f_fit_model(x, P) = (P[4])*(x^0) + (P[3])*(x^1) + (P[2])*(x^2) + (P[1])*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
    # 必須將自變量作爲第一個參數，將待估參數作爲單獨的數組參數;
    # 應變量 y 為反應度光强度（relative light unit,RLU）;
    # 自變量 x 為含量劑量濃度（Dosage Concentration）;
    # 參數 P[1] 為自變量 3 次項系數（x^3）;
    # 參數 P[2] 為自變量 2 次項系數（x^2）;
    # 參數 P[3] 為自變量 1 次項系數（x^1）;
    # 參數 P[4] 為自變量常數項（0 次項）系數（x^0）;

    # # The finite difference method is used above to approximate the Jacobian.
    # # Alternatively, a function which calculates it exactly can be supplied instead.
    # function jacobian_model(x, P)
    #     J = Array{Float64}(undef, length(x), length(P))
    #     @. J[:,1] = exp(-x*P[2])     #dmodel/dP[1]
    #     @. @views J[:,2] = -x*P[1]*J[:,1] #dmodel/dP[2], thanks to @views we don't allocate memory for the J[:,1] slice
    #     J
    # end

    # function jacobian_inplace(J::Array{Float64,2}, x, P)
    #     @. J[:,1] = exp(-x*P[2])
    #     @. @views J[:,2] = -x*P[1]*J[:,1]
    # end

    # function Avv!(dir_deriv,p,v)
    #     v1 = v[1]
    #     v2 = v[2]
    #     for i=1:length(xdata)
    #         #compute all the elements of the Hessian matrix
    #         h11 = 0
    #         h12 = (-xdata[i] * exp(-xdata[i] * p[2]))
    #         #h21 = h12
    #         h22 = (xdata[i]^2 * p[1] * exp(-xdata[i] * p[2]))

    #         # manually compute v'Hv. This whole process might seem cumbersome, but
    #         # allocating temporary matrices quickly becomes REALLY expensive and might even
    #         # render the use of geodesic acceleration terribly inefficient
    #         dir_deriv[i] = h11*v1^2 + 2*h12*v1*v2 + h22*v2^2

    #     end
    # end

    # 使用第三方擴展包「LsqFit」中的「curve_fit()」函數，使用非綫性最小二乘法擬合曲綫方程;
    # fit = curve_fit(model, jacobian_model, xdata, ydata, p0_bounds; lower=lowerLimit, upper=upperLimit, autodiff=:finiteforward, avv!=Avv!, lambda=0, min_step_quality=0, inplace=true)
    # fit = curve_fit(model, [jacobian], x, y, [w,] p0; kwargs...):
    # model: function that takes two arguments (x, params)
    # jacobian: (optional) function that returns the Jacobian matrix of model
    # x: the independent variable
    # y: the dependent variable that constrains model
    # w: (optional) weight applied to the residual; can be a vector (of length(x) size or empty) or matrix (inverse covariance matrix)
    # p0: initial guess of the model parameters
    # kwargs: tuning parameters for fitting, passed to levenberg_marquardt, such as maxIter, show_trace or lower and upper bounds
    # fit: composite type of results (LsqFitResult)
    # This performs a fit using a non-linear iteration to minimize the (weighted) residual between the model and the dependent variable data (y). The weight (w) can be neglected (as per the example) to perform an unweighted fit. An unweighted fit is the numerical equivalent of w=1 for each point (although unweighted error estimates are handled differently from weighted error estimates even when the weights are uniform).
    # 加權最小二乘法擬合，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.confidence_interval(fit, 0.05;) 求解擬合得到的參數解的 95% 水平的致信區間;
    if Base.length(weight) > 0
        fit = LsqFit.curve_fit(
            f_fit_model,
            Xdata,
            YdataMean,  # Ydata,
            weight,  # 自定義的擬合權重向量;
            Pdata_0;
            lower=Plower,
            upper=Pupper,
            # avv!=Avv!,
            # lambda=0,
            # min_step_quality=0
            autodiff=:finiteforward
        );
    elseif Core.Int64(Base.length(weight)) === Core.Int64(0)
        fit = LsqFit.curve_fit(
            f_fit_model,
            Xdata,
            YdataMean,  # Ydata,
            # weight,  # 自定義的擬合權重向量;
            Pdata_0;
            lower=Plower,
            upper=Pupper,
            # avv!=Avv!,
            # lambda=0,
            # min_step_quality=0
            autodiff=:finiteforward
        );
    end
    # fit is a composite type (LsqFitResult), with some interesting values:
    #	dof(fit): degrees of freedom 擬合自由度
    #	coef(fit): best fit parameters 擬合得到的參數值
    #	fit.resid: residuals = vector of residuals 擬合殘差向量
    #	fit.jacobian: estimated Jacobian at solution 擬合解的參數估計雅可比（jacobian）矩陣;
    # println(LsqFit.coef(fit));  # LsqFit.coef(fit) 擬合得到的參數值;
    # println(LsqFit.dof(fit));  # LsqFit.dof(fit) 擬合自由度;
    # println(fit.resid);  # fit.resid 擬合殘差向量;
    # println(fit.jacobian);  # fit.jacobian 擬合解的參數估計雅可比（jacobian）矩陣;
    # Base.write(Base.stdout, LsqFit.coef(fit) * "\n");
    # [Base.string(LsqFit.coef(fit)[1]), Base.string(LsqFit.coef(fit)[2]), Base.string(LsqFit.coef(fit)[3]), Base.string(LsqFit.coef(fit)[4])]
    # Base.write(Base.stdout, fit.resid * "\n");
    # [Base.string(fit.resid[1]), Base.string(fit.resid[2]), Base.string(fit.resid[3]), Base.string(fit.resid[4]), Base.string(fit.resid[5]), Base.string(fit.resid[6]), Base.string(fit.resid[7]), Base.string(fit.resid[8]), Base.string(fit.resid[9]), Base.string(fit.resid[10]), Base.string(fit.resid[11])]

    P1 = LsqFit.coef(fit)[1];
    P2 = LsqFit.coef(fit)[2];
    P3 = LsqFit.coef(fit)[3];
    P4 = LsqFit.coef(fit)[4];

    # # sigma = stderror(fit; atol, rtol):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # atol: absolute tolerance for negativity check
    # # rtol: relative tolerance for negativity check
    # # This returns the error or uncertainty of each parameter fit to the model and already scaled by the associated degrees of freedom. Please note, this is a LOCAL quantity calculated from the Jacobian of the model evaluated at the best fit point and NOT the result of a parameter exploration.
    # # If no weights are provided for the fits, the variance is estimated from the mean squared error of the fits. If weights are provided, the weights are assumed to be the inverse of the variances or of the covariance matrix, and errors are estimated based on these and the Jacobian, assuming a linearization of the model around the minimum squared error point.
    # sigma = Core.Array{Core.Any, 1}();
    # if Core.Int64(Base.length(weight)) === Core.Int64(0)
    #     sigma = LsqFit.stderror(fit;);
    #     println(sigma);
    # end

    sdP1 = Core.nothing;
    sdP2 = Core.nothing;
    sdP3 = Core.nothing;
    sdP4 = Core.nothing;

    # # margin_of_error = margin_error(fit, alpha=0.05; atol, rtol):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # alpha: significance level
    # # atol: absolute tolerance for negativity check
    # # rtol: relative tolerance for negativity check
    # # This returns the product of standard error and critical value of each parameter at alpha significance level.
    margin_of_error = Core.Array{Core.Any, 1}();  # 擬合得到的參數解的標準差，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.margin_error(fit, 0.05;) 求解擬合得到的參數解的標準差;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        margin_of_error = LsqFit.margin_error(fit, 0.317;);  # 求解的 1SD 的值，標準正態分佈大約 68.3% 的概率分佈在 +-1SD 之間，0.317 = 1- 0.683 ;
        # println(margin_of_error);  # margin_of_error 擬合參數解的標準差;
        # Base.write(Base.stdout, margin_of_error * "\n");
        # [Base.string(margin_of_error[1]), Base.string(margin_of_error[2]), Base.string(margin_of_error[3]), Base.string(margin_of_error[4])]

        sdP1 = margin_of_error[1];
        sdP2 = margin_of_error[2];
        sdP3 = margin_of_error[3];
        sdP4 = margin_of_error[4];
    end
    # confidence_interval = confidence_interval(fit, alpha=0.05; atol, rtol):
    # fit: result of curve_fit (a LsqFitResult type)
    # alpha: significance level
    # atol: absolute tolerance for negativity check
    # rtol: relative tolerance for negativity check
    # This returns confidence interval of each parameter at alpha significance level.
    confidence_inter = Core.Array{Core.Any, 1}();  # 擬合得到的參數解的 95% 水平的致信區間，注意，當使用加權 weight 擬合時，則不能使用 LsqFit.confidence_interval(fit, 0.05;) 求解擬合得到的參數解的 95% 水平的致信區間;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        confidence_inter = LsqFit.confidence_interval(fit, 0.05;);  # 求解擬合得到的參數解的 95% 水平的致信區間;
        # println(confidence_inter);  # confidence_inter 擬合參數解的 95% 水平的致信區間;
        # Base.write(Base.stdout, confidence_inter * "\n");
        # [Base.string(confidence_inter[1][1]), Base.string(confidence_inter[2][1]), Base.string(confidence_inter[3][1]), Base.string(confidence_inter[4][1])]
        # [Base.string(confidence_inter[1][2]), Base.string(confidence_inter[2][2]), Base.string(confidence_inter[3][2]), Base.string(confidence_inter[4][2])]
    end

    # # covar = estimate_covar(fit):
    # # fit: result of curve_fit (a LsqFitResult type)
    # # covar: parameter covariance matrix calculated from the Jacobian of the model at the fit point, using the weights (if specified) as the inverse covariance of observations
    # # This returns the parameter covariance matrix evaluated at the best fit point.
    # covar = LsqFit.estimate_covar(fit;);
    # println(covar);

    # 計算擬合的應變量 Yvals 值;
    Yvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
    for i = 1:Base.length(Xdata)
        yv = P4*((Xdata[i])^0) + P3*((Xdata[i])^1) + P2*((Xdata[i])^2) + P1*((Xdata[i])^3);  # y = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3
        Base.push!(Yvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
    end

    # 計算擬合的應變量 Yvals 誤差上下限;
    # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
    # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
    # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
    YvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
    YvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
    if Core.Int64(Base.length(weight)) === Core.Int64(0)
        for i = 1:Base.length(Xdata)
            yvsd = (P4 - sdP4)*((Xdata[i])^0) + (P3 - sdP3)*((Xdata[i])^1) + (P2 - sdP2)*((Xdata[i])^2) + (P1 - sdP1)*((Xdata[i])^3);  # y = (P4 - sdP4)·x^0 + (P3 - sdP3)·x^1 + (P2 - sdP2)·x^2 + (P1 - sdP1)·x^3
            yvLower = Yvals[i] - Base.sqrt((Yvals[i] - yvsd)^2 + YdataSTD[i]^2);
            Base.push!(YvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

            yvsd = (P4 + sdP4)*((Xdata[i])^0) + (P3 + sdP3)*((Xdata[i])^1) + (P2 + sdP2)*((Xdata[i])^2) + (P1 + sdP1)*((Xdata[i])^3);  # y = (P4 + sdP4)·x^0 + (P3 + sdP3)·x^1 + (P2 + sdP2)·x^2 + (P1 + sdP1)·x^3
            yvUpper = Yvals[i] + Base.sqrt((yvsd - Yvals[i])^2 + YdataSTD[i]^2);
            Base.push!(YvalsUncertaintyUpper, yvUpper);
        end
    end

    # 計算擬合殘差;
    # Residual = Core.Array{Core.Float64, 2}();  # 擬合殘差向量;
    # for i = 1:Base.length(fit.resid)
    #     for j = 1:Base.length(fit.resid[i])
    #         resi = Core.Float64(fit.resid[i][j]);
    #         Base.push!(Residual[i], resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    #     end
    # end
    Residual = Core.Array{Core.Float64, 1}();  # 擬合殘差向量;
    for i = 1:Base.length(fit.resid)
        resi = Core.Float64(fit.resid[i]);
        Base.push!(Residual, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    end
    # Residual = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # 擬合殘差向量;
    # for i = 1:Base.length(Ydata)
    #     # resi = Core.Float64(Core.Float64(YdataMean[i]) - Core.Float64(Yvals[i]));
    #     trainingResidual_1D = Core.Array{Core.Float64, 1}();
    #     for j = 1:Base.length(Ydata[i])
    #         resi = Core.Float64(Core.Float64(Ydata[i][j]) - Core.Float64(Yvals[i]));
    #         Base.push!(trainingResidual_1D, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
    #     end
    #     Base.push!(Residual, trainingResidual_1D);  # 使用 push! 函數在數組末尾追加推入新元素;
    # end
    # testData["Residual"] = Residual;

    # 計算測試集數據的擬合值;
    testData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(testing_data, Base.Dict) && Base.length(testing_data) > 0

        testData = testing_data;
        if Base.haskey(testing_data, "Xdata")
            if (Base.typeof(testing_data["Xdata"]) <: Core.Array || Base.typeof(testing_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    if (Base.typeof(testing_data["Xdata"][i]) <: Core.Array || Base.typeof(testing_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # testData_Xdata_i = Core.Array{Core.Float64, 1}();
                            testData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"][i])));
                            for j = 1:Base.length(testing_data["Xdata"][i])
                                # Base.push!(testData_Xdata_i, Core.Float64(testing_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Xdata"][i][j] = Core.Float64(testing_data["Xdata"][i][j]);
                                # Base.push!(testData["Xdata"][i], Core.Float64(testing_data["Xdata"][i][j]));
                            end
                            # Base.push!(testData["Xdata"], testData_Xdata_i);
                            # testData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Xdata"][i], Core.String) || Base.typeof(testing_data["Xdata"][i]) <: Core.Float64 || Base.typeof(testing_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # Base.push!(testData["Xdata"], Core.Float64(testing_data["Xdata"][i]));
                            testData["Xdata"][i] = Core.Float64(testing_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(testing_data, "Ydata")
            if (Base.typeof(testing_data["Ydata"]) <: Core.Array || Base.typeof(testing_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Ydata"])
                    if (Base.typeof(testing_data["Ydata"][i]) <: Core.Array || Base.typeof(testing_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # testData_Ydata_i = Core.Array{Core.Float64, 1}();
                            testData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"][i])));
                            for j = 1:Base.length(testing_data["Ydata"][i])
                                # Base.push!(testData_Ydata_i, Core.Float64(testing_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Ydata"][i][j] = Core.Float64(testing_data["Ydata"][i][j]);
                                # Base.push!(testData["Ydata"][i], Core.Float64(testing_data["Ydata"][i][j]));
                            end
                            # Base.push!(testData["Ydata"], testData_Ydata_i);
                            # testData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Ydata"][i], Core.String) || Base.typeof(testing_data["Ydata"][i]) <: Core.Float64 || Base.typeof(testing_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # Base.push!(testData["Ydata"], Core.Float64(testing_data["Ydata"][i]));
                            testData["Ydata"][i] = Core.Float64(testing_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
        testing_data = testData;

        if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
            for i = 1:Base.length(testing_data["Xdata"])
                yv = P4*((testing_data["Xdata"][i])^0) + P3*((testing_data["Xdata"][i])^1) + P2*((testing_data["Xdata"][i])^2) + P1*((testing_data["Xdata"][i])^3);  # y = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3
                Base.push!(testYvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
            end
            testData["test-Yfit"] = testYvals;

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if Core.Int64(Base.length(weight)) === Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    yvsd = (P4 - sdP4)*((testing_data["Xdata"][i])^0) + (P3 - sdP3)*((testing_data["Xdata"][i])^1) + (P2 - sdP2)*((testing_data["Xdata"][i])^2) + (P1 - sdP1)*((testing_data["Xdata"][i])^3);  # y = (P4 - sdP4)·x^0 + (P3 - sdP3)·x^1 + (P2 - sdP2)·x^2 + (P1 - sdP1)·x^3
                    yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

                    yvsd = (P4 + sdP4)*((testing_data["Xdata"][i])^0) + (P3 + sdP3)*((testing_data["Xdata"][i])^1) + (P2 + sdP2)*((testing_data["Xdata"][i])^2) + (P1 + sdP1)*((testing_data["Xdata"][i])^3);  # y = (P4 + sdP4)·x^0 + (P3 + sdP3)·x^1 + (P2 + sdP2)·x^2 + (P1 + sdP1)·x^3
                    yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyUpper, yvUpper);
                end
            end
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower;
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper;

            # 計算測試集數據的擬合殘差;
            # testResidual = Core.Array{Core.Float64, 1}();  # 擬合殘差向量;
            testResidual = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # 擬合殘差向量;
            for i = 1:Base.length(testing_data["Ydata"])
                # resi = Core.Float64(Core.Float64(testYdataMean[i]) - Core.Float64(testYvals[i]));
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    testResidual_1D = Core.Array{Core.Float64, 1}();
                    for j = 1:Base.length(testing_data["Ydata"][i])
                        resi = Core.Float64(Core.Float64(testing_data["Ydata"][i][j]) - Core.Float64(testYvals[i]));
                        Base.push!(testResidual_1D, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
                    end
                    Base.push!(testResidual, testResidual_1D);
                else
                    resi = Core.Float64(Core.Float64(testing_data["Ydata"][i]) - Core.Float64(testYvals[i]));
                    Base.push!(testResidual, [resi]);
                end
            end
            testData["test-Residual"] = testResidual;

        elseif (!Base.haskey(testing_data, "Xdata") || Base.length(testing_data["Xdata"]) <= 0) && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 定義待求根的一元方程模型;
            # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
            # 參數 P1 為自變量 3 次項系數（x^3）;
            # 參數 P2 為自變量 2 次項系數（x^2）;
            # 參數 P3 為自變量 1 次項系數（x^1）;
            # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

            # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
            # Roots.find_zero(f_fit_model, (1.0, 2.0), Roots.Bisection());

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = Core.Array{Core.Float64, 1}();  # 應變量 X 的擬合值;
            # 求解 y 的 1·SD 值的根;
            testXdataSTD = Core.Array{Core.Float64, 1}();
            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            for i = 1:Base.length(testYdataMean)

                # 求解 y 值的根;
                # 定義待求根的一元方程模型;
                # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                f1_f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3) - testYdataMean[i];
                # 參數 P1 為自變量 3 次項系數（x^3）;
                # 參數 P2 為自變量 2 次項系數（x^2）;
                # 參數 P3 為自變量 1 次項系數（x^1）;
                # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                # 計算二分法求根的含根區間（迭代初值）;
                X_lower = -Base.Inf;
                X_upper = +Base.Inf;
                if Core.Int64(Base.length(weight)) === Core.Int64(0)
                    if testYdataMean[i] < Base.findmin(YdataMean)[1]
                    # if testYdataMean[i] < YdataMean[1]
                        # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = Base.findmin(Xdata)[1];
                        # X_upper = Xdata[1];
                    end
                    if testYdataMean[i] > Base.findmax(YdataMean)[1]
                    # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                        # X_lower = Xdata[Base.length(Xdata)];
                        X_lower = Base.findmax(Xdata)[1];
                        # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    end
                    if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                    # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                        for j = 1:Base.length(YdataMean)
                            # if Core.Int64(j) === Core.Int64(i)
                            # end
                            # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                            # end
                            if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                X_lower = Xdata[j] * Core.Float64(0.99);
                                X_upper = Xdata[j] * Core.Float64(1.01);
                                break;
                            end
                            if testYdataMean[i] > YdataMean[j]
                                X_lower = Xdata[j];
                            end
                            if testYdataMean[i] < YdataMean[j]
                                X_upper = Xdata[j];
                                break;
                            end
                        end
                    end
                else
                    if testYdataMean[i] < Base.findmin(YdataMean)[1]
                    # if testYdataMean[i] < YdataMean[1]
                        # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = (Base.findmin(Xdata)[1] * Base.findmax(weight)[1]);
                        # X_upper = (Xdata[1] * weight[1]);
                    end
                    if testYdataMean[i] > Base.findmax(YdataMean)[1]
                    # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                        # X_lower = (Xdata[Base.length(Xdata)] * weight[Base.length(weight)]);
                        X_lower = (Base.findmax(Xdata)[1] * Base.findmin(weight)[1]);
                        # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    end
                    if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                    # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                        for j = 1:Base.length(YdataMean)
                            # if Core.Int64(j) === Core.Int64(i)
                            # end
                            # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                            # end
                            if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                X_lower = (Xdata[j] * weight[j]) * Core.Float64(0.99);
                                X_upper = (Xdata[j] * weight[j]) * Core.Float64(1.01);
                                break;
                            end
                            if testYdataMean[i] > YdataMean[j]
                                X_lower = (Xdata[j] * weight[j]);
                            end
                            if testYdataMean[i] < YdataMean[j]
                                X_upper = (Xdata[j] * weight[j]);
                                break;
                            end
                        end
                    end
                end
                # println(X_lower);
                # println(X_upper);

                # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
                # Roots.find_zero(f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000, xatol=0.0, xrtol=0.0, atol=0.0, rtol=0.0, verbose=true);
                # xv = Roots.find_zero(f1_f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000);
                xv = Roots.find_zero(f1_f_fit_model, X_upper, Roots.Order1());

                Base.push!(testXvals, Core.Float64(xv));  # 使用 push! 函數在數組末尾追加推入新元;

                # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲方程擬合（Curve Fitting）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
                # 求解 y 的 1·SD 值的根;
                # 定義待求根的一元方程模型;
                # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                f2_f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3) - (testYdataMean[i] + testYdataSTD[i]);
                # 參數 P1 為自變量 3 次項系數（x^3）;
                # 參數 P2 為自變量 2 次項系數（x^2）;
                # 參數 P3 為自變量 1 次項系數（x^1）;
                # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                # 計算二分法求根的含根區間（迭代初值）;
                X_lower = -Base.Inf;
                X_upper = +Base.Inf;
                if Core.Int64(Base.length(weight)) === Core.Int64(0)
                    if (testYdataMean[i] + testYdataSTD[i]) < Base.findmin(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) < YdataMean[1]
                        # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = Base.findmin(Xdata)[1];
                        # X_upper = Xdata[1];
                    end
                    if (testYdataMean[i] + testYdataSTD[i]) > Base.findmax(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) > YdataMean[Base.length(YdataMean)]
                        # X_lower = Xdata[Base.length(Xdata)];
                        X_lower = Base.findmax(Xdata)[1];
                        # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    end
                    if (testYdataMean[i] + testYdataSTD[i]) >= Base.findmin(YdataMean)[1] && (testYdataMean[i] + testYdataSTD[i]) <= Base.findmax(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) >= YdataMean[1] && (testYdataMean[i] + testYdataSTD[i]) <= YdataMean[Base.length(YdataMean)]
                        for j = 1:Base.length(YdataMean)
                            # if Core.Int64(j) === Core.Int64(i)
                            # end
                            # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                            # end
                            if Core.Float64((testYdataMean[i] + testYdataSTD[i])) === Core.Float64(YdataMean[j])
                                X_lower = Xdata[j] * Core.Float64(0.99);
                                X_upper = Xdata[j] * Core.Float64(1.01);
                                break;
                            end
                            if (testYdataMean[i] + testYdataSTD[i]) > YdataMean[j]
                                X_lower = Xdata[j];
                            end
                            if (testYdataMean[i] + testYdataSTD[i]) < YdataMean[j]
                                X_upper = Xdata[j];
                                break;
                            end
                        end
                    end
                else
                    if (testYdataMean[i] + testYdataSTD[i]) < Base.findmin(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) < YdataMean[1]
                        # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        X_upper = (Base.findmin(Xdata)[1] * Base.findmax(weight)[1]);
                        # X_upper = (Xdata[1] * weight[1]);
                    end
                    if (testYdataMean[i] + testYdataSTD[i]) > Base.findmax(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) > YdataMean[Base.length(YdataMean)]
                        # X_lower = (Xdata[Base.length(Xdata)] * weight[Base.length(weight)]);
                        X_lower = (Base.findmax(Xdata)[1] * Base.findmin(weight)[1]);
                        # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                    end
                    if (testYdataMean[i] + testYdataSTD[i]) >= Base.findmin(YdataMean)[1] && (testYdataMean[i] + testYdataSTD[i]) <= Base.findmax(YdataMean)[1]
                    # if (testYdataMean[i] + testYdataSTD[i]) >= YdataMean[1] && (testYdataMean[i] + testYdataSTD[i]) <= YdataMean[Base.length(YdataMean)]
                        for j = 1:Base.length(YdataMean)
                            # if Core.Int64(j) === Core.Int64(i)
                            # end
                            # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                            # end
                            if Core.Float64((testYdataMean[i] + testYdataSTD[i])) === Core.Float64(YdataMean[j])
                                X_lower = (Xdata[j] * weight[j]) * Core.Float64(0.99);
                                X_upper = (Xdata[j] * weight[j]) * Core.Float64(1.01);
                                break;
                            end
                            if (testYdataMean[i] + testYdataSTD[i]) > YdataMean[j]
                                X_lower = (Xdata[j] * weight[j]);
                            end
                            if (testYdataMean[i] + testYdataSTD[i]) < YdataMean[j]
                                X_upper = (Xdata[j] * weight[j]);
                                break;
                            end
                        end
                    end
                end
                # println(X_lower);
                # println(X_upper);

                # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
                # Roots.find_zero(f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000, xatol=0.0, xrtol=0.0, atol=0.0, rtol=0.0, verbose=true);
                # xv_add_1_SD = Roots.find_zero(f2_f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000);
                xv_add_1_SD = Roots.find_zero(f2_f_fit_model, X_upper, Roots.Order1(); maxiters=10000);
                xv_1_SD = Base.abs(Core.Float64(xv) - Core.Float64(xv_add_1_SD));

                Base.push!(testXdataSTD, Core.Float64(xv_1_SD));  # 使用 push! 函數在數組末尾追加推入新元;

                # 通過方程擬合算法（Curve Fitting Algorithm）的標準差（Standard Deviation）（擬合獲得方程參數的標準差），轉換爲擬合（Curve Fitting）之後的 X 值的擬合算法（Curve Fitting Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲擬合（Curve Fitting）之後的 X 值的總標準差（Standard Deviation）;
                # 計算 x 擬合值（Xfit）的置信限（Uncertainty）;
                if Core.Int64(Base.length(weight)) === Core.Int64(0)

                    # 求解 Yfit - 1·SD 值的根;
                    # 定義待求根的一元方程模型;
                    # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                    f3_f_fit_model(x) = (P4 - sdP4)*(x^0) + (P3 - sdP3)*(x^1) + (P2 - sdP2)*(x^2) + (P1 - sdP1)*(x^3) - testYdataMean[i];
                    # 參數 P1 為自變量 3 次項系數（x^3）;
                    # 參數 P2 為自變量 2 次項系數（x^2）;
                    # 參數 P3 為自變量 1 次項系數（x^1）;
                    # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                    # 計算二分法求根的含根區間（迭代初值）;
                    X_lower = -Base.Inf;
                    X_upper = +Base.Inf;
                    if Core.Int64(Base.length(weight)) === Core.Int64(0)
                        if testYdataMean[i] < Base.findmin(YdataMean)[1]
                        # if testYdataMean[i] < YdataMean[1]
                            # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = Base.findmin(Xdata)[1];
                            # X_upper = Xdata[1];
                        end
                        if testYdataMean[i] > Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                            # X_lower = Xdata[Base.length(Xdata)];
                            X_lower = Base.findmax(Xdata)[1];
                            # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        end
                        if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                            for j = 1:Base.length(YdataMean)
                                # if Core.Int64(j) === Core.Int64(i)
                                # end
                                # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                                # end
                                if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                    X_lower = Xdata[j] * Core.Float64(0.99);
                                    X_upper = Xdata[j] * Core.Float64(1.01);
                                    break;
                                end
                                if testYdataMean[i] > YdataMean[j]
                                    X_lower = Xdata[j];
                                end
                                if testYdataMean[i] < YdataMean[j]
                                    X_upper = Xdata[j];
                                    break;
                                end
                            end
                        end
                    else
                        if testYdataMean[i] < Base.findmin(YdataMean)[1]
                        # if testYdataMean[i] < YdataMean[1]
                            # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = (Base.findmin(Xdata)[1] * Base.findmax(weight)[1]);
                            # X_upper = (Xdata[1] * weight[1]);
                        end
                        if testYdataMean[i] > Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                            # X_lower = (Xdata[Base.length(Xdata)] * weight[Base.length(Xdata)]);
                            X_lower = (Base.findmax(Xdata)[1] * Base.findmin(weight)[1]);
                            # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        end
                        if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                            for j = 1:Base.length(YdataMean)
                                # if Core.Int64(j) === Core.Int64(i)
                                # end
                                # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                                # end
                                if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                    X_lower = (Xdata[j] * weight[j]) * Core.Float64(0.99);
                                    X_upper = (Xdata[j] * weight[j]) * Core.Float64(1.01);
                                    break;
                                end
                                if testYdataMean[i] > YdataMean[j]
                                    X_lower = (Xdata[j] * weight[j]);
                                end
                                if testYdataMean[i] < YdataMean[j]
                                    X_upper = (Xdata[j] * weight[j]);
                                    break;
                                end
                            end
                        end
                    end
                    # println(X_lower);
                    # println(X_upper);

                    # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
                    # Roots.find_zero(f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000, xatol=0.0, xrtol=0.0, atol=0.0, rtol=0.0, verbose=true);
                    # xvsd = Roots.find_zero(f3_f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000);
                    xvsd = Roots.find_zero(f3_f_fit_model, X_upper, Roots.Order1(); maxiters=10000);

                    # 求解 Xfit-Uncertainty-Lower 的值;
                    xvLower = Core.Float64(xv) - Base.sqrt((Core.Float64(xv) - Core.Float64(xvsd))^2 + Core.Float64(xv_1_SD)^2);
                    Base.push!(testXvalsUncertaintyLower, Core.Float64(xvLower));  # 使用 push! 函數在數組末尾追加推入新元;

                    # 求解 Yfit + 1·SD 值的根;
                    # 定義待求根的一元方程模型;
                    # f_fit_model(x) = P4*(x^0) + P3*(x^1) + P2*(x^2) + P1*(x^3);  # 自定義的 3 階多項式（Polynomial(Cubic)）模型 f(x, P) = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3 方程;
                    f4_f_fit_model(x) = (P4 + sdP4)*(x^0) + (P3 + sdP3)*(x^1) + (P2 + sdP2)*(x^2) + (P1 + sdP1)*(x^3) - testYdataMean[i];
                    # 參數 P1 為自變量 3 次項系數（x^3）;
                    # 參數 P2 為自變量 2 次項系數（x^2）;
                    # 參數 P3 為自變量 1 次項系數（x^1）;
                    # 參數 P4 為自變量常數項（0 次項）系數（x^0）;

                    # 計算二分法求根的含根區間（迭代初值）;
                    X_lower = -Base.Inf;
                    X_upper = +Base.Inf;
                    if Core.Int64(Base.length(weight)) === Core.Int64(0)
                        if testYdataMean[i] < Base.findmin(YdataMean)[1]
                        # if testYdataMean[i] < YdataMean[1]
                            # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = Base.findmin(Xdata)[1];
                            # X_upper = Xdata[1];
                        end
                        if testYdataMean[i] > Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                            # X_lower = Xdata[Base.length(Xdata)];
                            X_lower = Base.findmax(Xdata)[1];
                            # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        end
                        if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                            for j = 1:Base.length(YdataMean)
                                # if Core.Int64(j) === Core.Int64(i)
                                # end
                                # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                                # end
                                if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                    X_lower = Xdata[j] * Core.Float64(0.99);
                                    X_upper = Xdata[j] * Core.Float64(1.01);
                                    break;
                                end
                                if testYdataMean[i] > YdataMean[j]
                                    X_lower = Xdata[j];
                                end
                                if testYdataMean[i] < YdataMean[j]
                                    X_upper = Xdata[j];
                                    break;
                                end
                            end
                        end
                    else
                        if testYdataMean[i] < Base.findmin(YdataMean)[1]
                        # if testYdataMean[i] < YdataMean[1]
                            # X_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            X_upper = (Base.findmin(Xdata)[1] * Base.findmax(weight)[1]);
                            # X_upper = (Xdata[1] * weight[1]);
                        end
                        if testYdataMean[i] > Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] > YdataMean[Base.length(YdataMean)]
                            # X_lower = (Xdata[Base.length(Xdata)] * weight[Base.length(weight)]);
                            X_lower = (Base.findmax(Xdata)[1] * Base.findmin(weight)[1]);
                            # X_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        end
                        if testYdataMean[i] >= Base.findmin(YdataMean)[1] && testYdataMean[i] <= Base.findmax(YdataMean)[1]
                        # if testYdataMean[i] >= YdataMean[1] && testYdataMean[i] <= YdataMean[Base.length(YdataMean)]
                            for j = 1:Base.length(YdataMean)
                                # if Core.Int64(j) === Core.Int64(i)
                                # end
                                # if Core.Int64(j) === Core.Int64(Base.length(YdataMean))
                                # end
                                if Core.Float64(testYdataMean[i]) === Core.Float64(YdataMean[j])
                                    X_lower = (Xdata[j] * weight[j]) * Core.Float64(0.99);
                                    X_upper = (Xdata[j] * weight[j]) * Core.Float64(1.01);
                                    break;
                                end
                                if testYdataMean[i] > YdataMean[j]
                                    X_lower = (Xdata[j] * weight[j]);
                                end
                                if testYdataMean[i] < YdataMean[j]
                                    X_upper = (Xdata[j] * weight[j]);
                                    break;
                                end
                            end
                        end
                    end
                    # println(X_lower);
                    # println(X_upper);

                    # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
                    # Roots.find_zero(f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000, xatol=0.0, xrtol=0.0, atol=0.0, rtol=0.0, verbose=true);
                    # xvsd = Roots.find_zero(f4_f_fit_model, (X_lower, X_upper), Roots.Bisection(); maxiters=10000);
                    xvsd = Roots.find_zero(f4_f_fit_model, X_upper, Roots.Order1(); maxiters=10000);

                    # 求解 Xfit-Uncertainty-Upper 的值;
                    xvUpper = Core.Float64(xv) + Base.sqrt((Core.Float64(xv) - Core.Float64(xvsd))^2 + Core.Float64(xv_1_SD)^2);
                    Base.push!(testXvalsUncertaintyUpper, Core.Float64(xvUpper));
                end
            end
            testData["test-Xvals"] = testXvals;
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower;
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper;

        elseif Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && (!Base.haskey(testing_data, "Ydata") || Base.length(testing_data["Ydata"]) <= 0)

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
            for i = 1:Base.length(testing_data["Xdata"])
                yv = P4*((testing_data["Xdata"][i])^0) + P3*((testing_data["Xdata"][i])^1) + P2*((testing_data["Xdata"][i])^2) + P1*((testing_data["Xdata"][i])^3);  # y = P4·x^0 + P3·x^1 + P2·x^2 + P1·x^3
                Base.push!(testYvals, yv);  # 使用 push! 函數在數組末尾追加推入新元;
            end
            testData["test-Yfit"] = testYvals;

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            if Core.Int64(Base.length(weight)) === Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    yvsd = (P4 - sdP4)*((testing_data["Xdata"][i])^0) + (P3 - sdP3)*((testing_data["Xdata"][i])^1) + (P2 - sdP2)*((testing_data["Xdata"][i])^2) + (P1 - sdP1)*((testing_data["Xdata"][i])^3);  # y = (P4 - sdP4)·x^0 + (P3 - sdP3)·x^1 + (P2 - sdP2)·x^2 + (P1 - sdP1)·x^3
                    yvLower = Core.Float64(yvsd);
                    # yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2);
                    # yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

                    yvsd = (P4 + sdP4)*((testing_data["Xdata"][i])^0) + (P3 + sdP3)*((testing_data["Xdata"][i])^1) + (P2 + sdP2)*((testing_data["Xdata"][i])^2) + (P1 + sdP1)*((testing_data["Xdata"][i])^3);  # y = (P4 + sdP4)·x^0 + (P3 + sdP3)·x^1 + (P2 + sdP2)·x^2 + (P1 + sdP1)·x^3
                    yvUpper = Core.Float64(yvsd);
                    # yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2);
                    # yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2 + testYdataSTD[i]^2);
                    Base.push!(testYvalsUncertaintyUpper, yvUpper);
                end
            end
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower;
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper;

        else
        end
    end

    # http://gadflyjl.org/stable/gallery/geometries/#[Geom.segment](@ref)
    # 繪圖;
    img1 = Core.nothing;
    img2 = Core.nothing;
    if true

        set_default_plot_size(21cm, 21cm);  # 設定畫布規格;
    
        # 繪製擬合散點圖;
        # img1 = Core.nothing;
        if Core.Int64(Base.length(weight)) === Core.Int64(0)
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],  # :dot
                    default_color="red",  # gray
                    alphas=[1],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # 繪製置信區間填充圖;
            ribbonline1 = Gadfly.layer(
                x=Xdata,
                # y=Yvals,
                ymin=YvalsUncertaintyLower,
                ymax=YvalsUncertaintyUpper,
                # Geom.smooth,
                Geom.ribbon(fill=true),
                Theme(
                    # point_size=5pt,
                    line_width=0.1pt,
                    line_style=[:dot],  # :solid
                    default_color="gray",  # grey
                    alphas=[0.5],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # smoothline2 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyLower,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            # smoothline3 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyUpper,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # smoothline2,
                # smoothline3,
                ribbonline1,
                Guide.title("3th order Polynomial ( Cubic ) model"),
                Guide.xlabel("Independent Variable ( x )"),
                Guide.ylabel("Dependent Variable ( y )"),
                Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"])
            );
        elseif Base.length(weight) > 0
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],
                    default_color="red",
                    alphas=[1],
                    # default_color="gray"  # grey
                )  # color=[colorant"red"],
            );
            # # 繪製置信區間填充圖;
            # ribbonline1 = Gadfly.layer(
            #     x=Xdata,
            #     # y=Yvals,
            #     ymin=YvalsUncertaintyLower,
            #     ymax=YvalsUncertaintyUpper,
            #     # Geom.smooth,
            #     Geom.ribbon(fill=true),
            #     Theme(
            #         # point_size=5pt,
            #         line_width=0.1pt,
            #         line_style=[:dot],  # :solid
            #         default_color="gray",  # grey
            #         alphas=[0.5],
            #         # lowlight_color=c->"gray"
            #     )  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # ribbonline1,
                Guide.title("3th order Polynomial ( Cubic ) model"),
                Guide.xlabel("Independent Variable ( x )"),
                Guide.ylabel("Dependent Variable ( y )"),
                Guide.manual_discrete_key("", ["observation values", "polyfit values"]; color=["blue", "red"])
            );
        end
        # Gadfly.draw(
        #     Gadfly.SVG(
        #         "./Curvefit.svg",
        #         21cm,
        #         21cm
        #     ),  # 保存爲 .svg 格式圖片;
        #     # Gadfly.PDF(
        #     #     "Curvefit.pdf",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .pdf 格式圖片;
        #     # Gadfly.PNG(
        #     #     "Curvefit.png",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .png 格式圖片;
        #     img1
        # );
    
        # 繪製擬合殘差圖;
        points2 = Gadfly.layer(
            x=Xdata,
            y=Residual,
            Geom.point,
            # Geom.line,
            # Geom.abline,
            # Geom.smooth(method=:loess, smoothing=0.9),
            color=[colorant"blue"],
            Theme(line_width=1pt)
        );
        line2 = Gadfly.layer(
            x=[Base.findmin(Xdata)[1], Base.findmax(Xdata)[1]],
            y=[Statistics.mean(Residual), Statistics.mean(Residual)],
            Geom.line,
            Theme(
                # point_size=5pt,
                line_width=1.0pt,
                line_style=[:solid],
                default_color="red",
                alphas=[1]
            )  # color=[colorant"red"],
        );
        img2 = Gadfly.plot(
            points2,
            line2,
            # Guide.title("Residual ~ 3th order Polynomial ( Cubic ) model"),
            Guide.xlabel("Independent Variable ( x )"),
            Guide.ylabel("Residual"),
            # Guide.manual_discrete_key("", ["Residual", "Residual mean"]; color=["blue", "red"])
        );
        # Gadfly.draw(
        #     Gadfly.SVG(
        #         "./Residual.svg",
        #         21cm,
        #         21cm
        #     ),  # 保存爲 .svg 格式圖片;
        #     # Gadfly.PDF(
        #     #     "Residual.pdf",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .pdf 格式圖片;
        #     # Gadfly.PNG(
        #     #     "Residual.png",
        #     #     21cm,
        #     #     21cm
        #     # ),  # 保存爲 .png 格式圖片;
        #     img2
        # );
    
        # # Gadfly.hstack(img1, img2);
        # # Gadfly.title(Gadfly.hstack(img1, img2), "3th order Polynomial ( Cubic ) model weighted least square method curve fit");
        # Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2));
        # Gadfly.title(Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2)), "3th order Polynomial ( Cubic ) model weighted least square method curve fit");
    end

    resultDict = Base.Dict{Core.String, Core.Any}();
    if Base.length(weight) > 0
        resultDict["Coefficient"] = LsqFit.coef(fit);
        resultDict["Residual"] = fit.resid;
        resultDict["Yfit"] = Yvals;
        resultDict["Coefficient-StandardDeviation"] = [];
        resultDict["Coefficient-Confidence-Lower-95%"] = [];
        resultDict["Coefficient-Confidence-Upper-95%"] = [];
        resultDict["Yfit-Uncertainty-Lower"] = [];  # 擬合的應變量 Yvals 誤差下限;
        resultDict["Yfit-Uncertainty-Upper"] = [];  # 擬合的應變量 Yvals 誤差上限;
        resultDict["testData"] = testData;  # 傳入測試數據集的計算結果;
        resultDict["Curve-fit-image"] = img1;  # 擬合曲綫繪圖;
        resultDict["Residual-image"] = img2;  # 擬合殘差繪圖;
    elseif Core.Int64(Base.length(weight)) === Core.Int64(0)
        resultDict["Coefficient"] = LsqFit.coef(fit);
        resultDict["Residual"] = fit.resid;
        resultDict["Yfit"] = Yvals;
        resultDict["Coefficient-StandardDeviation"] = margin_of_error;  # 擬合得到的參數解的標準差;
        resultDict["Coefficient-Confidence-Lower-95%"] = [confidence_inter[1][1], confidence_inter[2][1], confidence_inter[3][1], confidence_inter[4][1]];
        resultDict["Coefficient-Confidence-Upper-95%"] = [confidence_inter[1][2], confidence_inter[2][2], confidence_inter[3][2], confidence_inter[4][2]];
        resultDict["Yfit-Uncertainty-Lower"] = YvalsUncertaintyLower;  # 擬合的應變量 Yvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["Yfit-Uncertainty-Upper"] = YvalsUncertaintyUpper;  # 擬合的應變量 Yvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
        resultDict["testData"] = testData;  # 傳入測試數據集的計算結果;
        resultDict["Curve-fit-image"] = img1;  # 擬合曲綫繪圖;
        resultDict["Residual-image"] = img2;  # 擬合殘差繪圖;
    end
    # println(resultDict);

    return resultDict;
end


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
# # training_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => YdataMean);

# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata[begin+1:end-1], "Ydata" => Ydata[begin+1:end-1]);
# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata, "Ydata" => Ydata);
# testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => YdataMean);
# # testing_data = Base.Dict{Core.String, Core.Any}("Ydata" => Ydata);
# # testing_data = Base.Dict{Core.String, Core.Any}("Xdata" => Xdata);
# # testing_data = training_data;

# Pdata_0 = [
#     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])),
#     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])),
#     Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])),
#     Core.Float64(Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^1) for i in 1:Base.length(YdataMean)])) * Xdata[i]^1)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^2) for i in 1:Base.length(YdataMean)])) * Xdata[i]^2)) for i in 1:Base.length(YdataMean)]) + Statistics.mean([Core.Float64(Core.Float64(YdataMean[i] % Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) * Core.Float64(Core.Float64(Statistics.mean([(YdataMean[i]/Xdata[i]^3) for i in 1:Base.length(YdataMean)])) * Xdata[i]^3)) for i in 1:Base.length(YdataMean)]))
# ];

# Plower = [
#     -Base.Inf,
#     -Base.Inf,
#     -Base.Inf,
#     -Base.Inf
#     # -Base.Inf
# ];
# Pupper = [
#     +Base.Inf,
#     +Base.Inf,
#     +Base.Inf,
#     +Base.Inf
#     # +Base.Inf
# ];

# weight = Core.Array{Core.Float64, 1}();
# target = 2;  # 擬合模型之後的目標預測點，比如，設定爲 3 表示擬合出模型參數值之後，想要使用此模型預測 Xdata 中第 3 個位置附近的點的 Yvals 的直;
# af = Core.Float64(0.9);  # 衰減因子 attenuation factor ，即權重值衰減的速率，af 值愈小，權重值衰減的愈快;
# for i = 1:Base.length(YdataMean)
#     wei = Base.exp((YdataMean[i] / YdataMean[target] - 1)^2 / ((-2) * af^2));
#     Base.push!(weight, wei);  # 使用 push! 函數在數組末尾追加推入新元素;
# end
# # println(weight);

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
# # Gadfly.title(Gadfly.hstack(result["Curve-fit-image"], result["Residual-image"]), "3th order Polynomial ( Cubic ) model weighted least square method curve fit");
# Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"]));
# Gadfly.title(Gadfly.vstack(Gadfly.hstack(result["Curve-fit-image"]), Gadfly.hstack(result["Residual-image"])), "3th order Polynomial ( Cubic ) model weighted least square method curve fit");
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



# 插值（Interpolations）;

# using Interpolations;  # 導入第三方擴展包「Interpolations」，用於插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「Interpolations」：julia> using Pkg; Pkg.add("Interpolations") 成功之後才能使用;
# https://juliamath.github.io/Interpolations.jl/stable/
# https://github.com/JuliaMath/Interpolations.jl/
# using DataInterpolations;  # 導入第三方擴展包「DataInterpolations」，用於一維（1 Dimension）插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「DataInterpolations」：julia> using Pkg; Pkg.add("DataInterpolations") 成功之後才能使用;
# https://github.com/SciML/DataInterpolations.jl
# using Roots;  # 導入第三方擴展包「Roots」，用於求解任意形式一元非缐性方程，需要在控制臺先安裝第三方擴展包「Roots」：julia> using Pkg; Pkg.add("Roots") 成功之後才能使用;
# https://juliamath.github.io/Roots.jl/stable
# https://github.com/JuliaMath/Roots.jl
function MathInterpolation(
    training_data::Base.Dict{Core.String, Core.Any};
    testing_data::Base.Dict{Core.String, Core.Any} = training_data,
    Interpolation_Method::Core.String = "BSpline(Cubic)",  # "Constant(Previous)", "Constant(Next)", "Linear", "BSpline(Linear)", "BSpline(Quadratic)", "BSpline(Cubic)", "Polynomial(Linear)", "Polynomial(Quadratic)", "Lagrange", "SteffenMonotonicInterpolation", "Spline(Akima)", "B-Splines", "B-Splines(Approx)";
    λ = Core.UInt8(0),  # λ::Core.UInt8 = Core.UInt8(0),  # 擴展包 Interpolations 中 interpolate() 函數的參數，is non-negative. If its value is zero, it falls back to non-regularized interpolation;
    k = Core.UInt8(2),  # k::Core.UInt8 = Core.UInt8(2),  # 擴展包 Interpolations 中 interpolate() 函數的參數，corresponds to the derivative to penalize. In the limit λ->∞, the interpolation function is a polynomial of order k-1. A value of 2 is the most common;
    d = Core.UInt8(Base.length(training_data["Ydata"]) - 1),  # d::Core.UInt8 = Core.UInt8(Base.length(training_data["Ydata"]) - 1),  # 擴展包 DataInterpolations 中 BSplineInterpolation() 函數的參數，表示傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
    h = Core.UInt8(Base.length(training_data["Ydata"]) - 1)  # h::Core.UInt8 = Core.UInt8(Base.length(training_data["Ydata"]) - 1)  # 擴展包 DataInterpolations 中 BSplineApprox() 函數的參數，表示定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
) ::Base.Dict{Core.String, Core.Any}

    trainingData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(training_data, Base.Dict) && Core.Int64(Base.length(training_data)) > Core.Int64(0)
        if Base.haskey(training_data, "Xdata")
            if (Base.typeof(training_data["Xdata"]) <: Core.Array || Base.typeof(training_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Xdata"])
                    if (Base.typeof(training_data["Xdata"][i]) <: Core.Array || Base.typeof(training_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # trainingData_Xdata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"][i])));
                            for j = 1:Base.length(training_data["Xdata"][i])
                                # Base.push!(trainingData_Xdata_i, Core.Float64(training_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Xdata"][i][j] = Core.Float64(training_data["Xdata"][i][j]);
                                # Base.push!(trainingData["Xdata"][i], Core.Float64(training_data["Xdata"][i][j]));
                            end
                            # Base.push!(trainingData["Xdata"], trainingData_Xdata_i);
                            # trainingData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Xdata"][i], Core.String) || Base.typeof(training_data["Xdata"][i]) <: Core.Float64 || Base.typeof(training_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Xdata"))
                            trainingData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Xdata"])));
                            # trainingData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Xdata")
                            # Base.push!(trainingData["Xdata"], Core.Float64(training_data["Xdata"][i]));
                            trainingData["Xdata"][i] = Core.Float64(training_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(training_data, "Ydata")
            if (Base.typeof(training_data["Ydata"]) <: Core.Array || Base.typeof(training_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(training_data["Ydata"])
                    if (Base.typeof(training_data["Ydata"][i]) <: Core.Array || Base.typeof(training_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(training_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # trainingData_Ydata_i = Core.Array{Core.Float64, 1}();
                            trainingData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"][i])));
                            for j = 1:Base.length(training_data["Ydata"][i])
                                # Base.push!(trainingData_Ydata_i, Core.Float64(training_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                trainingData["Ydata"][i][j] = Core.Float64(training_data["Ydata"][i][j]);
                                # Base.push!(trainingData["Ydata"][i], Core.Float64(training_data["Ydata"][i][j]));
                            end
                            # Base.push!(trainingData["Ydata"], trainingData_Ydata_i);
                            # trainingData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(training_data["Ydata"][i], Core.String) || Base.typeof(training_data["Ydata"][i]) <: Core.Float64 || Base.typeof(training_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(trainingData, Base.Dict) && ( ! Base.haskey(trainingData, "Ydata"))
                            trainingData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(training_data["Ydata"])));
                            # trainingData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(trainingData, Base.Dict) && Base.haskey(trainingData, "Ydata")
                            # Base.push!(trainingData["Ydata"], Core.Float64(training_data["Ydata"][i]));
                            trainingData["Ydata"][i] = Core.Float64(training_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
    end
    # Xdata::Core.Array{Core.Float64, 1} = trainingData["Xdata"];
    # Ydata::Core.Array{Core.Array{Core.Float64, 1}, 1} = trainingData["Ydata"];
    Xdata = trainingData["Xdata"];
    # println(Xdata);
    Ydata = trainingData["Ydata"];
    # println(Ydata);

    # 求 Ydata 均值向量;
    YdataMean = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            yMean = Core.Float64(Statistics.mean(Ydata[i]));
            Base.push!(YdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
        else
            yMean = Core.Float64(Ydata[i]);
            Base.push!(YdataMean, yMean);
        end
    end
    # println(YdataMean);
    # 求 Ydata 標準差向量;
    YdataSTD = Core.Array{Core.Float64, 1}();
    for i = 1:Base.length(Ydata)
        if Base.typeof(Ydata[i]) <: Core.Array
            if Core.Int64(Base.length(Ydata[i])) === Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=false));
                Base.push!(YdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
            elseif Core.Int64(Base.length(Ydata[i])) > Core.Int64(1)
                ySTD = Core.Float64(Statistics.std(Ydata[i]; corrected=true));
                Base.push!(YdataSTD, ySTD);
            end
        else
            ySTD = Core.Float64(0.0);
            Base.push!(YdataSTD, ySTD);
        end
    end
    # println(YdataSTD);

    # https://juliamath.github.io/Interpolations.jl/stable/
    # https://github.com/JuliaMath/Interpolations.jl/
    # 構造一個「插值對象」;
    # itp = interpolate((nodes1, nodes2, ...), A, interpmode, gridstyle, λ, k);
    # Interpolations.Nearest() 最近鄰插值, Interpolations.BSpline(Interpolations.Constant()) 數據區間保持常數插值（階梯狀曲缐）, Interpolations.BSpline(Interpolations.Linear()) 缐性插值, Interpolations.BSpline(Interpolations.Quadratic(extrapolation_bc=Interpolations.Line())) 二階多項式插值，參數 extrapolation_bc 表示指定的外推邊界條件（Boundary Condition）, Interpolations.BSpline(Interpolations.Cubic(extrapolation_bc=Interpolations.Line())) 三階多項式插值，參數 extrapolation_bc 表示指定的外推邊界條件（Boundary Condition）;
    # Interpolations.NoInterp() 不進行插值祇是返回請求數據點最近的可用數據點, Interpolations.Constant(Interpolations.Previous) 數據區間保持左側常數插值（階梯狀曲缐）, Interpolations.Constant(Interpolations.Next) 數據區間保持右側常數插值（階梯狀曲缐）, Interpolations.Linear() 缐性插值, Interpolations.Quadratic(extrapolation_bc=Interpolations.Line()) 二階多項式插值，參數 extrapolation_bc 表示指定的外推邊界條件（Boundary Condition）, Interpolations.Cubic(extrapolation_bc=Interpolations.Line()) 三階多項式插值，參數 extrapolation_bc 表示指定的外推邊界條件（Boundary Condition）;
    # 邊界條件（Boundary Condition）外推：Interpolations.Throw() 不允許外推, Interpolations.Flat() 爲邊緣點值的水平外推, Interpolations.Line() 爲邊緣最後兩點值的缐性外推, Interpolations.Free() 無約束外推, Interpolations.Periodic() 爲起點值的周期外推, Interpolations.Reflect() 爲邊緣點值的相反鏡像外推;
    # https://github.com/SciML/DataInterpolations.jl

    # Dependent variable = Xdata;
    # Independent variable = YdataMean;
    itp = Core.nothing;
    if Interpolation_Method === "Constant(Previous)"
        itp = Interpolations.extrapolate(Interpolations.interpolate((YdataMean,), Xdata, Interpolations.Gridded(Interpolations.Constant(Interpolations.Previous))), Interpolations.Line());
        # itp = DataInterpolations.ConstantInterpolation(Xdata, YdataMean, dir=:left, extrapolate=true);
    elseif Interpolation_Method === "Constant(Next)"
        itp = Interpolations.extrapolate(Interpolations.interpolate((YdataMean,), Xdata, Interpolations.Gridded(Interpolations.Constant(Interpolations.Next))), Interpolations.Line());
        # itp = DataInterpolations.ConstantInterpolation(Xdata, YdataMean, dir=:right, extrapolate=true);
    elseif Interpolation_Method === "Linear"
        itp = Interpolations.extrapolate(Interpolations.interpolate((YdataMean,), Xdata, Interpolations.Gridded(Interpolations.Linear())), Interpolations.Line());
        # itp = DataInterpolations.LinearInterpolation(Xdata, YdataMean, extrapolate=true);
    elseif Interpolation_Method === "BSpline(Linear)"
        itp = Interpolations.extrapolate(Interpolations.interpolate(Xdata, Interpolations.BSpline(Interpolations.Linear())), Interpolations.Line());
    elseif Interpolation_Method === "BSpline(Quadratic)"
        # itp = Interpolations.extrapolate(Interpolations.interpolate(Xdata, Interpolations.BSpline(Interpolations.Quadratic(Interpolations.Line(Interpolations.OnGrid())))), Interpolations.Line());
        itp = DataInterpolations.QuadraticSpline(Xdata, YdataMean, extrapolate=true);
    elseif Interpolation_Method === "BSpline(Cubic)"
        # itp = Interpolations.extrapolate(Interpolations.interpolate(Xdata, Interpolations.BSpline(Interpolations.Cubic(Interpolations.Line(Interpolations.OnGrid())))), Interpolations.Line());
        itp = DataInterpolations.CubicSpline(Xdata, YdataMean, extrapolate=true);
    elseif Interpolation_Method === "Polynomial(Linear)"
        # 缐性插值;
        itp = Interpolations.extrapolate(Interpolations.interpolate((YdataMean,), Xdata, Interpolations.Gridded(Interpolations.Linear())), Interpolations.Line());
    elseif Interpolation_Method === "Polynomial(Quadratic)"
        # 2 階多項式插值;
        itp = DataInterpolations.QuadraticInterpolation(Xdata, YdataMean, extrapolate=true);
    # elseif Interpolation_Method === "Polynomial(Cubic)"
    #     # 3 階多項式插值;
    elseif Interpolation_Method === "Lagrange"
        # 使用 d 階多項式擬合數據，其中 d = Base.length(YdataMean) - 1 ，擬合曲缐一階連續可微;
        itp = DataInterpolations.LagrangeInterpolation(Xdata, YdataMean, Core.UInt8(Base.length(YdataMean) - 1), extrapolate=true);
    elseif Interpolation_Method === "SteffenMonotonicInterpolation"
        itp = Interpolations.extrapolate(Interpolations.interpolate(YdataMean, Xdata, Interpolations.SteffenMonotonicInterpolation()), Interpolations.Line());
    elseif Interpolation_Method === "Spline(Akima)"
        # 阿基馬（Akima）（阿基米德）樣條（Spline）插值，提供平滑效果，計算效率高;
        itp = DataInterpolations.AkimaInterpolation(Xdata, YdataMean, extrapolate=true);
    elseif Interpolation_Method === "B-Splines"
        # 貝塞爾曲缐（B-Splines）樣條插值：BSplineInterpolation(u, t, d, pVec, knotVec) ;
        # u : Dependent variable = Xdata;
        # t : Independent variable = YdataMean;
        # 參數：d 表示，傳入 B 樣條曲缐（B-Splines）的次數;
        # 參數：pVec 表示，符號標識參數向量，可取值 pVec = :Uniform 表示參數均勻分布，取值 pVec = :ArcLen 表示由弦長法生成的參數;
        # 參數：knotVec 表示，符號標識結點向量，可取值 knotVec = :Uniform 表示均匀結點向量，取值 knotVec = :Average 表示平均間距的結點向量;
        itp = DataInterpolations.BSplineInterpolation(Xdata, YdataMean, d, :ArcLen, :Average, extrapolate=true);
    # elseif Interpolation_Method === "B-Splines(Approx)"
    #     # 平滑擬合的貝塞爾曲缐（B-Splines Approx）（近似貝塞爾曲缐）樣條插值：BSplineApprox(u, t, d, h, pVec, knotVec) ;
    #     # u : Dependent variable = Xdata;
    #     # t : Independent variable = YdataMean;
    #     # 參數：d 表示，傳入 B 樣條曲缐（B-Splines）的次數，祇能取 d < length(t) 值，可取值 d = length(t) - 1 ;
    #     # 參數：h 表示，定義控制點的數量，愈小的 h 值，意味著曲缐愈平滑，祇能取 h < length(t) 值，可取值 h = length(t) - 1 ;
    #     # 參數：pVec 表示，符號標識參數向量，可取值 pVec = :Uniform 表示參數均勻分布，取值 pVec = :ArcLen 表示由弦長法生成的參數;
    #     # 參數：knotVec 表示，符號標識結點向量，可取值 knotVec = :Uniform 表示均匀結點向量，取值 knotVec = :Average 表示平均間距的結點向量;
    #     itp = DataInterpolations.BSplineApprox(Xdata, YdataMean, d, h, :ArcLen, :Average, extrapolate=true);
    else
    end

    # testData = Base.Dict{Core.String, Core.Any}();
    # img1 = Core.nothing;
    # img2 = Core.nothing;
    resultDict = Base.Dict{Core.String, Core.Any}();
    if Base.isnothing(itp)
        println("The interpolation arguments cannot be recognized, the interpolation object cannot be established.");
        resultDict["error"] = Base.string("The interpolation arguments cannot be recognized, the interpolation object cannot be established.");
        resultDict["training_data"] = training_data;
        resultDict["Interpolation_Method"] = Interpolation_Method;
        resultDict["λ"] = λ;
        resultDict["k"] = k;
        resultDict["d"] = d;
        resultDict["h"] = h;
        # resultDict["testing_data"] = testing_data;
        # resultDict["testData"] = Base.Dict{Core.String, Core.Any}();  # 傳入測試數據集的計算結果;
        # resultDict["Curve-Interpolation-image"] = Core.nothing;  # 擬合曲綫繪圖;
        # println(resultDict);
        return resultDict;
    end

    # 計算測試集數據的内插值;
    testData = Base.Dict{Core.String, Core.Any}();
    if Base.isa(testing_data, Base.Dict) && Base.length(testing_data) > 0

        testData = testing_data;
        if Base.haskey(testing_data, "Xdata")
            if (Base.typeof(testing_data["Xdata"]) <: Core.Array || Base.typeof(testing_data["Xdata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Xdata"])
                    if (Base.typeof(testing_data["Xdata"][i]) <: Core.Array || Base.typeof(testing_data["Xdata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Xdata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # testData_Xdata_i = Core.Array{Core.Float64, 1}();
                            testData["Xdata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"][i])));
                            for j = 1:Base.length(testing_data["Xdata"][i])
                                # Base.push!(testData_Xdata_i, Core.Float64(testing_data["Xdata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Xdata"][i][j] = Core.Float64(testing_data["Xdata"][i][j]);
                                # Base.push!(testData["Xdata"][i], Core.Float64(testing_data["Xdata"][i][j]));
                            end
                            # Base.push!(testData["Xdata"], testData_Xdata_i);
                            # testData_Xdata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Xdata"][i], Core.String) || Base.typeof(testing_data["Xdata"][i]) <: Core.Float64 || Base.typeof(testing_data["Xdata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Xdata"))
                            testData["Xdata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Xdata"])));
                            # testData["Xdata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Xdata")
                            # Base.push!(testData["Xdata"], Core.Float64(testing_data["Xdata"][i]));
                            testData["Xdata"][i] = Core.Float64(testing_data["Xdata"][i]);
                        end
                    end
                end
            end
        end
        if Base.haskey(testing_data, "Ydata")
            if (Base.typeof(testing_data["Ydata"]) <: Core.Array || Base.typeof(testing_data["Ydata"]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"])) > Core.Int64(0)
                for i = 1:Base.length(testing_data["Ydata"])
                    if (Base.typeof(testing_data["Ydata"][i]) <: Core.Array || Base.typeof(testing_data["Ydata"][i]) <: Base.Vector) && Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(0)
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Array{Core.Float64, 1}, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # testData_Ydata_i = Core.Array{Core.Float64, 1}();
                            testData["Ydata"][i] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"][i])));
                            for j = 1:Base.length(testing_data["Ydata"][i])
                                # Base.push!(testData_Ydata_i, Core.Float64(testing_data["Ydata"][i][j]));  # 使用 push! 函數在數組末尾追加推入新元素;
                                testData["Ydata"][i][j] = Core.Float64(testing_data["Ydata"][i][j]);
                                # Base.push!(testData["Ydata"][i], Core.Float64(testing_data["Ydata"][i][j]));
                            end
                            # Base.push!(testData["Ydata"], testData_Ydata_i);
                            # testData_Ydata_i = Core.nothing;
                        end
                    end
                    if Base.isa(testing_data["Ydata"][i], Core.String) || Base.typeof(testing_data["Ydata"][i]) <: Core.Float64 || Base.typeof(testing_data["Ydata"][i]) <: Core.Int64
                        if Base.isa(testData, Base.Dict) && ( ! Base.haskey(testData, "Ydata"))
                            testData["Ydata"] = Core.Array{Core.Float64, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));  # Core.Array{Core.Any, 1}(Core.undef, Core.Int64(Base.length(testing_data["Ydata"])));
                            # testData["Ydata"] = Core.Array{Core.Float64, 1}();  # Core.Array{Core.Any, 1}();
                        end
                        if Base.isa(testData, Base.Dict) && Base.haskey(testData, "Ydata")
                            # Base.push!(testData["Ydata"], Core.Float64(testing_data["Ydata"][i]));
                            testData["Ydata"][i] = Core.Float64(testing_data["Ydata"][i]);
                        end
                    end
                end
            end
        end
        testing_data = testData;

        if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = Core.Array{Core.Float64, 1}();  # 應變量 X 的擬合值;
            for i = 1:Base.length(testYdataMean)
                # # xv = Core.nothing;
                # if Core.Float64(testYdataMean[i]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[i]) <= Core.Float64(Base.findmax(YdataMean)[1])
                    xv = Core.Float64(itp(testYdataMean[i]));
                    Base.push!(testXvals, xv);  # 使用 push! 函數在數組末尾追加推入新元;
                # end
                # # Base.push!(testXvals, xv);
            end
            testData["test-Xvals"] = testXvals;

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲插值（Interpolation）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
            testXdataSTD = Core.Array{Core.Float64, 1}();
            for j = 1:Base.length(testYdataSTD)
                # # xv = Core.nothing;
                # if (Core.Float64(testYdataMean[j]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[j]) <= Core.Float64(Base.findmax(YdataMean)[1])) && (Core.Float64(testYdataMean[j] + testYdataSTD[j]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[j] + testYdataSTD[j]) <= Core.Float64(Base.findmax(YdataMean)[1]))
                    xv = Base.abs(Core.Float64(itp(testYdataMean[j])) - Core.Float64(itp(testYdataMean[j] + testYdataSTD[j])));
                    Base.push!(testXdataSTD, xv);  # 使用 push! 函數在數組末尾追加推入新元;
                # end
                # # Base.push!(testXdataSTD, xv);
            end
            # 通過插值算法（Interpolation Algorithm）的標準差（Standard Deviation）（插值計算結果的不確定度），轉換爲插值（Interpolation）之後的 X 值的插值算法（Interpolation Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            # 這裏因爲插值算法（Interpolation Algorithm）的的標準差（Standard Deviation）未給出，將之視爲零（0），因此 Y 值的觀察（Observation）標準差（Standard Deviation），即是轉換爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            for i = 1:Base.length(testYdataMean)
                # xvLower = Core.nothing;
                # xvUpper = Core.nothing;
                # if !(isnothing(testXvals[i]) || isnothing(testXdataSTD[i]))
                #     xvLower = Core.Float64(testXvals[i] - testXdataSTD[i]);
                #     xvUpper = Core.Float64(testXvals[i] + testXdataSTD[i]);
                # end
                # Base.push!(testXvalsUncertaintyLower, xvLower);  # 使用 push! 函數在數組末尾追加推入新元;
                # Base.push!(testXvalsUncertaintyUpper, xvUpper);if !(isnothing(testXvals[i]) || isnothing(testXdataSTD[i]))
                if Core.Int64(i) <= Core.Int64(Base.length(testXvals)) && Core.Int64(i) <= Core.Int64(Base.length(testXdataSTD))
                    xvLower = Core.Float64(testXvals[i] - testXdataSTD[i]);
                    Base.push!(testXvalsUncertaintyLower, xvLower);

                    xvUpper = Core.Float64(testXvals[i] + testXdataSTD[i]);
                    Base.push!(testXvalsUncertaintyUpper, xvUpper);
                end
            end
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower;
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper;

            # 計算測試集數據的擬合殘差;
            testResidual = Core.Array{Core.Float64, 1}();  # 擬合殘差向量;
            for i = 1:Base.length(testing_data["Xdata"])
                # resi = Core.nothing;
                # if !(isnothing(testing_data["Xdata"][i]) || isnothing(testXvals[i]))
                #     resi = Core.Float64(Core.Float64(testing_data["Xdata"][i]) - Core.Float64(testXvals[i]));
                # end
                # Base.push!(testResidual, resi);  # 使用 push! 函數在數組末尾追加推入新元素;
                if Core.Int64(i) <= Core.Int64(Base.length(testXvals))
                    resi = Core.Float64(Core.Float64(testing_data["Xdata"][i]) - Core.Float64(testXvals[i]));
                    Base.push!(testResidual, resi);
                end
            end
            testData["test-Residual"] = testResidual;

        elseif (!Base.haskey(testing_data, "Xdata") || Base.length(testing_data["Xdata"]) <= 0) && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0

            # 計算測試集數據的 Ydata 均值向量;
            testYdataMean = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    yMean = Core.Float64(Statistics.mean(testing_data["Ydata"][i]));
                    Base.push!(testYdataMean, yMean);  # 使用 push! 函數在數組末尾追加推入新元素;
                else
                    yMean = Core.Float64(testing_data["Ydata"][i]);
                    Base.push!(testYdataMean, yMean);
                end
            end
            testData["test-Ydata-Mean"] = testYdataMean;
            # 計算測試集數據的 Ydata 標準差向量;
            testYdataSTD = Core.Array{Core.Float64, 1}();
            for i = 1:Base.length(testing_data["Ydata"])
                if Base.typeof(testing_data["Ydata"][i]) <: Core.Array
                    if Core.Int64(Base.length(testing_data["Ydata"][i])) === Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=false));
                        Base.push!(testYdataSTD, ySTD);  # 使用 push! 函數在數組末尾追加推入新元素;
                    elseif Core.Int64(Base.length(testing_data["Ydata"][i])) > Core.Int64(1)
                        ySTD = Core.Float64(Statistics.std(testing_data["Ydata"][i]; corrected=true));
                        Base.push!(testYdataSTD, ySTD);
                    end
                else
                    ySTD = Core.Float64(0.0);
                    Base.push!(testYdataSTD, ySTD);
                end
            end
            testData["test-Ydata-StandardDeviation"] = testYdataSTD;

            # 計算測試集數據的擬合的因變量 testXvals 值;
            testXvals = Core.Array{Core.Float64, 1}();  # 應變量 X 的擬合值;
            for i = 1:Base.length(testYdataMean)
                # # xv = Core.nothing;
                # if Core.Float64(testYdataMean[i]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[i]) <= Core.Float64(Base.findmax(YdataMean)[1])
                    xv = Core.Float64(itp(testYdataMean[i]));
                    Base.push!(testXvals, xv);  # 使用 push! 函數在數組末尾追加推入新元;
                # end
                # # Base.push!(testXvals, xv);
            end
            testData["test-Xvals"] = testXvals;

            # 計算測試集數據的擬合的因變量 testXvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testXvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testXvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testXvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # 通過 Y 值的觀察（Observation）標準差（Standard Deviation），轉換爲插值（Interpolation）之後的 X 值的觀察（Observation）標準差（Standard Deviation）;
            testXdataSTD = Core.Array{Core.Float64, 1}();
            for j = 1:Base.length(testYdataSTD)
                # # xv = Core.nothing;
                # if (Core.Float64(testYdataMean[j]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[j]) <= Core.Float64(Base.findmax(YdataMean)[1])) && (Core.Float64(testYdataMean[j] + testYdataSTD[j]) >= Core.Float64(Base.findmin(YdataMean)[1]) && Core.Float64(testYdataMean[j] + testYdataSTD[j]) <= Core.Float64(Base.findmax(YdataMean)[1]))
                    xv = Base.abs(Core.Float64(itp(testYdataMean[j])) - Core.Float64(itp(testYdataMean[j] + testYdataSTD[j])));
                    Base.push!(testXdataSTD, xv);  # 使用 push! 函數在數組末尾追加推入新元;
                # end
                # # Base.push!(testXdataSTD, xv);
            end
            # 通過插值算法（Interpolation Algorithm）的標準差（Standard Deviation）（插值計算結果的不確定度），轉換爲插值（Interpolation）之後的 X 值的插值算法（Interpolation Algorithm）標準差（Standard Deviation），然後合并觀察（Observation）標準差（Standard Deviation）與算法（Algorithm）標準差（Standard Deviation），爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            # 這裏因爲插值算法（Interpolation Algorithm）的的標準差（Standard Deviation）未給出，將之視爲零（0），因此 Y 值的觀察（Observation）標準差（Standard Deviation），即是轉換爲插值（Interpolation）之後的 X 值的總標準差（Standard Deviation）;
            for i = 1:Base.length(testYdataMean)
                # xvLower = Core.nothing;
                # xvUpper = Core.nothing;
                # if !(isnothing(testXvals[i]) || isnothing(testXdataSTD[i]))
                #     xvLower = Core.Float64(testXvals[i] - testXdataSTD[i]);
                #     xvUpper = Core.Float64(testXvals[i] + testXdataSTD[i]);
                # end
                # Base.push!(testXvalsUncertaintyLower, xvLower);  # 使用 push! 函數在數組末尾追加推入新元;
                # Base.push!(testXvalsUncertaintyUpper, xvUpper);
                # if !(isnothing(testXvals[i]) || isnothing(testXdataSTD[i]))
                if Core.Int64(i) <= Core.Int64(Base.length(testXvals)) && Core.Int64(i) <= Core.Int64(Base.length(testXdataSTD))
                    xvLower = Core.Float64(testXvals[i] - testXdataSTD[i]);
                    Base.push!(testXvalsUncertaintyLower, xvLower);

                    xvUpper = Core.Float64(testXvals[i] + testXdataSTD[i]);
                    Base.push!(testXvalsUncertaintyUpper, xvUpper);
                end
            end
            testData["test-Xfit-Uncertainty-Lower"] = testXvalsUncertaintyLower;
            testData["test-Xfit-Uncertainty-Upper"] = testXvalsUncertaintyUpper;

        elseif Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && (!Base.haskey(testing_data, "Ydata") || Base.length(testing_data["Ydata"]) <= 0)

            # 計算測試集數據的擬合的應變量 testYvals 值;
            testYvals = Core.Array{Core.Float64, 1}();  # 應變量 y 的擬合值;
            if !(Base.isnothing(itp))

                for i = 1:Base.length(testing_data["Xdata"])

                    # if Core.Float64(testing_data["Xdata"][i]) >= Core.Float64(Base.findmin(Xdata)[1]) && Core.Float64(testing_data["Xdata"][i]) <= Core.Float64(Base.findmax(Xdata)[1])

                        function rf1(x::Core.Float64)
                            y = Core.Float64(itp(x)) - Core.Float64(testing_data["Xdata"][i]);
                            return y;
                        end

                        # 計算二分法求根的含根區間（迭代初值）;
                        Y_lower = -Base.Inf;
                        Y_upper = +Base.Inf;
                        if testing_data["Xdata"][i] < Base.findmin(Xdata)[1]
                        # if testing_data["Xdata"][i] < Xdata[1]
                            # Y_lower = Core.Float64(2.2250738585072e-308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                            Y_upper = Base.findmin(YdataMean)[1];
                            # Y_upper = YdataMean[1];
                        end
                        if testing_data["Xdata"][i] > Base.findmax(Xdata)[1]
                        # if testing_data["Xdata"][i] > Xdata[Base.length(Xdata)]
                            # Y_lower = YdataMean[Base.length(YdataMean)];
                            Y_lower = Base.findmax(YdataMean)[1];
                            # Y_upper = Core.Float64(1.79769313486232e+308);  # Excel VBA 浮點數最大值：1.79769313486232E+308，Excel VBA 浮點數最小值：2.2250738585072E-308;
                        end
                        if testing_data["Xdata"][i] >= Base.findmin(Xdata)[1] && testing_data["Xdata"][i] <= Base.findmax(Xdata)[1]
                        # if testing_data["Xdata"][i] >= Xdata[1] && testing_data["Xdata"][i] <= Xdata[Base.length(Xdata)]
                            for j = 1:Base.length(Xdata)
                                # if Core.Int64(j) === Core.Int64(i)
                                # end
                                # if Core.Int64(j) === Core.Int64(Base.length(Xdata))
                                # end
                                if Core.Float64(testing_data["Xdata"][i]) === Core.Float64(Xdata[j])
                                    Y_lower = YdataMean[j] * Core.Float64(0.99);
                                    Y_upper = YdataMean[j] * Core.Float64(1.01);
                                    break;
                                end
                                if testing_data["Xdata"][i] > Xdata[j]
                                    Y_lower = YdataMean[j];
                                end
                                if testing_data["Xdata"][i] < Xdata[j]
                                    Y_upper = YdataMean[j];
                                    break;
                                end
                            end
                        end
                        # println(Y_lower);
                        # println(Y_upper);

                        # 參數 Roots.Bisection() 表示二分法，需要輸入含根區間，參數 Roots.Order1() 表示割綫法，需要輸入迭代起始點，參數 Roots.Newton() 表示斜截法（牛頓法），需要輸入迭代起始點，參數 Roots.A42() 表示;
                        # Roots.find_zero(f_fit_model, (Y_lower, Y_upper), Roots.Bisection(); maxiters=10000, xatol=0.0, xrtol=0.0, atol=0.0, rtol=0.0, verbose=true);
                        # xv = Roots.find_zero(rf1, (Y_lower, Y_upper), Roots.Bisection(); maxiters=10000);
                        yv = Roots.find_zero(rf1, Y_upper, Roots.Order1(); maxiters=10000);
                        Base.push!(testYvals, Core.Float64(yv));  # 使用 push! 函數在數組末尾追加推入新元;

                    # end
                end
            end
            testData["test-Yfit"] = testYvals;

            # 計算測試集數據的擬合的應變量 testYvals 誤差上下限;
            # 使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量來估算擬合誤差時，需要在擬合模型之前，先估算應變量 y 實測值的不確定性程度（Ydata 的標準差），然後再合并應變量 y 實測值的不確定性程度（Ydata 的標準差）與從 margin_of_error 向量獲得的擬合誤差，得到總的不確定度;
            # 如果使用應變量 y 的平均值擬合，就已經丟失了應變量 y 的分佈信息，導致 curve_fit() 函數認爲，應變量 y 的實測值 Ydata 是絕對且無變異的，這樣會導致低估擬合參數標準誤差;
            # 要估算應變量 y 的實測值 Ydata 的不確定性，可以計算 Ydata 的標準差，然後將這個標準差的倒數向量傳遞給 curve_fit() 函數的 [w,] 參數;
            testYvalsUncertaintyLower = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差下限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            testYvalsUncertaintyUpper = Core.Array{Core.Float64, 1}();  # 擬合的應變量 testYvals 誤差上限，使用 LsqFit.margin_error(fit, 0.05;) 函數的返回值 margin_of_error 向量，估計得到的模型擬合標準差，再合并加上應變量 y 的實測值 Ydata 的變異程度（Ydata 的標準差）;
            # if Core.Int64(Base.length(weight)) === Core.Int64(0)
            #     for i = 1:Base.length(testing_data["Xdata"])
            #         yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            #         # yvsd = (P4 - sdP4) - ((P4 - sdP4) - (P1 - sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 - sdP2))^(P3 - sdP3))^(P5 - sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            #         yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2);
            #         # yvLower = testYvals[i] - Base.sqrt((testYvals[i] - yvsd)^2 + testYdataSTD[i]^2);
            #         Base.push!(testYvalsUncertaintyLower, yvLower);  # 使用 push! 函數在數組末尾追加推入新元;

            #         yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / (1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3);
            #         # yvsd = (P4 + sdP4) - ((P4 + sdP4) - (P1 + sdP1)) / ((1.0 + (testing_data["Xdata"][i] / (P2 + sdP2))^(P3 + sdP3))^(P5 + sdP5));  # P4 - (P4 - P1)/(1.0 + (x[i]/P2)^P3)^P5;
            #         yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2);
            #         # yvUpper = testYvals[i] + Base.sqrt((yvsd - testYvals[i])^2 + testYdataSTD[i]^2);
            #         Base.push!(testYvalsUncertaintyUpper, yvUpper);
            #     end
            # end
            testData["test-Yfit-Uncertainty-Lower"] = testYvalsUncertaintyLower;
            testData["test-Yfit-Uncertainty-Upper"] = testYvalsUncertaintyUpper;

        else
        end
    end

    # http://gadflyjl.org/stable/gallery/geometries/#[Geom.segment](@ref)
    # 繪圖;
    img1 = Core.nothing;
    img2 = Core.nothing;
    if true

        set_default_plot_size(21cm, 21cm);  # 設定畫布規格;

        # 繪製擬合散點圖;
        if Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0
            # img1 = Core.nothing;
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean, # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],  # :dot
                    default_color="red",  # gray
                    alphas=[1],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # # 繪製置信區間填充圖;
            # ribbonline1 = Gadfly.layer(
            #     x=Xdata,
            #     # y=YdataMean, # Yvals,
            #     ymin=YvalsUncertaintyLower,
            #     ymax=YvalsUncertaintyUpper,
            #     # Geom.smooth,
            #     Geom.ribbon(fill=true),
            #     Theme(
            #         # point_size=5pt,
            #         line_width=0.1pt,
            #         line_style=[:dot],  # :solid
            #         default_color="gray",  # grey
            #         alphas=[0.5],
            #         # lowlight_color=c->"gray"
            #     )  # color=[colorant"red"],
            # );
            # smoothline2 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyLower,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            # smoothline3 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyUpper,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # smoothline2,
                # smoothline3,
                # ribbonline1,
                Guide.title(Base.string("Interpolation : " * Interpolation_Method * " model")),
                Guide.xlabel("Independent Variable ( x )"),
                Guide.ylabel("Dependent Variable ( y )"),
                Guide.manual_discrete_key("", ["observation values", "interpolation values"]; color=["blue", "red"])
            );
            # Gadfly.draw(
            #     Gadfly.SVG(
            #         "./Curvefit.svg",
            #         21cm,
            #         21cm
            #     ),  # 保存爲 .svg 格式圖片;
            #     # Gadfly.PDF(
            #     #     "Curvefit.pdf",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .pdf 格式圖片;
            #     # Gadfly.PNG(
            #     #     "Curvefit.png",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .png 格式圖片;
            #     img1
            # );
        end

        if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && (!Base.haskey(testing_data, "Ydata") || Base.length(testing_data["Ydata"]) <= 0)
            # img1 = Core.nothing;
            points1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean, # Ydata,
                Geom.point,
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            smoothline1 = Gadfly.layer(
                x=Xdata,
                y=YdataMean,  # Yvals,
                # ymin=YvalsUncertaintyLower,  # 繪製置信區間填充圖下綫;
                # ymax=YvalsUncertaintyUpper,  # 繪製置信區間填充圖上綫;
                Geom.smooth,
                # Geom.ribbon(fill=true),  # 繪製置信區間填充圖;
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],  # :dot
                    default_color="red",  # gray
                    alphas=[1],
                    # lowlight_color=c->"gray"
                )  # color=[colorant"red"],
            );
            # # 繪製置信區間填充圖;
            # ribbonline1 = Gadfly.layer(
            #     x=Xdata,
            #     # y=YdataMean, # Yvals,
            #     ymin=YvalsUncertaintyLower,
            #     ymax=YvalsUncertaintyUpper,
            #     # Geom.smooth,
            #     Geom.ribbon(fill=true),
            #     Theme(
            #         # point_size=5pt,
            #         line_width=0.1pt,
            #         line_style=[:dot],  # :solid
            #         default_color="gray",  # grey
            #         alphas=[0.5],
            #         # lowlight_color=c->"gray"
            #     )  # color=[colorant"red"],
            # );
            # smoothline2 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyLower,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            # smoothline3 = Gadfly.layer(
            #     x=Xdata,
            #     y=YvalsUncertaintyUpper,
            #     Geom.smooth,
            #     Theme(line_width=0.5pt, line_style=[:dot], default_color="red", alphas=[0.3],)  # color=[colorant"red"],
            # );
            img1 = Gadfly.plot(
                points1,
                smoothline1,
                # smoothline2,
                # smoothline3,
                # ribbonline1,
                Guide.title(Base.string("Interpolation : " * Interpolation_Method * " model")),
                Guide.xlabel("Independent Variable ( x )"),
                Guide.ylabel("Dependent Variable ( y )"),
                Guide.manual_discrete_key("", ["observation values", "interpolation values"]; color=["blue", "red"])
            );
            # Gadfly.draw(
            #     Gadfly.SVG(
            #         "./Curvefit.svg",
            #         21cm,
            #         21cm
            #     ),  # 保存爲 .svg 格式圖片;
            #     # Gadfly.PDF(
            #     #     "Curvefit.pdf",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .pdf 格式圖片;
            #     # Gadfly.PNG(
            #     #     "Curvefit.png",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .png 格式圖片;
            #     img1
            # );
        end

        # 繪製擬合殘差圖;
        if Base.haskey(testing_data, "Xdata") && Base.length(testing_data["Xdata"]) > 0 && Base.haskey(testing_data, "Ydata") && Base.length(testing_data["Ydata"]) > 0
            points2 = Gadfly.layer(
                x=testData["test-Xvals"],  # Xdata,
                y=testData["test-Residual"],  # Residual,
                Geom.point,
                # Geom.line,
                # Geom.abline,
                # Geom.smooth(method=:loess, smoothing=0.9),
                color=[colorant"blue"],
                Theme(line_width=1pt)
            );
            line2 = Gadfly.layer(
                x=[Base.findmin(testData["test-Xvals"])[1], Base.findmax(testData["test-Xvals"])[1]],
                y=[Statistics.mean(testData["test-Residual"]), Statistics.mean(testData["test-Residual"])],
                # x=[Base.findmin(Xdata)[1], Base.findmax(Xdata)[1]],
                # y=[Statistics.mean(Residual), Statistics.mean(Residual)],
                Geom.line,
                Theme(
                    # point_size=5pt,
                    line_width=1.0pt,
                    line_style=[:solid],
                    default_color="red",
                    alphas=[1]
                )  # color=[colorant"red"],
            );
            img2 = Gadfly.plot(
                points2,
                line2,
                # Guide.title(Base.string("Residual ~ Interpolation : " * Interpolation_Method * " model")),
                Guide.xlabel("Independent Variable ( x )"),
                Guide.ylabel("Residual"),
                # Guide.manual_discrete_key("", ["Residual", "Residual mean"]; color=["blue", "red"])
            );
            # Gadfly.draw(
            #     Gadfly.SVG(
            #         "./Residual.svg",
            #         21cm,
            #         21cm
            #     ),  # 保存爲 .svg 格式圖片;
            #     # Gadfly.PDF(
            #     #     "Residual.pdf",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .pdf 格式圖片;
            #     # Gadfly.PNG(
            #     #     "Residual.png",
            #     #     21cm,
            #     #     21cm
            #     # ),  # 保存爲 .png 格式圖片;
            #     img2
            # );
        end
    
        # # Gadfly.hstack(img1, img2);
        # # Gadfly.title(Gadfly.hstack(img1, img2), Base.string("Interpolation : " * Interpolation_Method * " curve"));
        # Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2));
        # Gadfly.title(Gadfly.vstack(Gadfly.hstack(img1), Gadfly.hstack(img2)), Base.string("Interpolation : " * Interpolation_Method * " curve fit"));
    end

    # resultDict = Base.Dict{Core.String, Core.Any}();
    resultDict["testData"] = testData;  # 傳入測試數據集的計算結果;
    resultDict["Curve-fit-image"] = img1;  # 擬合曲綫繪圖;
    resultDict["Residual-image"] = img2;  # 擬合殘差繪圖;
    # println(resultDict);

    return resultDict;
end


# 函數使用示例;
# 自變量 x 的實測數據;
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
