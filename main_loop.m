%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 実験の条件と結果をエクセルファイルでデータベース化するテンプレート         %
%                                                                         %
% Coded by D. Kitamura (d-kitamura@ieee.org)                              %
%                                                                         %
% See also:                                                               %
% http://d-kitamura.net                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % ワークスペースの全変数をクリア
close all; % 全プロットフィギュアウィンドウを閉じる
clc; % コマンドラインをクリア

% 出力ディレクトリ名とエクセルファイル名
outDirName = "./output/"; % 結果を保存するディレクトリのパス
excelFileName = "result.xlsx"; % 結果を保存するエクセルファイル名
exelFilePath = outDirName + excelFileName; % エクセルファイルのパス（outDir内のexcelFileName）

% 結果保存用のテーブル変数の定義
isExcelFile = exist(exelFilePath, 'file'); % エクセルファイルが存在するかしないか判定（存在すれば2，無ければ0）
if ~isfolder(outDirName) % outDirが存在しない場合
    mkdir(outDirName); % 出力ディレクトリの作成
    resultTable = []; % 空のtable変数を定義
elseif isExcelFile ~= 2 % outDirは存在するがexcelFileNameの名前のエクセルファイルが存在しない場合
    resultTable = []; % 空のtable変数を定義
else % outDirが存在しexcelFileNameの名前のエクセルファイルも存在する場合
    resultTable = readtable(exelFilePath); % エクセルファイルを読み込んでtable変数に代入
end

% 網羅的に調査する入力データの条件やアルゴリズムのパラメータ等の設定
for cond1 = 1:5
    for cond2 = 1:5
        for param1 = 0.5:0.5:2.5
            for param2 = 0.25:0.25:1
                for param3 = ["max", "min"]
                    for seed = 1:10
                        % 乱数ストリームの初期化
                        RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed)); % seedの値を使って疑似乱数列を生成（疑似乱数はメルセンヌツイスタ）
                        
                        % 実験例
                        inputData = magic(cond1) + cond2; % 条件cond1及びcond2に従って生成した入力データ例
                        [result1, result2] = sampleExperiment(inputData,param1,param2,param3); % 実験アルゴリズムの関数例
                        
                        % データベースの更新
                        resultTable = [resultTable; table(cond1, cond2, param1, param2, param3, seed, result1, result2)]; % table変数に実行結果を1行追加し保存
                    end
                end
            end
        end
    end
end

% データベースの保存
writetable(resultTable, exelFilePath); % エクセルファイルを上書き
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%