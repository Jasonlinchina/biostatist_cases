#!/usr/bin/env python3
#coding = UTF-8

import os
import numpy as np
import pandas as pd

path = '.'
file_names = os.listdir(path)
fn_list = []
for file_name in file_names:
    if file_name.endswith('.FGD4.survival.txt'):
        fn_list.append(file_name)

for fn in fn_list:
    cancer = fn.strip().split('.')[0]
    df = pd.read_table(fn, header = 0, index_col = 0)
    df.sort_values(by = ['FPKM_FGD4'], ascending = False, inplace = True)
# in order to meet with the paper, the number of high FGD4 is changed to 135, and the number of low FGD4 is changed to 136. 
    df.insert(df.shape[1], 'type', 
        np.hstack((np.full(int(df.shape[0] * 0.33), 1), np.full(df.shape[0] - 2* int(df.shape[0] * 0.33), ''), np.full(int(df.shape[0] * 0.33), 2))))
#    df.insert(df.shape[1], 'type',
#       np.hstack((np.full(int(df.shape[0] * 0.5), 1), np.full(df.shape[0] - int(df.shape[0] * 0.5), 2))))
    df.to_csv('.'.join([cancer, 'FGD4.survival.rank.txt']), sep = '\t')    
