Attribute VB_Name = "DatabaseMongoDB"

'Author: 弘毅先生
'E-mail: 283640621@qq.com
'Telephont Number: +86 18604537694
'Date: 六十九年


'The codes were enhanced for both VBA7 (64-bit) and others (32-bit) by Long Vh.
#If VBA7 Then

    Private Declare PtrSafe Sub sleep Lib "kernel64" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 64 位軟件使用這條語句聲明
    Private Declare PtrSafe Function timeGetTime Lib "winmm.dll" () As Long: Rem 64 位軟件使用這條語句聲明
    
    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare PtrSafe Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As LongPtr, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 64 位軟件使用這條語句聲明

#Else

    Private Declare Sub sleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long): Rem 32 位軟件使用這條語句聲明，聲明 sleep 函數，函數 sleep 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 sleep 函數精確延時使用的，如果程序中不使用 sleep 函數，可以刪除這條語句。函數 sleep 的使用方法是，sleep 3000  '3000 表示 3000 毫秒。函數 sleep 延時是毫秒級的，精確度比較高，但它在延時時，會將程序挂起，使操作系統暫時無法響應用戶操作，所以長延時不適合使用。
    Private Declare Function timeGetTime Lib "winmm.dll" () As Long: Rem 32 位軟件使用這條語句聲明，聲明 timeGetTime 函數，函數 timeGetTime 是 Windows API 函數，使用前，必須先聲明，然後再使用。這條語句是為後面使用 timeGetTime 函數精確延時使用的，如果程序中不需要使用 timeGetTime 函數也可以刪除這條語句。函數 timeGetTime 返回的是開機到現在的毫秒數，可以支持 1 毫秒的間隔時間，一直增加。

    '聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。
    Private Declare Function sendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long: Rem 32 位軟件使用這條語句聲明，聲明 SendMessage 函數，函數 SendMessage 是 Windows 系統 API 函數，使用前必須先聲明，然後才能使用。

#End If
Private Const WM_SYSCOMMAND = &H112: Rem 聲明函數參數使用的常數值
Private Const SC_MINIMIZE = &HF020&: Rem 聲明函數參數使用的常數值
'使用函數示例
'SendMessage IEA.hwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0: Rem 向瀏覽器窗口發送消息，最小化瀏覽器窗口，這是使用的 Windows 系統的 API 函數，在模塊頭部的幾條語句中聲明過

Rem 如果使用全局變量 public 的方法實現，在用戶窗體裏邊的全局變量賦值方式如下：
Option Explicit: Rem 語句 Option Explicit 表示强制要求變量需要先聲明後使用；聲明全局變量，可以跨越函數和子過程之間使用的，用于監測窗體中按钮控件點擊狀態。



