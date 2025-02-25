import csv

# 读取文本文件内容
with open('combined_data.txt', 'r', encoding='utf-8') as file:
    lines = file.readlines()

# 提取列名（第一行数据），去除换行符并按逗号分割
headers = lines[0].strip().split(',')
data = [line.strip().split(',') for line in lines[1:]]

# 将数据写入CSV文件
with open('output.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    # 先写入列名
    writer.writerow(headers)
    # 逐行写入数据
    writer.writerows(data)