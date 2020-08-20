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
outDirPath = "./output/"; % 結果を保存するディレクトリのパス
excelFileName = "result.xlsx"; % 結果を保存するエクセルファイル名
excelFilePath = outDirPath + excelFileName; % エクセルファイルのパス（outDir内のexcelFileName）

% 結果保存用のテーブル変数の定義
isExcelFile = exist(excelFilePath, 'file'); % エクセルファイルが存在するかしないか判定（存在すれば2，無ければ0）
if ~isfolder(outDirPath) % outDirが存在しない場合
    mkdir(outDirPath); % 出力ディレクトリの作成
    resultTable = []; % 空のtable変数を定義
elseif isExcelFile ~= 2 % outDirは存在するがexcelFileNameの名前のエクセルファイルが存在しない場合
    resultTable = []; % 空のtable変数を定義
else % outDirが存在しexcelFileNameの名前のエクセルファイルも存在する場合
    resultTable = readtable(excelFilePath); % エクセルファイルを読み込んでtable変数に代入
end

% 入力データの条件やアルゴリズムのパラメータ等の設定
cond1All = 1:5; % 条件1
cond2All = 1:5; % 条件2
param1All = 0.5:0.5:2.5; % パラメータ1
param2All = 0.25:0.25:1; % パラメータ2
param3All = ["max", "min"]; % パラメータ3
seedAll = 1:10; % 乱数シード値（アルゴリズム中で乱数を用いる場合に再現性を確保するため）

% 網羅的に調査する入力データの条件やアルゴリズムのパラメータ等の設定
for cond1 = cond1All
    for cond2 = cond2All
        for param1 = param1All
            for param2 = param2All
                for param3 = param3All
                    for seed = seedAll
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
writetable(resultTable, excelFilePath); % エクセルファイルを上書き
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%