'自定義啓動運算;
Public Sub Run_MongoDB(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_Server_Url As String, ByVal Database_custom_name As String, ByVal Data_table_custom_name As String, ByVal Database_Server_Username As String, ByVal Database_Server_Password As String, ByVal Field_name_input_position As String, ByVal Field_data_input_position As String, ByVal Field_name_output_position As String, ByVal Field_data_output_position As String, ParamArray OtherArgs())
'最後一個參數 ParamArray OtherArgs() 表示可變參數，預設值為空 "" 字符串，可傳入 ("test", "Interpolate", "Logistic", "Cox", "LC5PFit") 等自定義的算法名稱值字符串之一。
'調用示例：Call DatabaseModule.Run(Public_Database_software, Public_Database_operational_order, Public_Database_Server_Url, Public_Database_custom_name, Public_Data_table_custom_name, Public_Database_Server_Username, Public_Database_Server_Password, Public_Field_name_input_position, Public_Field_data_input_position, Public_Field_name_output_position, Public_Field_data_output_position)
'需要事先完成如下操作：
'控制臺命令行啓動 MongoDB 數據庫服務器端應用：C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongod.exe --config=C:\Criss\DatabaseServer\MongoDB\mongod.cfg
'控制臺命令行啓動用於鏈接操作 MongoDB 數據庫服務器端應用的自定義的 Node.js 服務器：C:\Criss\DatabaseServer\MongoDB>C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:\Criss\DatabaseServer\MongoDB\Nodejs2MongodbServer.js host=0.0.0.0 port=27016 number_cluster_Workers=0 MongodbHost=0.0.0.0 MongodbPort=27017 dbUser=admin_MathematicalStatisticsData dbPass=admin dbName=MathematicalStatisticsData
'控制臺命令行啓動 MongoDB 數據庫客戶端應用：C:\Criss\DatabaseServer\MongoDB>C:\Criss\MongoDB\Server\4.2\bin\mongo.exe mongodb://127.0.0.1:27017/MathematicalStatisticsData
'（注意，這一步操作不必須，不是必須啓動  MongoDB 數據庫客戶端應用，可以選擇不啓動）


    Application.CutCopyMode = False: Rem 退出時，不顯示詢問，是否清空剪貼板對話框
    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。

    Dim i, j, k, g, h As Integer: Rem 整型，記錄 for 循環次數變量
    i = 0
    j = 0
    k = 0
    g = 0
    h = 0


    ''循環讀取傳入的全部可變參數的值
    'Dim OtherArgsValues As String
    'Dim i As Integer
    'For i = 0 To UBound(OtherArgs)
    '    OtherArgsValues = OtherArgsValues & "/n" & OtherArgs(i)
    'Next
    'Debug.Print OtherArgsValues: Rem ("InternetExplorer", "Edge", "Chrome", "Firefox")

    Dim OtherArgs_Name As String
    If (UBound(OtherArgs) > -1) And OtherArgs(LBound(OtherArgs)) <> "" Then
        OtherArgs_Name = CStr(OtherArgs(LBound(OtherArgs)))
    Else
        OtherArgs_Name = "LC5PFit": Rem 判斷自定義選擇的統計算法種類，可以取值：("test", "Interpolate", "Logistic", "Cox", "LC5PFit")
    End If
    'Debug.Print OtherArgs(LBound(OtherArgs))
    'Debug.Print OtherArgs_Name


    ''更改按鈕狀態和標志
    'PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
    'If Not (DatabaseControlPanel.Controls("Run_CommandButton") Is Nothing) Then
    '    Select Case PublicVariableStartORStopButtonClickState
    '        Case True
    '            DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Run")
    '        Case False
    '            DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Abort")
    '        Case Else
    '            MsgBox "Run or Abort Button" & "\\n" & "Private Sub Run_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
    '    End Select
    'End If
    ''刷新操作面板窗體控件中的變量值
    ''Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    ''為操作面板窗體控件 DatabaseControlPanel 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
    'If Not (DatabaseControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
    '    DatabaseControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
    'End If
    ''判斷是否跳出子過程不繼續執行後面的動作
    'If PublicVariableStartORStopButtonClickState Then

    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "運行過程被中止.": Rem 提示運行過程執行狀態，賦值給標簽控件 Database_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Database_status_Label”的“text”屬性值 Database_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    '    'End If

    '    ''Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
    '    ''刷新載入的鏈接操控數據庫模塊中的變量值，鏈接操控數據庫模塊名稱值為：("DatabaseModule")
    '    'DatabaseModule.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState: Rem 為導入的鏈接操控數據庫模塊 DatabaseModule 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
    '    ''Debug.Print VBA.TypeName(DatabaseModule)
    '    ''Debug.Print VBA.TypeName(DatabaseModule.PublicVariableStartORStopButtonClickState)
    '    ''Debug.Print DatabaseModule.PublicVariableStartORStopButtonClickState
    '    ''Application.Evaluate Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"
    '    ''Application.Run Public_Database_module_name & ".PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState"

    '    '使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    '    If Not (DatabaseControlPanel.Controls("delay") Is Nothing) Then
    '        Call DatabaseControlPanel.delay(DatabaseControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
    '    End If

    '    DatabaseControlPanel.Run_CommandButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Run_CommandButton（啓動運行按鈕），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Access_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Access_OptionButton（用於判別標識指定使用 Microsoft Office Access 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.MongoDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MongoDB_OptionButton（用於判別標識指定使用 MongoDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.MariaDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MariaDB_OptionButton（用於判別標識指定使用 MariaDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.PostgreSQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 PostgreSQL_OptionButton（用於判別標識指定使用 PostgreSQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.MySQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MySQL_OptionButton（用於判別標識指定使用 MySQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Database_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_name_input_TextBox（用於指定待鏈接操控的自定義數據庫命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Data_table_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Data_table_name_input_TextBox（用於指定待鏈接操控的自定義數據庫包含的數據二維表格（集合）命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Field_name_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_name_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Field_data_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Field_name_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Field_data_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Add_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_data_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Retrieve_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_data_OptionButton（用於標識選擇某一個具體操控指令（檢索查找數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Update_Data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Update_Data_OptionButton（用於標識選擇某一個具體操控指令（修改更新數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Delete_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_data_OptionButton（用於標識選擇某一個具體操控指令（刪除指定數據）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Retrieve_count_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_count_OptionButton（用於標識選擇某一個具體操控指令（檢索數據的條數）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Add_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_table_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.Delete_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_table_OptionButton（用於標識選擇某一個具體操控指令（刪除指定保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
    '    DatabaseControlPanel.SQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 SQL_OptionButton（用於標識選擇某一個具體操控指令（執行傳入的 SQL 指令）的單選框），False 表示禁用點擊，True 表示可以點擊

    '    Exit Sub

    'End If


    ''刷新提供存儲數據服務的數據庫服務器網址 URL 字符串
    'If Not (DatabaseControlPanel.Controls("Database_Server_Url_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Value)
    '    Public_Database_Server_Url = CStr(DatabaseControlPanel.Controls("Database_Server_Url_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型。
    'End If
    ''Debug.Print "Database Server Url = " & "[ " & Public_Database_Server_Url & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Url 值。
    ''刷新控制面板窗體中包含的變量，用於保存計算結果的數據庫服務器網址 URL 字符串，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Database_Server_Url") Is Nothing) Then
    '    DatabaseControlPanel.Public_Database_Server_Url = Public_Database_Server_Url
    'End If
    'Dim Database_Server_Url As String
    'Database_Server_Url = Public_Database_Server_Url


    '拼接提供存儲數據功能的數據庫服務器網址，得到完整的請求 URL 字符串，拼接之後得到的字符串格式類似於："http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
    Dim tempArr() As String: Rem 字符串分割之後得到的數組
    Dim Database_Server_Url_split As String: Rem 字符串拼接之後得到的，提供存儲數據功能的數據庫服務器完整網址，字符串變量，可取值：CStr("http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password");
    Database_Server_Url_split = Database_Server_Url
    If Database_Server_Url <> "" Then

        'Database_Server_Url_split = CStr(Database_Server_Url): Rem 用於提供存儲數據服務的服務器網址，字符串變量
        If (Database_custom_name <> "") And (Data_table_custom_name <> "") And (Database_Server_Username <> "") And (Database_Server_Password <> "") Then

            If InStr(1, Database_Server_Url_split, "?", 1) = 0 Then
                Database_Server_Url_split = CStr(Database_Server_Url_split) & "?dbName=" & CStr(Database_custom_name) & "&dbTableName=" & CStr(Data_table_custom_name) & "&dbUser=" & CStr(Database_Server_Username) & "&dbPass=" & CStr(Database_Server_Password) & "&Key=" & CStr(Database_Server_Username) & ":" & CStr(Database_Server_Password)
            Else
                Database_Server_Url_split = VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))) & "?dbName=" & CStr(Database_custom_name) & "&dbTableName=" & CStr(Data_table_custom_name) & "&dbUser=" & CStr(Database_Server_Username) & "&dbPass=" & CStr(Database_Server_Password) & "&Key=" & CStr(Database_Server_Username) & ":" & CStr(Database_Server_Password)
            End If

        Else

            If Database_custom_name <> "" Then
                If InStr(1, Database_Server_Url_split, "?", 1) = 0 Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "?dbName=" & CStr(Database_custom_name)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbName", 1) = 0) Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "&dbName=" & CStr(Database_custom_name)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbName", 1) <> 0) Then
                    'Dim tempArr() As String: Rem 字符串分割之後得到的數組
                    ReDim tempArr(0): Rem 清空數組
                    tempArr = VBA.Split(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(UBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))), delimiter:="&")
                    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
                    For i = LBound(tempArr) To UBound(tempArr)
                        If VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare))) = "dbName" Then
                            tempArr(i) = "dbName" & "=" & CStr(Database_custom_name)
                        End If
                    Next
                    Database_Server_Url_split = VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))) & "?" & VBA.Join(tempArr, "&")
                Else
                End If
            End If
            If Data_table_custom_name <> "" Then
                If InStr(1, Database_Server_Url_split, "?", 1) = 0 Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "?dbTableName=" & CStr(Data_table_custom_name)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbTableName", 1) = 0) Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "&dbTableName=" & CStr(Data_table_custom_name)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbTableName", 1) <> 0) Then
                    'Dim tempArr() As String: Rem 字符串分割之後得到的數組
                    ReDim tempArr(0): Rem 清空數組
                    tempArr = VBA.Split(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(UBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))), delimiter:="&")
                    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
                    For i = LBound(tempArr) To UBound(tempArr)
                        If VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare))) = "dbTableName" Then
                            tempArr(i) = "dbTableName" & "=" & CStr(Data_table_custom_name)
                        End If
                    Next
                    Database_Server_Url_split = VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))) & "?" & VBA.Join(tempArr, "&")
                Else
                End If
            End If
            If Database_Server_Username <> "" Then
                If InStr(1, Database_Server_Url_split, "?", 1) = 0 Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "?dbUser=" & CStr(Database_Server_Username)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbUser", 1) = 0) Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "&dbUser=" & CStr(Database_Server_Username)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbUser", 1) <> 0) Then
                    'Dim tempArr() As String: Rem 字符串分割之後得到的數組
                    ReDim tempArr(0): Rem 清空數組
                    tempArr = VBA.Split(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(UBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))), delimiter:="&")
                    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
                    For i = LBound(tempArr) To UBound(tempArr)
                        If VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare))) = "dbUser" Then
                            tempArr(i) = "dbUser" & "=" & CStr(Database_Server_Username)
                        End If
                    Next
                    Database_Server_Url_split = VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))) & "?" & VBA.Join(tempArr, "&")
                Else
                End If
            End If
            If Database_Server_Password <> "" Then
                If InStr(1, Database_Server_Url_split, "?", 1) = 0 Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "?dbPass=" & CStr(Database_Server_Password)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbPass", 1) = 0) Then
                    Database_Server_Url_split = CStr(Database_Server_Url_split) & "&dbPass=" & CStr(Database_Server_Password)
                ElseIf (InStr(1, Database_Server_Url_split, "?", 1) <> 0) And (InStr(1, Database_Server_Url_split, "dbPass", 1) <> 0) Then
                    'Dim tempArr() As String: Rem 字符串分割之後得到的數組
                    ReDim tempArr(0): Rem 清空數組
                    tempArr = VBA.Split(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(UBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))), delimiter:="&")
                    'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
                    For i = LBound(tempArr) To UBound(tempArr)
                        If VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(tempArr(i), delimiter:="=", limit:=2, compare:=vbBinaryCompare))) = "dbPass" Then
                            tempArr(i) = "dbPass" & "=" & CStr(Database_Server_Password)
                        End If
                    Next
                    Database_Server_Url_split = VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare)(LBound(VBA.Split(Database_Server_Url_split, delimiter:="?", limit:=2, compare:=vbBinaryCompare))) & "?" & VBA.Join(tempArr, "&")
                Else
                End If
            End If

        End If

    Else

        Debug.Print "輸入的數控服務器 Url 網址字符串爲空或無法識別：（Database Server Url = " & CStr(Database_Server_Url) & "）."
        MsgBox "輸入的數控服務器 Url 網址字符串爲空或無法識別：（Database Server Url = " & CStr(Database_Server_Url) & "）."
        Exit Sub

    End If


    '從控制面板窗體中包含的文本輸入框中讀取值，刷新待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置字符串;
    'If Not (DatabaseControlPanel.Controls("Field_name_position_Input_TextBox") Is Nothing) Then
    '    'Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A1:H1 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$H$1，即：Public_Field_name_input_position = "$A$1:$H$1"。
    '    Public_Field_name_input_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A1:H1 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$1:$H$1，即：Public_Field_name_input_position = "$A$1:$H$1"。
    'End If
    'Debug.Print Public_Field_name_input_position
    ''刷新控制面板窗體中包含的變量，待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Field_name_input_position") Is Nothing) Then
    '    DatabaseControlPanel.Public_Field_name_input_position = Public_Field_name_input_position
    'End If
    'Dim Field_name_input_position As String
    'Field_name_input_position = Public_Field_name_input_position

    Dim Data_name_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Data_name_input_sheetName = ""
    Dim Data_name_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Data_name_input_rangePosition = ""
    If (Field_name_input_position <> "") And (InStr(1, Field_name_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Field_name_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Data_name_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Field_name_input_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_name_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Data_name_input_rangePosition = "": Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & CStr(tempArr(i)): Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Data_name_input_rangePosition = Data_name_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待上傳數據庫服務器請求的數據字段命名值在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Data_name_input_sheetName & ", " & Data_name_input_rangePosition
    Else
        Data_name_input_rangePosition = Field_name_input_position
    End If


    ''從控制面板窗體中包含的文本輸入框中讀取值，刷新待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置字符串;
    'If Not (DatabaseControlPanel.Controls("Field_data_position_Input_TextBox") Is Nothing) Then
    '    'Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A2:H12 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$H$12，即：Public_Field_data_input_position = "$A$2:$H$12"。
    '    Public_Field_data_input_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!A2:H12 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$A$2:$H$12，即：Public_Field_data_input_position = "$A$2:$H$12"。
    'End If
    'Debug.Print Public_Field_data_input_position
    ''刷新控制面板窗體中包含的變量，待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Field_data_input_position") Is Nothing) Then
    '    DatabaseControlPanel.Public_Field_data_input_position = Public_Field_data_input_position
    'End If
    'Dim Field_data_input_position As String
    'Field_data_input_position = Public_Field_data_input_position

    Dim Data_input_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Data_input_sheetName = ""
    Dim Data_input_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Data_input_rangePosition = ""
    If (Field_data_input_position <> "") And (InStr(1, Field_data_input_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Field_data_input_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Data_input_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Field_data_input_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Data_input_sheetName = CStr(tempArr(LBound(tempArr))): Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Data_input_rangePosition = "": Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Data_input_rangePosition = Data_input_rangePosition & CStr(tempArr(i)): Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Data_input_rangePosition = Data_input_rangePosition & "!" & CStr(tempArr(i)): Rem 待上傳數據庫服務器請求的數據字段在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Data_input_sheetName & ", " & Data_input_rangePosition
    Else
        Data_input_rangePosition = Field_data_input_position
    End If


    ''從控制面板窗體中包含的文本輸入框中讀取值，刷新從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置字符串;
    'If Not (DatabaseControlPanel.Controls("Field_name_position_Output_TextBox") Is Nothing) Then
    '    'Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Field_name_output_position = "$J$1:$L$5"。
    '    Public_Field_name_output_position = CStr(DatabaseControlPanel.Controls("Field_name_position_Output_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Field_name_output_position = "$J$1:$L$5"。
    'End If
    'Debug.Print Public_Field_name_output_position
    ''刷新控制面板窗體中包含的變量，從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Field_name_output_position") Is Nothing) Then
    '    DatabaseControlPanel.Public_Field_name_output_position = Public_Field_name_output_position
    'End If
    'Dim Field_name_output_position As String
    'Field_name_output_position = Public_Field_name_output_position

    Dim Result_name_output_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Result_name_output_sheetName = ""
    Dim Result_name_output_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Result_name_output_rangePosition = ""
    If (Field_name_output_position <> "") And (InStr(1, Field_name_output_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Field_name_output_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Result_name_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Result_name_output_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Field_name_output_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Result_name_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Result_name_output_rangePosition = "": Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Result_name_output_rangePosition = Result_name_output_rangePosition & CStr(tempArr(i)): Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Result_name_output_rangePosition = Result_name_output_rangePosition & "!" & CStr(tempArr(i)): Rem 從數據庫服務器接收到的響應值結果字段命名值輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Result_name_output_sheetName & ", " & Result_name_output_rangePosition
    Else
        Result_name_output_rangePosition = Field_name_output_position
    End If


    ''從控制面板窗體中包含的文本輸入框中讀取值，刷新從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置字符串;
    'If Not (DatabaseControlPanel.Controls("Field_data_position_Output_TextBox") Is Nothing) Then
    '    'Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Field_data_output_position = "$J$1:$L$5"。
    '    Public_Field_data_output_position = CStr(DatabaseControlPanel.Controls("Field_data_position_Output_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為字符串類型，例如可以文本輸入框控件中輸入值：Sheet1!J1:L5 或 'C:\Criss\vba\Statistics\[示例.xlsx]Sheet1'!$J$1:$L$5，即：Public_Field_data_output_position = "$J$1:$L$5"。
    'End If
    'Debug.Print Public_Field_data_output_position
    ''刷新控制面板窗體中包含的變量，從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Field_data_output_position") Is Nothing) Then
    '    DatabaseControlPanel.Public_Field_data_output_position = Public_Field_data_output_position
    'End If
    'Dim Field_data_output_position As String
    'Field_data_output_position = Public_Field_data_output_position

    Dim Result_output_sheetName As String: Rem 字符串分割之後得到的指定的工作表（Sheet）的名字字符串;
    Result_output_sheetName = ""
    Dim Result_output_rangePosition As String: Rem 字符串分割之後得到的指定的單元格區域（Range）的位置字符串;
    Result_output_rangePosition = ""
    If (Field_data_output_position <> "") And (InStr(1, Field_data_output_position, "!", 1) <> 0) Then
        'Dim i As Integer: Rem 整型，記錄 for 循環次數變量
        'Dim tempArr() As String: Rem 字符串分割之後得到的數組
        ReDim tempArr(0): Rem 清空數組
        tempArr = VBA.Split(Field_data_output_position, delimiter:="!", limit:=2, compare:=vbBinaryCompare)
        'Debug.Print tempArr(LBound(tempArr)) & ", " & tempArr(UBound(tempArr))
        '刪除字符串首的單引號「'」;
        Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        Loop
        'If left(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'End If
        '刪除字符串尾的單引號「'」;
        Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
            tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
            'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        Loop
        'If Right(CStr(tempArr(LBound(tempArr))), 1) = "'" Then
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'End If
        Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        Result_output_rangePosition = CStr(tempArr(UBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'tempArr = VBA.Split(Field_data_output_position, delimiter:="!")
        '刪除字符串首的單引號「'」;
        'Do While left(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(Right(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 2, Len(CStr(tempArr(LBound(tempArr))))))
        'Loop
        ''刪除字符串尾的單引號「'」;
        'Do While Right(CStr(tempArr(LBound(tempArr))), 1) = "'"
        '    tempArr(LBound(tempArr)) = CStr(left(CStr(tempArr(LBound(tempArr))), CInt(Len(CStr(tempArr(LBound(tempArr)))) - 1)))
        '    'tempArr(LBound(tempArr)) = CStr(Mid(CStr(tempArr(LBound(tempArr))), 1, Len(CStr(tempArr(LBound(tempArr)))) - 1))
        'Loop
        'Result_output_sheetName = CStr(tempArr(LBound(tempArr))): Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的工作表（Sheet）的名字字符串
        'Result_output_rangePosition = "": Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        'For i = CInt(LBound(tempArr) + CInt(1)) To UBound(tempArr)
        '    If i = CInt(LBound(tempArr) + CInt(1)) Then
        '        Result_output_rangePosition = Result_output_rangePosition & CStr(tempArr(i)): Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    Else
        '        Result_output_rangePosition = Result_output_rangePosition & "!" & CStr(tempArr(i)): Rem 從數據庫服務器接收到的響應值結果輸出在Excel表格中的傳入位置的單元格區域（Range）的位置的字符串
        '    End If
        'Next
        'Debug.Print Result_output_sheetName & ", " & Result_output_rangePosition
    Else
        Result_output_rangePosition = Field_data_output_position
    End If


    ''判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串變量，可取值：("MongoDB"，"Microsoft Office Access"，"PostgreSQL"，"MySQL") 等自定義的數據庫管理應用軟體名稱值字符串，例如取值：CStr("MongoDB")
    ''判斷子框架控件是否存在
    'If Not (DatabaseControlPanel.Controls("Database_software_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    'Dim element_i
    '    For Each element_i In DatabaseControlPanel.Controls("Database_software_Frame").Controls
    '        '判斷單選框控件的選中狀態
    '        If element_i.Value Then
    '            Public_Database_software = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing

    '    'Debug.Print "Database software = " & "[ " & Public_Database_software & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_software 值。
    '    '刷新控制面板窗體中包含的變量，判斷選擇使用的辨識數據庫應用軟體的名稱字符串，字符串類型的變量;
    '    If Not (DatabaseControlPanel.Controls("Public_Database_software") Is Nothing) Then
    '        DatabaseControlPanel.Public_Database_software = Public_Database_software
    '    End If
    'End If
    'Dim Database_software As String
    'Database_software = Public_Database_software


    ''刷新指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串
    'If Not (DatabaseControlPanel.Controls("Database_name_input_TextBox") Is Nothing) Then
    '    'Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Value)
    '    Public_Database_custom_name = CStr(DatabaseControlPanel.Controls("Database_name_input_TextBox").Text)
    'End If
    ''Debug.Print "Database custom name = " & "[ " & Public_Database_custom_name & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_custom_name 值。
    ''刷新控制面板窗體中包含的變量，指定數據庫服務器中待鏈接操控的自定義數據庫名稱字符串，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Database_custom_name") Is Nothing) Then
    '    DatabaseControlPanel.Public_Database_custom_name = Public_Database_custom_name
    'End If
    'Dim Database_custom_name As String
    'Database_custom_name = Public_Database_custom_name

    ''刷新指定數據庫服務器中待鏈接操控的自定義數據庫中包含的數據二維表格（集合）名稱字符串
    'If Not (DatabaseControlPanel.Controls("Data_table_name_input_TextBox") Is Nothing) Then
    '    'Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Value)
    '    Public_Data_table_custom_name = CStr(DatabaseControlPanel.Controls("Data_table_name_input_TextBox").Text)
    'End If
    ''Debug.Print "Data table custom name = " & "[ " & Public_Data_table_custom_name & " ]"
    ''刷新控制面板窗體中包含的變量，指定數據庫服務器中待鏈接操控的自定義數據庫中包含的數據二維表格（集合）名稱字符串，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Data_table_custom_name") Is Nothing) Then
    '    DatabaseControlPanel.Public_Data_table_custom_name = Public_Data_table_custom_name
    'End If
    'Dim Data_table_custom_name As String
    'Data_table_custom_name = Public_Data_table_custom_name

    ''刷新用於驗證提供數據存儲服務的服務器的賬戶名字符串
    'If Not (DatabaseControlPanel.Controls("Username_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Value)
    '    Public_Database_Server_Username = CStr(DatabaseControlPanel.Controls("Username_TextBox").Text)
    'End If
    ''Debug.Print "Database Server Username = " & "[ " & Public_Database_Server_Username & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_Server_Username 值。
    ''刷新控制面板窗體中包含的變量，用於驗證提供數據存儲服務的服務器的賬戶名字符串，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Database_Server_Username") Is Nothing) Then
    '    DatabaseControlPanel.Public_Database_Server_Username = Public_Database_Server_Username
    'End If
    'Dim Database_Server_Username As String
    'Database_Server_Username = Public_Database_Server_Username

    ''刷新用於驗證提供數據存儲服務的服務器的賬戶密碼字符串
    'If Not (DatabaseControlPanel.Controls("Password_TextBox") Is Nothing) Then
    '    'Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Value)
    '    Public_Database_Server_Password = CStr(DatabaseControlPanel.Controls("Password_TextBox").Text)
    'End If
    ''Debug.Print "Statistics Algorithm Server Password = " & "[ " & Public_Database_Server_Password & " ]"
    ''刷新控制面板窗體中包含的變量，用於驗證提供數據存儲服務的服務器的賬戶密碼字符串，字符串類型的變量;
    'If Not (DatabaseControlPanel.Controls("Public_Database_Server_Password") Is Nothing) Then
    '    DatabaseControlPanel.Public_Database_Server_Password = Public_Database_Server_Password
    'End If
    'Dim Database_Server_Password As String
    'Database_Server_Password = Public_Database_Server_Password


    ''判別辨識選擇指定某一個具體的操作指令的種類，字符串型變量，可以取值：("Add data", "Retrieve data", "Update data", "Delete data", "Retrieve count", "Add table(collection)", "Delete table(collection)") 等自定義的操控指令名稱值字符串;
    ''判斷子框架控件是否存在
    'If Not (DatabaseControlPanel.Controls("Manipulate_database_Frame") Is Nothing) Then
    '    '遍歷框架中包含的子元素。
    '    'Dim element_i
    '    For Each element_i In DatabaseControlPanel.Controls("Manipulate_database_Frame").Controls
    '        '判斷單選框控件的選中狀態
    '        If element_i.Value Then
    '            Public_Database_operational_order = CStr(element_i.Caption): Rem 從單選框張提取值，結果為字符串型。函數 CStr() 表示轉換爲字符串類型。
    '            Exit For
    '        End If
    '    Next
    '    Set element_i = Nothing

    '    'Debug.Print "Database operational order = " & "[ " & Public_Database_operational_order & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Database_operational_order 值。
    '    '刷新控制面板窗體中包含的變量，用於判別辨識選擇指定某一個具體的對數據庫操作的指令種類的標志，字符串類型的變量;
    '    If Not (DatabaseControlPanel.Controls("Public_Database_operational_order") Is Nothing) Then
    '        DatabaseControlPanel.Public_Database_operational_order = Public_Database_operational_order
    '    End If
    'End If
    'Dim Database_operational_order As String
    'Database_operational_order = Public_Database_operational_order


    '整型數據能表示的數據範圍：-32768 ~ 32767
    '長整型數據能表示的數據範圍：-2147483648 ~ 2147483647
    '單精度浮點型，在表示負數時，能表示的數據範圍：-3.402823 × E38 ~ -1.401298 × E-45
    '單精度浮點型，在表示正數時，能表示的數據範圍：1.401298 × E-45 ~ 3.402823 × E38
    '雙精度浮點型，在表示負數時，能表示的數據範圍：-1.79769313486231 × E308 ~ -4.94065645841247 × E-324
    '雙精度浮點型，在表示負數時，能表示的數據範圍：4.94065645841247 × E-324 ~ 1.79769313486231 × E308
    '注意，單精度浮點型數據，其精度是：6，即只能保存小數點後最多 6 位小數的數據，雙精度浮點型，其精度是：14，即只能保存小數點後最多 14 位小數的數據，如果超出以上長度，則超出部分會被刪除，並且會自動四捨五入。


    '刷新控制面板窗體控件中包含的提示標簽顯示值
    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
        DatabaseControlPanel.Controls("Database_status_Label").Caption = "從 Excel 表格中讀取 Post 請求的數據 read data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    End If


    Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

    Dim inputDataNameArray() As Variant: Rem Variant、String 聲明一個不定長二維數組變量，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataNameArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim inputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataArray(0 To X_UBound, 0 To Y_UBound) As Single: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim inputDataNameArray2() As Variant: Rem Variant、String 聲明一個不定長二維數組變量，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataNameArray2(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim inputDataArray2() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim inputDataArray2(0 To X_UBound, 0 To Y_UBound) As Single: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式

    Dim requestJSONArray() As Variant: Rem Variant、String、Integer、Long、Single、Double，聲明一個不定長一維數組變量，客戶端請求值一維數組，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    'ReDim requestJSONArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，客戶端請求值一維數組，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    Dim requestJSONDict As Object: Rem 客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
    'Set requestJSONDict = CreateObject("Scripting.Dictionary")

    Dim requestJSONText As String: Rem 向數據庫服務器發送的原始數據的 JSON 格式的字符串;
    requestJSONText = ""

    Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
    responseJSONText = ""

    Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;
    ''Set responseJSONDict = CreateObject("Scripting.Dictionary")
    Dim responseJSONArray As Variant: Rem Variant、String、Integer、Long、Single、Double，聲明一個不定長一維數組變量，數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;
    'ReDim responseJSONArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;

    '將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
    Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式
    Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
    'ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號，列號）格式

    '使用第三方模組（Module）：clsJsConverter，將原始數據字典 requestJSONDict 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
    Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。


    'Public_Database_module_name = "DatabaseModule": Rem 導入的鏈接操控數據庫模塊的自定義命名值字符串（當前所處的模塊名）

    'Public_Inject_data_page_JavaScript_filePath = "C:\Criss\vba\Statistics\StatisticsAlgorithmServer\test_injected.js": Rem 待插入目標數據源頁面的 JavaScript 脚本文檔路徑全名
    'Public_Inject_data_page_JavaScript = ";window.onbeforeunload = function(event) { event.returnValue = '是否現在就要離開本頁面？'+'///n'+'比如要不要先點擊 < 取消 > 關閉本頁面，在保存一下之後再離開呢？';};function NewFunction() { alert(window.document.getElementsByTagName('html')[0].outerHTML);  /* (function(j){})(j) 表示定義了一個，有一個形參（第一個 j ）的空匿名函數，然後以第二個 j 為實參進行調用; */;};": Rem 待插入目標數據源頁面的 JavaScript 脚本字符串


    Select Case Database_software

        Case Is = "Microsoft Office Access"

        Case Is = "MongoDB"

            Select Case Database_operational_order

                Case "Add data", "Delete data", "Add table(collection)", "Delete table(collection)"

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
                    If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
                    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
                    'ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_name_input_rangePosition <> "" Then
                        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        'inputDataNameArray = RNG: Rem RNG.Value
                        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        For i = 1 To RNG.Rows.Count
                            For j = 1 To RNG.Columns.Count
                                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            Next j
                        Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                        '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
                        '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                        '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                        '    'Next j
                        'Next i
                    End If

                    If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
                    ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
                    'ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_input_rangePosition <> "" Then
                        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        inputDataArray = RNG: Rem RNG.Value
                        ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        'For i = 1 To RNG.Rows.Count
                        '    For j = 1 To RNG.Columns.Count
                        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                        '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                        '    Next j
                        'Next i
                    End If

                    'Dim requestJSONDict As Object  '函數返回值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set requestJSONDict = CreateObject("Scripting.Dictionary")
                    'Debug.Print requestJSONDict.Count

                    '判斷一維數組 inputDataNameArray 是否爲空
                    'Dim Len_inputDataNameArray As Integer
                    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    'If Err.Number = 13 Then
                    Dim Len_inputDataNameArray As String
                    Len_inputDataNameArray = ""
                    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    Next j
                    'Next i
                    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    'If Len(Len_inputDataNameArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If
                    'Debug.Print Len(Len_inputDataNameArray)

                    '判斷二維數組 inputDataArray 是否爲空
                    'Dim Len_inputDataArray As Integer
                    'Len_inputDataArray = UBound(inputDataArray, 1)
                    'If Err.Number = 13 Then
                    '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
                    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '        DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    End If
                    '    Exit Sub
                    'End If
                    Dim Len_inputDataArray As String
                    Len_inputDataArray = ""
                    'Len_inputDataArray = Trim(Join(inputDataArray))
                    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                            'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                            Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
                        Next j
                    Next i
                    Len_inputDataArray = Trim(Len_inputDataArray)
                    'If Len(Len_inputDataArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If
                    'Debug.Print Len(Len_inputDataArray)


                    Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set rowDataDict = CreateObject("Scripting.Dictionary")
                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        Dim m, n As Integer
                        m = 0
                        n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) Then
                                    rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestJSONArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                            'Debug.Print LBound(requestJSONArray, 1)
                            'Debug.Print UBound(requestJSONArray, 1)
                            'Debug.Print requestJSONArray(i).Count()
                            'Debug.Print LBound(requestJSONArray(i).Keys())
                            'Debug.Print UBound(requestJSONArray(i).Keys())
                            'For m = LBound(requestJSONArray(i).Keys()) To UBound(requestJSONArray(i).Keys())
                            '    'Debug.Print requestJSONArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                            '    Debug.Print "requestJSONArray(" & CStr(i) & ").Item(" & requestJSONArray(i).Keys()(m) & ") = " & requestJSONArray(i).Item(requestJSONArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 1)
                        '    'Debug.Print requestJSONArray(m).Count()
                        '    'Debug.Print LBound(requestJSONArray(m).Keys())
                        '    'Debug.Print UBound(requestJSONArray(m).Keys())
                        '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                        '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) = 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print LBound(inputDataNameArray, 1)
                                'Debug.Print UBound(inputDataNameArray, 1)
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr("Column" & "-" & j)) Then
                                    rowDataDict.Item(CStr("Column" & "-" & j)) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr("Column" & "-" & j), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr("Column" & "-" & j) & ") = " & rowDataDict.Item(CStr("Column" & "-" & j))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestJSONArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                            'Debug.Print LBound(requestJSONArray, 1)
                            'Debug.Print UBound(requestJSONArray, 1)
                            'Debug.Print requestJSONArray(i).Count()
                            'Debug.Print LBound(requestJSONArray(i).Keys())
                            'Debug.Print UBound(requestJSONArray(i).Keys())
                            'For m = LBound(requestJSONArray(i).Keys()) To UBound(requestJSONArray(i).Keys())
                            '    'Debug.Print requestJSONArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                            '    Debug.Print "requestJSONArray(" & CStr(i) & ").Item(" & requestJSONArray(i).Keys()(m) & ") = " & requestJSONArray(i).Item(requestJSONArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 2)
                        '    'Debug.Print requestJSONArray(m).Count()
                        '    'Debug.Print LBound(requestJSONArray(m).Keys())
                        '    'Debug.Print UBound(requestJSONArray(m).Keys())
                        '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                        '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) = 0 Then

                        'ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式
                        ReDim requestJSONArray(1 To 1) As Variant

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        'Dim m, n As Integer
                        'm = 0
                        'n = 0

                        'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                        Set rowDataDict = CreateObject("Scripting.Dictionary")
                        rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                        For j = 1 To CInt(UBound(inputDataNameArray, 1) - LBound(inputDataNameArray, 1) + 1)

                            ''判斷本行（第 i 行）數據是否爲空字符串（""）
                            'If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                            '    Len_empty_Boolean = False
                            'End If

                            'Debug.Print LBound(inputDataNameArray, 1)
                            'Debug.Print UBound(inputDataNameArray, 1)
                            'Debug.Print inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)
                            'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                            '檢查字典中是否已經指定的鍵值對
                            If rowDataDict.Exists(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) Then
                                rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) = CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                            Else
                                rowDataDict.Add CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)), CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                            End If
                            'Debug.Print "rowDataDict.Item(" & CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)))

                            ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                            'If rowDataDict.Exists("testYdata_1") Then
                            '    rowDataDict.Remove ("testYdata_1")
                            'End If

                        Next j
                        'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                        '    'Debug.Print rowDataDict.Keys()(m)
                        '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    Debug.Print "rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                        'Next m

                        Set requestJSONArray(1) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                        'Debug.Print LBound(requestJSONArray, 1)
                        'Debug.Print UBound(requestJSONArray, 1)
                        'Debug.Print requestJSONArray(1).Count()
                        'Debug.Print LBound(requestJSONArray(1).Keys())
                        'Debug.Print UBound(requestJSONArray(1).Keys())
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 2)
                        '    'Debug.Print requestJSONArray(m).Count()
                        '    'Debug.Print LBound(requestJSONArray(m).Keys())
                        '    'Debug.Print UBound(requestJSONArray(m).Keys())
                        '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                        '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                        '    Next n
                        'Next m

                        '纍積記錄中的一個空行數據
                        If Len_empty_Boolean = True Then
                            Len_empty = Len_empty + 1
                        End If

                        'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    End If

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Len_empty = 0

                    ''循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放鏈接操控數據庫的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    'Len_empty = 0
                    'For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

                    '    '遍歷讀取逐列的數據推入一維數組
                    '    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                    '        'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        '判斷數組 inputDataArray 當前元素是否爲空字符串
                    '        If inputDataArray(i, j) = "" Then
                    '            Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
                    '        Else
                    '            columnDataArray(i) = inputDataArray(i, j)
                    '        End If
                    '        'Debug.Print columnDataArray(i)
                    '    Next i
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    If Len_empty <> 0 Then
                    '        If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                    '            ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        Else
                    '            'ReDim columnDataArray(0): Rem 清空數組
                    '            Erase columnDataArray: Rem 函數 Erase() 表示置空數組
                    '        End If
                    '    End If
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '判斷數組 inputDataNameArray 是否爲空
                    '    'Dim Len_inputDataNameArray As Integer
                    '    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    '    'If Err.Number = 13 Then
                    '    Dim Len_inputDataNameArray As String
                    '    Len_inputDataNameArray = ""
                    '    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    '    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    '    Next j
                    '    'Next i
                    '    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    '    If Len(Len_inputDataNameArray) = 0 Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    ElseIf inputDataNameArray(j) = "" Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    Else
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr(inputDataNameArray(j))) Then
                    '            requestJSONDict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    End If
                    '    'Debug.Print requestJSONDict.Item(CStr(inputDataNameArray(j)))

                    'Next j

                    ''Debug.Print requestJSONDict.Count
                    ''Debug.Print LBound(requestJSONDict.Keys())
                    ''Debug.Print UBound(requestJSONDict.Keys())
                    ''For i = LBound(requestJSONDict.Keys()) To UBound(requestJSONDict.Keys())
                    ''    'Debug.Print requestJSONDict.Keys()(i)
                    ''    'Debug.Print LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    'Debug.Print UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    For j = LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i)))) To UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''        Debug.Print requestJSONDict.Keys()(i) & ":(" & j & ") = " & requestJSONDict.Item(requestJSONDict.Keys()(i))(j)
                    ''    Next j
                    ''Next i

                    ''ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'Len_empty = 0
                    ''ReDim columnDataArray(0): Rem 清空數組，釋放内存
                    'Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存



                    ''將保存計算結果的二維數組變量 outputDataArray 手動轉換爲對應的 JSON 格式的字符串;
                    'Dim columnName() As String: Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'columnName(1) = "Column_1"
                    'columnName(2) = "Column_2"
                    ''For i = 1 To UBound(columnName, 1)
                    ''    Debug.Print columnName(i)
                    ''Next i

                    'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
                    'PostCode = ""
                    'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
                    'PostCode = "{" & """Column_1""" & ":" & """" & CStr(inputDataArray(1, 1)) & """" & "," _
                    '         & """Column_2""" & ":" & """" & CStr(inputDataArray(1, 2)) & """" & "}" _
                    '         & """Column_3""" & ":" & """" & CStr(inputDataArray(1, 3)) & """" & "," _
                    '         & """Column_4""" & ":" & """" & CStr(inputDataArray(1, 4)) & """" & "," _
                    '         & """Column_5""" & ":" & """" & CStr(inputDataArray(1, 5)) & """" & "," _
                    '         & """Column_6""" & ":" & """" & CStr(inputDataArray(1, 6)) & """" & "," _
                    '         & """Column_7""" & ":" & """" & CStr(inputDataArray(1, 7)) & """" & "," _
                    '         & """Column_8""" & ":" & """" & CStr(inputDataArray(1, 8)) & """" & "," _
                    '         & """Column_9""" & ":" & """" & CStr(inputDataArray(1, 9)) & """" & "," _
                    '         & """Column_10""" & ":" & """" & CStr(inputDataArray(1, 10)) & """" & "," _
                    '         & """Column_11""" & ":" & """" & CStr(inputDataArray(1, 11)) & """" & "," _
                    '         & """Column_12""" & ":" & """" & CStr(inputDataArray(1, 12)) & """" & "}"

                    ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    PostCode = ""
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (j = UBound(inputDataArray, 2)) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & "]"
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & "]"
                    '            End If
                    '        End If
                    '    Next j
                    '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                    '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

                    '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    '    '讀取服務器返回的響應值
                    '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    '    Response_Text = WHR.responseText
                    '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'Debug.Print Response_Text

                    'Next i


                    ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'PostCode = "["
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (i < UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & ","
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & ","
                    '            End If
                    '        End If
                    '        If (i = UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}"
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}"
                    '            End If
                    '        End If
                    '    Next j
                    'Next i
                    'PostCode = PostCode & "]"
                    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                Case "Retrieve count", "Retrieve data", "SQL"

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
                    If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
                    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
                    'ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_name_input_rangePosition <> "" Then
                        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        'inputDataNameArray = RNG: Rem RNG.Value
                        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        For i = 1 To RNG.Rows.Count
                            For j = 1 To RNG.Columns.Count
                                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            Next j
                        Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                        '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
                        '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                        '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                        '    'Next j
                        'Next i
                    End If

                    If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
                    ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
                    'ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_input_rangePosition <> "" Then
                        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        'inputDataArray = RNG: Rem RNG.Value
                        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        For i = 1 To RNG.Rows.Count
                            For j = 1 To RNG.Columns.Count
                                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                                inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            Next j
                        Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                        '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                        '    Next j
                        'Next i
                    End If

                    'Dim requestJSONDict As Object  '函數返回值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set requestJSONDict = CreateObject("Scripting.Dictionary")
                    'Debug.Print requestJSONDict.Count

                    '判斷一維數組 inputDataNameArray 是否爲空
                    'Dim Len_inputDataNameArray As Integer
                    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    'If Err.Number = 13 Then
                    'Dim Len_inputDataNameArray As String
                    Len_inputDataNameArray = ""
                    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    Next j
                    'Next i
                    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    'If Len(Len_inputDataNameArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If
                    'Debug.Print Len(Len_inputDataNameArray)

                    '判斷二維數組 inputDataArray 是否爲空
                    'Dim Len_inputDataArray As Integer
                    'Len_inputDataArray = UBound(inputDataArray, 1)
                    'If Err.Number = 13 Then
                    '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
                    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '        DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    End If
                    '    Exit Sub
                    'End If
                    'Dim Len_inputDataArray As String
                    Len_inputDataArray = ""
                    'Len_inputDataArray = Trim(Join(inputDataArray))
                    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                            'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                            Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
                        Next j
                    Next i
                    Len_inputDataArray = Trim(Len_inputDataArray)
                    'If Len(Len_inputDataArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If
                    'Debug.Print Len(Len_inputDataArray)


                    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set rowDataDict = CreateObject("Scripting.Dictionary")
                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    'Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) > 0 Then

                        'ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        ''循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        ''Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        ''Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        'Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                        '    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                        '    Set rowDataDict = CreateObject("Scripting.Dictionary")
                        '    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        '    Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                        '    For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                        '        '判斷本行（第 i 行）數據是否爲空字符串（""）
                        '        If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                        '            Len_empty_Boolean = False
                        '        End If

                        '        'Debug.Print inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                        '        'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                        '        '檢查字典中是否已經指定的鍵值對
                        '        If rowDataDict.Exists(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) Then
                        '            rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                        '        Else
                        '            rowDataDict.Add CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                        '        End If
                        '        'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))))

                        '        ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                        '        'If rowDataDict.Exists("testYdata_1") Then
                        '        '    rowDataDict.Remove ("testYdata_1")
                        '        'End If

                        '    Next j
                        '    'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                        '    '    'Debug.Print rowDataDict.Keys()(m)
                        '    '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                        '    'Next m

                        '    Set requestJSONArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 1)
                        '    'Debug.Print requestJSONArray(i).Count()
                        '    'Debug.Print LBound(requestJSONArray(i).Keys())
                        '    'Debug.Print UBound(requestJSONArray(i).Keys())
                        '    'For m = LBound(requestJSONArray(i).Keys()) To UBound(requestJSONArray(i).Keys())
                        '    '    'Debug.Print requestJSONArray(i).Keys()(m)
                        '    '    'Debug.Print LBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                        '    '    'Debug.Print UBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                        '    '    Debug.Print "requestJSONArray(" & CStr(i) & ").Item(" & requestJSONArray(i).Keys()(m) & ") = " & requestJSONArray(i).Item(requestJSONArray(i).Keys()(m))
                        '    'Next m

                        '    '纍積記錄中的一個空行數據
                        '    If Len_empty_Boolean = True Then
                        '        Len_empty = Len_empty + 1
                        '    End If

                        '    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        'Next i

                        ReDim requestJSONArray(1 To CInt(CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) * CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1))) As Variant
                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)

                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行

                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print "inputDataNameArray(" & CStr(LBound(inputDataNameArray, 1) + CInt(j) - 1) & ") = " & inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                                'Debug.Print "inputDataArray(" & CStr(LBound(inputDataArray, 1) + CInt(i) - 1) & "," & CStr((LBound(inputDataArray, 2) + CInt(j) - 1)) & ") = " & inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))


                                ''使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                                ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                                ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                                ''requestJSONText = JsonConverter.ConvertToJson(requestJSONArray, Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                                'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                                ''Debug.Print requestJSONText

                                'Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                                ''Debug.Print responseJSONDict.Count
                                ''Debug.Print LBound(responseJSONDict.Keys())

                                'requestJSONArray(CInt(CInt(i - 1) * j) + j) = CStr(JsonConverter.ConvertToJson(JsonConverter.ParseJson(inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))))): Rem 將二維數組 inputDataArray 中的數據逐個（1R1C -> 1R2C -> ... -> 1RnC -> 2R1C -> 2R2C -> ... -> 2RnC -> ... -> nRnC）推入一維數組 requestJSONArray 中的第「(i - 1) * j + j」個元素;
                                requestJSONArray(CInt(CInt(i - 1) * j) + j) = CStr(inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))): Rem 將二維數組 inputDataArray 中的數據逐個（1R1C -> 1R2C -> ... -> 1RnC -> 2R1C -> 2R2C -> ... -> 2RnC -> ... -> nRnC）推入一維數組 requestJSONArray 中的第「(i - 1) * j + j」個元素;
                                'Debug.Print "requestJSONArray(" & CStr(CInt(CInt(i - 1) * j) + j) & ") = " & requestJSONArray(CInt(CInt(i - 1) * j) + j)


                                '纍積記錄中的一個空行數據
                                If Len_empty_Boolean = True Then
                                    Len_empty = Len_empty + 1
                                End If

                            Next j

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 1)
                        '    'Debug.Print requestJSONArray(m).Count()
                        '    'Debug.Print LBound(requestJSONArray(m).Keys())
                        '    'Debug.Print UBound(requestJSONArray(m).Keys())
                        '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                        '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) = 0 And Len(Len_inputDataArray) > 0 Then

                        'ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        ''循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        ''Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        ''Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        'Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                        '    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                        '    Set rowDataDict = CreateObject("Scripting.Dictionary")
                        '    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        '    Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                        '    For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                        '        '判斷本行（第 i 行）數據是否爲空字符串（""）
                        '        If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                        '            Len_empty_Boolean = False
                        '        End If

                        '        'Debug.Print LBound(inputDataNameArray, 1)
                        '        'Debug.Print UBound(inputDataNameArray, 1)
                        '        'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                        '        '檢查字典中是否已經指定的鍵值對
                        '        If rowDataDict.Exists(CStr("Column" & "-" & j)) Then
                        '            rowDataDict.Item(CStr("Column" & "-" & j)) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                        '        Else
                        '            rowDataDict.Add CStr("Column" & "-" & j), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                        '        End If
                        '        'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr("Column" & "-" & j) & ") = " & rowDataDict.Item(CStr("Column" & "-" & j))

                        '        ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                        '        'If rowDataDict.Exists("testYdata_1") Then
                        '        '    rowDataDict.Remove ("testYdata_1")
                        '        'End If

                        '    Next j
                        '    'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                        '    '    'Debug.Print rowDataDict.Keys()(m)
                        '    '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                        '    'Next m

                        '    Set requestJSONArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 1)
                        '    'Debug.Print requestJSONArray(i).Count()
                        '    'Debug.Print LBound(requestJSONArray(i).Keys())
                        '    'Debug.Print UBound(requestJSONArray(i).Keys())
                        '    'For m = LBound(requestJSONArray(i).Keys()) To UBound(requestJSONArray(i).Keys())
                        '    '    'Debug.Print requestJSONArray(i).Keys()(m)
                        '    '    'Debug.Print LBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                        '    '    'Debug.Print UBound(requestJSONArray(i).Item(CStr(requestJSONArray(i).Keys()(m))))
                        '    '    Debug.Print "requestJSONArray(" & CStr(i) & ").Item(" & requestJSONArray(i).Keys()(m) & ") = " & requestJSONArray(i).Item(requestJSONArray(i).Keys()(m))
                        '    'Next m

                        '    '纍積記錄中的一個空行數據
                        '    If Len_empty_Boolean = True Then
                        '        Len_empty = Len_empty + 1
                        '    End If

                        '    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        'Next i

                        ReDim requestJSONArray(1 To CInt(CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) * CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1))) As Variant
                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)

                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行

                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print "inputDataNameArray(" & CStr(LBound(inputDataNameArray, 1) + CInt(j) - 1) & ") = " & inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                                'Debug.Print "inputDataArray(" & CStr(LBound(inputDataArray, 1) + CInt(i) - 1) & "," & CStr((LBound(inputDataArray, 2) + CInt(j) - 1)) & ") = " & inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))


                                ''使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                                ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                                ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                                ''requestJSONText = JsonConverter.ConvertToJson(requestJSONArray, Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                                'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                                ''Debug.Print requestJSONText

                                'Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                                ''Debug.Print responseJSONDict.Count
                                ''Debug.Print LBound(responseJSONDict.Keys())

                                'requestJSONArray(CInt(CInt(i - 1) * j) + j) = CStr(JsonConverter.ConvertToJson(JsonConverter.ParseJson(inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))))): Rem 將二維數組 inputDataArray 中的數據逐個（1R1C -> 1R2C -> ... -> 1RnC -> 2R1C -> 2R2C -> ... -> 2RnC -> ... -> nRnC）推入一維數組 requestJSONArray 中的第「(i - 1) * j + j」個元素;
                                requestJSONArray(CInt(CInt(i - 1) * j) + j) = CStr(inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))): Rem 將二維數組 inputDataArray 中的數據逐個（1R1C -> 1R2C -> ... -> 1RnC -> 2R1C -> 2R2C -> ... -> 2RnC -> ... -> nRnC）推入一維數組 requestJSONArray 中的第「(i - 1) * j + j」個元素;
                                'Debug.Print "requestJSONArray(" & CStr(CInt(CInt(i - 1) * j) + j) & ") = " & requestJSONArray(CInt(CInt(i - 1) * j) + j)


                                '纍積記錄中的一個空行數據
                                If Len_empty_Boolean = True Then
                                    Len_empty = Len_empty + 1
                                End If

                            Next j

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                        '    'Debug.Print LBound(requestJSONArray, 1)
                        '    'Debug.Print UBound(requestJSONArray, 2)
                        '    'Debug.Print requestJSONArray(m).Count()
                        '    'Debug.Print LBound(requestJSONArray(m).Keys())
                        '    'Debug.Print UBound(requestJSONArray(m).Keys())
                        '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                        '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    'If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) = 0 Then

                    '    'ReDim requestJSONArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式
                    '    ReDim requestJSONArray(1 To 1) As Variant

                    '    '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                    '    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    '    Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    '    'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                    '    Len_empty_Boolean = True
                    '    'Dim m, n As Integer
                    '    'm = 0
                    '    'n = 0

                    '    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestJSONArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    '    Set rowDataDict = CreateObject("Scripting.Dictionary")
                    '    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    '    Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                    '    For j = 1 To CInt(UBound(inputDataNameArray, 1) - LBound(inputDataNameArray, 1) + 1)

                    '        ''判斷本行（第 i 行）數據是否爲空字符串（""）
                    '        'If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                    '        '    Len_empty_Boolean = False
                    '        'End If

                    '        'Debug.Print LBound(inputDataNameArray, 1)
                    '        'Debug.Print UBound(inputDataNameArray, 1)
                    '        'Debug.Print inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)
                    '        'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                    '        '檢查字典中是否已經指定的鍵值對
                    '        If rowDataDict.Exists(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) Then
                    '            rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) = CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                    '        Else
                    '            rowDataDict.Add CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)), CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                    '        End If
                    '        'Debug.Print "rowDataDict.Item(" & CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)))

                    '        ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                    '        'If rowDataDict.Exists("testYdata_1") Then
                    '        '    rowDataDict.Remove ("testYdata_1")
                    '        'End If

                    '    Next j
                    '    'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                    '    '    'Debug.Print rowDataDict.Keys()(m)
                    '    '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                    '    '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                    '    '    Debug.Print "rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                    '    'Next m

                    '    Set requestJSONArray(1) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestJSONArray 中包含的一個元素，推入一維數組 requestJSONArray 中的第 i 個元素;
                    '    'Debug.Print LBound(requestJSONArray, 1)
                    '    'Debug.Print UBound(requestJSONArray, 1)
                    '    'Debug.Print requestJSONArray(1).Count()
                    '    'Debug.Print LBound(requestJSONArray(1).Keys())
                    '    'Debug.Print UBound(requestJSONArray(1).Keys())
                    '    'Dim m, n As Integer
                    '    'm = 0
                    '    'n = 0
                    '    'For m = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    '    'Debug.Print LBound(requestJSONArray, 1)
                    '    '    'Debug.Print UBound(requestJSONArray, 2)
                    '    '    'Debug.Print requestJSONArray(m).Count()
                    '    '    'Debug.Print LBound(requestJSONArray(m).Keys())
                    '    '    'Debug.Print UBound(requestJSONArray(m).Keys())
                    '    '    For n = LBound(requestJSONArray(m).Keys()) To UBound(requestJSONArray(m).Keys())
                    '    '        Debug.Print "requestJSONArray(" & m & ").Item(" & requestJSONArray(m).Keys()(n) & ") = " & requestJSONArray(m).Item(requestJSONArray(m).Keys()(n))
                    '    '    Next n
                    '    'Next m

                    '    '纍積記錄中的一個空行數據
                    '    If Len_empty_Boolean = True Then
                    '        Len_empty = Len_empty + 1
                    '    End If

                    '    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    '    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    'End If

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Len_empty = 0

                    ''循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放鏈接操控數據庫的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    'For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

                    '    '遍歷讀取逐列的數據推入一維數組
                    '    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                    '        'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        '判斷數組 inputDataArray 當前元素是否爲空字符串
                    '        If inputDataArray(i, j) = "" Then
                    '            Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
                    '        Else
                    '            columnDataArray(i) = inputDataArray(i, j)
                    '        End If
                    '        'Debug.Print columnDataArray(i)
                    '    Next i
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    If Len_empty <> 0 Then
                    '        If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                    '            ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        Else
                    '            'ReDim columnDataArray(0): Rem 清空數組
                    '            Erase columnDataArray: Rem 函數 Erase() 表示置空數組
                    '        End If
                    '    End If
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '判斷數組 inputDataNameArray 是否爲空
                    '    'Dim Len_inputDataNameArray As Integer
                    '    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    '    'If Err.Number = 13 Then
                    '    Dim Len_inputDataNameArray As String
                    '    Len_inputDataNameArray = ""
                    '    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    '    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    '    Next j
                    '    'Next i
                    '    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    '    If Len(Len_inputDataNameArray) = 0 Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    ElseIf inputDataNameArray(j) = "" Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    Else
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr(inputDataNameArray(j))) Then
                    '            requestJSONDict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    End If
                    '    'Debug.Print requestJSONDict.Item(CStr(inputDataNameArray(j)))

                    'Next j

                    ''Debug.Print requestJSONDict.Count
                    ''Debug.Print LBound(requestJSONDict.Keys())
                    ''Debug.Print UBound(requestJSONDict.Keys())
                    ''For i = LBound(requestJSONDict.Keys()) To UBound(requestJSONDict.Keys())
                    ''    'Debug.Print requestJSONDict.Keys()(i)
                    ''    'Debug.Print LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    'Debug.Print UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    For j = LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i)))) To UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''        Debug.Print requestJSONDict.Keys()(i) & ":(" & j & ") = " & requestJSONDict.Item(requestJSONDict.Keys()(i))(j)
                    ''    Next j
                    ''Next i

                    ''ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'Len_empty = 0
                    ''ReDim columnDataArray(0): Rem 清空數組，釋放内存
                    'Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存



                    ''將保存計算結果的二維數組變量 outputDataArray 手動轉換爲對應的 JSON 格式的字符串;
                    'Dim columnName() As String: Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'columnName(1) = "Column_1"
                    'columnName(2) = "Column_2"
                    ''For i = 1 To UBound(columnName, 1)
                    ''    Debug.Print columnName(i)
                    ''Next i

                    'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
                    'PostCode = ""
                    'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
                    'PostCode = "{" & """Column_1""" & ":" & """" & CStr(inputDataArray(1, 1)) & """" & "," _
                    '         & """Column_2""" & ":" & """" & CStr(inputDataArray(1, 2)) & """" & "}" _
                    '         & """Column_3""" & ":" & """" & CStr(inputDataArray(1, 3)) & """" & "," _
                    '         & """Column_4""" & ":" & """" & CStr(inputDataArray(1, 4)) & """" & "," _
                    '         & """Column_5""" & ":" & """" & CStr(inputDataArray(1, 5)) & """" & "," _
                    '         & """Column_6""" & ":" & """" & CStr(inputDataArray(1, 6)) & """" & "," _
                    '         & """Column_7""" & ":" & """" & CStr(inputDataArray(1, 7)) & """" & "," _
                    '         & """Column_8""" & ":" & """" & CStr(inputDataArray(1, 8)) & """" & "," _
                    '         & """Column_9""" & ":" & """" & CStr(inputDataArray(1, 9)) & """" & "," _
                    '         & """Column_10""" & ":" & """" & CStr(inputDataArray(1, 10)) & """" & "," _
                    '         & """Column_11""" & ":" & """" & CStr(inputDataArray(1, 11)) & """" & "," _
                    '         & """Column_12""" & ":" & """" & CStr(inputDataArray(1, 12)) & """" & "}"

                    ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    PostCode = ""
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (j = UBound(inputDataArray, 2)) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & "]"
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & "]"
                    '            End If
                    '        End If
                    '    Next j
                    '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                    '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

                    '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    '    '讀取服務器返回的響應值
                    '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    '    Response_Text = WHR.responseText
                    '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'Debug.Print Response_Text

                    'Next i


                    ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'PostCode = "["
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (i < UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & ","
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & ","
                    '            End If
                    '        End If
                    '        If (i = UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}"
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}"
                    '            End If
                    '        End If
                    '    Next j
                    'Next i
                    'PostCode = PostCode & "]"
                    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                Case Is = "Update data"

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
                    If (Data_name_input_sheetName <> "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_name_input_sheetName).Range(Data_name_input_rangePosition)
                    ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_name_input_rangePosition)
                    'ElseIf (Data_name_input_sheetName = "") And (Data_name_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_name_input_rangePosition <> "" Then
                        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        'inputDataNameArray = RNG: Rem RNG.Value
                        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        For i = 1 To RNG.Rows.Count
                            For j = 1 To RNG.Columns.Count
                                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            Next j
                        Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                        '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
                        '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                        '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                        '    'Next j
                        'Next i
                    End If

                    If (Data_input_sheetName <> "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Data_input_sheetName).Range(Data_input_rangePosition)
                    ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Data_input_rangePosition)
                    'ElseIf (Data_input_sheetName = "") And (Data_input_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Data_input_rangePosition <> "" Then
                        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        inputDataArray = RNG: Rem RNG.Value
                        ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        'For i = 1 To RNG.Rows.Count
                        '    For j = 1 To RNG.Columns.Count
                        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                        '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                        '    Next j
                        'Next i
                    End If

                    'Dim requestJSONDict As Object  '函數返回值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set requestJSONDict = CreateObject("Scripting.Dictionary")
                    'Debug.Print requestJSONDict.Count

                    '判斷一維數組 inputDataNameArray 是否爲空
                    'Dim Len_inputDataNameArray As Integer
                    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    'If Err.Number = 13 Then
                    'Dim Len_inputDataNameArray As String
                    Len_inputDataNameArray = ""
                    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    Next j
                    'Next i
                    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    'If Len(Len_inputDataNameArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If

                    '判斷二維數組 inputDataArray 是否爲空
                    'Dim Len_inputDataArray As Integer
                    'Len_inputDataArray = UBound(inputDataArray, 1)
                    'If Err.Number = 13 Then
                    '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
                    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '        DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    End If
                    '    Exit Sub
                    'End If
                    'Dim Len_inputDataArray As String
                    Len_inputDataArray = ""
                    'Len_inputDataArray = Trim(Join(inputDataArray))
                    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                            'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                            Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
                        Next j
                    Next i
                    Len_inputDataArray = Trim(Len_inputDataArray)
                    'If Len(Len_inputDataArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If

                    'Dim requestOldDataArray() As Variant: Rem Variant、String、Integer、Long、Single、Double，聲明一個不定長一維數組變量，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    ReDim requestOldDataArray(0)
                    'ReDim requestOldDataArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;

                    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestOldDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set rowDataDict = CreateObject("Scripting.Dictionary")
                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    'Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestOldDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestOldDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) Then
                                    rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestOldDataArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestOldDataArray 中包含的一個元素，推入一維數組 requestOldDataArray 中的第 i 個元素;
                            'Debug.Print LBound(requestOldDataArray, 1)
                            'Debug.Print UBound(requestOldDataArray, 1)
                            'Debug.Print requestOldDataArray(i).Count()
                            'Debug.Print LBound(requestOldDataArray(i).Keys())
                            'Debug.Print UBound(requestOldDataArray(i).Keys())
                            'For m = LBound(requestOldDataArray(i).Keys()) To UBound(requestOldDataArray(i).Keys())
                            '    'Debug.Print requestOldDataArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestOldDataArray(i).Item(CStr(requestOldDataArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestOldDataArray(i).Item(CStr(requestOldDataArray(i).Keys()(m))))
                            '    Debug.Print "requestOldDataArray(" & CStr(i) & ").Item(" & requestOldDataArray(i).Keys()(m) & ") = " & requestOldDataArray(i).Item(requestOldDataArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestOldDataArray, 1) To UBound(requestOldDataArray, 1)
                        '    'Debug.Print LBound(requestOldDataArray, 1)
                        '    'Debug.Print UBound(requestOldDataArray, 1)
                        '    'Debug.Print requestOldDataArray(m).Count()
                        '    'Debug.Print LBound(requestOldDataArray(m).Keys())
                        '    'Debug.Print UBound(requestOldDataArray(m).Keys())
                        '    For n = LBound(requestOldDataArray(m).Keys()) To UBound(requestOldDataArray(m).Keys())
                        '        Debug.Print "requestOldDataArray(" & m & ").Item(" & requestOldDataArray(m).Keys()(n) & ") = " & requestOldDataArray(m).Item(requestOldDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) = 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestOldDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestOldDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print LBound(inputDataNameArray, 1)
                                'Debug.Print UBound(inputDataNameArray, 1)
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr("Column" & "-" & j)) Then
                                    rowDataDict.Item(CStr("Column" & "-" & j)) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr("Column" & "-" & j), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr("Column" & "-" & j) & ") = " & rowDataDict.Item(CStr("Column" & "-" & j))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestOldDataArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestOldDataArray 中包含的一個元素，推入一維數組 requestOldDataArray 中的第 i 個元素;
                            'Debug.Print LBound(requestOldDataArray, 1)
                            'Debug.Print UBound(requestOldDataArray, 1)
                            'Debug.Print requestOldDataArray(i).Count()
                            'Debug.Print LBound(requestOldDataArray(i).Keys())
                            'Debug.Print UBound(requestOldDataArray(i).Keys())
                            'For m = LBound(requestOldDataArray(i).Keys()) To UBound(requestOldDataArray(i).Keys())
                            '    'Debug.Print requestOldDataArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestOldDataArray(i).Item(CStr(requestOldDataArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestOldDataArray(i).Item(CStr(requestOldDataArray(i).Keys()(m))))
                            '    Debug.Print "requestOldDataArray(" & CStr(i) & ").Item(" & requestOldDataArray(i).Keys()(m) & ") = " & requestOldDataArray(i).Item(requestOldDataArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestOldDataArray, 1) To UBound(requestOldDataArray, 1)
                        '    'Debug.Print LBound(requestOldDataArray, 1)
                        '    'Debug.Print UBound(requestOldDataArray, 2)
                        '    'Debug.Print requestOldDataArray(m).Count()
                        '    'Debug.Print LBound(requestOldDataArray(m).Keys())
                        '    'Debug.Print UBound(requestOldDataArray(m).Keys())
                        '    For n = LBound(requestOldDataArray(m).Keys()) To UBound(requestOldDataArray(m).Keys())
                        '        Debug.Print "requestOldDataArray(" & m & ").Item(" & requestOldDataArray(m).Keys()(n) & ") = " & requestOldDataArray(m).Item(requestOldDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) = 0 Then

                        'ReDim requestOldDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式
                        ReDim requestOldDataArray(1 To 1) As Variant

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        'Dim m, n As Integer
                        'm = 0
                        'n = 0

                        'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestOldDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                        Set rowDataDict = CreateObject("Scripting.Dictionary")
                        rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                        For j = 1 To CInt(UBound(inputDataNameArray, 1) - LBound(inputDataNameArray, 1) + 1)

                            ''判斷本行（第 i 行）數據是否爲空字符串（""）
                            'If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                            '    Len_empty_Boolean = False
                            'End If

                            'Debug.Print LBound(inputDataNameArray, 1)
                            'Debug.Print UBound(inputDataNameArray, 1)
                            'Debug.Print inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)
                            'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                            '檢查字典中是否已經指定的鍵值對
                            If rowDataDict.Exists(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) Then
                                rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) = CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                            Else
                                rowDataDict.Add CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)), CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                            End If
                            'Debug.Print "rowDataDict.Item(" & CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)))

                            ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                            'If rowDataDict.Exists("testYdata_1") Then
                            '    rowDataDict.Remove ("testYdata_1")
                            'End If

                        Next j
                        'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                        '    'Debug.Print rowDataDict.Keys()(m)
                        '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    Debug.Print "rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                        'Next m

                        Set requestOldDataArray(1) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestOldDataArray 中包含的一個元素，推入一維數組 requestOldDataArray 中的第 i 個元素;
                        'Debug.Print LBound(requestOldDataArray, 1)
                        'Debug.Print UBound(requestOldDataArray, 1)
                        'Debug.Print requestOldDataArray(1).Count()
                        'Debug.Print LBound(requestOldDataArray(1).Keys())
                        'Debug.Print UBound(requestOldDataArray(1).Keys())
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestOldDataArray, 1) To UBound(requestOldDataArray, 1)
                        '    'Debug.Print LBound(requestOldDataArray, 1)
                        '    'Debug.Print UBound(requestOldDataArray, 2)
                        '    'Debug.Print requestOldDataArray(m).Count()
                        '    'Debug.Print LBound(requestOldDataArray(m).Keys())
                        '    'Debug.Print UBound(requestOldDataArray(m).Keys())
                        '    For n = LBound(requestOldDataArray(m).Keys()) To UBound(requestOldDataArray(m).Keys())
                        '        Debug.Print "requestOldDataArray(" & m & ").Item(" & requestOldDataArray(m).Keys()(n) & ") = " & requestOldDataArray(m).Item(requestOldDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                        '纍積記錄中的一個空行數據
                        If Len_empty_Boolean = True Then
                            Len_empty = Len_empty + 1
                        End If

                        'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    End If

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Len_empty = 0


                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域
                    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的選擇範圍（Data name input = " & CStr(Public_Field_name_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Result_name_output_rangePosition <> "" Then
                        'ReDim inputDataNameArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、String 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        'inputDataNameArray = RNG: Rem RNG.Value
                        '使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        ReDim inputDataNameArray(1 To CInt(RNG.Rows.Count * RNG.Columns.Count)) As Variant: Rem 更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的的自定義名稱值字符串，注意 VBA 的二維數組索引是（行號，列號）格式
                        For i = 1 To RNG.Rows.Count
                            For j = 1 To RNG.Columns.Count
                                'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                                inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                'inputDataNameArray(CInt((i - 1) * RNG.Columns.Count) + j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            Next j
                        Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                        '    Debug.Print "inputDataNameArray:(" & i & ") = " & inputDataNameArray(i)
                        '    'For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                        '    '    Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                        '    'Next j
                        'Next i
                    End If

                    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then
                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then
                    '    Debug.Print "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'MsgBox "用於向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的選擇範圍（Data input = " & CStr(Public_Field_data_input_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    Else
                    End If
                    If Result_output_rangePosition <> "" Then
                        ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Variant、Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        inputDataArray = RNG: Rem RNG.Value
                        ''使用 For 循環嵌套遍歷的方法，將 Excel 工作表的單元格中的值寫入二維數組，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'ReDim inputDataArray(1 To RNG.Rows.Count, 1 To RNG.Columns.Count) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值，注意 VBA 的二維數組索引是（行號，列號）格式
                        'For i = 1 To RNG.Rows.Count
                        '    For j = 1 To RNG.Columns.Count
                        '        'Debug.Print "Cells(" & CInt(CInt(RNG.Row) + CInt(i - 1)) & ", " & CInt(CInt(RNG.Column) + CInt(j - 1)) & ") = " & Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值
                        '        inputDataArray(i, j) = Cells(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'inputDataArray(i, j) = Range(CInt(CInt(RNG.Row) + CInt(i - 1)), CInt(CInt(RNG.Column) + CInt(j - 1))).Value: Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i
                        Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        'For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        '    For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                        '        Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                        '    Next j
                        'Next i
                    End If

                    'Dim requestJSONDict As Object  '函數返回值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set requestJSONDict = CreateObject("Scripting.Dictionary")
                    'Debug.Print requestJSONDict.Count

                    '判斷一維數組 inputDataNameArray 是否爲空
                    'Dim Len_inputDataNameArray As Integer
                    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    'If Err.Number = 13 Then
                    'Dim Len_inputDataNameArray As String
                    Len_inputDataNameArray = ""
                    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    Next j
                    'Next i
                    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    'If Len(Len_inputDataNameArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據字段自定義命名字符串值的一維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If

                    '判斷二維數組 inputDataArray 是否爲空
                    'Dim Len_inputDataArray As Integer
                    'Len_inputDataArray = UBound(inputDataArray, 1)
                    'If Err.Number = 13 Then
                    '    MsgBox "保存用於統計運算的原始數據的二維數組爲空."
                    '    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '        DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    End If
                    '    Exit Sub
                    'End If
                    'Dim Len_inputDataArray As String
                    Len_inputDataArray = ""
                    'Len_inputDataArray = Trim(Join(inputDataArray))
                    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                        For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)
                            'Debug.Print "inputDataArray:(" & i & ", " & j & ") = " & inputDataArray(i, j)
                            Len_inputDataArray = Len_inputDataArray & inputDataArray(i, j)
                        Next j
                    Next i
                    Len_inputDataArray = Trim(Len_inputDataArray)
                    'If Len(Len_inputDataArray) = 0 Then
                    '    Debug.Print "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    'MsgBox "保存用於操控數據庫的原始數據的二維數組爲空."
                    '    ''刷新控制面板窗體控件中包含的提示標簽顯示值
                    '    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                    '    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    '    'End If
                    '    'Exit Sub
                    'End If


                    'Dim requestNewDataArray() As Variant: Rem Variant、String、Integer、Long、Single、Double，聲明一個不定長一維數組變量，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    ReDim requestNewDataArray(0)
                    'ReDim requestNewDataArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;

                    'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestNewDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    'Set rowDataDict = CreateObject("Scripting.Dictionary")
                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    'Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestNewDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestNewDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) Then
                                    rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1)))) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(CInt(LBound(inputDataNameArray, 1) + CInt(j) - 1))))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestNewDataArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestNewDataArray 中包含的一個元素，推入一維數組 requestNewDataArray 中的第 i 個元素;
                            'Debug.Print LBound(requestNewDataArray, 1)
                            'Debug.Print UBound(requestNewDataArray, 1)
                            'Debug.Print requestNewDataArray(i).Count()
                            'Debug.Print LBound(requestNewDataArray(i).Keys())
                            'Debug.Print UBound(requestNewDataArray(i).Keys())
                            'For m = LBound(requestNewDataArray(i).Keys()) To UBound(requestNewDataArray(i).Keys())
                            '    'Debug.Print requestNewDataArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestNewDataArray(i).Item(CStr(requestNewDataArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestNewDataArray(i).Item(CStr(requestNewDataArray(i).Keys()(m))))
                            '    Debug.Print "requestNewDataArray(" & CStr(i) & ").Item(" & requestNewDataArray(i).Keys()(m) & ") = " & requestNewDataArray(i).Item(requestNewDataArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestNewDataArray, 1) To UBound(requestNewDataArray, 1)
                        '    'Debug.Print LBound(requestNewDataArray, 1)
                        '    'Debug.Print UBound(requestNewDataArray, 1)
                        '    'Debug.Print requestNewDataArray(m).Count()
                        '    'Debug.Print LBound(requestNewDataArray(m).Keys())
                        '    'Debug.Print UBound(requestNewDataArray(m).Keys())
                        '    For n = LBound(requestNewDataArray(m).Keys()) To UBound(requestNewDataArray(m).Keys())
                        '        Debug.Print "requestNewDataArray(" & m & ").Item(" & requestNewDataArray(m).Keys()(n) & ") = " & requestNewDataArray(m).Item(requestNewDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) = 0 And Len(Len_inputDataArray) > 0 Then

                        ReDim requestNewDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        For i = 1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)
                            'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestNewDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                            Set rowDataDict = CreateObject("Scripting.Dictionary")
                            rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                            For j = 1 To CInt(UBound(inputDataArray, 2) - LBound(inputDataArray, 2) + 1)

                                '判斷本行（第 i 行）數據是否爲空字符串（""）
                                If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                                    Len_empty_Boolean = False
                                End If

                                'Debug.Print LBound(inputDataNameArray, 1)
                                'Debug.Print UBound(inputDataNameArray, 1)
                                'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                                '檢查字典中是否已經指定的鍵值對
                                If rowDataDict.Exists(CStr("Column" & "-" & j)) Then
                                    rowDataDict.Item(CStr("Column" & "-" & j)) = inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                                Else
                                    rowDataDict.Add CStr("Column" & "-" & j), inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                                End If
                                'Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & CStr("Column" & "-" & j) & ") = " & rowDataDict.Item(CStr("Column" & "-" & j))

                                ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                                'If rowDataDict.Exists("testYdata_1") Then
                                '    rowDataDict.Remove ("testYdata_1")
                                'End If

                            Next j
                            'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                            '    'Debug.Print rowDataDict.Keys()(m)
                            '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                            '    Debug.Print "(" & CStr(i) & ") rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                            'Next m

                            Set requestNewDataArray(i) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestNewDataArray 中包含的一個元素，推入一維數組 requestNewDataArray 中的第 i 個元素;
                            'Debug.Print LBound(requestNewDataArray, 1)
                            'Debug.Print UBound(requestNewDataArray, 1)
                            'Debug.Print requestNewDataArray(i).Count()
                            'Debug.Print LBound(requestNewDataArray(i).Keys())
                            'Debug.Print UBound(requestNewDataArray(i).Keys())
                            'For m = LBound(requestNewDataArray(i).Keys()) To UBound(requestNewDataArray(i).Keys())
                            '    'Debug.Print requestNewDataArray(i).Keys()(m)
                            '    'Debug.Print LBound(requestNewDataArray(i).Item(CStr(requestNewDataArray(i).Keys()(m))))
                            '    'Debug.Print UBound(requestNewDataArray(i).Item(CStr(requestNewDataArray(i).Keys()(m))))
                            '    Debug.Print "requestNewDataArray(" & CStr(i) & ").Item(" & requestNewDataArray(i).Keys()(m) & ") = " & requestNewDataArray(i).Item(requestNewDataArray(i).Keys()(m))
                            'Next m

                            '纍積記錄中的一個空行數據
                            If Len_empty_Boolean = True Then
                                Len_empty = Len_empty + 1
                            End If

                            'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                        Next i
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestNewDataArray, 1) To UBound(requestNewDataArray, 1)
                        '    'Debug.Print LBound(requestNewDataArray, 1)
                        '    'Debug.Print UBound(requestNewDataArray, 2)
                        '    'Debug.Print requestNewDataArray(m).Count()
                        '    'Debug.Print LBound(requestNewDataArray(m).Keys())
                        '    'Debug.Print UBound(requestNewDataArray(m).Keys())
                        '    For n = LBound(requestNewDataArray(m).Keys()) To UBound(requestNewDataArray(m).Keys())
                        '        Debug.Print "requestNewDataArray(" & m & ").Item(" & requestNewDataArray(m).Keys()(n) & ") = " & requestNewDataArray(m).Item(requestNewDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                    End If

                    If Len(Len_inputDataNameArray) > 0 And Len(Len_inputDataArray) = 0 Then

                        'ReDim requestNewDataArray(1 To CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1)) As Variant: Rem Variant、String、Integer、Long、Single、Double，更新一維數組變量的行列維度，用於存放客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串，注意如果是二維數組，則 VBA 的二維數組索引是（行號，列號）格式
                        ReDim requestNewDataArray(1 To 1) As Variant

                        '循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                        'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的行數目;
                        'Dim Len_empty_Boolean As Boolean: Rem 記錄判斷二維數組 inputDataArray 中本行數據是否為空行
                        Len_empty_Boolean = True
                        'Dim m, n As Integer
                        'm = 0
                        'n = 0

                        'Dim rowDataDict As Object: Rem 聲明一個字典對象，用於存放每一行的請求數據，然後每一行的數據依次推入一維請求數組 requestNewDataArray() 中，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                        Set rowDataDict = CreateObject("Scripting.Dictionary")
                        rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        Len_empty_Boolean = True: Rem 取 True 值表示二維數組 inputDataArray 中本行數據為空行，取 False 值表示本行非空行
                        For j = 1 To CInt(UBound(inputDataNameArray, 1) - LBound(inputDataNameArray, 1) + 1)

                            ''判斷本行（第 i 行）數據是否爲空字符串（""）
                            'If inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)) <> "" Then
                            '    Len_empty_Boolean = False
                            'End If

                            'Debug.Print LBound(inputDataNameArray, 1)
                            'Debug.Print UBound(inputDataNameArray, 1)
                            'Debug.Print inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)
                            'Debug.Print inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1))

                            '檢查字典中是否已經指定的鍵值對
                            If rowDataDict.Exists(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) Then
                                rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1))) = CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 刷新字典指定的鍵值對
                            Else
                                rowDataDict.Add CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)), CStr(""): Rem inputDataArray(CInt(LBound(inputDataArray, 1) + CInt(i) - 1), CInt(LBound(inputDataArray, 2) + CInt(j) - 1)): Rem 字典新增指定的鍵值對
                            End If
                            'Debug.Print "rowDataDict.Item(" & CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)) & ") = " & rowDataDict.Item(CStr(inputDataNameArray(LBound(inputDataNameArray, 1) + j - 1)))

                            ''刪除字典 rowDataDict 中的條目 "testYdata_1"
                            'If rowDataDict.Exists("testYdata_1") Then
                            '    rowDataDict.Remove ("testYdata_1")
                            'End If

                        Next j
                        'For m = LBound(rowDataDict.Keys()) To UBound(rowDataDict.Keys())
                        '    'Debug.Print rowDataDict.Keys()(m)
                        '    'Debug.Print LBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    'Debug.Print UBound(rowDataDict.Item(CStr(rowDataDict.Keys()(m))))
                        '    Debug.Print "rowDataDict.Item(" & rowDataDict.Keys()(m) & ") = " & rowDataDict.Item(rowDataDict.Keys()(m))
                        'Next m

                        Set requestNewDataArray(1) = rowDataDict: Rem 首先將二維數組 inputDataArray 中的第 i 行數據，推入字典 rowDataDict 中，然後以字典的形式，作爲一維數組 requestNewDataArray 中包含的一個元素，推入一維數組 requestNewDataArray 中的第 i 個元素;
                        'Debug.Print LBound(requestNewDataArray, 1)
                        'Debug.Print UBound(requestNewDataArray, 1)
                        'Debug.Print requestNewDataArray(1).Count()
                        'Debug.Print LBound(requestNewDataArray(1).Keys())
                        'Debug.Print UBound(requestNewDataArray(1).Keys())
                        ''Dim m, n As Integer
                        'm = 0
                        'n = 0
                        'For m = LBound(requestNewDataArray, 1) To UBound(requestNewDataArray, 1)
                        '    'Debug.Print LBound(requestNewDataArray, 1)
                        '    'Debug.Print UBound(requestNewDataArray, 2)
                        '    'Debug.Print requestNewDataArray(m).Count()
                        '    'Debug.Print LBound(requestNewDataArray(m).Keys())
                        '    'Debug.Print UBound(requestNewDataArray(m).Keys())
                        '    For n = LBound(requestNewDataArray(m).Keys()) To UBound(requestNewDataArray(m).Keys())
                        '        Debug.Print "requestNewDataArray(" & m & ").Item(" & requestNewDataArray(m).Keys()(n) & ") = " & requestNewDataArray(m).Item(requestNewDataArray(m).Keys()(n))
                        '    Next n
                        'Next m

                        '纍積記錄中的一個空行數據
                        If Len_empty_Boolean = True Then
                            Len_empty = Len_empty + 1
                        End If

                        'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    End If

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Len_empty = 0


                    ''循環遍歷二維數組 inputDataNameArray 和 inputDataArray，讀取逐次讀出全部用於鏈接操控數據庫的原始數據的自定義標志名稱字段值字符串和對應的數據;
                    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放鏈接操控數據庫的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    'For j = LBound(inputDataArray, 2) To UBound(inputDataArray, 2)

                    '    '遍歷讀取逐列的數據推入一維數組
                    '    'Dim columnDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Variant、Integer、Long、Single、Double，重置不定長一維數組變量的長度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    'Dim Len_empty As Integer: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    Len_empty = 0: Rem 記錄數組 inputDataArray 元素爲空字符串（""）的數目;
                    '    For i = LBound(inputDataArray, 1) To UBound(inputDataArray, 1)
                    '        'Debug.Print "inputDataNameArray(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '        'ReDim columnDataArray(LBound(inputDataArray, 1) To UBound(inputDataArray, 1)) As Variant: Rem Integer、Long、Single、Double，更新二維數組變量的行列維度，用於存放待計算的原始數據值，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        '判斷數組 inputDataArray 當前元素是否爲空字符串
                    '        If inputDataArray(i, j) = "" Then
                    '            Len_empty = Len_empty + 1: Rem 將數組 inputDataArray 元素爲空字符串（""）的數目遞進加一;
                    '        Else
                    '            columnDataArray(i) = inputDataArray(i, j)
                    '        End If
                    '        'Debug.Print columnDataArray(i)
                    '    Next i
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '    If Len_empty <> 0 Then
                    '        If Len_empty < CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) + 1) Then
                    '            ReDim Preserve columnDataArray(LBound(inputDataArray, 1) To LBound(inputDataArray, 1) + CInt(UBound(inputDataArray, 1) - LBound(inputDataArray, 1) - Len_empty)) As Variant: Rem 重定義保存 Excel 某一列數據的一維數組變量的列維度，刪除後面元素為空字符串（""）的元素，注意，如果使用 Preserve 參數，則只能重新定義二維數組的最後一個維度（即列維度），但可以保留數組中原有的元素值，用於存放當前頁面中采集到的數據結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    '        Else
                    '            'ReDim columnDataArray(0): Rem 清空數組
                    '            Erase columnDataArray: Rem 函數 Erase() 表示置空數組
                    '        End If
                    '    End If
                    '    'Debug.Print LBound(columnDataArray)
                    '    'Debug.Print UBound(columnDataArray)

                    '    '判斷數組 inputDataNameArray 是否爲空
                    '    'Dim Len_inputDataNameArray As Integer
                    '    'Len_inputDataNameArray = UBound(inputDataNameArray, 1)
                    '    'If Err.Number = 13 Then
                    '    Dim Len_inputDataNameArray As String
                    '    Len_inputDataNameArray = ""
                    '    Len_inputDataNameArray = Trim(Join(inputDataNameArray))
                    '    'For i = LBound(inputDataNameArray, 1) To UBound(inputDataNameArray, 1)
                    '    '    For j = LBound(inputDataNameArray, 2) To UBound(inputDataNameArray, 2)
                    '    '        'Debug.Print "inputDataNameArray:(" & i & ", " & j & ") = " & inputDataNameArray(i, j)
                    '    '        Len_inputDataNameArray = Len_inputDataNameArray & inputDataNameArray(i, j)
                    '    '    Next j
                    '    'Next i
                    '    'Len_inputDataNameArray = Trim(Len_inputDataNameArray)
                    '    If Len(Len_inputDataNameArray) = 0 Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    ElseIf inputDataNameArray(j) = "" Then
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr("Column" & "-" & CStr(j))) Then
                    '            requestJSONDict.Item(CStr("Column" & "-" & CStr(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr("Column" & "-" & CStr(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    Else
                    '        '檢查字典中是否已經指定的鍵值對
                    '        If requestJSONDict.Exists(CStr(inputDataNameArray(j))) Then
                    '            requestJSONDict.Item(CStr(inputDataNameArray(j))) = columnDataArray: Rem 刷新字典指定的鍵值對
                    '        Else
                    '            requestJSONDict.Add CStr(inputDataNameArray(j)), columnDataArray: Rem 字典新增指定的鍵值對
                    '        End If
                    '    End If
                    '    'Debug.Print requestJSONDict.Item(CStr(inputDataNameArray(j)))

                    'Next j

                    ''Debug.Print requestJSONDict.Count
                    ''Debug.Print LBound(requestJSONDict.Keys())
                    ''Debug.Print UBound(requestJSONDict.Keys())
                    ''For i = LBound(requestJSONDict.Keys()) To UBound(requestJSONDict.Keys())
                    ''    'Debug.Print requestJSONDict.Keys()(i)
                    ''    'Debug.Print LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    'Debug.Print UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''    For j = LBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i)))) To UBound(requestJSONDict.Item(CStr(requestJSONDict.Keys()(i))))
                    ''        Debug.Print requestJSONDict.Keys()(i) & ":(" & j & ") = " & requestJSONDict.Item(requestJSONDict.Keys()(i))(j)
                    ''    Next j
                    ''Next i

                    ''ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    'Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'Len_empty = 0
                    ''ReDim columnDataArray(0): Rem 清空數組，釋放内存
                    'Erase columnDataArray: Rem 函數 Erase() 表示置空數組，釋放内存



                    ''將保存計算結果的二維數組變量 outputDataArray 手動轉換爲對應的 JSON 格式的字符串;
                    'Dim columnName() As String: Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'ReDim columnName(1 To UBound(inputDataArray, 2)): Rem 二維數組數據各字段（各列）名稱字符串一維數組;
                    'columnName(1) = "Column_1"
                    'columnName(2) = "Column_2"
                    ''For i = 1 To UBound(columnName, 1)
                    ''    Debug.Print columnName(i)
                    ''Next i

                    'Dim PostCode As String: Rem 當使用 POST 請求時，將會伴隨請求一起發送到服務器端的 POST 值字符串
                    'PostCode = ""
                    'PostCode = "{""Column_1"" : ""b-1"", ""Column_2"" : ""一級"", ""Column_3"" : ""b-1-1"", ""Column_4"" : ""二級"", ""Column_5"" : ""b-1-2"", ""Column_6"" : ""二級"", ""Column_7"" : ""b-1-3"", ""Column_8"" : ""二級"", ""Column_9"" : ""b-1-4"", ""Column_10"" : ""二級"", ""Column_11"" : ""b-1-5"", ""Column_12"" : ""二級""}"
                    'PostCode = "{" & """Column_1""" & ":" & """" & CStr(inputDataArray(1, 1)) & """" & "," _
                    '         & """Column_2""" & ":" & """" & CStr(inputDataArray(1, 2)) & """" & "}" _
                    '         & """Column_3""" & ":" & """" & CStr(inputDataArray(1, 3)) & """" & "," _
                    '         & """Column_4""" & ":" & """" & CStr(inputDataArray(1, 4)) & """" & "," _
                    '         & """Column_5""" & ":" & """" & CStr(inputDataArray(1, 5)) & """" & "," _
                    '         & """Column_6""" & ":" & """" & CStr(inputDataArray(1, 6)) & """" & "," _
                    '         & """Column_7""" & ":" & """" & CStr(inputDataArray(1, 7)) & """" & "," _
                    '         & """Column_8""" & ":" & """" & CStr(inputDataArray(1, 8)) & """" & "," _
                    '         & """Column_9""" & ":" & """" & CStr(inputDataArray(1, 9)) & """" & "," _
                    '         & """Column_10""" & ":" & """" & CStr(inputDataArray(1, 10)) & """" & "," _
                    '         & """Column_11""" & ":" & """" & CStr(inputDataArray(1, 11)) & """" & "," _
                    '         & """Column_12""" & ":" & """" & CStr(inputDataArray(1, 12)) & """" & "}"

                    ''使用 For 循環嵌套遍歷的方法，將一維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    PostCode = ""
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "'" & "[" & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (j = UBound(inputDataArray, 2)) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & "]"
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & "]"
                    '            End If
                    '        End If
                    '    Next j
                    '    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                    '    WHR.SetRequestHeader "Content-Length", Len(PostCode): Rem 請求頭參數：POST 的内容長度。

                    '    WHR.Send (PostCode): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    '    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    '    '讀取服務器返回的響應值
                    '    WHR.Response.write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    '    WHR.Response.write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    '    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    '    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    '    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    '    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    '    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    '    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    '    Response_Text = WHR.responseText
                    '    Response_Text = StrConv(Response_Text, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    '    'Debug.Print Response_Text

                    'Next i


                    ''使用 For 循環嵌套遍歷的方法，將二維數組的值拼接為 JSON 字符串，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    'PostCode = "["
                    'For i = 1 To UBound(inputDataArray, 1)
                    '    For j = 1 To UBound(inputDataArray, 2)
                    '        If (j = 1) Then
                    '            If (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '            End If
                    '            If (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "{" & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """"
                    '            End If
                    '        End If
                    '        If (j > 1) And (j < UBound(inputDataArray, 2)) Then
                    '            PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & ","
                    '        End If
                    '        If (i < UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}" & ","
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}" & ","
                    '            End If
                    '        End If
                    '        If (i = UBound(inputDataArray, 1)) Then
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) > 1) Then
                    '                PostCode = PostCode & """" & CStr(columnName(j)) & """" & ":" & """" & CStr(inputDataArray(i, j)) & """" & "}"
                    '            End If
                    '            If (j = UBound(inputDataArray, 2)) And (UBound(inputDataArray, 2) = 1) Then
                    '                PostCode = PostCode & "}"
                    '            End If
                    '        End If
                    '    Next j
                    'Next i
                    'PostCode = PostCode & "]"
                    'Debug.Print PostCode: Rem 在立即窗口打印拼接後的請求 Post 值。

                    ReDim requestJSONArray(1 To CInt(UBound(requestOldDataArray, 1) - LBound(requestOldDataArray, 1) + 1))

                    'Dim rowDataArray() As Variant: Rem Variant、String、Integer、Long、Single、Double，聲明一個不定長一維數組變量，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    ReDim rowDataArray(0)
                    'ReDim rowDataArray(0 To X_UBound, 0 To Y_UBound) As String: Rem 更新二維數組變量的行列維度，客戶端請求值字典，記錄向數據庫服務器發送的，用於操控數據庫的原始數據，向服務器發送之前需要用到第三方模組（Module）將字典變量轉換爲 JSON 字符串;
                    For i = 1 To CInt(UBound(requestOldDataArray, 1) - LBound(requestOldDataArray, 1) + 1)
                        ReDim rowDataArray(1 To 2)
                        Set rowDataArray(1) = requestOldDataArray(LBound(requestOldDataArray, 1) + i - 1)
                        Set rowDataArray(2) = requestNewDataArray(LBound(requestNewDataArray, 1) + i - 1)
                        requestJSONArray(i) = rowDataArray

                        'ReDim rowDataArray(0): Rem 清空數組，釋放内存
                        ''Erase rowDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Next i
                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim rowDataArray(0): Rem 清空數組，釋放内存
                    'Erase rowDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim requestOldDataArray(0): Rem 清空數組，釋放内存
                    Erase requestOldDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim requestNewDataArray(0): Rem 清空數組，釋放内存
                    Erase requestNewDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                Case Else

                    MsgBox "輸入的自定義對數據庫操作的指令名稱錯誤，無法識別傳入的名稱（Database operational order name = " & CStr(Database_operational_order) & "），目前只製作完成 (""Add data"", ""Retrieve data"", ""Update data"", ""Delete data"", ""Retrieve count"", ""Add table(collection)"", ""Delete table(collection)"", ""SQL"") 自定義的對數據庫操作的指令."
                    Exit Sub

            End Select


            '判斷是否跳出子過程不繼續執行後面的動作
            'If PublicVariableStartORStopButtonClickState Then
            '    '刷新控制面板窗體控件中包含的提示標簽顯示值
            '    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
            '        DatabaseControlPanel.Controls("Database_status_Label").Caption = "運行過程被中止.": Rem 提示運行過程執行狀態，賦值給標簽控件 Database_status_Label 的屬性值 .Caption 顯示。如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Database_status_Label”的“text”屬性值 Database_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            '    End If
            '    ''更改按鈕狀態和標志
            '    ''PublicVariableStartORStopButtonClickState = Not PublicVariableStartORStopButtonClickState
            '    'If Not (DatabaseControlPanel.Controls("Run_CommandButton") Is Nothing) Then
            '    '    Select Case PublicVariableStartORStopButtonClickState
            '    '        Case True
            '    '            DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Run")
            '    '        Case False
            '    '            DatabaseControlPanel.Controls("Run_CommandButton").Caption = CStr("Abort")
            '    '        Case Else
            '    '            MsgBox "Run or Abort Button" & "\\n" & "Private Sub Run_CommandButton_Click() Variable { PublicVariableStartORStopButtonClickState } Error !" & "\\n" & CStr(PublicVariableStartORStopButtonClickState)
            '    '    End Select
            '    'End If
            '    ''刷新操作面板窗體控件中的變量值
            '    ''Debug.Print "Run or Abort Button Click State = " & "[ " & PublicVariableStartORStopButtonClickState & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 PublicVariableStartORStopButtonClickState 值。
            '    ''為操作面板窗體控件 DatabaseControlPanel 中包含的（監測窗體中啓動運行按钮控件的點擊狀態，布爾型）變量更新賦值
            '    'If Not (DatabaseControlPanel.Controls("PublicVariableStartORStopButtonClickState") Is Nothing) Then
            '    '    DatabaseControlPanel.PublicVariableStartORStopButtonClickState = PublicVariableStartORStopButtonClickState
            '    'End If
            '    ''取消控制面板中窗體控件中的按鈕禁用狀態
            '    'DatabaseControlPanel.Run_CommandButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Run_CommandButton（啓動運行按鈕），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Access_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Access_OptionButton（用於判別標識指定使用 Microsoft Office Access 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.MongoDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MongoDB_OptionButton（用於判別標識指定使用 MongoDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.MariaDB_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MariaDB_OptionButton（用於判別標識指定使用 MariaDB 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.PostgreSQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 PostgreSQL_OptionButton（用於判別標識指定使用 PostgreSQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.MySQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 MySQL_OptionButton（用於判別標識指定使用 MySQL 數據庫管理軟體的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Database_Server_Url_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_Server_Url_TextBox（用於保存計算結果的數據庫服務器網址 URL 字符串輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Database_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Database_name_input_TextBox（用於指定待鏈接操控的自定義數據庫命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Data_table_name_input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Data_table_name_input_TextBox（用於指定待鏈接操控的自定義數據庫包含的數據二維表格（集合）命名字符串的文本輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Username_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Username_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶名輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Password_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的按鈕控件 Password_TextBox（用於驗證提供數據存儲的數據庫服務器的賬戶密碼輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Field_name_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_name_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的名（key）字段的命名值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Field_data_position_Input_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Input_TextBox（需要向數據庫服務器發送 Post 請求的鍵值對（key : value）數據的值（value）字段的值在Excel表格中的傳入位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Field_name_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的名（key）字段的命名值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Field_data_position_Output_TextBox.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的文本輸入框控件 Field_data_position_Output_TextBox（從數據庫服務器接收到的響應值鍵值對（key : value）數據的值（value）字段的值寫入Excel表格中的輸出位置字符串的輸入框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Add_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_data_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入數據）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Retrieve_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_data_OptionButton（用於標識選擇某一個具體操控指令（檢索查找數據）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Update_Data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Update_Data_OptionButton（用於標識選擇某一個具體操控指令（修改更新數據）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Delete_data_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_data_OptionButton（用於標識選擇某一個具體操控指令（刪除指定數據）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Retrieve_count_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Retrieve_count_OptionButton（用於標識選擇某一個具體操控指令（檢索數據的條數）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Add_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Add_table_OptionButton（用於標識選擇某一個具體操控指令（添加新增插入保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.Delete_table_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 Delete_table_OptionButton（用於標識選擇某一個具體操控指令（刪除指定保存數據的二維表格或集合）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    'DatabaseControlPanel.SQL_OptionButton.Enabled = True: Rem 啓用操作面板窗體 DatabaseControlPanel 中的單選框控件 SQL_OptionButton（用於標識選擇某一個具體操控指令（執行傳入的 SQL 指令）的單選框），False 表示禁用點擊，True 表示可以點擊
            '    Exit Sub
            'End If


            '刷新自定義的延時等待時長
            'Public_Delay_length_input = CLng(1500): Rem 人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
            If Not (DatabaseControlPanel.Controls("Delay_input_TextBox") Is Nothing) Then
                'Public_delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為長整型。
                Public_Delay_length_input = CLng(DatabaseControlPanel.Controls("Delay_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為長整型。

                'Debug.Print "Delay length input = " & "[ " & Public_Delay_length_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_input 值。
                '刷新控制面板窗體中包含的變量，人爲延時等待時長基礎值，單位毫秒。函數 CLng() 表示强制轉換為長整型
                If Not (DatabaseControlPanel.Controls("Public_Delay_length_input") Is Nothing) Then
                    DatabaseControlPanel.Public_Delay_length_input = Public_Delay_length_input
                End If
            End If
            'Public_Delay_length_random_input = CSng(0.2): Rem 人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
            If Not (DatabaseControlPanel.Controls("Delay_random_input_TextBox") Is Nothing) Then
                'Public_delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Value): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。
                Public_Delay_length_random_input = CSng(DatabaseControlPanel.Controls("Delay_random_input_TextBox").Text): Rem 從文本輸入框控件中提取值，結果為單精度浮點型。

                'Debug.Print "Delay length random input = " & "[ " & Public_Delay_length_random_input & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length_random_input 值。
                '刷新控制面板窗體中包含的變量，人爲延時等待時長隨機波動範圍，單位為基礎值的百分比。函數 CSng() 表示强制轉換為單精度浮點型
                If Not (DatabaseControlPanel.Controls("Public_Delay_length_random_input") Is Nothing) Then
                    DatabaseControlPanel.Public_Delay_length_random_input = Public_Delay_length_random_input
                End If
            End If
            Randomize: Rem 函數 Randomize 表示生成一個隨機數種子（seed）
            Public_Delay_length = CLng((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Public_Delay_length = CLng(Int((CLng(Public_Delay_length_input * (1 + Public_Delay_length_random_input)) - Public_Delay_length_input + 1) * Rnd() + Public_Delay_length_input)): Rem Int((upperbound - lowerbound + 1) * rnd() + lowerbound)，函數 Rnd() 表示生成 [0,1) 的隨機數。
            'Debug.Print "Delay length = " & "[ " & Public_Delay_length & " ]": Rem 這條語句用於調式，調試完畢後可刪除。效果是在“立即窗口”中顯示讀取到的 Public_Delay_length 值。
            '刷新控制面板窗體中包含的變量，經過隨機化之後最終得到的延時長度
            If Not (DatabaseControlPanel.Controls("Public_Delay_length") Is Nothing) Then
                DatabaseControlPanel.Public_Delay_length = Public_Delay_length
            End If

            ''使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'If Not (DatabaseControlPanel.Controls("delay") Is Nothing) Then
            '    Call DatabaseControlPanel.delay(DatabaseControlPanel.Public_Delay_length): Rem 使用自定義子過程延時等待 3000 毫秒（3 秒鐘），等待網頁加載完畢，自定義延時等待子過程傳入參數可取值的最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，範圍在 0 到 2^32 之間。
            'End If

            '刷新控制面板窗體控件中包含的提示標簽顯示值
            If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
            End If

            '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
            Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
            Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
            Dim LabelText As String
            LabelText = ""

            Select Case Database_operational_order

                Case Is = "Add data"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    '使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray, Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    requestJSONText = JsonConverter.ConvertToJson(requestJSONArray): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    'Debug.Print requestJSONText

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                    Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                    WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    'requestJSONText = "": Rem 置空，釋放内存

                    '讀取服務器返回的響應值
                    WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                    responseJSONText = WHR.responseText
                    'Debug.Print responseJSONText
                    'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'Debug.Print responseJSONText

                    'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                    'Set HTMLCode = Nothing
                    'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If


                    ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                    '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                    'Debug.Print responseJSONArray.Count
                    ''For i = 1 To responseJSONArray.Count
                    ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                    ''        'Debug.Print responseJSONArray(i).Keys()(j)
                    ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                    ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                    ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                    ''    Next j
                    ''Next i
                    'Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONArray
                    '    i = i + 1
                    '    'Debug.Print LBound(Value.Keys())
                    '    'Debug.Print UBound(Value.Keys())
                    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                    '        'Debug.Print Value.Keys()(j)
                    '        'Debug.Print Value.Exists(Value.Keys()(j))
                    '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                    '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                    '    Next j
                    'Next Value

                    'responseJSONText = "": Rem 置空，釋放内存
                    'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                    'If responseJSONArray.Count > 0 Then

                    '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                    '    Dim max_Rows As Integer
                    '    max_Rows = responseJSONArray.Count
                    '    Dim max_Columns As Integer
                    '    max_Columns = 0
                    '    'Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '        End If
                    '    Next Value

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                    '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                    '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                    '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '    Next j

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    'Debug.Print responseJSONArray.Count
                    '    'For i = 1 To responseJSONArray.Count
                    '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                    '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                    '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                    '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                    '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '    Next j
                    '    'Next i
                    '    Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        'Debug.Print LBound(Value.Keys())
                    '        'Debug.Print UBound(Value.Keys())
                    '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                    '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                    '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                    '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '        Next j
                    '    Next Value

                    'End If

                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;


                    Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                    'Debug.Print responseJSONDict.Count
                    'Debug.Print LBound(responseJSONDict.Keys())
                    'Debug.Print UBound(responseJSONDict.Keys())
                    'Dim Value As Variant
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    'Debug.Print responseJSONDict.Keys()(i)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                    '    'Next j
                    '    j = 0
                    '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                    '        j = j + 1
                    '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                    '    Next Value
                    'Next i

                    responseJSONText = "": Rem 置空，釋放内存


                    '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                    Dim max_Columns As Integer
                    max_Columns = 0
                    ''Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONDict
                    '    i = i + 1
                    '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '    End If
                    'Next Value
                    max_Columns = 1
                    'Debug.Print max_Columns

                    '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                    Dim max_Rows As Integer
                    max_Rows = 0
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                    '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                    '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                    '        End If
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        If max_Rows < 1 Then
                    '            max_Rows = 1
                    '        End If
                    '    Else
                    '    End If
                    'Next i
                    '檢查字典中是否已經指定的鍵值對
                    'Debug.Print responseJSONDict.Exists("Database_say")
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                            End If
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            If max_Rows < 1 Then
                                max_Rows = 1
                            End If
                        Else
                        End If
                    End If
                    'Debug.Print max_Rows

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                    '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    'Next j
                    outputDataNameArray(1) = CStr("Database_say")
                    'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                    '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                    'Next i

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                    '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                    '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                    '        Dim Value As Variant
                    '        j = 0
                    '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                    '            j = j + 1
                    '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                    '            outputDataArray(j, i) = Value
                    '        Next Value
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    Else
                    '    End If
                    'Next i
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            'Debug.Print responseJSONDict.Item("Database_say").Count
                            Dim Value As Variant
                            j = 0
                            For Each Value In responseJSONDict.Item("Database_say")
                                j = j + 1
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                outputDataArray(j, 1) = Value
                            Next Value
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                            outputDataArray(1, 1) = responseJSONDict("Database_say")
                        Else
                        End If
                    End If
                    'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                    '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                    '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                    '    Next j
                    'Next i

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                    LabelText = ""
                    If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                        LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    Else
                        '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        If CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) = CInt(0) Then
                            LabelText = "數據庫未寫入數據."
                        ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) > CInt(0) Then
                            LabelText = "向數據庫寫入「" & CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) & "」條數據成功."
                        Else
                        End If
                    End If
                    'Debug.Print LabelText
                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                    '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        ''RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    ''RNG = outputDataNameArray
                    '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                    '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                    '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Next j
                    '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    'RNG = outputDataArray
                    '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                    '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                    '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '    Next j
                    '    'Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                    ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                    'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                    'Columns("C:J").Clear: Rem 清空 C 至 J 列
                    'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                    'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                    'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                    'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                    'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                    'ActiveCell.Row: Rem 返回活動單元格的行號
                    'ActiveCell.Column: Rem 返回活動單元格的列號
                    'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                    'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataArray(0): Rem 清空數組，釋放内存
                    Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    Exit Sub

                Case Is = "Retrieve count"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    Dim Number_of_Retrieval As Long
                    Number_of_Retrieval = 0
                    'Dim k As Integer
                    For k = 1 To CInt(UBound(requestJSONArray, 1) - LBound(requestJSONArray, 1) + 1)

                        ''使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                        ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        ''requestJSONText = JsonConverter.ConvertToJson(CInt(LBound(requestJSONArray, 1) + k - 1), Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        ''Debug.Print requestJSONText

                        'requestJSONText = CStr(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        requestJSONText = requestJSONArray(LBound(requestJSONArray, 1) + k - 1): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'Debug.Print requestJSONText

                        ''ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                        'Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                        WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                        'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                        'requestJSONText = "": Rem 置空，釋放内存

                        '讀取服務器返回的響應值
                        WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                        WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                        'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                        ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                        ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                        '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                        'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                        'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                        'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                        'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                        responseJSONText = WHR.responseText
                        'Debug.Print responseJSONText
                        'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'Debug.Print responseJSONText

                        'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                        'Set HTMLCode = Nothing
                        'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If


                        ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                        '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'Debug.Print responseJSONArray.Count
                        ''For i = 1 To responseJSONArray.Count
                        ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                        ''        'Debug.Print responseJSONArray(i).Keys()(j)
                        ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                        ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                        ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                        ''    Next j
                        ''Next i
                        'Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONArray
                        '    i = i + 1
                        '    'Debug.Print LBound(Value.Keys())
                        '    'Debug.Print UBound(Value.Keys())
                        '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                        '        'Debug.Print Value.Keys()(j)
                        '        'Debug.Print Value.Exists(Value.Keys()(j))
                        '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                        '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                        '    Next j
                        'Next Value

                        'responseJSONText = "": Rem 置空，釋放内存
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                        ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                        ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                        'If responseJSONArray.Count > 0 Then

                        '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                        '    Dim max_Rows As Integer
                        '    max_Rows = responseJSONArray.Count
                        '    Dim max_Columns As Integer
                        '    max_Columns = 0
                        '    'Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '        End If
                        '    Next Value

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                        '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                        '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                        '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '    Next j

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    'Debug.Print responseJSONArray.Count
                        '    'For i = 1 To responseJSONArray.Count
                        '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                        '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                        '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                        '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                        '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '    Next j
                        '    'Next i
                        '    Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        'Debug.Print LBound(Value.Keys())
                        '        'Debug.Print UBound(Value.Keys())
                        '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                        '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                        '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                        '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '        Next j
                        '    Next Value

                        'End If

                        ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                        Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                        'Debug.Print responseJSONDict.Count
                        'Debug.Print LBound(responseJSONDict.Keys())
                        'Debug.Print UBound(responseJSONDict.Keys())
                        'Dim Value As Variant
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    'Debug.Print responseJSONDict.Keys()(i)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                        '    'Next j
                        '    j = 0
                        '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                        '        j = j + 1
                        '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                        '    Next Value
                        'Next i

                        responseJSONText = "": Rem 置空，釋放内存


                        '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                        'Dim max_Columns As Integer
                        max_Columns = 0
                        ''Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONDict
                        '    i = i + 1
                        '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '    End If
                        'Next Value
                        max_Columns = 1
                        'Debug.Print max_Columns

                        '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                        'Dim max_Rows As Integer
                        max_Rows = 0
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                        '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                        '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                        '        End If
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        If max_Rows < 1 Then
                        '            max_Rows = 1
                        '        End If
                        '    Else
                        '    End If
                        'Next i
                        '檢查字典中是否已經指定的鍵值對
                        'Debug.Print responseJSONDict.Exists("Database_say")
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                    max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                                End If
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                If max_Rows < 1 Then
                                    max_Rows = 1
                                End If
                            Else
                            End If
                        End If
                        'Debug.Print max_Rows


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                        LabelText = ""
                        If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                            LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                            '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                            'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                            'Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                            If responseJSONDict("Database_say") <> "" Then
                                Number_of_Retrieval = Number_of_Retrieval + CLng(responseJSONDict("Database_say"))
                            End If
                            If (responseJSONDict("Database_say") = "") Or (CInt(responseJSONDict("Database_say")) = CInt(0)) Then
                                LabelText = "在數據庫中使用當前關鍵詞共檢索到「" & CStr(Number_of_Retrieval) & "」條數據."
                            ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))) > CInt(0) Then
                                LabelText = "在數據庫中使用當前關鍵詞共檢索到「" & CStr(Number_of_Retrieval) & "」條數據."
                            Else
                            End If
                        End If
                        'Debug.Print LabelText
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                        '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        'Next j
                        outputDataNameArray(1) = CStr("Database_say")
                        'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                        '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                        'Next i

                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                        '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                        '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                        '        Dim Value As Variant
                        '        j = 0
                        '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                        '            j = j + 1
                        '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                        '            outputDataArray(j, i) = Value
                        '        Next Value
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    Else
                        '    End If
                        'Next i
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                'Debug.Print responseJSONDict.Item("Database_say").Count
                                'Dim Value As Variant
                                j = 0
                                For Each Value In responseJSONDict.Item("Database_say")
                                    j = j + 1
                                    'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                    outputDataArray(j, 1) = Value
                                    'outputDataArray(j, k) = Value
                                Next Value
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                                outputDataArray(1, 1) = responseJSONDict("Database_say")
                                'outputDataArray(k, 1) = responseJSONDict("Database_say")
                            Else
                            End If
                        End If
                        'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                        '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                        '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                        '    Next j
                        'Next i

                        responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        If k <= 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        ElseIf k > 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        Else
                        End If

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                    Next k

                    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    Number_of_Retrieval = 0

                    Exit Sub

                Case Is = "Retrieve data"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    'Dim Number_of_Retrieval As Long
                    Number_of_Retrieval = 0
                    For k = 1 To CInt(UBound(requestJSONArray, 1) - LBound(requestJSONArray, 1) + 1)

                        ''使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                        ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        ''requestJSONText = JsonConverter.ConvertToJson(requestJSONArray(CInt(LBound(requestJSONArray, 1) + k - 1)), Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        ''Debug.Print requestJSONText

                        'requestJSONText = CStr(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        requestJSONText = requestJSONArray(LBound(requestJSONArray, 1) + k - 1): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'Debug.Print requestJSONText

                        ''ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                        'Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                        WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                        'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                        'requestJSONText = "": Rem 置空，釋放内存

                        '讀取服務器返回的響應值
                        WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                        WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                        'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                        ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                        ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                        '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                        'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                        'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                        'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                        'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                        responseJSONText = WHR.responseText
                        'Debug.Print responseJSONText
                        'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'Debug.Print responseJSONText

                        'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                        'Set HTMLCode = Nothing
                        'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        'Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;
                        'Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                        'Debug.Print responseJSONText
                        '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                        'Debug.Print responseJSONDict("Database_say")
                        Set responseJSONArray = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'Debug.Print responseJSONArray.Count
                        'For i = 1 To responseJSONArray.Count
                        '    'Debug.Print LBound(responseJSONArray(i).Keys())
                        '    'Debug.Print UBound(responseJSONArray(i).Keys())
                        '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        '    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                        '        'Debug.Print responseJSONArray(i).Keys()(j)
                        '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                        '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                        '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                        '    Next j
                        'Next i
                        'Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONArray
                        '    i = i + 1
                        '    'Debug.Print LBound(Value.Keys())
                        '    'Debug.Print UBound(Value.Keys())
                        '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                        '        'Debug.Print Value.Keys()(j)
                        '        'Debug.Print Value.Exists(Value.Keys()(j))
                        '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                        '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                        '    Next j
                        'Next Value

                        responseJSONText = "": Rem 置空，釋放内存

                        '將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                        'ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                        'Debug.Print responseJSONArray.Count
                        If responseJSONArray.Count > 0 Then

                            '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                            'Dim max_Rows As Integer
                            max_Rows = responseJSONArray.Count
                            'Dim max_Columns As Integer
                            max_Columns = 0
                            'Dim Value As Variant
                            i = 0
                            For Each Value In responseJSONArray
                                i = i + 1
                                If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                                    max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                                End If
                            Next Value

                            '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                            ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                            For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                                'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                                'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                                'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                                'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                                'Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                                outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                            Next j
                            'Debug.Print "outputDataNameArray rows = " & CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + 1)
                            'For j = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                            '    Debug.Print "outputDataNameArray (" & CStr(j) & ") = " & outputDataNameArray(j)
                            'Next j

                            '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                            ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                            'Debug.Print responseJSONArray.Count
                            'For i = 1 To responseJSONArray.Count
                            '    'Debug.Print LBound(responseJSONArray(i).Keys())
                            '    'Debug.Print UBound(responseJSONArray(i).Keys())
                            '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                            '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                            '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                            '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                            '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                            '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                            '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                            '    Next j
                            'Next i
                            'Dim Value As Variant
                            i = 0
                            For Each Value In responseJSONArray
                                i = i + 1
                                'Debug.Print LBound(Value.Keys())
                                'Debug.Print UBound(Value.Keys())
                                'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                                For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                                    'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                                    'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                                    'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                                    'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                                    outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                                Next j
                            Next Value
                            'Debug.Print "outputDataArray rows = " & CStr(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + 1) & ", columns = " & CStr(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + 1)
                            'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                            '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                            '        Debug.Print "outputDataArray(" & i & "," & j & ") = " & outputDataArray(i, j)
                            '    Next j
                            'Next i

                        End If

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        'Debug.Print "Database_say: " & responseJSONArray.Count
                        LabelText = ""
                        'If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                        '    LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        'Else
                            '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                            '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                            'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                            'Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                            If (responseJSONDict("Database_say") <> "") And (CInt(responseJSONArray.Count) > CInt(0)) Then
                                Number_of_Retrieval = Number_of_Retrieval + CLng(responseJSONArray.Count)
                            End If
                            If (responseJSONDict("Database_say") = "") Or (CInt(responseJSONArray.Count) = CInt(0)) Then
                                LabelText = "在數據庫中使用當前關鍵詞共檢索到「" & CStr(Number_of_Retrieval) & "」條數據."
                            ElseIf CInt(responseJSONArray.Count) > CInt(0) Then
                                LabelText = "在數據庫中使用當前關鍵詞共檢索到「" & CStr(Number_of_Retrieval) & "」條數據."
                            Else
                            End If
                        'End If
                        'Debug.Print LabelText
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                        responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                        ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                        'Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                        ''Debug.Print responseJSONDict.Count
                        ''Debug.Print LBound(responseJSONDict.Keys())
                        ''Debug.Print UBound(responseJSONDict.Keys())
                        'Dim Value As Variant
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    'Debug.Print responseJSONDict.Keys()(i)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                        '    'Next j
                        '    j = 0
                        '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                        '        j = j + 1
                        '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                        '    Next Value
                        'Next i

                        'responseJSONText = "": Rem 置空，釋放内存
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存


                        ''求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                        'Dim max_Columns As Integer
                        'max_Columns = 0
                        '''Dim Value As Variant
                        ''i = 0
                        ''For Each Value In responseJSONDict
                        ''    i = i + 1
                        ''    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        ''        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        ''    End If
                        ''Next Value
                        'max_Columns = 1
                        ''Debug.Print max_Columns

                        ''求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                        'Dim max_Rows As Integer
                        'max_Rows = 0
                        ''For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        ''    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        ''        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                        ''        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                        ''            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                        ''        End If
                        ''    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        ''        If max_Rows < 1 Then
                        ''            max_Rows = 1
                        ''        End If
                        ''    Else
                        ''    End If
                        ''Next i
                        ''檢查字典中是否已經指定的鍵值對
                        ''Debug.Print responseJSONDict.Exists("Database_say")
                        'If responseJSONDict.Exists("Database_say") Then
                        '    If IsArray(responseJSONDict.Item("Database_say")) Then
                        '        'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                        '        If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                        '            max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                        '        End If
                        '    ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                        '        If max_Rows < 1 Then
                        '            max_Rows = 1
                        '        End If
                        '    Else
                        '    End If
                        'End If
                        ''Debug.Print max_Rows

                        ''將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        'ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        ''For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                        ''    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        ''    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                        ''    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        ''    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        ''    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        ''Next j
                        'outputDataNameArray(1) = CStr("Database_say")
                        ''For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                        ''    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                        ''Next i

                        ''將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        'ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        ''For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                        ''    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        ''    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        ''    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        ''    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        ''        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                        ''        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                        ''        Dim Value As Variant
                        ''        j = 0
                        ''        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                        ''            j = j + 1
                        ''            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                        ''            outputDataArray(j, i) = Value
                        ''        Next Value
                        ''    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        ''        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        ''        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        ''    Else
                        ''    End If
                        ''Next i
                        'If responseJSONDict.Exists("Database_say") Then
                        '    If IsArray(responseJSONDict.Item("Database_say")) Then
                        '        'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                        '        'Debug.Print responseJSONDict.Item("Database_say").Count
                        '        Dim Value As Variant
                        '        j = 0
                        '        For Each Value In responseJSONDict.Item("Database_say")
                        '            j = j + 1
                        '            'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                        '            outputDataArray(j, 1) = Value
                        '            'outputDataArray(j, k) = Value
                        '        Next Value
                        '    ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                        '        'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                        '        outputDataArray(1, 1) = responseJSONDict("Database_say")
                        '        'outputDataArray(k, 1) = responseJSONDict("Database_say")
                        '    Else
                        '    End If
                        'End If
                        ''For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                        ''    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                        ''        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                        ''    Next j
                        ''Next i

                        'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        If k <= 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        ElseIf k > 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        Else
                        End If

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                    Next k

                    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存

                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    Number_of_Retrieval = 0

                    Exit Sub

                Case Is = "Update data"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    'Dim Number_of_Retrieval As Long
                    Number_of_Retrieval = 0
                    'Dim k As Integer
                    For k = 1 To CInt(UBound(requestJSONArray, 1) - LBound(requestJSONArray, 1) + 1)

                        '使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'requestJSONText = JsonConverter.ConvertToJson(CInt(LBound(requestJSONArray, 1) + k - 1), Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        requestJSONText = JsonConverter.ConvertToJson(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'Debug.Print requestJSONText

                        ''ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                        'Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                        WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                        'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                        'requestJSONText = "": Rem 置空，釋放内存

                        '讀取服務器返回的響應值
                        WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                        WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                        'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                        ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                        ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                        '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                        'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                        'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                        'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                        'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                        responseJSONText = WHR.responseText
                        'Debug.Print responseJSONText
                        'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'Debug.Print responseJSONText

                        'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                        'Set HTMLCode = Nothing
                        'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If


                        ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                        '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'Debug.Print responseJSONArray.Count
                        ''For i = 1 To responseJSONArray.Count
                        ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                        ''        'Debug.Print responseJSONArray(i).Keys()(j)
                        ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                        ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                        ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                        ''    Next j
                        ''Next i
                        'Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONArray
                        '    i = i + 1
                        '    'Debug.Print LBound(Value.Keys())
                        '    'Debug.Print UBound(Value.Keys())
                        '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                        '        'Debug.Print Value.Keys()(j)
                        '        'Debug.Print Value.Exists(Value.Keys()(j))
                        '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                        '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                        '    Next j
                        'Next Value

                        'responseJSONText = "": Rem 置空，釋放内存
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                        ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                        ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                        'If responseJSONArray.Count > 0 Then

                        '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                        '    Dim max_Rows As Integer
                        '    max_Rows = responseJSONArray.Count
                        '    Dim max_Columns As Integer
                        '    max_Columns = 0
                        '    'Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '        End If
                        '    Next Value

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                        '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                        '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                        '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '    Next j

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    'Debug.Print responseJSONArray.Count
                        '    'For i = 1 To responseJSONArray.Count
                        '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                        '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                        '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                        '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                        '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '    Next j
                        '    'Next i
                        '    Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        'Debug.Print LBound(Value.Keys())
                        '        'Debug.Print UBound(Value.Keys())
                        '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                        '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                        '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                        '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '        Next j
                        '    Next Value

                        'End If

                        ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                        Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                        'Debug.Print responseJSONDict.Count
                        'Debug.Print LBound(responseJSONDict.Keys())
                        'Debug.Print UBound(responseJSONDict.Keys())
                        'Dim Value As Variant
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    'Debug.Print responseJSONDict.Keys()(i)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                        '    'Next j
                        '    j = 0
                        '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                        '        j = j + 1
                        '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                        '    Next Value
                        'Next i

                        responseJSONText = "": Rem 置空，釋放内存


                        '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                        'Dim max_Columns As Integer
                        max_Columns = 0
                        ''Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONDict
                        '    i = i + 1
                        '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '    End If
                        'Next Value
                        max_Columns = 1
                        'Debug.Print max_Columns

                        '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                        'Dim max_Rows As Integer
                        max_Rows = 0
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                        '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                        '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                        '        End If
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        If max_Rows < 1 Then
                        '            max_Rows = 1
                        '        End If
                        '    Else
                        '    End If
                        'Next i
                        '檢查字典中是否已經指定的鍵值對
                        'Debug.Print responseJSONDict.Exists("Database_say")
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                    max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                                End If
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                If max_Rows < 1 Then
                                    max_Rows = 1
                                End If
                            Else
                            End If
                        End If
                        'Debug.Print max_Rows


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                        LabelText = ""
                        If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                            LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                            '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                            'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                            'Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                            If responseJSONDict("Database_say") <> "" Then
                                Number_of_Retrieval = Number_of_Retrieval + CLng(JsonConverter.ParseJson(responseJSONDict("Database_say"))("modifiedCount"))
                            End If
                            If CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("modifiedCount")) = CInt(0) Then
                                LabelText = "在數據庫中未找到待更新目標數據."
                            ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("modifiedCount")) > CInt(0) Then
                                LabelText = "對數據庫更新「" & CStr(Number_of_Retrieval) & "」條數據成功."
                            Else
                            End If
                        End If
                        'Debug.Print LabelText
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存


                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                        '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        'Next j
                        outputDataNameArray(1) = CStr("Database_say")
                        'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                        '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                        'Next i

                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                        '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                        '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                        '        Dim Value As Variant
                        '        j = 0
                        '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                        '            j = j + 1
                        '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                        '            outputDataArray(j, i) = Value
                        '        Next Value
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    Else
                        '    End If
                        'Next i
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                'Debug.Print responseJSONDict.Item("Database_say").Count
                                'Dim Value As Variant
                                j = 0
                                For Each Value In responseJSONDict.Item("Database_say")
                                    j = j + 1
                                    'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                    outputDataArray(j, 1) = Value
                                    'outputDataArray(j, k) = Value
                                Next Value
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                                outputDataArray(1, 1) = responseJSONDict("Database_say")
                                'outputDataArray(k, 1) = responseJSONDict("Database_say")
                            Else
                            End If
                        End If
                        'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                        '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                        '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                        '    Next j
                        'Next i

                        responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存


                        ''刷新控制面板窗體控件中包含的提示標簽顯示值
                        'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        'End If

                        'If k <= 1 Then

                        '    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                        '    '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                        '    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column'

                        '        ''RNG = outputDataNameArray
                        '        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Next j
                        '            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataNameArray
                        '        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Next j
                        '            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                        '    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                        '    '    'Exit Sub

                        '    '    Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '    '    'Set RNG = Cells(2, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 2 行的最後一個非空單元格賦予變量 RNG，其中參數 (2, Columns.Count) 中的 2 表示第 2 行
                        '    '    'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '    '    Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '    '    'Debug.Print RNG.Row & " × " & RNG.Column

                        '    '    ''RNG = outputDataNameArray
                        '    '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '    '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '    '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '    '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '    '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '    '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        'Next j
                        '    '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    Next i

                        '    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    Else
                        '    End If

                        '    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        '    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                        '    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        '    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        '    '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                        '    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataArray
                        '        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '    Next j
                        '        'Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataArray
                        '        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '    Next j
                        '        'Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                        '    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                        '    '    'Exit Sub

                        '    '    'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '    '    Set RNG = Cells(2, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 2 行的最後一個非空單元格賦予變量 RNG，其中參數 (2, Columns.Count) 中的 2 表示第 2 行
                        '    '    'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '    '    Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '    '    'Debug.Print RNG.Row & " × " & RNG.Column

                        '    '    'RNG = outputDataArray
                        '    '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '    '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '    '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '    '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '    '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    '    Next j
                        '    '    'Next i

                        '    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    Else
                        '    End If

                        '    '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                        '    ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                        '    'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                        '    'Columns("C:J").Clear: Rem 清空 C 至 J 列
                        '    'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                        '    'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                        '    'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                        '    'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                        '    'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                        '    'ActiveCell.Row: Rem 返回活動單元格的行號
                        '    'ActiveCell.Column: Rem 返回活動單元格的列號
                        '    'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                        '    'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                        '    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        '    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                        '    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        '    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ReDim outputDataArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        'ElseIf k > 1 Then

                        '    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                        '    '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                        '    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        'Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 中的第 1 列）
                        '        'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                        '        'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                        '        'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                        '        Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        ''RNG = outputDataNameArray
                        '        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Next j
                        '            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        'Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 中的第 1 列）
                        '        'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                        '        'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                        '        'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                        '        Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataNameArray
                        '        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Next j
                        '            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                        '    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                        '    '    'Exit Sub

                        '    '    Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '    '    'Set RNG = Cells(2, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 2 行的最後一個非空單元格賦予變量 RNG，其中參數 (2, Columns.Count) 中的 2 表示第 2 行
                        '    '    'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '    '    Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '    '    'Debug.Print RNG.Row & " × " & RNG.Column

                        '    '    ''RNG = outputDataNameArray
                        '    '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '    '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '    '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '    '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                        '    '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                        '    '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        'Next j
                        '    '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    Next i

                        '    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    Else
                        '    End If

                        '    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        '    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                        '    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        '    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        '    '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                        '    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        'Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 中的第 1 列）
                        '        'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                        '        'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                        '        'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                        '        Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataArray
                        '        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '    Next j
                        '        'Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                        '        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(CInt(RNG.Row), Columns.Count).End(xlToLeft): Rem 第 CInt(RNG.Row) 行非空的最後一列，其中參數 CInt(RNG.Row) 表示第 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 行
                        '        'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '        'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '        'Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 中的第 1 列）
                        '        'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                        '        'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                        '        'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                        '        Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                        '        'Debug.Print RNG.Row & " × " & RNG.Column

                        '        'RNG = outputDataArray
                        '        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        '    Next j
                        '        'Next i

                        '        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                        '    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                        '    '    'Exit Sub

                        '    '    'Set RNG = Cells(1, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 1 行的最後一個非空單元格賦予變量 RNG，其中參數 (1, Columns.Count) 中的 1 表示第 1 行
                        '    '    Set RNG = Cells(2, Columns.Count).End(xlToLeft): Rem 將 Excel 工作簿中的 2 行的最後一個非空單元格賦予變量 RNG，其中參數 (2, Columns.Count) 中的 2 表示第 2 行
                        '    '    'Set RNG = RNG.Offset(0, 2): Rem 將變量 Rng 重置為 Rng 的同行的右兩列的單元格（即同行的第二個空單元格）
                        '    '    Set RNG = RNG.Offset(0, 1): Rem 將變量 Rng 重置為 Rng 的同行的右一列的單元格（即同行的第一個空單元格）
                        '    '    'Debug.Print RNG.Row & " × " & RNG.Column

                        '    '    'RNG = outputDataArray
                        '    '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        '    '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '    '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        '    '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '    '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    '    '    Next j
                        '    '    'Next i

                        '    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                        '    Else
                        '    End If

                        '    '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                        '    ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                        '    'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                        '    'Columns("C:J").Clear: Rem 清空 C 至 J 列
                        '    'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                        '    'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                        '    'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                        '    'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                        '    'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                        '    'ActiveCell.Row: Rem 返回活動單元格的行號
                        '    'ActiveCell.Column: Rem 返回活動單元格的列號
                        '    'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                        '    'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                        '    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        '    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        '    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                        '    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        '    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                        '    ReDim outputDataArray(0): Rem 清空數組，釋放内存
                        '    'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        'Else
                        'End If

                        'Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                        ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                        ReDim outputDataArray(0): Rem 清空數組，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                    Next k

                    rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    ReDim rowDataArray(0): Rem 清空數組，釋放内存
                    Erase rowDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    Number_of_Retrieval = 0

                    Exit Sub

                Case Is = "Delete data"

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    'Dim Number_of_Retrieval As Long
                    Number_of_Retrieval = 0
                    'Dim k As Integer
                    For k = 1 To CInt(UBound(requestJSONArray, 1) - LBound(requestJSONArray, 1) + 1)

                        '使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'requestJSONText = JsonConverter.ConvertToJson(CInt(LBound(requestJSONArray, 1) + k - 1), Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        requestJSONText = JsonConverter.ConvertToJson(requestJSONArray(LBound(requestJSONArray, 1) + k - 1)): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                        'Debug.Print requestJSONText

                        ''ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                        'Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                        WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                        'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                        'requestJSONText = "": Rem 置空，釋放内存

                        '讀取服務器返回的響應值
                        WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                        WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                        'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                        ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                        ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                        '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                        'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                        'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                        'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                        'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                        responseJSONText = WHR.responseText
                        'Debug.Print responseJSONText
                        'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                        'Debug.Print responseJSONText

                        'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                        'Set HTMLCode = Nothing
                        'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If


                        ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                        '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'Debug.Print responseJSONArray.Count
                        ''For i = 1 To responseJSONArray.Count
                        ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                        ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                        ''        'Debug.Print responseJSONArray(i).Keys()(j)
                        ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                        ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                        ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                        ''    Next j
                        ''Next i
                        'Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONArray
                        '    i = i + 1
                        '    'Debug.Print LBound(Value.Keys())
                        '    'Debug.Print UBound(Value.Keys())
                        '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                        '        'Debug.Print Value.Keys()(j)
                        '        'Debug.Print Value.Exists(Value.Keys()(j))
                        '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                        '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                        '    Next j
                        'Next Value

                        'responseJSONText = "": Rem 置空，釋放内存
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                        ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                        ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                        'If responseJSONArray.Count > 0 Then

                        '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                        '    Dim max_Rows As Integer
                        '    max_Rows = responseJSONArray.Count
                        '    Dim max_Columns As Integer
                        '    max_Columns = 0
                        '    'Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '        End If
                        '    Next Value

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                        '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                        '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                        '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                        '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                        '    Next j

                        '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        '    'Debug.Print responseJSONArray.Count
                        '    'For i = 1 To responseJSONArray.Count
                        '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                        '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                        '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                        '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                        '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                        '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                        '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                        '    '    Next j
                        '    'Next i
                        '    Dim Value As Variant
                        '    i = 0
                        '    For Each Value In responseJSONArray
                        '        i = i + 1
                        '        'Debug.Print LBound(Value.Keys())
                        '        'Debug.Print UBound(Value.Keys())
                        '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                        '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                        '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                        '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                        '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                        '        Next j
                        '    Next Value

                        'End If

                        ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                        'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                        ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                        Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                        'Debug.Print responseJSONDict.Count
                        'Debug.Print LBound(responseJSONDict.Keys())
                        'Debug.Print UBound(responseJSONDict.Keys())
                        'Dim Value As Variant
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    'Debug.Print responseJSONDict.Keys()(i)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                        '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                        '    'Next j
                        '    j = 0
                        '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                        '        j = j + 1
                        '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                        '    Next Value
                        'Next i

                        responseJSONText = "": Rem 置空，釋放内存


                        '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                        'Dim max_Columns As Integer
                        max_Columns = 0
                        ''Dim Value As Variant
                        'i = 0
                        'For Each Value In responseJSONDict
                        '    i = i + 1
                        '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                        '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                        '    End If
                        'Next Value
                        max_Columns = 1
                        'Debug.Print max_Columns

                        '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                        'Dim max_Rows As Integer
                        max_Rows = 0
                        'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                        '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                        '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                        '        End If
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                        '        If max_Rows < 1 Then
                        '            max_Rows = 1
                        '        End If
                        '    Else
                        '    End If
                        'Next i
                        '檢查字典中是否已經指定的鍵值對
                        'Debug.Print responseJSONDict.Exists("Database_say")
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                    max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                                End If
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                If max_Rows < 1 Then
                                    max_Rows = 1
                                End If
                            Else
                            End If
                        End If
                        'Debug.Print max_Rows


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                        LabelText = ""
                        If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                            LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        Else
                            '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                            '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                            'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                            'Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                            If responseJSONDict("Database_say") <> "" Then
                                Number_of_Retrieval = Number_of_Retrieval + CLng(JsonConverter.ParseJson(responseJSONDict("Database_say"))("deletedCount"))
                            End If
                            If CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("deletedCount")) = CInt(0) Then
                                LabelText = "在數據庫中未找到待刪除目標數據."
                            ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("deletedCount")) > CInt(0) Then
                                LabelText = "從數據庫刪除「" & CStr(Number_of_Retrieval) & "」條數據成功."
                            Else
                            End If
                        End If
                        'Debug.Print LabelText
                        'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存


                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                        ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                        '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                        '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                        '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                        'Next j
                        outputDataNameArray(1) = CStr("Database_say")
                        'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                        '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                        'Next i

                        '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                        ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                        'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                        '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                        '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                        '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                        '        Dim Value As Variant
                        '        j = 0
                        '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                        '            j = j + 1
                        '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                        '            outputDataArray(j, i) = Value
                        '        Next Value
                        '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                        '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                        '    Else
                        '    End If
                        'Next i
                        If responseJSONDict.Exists("Database_say") Then
                            If IsArray(responseJSONDict.Item("Database_say")) Then
                                'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                                'Debug.Print responseJSONDict.Item("Database_say").Count
                                'Dim Value As Variant
                                j = 0
                                For Each Value In responseJSONDict.Item("Database_say")
                                    j = j + 1
                                    'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                    outputDataArray(j, 1) = Value
                                    'outputDataArray(j, k) = Value
                                Next Value
                            ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                                outputDataArray(1, 1) = responseJSONDict("Database_say")
                                'outputDataArray(k, 1) = responseJSONDict("Database_say")
                            Else
                            End If
                        End If
                        'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                        '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                        '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                        '    Next j
                        'Next i

                        responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                        'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存


                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                        If k <= 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        ElseIf k > 1 Then

                            'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                            '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                ''RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataNameArray
                                ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                                    'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                                    '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Next j
                                    Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                    'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    ''RNG = outputDataNameArray
                            '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Next j
                            '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                            '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                            If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                                Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                Set RNG = Cells(Rows.Count, CInt(RNG.Column)).End(xlUp): Rem 將 Excel 工作簿中的 CInt(RNG.Column) 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, CInt(RNG.Column)) 中的 CInt(RNG.Column) 表示 Excel 工作表的第 CInt(RNG.Column) 列（區域 ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition) 中的第 1 列）
                                'Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                                'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                                'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                                Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                                'Debug.Print RNG.Row & " × " & RNG.Column

                                'RNG = outputDataArray
                                '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                                RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                                ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                                'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                                '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                                '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                                '    Next j
                                'Next i

                                'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                            '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                            '    'Exit Sub

                            '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                            '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                            '    'Set RNG = RNG.Offset(2, 0): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                            '    Set RNG = RNG.Offset(1, 0): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                            '    'Debug.Print RNG.Row & " × " & RNG.Column

                            '    'RNG = outputDataArray
                            '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                            '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                            '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                            '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                            '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                            '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    '    Next j
                            '    'Next i

                            '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                            Else
                            End If

                            '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                            ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                            'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                            'Columns("C:J").Clear: Rem 清空 C 至 J 列
                            'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                            'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                            'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                            'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                            'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                            'ActiveCell.Row: Rem 返回活動單元格的行號
                            'ActiveCell.Column: Rem 返回活動單元格的列號
                            'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                            'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                            Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                            'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                            'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                            ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                            'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                            ReDim outputDataArray(0): Rem 清空數組，釋放内存
                            'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

                        Else
                        End If

                        '刷新控制面板窗體控件中包含的提示標簽顯示值
                        If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                            DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                        End If

                    Next k

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    Number_of_Retrieval = 0

                    Exit Sub

                Case Is = "Add table(collection)"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    '使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray, Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    requestJSONText = JsonConverter.ConvertToJson(requestJSONArray): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    'Debug.Print requestJSONText

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                    Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                    WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    'requestJSONText = "": Rem 置空，釋放内存

                    '讀取服務器返回的響應值
                    WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                    responseJSONText = WHR.responseText
                    'Debug.Print responseJSONText
                    'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'Debug.Print responseJSONText

                    'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                    'Set HTMLCode = Nothing
                    'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If


                    ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                    '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                    'Debug.Print responseJSONArray.Count
                    ''For i = 1 To responseJSONArray.Count
                    ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                    ''        'Debug.Print responseJSONArray(i).Keys()(j)
                    ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                    ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                    ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                    ''    Next j
                    ''Next i
                    'Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONArray
                    '    i = i + 1
                    '    'Debug.Print LBound(Value.Keys())
                    '    'Debug.Print UBound(Value.Keys())
                    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                    '        'Debug.Print Value.Keys()(j)
                    '        'Debug.Print Value.Exists(Value.Keys()(j))
                    '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                    '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                    '    Next j
                    'Next Value

                    'responseJSONText = "": Rem 置空，釋放内存
                    'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                    'If responseJSONArray.Count > 0 Then

                    '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                    '    Dim max_Rows As Integer
                    '    max_Rows = responseJSONArray.Count
                    '    Dim max_Columns As Integer
                    '    max_Columns = 0
                    '    'Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '        End If
                    '    Next Value

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                    '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                    '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                    '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '    Next j

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    'Debug.Print responseJSONArray.Count
                    '    'For i = 1 To responseJSONArray.Count
                    '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                    '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                    '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                    '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                    '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '    Next j
                    '    'Next i
                    '    Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        'Debug.Print LBound(Value.Keys())
                    '        'Debug.Print UBound(Value.Keys())
                    '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                    '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                    '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                    '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '        Next j
                    '    Next Value

                    'End If

                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                    Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                    'Debug.Print responseJSONDict.Count
                    'Debug.Print LBound(responseJSONDict.Keys())
                    'Debug.Print UBound(responseJSONDict.Keys())
                    'Dim Value As Variant
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    'Debug.Print responseJSONDict.Keys()(i)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                    '    'Next j
                    '    j = 0
                    '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                    '        j = j + 1
                    '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                    '    Next Value
                    'Next i

                    responseJSONText = "": Rem 置空，釋放内存


                    '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                    'Dim max_Columns As Integer
                    max_Columns = 0
                    ''Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONDict
                    '    i = i + 1
                    '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '    End If
                    'Next Value
                    max_Columns = 1
                    'Debug.Print max_Columns

                    '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                    'Dim max_Rows As Integer
                    max_Rows = 0
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                    '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                    '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                    '        End If
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        If max_Rows < 1 Then
                    '            max_Rows = 1
                    '        End If
                    '    Else
                    '    End If
                    'Next i
                    '檢查字典中是否已經指定的鍵值對
                    'Debug.Print responseJSONDict.Exists("Database_say")
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                            End If
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            If max_Rows < 1 Then
                                max_Rows = 1
                            End If
                        Else
                        End If
                    End If
                    'Debug.Print max_Rows

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                    '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    'Next j
                    outputDataNameArray(1) = CStr("Database_say")
                    'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                    '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                    'Next i

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                    '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                    '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                    '        Dim Value As Variant
                    '        j = 0
                    '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                    '            j = j + 1
                    '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                    '            outputDataArray(j, i) = Value
                    '        Next Value
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    Else
                    '    End If
                    'Next i
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            'Debug.Print responseJSONDict.Item("Database_say").Count
                            'Dim Value As Variant
                            j = 0
                            For Each Value In responseJSONDict.Item("Database_say")
                                j = j + 1
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                outputDataArray(j, 1) = Value
                            Next Value
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                            outputDataArray(1, 1) = responseJSONDict("Database_say")
                        Else
                        End If
                    End If
                    'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                    '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                    '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                    '    Next j
                    'Next i

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                    LabelText = ""
                    If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                        LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    Else
                        ''使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        ''Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'If CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) = CInt(0) Then
                        '    LabelText = "數據庫未寫入數據."
                        'ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) > CInt(0) Then
                        '    LabelText = "向數據庫中寫入「" & CStr(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) & "」條數據成功."
                        'Else
                        'End If
                        LabelText = "對數據庫新增「" & CStr(Data_table_custom_name) & "」集合（表格）成功."
                        'LabelText = "對數據庫「" & CStr(Database_custom_name) & "」新增「" & CStr(Data_table_custom_name) & "」集合（表格）成功."
                    End If
                    'Debug.Print LabelText
                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                    '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        ''RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    ''RNG = outputDataNameArray
                    '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                    '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                    '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Next j
                    '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    'RNG = outputDataArray
                    '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                    '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                    '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '    Next j
                    '    'Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                    ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                    'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                    'Columns("C:J").Clear: Rem 清空 C 至 J 列
                    'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                    'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                    'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                    'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                    'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                    'ActiveCell.Row: Rem 返回活動單元格的行號
                    'ActiveCell.Column: Rem 返回活動單元格的列號
                    'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                    'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataArray(0): Rem 清空數組，釋放内存
                    Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    Exit Sub

                Case Is = "Delete table(collection)"

                    'For i = LBound(requestJSONArray, 1) To UBound(requestJSONArray, 1)
                    '    Debug.Print i
                    '    Debug.Print JsonConverter.ConvertToJson(requestJSONArray(i))
                    'Next i

                    '創建一個 http 客戶端 AJAX 鏈接器，即 VBA 的 XMLHttpRequest 對象;
                    'Dim WHR As Object: Rem 創建一個 XMLHttpRequest 對象
                    'Set WHR = CreateObject("WinHttp.WinHttpRequest.5.1"): Rem 創建並引用 WinHttp.WinHttpRequest.5.1 對象。Msxml2.XMLHTTP 對象和 Microsoft.XMLHTTP 對象不可以在發送 header 中包括 Cookie 和 referer。MSXML2.ServerXMLHTTP 對象可以在 header 中發送 Cookie 但不能發 referer。
                    WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;
                    'Dim resolveTimeout, connectTimeout, sendTimeout, receiveTimeout
                    resolveTimeout = 10000: Rem 解析 DNS 名字的超時時長，10000 毫秒。
                    connectTimeout = Public_Delay_length: Rem 10000: Rem: 建立 Winsock 鏈接的超時時長，10000 毫秒。
                    sendTimeout = Public_Delay_length: Rem 120000: Rem 發送數據的超時時長，120000 毫秒。
                    receiveTimeout = Public_Delay_length: Rem 60000: Rem 接收 response 的超時時長，60000 毫秒。
                    WHR.SetTimeouts resolveTimeout, connectTimeout, sendTimeout, receiveTimeout: Rem 設置操作超時時長;

                    WHR.Option(6) = False: Rem 當取 True 值時，表示當請求頁面重定向跳轉時自動跳轉，當取 False 值時，表示不自動跳轉，截取服務端返回的的 302 狀態。
                    'WHR.Option(4) = 13056: Rem 忽略錯誤標志

                    '"http://localhost:27016/insertMany?dbName=MathematicalStatisticsData&dbTableName=LC5PFit&dbUser=admin_MathematicalStatisticsData&dbPass=admin&Key=username:password"
                    WHR.Open "post", Database_Server_Url_split, False: Rem 創建與數據庫服務器的鏈接，采用 post 方式請求，參數 False 表示阻塞進程，等待收到服務器返回的響應數據的時候再繼續執行後續的代碼語句，當還沒收到服務器返回的響應數據時，就會卡在這裏（阻塞），直到收到服務器響應數據爲止，如果取 True 值就表示不等待（阻塞），直接繼續執行後面的代碼，就是所謂的異步獲取數據。
                    WHR.SetRequestHeader "Content-Type", "text/html;encoding=gbk": Rem 請求頭參數：編碼方式
                    WHR.SetRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*": Rem 請求頭參數：用戶端接受的數據類型
                    WHR.SetRequestHeader "Referer", "http://localhost:8001/": Rem 請求頭參數：著名發送請求來源
                    WHR.SetRequestHeader "Accept-Language", "zh-CHT,zh-TW,zh-HK,zh-MO,zh-SG,zh-CHS,zh-CN,zh-SG,en-US,en-GB,en-CA,en-AU;" '請求頭參數：用戶系統語言
                    WHR.SetRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko"  '"Chrome/65.0.3325.181 Safari/537.36": Rem 請求頭參數：用戶端瀏覽器姓名版本信息
                    WHR.SetRequestHeader "Connection", "Keep-Alive": Rem 請求頭參數：保持鏈接。當取 "Close" 值時，表示保持連接。

                    'Dim requst_Authorization As String
                    requst_Authorization = ""
                    If (Database_Server_Url_split <> "") And (InStr(1, Database_Server_Url_split, "&Key=", 1) <> 0) Then
                        requst_Authorization = CStr(VBA.Split(Database_Server_Url_split, "&Key=")(1))
                        If InStr(1, requst_Authorization, "&", 1) <> 0 Then
                            requst_Authorization = CStr(VBA.Split(requst_Authorization, "&")(0))
                        End If
                    End If
                    'Debug.Print requst_Authorization
                    If requst_Authorization <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            requst_Authorization = CStr("Basic") & " " & CStr(DatabaseControlPanel.Base64Encode(CStr(requst_Authorization)))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    requst_Authorization = CStr(VBA.Split(requst_Authorization, " ")(0)) & " " & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(requst_Authorization, " ")(1))))
                        'End If
                        WHR.SetRequestHeader "authorization", requst_Authorization: Rem 設置請求頭參數：請求驗證賬號密碼。
                    End If
                    'Debug.Print requst_Authorization: Rem 在立即窗口打印拼接後的請求驗證賬號密碼值。

                    'Dim CookiePparameter As String: Rem 請求 Cookie 值字符串
                    CookiePparameter = "Session_ID=request_Key->username:password"
                    'CookiePparameter = "Session_ID=" & "request_Key->username:password" _
                    '                 & "&FSSBBIl1UgzbN7N80S=" & CookieFSSBBIl1UgzbN7N80S _
                    '                 & "&FSSBBIl1UgzbN7N80T=" & CookieFSSBBIl1UgzbN7N80T
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。
                    If CookiePparameter <> "" Then
                        If Not (DatabaseControlPanel.Controls("Base64Encode") Is Nothing) Then
                            CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Encode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        End If
                        'If Not (DatabaseControlPanel.Controls("Base64Decode") Is Nothing) Then
                        '    CookiePparameter = CStr(VBA.Split(CookiePparameter, "=")(0)) & "=" & CStr(DatabaseControlPanel.Base64Decode(CStr(VBA.Split(CookiePparameter, "=")(1))))
                        'End If
                        WHR.SetRequestHeader "Cookie", CookiePparameter: Rem 設置請求頭參數：請求 Cookie。
                    End If
                    'Debug.Print CookiePparameter: Rem 在立即窗口打印拼接後的請求 Cookie 值。

                    'WHR.SetRequestHeader "Accept-Encoding", "gzip, deflate": Rem 請求頭參數：表示通知服務器端返回 gzip, deflate 壓縮過的編碼

                    '使用第三方模組（Module）：clsJsConverter，將請求數據一維數組 requestJSONArray 轉換爲向數據庫服務器發送的原始數據的 JSON 格式的字符串，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符將被轉換爲 unicode 編碼;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'requestJSONText = JsonConverter.ConvertToJson(requestJSONArray, Whitespace:=2): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    requestJSONText = JsonConverter.ConvertToJson(requestJSONArray): Rem 向數據庫服務器發送的請求數據的 JSON 格式的字符串;
                    'Debug.Print requestJSONText

                    'rowDataDict.RemoveAll: Rem 清空字典，釋放内存
                    Set rowDataDict = Nothing: Rem 清空對象變量“rowDataDict”，釋放内存
                    'ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                    Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向數據庫服務器發送請求 upload data …": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    WHR.SetRequestHeader "Content-Length", Len(requestJSONText): Rem 請求頭參數：POST 的内容長度。

                    WHR.Send (requestJSONText): Rem 向服務器發送 Http 請求(即請求下載網頁數據)，若在 WHR.Open 時使用 "get" 方法，可直接調用“WHR.Send”發送，不必有後面的括號中的參數 (PostCode)。
                    'WHR.WaitForResponse: Rem 等待返回请求，XMLHTTP中也可以使用

                    'requestJSONText = "": Rem 置空，釋放内存

                    '讀取服務器返回的響應值
                    WHR.Response.Write.Status: Rem 表示服務器端接到請求後，返回的 HTTP 響應狀態碼
                    WHR.Response.Write.responseText: Rem 設定服務器端返回的響應值，以文本形式寫入
                    'WHR.Response.BinaryWrite.ResponseBody: Rem 設定服務器端返回的響應值，以二進制數據的形式寫入

                    ''Dim HTMLCode As Object: Rem 聲明一個 htmlfile 對象變量，用於保存返回的響應值，通常為 HTML 網頁源代碼
                    ''Set HTMLCode = CreateObject("htmlfile"): Rem 創建一個 htmlfile 對象，對象變量賦值需要使用 set 關鍵字并且不能省略，普通變量賦值使用 let 關鍵字可以省略
                    '''HTMLCode.designMode = "on": Rem 開啓編輯模式
                    'HTMLCode.write .responseText: Rem 寫入數據，將服務器返回的響應值，賦給之前聲明的 htmlfile 類型的對象變量“HTMLCode”，包括響應頭文檔
                    'HTMLCode.body.innerhtml = WHR.responseText: Rem 將服務器返回的響應值 HTML 網頁源碼中的網頁體（body）文檔部分的代碼，賦值給之前聲明的 htmlfile 類型的對象變量“HTMLCode”。參數 “responsetext” 代表服務器接到客戶端發送的 Http 請求之後，返回的響應值，通常為 HTML 源代碼。有三種形式，若使用參數 ResponseText 表示將服務器返回的響應值解析為字符型文本數據；若使用參數 ResponseXML 表示將服務器返回的響應值為 DOM 對象，若將響應值解析為 DOM 對象，後續則可以使用 JavaScript 語言操作 DOM 對象，若想將響應值解析為 DOM 對象就要求服務器返回的響應值必須爲 XML 類型字符串。若使用參數 ResponseBody 表示將服務器返回的響應值解析為二進制類型的數據，二進制數據可以使用 Adodb.Stream 進行操作。
                    'HTMLCode.body.innerhtml = StrConv(HTMLCode.body.innerhtml, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'HTMLHead = WHR.GetAllResponseHeaders: Rem 讀取服務器返回的響應值 HTML 網頁源代碼中的頭（head）文檔，如果需要提取網頁頭文檔中的 Cookie 參數值，可使用“.GetResponseHeader("set-cookie")”方法。

                    'Dim responseJSONText As String: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串;
                    responseJSONText = WHR.responseText
                    'Debug.Print responseJSONText
                    'responseJSONText = StrConv(responseJSONText, vbUnicode, &H804): Rem 將下載後的服務器響應值字符串轉換爲 GBK 編碼。當解析響應值顯示亂碼時，就可以通過使用 StrConv 函數將字符串編碼轉換爲自定義指定的 GBK 編碼，這樣就會顯示簡體中文，&H804：GBK，&H404：big5。
                    'Debug.Print responseJSONText

                    'WHR.abort: Rem 把 XMLHttpRequest 對象復位到未初始化狀態;

                    'Set HTMLCode = Nothing
                    'Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "從數據庫服務器接收響應值結果 download result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If


                    ''Dim responseJSONArray As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 數組對象;

                    '使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                    '使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                    'Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                    'Set responseJSONArray = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                    'Debug.Print responseJSONArray.Count
                    ''For i = 1 To responseJSONArray.Count
                    ''    'Debug.Print LBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print UBound(responseJSONArray(i).Keys())
                    ''    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    ''    For j = LBound(responseJSONArray(i).Keys()) To UBound(responseJSONArray(i).Keys())
                    ''        'Debug.Print responseJSONArray(i).Keys()(j)
                    ''        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(j))
                    ''        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j)))
                    ''        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(j)) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(j))))
                    ''    Next j
                    ''Next i
                    'Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONArray
                    '    i = i + 1
                    '    'Debug.Print LBound(Value.Keys())
                    '    'Debug.Print UBound(Value.Keys())
                    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '    For j = LBound(Value.Keys()) To UBound(Value.Keys())
                    '        'Debug.Print Value.Keys()(j)
                    '        'Debug.Print Value.Exists(Value.Keys()(j))
                    '        'Debug.Print Value.Item(CStr(Value.Keys()(j)))
                    '        Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(j)) & ") = " & CStr(Value.Item(CStr(Value.Keys()(j))))
                    '    Next j
                    'Next Value

                    'responseJSONText = "": Rem 置空，釋放内存
                    'Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    ''將結果響應值結果數組 responseJSONArray 中的的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中和鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    'Dim outputDataNameArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長一維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    ''ReDim outputDataNameArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'Dim outputDataArray() As Variant: Rem Variant、Integer、Long、Single、Double，聲明一個不定長二維數組變量，用於存放數據庫服務器返回的響應值結果，注意 VBA 的二維數組索引是（行號，列號）格式
                    ''ReDim outputDataArray(1 To max_Rows, 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + CInt(1))) As Single: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式

                    'If responseJSONArray.Count > 0 Then

                    '    '求取結果字典 responseJSONDict 指定的數據元素中的最大行、列數:
                    '    Dim max_Rows As Integer
                    '    max_Rows = responseJSONArray.Count
                    '    Dim max_Columns As Integer
                    '    max_Columns = 0
                    '    'Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '            max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '        End If
                    '    Next Value

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    '    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    For j = 1 To CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        'Debug.Print responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '        'Debug.Print responseJSONArray(1).Exists(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))
                    '        'Debug.Print responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))))
                    '        'Debug.Print "responseJSONArray (" & CStr(1) & ").Item(" & CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))) & ") = " & CStr(responseJSONArray(1).Item(CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1))))))
                    '        Debug.Print "responseJSONArray (" & CStr(1) & ").Count = " & CInt(UBound(responseJSONArray(1).Keys()) - LBound(responseJSONArray(1).Keys()) + 1)
                    '        outputDataNameArray(j) = CStr(responseJSONArray(1).Keys()(CInt(LBound(responseJSONArray(1).Keys()) + j - 1)))
                    '    Next j

                    '    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    '    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    '    'Debug.Print responseJSONArray.Count
                    '    'For i = 1 To responseJSONArray.Count
                    '    '    'Debug.Print LBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print UBound(responseJSONArray(i).Keys())
                    '    '    'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()))
                    '    '    For j = 1 To CInt(UBound(responseJSONArray(i).Keys()) - LBound(responseJSONArray(i).Keys()) + 1)
                    '    '        'Debug.Print responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))
                    '    '        'Debug.Print responseJSONArray(i).Exists(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))
                    '    '        'Debug.Print responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '        'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))) & ") = " & CStr(responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1)))))
                    '    '        outputDataArray(i, j) = responseJSONArray(i).Item(CStr(responseJSONArray(i).Keys()(CInt(LBound(responseJSONArray(i).Keys()) + j - 1))))
                    '    '    Next j
                    '    'Next i
                    '    Dim Value As Variant
                    '    i = 0
                    '    For Each Value In responseJSONArray
                    '        i = i + 1
                    '        'Debug.Print LBound(Value.Keys())
                    '        'Debug.Print UBound(Value.Keys())
                    '        'Debug.Print "responseJSONArray:(" & i & ") = " & CInt(UBound(Value.Keys()) - LBound(Value.Keys()))
                    '        For j = 1 To CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '            'Debug.Print Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))
                    '            'Debug.Print Value.Exists(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))
                    '            'Debug.Print Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '            'Debug.Print "responseJSONArray (" & i & ").Item(" & CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))) & ") = " & CStr(Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1)))))
                    '            outputDataArray(i, j) = Value.Item(CStr(Value.Keys()(CInt(LBound(Value.Keys()) + j - 1))))
                    '        Next j
                    '    Next Value

                    'End If

                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    ''Dim responseJSONDict As Object: Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換後的 VBA 字典對象;

                    Set responseJSONDict = JsonConverter.ParseJson(responseJSONText): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典對象;
                    'Debug.Print responseJSONDict.Count
                    'Debug.Print LBound(responseJSONDict.Keys())
                    'Debug.Print UBound(responseJSONDict.Keys())
                    'Dim Value As Variant
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    'Debug.Print responseJSONDict.Keys()(i)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(i))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i)))(1)
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    'For j = 1 To responseJSONDict.Item(CStr(responseJSONDict.Keys()(i))).Count
                    '    '    Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & responseJSONDict.Item(responseJSONDict.Keys()(i))(j)
                    '    'Next j
                    '    j = 0
                    '    For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(i))
                    '        j = j + 1
                    '        Debug.Print CStr(responseJSONDict.Keys()(i)) & ":(" & j & ") = " & Value
                    '    Next Value
                    'Next i

                    responseJSONText = "": Rem 置空，釋放内存


                    '求取結果字典 responseJSONDict 所有數據元素中的最大列數:
                    'Dim max_Columns As Integer
                    max_Columns = 0
                    ''Dim Value As Variant
                    'i = 0
                    'For Each Value In responseJSONDict
                    '    i = i + 1
                    '    If CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1) > max_Columns Then
                    '        max_Columns = CInt(UBound(Value.Keys()) - LBound(Value.Keys()) + 1)
                    '    End If
                    'Next Value
                    max_Columns = 1
                    'Debug.Print max_Columns

                    '求取結果字典 responseJSONDict 所有數據元素中的最大行數:
                    'Dim max_Rows As Integer
                    max_Rows = 0
                    'For i = LBound(responseJSONDict.Keys()) To UBound(responseJSONDict.Keys())
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        'TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "Array"
                    '        If CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count) > max_Rows Then
                    '            max_Rows = CInt(responseJSONDict.Item(responseJSONDict.Keys()(i)).Count)
                    '        End If
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(i))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(i))) Then
                    '        If max_Rows < 1 Then
                    '            max_Rows = 1
                    '        End If
                    '    Else
                    '    End If
                    'Next i
                    '檢查字典中是否已經指定的鍵值對
                    'Debug.Print responseJSONDict.Exists("Database_say")
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            If CInt(responseJSONDict.Item("Database_say").Count) > max_Rows Then
                                max_Rows = CInt(responseJSONDict.Item("Database_say").Count)
                            End If
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            If max_Rows < 1 Then
                                max_Rows = 1
                            End If
                        Else
                        End If
                    End If
                    'Debug.Print max_Rows

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的名稱鍵（Key）字符串值轉存至一維數組 outputDataNameArray 中：
                    ReDim outputDataNameArray(1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For j = 1 To CInt(UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1)
                    '    'Debug.Print responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))))
                    '    'Debug.Print responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1))) & ") = " & CStr(responseJSONDict.Item(CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))))
                    '    outputDataNameArray(j) = CStr(responseJSONDict.Keys()(CInt(LBound(responseJSONDict.Keys()) + j - 1)))
                    'Next j
                    outputDataNameArray(1) = CStr("Database_say")
                    'For i = LBound(outputDataNameArray, 1) To UBound(outputDataNameArray, 1)
                    '    Debug.Print "outputDataNameArray:(" & i & ") = " & outputDataNameArray(i)
                    'Next i

                    '將結果字典 responseJSONDict 中的鍵值對（Key:Value）數據的值（Value）轉存至二維數組 outputDataArray 中：
                    ReDim outputDataArray(1 To max_Rows, 1 To max_Columns) As Variant: Rem Variant、Integer、Long、Single、Double，重置二維數組變量的行列維度，用於存放算法服務器返回的計算結果，注意 VBA 的二維數組索引是（行號、列號）格式
                    'For i = 1 To UBound(responseJSONDict.Keys()) - LBound(responseJSONDict.Keys()) + 1
                    '    'Debug.Print responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Exists(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)
                    '    'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    If IsArray(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'TypeName(responseJSONDict.Item(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))) = "Array"
                    '        'Debug.Print responseJSONDict.Item(CStr(requestJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))).Count
                    '        Dim Value As Variant
                    '        j = 0
                    '        For Each Value In responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))
                    '            j = j + 1
                    '            'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ")(" & j & ") = " & Value
                    '            outputDataArray(j, i) = Value
                    '        Next Value
                    '    ElseIf (TypeName(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) = "String") Or IsNumeric(responseJSONDict.Item(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1))) Then
                    '        'Debug.Print "responseJSONDict.Item(" & CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)) & ") = " & responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '        outputDataArray(1, i) = responseJSONDict(CStr(responseJSONDict.Keys()(LBound(responseJSONDict.Keys()) + i - 1)))
                    '    Else
                    '    End If
                    'Next i
                    If responseJSONDict.Exists("Database_say") Then
                        If IsArray(responseJSONDict.Item("Database_say")) Then
                            'TypeName(responseJSONDict.Item("Database_say")) = "Array"
                            'Debug.Print responseJSONDict.Item("Database_say").Count
                            'Dim Value As Variant
                            j = 0
                            For Each Value In responseJSONDict.Item("Database_say")
                                j = j + 1
                                'Debug.Print "responseJSONDict.Item(" & "Database_say" & ")(" & j & ") = " & Value
                                outputDataArray(j, 1) = Value
                            Next Value
                        ElseIf (TypeName(responseJSONDict.Item("Database_say")) = "String") Or IsNumeric(responseJSONDict.Item("Database_say")) Then
                            'Debug.Print "responseJSONDict.Item(" & "Database_say" & ") = " & responseJSONDict("Database_say")
                            outputDataArray(1, 1) = responseJSONDict("Database_say")
                        Else
                        End If
                    End If
                    'For i = LBound(outputDataArray, 1) To UBound(outputDataArray, 1)
                    '    For j = LBound(outputDataArray, 2) To UBound(outputDataArray, 2)
                    '        Debug.Print "outputDataArray:(" & i & ", " & j & ") = " & outputDataArray(i, j)
                    '    Next j
                    'Next i

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    'Debug.Print "Database_say: " & responseJSONDict("Database_say")
                    LabelText = ""
                    If (InStr(1, responseJSONDict("Database_say"), "error", 1) > 0) Or (InStr(1, responseJSONDict("Database_say"), "Error", 1) > 0) Then
                        LabelText = CStr(responseJSONDict("Database_say")): Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    Else
                        ''使用第三方模組（Module）：clsJsConverter，將數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 字典或 VBA 數組對象，注意如漢字等非（ASCII, American Standard Code for Information Interchange，美國信息交換標準代碼）字符是使用對應的 unicode 編碼表示的;
                        ''使用第三方模組（Module）：clsJsConverter 的 Github 官方倉庫網址：https://github.com/VBA-tools/VBA-JSON
                        ''Dim JsonConverter As New clsJsConverter: Rem 聲明一個 JSON 解析器（clsJsConverter）對象變量，用於 JSON 字符串和 VBA 字典（Dict）或 VBA 數組（Array）之間互相轉換；JSON 解析器（clsJsConverter）對象變量是第三方類模塊 clsJsConverter 中自定義封裝，使用前需要確保已經導入該類模塊。
                        ''Set LabelDict = JsonConverter.ParseJson(responseJSONDict("Database_say")): Rem 數據庫服務器響應返回的結果的 JSON 格式的字符串轉換爲 VBA 數組對象;
                        'If CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) = CInt(0) Then
                        '    LabelText = "數據庫未寫入數據."
                        'ElseIf CInt(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) > CInt(0) Then
                        '    LabelText = "向數據庫中寫入「" & CStr(JsonConverter.ParseJson(responseJSONDict("Database_say"))("insertedCount")) & "」條數據成功."
                        'Else
                        'End If
                        LabelText = "對數據庫刪除「" & CStr(Data_table_custom_name) & "」集合（表格）成功."
                        'LabelText = "對數據庫「" & CStr(Database_custom_name) & "」刪除「" & CStr(Data_table_custom_name) & "」集合（表格）成功."
                    End If
                    'Debug.Print LabelText
                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存

                    responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = "向 Excel 表格中寫入響應值結果 write result.": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'Dim RNG As Range: Rem 定義一個 Range 對象變量“Rng”，Range 對象是指 Excel 工作表單元格或者單元格區域

                    '將存放數據庫響應值結果的一維數組 outputDataNameArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_name_output_sheetName <> "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_name_output_sheetName).Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        ''RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_name_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataNameArray
                        ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                            'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                            '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Next j
                            Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                            'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_name_output_sheetName = "") And (Result_name_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    ''RNG = outputDataNameArray
                    '    ''使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    'RNG.Resize(CInt(UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1) + CInt(1)), CInt(1)) = outputDataNameArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    '使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    For i = 0 To UBound(outputDataNameArray, 1) - LBound(outputDataNameArray, 1)
                    '        'For j = 0 To UBound(outputDataNameArray, 2) - LBound(outputDataNameArray, 2)
                    '        '    Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        '    'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i, LBound(outputDataNameArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Next j
                    '        Cells(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '        'Range(CInt(RNG.Row), CInt(CInt(RNG.Column) + CInt(i))).Value = outputDataNameArray(LBound(outputDataNameArray, 1) + i): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存


                    '將存放數據庫響應值結果的二維數組 outputDataArray 中的數據寫入 Excel 表格指定的位置的單元格中：
                    If (Result_output_sheetName <> "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.Worksheets(Result_output_sheetName).Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition <> "") Then

                        Set RNG = ThisWorkbook.ActiveSheet.Range(Result_output_rangePosition)
                        'Debug.Print RNG.Row & " × " & RNG.Column

                        'RNG = outputDataArray
                        '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                        RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                        ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                        'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                        '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                        '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                        '    Next j
                        'Next i

                        'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    'ElseIf (Result_output_sheetName = "") And (Result_output_rangePosition = "") Then

                    '    'MsgBox "統計運算的結果輸出的選擇範圍（Result output = " & CStr(Public_Field_data_output_position) & "）爲空或結構錯誤，目前只能接受類似 Sheet1!A1:C5 結構的字符串."
                    '    'Exit Sub

                    '    Set RNG = Cells(Rows.Count, 1).End(xlUp): Rem 將 Excel 工作簿中的 A 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 1) 中的 1 表示 Excel 工作表的第 1 列（A 列）
                    '    'Set RNG = Cells(Rows.Count, 2).End(xlUp): Rem 將 Excel 工作簿中的 B 列的最後一個非空單元格賦予變量 RNG，參數 (Rows.Count, 2) 中的 2 表示 Excel 工作表的第 2 列（B 列）
                    '    'Set RNG = RNG.Offset(2): Rem 將變量 Rng 重置為 Rng 的同列下兩行的單元格（即同列的第二個空單元格）
                    '    Set RNG = RNG.Offset(1): Rem 將變量 Rng 重置為 Rng 的同列下一行的單元格（即同列的第一個空單元格）
                    '    'Debug.Print RNG.Row & " × " & RNG.Column

                    '    'RNG = outputDataArray
                    '    '使用 Range(2, 1).Resize(4, 3) = array 或者 Cells(2, 1).Resize(4, 3) = array 的方法，將二維數組一次性寫入 Excel 工作表中指定區域的單元格中，參數 .Resize(4, 3) 表示 Excel 工作表選中區域的大小為 4 行 × 3 列，參數 Range(2, 1). 或 Cells(2, 1). 表示 Excel 工作表選中區域的一個定位，選中區域的左上角的第一個單元格的坐標值，在本例中就是 Excel 工作表中的第 2 行與第 1 列（A 列）焦點的單元格。
                    '    RNG.Resize(CInt(UBound(outputDataArray, 1) - LBound(outputDataArray, 1) + CInt(1)), CInt(UBound(outputDataArray, 2) - LBound(outputDataArray, 2) + CInt(1))) = outputDataArray: Rem 將采集到的結果二維數組賦給指定區域的 Excel 工作簿的單元格，在數據量很大的情況，這種整體賦值方法的效率會顯著高於使用 For 循環賦值的效率。

                    '    ''使用 For 循環嵌套遍歷的方法，將二維數組的值寫入 Excel 工作表的單元格中，假如 Array 為二維數組，則函數 UBound(Array, 1) 表示二維數組的第 1 個維度的最大索引號，函數 UBound(Array, 2) 表示二維數組的第 2 個維度的最大索引號。
                    '    'For i = 0 To UBound(outputDataArray, 1) - LBound(outputDataArray, 1)
                    '    '    For j = 0 To UBound(outputDataArray, 2) - LBound(outputDataArray, 2)
                    '    '        Cells(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '        'Range(CInt(CInt(RNG.Row) + CInt(i)), CInt(CInt(RNG.Column) + CInt(j))).Value = outputDataArray(LBound(outputDataArray, 1) + i, LBound(outputDataArray, 2) + j): Rem 方法 Cell.Row 或 Range.Row 表示 Excel 工作表中指定單元格的行號碼，方法 Cell.Column 或 Range.Column 表示 Excel 工作表中指定單元格的列號碼。
                    '    '    Next j
                    '    'Next i

                    '    'Debug.Print Cells(RNG.Row, RNG.Column).Value: Rem 這條語句用於調試，效果是實時在“立即窗口”打印結果值

                    Else
                    End If

                    '將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處：
                    ActiveWindow.ScrollRow = RNG.Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是，將 Excel 工作表窗口滾動到當前可見單元格總行數的一半處。參數“ActiveWindow.ScrollRow = RNG.Row”表示將當前 Excel 工作表窗口滾動到指定的 RNG 單元格行號的位置，參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總行數，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。
                    'RNG.EntireRow.Delete: Rem 刪除第一行表頭
                    'Columns("C:J").Clear: Rem 清空 C 至 J 列
                    'Windows(1).VisibleRange.Cells.Count: Rem 參數“Windows(1).VisibleRange.Cells.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的總數
                    'Windows(1).VisibleRange.Cells.Rows.Count: Rem 參數“Windows(1).VisibleRange.Cells.Rows.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂行數
                    'Windows(1).VisibleRange.Cells.Columns.Count: Rem 參數“Windows(1).VisibleRange.Cells.Columns.Count”的意思是計算當前 Excel 工作表窗口中可見單元格的縂列數
                    'ActiveWindow.RangeSelection.Address: Rem 返回選中的單元格的地址（行號和列號）
                    'ActiveCell.Address: Rem 返回活動單元格的地址（行號和列號）
                    'ActiveCell.Row: Rem 返回活動單元格的行號
                    'ActiveCell.Column: Rem 返回活動單元格的列號
                    'ActiveWindow.ScrollRow = ActiveCell.Row: Rem 表示將活動單元格的行號，賦值給 Excel 工作表窗口垂直滾動條滾動到的位置（注意，該參數只能接受長整型 Long 變量），實際的效果就是將 Excel 工作表窗口的上邊界滾動到活動單元格的行號處。
                    'ActiveWindow.ScrollRow = Cells(Rows.Count, 2).End(xlUp).Row - (Windows(1).VisibleRange.Cells.Rows.Count \ 2): Rem 這條語句的作用是將 Excel 工作表窗口滾動到當前可見單元格縂行數的一半處。例如，如果參數“ActiveWindow.ScrollRow = 2”則表示將 Excel 窗口滾動到第二行的位置處，符號“/”在 VBA 中表示普通除法，符號“mod”在 VBA 中表示除法取余數，符號“\”在 VBA 中表示除法取整數，符號“\”與“Int(N/N)”效果相同，函數 Int() 表示取整。

                    Set RNG = Nothing: Rem 清空對象變量“RNG”，釋放内存
                    'responseJSONDict.RemoveAll: Rem 清空字典，釋放内存
                    'Set responseJSONDict = Nothing: Rem 清空對象變量“responseJSONDict”，釋放内存
                    ''ReDim responseJSONArray(0): Rem 清空數組，釋放内存
                    'Erase responseJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
                    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim outputDataArray(0): Rem 清空數組，釋放内存
                    Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存

                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    Exit Sub

                Case Is = "SQL"

                    Debug.Print "MongoDB does not support SQL statements for database operations."

                    '刷新控制面板窗體控件中包含的提示標簽顯示值
                    LabelText = "數據庫：MongoDB 不支持使用 SQL 操作 MongoDB does not support SQL statements for database operations."
                    If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
                        DatabaseControlPanel.Controls("Database_status_Label").Caption = LabelText: Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
                    End If

                    'ReDim inputDataNameArray(0): Rem 清空數組，釋放内存
                    Erase inputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataArray(0): Rem 清空數組，釋放内存
                    Erase inputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataNameArray2(0): Rem 清空數組，釋放内存
                    Erase inputDataNameArray2: Rem 函數 Erase() 表示置空數組，釋放内存
                    'ReDim inputDataArray2(0): Rem 清空數組，釋放内存
                    Erase inputDataArray2: Rem 函數 Erase() 表示置空數組，釋放内存
                    requestJSONDict.RemoveAll: Rem 清空字典（Dict）釋放内存，但六字典（Dict）對象;
                    Set requestJSONDict = Nothing
                    requestJSONText = ""
                    'ReDim requestJSONArray(0): Rem 清空數組，釋放内存
                    Erase requestJSONArray: Rem 函數 Erase() 表示置空數組，釋放内存
                    responseJSONText = ""
                    responseJSONDict.RemoveAll: Rem 清空字典（Dict）釋放内存，但六字典（Dict）對象;
                    Set responseJSONDict = Nothing
                    'ReDim responseJSONArray(0)
                    Erase responseJSONArray
                    'ReDim outputDataNameArray(0)
                    Erase outputDataNameArray
                    'ReDim outputDataArray(0)
                    Erase outputDataArray

                    Set JsonConverter = Nothing: Rem 清空對象變量“JsonConverter”，釋放内存;
                    Set WHR = Nothing: Rem 清空對象變量“WHR”，釋放内存;

                    MsgBox "數據庫：MongoDB 不支持使用 SQL 操作." & Chr(13) & Chr(10) & "MongoDB does not support SQL statements for database operations."

                    Exit Sub

                Case Else

                    MsgBox "輸入的自定義對數據庫操作的指令名稱錯誤，無法識別傳入的名稱（Database operational order name = " & CStr(Database_operational_order) & "），目前只製作完成 (""Add data"", ""Retrieve data"", ""Update data"", ""Delete data"", ""Retrieve count"", ""Add table(collection)"", ""Delete table(collection)"", ""SQL"") 自定義的對數據庫操作的指令."
                    Exit Sub

            End Select

        Case Is = "MariaDB"

        Case Is = "PostgreSQL"

        Case Is = "MySQL"

        Case Else

            MsgBox "輸入的自定義判斷選擇使用的辨識數據庫應用軟體的名稱錯誤，無法識別傳入的名稱（Database software name = " & CStr(Database_software) & "），目前只製作完成 (""Microsoft Office Access""，""MongoDB""，""MariaDB""，""PostgreSQL""，""MySQL"", ...) 等自定義的數據庫管理應用軟體."
            Exit Sub

    End Select

    ''ReDim outputDataNameArray(0): Rem 清空數組，釋放内存
    'Erase outputDataNameArray: Rem 函數 Erase() 表示置空數組，釋放内存
    ''ReDim outputDataArray(0): Rem 清空數組，釋放内存
    'Erase outputDataArray: Rem 函數 Erase() 表示置空數組，釋放内存

    ''刷新控制面板窗體控件中包含的提示標簽顯示值
    'If Not (DatabaseControlPanel.Controls("Database_status_Label") Is Nothing) Then
    '    DatabaseControlPanel.Controls("Database_status_Label").Caption = "待機 Stand by": Rem 提示標簽，如果該控件位於操作面板窗體 DatabaseControlPanel 中，那麽可以用 .Controls() 方法獲取窗體中包含的全部子元素集合，並通過指定子元素名字符串的方式來獲取某一個指定的子元素，例如“DatabaseControlPanel.Controls("Database_status_Label").Text”表示用戶窗體控件中的標簽子元素控件“Web_page_load_status_Label”的“text”屬性值 Web_page_load_status_Label.text。如果該控件位於工作表中，那麽可以使用 OleObjects 對象來表示工作表中包含的所有子元素控件集合，例如 Sheet1 工作表中有控件 CommandButton1，那麽可以這樣獲取：“Sheet1.OLEObjects("CommandButton" & i).Object.Caption 表示 CommandButton1.Caption”，注意 Object 不可省略。
    'End If

End Sub


'Function Number2ColumnLetter(ByVal iCol As Long) As String
'   Dim a&, b&
'   a = iCol
'   Number2ColumnLetter = ""
'   While iCol > 0
'      a = Int((iCol - 1) / 26)
'      b = (iCol - 1) Mod 26
'      Number2ColumnLetter = Chr(b + 65) & Number2ColumnLetter
'      iCol = a
'   Wend
'End Function


'Function ColumnLetter2Number(ByVal ColumnLetter As String) As Long
'    Dim i As Long
'    ColumnLetter2Number = 0
'    For i = 1 To Len(ColumnLetter)
'        ColumnLetter2Number = ColumnLetter2Number * 26 + Asc(Mid(ColumnLetter, i, 1)) - Asc("A") + 1
'    Next i
'End Function


'Sub delay(T As Long): Rem 創建一個自定義精確延時子過程，用於後面需要延時功能時直接調用。用法為：delay(T);“T”就是要延時的時長，單位是毫秒，取值最大範圍是長整型 Long 變量（雙字，4 字節）的最大值，這個值的範圍在 0 到 2^32 之間，大約爲 49.71 日。關鍵字 Private 表示子過程作用域只在本模塊有效，關鍵字 Public 表示子過程作用域在所有模塊都有效
'    On Error Resume Next: Rem 當程序報錯時，跳過報錯的語句，繼續執行下一條語句。
'    Dim time1 As Long
'    time1 = timeGetTime: Rem 函數 timeGetTime 表示系統時間，該時間為從系統開啓算起所經過的時間（單位毫秒），持續纍加記錄。
'    Do
'        'If Not (DatabaseControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'        '    If timeGetTime - time1 < T Then
'        '        DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'        '    End If
'        '    If timeGetTime - time1 >= T Then
'        '        DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'        '    End If
'        'End If
'
'        DoEvents: Rem 語句 DoEvents 表示交出系統 CPU 控制權還給操作系統，也就是在此循環階段，用戶可以同時操作電腦的其它應用，而不是將程序挂起直到循環結束。

'    Loop While timeGetTime - time1 < T
'
'    'If Not (DatabaseControlPanel.Controls("Delay_realtime_prompt_Label") Is Nothing) Then
'    '    If timeGetTime - time1 < T Then
'    '        DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ " & CStr(timeGetTime - time1) & " ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'    '    End If
'    '    If timeGetTime - time1 >= T Then
'    '        DatabaseControlPanel.Controls("Delay_realtime_prompt_Label").Caption = "延時等待 [ 0 ] 毫秒": Rem 刷新提示標簽，顯示人爲延時等待的時間長度，單位毫秒。
'    '    End If
'    'End If
'
'End Sub



'*********************************************************************************************************************************************************************************



'讀取本地硬盤 JSON 文檔數據的示例代碼
'' Advanced example: Read .json file and load into sheet (Windows-only)
'' (add reference to Microsoft Scripting Runtime)
'' {"values":[{"a":1,"b":2,"c": 3},...]}
'
'Dim FSO As New FileSystemObject
'Dim JsonTS As TextStream
'Dim JsonText As String
'Dim Parsed As Dictionary
'
'' Read .json file
'Set JsonTS = FSO.OpenTextFile("example.json", ForReading)
'JsonText = JsonTS.ReadAll
'JsonTS.Close
'
'' Parse json to Dictionary
'' "values" is parsed as Collection
'' each item in "values" is parsed as Dictionary
'Set Parsed = JsonConverter.ParseJson(JsonText)
'
'' Prepare and write values to sheet
'Dim Values As Variant
'ReDim Values(Parsed("values").Count, 3)
'
'Dim Value As Dictionary
'Dim i As Long
'
'i = 0
'For Each Value In Parsed("values")
'  Values(i, 0) = Value("a")
'  Values(i, 1) = Value("b")
'  Values(i, 2) = Value("c")
'  i = i + 1
'Next Value
'
'Sheets("example").Range(Cells(1, 1), Cells(Parsed("values").Count, 3)) = Values

