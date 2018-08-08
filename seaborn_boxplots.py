import numpy as np 
import matplotlib as mpl
mpl.use('Agg') 
import matplotlib.pyplot as plt 
import pandas as pd
import seaborn as sns

for REGION in ['A','B','C','D','E','F','G','H']:
    data_file = ''.join(['path',REGION,'summary.txt'])
    data = pd.read_table(data_file, index_col = 1)
    plt.figure()
    plot = sns.boxplot(x='gci', y='ngigc', data=data)
    plot = sns.stripplot(x='gci', y='ngigc', data=data, color="gray", jitter=0.2, size=2.5)
    figure = plot.get_figure()
    path = ''.join(['path',REGION,'_python_seaborn_boxplot.png'])
    figure.savefig(path)
 
