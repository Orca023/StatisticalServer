# /root/.julia/config/startup.jl

# Base.MainInclude.include(popfirst!(ARGS));
# println(Base.PROGRAM_FILE)

# println("julia-1.10.3-linux-aarch64.tar.gz")
# println("termux0.118-ubuntu22.04-LTS-rootfs-aarch64")
# export JULIA_NUM_THREADS=4
# ENV["JULIA_PKG_SERVER"]="https://pkg.julialang.org"
# export JULIA_PKG_SERVER=https://mirrors.sjtug.sjtu.edu.cn/julia
# ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
ENV["JUPYTER"]="/root/.local/bin/jupyter"
# ENV["CONDA_JL_HOME"]="/root/.julia/conda/3/aarch64/"

# # module Interface
# # Main.Interface
# Base.push!(LOAD_PATH, "..");  # 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;

# # Base.MainInclude.include(Base.filter(Base.contains(r".*\.jl$"), Base.Filesystem.readdir()));  # 在 Jupyterlab 中實現加載 Base.MainInclude.include("*.jl") 文檔，其中 r".*\.jl$" 為解析脚本文檔名的正則表達式;

# using Statistics;  # 導入 Julia 的原生標準模組「Statistics」，用於數據統計計算;
# using Dates;  # 導入 Julia 的原生標準模組「Dates」，用於處理時間和日期數據，也可以用全名 Main.Dates. 訪問模組内的方法（函數）;
# using Distributed;  # 導入 Julia 的原生標準模組「Distributed」，用於提供并行化和分佈式功能;
# # using Sockets;  # 導入 Julia 的原生標準模組「Sockets」，用於創建 TCP server 服務器;
# # using Base64;  # 導入 Julia 的原生標準模組「Base64」，用於按照 Base64 方式編解碼字符串;
# # using SharedArrays;

# # Distributed.@everywhere using Dates, Distributed, Sockets, Base64;  # SharedArrays;  # 使用廣播關鍵字 Distributed.@everywhere 在所有子進程中加載指定模組或函數或變量;

