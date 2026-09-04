"user strict";

// 1、載入 Node.js 原生的模組（Model）;
// 媒介服務器函數服務端（後端） http_Server() 使用説明;
// const child_process = require('child_process');  // Node原生的創建子進程模組;
// const os = require('os');  // Node原生的操作系統信息模組;
// const net = require('net');  // Node原生的網卡網絡操作模組;
// const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// const qs = require('querystring');
const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
// const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
// const cluster = require('cluster');  // Node原生的支持多進程模組;
// // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
// const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

// // 1、載入自定義的其它模塊（模塊前需要寫明載入路徑）
// const Interpolation_Fitting = require('./Interpolation_Fitting.js');  // 加載自定義算法模組;  // require(require('path').join(require('path').resolve("."), "Interpolation_Fitting.js")); require('path').resolve("..").toString().concat("/temp/"); 當加載自定義的模塊時，引用模塊需要包括路徑和模塊名的完整引用，只寫模塊名會報錯;
// const LC5PFit = Interpolation_Fitting.LC5PFit;  // 使用「Interpolation_Fitting.js」模塊中的成員「LC5PFit(training_data, testing_data, Pdata_0, weight, Plower Pupper)」函數, 用於邏輯 4、5 參數擬合運算（4, 5 parameter logistic model）;
// const Polynomial3Fit = Interpolation_Fitting.Polynomial3Fit;  // 使用「Interpolation_Fitting.js」模塊中的成員「Polynomial3Fit(training_data, testing_data, Pdata_0, weight, Plower Pupper)」函數, 用於 3 次多項式方程擬合運算（Polynomial 3 (Cubic) model）;
// const MathInterpolation = Interpolation_Fitting.MathInterpolation;  // 使用「Interpolation_Fitting.js」模塊中的成員「MathInterpolation(training_data, testing_data, Interpolation_Method, λ, k, d, h)」函數, 用於插值（Interpolation）運算;



// 'utf8' 字符串轉二進制數組;
function CharStrToBytesArr(str) {
    let bytes = new Array();
    let c = "";
    for (let i = 0; i < str.length; i++) {
        c = str.charCodeAt(i);
        if (c >= 0x010000 && c <= 0x10FFFF) {
            bytes.push(((c >> 18) & 0x07) | 0xF0);
            bytes.push(((c >> 12) & 0x3F) | 0x80);
            bytes.push(((c >> 6) & 0x3F) | 0x80);
            bytes.push((c & 0x3F) | 0x80);
        } else if (c >= 0x000800 && c <= 0x00FFFF) {
            bytes.push(((c >> 12) & 0x0F) | 0xE0);
            bytes.push(((c >> 6) & 0x3F) | 0x80);
            bytes.push((c & 0x3F) | 0x80);
        } else if (c >= 0x000080 && c <= 0x0007FF) {
            bytes.push(((c >> 6) & 0x1F) | 0xC0);
            bytes.push((c & 0x3F) | 0x80);
        } else {
            bytes.push(c & 0xFF);
        };
    };
    return bytes;
};
// module.exports.CharStrToBytesArr = CharStrToBytesArr; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 二進制數組轉 'utf8' 字符串;
function BytesArrToCharStr(arr) {
    if (typeof arr === 'string') {
        return arr;
    };
    let str = '';
    let _arr = arr;
    for (let i = 0; i < _arr.length; i++) {
        let one = _arr[i].toString(2);
        let v = one.match(/^1+?(?=0)/);
        if (v && one.length == 8) {
            let bytesLength = v[0].length;
            let store = _arr[i].toString(2).slice(7 - bytesLength);
            for (let st = 1; st < bytesLength; st++) {
                store += _arr[st + i].toString(2).slice(2);
            };
            str += String.fromCharCode(parseInt(store, 2));
            i += bytesLength - 1;
        } else {
            str += String.fromCharCode(_arr[i]);
        };
    };
    return str;
};
// module.exports.BytesArrToCharStr = BytesArrToCharStr; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 自定義函數，檢測輸入的監聽主機 IP 地址類型，是否爲：IPv6，或是：IPv4;
function check_ip(address) {
    // IPv6 地址由八組四位十六進制數（0-9a-fA-F）構成，每組之間用冒號（:）分隔;
    let IPv6_regex = /^(::)?((([\da-f]{1,4}:){7}[\da-f]{1,4})|(([\da-f]{1,4}:){5}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){4}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){3}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:){2}(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?)|(([\da-f]{1,4}:)(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})?(:[0-9a-fA-F]{1,4})))$/;
    // IPv4 地址由四組數字（0-255）組成，每組之間用點號（.）分隔;
    let IPv4_regex = /^(\d{1,3}\.){3}(\d{1,3})$/;

    if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv6_regex.test(address)) {
        return "IPv6";
    } else if (Object.prototype.toString.call(address).toLowerCase() === '[object string]' && IPv4_regex.test(address)) {
        return "IPv4";
    } else {
        return false;
    };
};
// module.exports.check_ip = check_ip; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 自定義封裝的函數isStringJSON(str)判斷一個字符串是否爲 JSON 格式的字符串;
function isStringJSON(str) {
    // 首先判斷傳入參數 str 是否為一個字符串 typeof (str) === 'string'，如果不是字符串直接返回錯誤;
    if (Object.prototype.toString.call(str).toLowerCase() === '[object string]') {
        try {
            let Obj = JSON.parse(str);
            // 使用語句 if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) 判斷 Obj 是否為一個 JSON 對象;
            if (typeof (Obj) === 'object' && Object.prototype.toString.call(Obj).toLowerCase() === '[object object]' && !(Obj.length)) {
                return true;
            } else {
                return false;
            };
        } catch (error) {
            // console.log(error);
            return false;
        } finally {
            // ;
        };
    } else {
        // console.log("It is not a String!");
        return false;
    };
};
// module.exports.isStringJSON = isStringJSON; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義函數，對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// https://www.npmjs.com/package/js-base64
class base64 {

    constructor () {
        // private property
        let _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        // public method for encoding
        this.encode = function (input) {
            let output = "";
            let chr1, chr2, chr3, enc1, enc2, enc3, enc4;
            let i = 0;
            input = this._utf8_encode(input);
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                if (isNaN(chr2)) {
                    enc3 = enc4 = 64;
                } else if (isNaN(chr3)) {
                    enc4 = 64;
                };
                output = output + _keyStr.charAt(enc1) + _keyStr.charAt(enc2) + _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
            };
            return output;
        };

        // public method for decoding
        this.decode = function (input) {
            let output = "";
            let chr1, chr2, chr3;
            let enc1, enc2, enc3, enc4;
            let i = 0;
            if (typeof(input) !== "undefined" && input !== null) {
                input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                while (i < input.length) {
                    enc1 = _keyStr.indexOf(input.charAt(i++));
                    enc2 = _keyStr.indexOf(input.charAt(i++));
                    enc3 = _keyStr.indexOf(input.charAt(i++));
                    enc4 = _keyStr.indexOf(input.charAt(i++));
                    chr1 = (enc1 << 2) | (enc2 >> 4);
                    chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                    chr3 = ((enc3 & 3) << 6) | enc4;
                    output = output + String.fromCharCode(chr1);
                    if (enc3 != 64) {
                        output = output + String.fromCharCode(chr2);
                    }
                    if (enc4 != 64) {
                        output = output + String.fromCharCode(chr3);
                    };
                };
                output = this._utf8_decode(output);
            };
            return output;
        };
    };

    // private method for UTF-8 encoding
    _utf8_encode = function (str) {
        str = String(str);
        str = str.replace(/\r\n/g, "\n");
        let utftext = "";
        for (let n = 0; n < str.length; n++) {
            let c = str.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            };

        };
        return utftext;
    };

    // private method for UTF-8 decoding
    _utf8_decode = function (utftext) {
        let string = "";
        let i = 0;
        let c = 0;
        let c1 = 0;
        let c2 = 0;
        let c3 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            };
        };
        return string;
    };
};
let Base64 = new base64();
// module.exports.Base64 = Base64; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// 調用示例：
// const Base64 = Interface.Base64;  // 使用「Interface.js」模塊中的成員「Base64()」函數, 用於對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// 解碼：str = new Base64().decode(base64) ，編碼：base64 = new Base64().encode(str);

