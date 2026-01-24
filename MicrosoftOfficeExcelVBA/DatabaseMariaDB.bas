Attribute VB_Name = "DatabaseMariaDB"

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
Public Sub Run_MariaDB(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_Server_Url As String, ByVal Database_custom_name As String, ByVal Data_table_custom_name As String, ByVal Database_Server_Username As String, ByVal Database_Server_Password As String, ByVal Field_name_input_position As String, ByVal Field_data_input_position As String, ByVal Field_name_output_position As String, ByVal Field_data_output_position As String, ParamArray OtherArgs())
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


'自定義啓動運算;
Public Sub Run_PostgreSQL(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_Server_Url As String, ByVal Database_custom_name As String, ByVal Data_table_custom_name As String, ByVal Database_Server_Username As String, ByVal Database_Server_Password As String, ByVal Field_name_input_position As String, ByVal Field_data_input_position As String, ByVal Field_name_output_position As String, ByVal Field_data_output_position As String, ParamArray OtherArgs())
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


'自定義啓動運算;
Public Sub Run_MySQL(ByVal Database_software As String, ByVal Database_operational_order As String, ByVal Database_Server_Url As String, ByVal Database_custom_name As String, ByVal Data_table_custom_name As String, ByVal Database_Server_Username As String, ByVal Database_Server_Password As String, ByVal Field_name_input_position As String, ByVal Field_data_input_position As String, ByVal Field_name_output_position As String, ByVal Field_data_output_position As String, ParamArray OtherArgs())
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