# # https://discourse.juliacn.com/t/topic/2969
# # 如果想臨時更換pkg工具下載鏡像源，在julia解釋器環境命令行輸入命令：
# # julia> ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
# # 或者：
# # Windows Powershell: $env:JULIA_PKG_SERVER = 'https://pkg.julialang.org'
# # Linux/macOS Bash: export JULIA_PKG_SERVER="https://pkg.julialang.org"
# # using Gadfly;  # 導入第三方擴展包「Gadfly」，用於繪圖，需要在控制臺先安裝第三方擴展包「Gadfly」：julia> using Pkg; Pkg.add("Gadfly") 成功之後才能使用;
# # using Cairo;  # 導入第三方擴展包「Cairo」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Cairo」：julia> using Pkg; Pkg.add("Cairo") 成功之後才能使用;
# # using Fontconfig;  # 導入第三方擴展包「Fontconfig」，用於持久化保存圖片到硬盤文檔，需要在控制臺先安裝第三方擴展包「Fontconfig」：julia> using Pkg; Pkg.add("Fontconfig") 成功之後才能使用;
# using Plots;  # 導入第三方擴展包「Plots」，用於繪圖，需要在控制臺先安裝第三方擴展包「Plots」：julia> using Pkg; Pkg.add("Plots") 成功之後才能使用;
# using DataFrames;  # 導入第三方擴展包「DataFrames」，需要在控制臺先安裝第三方擴展包「DataFrames」：julia> using Pkg; Pkg.add("DataFrames") 成功之後才能使用;
# # # https://github.com/JuliaData/DataFrames.jl
# # # https://dataframes.juliadata.org/stable/
# using JLD;  # 導入第三方擴展包「JLD」，用於操作 Julia 語言專有的硬盤「.jld」文檔數據，需要在控制臺先安裝第三方擴展包「JLD」：julia> using Pkg; Pkg.add("JLD") 成功之後才能使用;
# # https://github.com/JuliaIO/JLD.jl
# # using HDF5;
# # # https://github.com/JuliaIO/HDF5.jl
# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# # # https://github.com/JuliaIO/JSON.jl
# using CSV;  # 導入第三方擴展包「CSV」，用於操作「.csv」文檔，需要在控制臺先安裝第三方擴展包「CSV」：julia> using Pkg; Pkg.add("CSV") 成功之後才能使用;
# # # https://github.com/JuliaData/CSV.jl
# # # https://csv.juliadata.org/stable/
# using XLSX;  # 導入第三方擴展包「XLSX」，用於操作「.xlsx」文檔（Microsoft Office Excel），需要在控制臺先安裝第三方擴展包「XLSX」：julia> using Pkg; Pkg.add("XLSX") 成功之後才能使用;
# # # https://github.com/felipenoris/XLSX.jl
# # # https://felipenoris.github.io/XLSX.jl/stable/
# # using Optim;  # 導入第三方擴展包「Optim」，用於通用形式優化問題求解（optimization），需要在控制臺先安裝第三方擴展包「Optim」：julia> using Pkg; Pkg.add("Optim") 成功之後才能使用;
# # # https://julianlsolvers.github.io/Optim.jl/stable/
# # # https://github.com/JuliaNLSolvers/Optim.jl
# using JuMP;  # 導入第三方擴展包「JuMP」，用於帶有約束條件的通用形式優化問題求解（optimization），需要在控制臺先安裝第三方擴展包「JuMP」：julia> using Pkg; Pkg.add("JuMP") 成功之後才能使用;
# using Gurobi;  # 導入第三方擴展包「Gurobi」，用於 JuMP 調用的求解器（underlying solver）做缐性、整數、二次、混合整數等問題優化，需要在控制臺先安裝第三方擴展包「Gurobi」：julia> using Pkg; Pkg.add("Gurobi") 成功之後才能使用;
# using Ipopt;  # 導入第三方擴展包「Ipopt」，用於 JuMP 調用的求解器（underlying solver）做非缐性問題優化，需要在控制臺先安裝第三方擴展包「Ipopt」：julia> using Pkg; Pkg.add("Ipopt") 成功之後才能使用;
# using Cbc;  # 導入第三方擴展包「Cbc」，用於 JuMP 調用的求解器（underlying solver）做整數、混合整數問題優化，需要在控制臺先安裝第三方擴展包「Cbc」：julia> using Pkg; Pkg.add("Cbc") 成功之後才能使用;
# using GLPK;  # 導入第三方擴展包「GLPK」，用於 JuMP 調用的求解器（underlying solver）做缐性問題優化，需要在控制臺先安裝第三方擴展包「GLPK」：julia> using Pkg; Pkg.add("GLPK") 成功之後才能使用;
# # # https://jump.dev/
# # # https://jump.dev/JuMP.jl/stable/
# # # https://github.com/jump-dev/JuMP.jl
# using LsqFit;  # 導入第三方擴展包「LsqFit」，用於任意形式曲缐方程擬合（Curve Fitting），需要在控制臺先安裝第三方擴展包「LsqFit」：julia> using Pkg; Pkg.add("LsqFit") 成功之後才能使用;
# # # https://julianlsolvers.github.io/LsqFit.jl/latest/
# # # https://github.com/JuliaNLSolvers/LsqFit.jl
# # using Interpolations;  # 導入第三方擴展包「Interpolations」，用於插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「Interpolations」：julia> using Pkg; Pkg.add("Interpolations") 成功之後才能使用;
# # # https://juliamath.github.io/Interpolations.jl/stable/
# # # https://github.com/JuliaMath/Interpolations.jl/
# using DataInterpolations;  # 導入第三方擴展包「DataInterpolations」，用於一維（1 Dimension）插值運算（Interpolation），需要在控制臺先安裝第三方擴展包「DataInterpolations」：julia> using Pkg; Pkg.add("DataInterpolations") 成功之後才能使用;
# # # https://github.com/SciML/DataInterpolations.jl
# using NLsolve;  # 導入第三方擴展包「NLsolve」，用於求解任意形式多元非缐性方程組，需要在控制臺先安裝第三方擴展包「NLsolve」：julia> using Pkg; Pkg.add("NLsolve") 成功之後才能使用;
# # # https://github.com/JuliaNLSolvers/NLsolve.jl
# using Roots;  # 導入第三方擴展包「Roots」，用於求解任意形式一元非缐性方程，需要在控制臺先安裝第三方擴展包「Roots」：julia> using Pkg; Pkg.add("Roots") 成功之後才能使用;
# # # https://juliamath.github.io/Roots.jl/stable
# # # https://github.com/JuliaMath/Roots.jl
# using ForwardDiff;  # 導入第三方擴展包「ForwardDiff」，用於任意形式一元方程數值微分（自動微分）計算，需要在控制臺先安裝第三方擴展包「ForwardDiff」：julia> using Pkg; Pkg.add("ForwardDiff") 成功之後才能使用;
# # # https://juliadiff.org/ForwardDiff.jl/stable/
# # # https://github.com/JuliaDiff/ForwardDiff.jl
# using Calculus;  # 導入第三方擴展包「Calculus」，用於任意形式多元方程數值微分（自動微分）計算，需要在控制臺先安裝第三方擴展包「Calculus」：julia> using Pkg; Pkg.add("Calculus") 成功之後才能使用;
# # # https://github.com/JuliaMath/Calculus.jl
# using Cubature;  # 導入第三方擴展包「Cubature」，用於任意形式多元方程數值積分（自動積分）計算，需要在控制臺先安裝第三方擴展包「Cubature」：julia> using Pkg; Pkg.add("Cubature") 成功之後才能使用;
# # # https://github.com/JuliaMath/Cubature.jl
# using DifferentialEquations;  # 導入第三方擴展包「DifferentialEquations」，用於求解任意形式微分方程，需要在控制臺先安裝第三方擴展包「DifferentialEquations」：julia> using Pkg; Pkg.add("DifferentialEquations") 成功之後才能使用;
# # # https://docs.sciml.ai/DiffEqDocs/stable/
# # # https://github.com/SciML/DifferentialEquations.jl
# using Symbolics;  # 導入第三方擴展包「Symbolics」，用於符號計算，需要在控制臺先安裝第三方擴展包「Symbolics」：julia> using Pkg; Pkg.add("Symbolics") 成功之後才能使用;
# # # https://symbolics.juliasymbolics.org/stable/
# # # https://github.com/JuliaSymbolics/Symbolics.jl
# # using SymPy;  # 導入第三方擴展包「SymPy」，用於符號計算，需要在控制臺先安裝第三方擴展包「SymPy」：julia> using Pkg; Pkg.add("SymPy") 成功之後才能使用;
# # # https://jverzani.github.io/SymPyCore.jl/dev/
# # # https://github.com/JuliaPy/SymPy.jl
# using TimeSeries;  # 導入第三方擴展包「TimeSeries」，用於連續型數據（continuous）的時間序列（Time Series）分析，需要在控制臺先安裝第三方擴展包「TimeSeries」：julia> using Pkg; Pkg.add("TimeSeries") 成功之後才能使用;
# # # https://juliastats.org/TimeSeries.jl/latest/
# # # https://github.com/JuliaStats/TimeSeries.jl
# using CountTimeSeries;  # 導入第三方擴展包「CountTimeSeries」，用於離散型數據（discrete）的時間序列（Time Series）分析，需要在控制臺先安裝第三方擴展包「CountTimeSeries」：julia> using Pkg; Pkg.add("CountTimeSeries") 成功之後才能使用;
# # # https://github.com/ManuelStapper/CountTimeSeries.jl
# # # https://github.com/ManuelStapper/CountTimeSeries.jl/blob/master/CountTimeSeries_documentation.pdf

# Distributed.@everywhere using Statistics, Dates, Plots;

# # 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
# # Base.MainInclude.include("./Router.jl");
# # Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Router.jl"));
# # Base.Filesystem.joinpath(Base.@__DIR__, "Router.jl")
# # Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Router.jl")
# # Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Router.jl")
# # Base.MainInclude.include("./Interpolation_Fitting.jl");