// 使用遞歸遍歷的方法深拷貝（複製傳值）對象類型變量（例如，數組和JSON對象等類型的數據），實現思路：拷貝的時候判斷屬性值的類型，如果是物件，繼續遞迴呼叫深拷貝函數;
function deepCopy(obj) {
    // 只拷貝對象;
    if (typeof (obj) !== 'object') return obj;
    // 根據 obj 的類型判斷是新建一個數組還是一個JSON對象;
    let newObj = obj instanceof Array ? [] : {};
    // 遍歷 obj，並且判斷是對象的屬性才拷貝;
    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            // 判斷屬性值的類型，如果是對象，則遞歸調用該深拷貝函數;
            newObj[key] = typeof (obj[key]) === 'object' ? deepCopy(obj[key]) : obj[key];
        };
    };
    return newObj;
};
// let newArray = deepCopy(oldArray);
// module.exports.deepCopy = deepCopy; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// // 使用遞歸遍歷的方法淺拷貝（引用傳址）對象類型變量（例如，數組和JSON對象等類型的數據），實現思路：遍歷物件，把屬性和屬性值都放在一個新的物件裡;
// function shallowCopy(obj) {
//     // 只拷貝對象;
//     if (typeof (obj) !== 'object') return obj;
//     // 根據 obj 的類型判斷是新建一個數組還是一個JSON對象;
//     let newObj = obj instanceof Array ? [] : {};
//     // 遍歷 obj，並且判斷是對象的屬性才拷貝;
//     for (let key in obj) {
//         if (obj.hasOwnProperty(key)) {
//             newObj[key] = obj[key];
//         };
//     };
//     return newObj;
// };
// // let newArray = shallowCopy(oldArray);
// module.exports.shallowCopy = shallowCopy; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 同步遞歸刪除非空文件夾，首先獲取到該資料夾裡面所有的資訊，遍歷裡面的資訊，判斷是文檔還是資料夾，如果是文檔直接刪除，如果是資料夾，進入資料夾，遞歸重複上述過程;
function deleteDirSync(absolute_path_String) {

    // const path = require('path'); // 導入Node.js原生的路徑處理模塊;
    // const fs = require('fs'); // 導入Node.js原生的文檔處理模塊;

    let absolute_path = require('path').normalize(absolute_path_String); // 規範化路徑;

    let stat = require('fs').statSync(absolute_path); // 同步查詢文檔;
    if (stat.isFile()) {

        // try {
        //     // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        //     fs.accessSync(absolute_path, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
        //     // console.log("文檔: " + absolute_path + " 可以讀寫.");
        //     // 判斷查看的是否為文檔;

        //     require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        //     console.log("文檔: " + absolute_path + " 已刪除.");
        // } catch (error) {
        //     try {
        //         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
        //         fs.fchmodSync(absolute_path, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
        //         // console.log("文檔: " + absolute_path + " 操作權限修改為可以讀寫.");
        //         // 常量                    八進制值    說明
        //         // fs.constants.S_IRUSR    0o400      所有者可讀
        //         // fs.constants.S_IWUSR    0o200      所有者可寫
        //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
        //         // fs.constants.S_IRGRP    0o40       群組可讀
        //         // fs.constants.S_IWGRP    0o20       群組可寫
        //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
        //         // fs.constants.S_IROTH    0o4        其他人可讀
        //         // fs.constants.S_IWOTH    0o2        其他人可寫
        //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
        //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
        //         // 數字	說明
        //         // 7	可讀、可寫、可執行
        //         // 6	可讀、可寫
        //         // 5	可讀、可執行
        //         // 4	唯讀
        //         // 3	可寫、可執行
        //         // 2	只寫
        //         // 1	只可執行
        //         // 0	沒有許可權
        //         // 例如，八進制值 0o765 表示：
        //         // 1) 、所有者可以讀取、寫入和執行該文檔；
        //         // 2) 、群組可以讀和寫入該文檔；
        //         // 3) 、其他人可以讀取和執行該文檔；
        //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
        //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

        //         // 判斷查看的是否為文檔;
        //         require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        //         console.log("文檔: " + absolute_path + " 已刪除.");
        //     } catch (error) {
        //         console.log("文檔 [ " + absolute_path + " ] 無操作權限.");
        //         console.error(error);
        //     };
        // };

        // 判斷查看的是否為文檔;
        require('fs').unlinkSync(absolute_path); // 同步刪除文檔;
        console.log("文檔: " + absolute_path + " 已刪除.");
    } else if (stat.isDirectory()) {
        let files = require('fs').readdirSync(absolute_path); // 同步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;

        if (files.length > 0) {

            let typeRecognition = true;

            for (let i = 0; i < files.length; i++) {
                let fileName = require('path').join(absolute_path, files[i]); // 使用Node.js原生的路徑處理模塊「path」模塊中的路徑拼接函數獲取文檔全名，與 pathString.concat("/", files[i]) 作用類似;
                // console.log(fileName);
                let stats = require('fs').statSync(fileName); // 同步查詢文檔;
                if (stats.isFile()) {

                    // try {
                    //     // 同步判斷判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(dir, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    //     fs.accessSync(fileName, 0o777);  // 0o777，fs.constants.R_OK | fs.constants.W_OK 可讀寫，fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    //     // console.log("目錄: " + fileName + " 可以讀寫.");
                    //     // 判斷查看的是否為文檔;

                    //     require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    //     console.log("文檔: " + fileName + " 已刪除.");
                    // } catch (error) {
                    //     try {
                    //         // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                    //         fs.fchmodSync(fileName, 0o777);  // fs.constants.S_IRWXO 返回值為 undefined;
                    //         // console.log("目錄: " + fileName + " 操作權限修改為可以讀寫.");
                    //         // 常量                    八進制值    說明
                    //         // fs.constants.S_IRUSR    0o400      所有者可讀
                    //         // fs.constants.S_IWUSR    0o200      所有者可寫
                    //         // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                    //         // fs.constants.S_IRGRP    0o40       群組可讀
                    //         // fs.constants.S_IWGRP    0o20       群組可寫
                    //         // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                    //         // fs.constants.S_IROTH    0o4        其他人可讀
                    //         // fs.constants.S_IWOTH    0o2        其他人可寫
                    //         // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                    //         // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    //         // 數字	說明
                    //         // 7	可讀、可寫、可執行
                    //         // 6	可讀、可寫
                    //         // 5	可讀、可執行
                    //         // 4	唯讀
                    //         // 3	可寫、可執行
                    //         // 2	只寫
                    //         // 1	只可執行
                    //         // 0	沒有許可權
                    //         // 例如，八進制值 0o765 表示：
                    //         // 1) 、所有者可以讀取、寫入和執行該文檔；
                    //         // 2) 、群組可以讀和寫入該文檔；
                    //         // 3) 、其他人可以讀取和執行該文檔；
                    //         // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    //         // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                    //         // 判斷查看的是否為文檔;
                    //         require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    //         console.log("文檔: " + fileName + " 已刪除.");
                    //     } catch (error) {
                    //         console.log("文檔 [ " + fileName + " ] 無操作權限.");
                    //         console.error(error);
                    //     };
                    // };

                    // 判斷查看的是否為文檔;
                    require('fs').unlinkSync(fileName); // 同步刪除文檔;
                    console.log("文檔: " + fileName + " 已刪除.");
                } else if (stats.isDirectory()) {
                    // 判斷查看的是否為文件夾（路徑）;
                    deleteDirSync(fileName);
                    // require('fs').rmdirSync(fileName); // 同步刪除空文件夾;
                } else {
                    console.log("文檔: " + fileName + " 類型無法識別.");
                    typeRecognition = false;
                };
            };

            if (typeRecognition) {
                require('fs').rmdirSync(absolute_path); // 同步刪除空文件夾;
                console.log("文件夾: " + absolute_path + " 已刪除.");
            };

        } else {

            require('fs').rmdirSync(absolute_path); // 同步刪除空文件夾;
            console.log("文件夾: " + absolute_path + " 已刪除.");
        };
    } else {
        console.log("文檔: " + absolute_path + " 類型無法識別.");
    };
};
// module.exports.deleteDirSync = deleteDirSync; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 異步遞歸清空非空文件夾，首先獲取到該資料夾裡面所有的資訊，遍歷裡面的資訊，判斷是文檔還是資料夾，如果是文檔直接刪除，如果是資料夾，進入資料夾，遞歸重複上述過程;
function deleteDir(absolute_path_String, callback) {

    // const path = require('path'); // 導入Node.js原生的路徑處理模塊;
    // const fs = require('fs'); // 導入Node.js原生的文檔處理模塊;

    let absolute_path = require('path').normalize(absolute_path_String); // 規範化路徑;
    // 異步查詢文檔;
    require('fs').stat(absolute_path, { bigint: false }, (error, stats) => {
        if (error) {
            console.log("文檔 " + absolute_path + " 無法判斷類別碼.");
            if (callback) { callback(error, null); };
            throw error;
        };

        // 判斷查看的是否為文檔或文件夾（路徑）;
        if (stats.isFile()) {
            // 異步判斷文檔權限，是否可讀require('fs').constants.R_OK、可寫require('fs').constants.W_OK、可執行require('fs').constants.X_OK;
            require('fs').access(absolute_path, 0o777, (error) => {
                if (error) {
                    console.log("無權限操作文檔 " + absolute_path);
                    require('fs').chmod(absolute_path, 0o777, (error) => {
                        if (error) {
                            console.log("文檔 " + absolute_path + " 無法修改操作權限.");
                            throw error;
                        };
                        console.log("文檔 " + absolute_path + " 操作權限已被修改為 0o777");
                        // 異步刪除文檔;
                        require('fs').unlink(absolute_path, (error) => {
                            if (error) {
                                console.log("文檔 " + absolute_path + " 無法刪除.");
                                if (callback) { callback(error, null); };
                                throw error;
                            };
                            console.log("文檔 " + absolute_path + " 已被刪除.");
                            // console.log("目錄: " + absolute_path + " 已清空.");
                            // // 異步刪除空文件夾;
                            // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                            //     if (error) {
                            //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                            //         typeRecognition = false;
                            //         throw error;
                            //     };
                            // });
                            if (callback) { callback(null, absolute_path); };
                        });
                    });

                } else {

                    // 異步刪除文檔;
                    require('fs').unlink(absolute_path, (error) => {
                        if (error) {
                            console.log("文檔 " + absolute_path + " 無法刪除.");
                            if (callback) { callback(error, null); };
                            throw error;
                        };
                        console.log("文檔 " + absolute_path + " 已被刪除.");
                        // console.log("目錄: " + absolute_path + " 已清空.");
                        // // 異步刪除空文件夾;
                        // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                        //     if (error) {
                        //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                        //         typeRecognition = false;
                        //         throw error;
                        //     };
                        // });
                        if (callback) { callback(null, absolute_path); };
                    });
                };
            });

        } else if (stats.isDirectory()) {
            // 異步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
            require('fs').readdir(absolute_path, { encoding: 'utf8', withFileTypes: false }, (error, files) => {

                if (error) {
                    console.log("輸入輸出數據文檔暫存媒介目錄無法讀取 " + absolute_path);
                    console.error(error);
                };

                let fn = 0;  // 記錄已刪除的文檔數目;
                let dn = 0;  // 記錄已刪除的文件夾數目;
                let l = files.length;

                if (files && files.length > 0) {

                    let typeRecognition = true;

                    for (let i = 0; i < files.length; i++) {

                        let fileName = require('path').join(absolute_path, files[i]); // 使用Node.js原生的路徑處理模塊「path」模塊中的路徑拼接函數獲取文檔全名，與 pathString.concat("/", files[i]) 作用類似;
                        // console.log(fileName);

                        // 異步查詢文檔;
                        require('fs').stat(fileName, { bigint: false }, (error, stats) => {

                            if (error) {
                                console.log("文檔 " + fileName + " 無法判斷類別碼.");
                                typeRecognition = false;
                                throw error;
                            };

                            // 判斷查看的是否為文檔或文件夾（路徑）;
                            if (stats.isFile()) {

                                // 異步判斷文檔權限，是否可讀require('fs').constants.R_OK、可寫require('fs').constants.W_OK、可執行require('fs').constants.X_OK;
                                require('fs').access(fileName, 0o777, (error) => {
                                    if (error) {
                                        console.log("無權限操作文檔 " + fileName);
                                        require('fs').chmod(fileName, 0o777, (error) => {
                                            if (error) {
                                                console.log("文檔 " + fileName + " 無法修改操作權限.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            console.log("文檔 " + fileName + " 操作權限已被修改為 0o777");
                                            // 異步刪除文檔;
                                            require('fs').unlink(fileName, (error) => {
                                                if (error) {
                                                    console.log("文檔 " + fileName + " 無法刪除.");
                                                    typeRecognition = false;
                                                    throw error;
                                                };
                                                console.log("文檔 " + fileName + " 已被刪除.");
                                                fn = fn + 1;
                                                if ((fn + dn) === files.length) {
                                                    if (typeRecognition) {
                                                        if (callback) { callback("error", null); };
                                                    } else {
                                                        // console.log("目錄: " + absolute_path + " 已清空.");
                                                        // // 異步刪除空文件夾;
                                                        // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                        //     if (error) {
                                                        //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                                                        //         typeRecognition = false;
                                                        //         throw error;
                                                        //     };
                                                        // });
                                                        if (callback) { callback(null, fn + dn); };
                                                    };
                                                };
                                            });
                                        });

                                    } else {

                                        // 異步刪除文檔;
                                        require('fs').unlink(fileName, (error) => {
                                            if (error) {
                                                console.log("文檔 " + fileName + " 無法刪除.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            console.log("文檔 " + fileName + " 已被刪除.");
                                            fn = fn + 1;
                                            if ((fn + dn) === files.length) {
                                                if (typeRecognition) {
                                                    if (callback) { callback("error", null); };
                                                } else {
                                                    // console.log("目錄: " + absolute_path + " 已清空.");
                                                    // // 異步刪除空文件夾;
                                                    // require('fs').rmdir(absolute_path, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                    //     if (error) {
                                                    //         console.log("目錄(文件夾) " + absolute_path + " 無法刪除.");
                                                    //         typeRecognition = false;
                                                    //         throw error;
                                                    //     };
                                                    // });
                                                    if (callback) { callback(null, fn + dn); };
                                                };
                                            };
                                        });
                                    };
                                });

                            } else if (stats.isDirectory()) {

                                // 異步查詢文件夾，返回一個文件夾下所有文檔名字符串組成的數組;
                                require('fs').readdir(fileName, { encoding: 'utf8', withFileTypes: false }, (error, Sfiles) => {

                                    if (error) {
                                        console.log("輸入輸出數據文檔暫存媒介目錄無法讀取 " + fileName);
                                        console.error(error);
                                    };
                                    if (Sfiles && Sfiles.length > 0) {
                                        deleteDir(fileName);
                                        let id = setInterval(() => {
                                            require('fs').readdir(fileName, { encoding: 'utf8', withFileTypes: false }, (error, SSfiles) => {
                                                if (SSfiles.length === 0) {
                                                    clearInterval(id);  // 清除延時監聽動作;
                                                    // 異步刪除空文件夾;
                                                    require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                        if (error) {
                                                            console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                            typeRecognition = false;
                                                            throw error;
                                                        };
                                                        dn = dn + 1;
                                                        console.log("目錄(文件夾) " + fileName + " 已被刪除.");
                                                        if ((fn + dn) === files.length) {
                                                            if (typeRecognition) {
                                                                if (callback) { callback("error", null); };
                                                            } else {

                                                                // console.log("目錄: " + absolute_path + " 已清空.");
                                                                // // 異步刪除空文件夾;
                                                                // require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                                //     if (error) {
                                                                //         console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                                //         typeRecognition = false;
                                                                //         throw error;
                                                                //     };
                                                                // });
                                                                if (callback) { callback(null, fn + dn); };
                                                            };
                                                        };
                                                    });
                                                };
                                            });
                                        }, 8);
                                    } else {
                                        // 異步刪除空文件夾;
                                        require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                            if (error) {
                                                console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                typeRecognition = false;
                                                throw error;
                                            };
                                            dn = dn + 1;
                                            console.log("目錄(文件夾) " + fileName + " 已被刪除.");
                                            if ((fn + dn) === files.length) {
                                                if (typeRecognition) {
                                                    if (callback) { callback("error", null); };
                                                } else {

                                                    // console.log("目錄: " + absolute_path + " 已清空.");
                                                    // // 異步刪除空文件夾;
                                                    // require('fs').rmdir(fileName, { maxRetries: 0, recursive: false, retryDelay: 100 }, (error) => {
                                                    //     if (error) {
                                                    //         console.log("目錄(文件夾) " + fileName + " 無法刪除.");
                                                    //         typeRecognition = false;
                                                    //         throw error;
                                                    //     };
                                                    // });
                                                    if (callback) { callback(null, fn + dn); };
                                                };
                                            };
                                        });
                                    };
                                });

                            } else {

                                console.log("文檔: " + fileName + " 類型無法識別.");
                                typeRecognition = false;
                                throw error;
                            };
                        });
                    };
                };
            });
        } else {
            console.log("文檔: " + absolute_path + " 類型無法識別.");
            if (callback) { callback(error, null); };
        };
    });
};
// module.exports.deleteDir = deleteDir; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義返回調用時函數的名字;
const where = () => {
    let reg = /\s+at\s(\s+)\s\(/g;
    let str = new Error().stack.toString();
    let res = reg.exec(str) && reg.exec(str);
    return res && res[1];
};
// module.exports.where = where; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義封裝一個函數，使用正則函數的方法檢查字符串中的字符類型，用於檢驗用戶輸入參數的合規性;
function CheckString(letters, fork) {
    let Require;
    switch (fork) {
        case 'arabic_numerals':
            Require = /^[0-9]+$/; //檢查是否全部由阿拉伯數字[0-9]構成的字符串;
            return Require.test(letters);
            break; // break用於終止後面的條件選擇語句執行;
        case 'non_negative_integer':
            Require = /^\\d+$/; //非負整數(正整數 + 0);
            return Require.test(letters);
            break;
        case 'positive_integer':
            Require = /^[0-9]*[1-9][0-9]*$/; //正整數;
            return Require.test(letters);
            break;
        case 'non_positive_integer':
            Require = /^((-\\d+)|(0+))$/; //非正整數(負整數 + 0);
            return Require.test(letters);
            break;
        case 'negative_integer':
            Require = /^-[0-9]*[1-9][0-9]*$/; //負整數;
            return Require.test(letters);
            break;
        case 'integer':
            Require = /^-?\\d+$/; //整數;
            return Require.test(letters);
            break;
        case 'non_negative_float':
            Require = '^\\d+('; //非負浮點數(正浮點數 + 0);
            return Require.test(letters);
            break;
        case 'positive_float':
            Require = /^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$/; //正浮點數;
            return Require.test(letters);
            break;
        case 'non_positive_float':
            Require = '^((-\\d+('; //非正浮點數(負浮點數 + 0);
            return Require.test(letters);
            break;
        case 'negative_float':
            Require = /^(-(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //負浮點數;
            return Require.test(letters);
            break;
        case 'float':
            Require = '^(-?\\d+)('; //浮點數;
            return Require.test(letters);
            break;
        default:
        // 執行與所有 case 不同時執行的代碼;
    };
};
// module.exports.CheckString = CheckString; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// // 控制臺傳參檢查埠號（port）是否已經被占用，控制臺傳參，其中「port」為需要檢測的端口號，運行方式示例：node PortIsOccupied 80;
// if (typeof (process.argv[2]) === 'undefined') {
//     console.log('端口參數未輸入，請正確輸入待測試端口號.');
// } else if (!CheckString(process.argv[2], 'arabic_numerals') || Number(process.argv[2]) >= 65535 || Number(process.argv[2]) <= 0) {
//     console.log(`端口參數「${process.argv[2]}」類型輸入錯誤，請正確輸入「1 ~ 65535」的數字端口進行測試.`);
// } else {
//     let port = Number(parseInt(process.argv[2]));
//     //console.log(port);
//     const Server = net.createServer().listen(port);
//     function PortIsOccupied(port) {
//         Server.on('listening', function () {
//             Server.close(); // 關閉服務;
//             console.log(`端口「${port}」可以使用.`);
//         });
//         Server.on('error', function (error) {
//             if (error.code === 'EADDRINUSE') {
//                 // 端口已被占用
//                 console.log(`端口「${port}」已經被占用，請更換端口重試.`);
//             } else {
//                 console.log(JSON.stringify(error));
//             };
//         });
//     };

//     // 執行
//     PortIsOccupied(port);
// };







// 處理從硬盤文檔讀取到的JSON對象數據，然後返回處理之後的結果JSON對象;
function do_data(data_Str) {

    let response_data_String = "";
    let require_data_JSON = {};
    // 使用自定義函數isStringJSON(data_Str)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    if (isStringJSON(data_Str)) {
        require_data_JSON = JSON.parse(data_Str);  // 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
        // str = JSON.stringify(jsonObj);
        // Obj = JSON.parse(jsonStr);
    } else {
        require_data_JSON = {
            "Client_say": data_Str,
        };
    };

    // console.log(require_data_JSON);
    // console.log(typeof(require_data_JSON));
    // console.log(typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length));

    let Client_say = "";
    // 使用函數 (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) 判斷傳入的參數 require_data_JSON 是否為 JSON 格式對象;
    if (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) {
        // 使用 JSON.hasOwnProperty("key") 判断某个"key"是否在JSON中;
        if (require_data_JSON.hasOwnProperty("Client_say")) {
            Client_say = require_data_JSON["Client_say"];
        } else {
            Client_say = "";
            // console.log('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].');
            // console.log(require_data_JSON);
        };
    } else {
        Client_say = require_data_JSON;
        // isStringJSON(request_data_JSON);
        // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);
    };

    let Server_say = Client_say;  // "require no problem.";
    // if (Client_say === "How are you" || Client_say === "How are you." || Client_say === "How are you!" || Client_say === "How are you !") {
    //     Server_say = "Fine, thank you, and you ?";
    // } else {
    //     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」";
    // };

    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(now_date);
    let response_data_JSON = {
        "Server_say": Server_say,
        "time": String(now_date)
    };
    response_data_String = JSON.stringify(response_data_JSON);
    // isStringJSON(request_data_JSON);
    // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);

    return response_data_String;
};
module.exports.do_data = do_data; // 使用「module.exports」接口對象，用來導出模塊中的成員;


// let is_monitor = true;  // Boolean;
// // let is_Monitor_Concurrent = "";  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
// let monitor_dir = String(require('path').join(String(__dirname), "Intermediary"));  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let monitor_file = String(require('path').join(String(monitor_dir), "intermediary_write_C.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_C.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
// let do_Function = do_data;  // function (argument) { return argument; };  // 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
// let output_dir = String(require('path').join(String(__dirname), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸出傳值的媒介目錄 "../temp/";
// let output_file = String(require('path').join(String(output_dir), "intermediary_write_Nodejs.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_Nodejs.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
// let to_executable = "";  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\Python\\Python39\\python.exe";
// let to_script = "";  // 用於對返回數據執行功能的被調用的脚本文檔 "../py/test.py";
// let delay = parseInt(100);  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay)，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
// let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
// let Worker_threads_Script_path = "";  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let Worker_threads_eval_value = null;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let temp_NodeJS_cache_IO_data_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "temp"));  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     // CheckString(delay, 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //     // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                     //     if (process.argv[i].split("=")[0] !== "do_Function") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Function" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Function = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "monitor_file": {
//                             monitor_file = String(process.argv[i].split("=")[1]);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("monitor file: " + monitor_file);
//                             break;
//                         }
//                         case "monitor_dir": {
//                             monitor_dir = String(process.argv[i].split("=")[1]);  // 用於輸入傳值的媒介目錄 "../temp/";
//                             // console.log("monitor dir: " + monitor_dir);
//                             break;
//                         }
//                         case "do_Function": {
//                             // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
//                             if (Object.prototype.toString.call(do_Function = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Function = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Function = null;
//                             };
//                             // console.log("do Function: " + do_Function);
//                             break;
//                         }
//                         case "output_dir": {
//                             output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                             // console.log("output dir: " + output_dir);
//                             break;
//                         }
//                         case "output_file": {
//                             output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("output file: " + output_file);
//                             break;
//                         }
//                         case "to_executable": {
//                             to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("to executable: " + to_executable);
//                             break;
//                         }
//                         case "to_script": {
//                             to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("to script: " + to_script);
//                             break;
//                         }
//                         case "temp_NodeJS_cache_IO_data_dir": {
//                             temp_NodeJS_cache_IO_data_dir = String(process.argv[i].split("=")[1]);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
//                             // console.log("temp NodeJS cache Input/Output data dir: " + temp_NodeJS_cache_IO_data_dir);
//                             break;
//                         }
//                         case "delay": {
//                             delay = parseInt(process.argv[i].split("=")[1]);  // delay = 500;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//                             // console.log("delay: " + delay);
//                             break;
//                         }
//                         // case "is_Monitor_Concurrent": {
//                         //     is_Monitor_Concurrent = String(process.argv[i].split("=")[1]);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//                         //     // console.log("is_Monitor_Concurrent: " + number_Worker_threads);
//                         //     break;
//                         // }
//                         case "number_Worker_threads": {
//                             CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                             number_Worker_threads = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number_Worker_threads: " + number_Worker_threads);
//                             break;
//                         }
//                         case "Worker_threads_Script_path": {
//                             Worker_threads_Script_path = process.argv[i].split("=")[1];  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads Script path: " + Worker_threads_Script_path);
//                             break;
//                         }
//                         case "Worker_threads_eval_value": {
//                             Worker_threads_eval_value = Boolean(process.argv[i].split("=")[1]);  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads eval value: " + Worker_threads_eval_value);
//                             break;
//                         }
//                         default: {
//                             // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// // 硬盤文檔監聽函數 file_Monitor() 使用説明;
// // file_Monitor(is_monitor, monitor_file, monitor_dir, do_Function_obj, return_obj, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir);
// if (require('worker_threads').isMainThread) {
//     // const child_process = require('child_process');  // Node原生的創建子進程模組;
//     // const os = require('os');  // Node原生的操作系統信息模組;
//     // const net = require('net');  // Node原生的網卡網絡操作模組;
//     // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const qs = require('querystring');
//     // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
//     // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
//     // const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
//     // const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
//     // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
//     // const cluster = require('cluster');  // Node原生的支持多進程模組;
//     // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
//     // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
    
//     // // 可以先改變工作目錄到 static 路徑;
//     // console.log('Starting directory: ' + process.cwd());
//     // try {
//     //     process.chdir('D:\\tmp\\');
//     //     console.log('New directory: ' + process.cwd());
//     // } catch (error) {
//     //     console.log('chdir: ' + error);
//     // };

//     // // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
//     // try {
//     //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
//     // } catch (error) {
//     //     console.log(error);
//     // };

//     let monitor_dir = require('path').join(require('path').resolve(".."), "Intermediary");  //require('path').resolve("..").toString().concat("/temp/")，"D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let monitor_file = require('path').join(monitor_dir, "intermediary_write_Python.txt");  // "../temp/intermediary_write_Python.txt" 用於接收傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let do_Function = do_data;  // 用於接收執行功能的函數;
//     let output_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // "D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let output_file = require('path').join(output_dir, "intermediary_write_Node.txt");  // "../temp/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let to_executable = require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // require('path').resolve("..").toString().concat("/Python/", "python39/python.exe")，"../Python/python39/python.exe"，path.resolve("../Python/python39/python.exe") 轉換爲絕對路徑;
//     let to_script = require('path').join(require('path').resolve(".."), "js", "test.js");  // require('path').resolve("..").toString().concat("/js/", "test.js")，"../js/test.js"，path.resolve("../js/test.js") 轉換爲絕對路徑;
//     let do_Function_obj = {
//         "do_Function": do_Function  // 用於接收執行功能的函數;
//     };
//     let return_obj = {
//         "output_dir": output_dir,  // 需要注意目錄操作權限 "./temp/" 用於傳值的媒介目錄;
//         "output_file": output_file,  // "./temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
//         "to_executable": to_executable,  // 用於對返回數據執行功能的解釋器可執行文件;
//         "to_script": to_script  // "./js/test.js" 用於執行功能的被調用的脚步文檔;
//     };
//     let is_monitor = true;  // 用於判斷只運行一次，還是保持文檔監聽;
//     let delay = 50;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//     let number_Worker_threads = 1;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//     let Worker_threads_Script_path = "";  // process.argv[1]; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值;
//     let Worker_threads_eval_value = "";  // true; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值;
//     let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // "C:\\Users\\china\\AppData\\Local\\Temp\\temp_NodeJS_cache_IO_data\\" 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
//     // let temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
//     // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
//     // console.log(temp_NodeJS_cache_IO_data_dir);

//     let data = Interface_file_Monitor({
//         "is_monitor": is_monitor,
//         "monitor_file": monitor_file,
//         "monitor_dir": monitor_dir,
//         // "do_Function_obj": do_Function_obj,
//         "do_Function": do_Function,
//         // "return_obj": return_obj,
//         "output_dir": output_dir,
//         "output_file": output_file,
//         "to_executable": to_executable,
//         "to_script": to_script,
//         "delay": delay,
//         "number_Worker_threads": number_Worker_threads,
//         "Worker_threads_Script_path": Worker_threads_Script_path,
//         "Worker_threads_eval_value": Worker_threads_eval_value,
//         "temp_NodeJS_cache_IO_data_dir": temp_NodeJS_cache_IO_data_dir
//     });
//     // let data = Interface_file_Monitor({
//     //     "is_monitor": is_monitor,
//     //     "monitor_file": monitor_file,
//     //     "do_Function": do_Function,
//     //     "output_file": output_file,
//     // });
// };





let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let webPath = String(require('path').join(String(__dirname), "html"));
// console.log(webPath);
// module.exports.webPath = webPath; // 使用「module.exports」接口對象，用來導出模塊中的成員;
let Key = "username:password";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// console.log(Key);
// module.exports.Key = Key; // 使用「module.exports」接口對象，用來導出模塊中的成員;
let Session = {
    "request_Key->username:password": Key
};
// console.log(Session);
// module.exports.Session = Session; // 使用「module.exports」接口對象，用來導出模塊中的成員;

// 自定義具體處理 GET 或 POST 請求的執行函數;
function do_Request_Router(
    request_url,
    request_POST_String,
    request_headers,
    callback
){
// async function do_Request_Router(
//     request_url,
//     request_POST_String,
//     request_headers
// ){

    // Check the file extension required and set the right mime type;
    // try {
    //     fs.readFileSync();
    //     fs.writeFileSync();
    // } catch (error) {
    //     console.log("硬盤文件打開或讀取錯誤.");
    // } finally {
    //     fs.close();
    // };

    // // let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
    // // let webPath = String(require('path').join(String(__dirname), "html"));
    // let webPath = global.webPath;  // 使用全局變量賦值;
    // // console.log(webPath);
    // // let Key = "";  // 使用全局變量賦值;
    // let Key = global.Key;  // 使用全局變量賦值;
    // // console.log(Key);
    // // let Session = {};  // 使用全局變量賦值;
    // let Session = global.Session;  // 使用全局變量賦值;
    // // console.log(Session);

    let response_body_String = "";
    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    let response_data_JSON = {
        "time": String(now_date),
        "request_url": request_url,
        "request_POST": request_POST_String,
        // "request_Authorization": request_headers["authorization"],  // "username:password";
        // "request_Cookie": request_headers["cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
        "Server_Authorization": Key,  // "username:password";
        "Database_say": "",
    };
    // console.log(request_headers);
    if (typeof (request_headers) === 'object' && Object.prototype.toString.call(request_headers).toLowerCase() === '[object object]' && !(request_headers.length)) {
        if (request_headers.hasOwnProperty("authorization")) {
            response_data_JSON["request_Authorization"] = Base64.decode(String(request_headers["authorization"]).split(" ")[1]);  // "username:password";
            // console.log(response_data_JSON["request_Authorization"]);
        };
        if (request_headers.hasOwnProperty("cookie")) {
            response_data_JSON["request_Cookie"] = request_headers["cookie"];  // String(request_headers["cookie"]).split("=")[0].concat("=", Base64.decode(String(request_headers["cookie"]).split("=")[1]));  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
            // console.log(response_data_JSON["request_Cookie"]);
        };
    };
    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // String = JSON.stringify(JSON); JSON = JSON.parse(String);

    // console.log(request_POST_String);
    let request_POST_JSON = {};
    // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
    // // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
    //     try {
    //         if (request_POST_String !== "") {
    //             request_POST_JSON = JSON.parse(request_POST_String, true);
    //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         };
    //     } catch (error) {
    //         console.error(error);
    //         response_data_JSON["Database_say"] = String(error);
    //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         if (callback) { callback(response_body_String, null); };
    //         return response_body_String;
    //     } finally {};
    //     // console.log(request_POST_JSON);
    // // };

    // console.log(request_url);
    // let request_url_JSON = url.parse(request_url, true);
    const request_url_JSON = new URL(request_url, `http://${request_headers["host"]}`);  // http://127.0.0.1:8000
    // console.log(request_url_JSON);
    const url_search_JSON = new URLSearchParams(request_url_JSON.search);
    // console.log(url_search_JSON);
    const request_url_path = String(request_url_JSON.pathname);
    // console.log(request_url_path);
    // let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
    // let webPath = String(require('path').join(String(__dirname), "html"));
    // console.log(webPath);
    let web_path = String(path.join(webPath, request_url_path));
    // let web_path = String(path.join(global.webPath, request_url_path));
    // console.log(web_path);

    // // try {
    // //     // 異步寫入硬盤文檔;
    // //     fs.writeFile(
    // //         web_path,
    // //         data,
    // //         function (error) {
    // //             if (error) { return console.error(error); };
    // //         }
    // //     );
    // //     // 同步讀取硬盤文檔;
    // //     // fs.writeFileSync(web_path, data);
    // // } catch (error) {
    // //     console.log("硬盤文檔打開或寫入錯誤.");
    // // } finally {
    // //     fs.close();
    // // };

    let file_data = null;
    // try {
    //     // // 異步讀取硬盤文檔;
    //     // fs.readFile(
    //     //     web_path,
    //     //     function (error, data) {
    //     //         if (error) {
    //     //             console.error(error);
    //     //             response_body_String = String(error);
    //     //             if (callback) { callback(response_body_String, null); };
    //     //         };
    //     //         if (data) {
    //     //             // console.log("異步讀取文檔: " + data.toString());
    //     //             file_data = data;
    //     //             response_body_String = file_data.toString();
    //     //             // console.log(response_body_String);
    //     //             if (callback) { callback(null, response_body_String); };
    //     //         };
    //     //     }
    //     // );
    //     // 同步讀取硬盤文檔;
    //     file_data = fs.readFileSync(web_path);
    //     // console.log("同步讀取文檔: " + file_data.toString());
    //     response_body_String = file_data.toString();
    //     // console.log(response_body_String);
    //     if (callback) { callback(null, response_body_String); };
    //     return response_body_String;
    // } catch (error) {
    //     console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
    //     response_body_String = String(error);
    //     if (callback) { callback(response_body_String, null); };
    //     return response_body_String;
    // } finally {
    //     // fs.close();
    // };

    let fileName = "";
    if (url_search_JSON.has("fileName")) {
        fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
    };

    if (url_search_JSON.has("Key")) {
        // global.Key = String(url_search_JSON.get("Key"));  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
        Key = String(url_search_JSON.get("Key"));  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    };
    if (url_search_JSON.has("dbUser")) {
        dbUser = String(url_search_JSON.get("dbUser"));  // 'admin_test20220703'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    if (url_search_JSON.has("dbPass")) {
        dbPass = String(url_search_JSON.get("dbPass"));  // 'admin'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    // UserPass = dbUser.concat(":", dbPass);  // 'admin_test20220703:admin';  // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    if (url_search_JSON.has("dbName")) {
        dbName = String(url_search_JSON.get("dbName"));  // 'testWebData'; // ['admin', 'testWebData'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
    };
    if (url_search_JSON.has("dbTableName")) {
        dbTableName = String(url_search_JSON.get("dbTableName"));  // 'test20220703'; // ['test20220703'];  // MongoDB 數據庫包含的數據集合（表格）;
    };

    switch (request_url_path) {

        case "/": {
            // 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

            web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
            Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
            Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
            Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

            try {

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            // console.log("異步讀取文檔: " + "\\n" + data.toString());
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            response_body_String = file_data.toString();
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Input_HTML = Input_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Output_HTML = Output_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
                            // console.log(response_body_String);

                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/index.html": {
            // 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

            // web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
            Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
            Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
            Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

            try {

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            // console.log("異步讀取文檔: " + "\\n" + data.toString());
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            response_body_String = file_data.toString();
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Input_HTML = Input_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Output_HTML = Output_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
                            // console.log(response_body_String);

                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/administrator.html": {
            // 客戶端或瀏覽器請求 url = http://localhost:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

            // web_path = String(path.join(webPath, "/administrator.html"));
            file_data = null;

            try {

                // // 同步讀取硬盤文檔;
                // file_data = fs.readFileSync(web_path);
                // // console.log("同步讀取文檔: " + file_data.toString());
                // let filesName = fs.readdirSync(webPath);
                // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                // filesName.forEach(
                //     function (item) {
                //         // console.log("異步讀取文件夾目錄: " + item.toString());
                //         let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                //         if (statsObj.isFile()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                //         } else if (statsObj.isDirectory()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                //         } else {};
                //     }
                // );
                // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                // // console.log(response_body_String);
                // // return response_body_String;

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                            fs.readdir(
                                webPath,
                                function (error, filesName) {

                                    if (error) {
                                        console.error(error);
                                        response_data_JSON["Database_say"] = String(error);
                                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                        if (callback) { callback(response_body_String, null); };
                                        // return response_body_String;
                                    };

                                    if (filesName) {
                                        let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                        // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                        filesName.forEach(
                                            function (item) {
                                                // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                // console.log("異步讀取文件夾目錄: " + item.toString());
                                                let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                                                if (statsObj.isFile()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else if (statsObj.isDirectory()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else {};
                                            }
                                        );
                                        response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                        // console.log(response_body_String);
                                        if (callback) { callback(null, response_body_String); };
                                        // return response_body_String;
                                    };
                                }
                            );
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/uploadFile": {
            // 客戶端或瀏覽器請求 url = http://localhost:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=NodejsServer.jl

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            web_path = String(path.join(webPath, fileName));
            file_data = request_POST_String;

            let file_data_Uint8Array_String = JSON.parse(file_data);  // JSON.stringify(file_data_Uint8Array);
            let file_data_Uint8Array = new Array();
            for (let i = 0; i < file_data_Uint8Array_String.length; i++) {
                if (Object.prototype.toString.call(file_data_Uint8Array_String[i]).toLowerCase() === '[object string]') {
                    // file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 2));  // 函數 parseInt("11100101", 2) 表示將二進制數字的字符串轉爲十進制的數字，例如 parseInt("11100101", 2) === 二進制的：11100101 也可以表示爲（0b11100101）=== 十進制的：229;
                    file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 10));  // 函數 parseInt("229", 10) 表示將十進制數字的字符串轉爲十進制的數字，例如 parseInt("229", 10) === 十進制的：229 === 二進制的：11100101 也可以表示爲（0b11100101）;
                } else {
                    file_data_Uint8Array.push(file_data_Uint8Array_String[i]);
                };
            };
            // let file_data_bytes = new Uint8Array(Buffer.from(file_data_String));  // 轉換為 Buffer 二進制對象;
            let file_data_bytes = Buffer.from(new Uint8Array(file_data_Uint8Array));  // 轉換為 Buffer 二進制對象;
            // let file_data_Buffer = Buffer.allocUnsafe(file_data_Uint8Array.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
            // let file_data_bytes = new Uint8Array(file_data_Buffer);  // 轉換為 Buffer 二進制對象;
            // for (let i = 0; i < file_data_Uint8Array.length; i++) {
            //     file_data_bytes[i] = file_data_Uint8Array[i];
            // };
            // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
            // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
            // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
            // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
            // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
            // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
            let file_data_len = file_data_Uint8Array.length;
            // let file_data_len = Buffer.byteLength(file_data);

            // let statsObj = fs.statSync(web_path, {bigint: false});
            // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                // console.log("文檔路徑全名: " + web_path);
                // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                // console.log("文檔操作權限值: " + String(statsObj.mode));

                // 同步判斷指定的目標文檔權限，當指定的目標文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + web_path + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.log("指定的待替換的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };
                };

                // 向指定的目標文檔同步寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(file_data_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);
                    // // console.log("目標文檔: " + web_path + " 寫入成功.");
                    // // response_body_String = JSON.stringify(result);
                    // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // if (callback) { callback(null, response_body_String); };
                    // // return response_body_String;

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {

                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                // 截取目標寫入目錄;
                let writeDirectory = "";
                if (fileName.indexOf("/") === -1) {
                    writeDirectory = "/";
                } else {
                    let tempArray = new Array();
                    tempArray = fileName.split("/");
                    if (tempArray.length <= 2) {
                        writeDirectory = "/";
                    } else {
                        for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
                            if (i === 0) {
                                writeDirectory = tempArray[i];
                            } else {
                                writeDirectory = writeDirectory + "/" + tempArray[i];
                            };
                        };
                    };
                };
                writeDirectory = String(path.join(webPath, writeDirectory));

                // 判斷目標寫入目錄是否存在，如果不存在則創建;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(writeDirectory)方法判斷指定的目標寫入目錄是否存在以及是否為文件夾;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                        fs.mkdirSync(writeDirectory, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                        // console.log("目錄: " + writeDirectory + " 創建成功.");
                    };
                    // 判斷指定的目標寫入目錄是否創建成功;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        console.log("無法創建指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.");
                        response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.";
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        return response_body_String;
                    };
                } catch (error) {
                    console.log("無法創建或識別指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create or recognize the directory = { " + String(writeDirectory) + " }.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                };

                // 同步創建指定的目標文檔，並向文檔寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(web_path_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {
                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            return response_body_String;
        }

        case "/deleteFile": {
            // 客戶端或瀏覽器請求 url = http://localhost:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=NodejsServer.jl

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待刪除的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            if (fileName !== "" && fileName !== null) {

                web_path = String(path.join(webPath, fileName));
                file_data = request_POST_String;

                let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
                // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
                // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
                // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
                // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
                // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
                let file_data_len = Buffer.byteLength(file_data);

                // let statsObj = fs.statSync(web_path, {bigint: false});
                // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
                if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                    // console.log("文檔路徑全名: " + web_path);
                    // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                    // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                    // console.log("文檔操作權限值: " + String(statsObj.mode));

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文檔: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
                            // 常量                    八進制值    說明
                            // fs.constants.S_IRUSR    0o400      所有者可讀
                            // fs.constants.S_IWUSR    0o200      所有者可寫
                            // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                            // fs.constants.S_IRGRP    0o40       群組可讀
                            // fs.constants.S_IWGRP    0o20       群組可寫
                            // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                            // fs.constants.S_IROTH    0o4        其他人可讀
                            // fs.constants.S_IWOTH    0o2        其他人可寫
                            // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                            // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                            // 數字	說明
                            // 7	可讀、可寫、可執行
                            // 6	可讀、可寫
                            // 5	可讀、可執行
                            // 4	唯讀
                            // 3	可寫、可執行
                            // 2	只寫
                            // 1	只可執行
                            // 0	沒有許可權
                            // 例如，八進制值 0o765 表示：
                            // 1) 、所有者可以讀取、寫入和執行該文檔；
                            // 2) 、群組可以讀和寫入該文檔；
                            // 3) 、其他人可以讀取和執行該文檔；
                            // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                            // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                        } catch (error) {
                            console.log("指定的待刪除的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文檔;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文檔;
                        fs.unlinkSync(web_path);  // 同步刪除，返回值為 undefined;
                        // Get the files in current diectory;
                        // after deletion;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文檔;
                        // fs.unlink(
                        //     web_path,
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } ); 

                        //             // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // 同步寫入文檔;
                        // // console.log(file_data);
                        // fs.writeFileSync(
                        //     web_path,
                        //     file_data,
                        //     { encoding: "utf8", mode: 0o777, flag: "w+" }
                        // );  // 返回值為 undefined;
                        // // // web_path_bytes = new Uint8Array(Buffer.from(web_path));  // 轉換為 Buffer 二進制對象;
                        // // fs.writeFileSync(web_path, web_path_bytes, { mode: 0o777, flag: "w+" });  // 返回值為 undefined;
                        // // console.log(web_path_bytes);
                        // // // let buffer = new Buffer(8);
                        // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                        // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                        // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                        // // console.log(data_Str);
                        // console.log("目標文檔: " + web_path + " 寫入成功.");
                        // // response_body_String = JSON.stringify(result);
                        // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        // if (callback) { callback(null, response_body_String); };
                        // // return response_body_String;

                        // fs.writeFile(
                        //     web_path,
                        //     file_data,
                        //     {
                        //         encoding: "utf8",
                        //         mode: 0o777,
                        //         flag: "w+"
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             console.log("目標文檔: " + web_path + " 寫入成功.");
                        //             // response_body_String = JSON.stringify(result);
                        //             response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(null, response_body_String); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文件夾存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文件夾: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文件夾: " + web_path + " 操作權限修改為可以讀寫.");
                            // 常量                    八進制值    說明
                            // fs.constants.S_IRUSR    0o400      所有者可讀
                            // fs.constants.S_IWUSR    0o200      所有者可寫
                            // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                            // fs.constants.S_IRGRP    0o40       群組可讀
                            // fs.constants.S_IWGRP    0o20       群組可寫
                            // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                            // fs.constants.S_IROTH    0o4        其他人可讀
                            // fs.constants.S_IWOTH    0o2        其他人可寫
                            // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                            // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                            // 數字	說明
                            // 7	可讀、可寫、可執行
                            // 6	可讀、可寫
                            // 5	可讀、可執行
                            // 4	唯讀
                            // 3	可寫、可執行
                            // 2	只寫
                            // 1	只可執行
                            // 0	沒有許可權
                            // 例如，八進制值 0o765 表示：
                            // 1) 、所有者可以讀取、寫入和執行該文檔；
                            // 2) 、群組可以讀和寫入該文檔；
                            // 3) 、其他人可以讀取和執行該文檔；
                            // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                            // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                        } catch (error) {
                            console.log("指定的待刪除的文件夾 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文件夾 Directory = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文件夾;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文件夾;
                        fs.rmdirSync(web_path, { recursive: true, maxRetries: 0, retryDelay: 100 });  // 同步刪除，返回值為 undefined;
                        // Get the current filenames;
                        // in the directory to verify;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文件夾;
                        // fs.rmdir(
                        //     web_path,
                        //     { 
                        //         recursive: true,
                        //         maxRetries: 0,
                        //         retryDelay: 100
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        //             // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // // 同步創建文件夾;
                        // fs.mkdirSync(web_path, 0777);
                        // // 伊布創建文件夾;
                        // fs.mkdir(
                        //     web_path,
                        //     {
                        //         recursive: true
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.error(err);
                        //         } else {
                        //             console.log('Directory created successfully!');
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else {

                    console.log("指定的待刪除的文檔: " + String(web_path) + " 不存在或無法識別." + "\n" + "file = { " + String(web_path) + " } can not found.");
                    response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 不存在或無法識別." + "\n" + "file = { " + String(fileName) + " } can not found.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            // let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
            // file_data = request_POST_String;
            // // web_path = String(path.join(webPath, request_url_path));
            // let currentDirectory = "";
            // if (fileName === "" || fileName === null) {
            //     currentDirectory = "/";
            // } else {
            //     if (fileName.indexOf("/") !== -1) {
            //         let tempArray = new Array();
            //         tempArray = fileName.split("/");
            //         for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
            //             if (i === 0) {
            //                 currentDirectory = tempArray[i];
            //             } else {
            //                 currentDirectory = currentDirectory + "/" + tempArray[i];
            //             };
            //         };
            //     } else {
            //         currentDirectory = "/";
            //     };
            // };
            // web_path = String(path.join(webPath, currentDirectory));

            // if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

            //     try {

            //         // // 同步讀取硬盤文檔;
            //         // file_data = fs.readFileSync(web_path_index_Html);
            //         // // console.log("同步讀取文檔: " + file_data.toString());
            //         // let filesName = fs.readdirSync(web_path);
            //         // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
            //         // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //         // filesName.forEach(
            //         //     function (item) {
            //         //         // console.log("異步讀取文件夾目錄: " + item.toString());
            //         //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //         //         if (statsObj.isFile()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
            //         //         } else if (statsObj.isDirectory()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
            //         //         } else {};
            //         //     }
            //         // );
            //         // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
            //         // // console.log(response_body_String);
            //         // // return response_body_String;

            //         // 異步讀取硬盤文檔;
            //         fs.readFile(
            //             web_path_index_Html,
            //             function (error, data) {

            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };

            //                 if (data) {
            //                     file_data = data;
            //                     // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
            //                     fs.readdir(
            //                         web_path,
            //                         function (error, filesName) {

            //                             if (error) {
            //                                 console.error(error);
            //                                 response_data_JSON["Database_say"] = String(error);
            //                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                                 if (callback) { callback(response_body_String, null); };
            //                                 // return response_body_String;
            //                             };

            //                             if (filesName) {
            //                                 let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
            //                                 // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //                                 filesName.forEach(
            //                                     function (item) {
            //                                         // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
            //                                         let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
            //                                         // console.log("異步讀取文件夾目錄: " + item.toString());
            //                                         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //                                         if (statsObj.isFile()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else if (statsObj.isDirectory()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else {};
            //                                     }
            //                                 );
            //                                 response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
            //                                 // console.log(response_body_String);
            //                                 if (callback) { callback(null, response_body_String); };
            //                                 // return response_body_String;
            //                             };
            //                         }
            //                     );
            //                 };
            //             }
            //         );

            //     } catch (error) {
            //         console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
            //         console.error(error);
            //         response_data_JSON["Database_say"] = String(error);
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     } finally {
            //         // fs.close();
            //     };
            // };

            return response_body_String;
        }

        case "/Polynomial3Fit": {
            // 讀取用戶端（前端 Client）發送的請求數據（Request），並進行三次多項式方程模型回歸擬合（polynomial-3 fitting）運算，並向用戶端（前端 Client）返回運算結果數據;
            // 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit

            request_POST_JSON = {
                'trainXdata': [
                    0.00001,  // parseFloat(0.00001),
                    1,  // parseFloat(1),
                    2,  // parseFloat(2),
                    3,  // parseFloat(3),
                    4,  // parseFloat(4),
                    5,  // parseFloat(5),
                    6,  // parseFloat(6),
                    7,  // parseFloat(7),
                    8,  // parseFloat(8),
                    9,  // parseFloat(9),
                    10  // parseFloat(10)
                ],
                'trainYdata_1': [
                    100,  // parseFloat(100),
                    200,  // parseFloat(200),
                    300,  // parseFloat(300),
                    400,  // parseFloat(400),
                    500,  // parseFloat(500),
                    600,  // parseFloat(600),
                    700,  // parseFloat(700),
                    800,  // parseFloat(800),
                    900,  // parseFloat(900),
                    1000,  // parseFloat(1000),
                    1100  // parseFloat(1100)
                ],
                'trainYdata_2': [
                    98,  // parseFloat(98),
                    198,  // parseFloat(198),
                    298,  // parseFloat(298),
                    398,  // parseFloat(398),
                    498,  // parseFloat(498),
                    598,  // parseFloat(598),
                    698,  // parseFloat(698),
                    798,  // parseFloat(798),
                    898,  // parseFloat(898),
                    998,  // parseFloat(998),
                    1098  // parseFloat(1098)
                ],
                'trainYdata_3': [
                    102,  // parseFloat(102),
                    202,  // parseFloat(202),
                    302,  // parseFloat(302),
                    402,  // parseFloat(402),
                    502,  // parseFloat(502),
                    602,  // parseFloat(602),
                    702,  // parseFloat(702),
                    802,  // parseFloat(802),
                    902,  // parseFloat(902),
                    1002,  // parseFloat(1002),
                    1102  // parseFloat(1102)
                ],
                'weight': [
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5  // parseFloat(0.5)
                ],
                'Pdata_0': [
                    90,  // parseFloat(90),
                    4,  // parseFloat(4),
                    1,  // parseFloat(1),
                    1210  // parseFloat(1210)
                ],
                'Plower': [
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf'  // -Infinity
                ],
                'Pupper': [
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf'  // +Infinity
                ],
                'testYdata_1': [
                    150,  // parseFloat(150),
                    200,  // parseFloat(200),
                    250,  // parseFloat(250),
                    350,  // parseFloat(350),
                    450,  // parseFloat(450),
                    550,  // parseFloat(550),
                    650,  // parseFloat(650),
                    750,  // parseFloat(750),
                    850,  // parseFloat(850),
                    950,  // parseFloat(950),
                    1050  // parseFloat(1050)
                ],
                'testYdata_2': [
                    148,  // parseFloat(148),
                    198,  // parseFloat(198),
                    248,  // parseFloat(248),
                    348,  // parseFloat(348),
                    448,  // parseFloat(448),
                    548,  // parseFloat(548),
                    648,  // parseFloat(648),
                    748,  // parseFloat(748),
                    848,  // parseFloat(848),
                    948,  // parseFloat(948),
                    1048  // parseFloat(1048)
                ],
                'testYdata_3': [
                    152,  // parseFloat(152),
                    202,  // parseFloat(202),
                    252,  // parseFloat(252),
                    352,  // parseFloat(352),
                    452,  // parseFloat(452),
                    552,  // parseFloat(552),
                    652,  // parseFloat(652),
                    752,  // parseFloat(752),
                    852,  // parseFloat(852),
                    952,  // parseFloat(952),
                    1052  // parseFloat(1052)
                ],
                'testXdata': [
                    0.5,  // parseFloat(0.5),
                    1,  // parseFloat(1),
                    1.5,  // parseFloat(1.5),
                    2.5,  // parseFloat(2.5),
                    3.5,  // parseFloat(3.5),
                    4.5,  // parseFloat(4.5),
                    5.5,  // parseFloat(5.5),
                    6.5,  // parseFloat(6.5),
                    7.5,  // parseFloat(7.5),
                    8.5,  // parseFloat(8.5),
                    9.5  // parseFloat(9.5)
                ],
                'trainYdata': [
                    [100, 98, 102],  // [parseFloat(100), parseFloat(98), parseFloat(102)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [300, 298, 302],  // [parseFloat(300), parseFloat(298), parseFloat(302)],
                    [400, 398, 402],  // [parseFloat(400), parseFloat(398), parseFloat(402)],
                    [500, 498, 502],  // [parseFloat(500), parseFloat(498), parseFloat(502)],
                    [600, 598, 602],  // [parseFloat(600), parseFloat(598), parseFloat(602)],
                    [700, 698, 702],  // [parseFloat(700), parseFloat(698), parseFloat(702)],
                    [800, 798, 802],  // [parseFloat(800), parseFloat(798), parseFloat(802)],
                    [900, 898, 902],  // [parseFloat(900), parseFloat(898), parseFloat(902)],
                    [1000, 998, 1002],  // [parseFloat(1000), parseFloat(998), parseFloat(1002)],
                    [1100, 1098, 1102]  // [parseFloat(1100), parseFloat(1098), parseFloat(1102)]
                ],
                'testYdata': [
                    [150, 148, 152],  // [parseFloat(150), parseFloat(148), parseFloat(152)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [250, 248, 252],  // [parseFloat(250), parseFloat(248), parseFloat(252)],
                    [350, 348, 352],  // [parseFloat(350), parseFloat(348), parseFloat(352)],
                    [450, 448, 452],  // [parseFloat(450), parseFloat(448), parseFloat(452)],
                    [550, 548, 552],  // [parseFloat(550), parseFloat(548), parseFloat(552)],
                    [650, 648, 652],  // [parseFloat(650), parseFloat(648), parseFloat(652)],
                    [750, 748, 752],  // [parseFloat(750), parseFloat(748), parseFloat(752)],
                    [850, 848, 852],  // [parseFloat(850), parseFloat(848), parseFloat(852)],
                    [950, 948, 952],  // [parseFloat(950), parseFloat(948), parseFloat(952)],
                    [1050, 1048, 1052]  // [parseFloat(1050), parseFloat(1048), parseFloat(1052)]
                ]
            };

            let Plower = [
                -Infinity,
                -Infinity,
                -Infinity,
                -Infinity
                // -Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Plower")) {
                if (request_POST_JSON["Plower"].length > 0) {
                    // Plower = request_POST_JSON["Plower"];
                    Plower = new Array;
                    for (let i = 0; i < request_POST_JSON["Plower"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "+Base.Inf" || request_POST_JSON["Plower"][i] === "+Inf" || request_POST_JSON["Plower"][i] === "+inf" || request_POST_JSON["Plower"][i] === "+Infinity" || request_POST_JSON["Plower"][i] === "+infinity" || request_POST_JSON["Plower"][i] === "Base.Inf" || request_POST_JSON["Plower"][i] === "Inf" || request_POST_JSON["Plower"][i] === "inf" || request_POST_JSON["Plower"][i] === "Infinity" || request_POST_JSON["Plower"][i] === "infinity")) {
                            Plower.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "-Base.Inf" || request_POST_JSON["Plower"][i] === "-Inf" || request_POST_JSON["Plower"][i] === "-inf" || request_POST_JSON["Plower"][i] === "-Infinity" || request_POST_JSON["Plower"][i] === "-infinity")) {
                            Plower.push(-Infinity);
                        } else {
                            Plower.push(parseFloat(request_POST_JSON["Plower"][i]));
                        };
                    };
                };
            };
            // console.log(Plower);

            let Pupper = [
                +Infinity,
                +Infinity,
                +Infinity,
                +Infinity
                // +Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Pupper")) {
                if (request_POST_JSON["Pupper"].length > 0) {
                    // Pupper = request_POST_JSON["Pupper"];
                    Pupper = new Array;
                    for (let i = 0; i < request_POST_JSON["Pupper"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "+Base.Inf" || request_POST_JSON["Pupper"][i] === "+Inf" || request_POST_JSON["Pupper"][i] === "+inf" || request_POST_JSON["Pupper"][i] === "+Infinity" || request_POST_JSON["Pupper"][i] === "+infinity" || request_POST_JSON["Pupper"][i] === "Base.Inf" || request_POST_JSON["Pupper"][i] === "Inf" || request_POST_JSON["Pupper"][i] === "inf" || request_POST_JSON["Pupper"][i] === "Infinity" || request_POST_JSON["Pupper"][i] === "infinity")) {
                            Pupper.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "-Base.Inf" || request_POST_JSON["Pupper"][i] === "-Inf" || request_POST_JSON["Pupper"][i] === "-inf" || request_POST_JSON["Pupper"][i] === "-Infinity" || request_POST_JSON["Pupper"][i] === "-infinity")) {
                            Pupper.push(-Infinity);
                        } else {
                            Pupper.push(parseFloat(request_POST_JSON["Pupper"][i]));
                        };
                    };
                };
            };
            // console.log(Pupper);

            // if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

            //     if (MongoDBClient !== null) {

            //         // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //         // // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 數組;
            //         // response_data_JSON["Database_say"] = JSON.stringify(result);
            //         // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         // // return response_body_String;

            //         // 注意，在使用 insertMany() 函數插入多條文檔的時候，在參數 ordered 為 true 值的情況下，如果其中一條數據出現錯誤（比如主鍵重複之類的錯誤），那麽會導致所有數據都無法被插入，反之，如果參數 ordered 為 false 值的情況下，只有出錯的數據無法被插入；可以使用 db.dbName.insertMany([], { ordered: false }) 方法來控制是否按順序插入多條數據。
            //         MongoDBClient.db(dbName).collection(dbTableName).insertMany(
            //             request_POST_JSON,
            //             {
            //                 ordered: false
            //             },
            //             function (error, result) {
            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };
            //                 if (result) {
            //                     // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中插入 " + String(result.insertedCount) + " 條數據成功.");
            //                     // console.log(result);
            //                     // response_body_String = JSON.stringify(result);
            //                     response_data_JSON["Database_say"] = JSON.stringify(result);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(null, response_body_String); };
            //                     // return response_body_String;
            //                 };
            //             }
            //         );
    
            //     } else {
    
            //         console.log("Database error.");
            //         response_data_JSON["Database_say"] = "Database error.";
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     };
    
            // } else {
    
            //     console.log("error, data is empty.");
            //     response_data_JSON["Database_say"] = "error, data is empty.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };
    

            // if (MongoDBClient !== null) {

            //     // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //     // let result = await MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray();  // 變量 request_POST_JSON 為 JSON 對象;
            //     // response_data_JSON["Database_say"] = JSON.stringify(result);
            //     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     // // return response_body_String;

            //     MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray(
            //         function (error, result) {
            //             if (error) {
            //                 console.error(error);
            //                 response_data_JSON["Database_say"] = String(error);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(response_body_String, null); };
            //                 // return response_body_String;
            //             };
            //             if (result) {
            //                 // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據成功.");
            //                 // console.log(result);
            //                 // response_body_String = JSON.stringify(result);
            //                 response_data_JSON["Database_say"] = JSON.stringify(result);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(null, response_body_String); };
            //                 // return response_body_String;
            //             };
            //         }
            //     );

            // } else {

            //     console.log("Database error.");
            //     response_data_JSON["Database_say"] = "Database error.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };

            response_data_JSON = {
                "Coefficient": [
                    0.000012525711645585622	,
                    -0.00018732891623333427,
                    100.00079837805943,
                    99.99910817079639
                ],
                "Coefficient-StandardDeviation": [
                    0.00781790123184812,
                    2104.76673086505,
                    0.0000237490808220821,
                    210359.023599377
                ],
                "Coefficient-Confidence-Lower-95%": [
                    99.9908250045862,
                    37529.2688077105,
                    1.0001042796499,
                    3759717.22485611
                ],
                "Coefficient-Confidence-Upper-95%": [
                    100.025139840936,
                    46767.6467025791,
                    1.00020852064729,
                    4683038.61962554
                ],
                "Yfit": [
                    100.008980483748,
                    199.99155580718,
                    299.992070696316,
                    399.99603100866,
                    500.000567344017,
                    600.00431688223,
                    700.006476967595,
                    800.006517272442,
                    900.004060927778,
                    999.998826196417,
                    1099.99059444852
                ],
                "Yfit-Uncertainty-Lower": [
                    99.0089499294379,
                    198.991136273453,
                    298.990136898385,
                    398.991624763274,
                    498.99282487668,
                    598.992447662226,
                    698.989753032473,
                    798.984266632803,
                    898.975662941844,
                    998.963708008532,
                    1098.94822805642
                ],
                "Yfit-Uncertainty-Upper": [
                    101.00901103813,
                    200.991951293373,
                    300.993902825086,
                    401.000210884195,
                    501.007916682505,
                    601.015588680788,
                    701.022365894672,
                    801.027666045591,
                    901.031064750697,
                    1001.0322361364,
                    1101.0309201882
                ],
                "Residual": [
                    0.00898048374801874,
                    -0.00844419281929731,
                    -0.00792930368334055,
                    -0.00396899133920669,
                    0.000567344017326831,
                    0.00431688223034143,
                    0.00647696759551763,
                    0.00651727244257926,
                    0.00406092777848243,
                    -0.00117380358278751,
                    -0.00940555147826671
                ],
                "testData": {
                    "Ydata": [
                        [150, 148, 152],
                        [200, 198, 202],
                        [250, 248, 252],
                        [350, 348, 352],
                        [450, 448, 452],
                        [550, 548, 552],
                        [650, 648, 652],
                        [750, 748, 752],
                        [850, 848, 852],
                        [950, 948, 952],
                        [1050, 1048, 1052]
                    ],
                    "test-Xvals": [
                        0.500050586546119,
                        1.00008444458554,
                        1.50008923026377,
                        2.50006143908055,
                        3.50001668919562,
                        4.49997400999207,
                        5.49994366811569,
                        6.49993211621922,
                        7.49994379302719,
                        8.49998194168741,
                        9.50004903674755
                    ],
                    // "test-Xvals-Uncertainty-Lower": [
                    //     0.499936310423273,
                    //     0.999794808816128,
                    //     1.49963107921017,
                    //     2.49927920023971,
                    //     3.49892261926065,
                    //     4.49857747071072,
                    //     5.4982524599721,
                    //     6.4979530588239,
                    //     7.49768303155859,
                    //     8.49744512880161,
                    //     9.49724144950174
                    // ],
                    // "test-Xvals-Uncertainty-Upper": [
                    //     0.500160692642957,
                    //     1.00036584601127,
                    //     1.50053513648402,
                    //     2.5008235803856,
                    //     3.50108303720897,
                    //     4.50133543331854,
                    //     5.50159259771137,
                    //     6.50186196458511,
                    //     7.50214864756277,
                    //     8.50245638268284,
                    //     9.50278802032924
                    // ],
                    "test-Xfit-Uncertainty-Lower": [
                        0.499936310423273,
                        0.999794808816128,
                        1.49963107921017,
                        2.49927920023971,
                        3.49892261926065,
                        4.49857747071072,
                        5.4982524599721,
                        6.4979530588239,
                        7.49768303155859,
                        8.49744512880161,
                        9.49724144950174
                    ],
                    "test-Xfit-Uncertainty-Upper": [
                        0.500160692642957,
                        1.00036584601127,
                        1.50053513648402,
                        2.5008235803856,
                        3.50108303720897,
                        4.50133543331854,
                        5.50159259771137,
                        6.50186196458511,
                        7.50214864756277,
                        8.50245638268284,
                        9.50278802032924
                    ],
                    // "Xdata": [
                    //     0.5,
                    //     1,
                    //     1.5,
                    //     2.5,
                    //     3.5,
                    //     4.5,
                    //     5.5,
                    //     6.5,
                    //     7.5,
                    //     8.5,
                    //     9.5
                    // ],
                    // "test-Yfit": [
                    //     149.99283432168886,
                    //     199.98780598165467,
                    //     249.98704946506768,
                    //     349.9910371559672,
                    //     449.9975369446911,
                    //     550.0037557953037,
                    //     650.0081868763082,
                    //     750.0098833059892,
                    //     850.0081939375959,
                    //     950.002643218264,
                    //     1049.9928684998304
                    // ],
                    // "test-Yfit-Uncertainty-Lower": [],
                    // "test-Yfit-Uncertainty-Upper": [],
                    "test-Residual": [
                        [0.000050586546119],
                        [0.00008444458554],
                        [0.00008923026377],
                        [0.00006143908055],
                        [0.00001668919562],
                        [-0.00002599000793],
                        [-0.0000563318843],
                        [-0.00006788378077],
                        [-0.0000562069728],
                        [-0.00001805831259],
                        [0.00004903674755]
                    ]
                },
                "request_Url": '/Polynomial3Fit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=Polynomial3Fit',
                "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
                "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
                "time": '2024-02-03 17:59:58.239794',
                "Server_say": '',
                "error": ''
            };

            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            // String = JSON.stringify(JSON); JSON = JSON.parse(String);

            // response_body_String = request_POST_String;
            if (callback) { callback(null, response_body_String); };
            return response_body_String;
        }

        case "/LC5PFit": {
            // 讀取用戶端（前端 Client）發送的請求數據（Request），並進行四參數邏輯回歸擬合（5 parameter Logistic fitting）運算，並向用戶端（前端 Client）返回運算結果數據;
            // 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit

            request_POST_JSON = {
                'trainXdata': [
                    0.00001,  // parseFloat(0.00001),
                    1,  // parseFloat(1),
                    2,  // parseFloat(2),
                    3,  // parseFloat(3),
                    4,  // parseFloat(4),
                    5,  // parseFloat(5),
                    6,  // parseFloat(6),
                    7,  // parseFloat(7),
                    8,  // parseFloat(8),
                    9,  // parseFloat(9),
                    10  // parseFloat(10)
                ],
                'trainYdata_1': [
                    100,  // parseFloat(100),
                    200,  // parseFloat(200),
                    300,  // parseFloat(300),
                    400,  // parseFloat(400),
                    500,  // parseFloat(500),
                    600,  // parseFloat(600),
                    700,  // parseFloat(700),
                    800,  // parseFloat(800),
                    900,  // parseFloat(900),
                    1000,  // parseFloat(1000),
                    1100  // parseFloat(1100)
                ],
                'trainYdata_2': [
                    98,  // parseFloat(98),
                    198,  // parseFloat(198),
                    298,  // parseFloat(298),
                    398,  // parseFloat(398),
                    498,  // parseFloat(498),
                    598,  // parseFloat(598),
                    698,  // parseFloat(698),
                    798,  // parseFloat(798),
                    898,  // parseFloat(898),
                    998,  // parseFloat(998),
                    1098  // parseFloat(1098)
                ],
                'trainYdata_3': [
                    102,  // parseFloat(102),
                    202,  // parseFloat(202),
                    302,  // parseFloat(302),
                    402,  // parseFloat(402),
                    502,  // parseFloat(502),
                    602,  // parseFloat(602),
                    702,  // parseFloat(702),
                    802,  // parseFloat(802),
                    902,  // parseFloat(902),
                    1002,  // parseFloat(1002),
                    1102  // parseFloat(1102)
                ],
                'weight': [
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5  // parseFloat(0.5)
                ],
                'Pdata_0': [
                    90,  // parseFloat(90),
                    4,  // parseFloat(4),
                    1,  // parseFloat(1),
                    1210  // parseFloat(1210)
                ],
                'Plower': [
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf'  // -Infinity
                ],
                'Pupper': [
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf'  // +Infinity
                ],
                'testYdata_1': [
                    150,  // parseFloat(150),
                    200,  // parseFloat(200),
                    250,  // parseFloat(250),
                    350,  // parseFloat(350),
                    450,  // parseFloat(450),
                    550,  // parseFloat(550),
                    650,  // parseFloat(650),
                    750,  // parseFloat(750),
                    850,  // parseFloat(850),
                    950,  // parseFloat(950),
                    1050  // parseFloat(1050)
                ],
                'testYdata_2': [
                    148,  // parseFloat(148),
                    198,  // parseFloat(198),
                    248,  // parseFloat(248),
                    348,  // parseFloat(348),
                    448,  // parseFloat(448),
                    548,  // parseFloat(548),
                    648,  // parseFloat(648),
                    748,  // parseFloat(748),
                    848,  // parseFloat(848),
                    948,  // parseFloat(948),
                    1048  // parseFloat(1048)
                ],
                'testYdata_3': [
                    152,  // parseFloat(152),
                    202,  // parseFloat(202),
                    252,  // parseFloat(252),
                    352,  // parseFloat(352),
                    452,  // parseFloat(452),
                    552,  // parseFloat(552),
                    652,  // parseFloat(652),
                    752,  // parseFloat(752),
                    852,  // parseFloat(852),
                    952,  // parseFloat(952),
                    1052  // parseFloat(1052)
                ],
                'testXdata': [
                    0.5,  // parseFloat(0.5),
                    1,  // parseFloat(1),
                    1.5,  // parseFloat(1.5),
                    2.5,  // parseFloat(2.5),
                    3.5,  // parseFloat(3.5),
                    4.5,  // parseFloat(4.5),
                    5.5,  // parseFloat(5.5),
                    6.5,  // parseFloat(6.5),
                    7.5,  // parseFloat(7.5),
                    8.5,  // parseFloat(8.5),
                    9.5  // parseFloat(9.5)
                ],
                'trainYdata': [
                    [100, 98, 102],  // [parseFloat(100), parseFloat(98), parseFloat(102)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [300, 298, 302],  // [parseFloat(300), parseFloat(298), parseFloat(302)],
                    [400, 398, 402],  // [parseFloat(400), parseFloat(398), parseFloat(402)],
                    [500, 498, 502],  // [parseFloat(500), parseFloat(498), parseFloat(502)],
                    [600, 598, 602],  // [parseFloat(600), parseFloat(598), parseFloat(602)],
                    [700, 698, 702],  // [parseFloat(700), parseFloat(698), parseFloat(702)],
                    [800, 798, 802],  // [parseFloat(800), parseFloat(798), parseFloat(802)],
                    [900, 898, 902],  // [parseFloat(900), parseFloat(898), parseFloat(902)],
                    [1000, 998, 1002],  // [parseFloat(1000), parseFloat(998), parseFloat(1002)],
                    [1100, 1098, 1102]  // [parseFloat(1100), parseFloat(1098), parseFloat(1102)]
                ],
                'testYdata': [
                    [150, 148, 152],  // [parseFloat(150), parseFloat(148), parseFloat(152)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [250, 248, 252],  // [parseFloat(250), parseFloat(248), parseFloat(252)],
                    [350, 348, 352],  // [parseFloat(350), parseFloat(348), parseFloat(352)],
                    [450, 448, 452],  // [parseFloat(450), parseFloat(448), parseFloat(452)],
                    [550, 548, 552],  // [parseFloat(550), parseFloat(548), parseFloat(552)],
                    [650, 648, 652],  // [parseFloat(650), parseFloat(648), parseFloat(652)],
                    [750, 748, 752],  // [parseFloat(750), parseFloat(748), parseFloat(752)],
                    [850, 848, 852],  // [parseFloat(850), parseFloat(848), parseFloat(852)],
                    [950, 948, 952],  // [parseFloat(950), parseFloat(948), parseFloat(952)],
                    [1050, 1048, 1052]  // [parseFloat(1050), parseFloat(1048), parseFloat(1052)]
                ]
            };

            let Plower = [
                -Infinity,
                -Infinity,
                -Infinity,
                -Infinity
                // -Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Plower")) {
                if (request_POST_JSON["Plower"].length > 0) {
                    // Plower = request_POST_JSON["Plower"];
                    Plower = new Array;
                    for (let i = 0; i < request_POST_JSON["Plower"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "+Base.Inf" || request_POST_JSON["Plower"][i] === "+Inf" || request_POST_JSON["Plower"][i] === "+inf" || request_POST_JSON["Plower"][i] === "+Infinity" || request_POST_JSON["Plower"][i] === "+infinity" || request_POST_JSON["Plower"][i] === "Base.Inf" || request_POST_JSON["Plower"][i] === "Inf" || request_POST_JSON["Plower"][i] === "inf" || request_POST_JSON["Plower"][i] === "Infinity" || request_POST_JSON["Plower"][i] === "infinity")) {
                            Plower.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "-Base.Inf" || request_POST_JSON["Plower"][i] === "-Inf" || request_POST_JSON["Plower"][i] === "-inf" || request_POST_JSON["Plower"][i] === "-Infinity" || request_POST_JSON["Plower"][i] === "-infinity")) {
                            Plower.push(-Infinity);
                        } else {
                            Plower.push(parseFloat(request_POST_JSON["Plower"][i]));
                        };
                    };
                };
            };
            // console.log(Plower);

            let Pupper = [
                +Infinity,
                +Infinity,
                +Infinity,
                +Infinity
                // +Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Pupper")) {
                if (request_POST_JSON["Pupper"].length > 0) {
                    // Pupper = request_POST_JSON["Pupper"];
                    Pupper = new Array;
                    for (let i = 0; i < request_POST_JSON["Pupper"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "+Base.Inf" || request_POST_JSON["Pupper"][i] === "+Inf" || request_POST_JSON["Pupper"][i] === "+inf" || request_POST_JSON["Pupper"][i] === "+Infinity" || request_POST_JSON["Pupper"][i] === "+infinity" || request_POST_JSON["Pupper"][i] === "Base.Inf" || request_POST_JSON["Pupper"][i] === "Inf" || request_POST_JSON["Pupper"][i] === "inf" || request_POST_JSON["Pupper"][i] === "Infinity" || request_POST_JSON["Pupper"][i] === "infinity")) {
                            Pupper.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "-Base.Inf" || request_POST_JSON["Pupper"][i] === "-Inf" || request_POST_JSON["Pupper"][i] === "-inf" || request_POST_JSON["Pupper"][i] === "-Infinity" || request_POST_JSON["Pupper"][i] === "-infinity")) {
                            Pupper.push(-Infinity);
                        } else {
                            Pupper.push(parseFloat(request_POST_JSON["Pupper"][i]));
                        };
                    };
                };
            };
            // console.log(Pupper);

            // if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

            //     if (MongoDBClient !== null) {

            //         // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //         // // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 數組;
            //         // response_data_JSON["Database_say"] = JSON.stringify(result);
            //         // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         // // return response_body_String;

            //         // 注意，在使用 insertMany() 函數插入多條文檔的時候，在參數 ordered 為 true 值的情況下，如果其中一條數據出現錯誤（比如主鍵重複之類的錯誤），那麽會導致所有數據都無法被插入，反之，如果參數 ordered 為 false 值的情況下，只有出錯的數據無法被插入；可以使用 db.dbName.insertMany([], { ordered: false }) 方法來控制是否按順序插入多條數據。
            //         MongoDBClient.db(dbName).collection(dbTableName).insertMany(
            //             request_POST_JSON,
            //             {
            //                 ordered: false
            //             },
            //             function (error, result) {
            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };
            //                 if (result) {
            //                     // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中插入 " + String(result.insertedCount) + " 條數據成功.");
            //                     // console.log(result);
            //                     // response_body_String = JSON.stringify(result);
            //                     response_data_JSON["Database_say"] = JSON.stringify(result);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(null, response_body_String); };
            //                     // return response_body_String;
            //                 };
            //             }
            //         );
    
            //     } else {
    
            //         console.log("Database error.");
            //         response_data_JSON["Database_say"] = "Database error.";
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     };
    
            // } else {
    
            //     console.log("error, data is empty.");
            //     response_data_JSON["Database_say"] = "error, data is empty.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };
    

            // if (MongoDBClient !== null) {

            //     // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //     // let result = await MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray();  // 變量 request_POST_JSON 為 JSON 對象;
            //     // response_data_JSON["Database_say"] = JSON.stringify(result);
            //     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     // // return response_body_String;

            //     MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray(
            //         function (error, result) {
            //             if (error) {
            //                 console.error(error);
            //                 response_data_JSON["Database_say"] = String(error);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(response_body_String, null); };
            //                 // return response_body_String;
            //             };
            //             if (result) {
            //                 // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據成功.");
            //                 // console.log(result);
            //                 // response_body_String = JSON.stringify(result);
            //                 response_data_JSON["Database_say"] = JSON.stringify(result);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(null, response_body_String); };
            //                 // return response_body_String;
            //             };
            //         }
            //     );

            // } else {

            //     console.log("Database error.");
            //     response_data_JSON["Database_say"] = "Database error.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };

            response_data_JSON = {
                "Coefficient": [
                    100.007982422761,
                    42148.4577551448,
                    1.0001564001486,
                    4221377.92224082
                ],
                "Coefficient-StandardDeviation": [
                    0.00781790123184812,
                    2104.76673086505,
                    0.0000237490808220821,
                    210359.023599377
                ],
                "Coefficient-Confidence-Lower-95%": [
                    99.9908250045862,
                    37529.2688077105,
                    1.0001042796499,
                    3759717.22485611
                ],
                "Coefficient-Confidence-Upper-95%": [
                    100.025139840936,
                    46767.6467025791,
                    1.00020852064729,
                    4683038.61962554
                ],
                "Yfit": [
                    100.008980483748,
                    199.99155580718,
                    299.992070696316,
                    399.99603100866,
                    500.000567344017,
                    600.00431688223,
                    700.006476967595,
                    800.006517272442,
                    900.004060927778,
                    999.998826196417,
                    1099.99059444852
                ],
                "Yfit-Uncertainty-Lower": [
                    99.0089499294379,
                    198.991136273453,
                    298.990136898385,
                    398.991624763274,
                    498.99282487668,
                    598.992447662226,
                    698.989753032473,
                    798.984266632803,
                    898.975662941844,
                    998.963708008532,
                    1098.94822805642
                ],
                "Yfit-Uncertainty-Upper": [
                    101.00901103813,
                    200.991951293373,
                    300.993902825086,
                    401.000210884195,
                    501.007916682505,
                    601.015588680788,
                    701.022365894672,
                    801.027666045591,
                    901.031064750697,
                    1001.0322361364,
                    1101.0309201882
                ],
                "Residual": [
                    0.00898048374801874,
                    -0.00844419281929731,
                    -0.00792930368334055,
                    -0.00396899133920669,
                    0.000567344017326831,
                    0.00431688223034143,
                    0.00647696759551763,
                    0.00651727244257926,
                    0.00406092777848243,
                    -0.00117380358278751,
                    -0.00940555147826671
                ],
                "testData": {
                    "Ydata": [
                        [150, 148, 152],
                        [200, 198, 202],
                        [250, 248, 252],
                        [350, 348, 352],
                        [450, 448, 452],
                        [550, 548, 552],
                        [650, 648, 652],
                        [750, 748, 752],
                        [850, 848, 852],
                        [950, 948, 952],
                        [1050, 1048, 1052]
                    ],
                    "test-Xvals": [
                        0.500050586546119,
                        1.00008444458554,
                        1.50008923026377,
                        2.50006143908055,
                        3.50001668919562,
                        4.49997400999207,
                        5.49994366811569,
                        6.49993211621922,
                        7.49994379302719,
                        8.49998194168741,
                        9.50004903674755
                    ],
                    // "test-Xvals-Uncertainty-Lower": [
                    //     0.499936310423273,
                    //     0.999794808816128,
                    //     1.49963107921017,
                    //     2.49927920023971,
                    //     3.49892261926065,
                    //     4.49857747071072,
                    //     5.4982524599721,
                    //     6.4979530588239,
                    //     7.49768303155859,
                    //     8.49744512880161,
                    //     9.49724144950174
                    // ],
                    // "test-Xvals-Uncertainty-Upper": [
                    //     0.500160692642957,
                    //     1.00036584601127,
                    //     1.50053513648402,
                    //     2.5008235803856,
                    //     3.50108303720897,
                    //     4.50133543331854,
                    //     5.50159259771137,
                    //     6.50186196458511,
                    //     7.50214864756277,
                    //     8.50245638268284,
                    //     9.50278802032924
                    // ],
                    "test-Xfit-Uncertainty-Lower": [
                        0.499936310423273,
                        0.999794808816128,
                        1.49963107921017,
                        2.49927920023971,
                        3.49892261926065,
                        4.49857747071072,
                        5.4982524599721,
                        6.4979530588239,
                        7.49768303155859,
                        8.49744512880161,
                        9.49724144950174
                    ],
                    "test-Xfit-Uncertainty-Upper": [
                        0.500160692642957,
                        1.00036584601127,
                        1.50053513648402,
                        2.5008235803856,
                        3.50108303720897,
                        4.50133543331854,
                        5.50159259771137,
                        6.50186196458511,
                        7.50214864756277,
                        8.50245638268284,
                        9.50278802032924
                    ],
                    // "Xdata": [
                    //     0.5,
                    //     1,
                    //     1.5,
                    //     2.5,
                    //     3.5,
                    //     4.5,
                    //     5.5,
                    //     6.5,
                    //     7.5,
                    //     8.5,
                    //     9.5
                    // ],
                    // "test-Yfit": [
                    //     149.99283432168886,
                    //     199.98780598165467,
                    //     249.98704946506768,
                    //     349.9910371559672,
                    //     449.9975369446911,
                    //     550.0037557953037,
                    //     650.0081868763082,
                    //     750.0098833059892,
                    //     850.0081939375959,
                    //     950.002643218264,
                    //     1049.9928684998304
                    // ],
                    // "test-Yfit-Uncertainty-Lower": [],
                    // "test-Yfit-Uncertainty-Upper": [],
                    "test-Residual": [
                        [0.000050586546119],
                        [0.00008444458554],
                        [0.00008923026377],
                        [0.00006143908055],
                        [0.00001668919562],
                        [-0.00002599000793],
                        [-0.0000563318843],
                        [-0.00006788378077],
                        [-0.0000562069728],
                        [-0.00001805831259],
                        [0.00004903674755]
                    ]
                },
                "request_Url": '/LC5PFit?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=LC5PFit',
                "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
                "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
                "time": '2024-02-03 17:59:58.239794',
                "Server_say": '',
                "error": ''
            };

            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            // String = JSON.stringify(JSON); JSON = JSON.parse(String);

            // response_body_String = request_POST_String;
            if (callback) { callback(null, response_body_String); };
            return response_body_String;
        }

        case "/Interpolation": {
            // 讀取用戶端（前端 Client）發送的請求數據（Request），並進行四參數邏輯回歸擬合（5 parameter Logistic fitting）運算，並向用戶端（前端 Client）返回運算結果數據;
            // 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1

            request_POST_JSON = {
                'trainXdata': [
                    0.00001,  // parseFloat(0.00001),
                    1,  // parseFloat(1),
                    2,  // parseFloat(2),
                    3,  // parseFloat(3),
                    4,  // parseFloat(4),
                    5,  // parseFloat(5),
                    6,  // parseFloat(6),
                    7,  // parseFloat(7),
                    8,  // parseFloat(8),
                    9,  // parseFloat(9),
                    10  // parseFloat(10)
                ],
                'trainYdata_1': [
                    100,  // parseFloat(100),
                    200,  // parseFloat(200),
                    300,  // parseFloat(300),
                    400,  // parseFloat(400),
                    500,  // parseFloat(500),
                    600,  // parseFloat(600),
                    700,  // parseFloat(700),
                    800,  // parseFloat(800),
                    900,  // parseFloat(900),
                    1000,  // parseFloat(1000),
                    1100  // parseFloat(1100)
                ],
                'trainYdata_2': [
                    98,  // parseFloat(98),
                    198,  // parseFloat(198),
                    298,  // parseFloat(298),
                    398,  // parseFloat(398),
                    498,  // parseFloat(498),
                    598,  // parseFloat(598),
                    698,  // parseFloat(698),
                    798,  // parseFloat(798),
                    898,  // parseFloat(898),
                    998,  // parseFloat(998),
                    1098  // parseFloat(1098)
                ],
                'trainYdata_3': [
                    102,  // parseFloat(102),
                    202,  // parseFloat(202),
                    302,  // parseFloat(302),
                    402,  // parseFloat(402),
                    502,  // parseFloat(502),
                    602,  // parseFloat(602),
                    702,  // parseFloat(702),
                    802,  // parseFloat(802),
                    902,  // parseFloat(902),
                    1002,  // parseFloat(1002),
                    1102  // parseFloat(1102)
                ],
                'weight': [
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5,  // parseFloat(0.5),
                    0.5  // parseFloat(0.5)
                ],
                'Pdata_0': [
                    90,  // parseFloat(90),
                    4,  // parseFloat(4),
                    1,  // parseFloat(1),
                    1210  // parseFloat(1210)
                ],
                'Plower': [
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf',  // -Infinity,
                    '-inf'  // -Infinity
                ],
                'Pupper': [
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf',  // +Infinity,
                    '+inf'  // +Infinity
                ],
                'testYdata_1': [
                    150,  // parseFloat(150),
                    200,  // parseFloat(200),
                    250,  // parseFloat(250),
                    350,  // parseFloat(350),
                    450,  // parseFloat(450),
                    550,  // parseFloat(550),
                    650,  // parseFloat(650),
                    750,  // parseFloat(750),
                    850,  // parseFloat(850),
                    950,  // parseFloat(950),
                    1050  // parseFloat(1050)
                ],
                'testYdata_2': [
                    148,  // parseFloat(148),
                    198,  // parseFloat(198),
                    248,  // parseFloat(248),
                    348,  // parseFloat(348),
                    448,  // parseFloat(448),
                    548,  // parseFloat(548),
                    648,  // parseFloat(648),
                    748,  // parseFloat(748),
                    848,  // parseFloat(848),
                    948,  // parseFloat(948),
                    1048  // parseFloat(1048)
                ],
                'testYdata_3': [
                    152,  // parseFloat(152),
                    202,  // parseFloat(202),
                    252,  // parseFloat(252),
                    352,  // parseFloat(352),
                    452,  // parseFloat(452),
                    552,  // parseFloat(552),
                    652,  // parseFloat(652),
                    752,  // parseFloat(752),
                    852,  // parseFloat(852),
                    952,  // parseFloat(952),
                    1052  // parseFloat(1052)
                ],
                'testXdata': [
                    0.5,  // parseFloat(0.5),
                    1,  // parseFloat(1),
                    1.5,  // parseFloat(1.5),
                    2.5,  // parseFloat(2.5),
                    3.5,  // parseFloat(3.5),
                    4.5,  // parseFloat(4.5),
                    5.5,  // parseFloat(5.5),
                    6.5,  // parseFloat(6.5),
                    7.5,  // parseFloat(7.5),
                    8.5,  // parseFloat(8.5),
                    9.5  // parseFloat(9.5)
                ],
                'trainYdata': [
                    [100, 98, 102],  // [parseFloat(100), parseFloat(98), parseFloat(102)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [300, 298, 302],  // [parseFloat(300), parseFloat(298), parseFloat(302)],
                    [400, 398, 402],  // [parseFloat(400), parseFloat(398), parseFloat(402)],
                    [500, 498, 502],  // [parseFloat(500), parseFloat(498), parseFloat(502)],
                    [600, 598, 602],  // [parseFloat(600), parseFloat(598), parseFloat(602)],
                    [700, 698, 702],  // [parseFloat(700), parseFloat(698), parseFloat(702)],
                    [800, 798, 802],  // [parseFloat(800), parseFloat(798), parseFloat(802)],
                    [900, 898, 902],  // [parseFloat(900), parseFloat(898), parseFloat(902)],
                    [1000, 998, 1002],  // [parseFloat(1000), parseFloat(998), parseFloat(1002)],
                    [1100, 1098, 1102]  // [parseFloat(1100), parseFloat(1098), parseFloat(1102)]
                ],
                'testYdata': [
                    [150, 148, 152],  // [parseFloat(150), parseFloat(148), parseFloat(152)],
                    [200, 198, 202],  // [parseFloat(200), parseFloat(198), parseFloat(202)],
                    [250, 248, 252],  // [parseFloat(250), parseFloat(248), parseFloat(252)],
                    [350, 348, 352],  // [parseFloat(350), parseFloat(348), parseFloat(352)],
                    [450, 448, 452],  // [parseFloat(450), parseFloat(448), parseFloat(452)],
                    [550, 548, 552],  // [parseFloat(550), parseFloat(548), parseFloat(552)],
                    [650, 648, 652],  // [parseFloat(650), parseFloat(648), parseFloat(652)],
                    [750, 748, 752],  // [parseFloat(750), parseFloat(748), parseFloat(752)],
                    [850, 848, 852],  // [parseFloat(850), parseFloat(848), parseFloat(852)],
                    [950, 948, 952],  // [parseFloat(950), parseFloat(948), parseFloat(952)],
                    [1050, 1048, 1052]  // [parseFloat(1050), parseFloat(1048), parseFloat(1052)]
                ]
            };

            let Plower = [
                -Infinity,
                -Infinity,
                -Infinity,
                -Infinity
                // -Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Plower")) {
                if (request_POST_JSON["Plower"].length > 0) {
                    // Plower = request_POST_JSON["Plower"];
                    Plower = new Array;
                    for (let i = 0; i < request_POST_JSON["Plower"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "+Base.Inf" || request_POST_JSON["Plower"][i] === "+Inf" || request_POST_JSON["Plower"][i] === "+inf" || request_POST_JSON["Plower"][i] === "+Infinity" || request_POST_JSON["Plower"][i] === "+infinity" || request_POST_JSON["Plower"][i] === "Base.Inf" || request_POST_JSON["Plower"][i] === "Inf" || request_POST_JSON["Plower"][i] === "inf" || request_POST_JSON["Plower"][i] === "Infinity" || request_POST_JSON["Plower"][i] === "infinity")) {
                            Plower.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Plower"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Plower"][i] === "-Base.Inf" || request_POST_JSON["Plower"][i] === "-Inf" || request_POST_JSON["Plower"][i] === "-inf" || request_POST_JSON["Plower"][i] === "-Infinity" || request_POST_JSON["Plower"][i] === "-infinity")) {
                            Plower.push(-Infinity);
                        } else {
                            Plower.push(parseFloat(request_POST_JSON["Plower"][i]));
                        };
                    };
                };
            };
            // console.log(Plower);

            let Pupper = [
                +Infinity,
                +Infinity,
                +Infinity,
                +Infinity
                // +Infinity
            ];
            if (request_POST_JSON.hasOwnProperty("Pupper")) {
                if (request_POST_JSON["Pupper"].length > 0) {
                    // Pupper = request_POST_JSON["Pupper"];
                    Pupper = new Array;
                    for (let i = 0; i < request_POST_JSON["Pupper"].length; i++) {
                        if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "+Base.Inf" || request_POST_JSON["Pupper"][i] === "+Inf" || request_POST_JSON["Pupper"][i] === "+inf" || request_POST_JSON["Pupper"][i] === "+Infinity" || request_POST_JSON["Pupper"][i] === "+infinity" || request_POST_JSON["Pupper"][i] === "Base.Inf" || request_POST_JSON["Pupper"][i] === "Inf" || request_POST_JSON["Pupper"][i] === "inf" || request_POST_JSON["Pupper"][i] === "Infinity" || request_POST_JSON["Pupper"][i] === "infinity")) {
                            Pupper.push(+Infinity);
                        } else if (Object.prototype.toString.call(request_POST_JSON["Pupper"][i]).toLowerCase() === '[object string]' && (request_POST_JSON["Pupper"][i] === "-Base.Inf" || request_POST_JSON["Pupper"][i] === "-Inf" || request_POST_JSON["Pupper"][i] === "-inf" || request_POST_JSON["Pupper"][i] === "-Infinity" || request_POST_JSON["Pupper"][i] === "-infinity")) {
                            Pupper.push(-Infinity);
                        } else {
                            Pupper.push(parseFloat(request_POST_JSON["Pupper"][i]));
                        };
                    };
                };
            };
            // console.log(Pupper);

            // if ((Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object array]' && request_POST_JSON.length > 0 && (typeof (request_POST_JSON[0]) === 'object' && Object.prototype.toString.call(request_POST_JSON[0]).toLowerCase() === '[object object]' && !(request_POST_JSON[0].length) && JSON.stringify(request_POST_JSON[0]) !== '{}')) || (typeof (request_POST_JSON) === 'object' && Object.prototype.toString.call(request_POST_JSON).toLowerCase() === '[object object]' && !(request_POST_JSON.length) && JSON.stringify(request_POST_JSON) !== '{}')) {

            //     if (MongoDBClient !== null) {

            //         // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //         // // let result = await MongoDBClient.db(dbName).collection(dbTableName).insertMany(request_POST_JSON);  // 變量 request_POST_JSON 為 JSON 數組;
            //         // response_data_JSON["Database_say"] = JSON.stringify(result);
            //         // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         // // return response_body_String;

            //         // 注意，在使用 insertMany() 函數插入多條文檔的時候，在參數 ordered 為 true 值的情況下，如果其中一條數據出現錯誤（比如主鍵重複之類的錯誤），那麽會導致所有數據都無法被插入，反之，如果參數 ordered 為 false 值的情況下，只有出錯的數據無法被插入；可以使用 db.dbName.insertMany([], { ordered: false }) 方法來控制是否按順序插入多條數據。
            //         MongoDBClient.db(dbName).collection(dbTableName).insertMany(
            //             request_POST_JSON,
            //             {
            //                 ordered: false
            //             },
            //             function (error, result) {
            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };
            //                 if (result) {
            //                     // console.log("向數據庫 " + dbName + " 中包含的集合 " + dbTableName + "中插入 " + String(result.insertedCount) + " 條數據成功.");
            //                     // console.log(result);
            //                     // response_body_String = JSON.stringify(result);
            //                     response_data_JSON["Database_say"] = JSON.stringify(result);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(null, response_body_String); };
            //                     // return response_body_String;
            //                 };
            //             }
            //         );
    
            //     } else {
    
            //         console.log("Database error.");
            //         response_data_JSON["Database_say"] = "Database error.";
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     };
    
            // } else {
    
            //     console.log("error, data is empty.");
            //     response_data_JSON["Database_say"] = "error, data is empty.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };
    

            // if (MongoDBClient !== null) {

            //     // const dbTable = MongoDBClient.db(dbName).collection(dbTableName); // 鏈接指定數據庫中包含的指定集合（表格）;

            //     // let result = await MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray();  // 變量 request_POST_JSON 為 JSON 對象;
            //     // response_data_JSON["Database_say"] = JSON.stringify(result);
            //     // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     // // return response_body_String;

            //     MongoDBClient.db(dbName).collection(dbTableName).find(request_POST_JSON).toArray(
            //         function (error, result) {
            //             if (error) {
            //                 console.error(error);
            //                 response_data_JSON["Database_say"] = String(error);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(response_body_String, null); };
            //                 // return response_body_String;
            //             };
            //             if (result) {
            //                 // console.log("從數據庫 " + dbName + " 中包含的集合 " + dbTableName + " 中查詢數據成功.");
            //                 // console.log(result);
            //                 // response_body_String = JSON.stringify(result);
            //                 response_data_JSON["Database_say"] = JSON.stringify(result);
            //                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                 if (callback) { callback(null, response_body_String); };
            //                 // return response_body_String;
            //             };
            //         }
            //     );

            // } else {

            //     console.log("Database error.");
            //     response_data_JSON["Database_say"] = "Database error.";
            //     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //     if (callback) { callback(response_body_String, null); };
            //     // return response_body_String;
            // };

            response_data_JSON = {
                // "Coefficient": [
                //     100.007982422761,
                //     42148.4577551448,
                //     1.0001564001486,
                //     4221377.92224082
                // ],
                // "Coefficient-StandardDeviation": [
                //     0.00781790123184812,
                //     2104.76673086505,
                //     0.0000237490808220821,
                //     210359.023599377
                // ],
                // "Coefficient-Confidence-Lower-95%": [
                //     99.9908250045862,
                //     37529.2688077105,
                //     1.0001042796499,
                //     3759717.22485611
                // ],
                // "Coefficient-Confidence-Upper-95%": [
                //     100.025139840936,
                //     46767.6467025791,
                //     1.00020852064729,
                //     4683038.61962554
                // ],
                // "Yfit": [
                //     100.008980483748,
                //     199.99155580718,
                //     299.992070696316,
                //     399.99603100866,
                //     500.000567344017,
                //     600.00431688223,
                //     700.006476967595,
                //     800.006517272442,
                //     900.004060927778,
                //     999.998826196417,
                //     1099.99059444852
                // ],
                // "Yfit-Uncertainty-Lower": [
                //     99.0089499294379,
                //     198.991136273453,
                //     298.990136898385,
                //     398.991624763274,
                //     498.99282487668,
                //     598.992447662226,
                //     698.989753032473,
                //     798.984266632803,
                //     898.975662941844,
                //     998.963708008532,
                //     1098.94822805642
                // ],
                // "Yfit-Uncertainty-Upper": [
                //     101.00901103813,
                //     200.991951293373,
                //     300.993902825086,
                //     401.000210884195,
                //     501.007916682505,
                //     601.015588680788,
                //     701.022365894672,
                //     801.027666045591,
                //     901.031064750697,
                //     1001.0322361364,
                //     1101.0309201882
                // ],
                // "Residual": [
                //     0.00898048374801874,
                //     -0.00844419281929731,
                //     -0.00792930368334055,
                //     -0.00396899133920669,
                //     0.000567344017326831,
                //     0.00431688223034143,
                //     0.00647696759551763,
                //     0.00651727244257926,
                //     0.00406092777848243,
                //     -0.00117380358278751,
                //     -0.00940555147826671
                // ],
                "testData": {
                    "Ydata": [
                        [150, 148, 152],
                        [200, 198, 202],
                        [250, 248, 252],
                        [350, 348, 352],
                        [450, 448, 452],
                        [550, 548, 552],
                        [650, 648, 652],
                        [750, 748, 752],
                        [850, 848, 852],
                        [950, 948, 952],
                        [1050, 1048, 1052]
                    ],
                    "test-Xvals": [
                        0.500050586546119,
                        1.00008444458554,
                        1.50008923026377,
                        2.50006143908055,
                        3.50001668919562,
                        4.49997400999207,
                        5.49994366811569,
                        6.49993211621922,
                        7.49994379302719,
                        8.49998194168741,
                        9.50004903674755
                    ],
                    // "test-Xvals-Uncertainty-Lower": [
                    //     0.499936310423273,
                    //     0.999794808816128,
                    //     1.49963107921017,
                    //     2.49927920023971,
                    //     3.49892261926065,
                    //     4.49857747071072,
                    //     5.4982524599721,
                    //     6.4979530588239,
                    //     7.49768303155859,
                    //     8.49744512880161,
                    //     9.49724144950174
                    // ],
                    // "test-Xvals-Uncertainty-Upper": [
                    //     0.500160692642957,
                    //     1.00036584601127,
                    //     1.50053513648402,
                    //     2.5008235803856,
                    //     3.50108303720897,
                    //     4.50133543331854,
                    //     5.50159259771137,
                    //     6.50186196458511,
                    //     7.50214864756277,
                    //     8.50245638268284,
                    //     9.50278802032924
                    // ],
                    "test-Xfit-Uncertainty-Lower": [
                        0.499936310423273,
                        0.999794808816128,
                        1.49963107921017,
                        2.49927920023971,
                        3.49892261926065,
                        4.49857747071072,
                        5.4982524599721,
                        6.4979530588239,
                        7.49768303155859,
                        8.49744512880161,
                        9.49724144950174
                    ],
                    "test-Xfit-Uncertainty-Upper": [
                        0.500160692642957,
                        1.00036584601127,
                        1.50053513648402,
                        2.5008235803856,
                        3.50108303720897,
                        4.50133543331854,
                        5.50159259771137,
                        6.50186196458511,
                        7.50214864756277,
                        8.50245638268284,
                        9.50278802032924
                    ],
                    // "Xdata": [
                    //     0.5,
                    //     1,
                    //     1.5,
                    //     2.5,
                    //     3.5,
                    //     4.5,
                    //     5.5,
                    //     6.5,
                    //     7.5,
                    //     8.5,
                    //     9.5
                    // ],
                    // "test-Yfit": [
                    //     149.99283432168886,
                    //     199.98780598165467,
                    //     249.98704946506768,
                    //     349.9910371559672,
                    //     449.9975369446911,
                    //     550.0037557953037,
                    //     650.0081868763082,
                    //     750.0098833059892,
                    //     850.0081939375959,
                    //     950.002643218264,
                    //     1049.9928684998304
                    // ],
                    // "test-Yfit-Uncertainty-Lower": [],
                    // "test-Yfit-Uncertainty-Upper": [],
                    "test-Residual": [
                        [0.000050586546119],
                        [0.00008444458554],
                        [0.00008923026377],
                        [0.00006143908055],
                        [0.00001668919562],
                        [-0.00002599000793],
                        [-0.0000563318843],
                        [-0.00006788378077],
                        [-0.0000562069728],
                        [-0.00001805831259],
                        [0.00004903674755]
                    ]
                },
                "request_Url": '/Interpolation?Key=username:password&algorithmUser=username&algorithmPass=password&algorithmName=BSpline(Cubic)&algorithmLambda=0&algorithmKei=2&algorithmDi=1&algorithmEith=1',
                "request_Authorization": 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=',
                "request_Cookie": 'session_id=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk',
                "time": '2024-02-03 17:59:58.239794',
                "Server_say": '',
                "error": ''
            };

            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            // String = JSON.stringify(JSON); JSON = JSON.parse(String);

            // response_body_String = request_POST_String;
            if (callback) { callback(null, response_body_String); };
            return response_body_String;
        }

        default: {

            let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
            // web_path = String(path.join(webPath, request_url_path));
            file_data = null;

            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // response_body_String = file_data.toString();
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {

                                let file_data_Buffer = data;
                                // let buffer = new ArrayBuffer(TemporaryPublicVariableCollectResultStoredStringArray.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
                                // let file_data_bytes_Uint8Array = new Uint8Array(buffer);  // 轉換為 Buffer 二進制對象;
                                // for (let i = 0; i < TemporaryPublicVariableCollectResultStoredStringArray.length; i++) {
                                //     file_data_bytes_Uint8Array[i] = TemporaryPublicVariableCollectResultStoredStringArray[i];
                                // };
                                // file_data_String = file_data_bytes_Uint8Array.toString();
                                file_data_Buffer = new Uint8Array(file_data_Buffer);
                                // console.log(file_data_Buffer);
                                // file_data = file_data_Buffer.toString();
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                // file_data = JSON.stringify(file_data_Buffer);  // JSON.parse(file_data);
                                let file_data_Uint8Array = new Array();
                                for (let i = 0; i < file_data_Buffer.length; i++) {
                                    file_data_Uint8Array.push(file_data_Buffer[i]);
                                    // file_data_Uint8Array.push(String(file_data_Buffer[i]));
                                };
                                file_data = JSON.stringify(file_data_Uint8Array);  // JSON.parse(file_data);
                                response_body_String = file_data;
                                // console.log(response_body_String);
                                if (callback) { callback(null, response_body_String); };
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path_index_Html);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // let filesName = fs.readdirSync(web_path);
                    // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                    // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                    // filesName.forEach(
                    //     function (item) {
                    //         // console.log("異步讀取文件夾目錄: " + item.toString());
                    //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                    //         if (statsObj.isFile()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                    //         } else if (statsObj.isDirectory()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                    //         } else {};
                    //     }
                    // );
                    // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path_index_Html,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {
                                file_data = data;
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                fs.readdir(
                                    web_path,
                                    function (error, filesName) {

                                        if (error) {
                                            console.error(error);
                                            response_data_JSON["Database_say"] = String(error);
                                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                            if (callback) { callback(response_body_String, null); };
                                            // return response_body_String;
                                        };

                                        if (filesName) {
                                            let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                            // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                            filesName.forEach(
                                                function (item) {
                                                    // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                    let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                    // console.log("異步讀取文件夾目錄: " + item.toString());
                                                    let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                                                    if (statsObj.isFile()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else if (statsObj.isDirectory()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else {};
                                                }
                                            );
                                            response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                            // console.log(response_body_String);
                                            if (callback) { callback(null, response_body_String); };
                                            // return response_body_String;
                                        };
                                    }
                                );
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else {

                console.log("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(web_path) + " } 無法識別.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(fileName) + " } 無法識別.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }
    };
};
module.exports.do_Request_Router = do_Request_Router; // 使用「module.exports」接口對象，用來導出模塊中的成員;


// // 用戶端（前端）http_Client() 使用説明;
// // 控制臺命令行使用:
// // C:\>C:\StatisticalServer\NodeJS\nodejs-14.4.0\node.exe C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js

// // 媒介服務器函數服務端（後端） http_Server() 使用説明;
// // const child_process = require('child_process');  // Node原生的創建子進程模組;
// // const os = require('os');  // Node原生的操作系統信息模組;
// // const net = require('net');  // Node原生的網卡網絡操作模組;
// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
// const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
// const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
// // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
// // const cluster = require('cluster');  // Node原生的支持多進程模組;
// // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
// // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
// let host = "::0";  // "::0", "::1", "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 10001;  // 1 ~ 65535 監聽端口;
// let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// // let webPath = String(require('path').join(String(__dirname), "html"));
// let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// // console.log(number_cluster_Workers);
// let Key = "username:password";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// let Session = {
//     "request_Key->username:password": Key
// };
// let do_Request = do_Request_Router;  // function (argument) { return argument; };  // 用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// let do_Function_JSON = {
//     "do_Request": do_Request.toString(),  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// };
// let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
// let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
// let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
// let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
// let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "Key": {
//                             Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Server UserName and PassWord: " + Key);
//                             break;
//                         }
//                         case "host": {
//                             host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + host);
//                             break;
//                         }
//                         case "port": {
//                             port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // console.log("listening Port: " + port);
//                             break;
//                         }
//                         case "webPath": {
//                             webPath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 監聽端口;
//                             // console.log("http Server root directory: " + webPath);
//                             break;
//                         }
//                         case "number_cluster_Workers": {
//                             number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number cluster Workers: " + number_cluster_Workers);
//                             break;
//                         }
//                         case "Session": {
//                             if (isStringJSON(process.argv[i].split('=')[1])) {
//                                 Session = JSON.parse(process.argv[i].split('=')[1]);
//                             } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                                 Session[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                             } else {
//                                 Session = null;
//                             };
//                             // console.log("Server Session: " + Session);
//                             break;
//                         }
//                         case "do_Request": {
//                             // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//                             if (Object.prototype.toString.call(do_Request = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Request = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Request = null;
//                             };
//                             // console.log("do_Request: " + do_Request);
//                             break;
//                         }
//                         default: {
//                             // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// let Server = Interface_http_Server({
//     "host": host,
//     "port": port,
//     "number_cluster_Workers": number_cluster_Workers,
//     "Key": Key,
//     "Session": Session,
//     // "do_Function_JSON": do_Function_JSON,
//     "do_Request": do_Request,
//     "exclusive": exclusive,
//     "backlog": backlog,
//     "readableAll": readableAll,
//     "writableAll": writableAll,
//     "ipv6Only": ipv6Only
// });
// // let Server = Interface_http_Server({
// //     "do_Request": do_Request,
// //     "Session": Session,
// //     "Key": Key,
// //     "number_cluster_Workers": number_cluster_Workers,
// // });







// 自定義具體處理從服務端返回的響應值數據的執行函數;
function do_Response_Router(
    response_status,
    response_headers,
    response_POST_String,
    callback
){
// async function do_Request_Router(
//     response_status,
//     response_headers,
//     response_POST_String
// ){

    // console.log(response_status);
    // console.log(response_headers);
    // console.log(response_POST_String);

    // Check the file extension required and set the right mime type;
    // try {
    //     fs.readFileSync();
    //     fs.writeFileSync();
    // } catch (error) {
    //     console.log("硬盤文件打開或讀取錯誤.");
    // } finally {
    //     fs.close();
    // };

    let response_body_String = "";
    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    let response_data_JSON = {
        "response_status": response_status,
        "response_headers": response_headers,
        "response_POST_String": response_POST_String,
        // "response_Cookie": response_headers["Set-Cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
        // "Server_Authorization": response_headers["WWW-Authenticate"],  // "username:password";
        "time": String(now_date)
    };
    // console.log(response_data_JSON);

    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    // console.log(response_body_String);

    // // let filePath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
    // // console.log(filePath);
    // let file_path = String(path.join(filePath, response_url_path));
    // // console.log(file_path);

    // // try {
    // //     // 異步寫入硬盤文檔;
    // //     fs.writeFile(
    // //         file_path,
    // //         data,
    // //         function (error) {
    // //             if (error) { return console.error(error); };
    // //         }
    // //     );
    // //     // 同步讀取硬盤文檔;
    // //     // fs.writeFileSync(file_path, data);
    // // } catch (error) {
    // //     console.log("硬盤文檔打開或寫入錯誤.");
    // // } finally {
    // //     fs.close();
    // // };

    if (callback) { callback(response_body_String, null); };
    return response_body_String;
};
module.exports.do_Response_Router = do_Response_Router; // 使用「module.exports」接口對象，用來導出模塊中的成員;


// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // 這裏是需要向Python服務器發送的參數數據JSON對象;
// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // let nowDate = new Date();
// // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
// let argument = "How_are_you_!";
// let post_Data_JSON = {
//     "Client_say": argument.replace(new RegExp("\\_", "g"), " "),
//     "time": String(now_date)
// };
// let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;

// let Host = "localhost";
// let Port = "8000";
// let URL = "/"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = ""; // "username:password";
// let request_Cookie = ""; // "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", new Base64().encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
// let do_Response = do_Response_Router;  // function (argument) { return argument; };  // 用於接收執行處理響應值（response）的函數 "do_Response_Router";
// let do_Function_JSON = {
//     "do_Response": do_Response.toString(),  // "function() {};" 函數對象字符串，用於接收執行處理響應值（response）的函數 "do_Response_Router";
// };

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "host": {
//                             // host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // // console.log("Host domain name: " + host);
//                             Host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + Host);
//                             break;
//                         }
//                         case "port": {
//                             // port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // // console.log("listening Port: " + port);
//                             Port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // console.log("listening Port: " + Port);
//                             break;
//                         }
//                         case "URL": {
//                             URL = String(process.argv[i].split("=")[1]);  // "http://usename:password@localhost:10001/"; 請求的網址字符串;
//                             // console.log("request URL: " + URL);
//                             break;
//                         }
//                         case "method": {
//                             // method = String(process.argv[i].split("=")[1]);  // "POST"; 請求的類型;
//                             Method = String(process.argv[i].split("=")[1]);  // "POST"; 請求的類型;
//                             // console.log("request Method: " + Method);
//                             break;
//                         }
//                         case "time_out": {
//                             time_out = parseInt(process.argv[i].split("=")[1]);  // 1000; 設置鏈接超時自動中斷，單位毫秒;
//                             // console.log("request out time: " + time_out);
//                             break;
//                         }
//                         case "request_Auth": {
//                             request_Auth = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Client UserName and PassWord: " + request_Auth);
//                             break;
//                         }
//                         case "request_Cookie": {
//                             request_Cookie = String(process.argv[i].split("=")[1]);  // "Session_ID=request_Key->username:password" 自定義的訪問網站時發送的請求 Cookie 值;
//                             // console.log("Client request Cookie: " + request_Cookie);
//                             break;
//                         }
//                         case "output_dir": {
//                             output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                             // console.log("output dir: " + output_dir);
//                             break;
//                         }
//                         case "output_file": {
//                             output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("output file: " + output_file);
//                             break;
//                         }
//                         case "to_executable": {
//                             to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("to executable: " + to_executable);
//                             break;
//                         }
//                         case "to_script": {
//                             to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("to script: " + to_script);
//                             break;
//                         }
//                         case "do_Response": {
//                             // "function() {};" 函數對象字符串，// 函數對象字符串，用於執行對接收到的服務端返回的響應處理功能的函數 "do_Response_Router";
//                             if (Object.prototype.toString.call(do_Response = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Response = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Response = null;
//                             };
//                             // console.log("do_Response: " + do_Response);
//                             break;
//                         }
//                         default: {
//                             console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };

// // console.log(String(now_date) + " " + "http://" + Host + ":" + Port + URL + " " + options["method"] + " @" + request_Auth + " " + request_Cookie);
// console.log("Client say: " + argument.replace(new RegExp("_", "g"), " "));

// http_Client({
//     "Host": Host,
//     "Port": Port,
//     "URL": URL,
//     "Method": Method,
//     "time_out": time_out,
//     "request_Auth": request_Auth,
//     "request_Cookie": request_Cookie,
//     "post_Data_String": post_Data_String,
//     "do_Response": do_Response,
// }, (error, response) => {
//     console.log(response);

//     // let response_status_String = response[0];
//     // console.log(response_status_String);
//     // let response_head_String = response[1];
//     // console.log(response_head_String);

//     // let response_body_String = response[2];
//     // console.log(response_body_String);
//     // // // response_body_String = {
//     // // //     "request Nikename": request_Nikename,
//     // // //     "request Passwork": request_Password,
//     // // //     "request_Authorization": Key,  // "username:password";
//     // // //     "Server_say": "Fine, thank you, and you ?",
//     // // //     "time": "2021-02-03 20:21:25.136"
//     // // // };

//     // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//     // let data_JSON = {};
//     // if (isStringJSON(response_body_String)) {
//     //     data_JSON = JSON.parse(response_body_String);
//     // } else {
//     //     data_JSON = {
//     //         "Server_say": response_body_String
//     //     };
//     // };

//     // console.log("Server say: " + data_JSON["Server_say"]);
// });


// 用於在模組外代碼使用 require() 方法導入本模組刷新本模組内的變量賦值，使用「module.exports」接口對象，用來導出模塊中的成員;
function setValue(newValue) {
    if (Object.keys(newValue).length > 0) {
        Object.keys(newValue).forEach(key => {
            // console.log(key, newValue[key]);
            if (key === "webPath") {
                webPath = newValue[key]
            } else if (key === "Key") {
                Key = newValue[key]
            } else if (key === "Session") {
                Session = newValue[key]
            } else {
                eval('"' + String(key) + '"') = newValue[key];
                // eval(String('"' + String(key) + '=' + String(newValue[key]) + '"'));
            };
        });
    };
    value = newValue;
}
module.exports.setValue = setValue; // 使用「module.exports」接口對象，用來導出模塊中的成員;
// console.log(webPath);
// console.log(Key);
// console.log(Session);



// // 用戶端（前端）http_Client() 使用説明;
// // 控制臺命令行使用:
// // C:\>C:\StatisticalServer\NodeJS\nodejs-14.4.0\node.exe C:/StatisticalServer/StatisticalServerJavaScript/StatisticalAlgorithmServer.js

// // 配置預設值;
// let interface_Function = Interface_http_Server;  // Interface_file_Monitor or Interface_http_Server or Interface_http_Client;
// let interface_Function_name_str = "Interface_http_Server";  // "Interface_file_Monitor" or "Interface_http_Server" or "Interface_http_Client";
// let do_Function_name_str_data = "do_Request";  // "do_data" or "do_Request" or "do_Response";

// // 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
// let is_monitor = true;  // Boolean;
// // let is_Monitor_Concurrent = "";  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
// let monitor_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "Intermediary"));  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let monitor_file = String(require('path').join(String(monitor_dir), "intermediary_write_C.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_C.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
// let output_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸出傳值的媒介目錄 "../temp/";
// let output_file = String(require('path').join(String(output_dir), "intermediary_write_Nodejs.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_Nodejs.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
// let temp_NodeJS_cache_IO_data_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "temp"));  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
// let to_executable = "";  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\Python\\Python39\\python.exe";
// let to_script = "";  // 用於對返回數據執行功能的被調用的脚本文檔 "../py/test.py";
// let delay = parseInt(100);  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay)，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
// let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
// let do_Function = do_data;  // function (argument) { return argument; };  // 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
// let Worker_threads_Script_path = "";  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let Worker_threads_eval_value = null;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });

// // 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
// let host = "::0";  // "::0", "::1", "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 10001;  // 1 ~ 65535 監聽端口;
// let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// // let webPath = String(require('path').join(String(__dirname), "html"));
// let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// // console.log(number_cluster_Workers);
// let Key = "username:password";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// let Session = {
//     "request_Key->username:password": Key
// };
// let do_Request = do_Request_Router;  // function (argument) { return argument; };  // 用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// let do_Function_JSON = {
//     "do_Request": do_Request.toString(),  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// };
// let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
// let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
// let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
// let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
// let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。

// // 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
// let Host = "localhost";
// let Port = "8000";
// let URL = "/"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = "username:password";
// let request_Cookie = "Session_ID=request_Key->username:password";
// // request_Cookie = request_Cookie.split("=")[0].concat("=", new Base64().encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
// request_Cookie = request_Cookie.split("=")[0].concat("=", Base64.encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
// // let filePath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));
// let do_Response = do_Response_Router;  // function (argument) { return argument; };  // 用於接收執行處理響應值（response）處理功能的函數 "do_Response_Router";
// do_Function_JSON["do_Response"] = do_Response.toString();  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Response_Router";

// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // let nowDate = new Date();
// // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
// // let argument = "How_are_you_!";
// // let post_Data_JSON = {
// //     "Client_say": argument.replace(new RegExp("\\_", "g"), " "),
// //     "time": String(now_date)
// // };
// // let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
// let post_Data_String = '{"Client_say":"Node.js-19.8.1 http.request()."}';


// // 用於輸入運行參數的配置文檔路徑全名;
// let configFile = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__filename)))), "config.txt"));  // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
// // let configFile = String(String(require('path').join(String(require('path').dirname(require('path').dirname(String(__filename)))), "config.txt")).replace("\\", "/"));  // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
// // console.log(configFile);
// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     if (process.argv[i].split("=")[0] === "configFile") {
//                         configFile = String(process.argv[i].split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
//                         // console.log("Config file: " + configFile);
//                         break;
//                     };
//                     // switch (process.argv[i].split("=")[0]) {
//                     //     case "configFile": {
//                     //         configFile = String(process.argv[i].split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
//                     //         // console.log("Config file: " + configFile);
//                     //         break;
//                     //     }
//                     //     default: {
//                     //         // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //         break;
//                     //     }
//                     // };
//                 };
//             };
//         };
//     };
// };

// // 讀取配置文檔（config.txt）裏的參數;
// // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
// // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt";
// if (Object.prototype.toString.call(configFile).toLowerCase() === '[object string]' && configFile !== "") {

//     // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
//     let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//     try {
//         // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
//         file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile();
//         // console.log("文檔: " + configFile + " 存在.");
//     } catch (error) {
//         console.error("Config file = [ " + String(configFile) + " ] unrecognized.");
//         // console.error("無法確定用於輸入運行參數的配置文檔: " + configFile + " 是否存在.");
//         console.error(error);
//         // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//         // return configFile;
//     };
//     // 同步判斷，當用於輸入運行參數的配置文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
//     if (!file_bool) {
//         console.log("Config file = [ " + String(configFile) + " ] absent.");
//         // console.log("用於輸入運行參數的配置文檔 " + configFile + " 不存在.");
//         // return configFile;
//     };

//     if (file_bool) {

//         // 同步判斷文檔權限，後面所有代碼都是，當用於輸入運行參數的配置文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//         try {
//             // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
//             fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
//             // console.log("文檔: " + configFile + " 可以讀寫.");
//         } catch (error) {
//             // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
//             try {
//                 // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
//                 fs.fchmodSync(configFile, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
//                 // console.log("文檔: " + configFile + " 操作權限修改為可以讀寫.");
//                 // 常量                    八進制值    說明
//                 // fs.constants.S_IRUSR    0o400      所有者可讀
//                 // fs.constants.S_IWUSR    0o200      所有者可寫
//                 // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
//                 // fs.constants.S_IRGRP    0o40       群組可讀
//                 // fs.constants.S_IWGRP    0o20       群組可寫
//                 // fs.constants.S_IXGRP    0o10       群組可執行或搜索
//                 // fs.constants.S_IROTH    0o4        其他人可讀
//                 // fs.constants.S_IWOTH    0o2        其他人可寫
//                 // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
//                 // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
//                 // 數字	說明
//                 // 7	可讀、可寫、可執行
//                 // 6	可讀、可寫
//                 // 5	可讀、可執行
//                 // 4	唯讀
//                 // 3	可寫、可執行
//                 // 2	只寫
//                 // 1	只可執行
//                 // 0	沒有許可權
//                 // 例如，八進制值 0o765 表示：
//                 // 1) 、所有者可以讀取、寫入和執行該文檔；
//                 // 2) 、群組可以讀和寫入該文檔；
//                 // 3) 、其他人可以讀取和執行該文檔；
//                 // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
//                 // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
//             } catch (error) {
//                 console.error("Config file = [ " + String(configFile) + " ] change the permissions mode=0o777 fail.");
//                 // console.error("用於輸入運行參數的配置文檔 [ " + configFile + " ] 無法修改為可讀可寫權限.");
//                 console.error(error);
//                 // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//                 // return configFile;
//             };
//         };

//         file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//         try {
//             // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔以及是否具有可讀取權限;
//             file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile();
//             // file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile() && (fs.accessSync(configFile, fs.constants.R_OK) || fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK));
//             // console.log("文檔: " + configFile + " 存在並可讀取.");
//         } catch (error) {
//             console.error("Config file = [ " + String(configFile) + " ] unrecognized or could not be read.");
//             // console.error("無法確定用於輸入運行參數的配置文檔: " + configFile + " 是否存在或不可讀取.");
//             console.error(error);
//             // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//             // return configFile;
//         };

//         // 同步判斷，當用於輸入運行參數的配置文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
//         // if (fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile() && fs.accessSync(configFile, fs.constants.R_OK)) {
//         if (file_bool) {

//             // 同步讀取，用於輸入運行參數的配置文檔中的數據;
//             try {

//                 let lines_String = "";  // 從輸入運行參數的配置文檔中讀取到的數據字符串;
//                 lines_String = fs.readFileSync(configFile, { encoding: "utf8", flag: "r" });
//                 // lines_String = fs.readFileSync(configFile, { encoding: "utf8", flag: "r+" });
//                 // // let buffer = new Buffer(8);
//                 // let buffer_data = fs.readFileSync(configFile, { encoding: null, flag: "r+" });
//                 // data_Str = buffer_data.toString("utf-8");  // 將Buffer轉換爲String;
//                 // // buffer_data = Buffer.from(data_Str, "utf-8");  // 將String轉換爲Buffer;
//                 // console.log(lines_String);

//                 console.log("Config file = " + String(configFile));

//                 let lines = new Array();  // 從輸入運行參數的配置文檔中讀取到的每一個橫向列的數據字符串組成的數組;
//                 if (Object.prototype.toString.call(lines_String).toLowerCase() === '[object string]' && lines_String !== "") {
//                     // 判斷字符串是否包含換行符號（\r\n）;
//                     if (lines_String.includes("\r\n")) {
//                         lines = lines_String.split("\r\n");  // 刪除行尾的換行符（\r\n）;
//                     } else if (lines_String.includes("\r")) {
//                         lines = lines_String.split("\r");  // 刪除行尾的換行符（\r）;
//                     } else if (lines_String.includes("\n")) {
//                         lines = lines_String.split("\n");  // 刪除行尾的換行符（\n）;
//                     } else {
//                         lines.push(lines_String);
//                         // lines.push(String(lines_String.trim()));
//                     };
//                 };

//                 if (lines.length > 0) {
//                     let line_I = parseInt(0);
//                     for (let i = 0; i < lines.length; i++) {
//                         // console.log(lines[i]);
//                         let line = String(lines[i].trim());  // 刪除行首尾的空格字符（' '）;

//                         line_I = parseInt(line_I) + parseInt(1);
//                         let line_Key = "";
//                         let line_Value = "";

//                         if (Object.prototype.toString.call(line).toLowerCase() === '[object string]' && line !== "") {

//                             // 判斷字符串是否含有等號字符（=）連接符（Key=Value），若含有等號字符（=），則以等號字符（=）分割字符串;
//                             if (line.indexOf("=", 0) !== -1) {
//                                 if (Object.prototype.toString.call(line.split("=")[0]).toLowerCase() === '[object string]' && line.split("=")[0] !== "") {
//                                     line_Key = String(line.split("=")[0].trim());  // 刪除字符串首尾的空格字符（' '）;
//                                 };
//                                 if (Object.prototype.toString.call(line.split("=")[1]).toLowerCase() === '[object string]' && line.split("=")[1] !== "") {
//                                     line_Value = String(line.split("=")[1].trim());  // 刪除字符串首尾的空格字符（' '）;
//                                 };
//                                 // if (eval('typeof (' + line.split("=")[0] + ')' + ' === undefined && ' + line.split("=")[0] + ' === undefined')) {
//                                 //     // eval('var ' + line.split("=")[0] + ' = "";');
//                                 // } else {
//                                 //     // try {
//                                 //     //     if (line.split("=")[0] !== "do_Request" && line.split("=")[0] !== "Session" && line.split("=")[0] !== "port" && line.split("=")[0] !== "number_cluster_Workers") {
//                                 //     //         eval(line + ";");
//                                 //     //     };
//                                 //     //     if (line.split("=")[0] === "port" && line.split("=")[0] === "number_cluster_Workers") {
//                                 //     //         // CheckString(line.split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                                 //     //         eval(line.split("=")[0]) = parseInt(line.split('=')[1]);
//                                 //     //     };
//                                 //     //     if (line.split("=")[0] === "Session") {
//                                 //     //         if (isStringJSON(line.split('=')[1])) {
//                                 //     //             eval(line.split("=")[0]) = JSON.parse(line.split('=')[1]);
//                                 //     //         } else if (line.split('=')[1].indexOf(":", 0) !== -1) {
//                                 //     //             eval(line.split("=")[0])[line.split('=')[1].split(":")[0]] = line.split('=')[1].split(":")[1];
//                                 //     //         } else {
//                                 //     //             eval(line + ";");
//                                 //     //         };
//                                 //     //     };
//                                 //     //     if (line.split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(line.split("=")[0]) = eval(line.split('=')[1])).toLowerCase() === '[object function]') {
//                                 //     //         eval(line.split("=")[0]) = eval(line.split('=')[1]);
//                                 //     //     } else {
//                                 //     //         do_Request = null;
//                                 //     //     };
//                                 //     //     console.log(line.split("=")[0].concat(" = ", eval(line.split("=")[0])));
//                                 //     // } catch (error) {
//                                 //     //     console.log("Don't recognize argument [ " + line + " ].");
//                                 //     //     console.log(error);
//                                 //     // };
//                                 //     switch (line.split("=")[0]) {
//                                 //         case "configFile": {
//                                 //             configFile = String(line.split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
//                                 //             // console.log("Config file: " + configFile);
//                                 //             break;
//                                 //         }
//                                 //         default: {
//                                 //             // console.log("Don't recognize argument [ " + line + " ].");
//                                 //             break;
//                                 //         }
//                                 //     };
//                                 // };
//                             } else {
//                                 line_Value = String(line.trim());
//                             };
//                         };
//                         // console.log(line_Key);
//                         // console.log(line_Value);

//                         // switch (line_Key) {
//                         //     case "configFile": {
//                         //         configFile = String(line_Value);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/StatisticalServer/StatisticalServerJavaScript/config.txt"; // "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
//                         //         // console.log("Config file: " + configFile);
//                         //         break;
//                         //     }
//                         //     default: {
//                         //         // console.log("Don't recognize argument [ " + line + " ].");
//                         //         break;
//                         //     }
//                         // };
//                         if (line_Key === "interface_Function") {
//                             interface_Function_name_str = String(line_Value);
//                             // "function() {};" 函數對象字符串，用於接收選擇啓動服務器類型的函數 "interface_Function";
//                             if (line_Value === "file_Monitor" && Object.prototype.toString.call(interface_Function = eval("Interface_file_Monitor")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_file_Monitor;  // 使用「Interface.js」模塊中的成員「file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir)」函數, 用於建立讀取硬盤文檔接口;
//                                 // interface_Function = eval(line_Value);
//                                 do_Function_name_str_data = "do_data";
//                             } else if (line_Value === "http_Server" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Server")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_http_Server;  // 使用「Interface.js」模塊中的成員「http_Server(host, port, number_cluster_Workers, Key, Session, do_Function_JSON)」函數, 用於建立網卡http協議監聽服務器接口;
//                                 // interface_Function = eval(line_Value);
//                                 do_Function_name_str_data = "do_Request";
//                             } else if (line_Value === "http_Client" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Client")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_http_Client;  // 使用「Interface.js」模塊中的成員「http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_JSON, callback)」函數, 用於建立網卡http協議客戶端請求接口;
//                                 // interface_Function = eval(line_Value);
//                                 do_Function_name_str_data = "do_Response";
//                             } else {
//                                 // interface_Function = eval(line_Value);
//                                 interface_Function = null;
//                                 do_Function_name_str_data = "";
//                             };
//                             // console.log("interface Function: " + interface_Function_name_str);
//                             continue;
//                         };
//                         // 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
//                         if (line_Key === "is_monitor") {
//                             is_monitor = String(line_Value);  // "true" or "false";
//                             // is_monitor = Boolean(line_Value);  // 使用 Boolean() 將字符串類型(String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 true or false";
//                             // console.log("Is monitor: " + String(is_monitor));
//                             continue;
//                         };
//                         if (line_Key === "monitor_file") {
//                             monitor_file = String(line_Value);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_C.txt";
//                             // console.log("Monitor file: " + monitor_file);
//                             continue;
//                         };
//                         if (line_Key === "monitor_dir") {
//                             monitor_dir = String(line_Value);  // 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 __dirname ;
//                             // console.log("Monitor directory: " + monitor_dir);
//                             continue;
//                         };
//                         if (line_Key === "output_dir") {
//                             output_dir = String(line_Value);  // 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 __dirname ;
//                             // console.log("Output directory: " + output_dir);
//                             continue;
//                         };
//                         if (line_Key === "output_file") {
//                             output_file = String(line_Value);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Nodejs.txt";
//                             // console.log("Output file: " + output_file);
//                             continue;
//                         };
//                         if (line_Key === "temp_NodeJS_cache_IO_data_dir") {
//                             temp_NodeJS_cache_IO_data_dir = String(line_Value);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 __dirname ;
//                             // console.log("Temporary cache IO data directory: " + temp_NodeJS_cache_IO_data_dir);
//                             continue;
//                         };
//                         if (line_Key === "to_executable") {
//                             to_executable = String(line_Value);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("To executable: " + to_executable);
//                             continue;
//                         };
//                         if (line_Key === "to_script") {
//                             to_script = String(line_Value);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("To script: " + to_script);
//                             continue;
//                         };
//                         if (line_Key === "delay") {
//                             delay = parseInt(line_Value);  // delay = 500; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//                             // console.log("Delay: " + String(delay));
//                             continue;
//                         };
//                         // if (line_Key === "is_Monitor_Concurrent") {
//                         //     is_Monitor_Concurrent = String(line_Value);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//                         //     // console.log("Is monitor concurrent: " + is_Monitor_Concurrent);
//                         //     continue;
//                         // };
//                         if (line_Key === "number_Worker_threads") {
//                             // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                             number_Worker_threads = parseInt(line_Value);  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("Number worker threads: " + String(number_Worker_threads));
//                             continue;
//                         };
//                         if (line_Key === "Worker_threads_Script_path") {
//                             Worker_threads_Script_path = line_Value;  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads Script path: " + Worker_threads_Script_path);
//                             continue;
//                         };
//                         if (line_Key === "Worker_threads_eval_value") {
//                             Worker_threads_eval_value = Boolean(line_Value);  // 使用 Boolean() 將字符串類型(String)變量轉換為布爾型(Bool)的變量;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads eval value: " + String(Worker_threads_eval_value));
//                             continue;
//                         };
//                         if (line_Key === "do_Function") {
//                             // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
//                             if (Object.prototype.toString.call(do_Function = eval(String(line_Value))).toLowerCase() === '[object function]') {
//                                 do_Function = eval(line_Value);
//                                 do_Function_name_str_data = "do_data";
//                             } else {
//                                 do_Function = null;
//                                 do_Function_name_str_data = "";
//                             };
//                             // console.log("do Function: " + String(do_Function));
//                             continue;
//                         };
//                         // 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
//                         if (line_Key === "webPath") {
//                             webPath = String(line_Value);  // 用於輸入服務器的根目錄 "../";
//                             // console.log("http Server root directory: " + webPath);
//                             continue;
//                         };
//                         if (line_Key === "Key") {
//                             Key = String(line_Value);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Server UserName and PassWord: " + Key);
//                             continue;
//                         };
//                         if (line_Key === "host") {
//                             host = String(line_Value);  // "::0" or "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + host);
//                             Host = String(line_Value);  // "::1" or "127.0.0.1" or "localhost"; 請求主機域名;
//                             // console.log("Host domain name: " + Host);
//                             continue;
//                         };
//                         if (line_Key === "port") {
//                             port = parseInt(line_Value);  // 8000; 監聽端口;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
//                             // console.log("listening Port: " + port);
//                             Port = parseInt(line_Value);  // 8000; 請求端口;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
//                             // console.log("request Port: " + Port);
//                             continue;
//                         };
//                         if (line_Key === "number_cluster_Workers") {
//                             number_cluster_Workers = parseInt(line_Value);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
//                             // console.log("number cluster Workers: " + number_cluster_Workers);
//                             continue;
//                         };
//                         if (line_Key === "Session") {
//                             if (isStringJSON(line_Value)) {
//                                 Session = JSON.parse(line_Value);
//                             } else if (line_Value.indexOf(":", 0) !== -1) {
//                                 Session[line_Value.split(":")[0]] = line_Value.split(":")[1];
//                             } else {
//                                 Session = null;
//                             };
//                             // console.log("Server Session: " + Session);
//                             continue;
//                         };
//                         if (line_Key === "do_Request") {
//                             // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//                             if (Object.prototype.toString.call(do_Request = eval(line_Value)).toLowerCase() === '[object function]') {
//                                 do_Request = eval(line_Value);
//                                 do_Function_name_str_data = "do_Request";
//                             } else {
//                                 do_Request = null;
//                                 do_Function_name_str_data = "";
//                             };
//                             // console.log("do_Request: " + do_Request);
//                             continue;
//                         };
//                         // 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
//                         if (line_Key === "URL") {
//                             URL = String(line_Value);  // "/";  // "http://[::1]:8000"  // "http://usename:password@[::1]:8000/";
//                             // console.log("request uniform resource locator : " + URL);
//                             continue;
//                         };
//                         if (line_Key === "requestMethod") {
//                             Method = String(line_Value);  // "POST" , "GET";  // 請求方法;
//                             // console.log("request Method: " + Method);
//                             continue;
//                         };
//                         if (line_Key === "time_out") {
//                             time_out = parseInt(line_Value);  // time_out = 1000; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，設置鏈接超時自動中斷，單位毫秒（millisecond）;
//                             // console.log("request time out : " + String(time_out));
//                             continue;
//                         };
//                         if (line_Key === "Authorization") {
//                             request_Auth = String(line_Value);  // "username:password";  // 向服務器請求連接的驗證賬號密碼;
//                             // console.log("request Authorization: " + request_Auth);
//                             continue;
//                         };
//                         if (line_Key === "Cookie") {
//                             request_Cookie = String(line_Value);  // "Session_ID=request_Key->username:password";  // 向服務器請求連接的驗證 Cookies 值;
//                             // console.log("request Cookies: " + request_Cookie);
//                             continue;
//                         };
//                         if (line_Key === "postData") {
//                             post_Data_String = String(line_Value);  // JSON.stringify(post_Data_JSON);  // 向服務器發送 POST 請求傳送的體（Body）參數值字符串;
//                             // console.log("request post data: " + post_Data_String);
//                             continue;
//                         };
//                         if (line_Key === "do_Response") {
//                             // "function() {};" 函數對象字符串，用於接收執行響應數據（response）的函數 "do_Response";
//                             if (Object.prototype.toString.call(do_Response = eval(line_Value)).toLowerCase() === '[object function]') {
//                                 do_Response = eval(line_Value);
//                                 do_Function_name_str_data = "do_Response";
//                             } else {
//                                 do_Response = null;
//                                 do_Function_name_str_data = "";
//                             };
//                             // console.log("do Response: " + do_Response);
//                             continue;
//                         };
//                         if (line_Key === "filePath") {
//                             filePath = String(line_Value);  // "C:\Criss\js\"; 響應數據輸出寫入文檔;
//                             // console.log("http Client Write file : " + filePath);
//                             continue;
//                         };
//                     };
//                 };

//             } catch (error) {
//                 console.log("Config file = [ " + String(configFile) + " ] could not be read.");
//                 // console.error("用於輸入運行參數的配置文檔: " + configFile + " 無法讀取.");
//                 console.error(error);
//                 // return configFile;
//             };
//         };

//         // let now_date = String(new Date().toLocaleString('chinese', { hour12: false }));
//         // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
//         // console.log(now_date);
//     };
//     file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
//     file_bool = null;  // 釋放内存;
// };

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "interface_Function": {
//                             Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Server UserName and PassWord: " + Key);
//                             interface_Function_name_str = String(process.argv[i].split("=")[1]);
//                             // "function() {};" 函數對象字符串，用於接收選擇啓動服務器類型的函數 "interface_Function";
//                             if (process.argv[i].split("=")[1] === "file_Monitor" && Object.prototype.toString.call(interface_Function = eval("Interface_file_Monitor")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_file_Monitor;  // 使用「Interface.js」模塊中的成員「file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir)」函數, 用於建立讀取硬盤文檔接口;
//                                 // interface_Function = eval(process.argv[i].split("=")[1]);
//                                 do_Function_name_str_data = "do_data";
//                             } else if (process.argv[i].split("=")[1] === "http_Server" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Server")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_http_Server;  // 使用「Interface.js」模塊中的成員「http_Server(host, port, number_cluster_Workers, Key, Session, do_Function_JSON)」函數, 用於建立網卡http協議監聽服務器接口;
//                                 // interface_Function = eval(process.argv[i].split("=")[1]);
//                                 do_Function_name_str_data = "do_Request";
//                             } else if (process.argv[i].split("=")[1] === "http_Client" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Client")).toLowerCase() === '[object function]') {
//                                 interface_Function = Interface_http_Client;  // 使用「Interface.js」模塊中的成員「http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_JSON, callback)」函數, 用於建立網卡http協議客戶端請求接口;
//                                 // interface_Function = eval(process.argv[i].split("=")[1]);
//                                 do_Function_name_str_data = "do_Response";
//                             } else {
//                                 // interface_Function = eval(process.argv[i].split("=")[1]);
//                                 interface_Function = null;
//                                 do_Function_name_str_data = "";
//                             };
//                             // console.log("interface Function: " + interface_Function_name_str);
//                             break;
//                         }
//                         // 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
//                         case "monitor_file": {
//                             monitor_file = String(process.argv[i].split("=")[1]);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("monitor file: " + monitor_file);
//                             break;
//                         }
//                         case "monitor_dir": {
//                             monitor_dir = String(process.argv[i].split("=")[1]);  // 用於輸入傳值的媒介目錄 "../temp/";
//                             // console.log("monitor dir: " + monitor_dir);
//                             break;
//                         }
//                         case "do_Function": {
//                             // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
//                             if (Object.prototype.toString.call(do_Function = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Function = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Function = null;
//                             };
//                             // console.log("do Function: " + do_Function);
//                             break;
//                         }
//                         case "output_dir": {
//                             output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                             // console.log("output dir: " + output_dir);
//                             break;
//                         }
//                         case "output_file": {
//                             output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("output file: " + output_file);
//                             break;
//                         }
//                         case "to_executable": {
//                             to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("to executable: " + to_executable);
//                             break;
//                         }
//                         case "to_script": {
//                             to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("to script: " + to_script);
//                             break;
//                         }
//                         case "temp_NodeJS_cache_IO_data_dir": {
//                             temp_NodeJS_cache_IO_data_dir = String(process.argv[i].split("=")[1]);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
//                             // console.log("temp NodeJS cache Input/Output data dir: " + temp_NodeJS_cache_IO_data_dir);
//                             break;
//                         }
//                         case "delay": {
//                             delay = parseInt(process.argv[i].split("=")[1]);  // delay = 500;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//                             // console.log("delay: " + delay);
//                             break;
//                         }
//                         // case "is_Monitor_Concurrent": {
//                         //     is_Monitor_Concurrent = String(process.argv[i].split("=")[1]);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//                         //     // console.log("is_Monitor_Concurrent: " + number_Worker_threads);
//                         //     break;
//                         // }
//                         case "number_Worker_threads": {
//                             CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                             number_Worker_threads = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number_Worker_threads: " + number_Worker_threads);
//                             break;
//                         }
//                         case "Worker_threads_Script_path": {
//                             Worker_threads_Script_path = process.argv[i].split("=")[1];  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads Script path: " + Worker_threads_Script_path);
//                             break;
//                         }
//                         case "Worker_threads_eval_value": {
//                             Worker_threads_eval_value = Boolean(process.argv[i].split("=")[1]);  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads eval value: " + Worker_threads_eval_value);
//                             break;
//                         }
//                         // 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
//                         case "Key": {
//                             Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Server UserName and PassWord: " + Key);
//                             break;
//                         }
//                         case "host": {
//                             host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + host);
//                             Host = String(process.argv[i].split("=")[1]);  // "::1" or "127.0.0.1" or "localhost"; 請求主機域名;
//                             // console.log("Host domain name: " + Host);
//                             break;
//                         }
//                         case "port": {
//                             port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // console.log("listening Port: " + port);
//                             Port = parseInt(process.argv[i].split("=")[1]);  // 8000; 請求端口;
//                             // console.log("request Port: " + Port);
//                             break;
//                         }
//                         case "webPath": {
//                             webPath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 監聽端口;
//                             // console.log("http Server root directory: " + webPath);
//                             break;
//                         }
//                         case "number_cluster_Workers": {
//                             number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number cluster Workers: " + number_cluster_Workers);
//                             break;
//                         }
//                         case "Session": {
//                             if (isStringJSON(process.argv[i].split('=')[1])) {
//                                 Session = JSON.parse(process.argv[i].split('=')[1]);
//                             } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                                 Session[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                             } else {
//                                 Session = null;
//                             };
//                             // console.log("Server Session: " + Session);
//                             break;
//                         }
//                         case "do_Request": {
//                             // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//                             if (Object.prototype.toString.call(do_Request = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Request = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Request = null;
//                             };
//                             // console.log("do_Request: " + do_Request);
//                             break;
//                         }
//                         // 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
//                         case "URL": {
//                             URL = String(process.argv[i].split("=")[1]);  // "/";  // "http://[::1]:8000"  // "http://usename:password@[::1]:8000/";
//                             // console.log("request uniform resource locator : " + URL);
//                             break;
//                         }
//                         case "requestMethod": {
//                             Method = String(process.argv[i].split("=")[1]);  // "POST" , "GET";  // 請求方法;
//                             // console.log("request Method: " + Method);
//                             break;
//                         }
//                         case "Authorization": {
//                             request_Auth = String(process.argv[i].split("=")[1]);  // "username:password";  // 向服務器請求連接的驗證賬號密碼;
//                             // console.log("request Authorization: " + request_Auth);
//                             break;
//                         }
//                         case "Cookie": {
//                             request_Cookie = String(process.argv[i].split("=")[1]);  // "Session_ID=request_Key->username:password";  // 向服務器請求連接的驗證 Cookies 值;
//                             // console.log("request Cookies: " + request_Cookie);
//                             break;
//                         }
//                         case "postData": {
//                             post_Data_String = String(process.argv[i].split("=")[1]);  // JSON.stringify(post_Data_JSON);  // 向服務器發送 POST 請求傳送的體（Body）參數值字符串;
//                             // console.log("request post data: " + post_Data_String);
//                             break;
//                         }
//                         case "time_out": {
//                             time_out = parseInt(process.argv[i].split("=")[1]);  // time_out = 1000; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，設置鏈接超時自動中斷，單位毫秒（millisecond）;
//                             // console.log("request time out : " + String(time_out));
//                             break;
//                         }
//                         case "do_Response": {
//                             // "function() {};" 函數對象字符串，用於接收執行響應數據（response）的函數 "do_Response";
//                             if (Object.prototype.toString.call(do_Response = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Response = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Response = null;
//                             };
//                             // console.log("do Response: " + do_Response);
//                             break;
//                         }
//                         case "filePath": {
//                             filePath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 響應數據輸出寫入文檔;
//                             // console.log("http Client Write file : " + filePath);
//                             break;
//                         }
//                         default: {
//                             // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// let result_Array = new Array();
// if (interface_Function_name_str === "Interface_file_Monitor") {
//     // 硬盤文檔監聽函數 file_Monitor() 使用説明;
//     // file_Monitor(is_monitor, monitor_file, monitor_dir, do_Function_obj, return_obj, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir);
//     if (require('worker_threads').isMainThread) {
//         // const child_process = require('child_process');  // Node原生的創建子進程模組;
//         // const os = require('os');  // Node原生的操作系統信息模組;
//         // const net = require('net');  // Node原生的網卡網絡操作模組;
//         // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//         // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//         // const qs = require('querystring');
//         // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
//         // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
//         // const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
//         // const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
//         // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
//         // const cluster = require('cluster');  // Node原生的支持多進程模組;
//         // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
//         // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;

//         // // 可以先改變工作目錄到 static 路徑;
//         // console.log('Starting directory: ' + process.cwd());
//         // try {
//         //     process.chdir('D:\\tmp\\');
//         //     console.log('New directory: ' + process.cwd());
//         // } catch (error) {
//         //     console.log('chdir: ' + error);
//         // };

//         // // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
//         // try {
//         //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
//         // } catch (error) {
//         //     console.log(error);
//         // };

//         // let monitor_dir = require('path').join(require('path').resolve(".."), "Intermediary");  //require('path').resolve("..").toString().concat("/temp/")，"D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//         // let monitor_file = require('path').join(monitor_dir, "intermediary_write_Python.txt");  // "../temp/intermediary_write_Python.txt" 用於接收傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//         // let do_Function = do_data;  // 用於接收執行功能的函數;
//         // let output_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // "D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//         // let output_file = require('path').join(output_dir, "intermediary_write_Node.txt");  // "../temp/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//         // let to_executable = require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // require('path').resolve("..").toString().concat("/Python/", "python39/python.exe")，"../Python/python39/python.exe"，path.resolve("../Python/python39/python.exe") 轉換爲絕對路徑;
//         // let to_script = require('path').join(require('path').resolve(".."), "js", "test.js");  // require('path').resolve("..").toString().concat("/js/", "test.js")，"../js/test.js"，path.resolve("../js/test.js") 轉換爲絕對路徑;
//         // let do_Function_obj = {
//         //     "do_Function": do_Function  // 用於接收執行功能的函數;
//         // };
//         // let return_obj = {
//         //     "output_dir": output_dir,  // 需要注意目錄操作權限 "./temp/" 用於傳值的媒介目錄;
//         //     "output_file": output_file,  // "./temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
//         //     "to_executable": to_executable,  // 用於對返回數據執行功能的解釋器可執行文件;
//         //     "to_script": to_script  // "./js/test.js" 用於執行功能的被調用的脚步文檔;
//         // };
//         // let is_monitor = true;  // 用於判斷只運行一次，還是保持文檔監聽;
//         // let delay = 50;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//         // let number_Worker_threads = 1;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//         // let Worker_threads_Script_path = "";  // process.argv[1]; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值;
//         // let Worker_threads_eval_value = "";  // true; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值;
//         // let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // "C:\\Users\\china\\AppData\\Local\\Temp\\temp_NodeJS_cache_IO_data\\" 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
//         // // let temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
//         // // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
//         // // console.log(temp_NodeJS_cache_IO_data_dir);
    
//         result_Array = interface_Function({
//             "is_monitor": is_monitor,
//             "monitor_file": monitor_file,
//             "monitor_dir": monitor_dir,
//             // "do_Function_obj": do_Function_obj,
//             "do_Function": do_Function,
//             // "return_obj": return_obj,
//             "output_dir": output_dir,
//             "output_file": output_file,
//             "to_executable": to_executable,
//             "to_script": to_script,
//             "delay": delay,
//             "number_Worker_threads": number_Worker_threads,
//             "Worker_threads_Script_path": Worker_threads_Script_path,
//             "Worker_threads_eval_value": Worker_threads_eval_value,
//             "temp_NodeJS_cache_IO_data_dir": temp_NodeJS_cache_IO_data_dir
//         });
//         // result_Array = interface_Function({
//         //     "is_monitor": is_monitor,
//         //     "monitor_file": monitor_file,
//         //     "do_Function": do_Function,
//         //     "output_file": output_file,
//         // });
//     };
// } else if (interface_Function_name_str === "Interface_http_Server") {
//     result_Array = interface_Function({
//         "host": host,
//         "port": port,
//         "number_cluster_Workers": number_cluster_Workers,
//         "Key": Key,
//         "Session": Session,
//         // "do_Function_JSON": do_Function_JSON,
//         "do_Request": do_Request,
//         "exclusive": exclusive,
//         "backlog": backlog,
//         "readableAll": readableAll,
//         "writableAll": writableAll,
//         "ipv6Only": ipv6Only
//     });
//     // result_Array = interface_Function({
//     //     "do_Request": do_Request,
//     //     "Session": Session,
//     //     "Key": Key,
//     //     "number_cluster_Workers": number_cluster_Workers,
//     // });
// } else if (interface_Function_name_str === "Interface_http_Client") {
//     interface_Function({
//         "Host": Host,
//         "Port": Port,
//         "URL": URL,
//         "Method": Method,
//         "time_out": time_out,
//         "request_Auth": request_Auth,
//         "request_Cookie": request_Cookie,
//         "post_Data_String": post_Data_String
//         // "do_Response": do_Response,
//     }, (error, response) => {
//         // console.log(response);
    
//         // let response_status_String = response[0];
//         // console.log(response_status_String);
//         // let response_head_String = response[1];
//         // console.log(response_head_String);
    
//         // let response_body_String = response[2];
//         // console.log(response_body_String);
//         // // // response_body_String = {
//         // // //     "request Nikename": request_Nikename,
//         // // //     "request Passwork": request_Password,
//         // // //     "request_Authorization": Key,  // "username:password";
//         // // //     "Server_say": "Fine, thank you, and you ?",
//         // // //     "time": "2021-02-03 20:21:25.136"
//         // // // };
    
//         // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//         // let data_JSON = {};
//         // if (isStringJSON(response_body_String)) {
//         //     data_JSON = JSON.parse(response_body_String);
//         // } else {
//         //     data_JSON = {
//         //         "Server_say": response_body_String
//         //     };
//         // };
    
//         // console.log("Server say: " + data_JSON["Server_say"]);

//         if (error !== null) {console.log(error);};
//         if (response !== null) {
//             do_Response(response[0], response[1], response[2], (err, response_data) => {
//                 // console.log(response_data);
//             });
//         };
//     });
// } else {};
// // console.log(typeof(result_Array));  // Array;
// // console.log(result_Array[0]);

// // // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // // let nowDate = new Date();
// // // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// // // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
// let return_file_creat_time = String(now_date);

// let result_text = "";
// if (interface_Function_name_str === "Interface_file_Monitor") {

//     if (is_monitor === true || is_monitor === "true" || is_monitor === "True" || is_monitor === "TRUE") {
//         result_text = "code:0";
//     };

//     if (is_monitor === false || is_monitor === "false" || is_monitor === "False" || is_monitor === "FALSE") {
//         if (Object.prototype.toString.call(result_Array).toLowerCase() === '[object array]' && result_Array.length === 3 && Object.prototype.toString.call(result_Array[1]).toLowerCase() === '[object string]' && Object.prototype.toString.call(result_Array[2]).toLowerCase() === '[object string]' && Object.prototype.toString.call(do_Function_name_str_data).toLowerCase() === '[object string]' && do_Function_name_str_data !== "") {
//             let return_info_JSON = {
//                 "Nodejs_say": {
//                     "output_file": String(result_Array[1]),
//                     "monitor_file": String(result_Array[2]),
//                     "do_Function": String(do_Function_name_str_data)
//                 },
//                 "time": String(return_file_creat_time)
//             };  // '{"Nodejs_say":{"output_file":"' + String(result_Array[1]) + '","monitor_file":"' + String(result_Array[2]) + '","do_Function":""},"time":"' + String(return_file_creat_time) + '"}'
//             result_text = ['code:0', JSON.stringify(return_info_JSON)].join("\n");  // JSON.parse(JSON_str);
//         } else if (Object.prototype.toString.call(result_Array).toLowerCase() === '[object array]' && result_Array.length === 3 && Object.prototype.toString.call(result_Array[1]).toLowerCase() === '[object string]' && Object.prototype.toString.call(result_Array[2]).toLowerCase() === '[object string]') {
//             let return_info_JSON = {
//                 "Nodejs_say": {
//                     "output_file": String(result_Array[1]),
//                     "monitor_file": String(result_Array[2]),
//                     "do_Function": String(do_Function_name_str_data)
//                 },
//                 "time": String(return_file_creat_time)
//             };  // '{"Nodejs_say":{"output_file":"' + String(result_Array[1]) + '","monitor_file":"' + String(result_Array[2]) + '","do_Function":""},"time":"' + String(return_file_creat_time) + '"}'
//             result_text = ['code:0', JSON.stringify(return_info_JSON)].join("\n");  // JSON.parse(JSON_str);
//         } else {
//             result_text = "code:-1";
//         };
//     };

// } else if (interface_Function_name_str === "Interface_http_Server") {
//     result_text = "code:0";
// } else if (interface_Function_name_str === "Interface_http_Client") {
//     result_text = "code:0";
// } else {};

// // 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
// console.log(result_text);  // 將運算結果寫到操作系統控制臺;


// // process.exit(0); // 停止運行，退出 Node.js 解釋器;













//console.log(`${OS.platform()},${OS.hostname()},${IP.address()}`); //查看服務器系統信息用於調試;

// // 控制臺傳參檢查埠號（port）是否已經被占用，控制臺傳參，其中「port」為需要檢測的端口號，運行方式示例：node PortIsOccupied 80;
// if (typeof (process.argv[2]) === 'undefined') {
//     console.log('端口參數未輸入，請正確輸入待測試端口號.');
// } else if (!CheckString(process.argv[2], 'arabic_numerals') || Number(process.argv[2]) >= 65535 || Number(process.argv[2]) <= 0) {
//     console.log(`端口參數「${process.argv[2]}」類型輸入錯誤，請正確輸入「1 ~ 65535」的數字端口進行測試.`);
// } else {
//     let port = Number(parseInt(process.argv[2]));
//     //console.log(port);
//     const Server = net.createServer().listen(port);
//     function PortIsOccupied(port) {
//         Server.on('listening', function () {
//             Server.close(); // 關閉服務;
//             console.log(`端口「${port}」可以使用.`);
//         });
//         Server.on('error', function (error) {
//             if (error.code === 'EADDRINUSE') {
//                 // 端口已被占用
//                 console.log(`端口「${port}」已經被占用，請更換端口重試.`);
//             } else {
//                 console.log(JSON.stringify(error));
//             };
//         });
//     };

//     // 執行
//     PortIsOccupied(port);
// };


// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     try {
//                         if (isStringJSON(process.argv[i].split('=')[1])) {
//                             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                         } else {
//                             eval(process.argv[i] + ";");
//                             // // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                             // eval(process.argv[i].split("=")[0] = process.argv[i].split('=')[1]);
//                         };
//                         console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     } catch (error) {
//                         console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                         console.log(error);
//                     };
//                 };
//             };
//         };
//     };
// };




// // 調用 R 語言使用示例，自定義類 File_Monitor 硬盤文檔監聽看守進程使用説明;
// // 配置預設值;
// monitor_Function = "File_Monitor";
// is_monitor = "FALSE";  // 預設不啓動看守進程監聽功能，只運行一輪就退出函數;
// monitor_dir = "";  // "D:\\temp\\"，"../Intermediary/" 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
// monitor_file = "";  // "D:\\temp\\intermediary_write_Node.txt"，"../Intermediary/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
// do_Function = "do_data";  // 用於接收執行功能的函數;
// output_dir = "";  // "D:\\temp\\"，"../Intermediary/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
// output_file = "";  // "D:\\temp\\intermediary_write_Node.txt"，"../Intermediary/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔;
// to_executable = "";  // "../NodeJS/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
// to_script = "";  // "../js/test.js" 用於對返回數據執行功能的被調用的脚本文檔;
// temp_cache_IO_data_dir = "";  // "D:\\temp\\"，"../Intermediary/"，tempdir() 函數返回操作系統的臨時文件夾，需要注意目錄操作權限，用於暫存輸入輸出傳值的媒介目錄;
// number_Worker_process = "0";  // 子進程數目默認 0 個，detectCores(logical = FALSE) # 獲取計算機實際物理處理器(cpu)數目;
// Sys_sleep = "0.2";  // 預設延遲等待時長為 0.2 秒;

// S00 = '../r/Interface.r';
// S01 = 'monitor_Function'.concat("=", String(monitor_Function));
// S02 = 'is_monitor'.concat("=", String(is_monitor));
// S03 = 'do_Function'.concat("=", String(do_Function));
// S04 = 'monitor_dir'.concat("=", String(monitor_dir));
// S05 = 'monitor_file'.concat("=", String(monitor_file));
// S06 = 'output_dir'.concat("=", String(output_dir));
// S07 = 'output_file'.concat("=", String(output_file));
// S08 = 'temp_cache_IO_data_dir'.concat("=", String(temp_cache_IO_data_dir));
// S09 = 'to_executable'.concat("=", String(to_executable));
// S10 = 'to_script'.concat("=", String(to_script));
// S11 = 'number_Worker_process'.concat("=", String(number_Worker_process));
// S12 = 'Sys_sleep'.concat("=", String(Sys_sleep));
// shell_child_process_exec_text = ["Rscript", S00, S01, S02, S03, S04, S05, S06, S07, S08, S09, S10, S11, S12].join(" ");
// // shell_child_process_exec_text === 'Rscript ../r/Interface.r monitor_Function=File_Monitor is_monitor=FALSE do_Function=do_data monitor_dir=../temp/ monitor_file=../temp/intermediary_write_Node.txt output_dir=../temp/ output_file=../temp/intermediary_write_R.txt temp_cache_IO_data_dir=../temp/ to_executable=../NodeJS/node.exe to_script=../js/Router.js number_Worker_process=0 Sys_sleep=0.2'

// // // 同步運行;
// // let result = require('child_process').execSync(shell_child_process_exec_text, {
// //     maxBuffer: 200 * 1024,
// //     stdio: [0, 1, 2]
// // });
// // // console.log(typeof(result));
// // let response_JSON = null;
// // // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// // if (isStringJSON(result)) {
// //     response_JSON = JSON.parse(result);
// // } else {
// //     response_JSON = {
// //         "Server_say": result
// //     };
// // };
// // // console.log("Server say: " + response_JSON["Server_say"]);
// // 異步運行;
// require('child_process').exec(shell_child_process_exec_text, {

//     maxBuffer: 200 * 1024  // quick fix;

// }, function (error, stdout, stderr) {
//     if (error) {
//         console.log(`EXEC Error: ${error}`);
//         // return;
//     };

//     if (stderr) {
//         console.error(`stderr: ${stderr}`);
//     };

//     // console.log("stdout:");
//     // console.log(typeof (stdout));
//     // console.log(stdout);
//     // console.log(JSON.parse(stdout));

//     let response_JSON = null;
//     if (stdout) {

//         stdout.setEncoding('utf8');

//         stdout.on('data', function (chunk) {
//             list.push(chunk);
//         });

//         stdout.on('end', function () {
//             // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
//             if (isStringJSON(stdout)) {
//                 response_JSON = JSON.parse(stdout);
//             } else {
//                 response_JSON = {
//                     "Python_say": stdout
//                 };
//             };
//             console.log("Python say: " + response_JSON["Python_say"]);
//         });

//         // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
//         if (isStringJSON(stdout)) {
//             response_JSON = JSON.parse(stdout);
//         } else {
//             response_JSON = {
//                 "Python_say": stdout
//             };
//         };
//         console.log("Python say: " + response_JSON["Python_say"]);
//     };

// });
// console.log(result[result.length() - 1]);
// console.log(result[result.length()]);




// // child_Process;
// // 這裏是需要向Python服務器發送的參數數據JSON對象，注意不能有空格因爲控制臺shell語句使用空格區分參數，如果需要帶空格的參數，可以先使用其它符號分隔連接傳入參數，等參數傳入之後然後再將分隔符替換為空格，不要傳遞使用漢字等非ACSII碼字符;
// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // console.log(now_date);
// let argument = "How_are_you_!";
// console.log("Client say: " + argument.replace(new RegExp("_", "g"), " "));
// // let post_Data_JSON = {
// //     "Client_say": "How_are_you_!",
// //     "time": "2021-1-17-1-55-2-75" // time = new Date().toLocaleString('chinese', { hour12: false });
// // };
// let post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + now_date + '\\"}'; // change the javascriptobject to jsonstring;
// // let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
// // let arg1 = 'hello';
// // let arg2 = 'world.';
// // let post_Data_String = qs.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;

// let to_executable = 'C:\\Python\\python39\\python.exe';
// let to_script = 'C:\\Users\\china\\Documents\\Node.js\\Python4Node.py';
// let shell_run_to_executable = to_executable.concat(" ", to_script, " ", post_Data_String);
// // 同步運行;
// let result = require('child_process').execSync(shell_run_to_executable, { stdio: [0, 1, 2] });
// // console.log(typeof(result));
// let response_JSON = null;
// // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// if (isStringJSON(result)) {
//     response_JSON = JSON.parse(result);
// } else {
//     response_JSON = {
//         "Server_say": result
//     };
// };
// console.log("Server say: " + response_JSON["Server_say"]);
// // 異步運行;
// // child_process.exec(shell_run_to_executable, function (error, stdout, stderr) {
// //     if (error) {
// //         console.log(`EXEC Error: ${error}`);
// //         // return;
// //     };

// //     if (stderr) {
// //         console.error(`stderr: ${stderr}`);
// //     };

// //     // console.log("stdout:");
// //     // console.log(typeof (stdout));
// //     // console.log(stdout);
// //     // console.log(JSON.parse(stdout));

// //     let response_JSON = null;
// //     if (stdout) {
// //         // 自定義函數判斷子進程 Python 程序返回值 stdout 是否為一個 JSON 格式的字符串;
// //         if (isStringJSON(stdout)) {
// //             response_JSON = JSON.parse(stdout);
// //         } else {
// //             response_JSON = {
// //                 "Python_say": stdout
// //             };
// //         };
// //         console.log("Python say: " + response_JSON["Python_say"]);
// //     };

// // });
// // // child_process.exec("CHCP") === "Active code page: 65001" || exec("CHCP") === "活动代码页: 936"
