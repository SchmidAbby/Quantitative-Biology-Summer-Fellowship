# Week 2 -- data viz with python/pandas, re-implementing script from last week 

import matplotlib
matplotlib.use('Agg')
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

for CPS_REGION in ['A','B','C','D','E','F','G','H']:
    data_file = ''.join(['CP',CPS_REGION,'_NONREDUNDANT_gene_clusters_summary.txt'])
    data = pd.read_table(data_file, index_col = 1)

    data_sub = data.loc[:, ['gene_callers_id', 'genome_name', 'COG_CATEGORY', 'num_genes_in_gene_cluster']]

    data_sub.boxplot(by='gene_callers_id', column = ['num_genes_in_gene_cluster'], grid = False)
    
    out = ''.join(['/mnt/c/Users/jbams/Documents/MerenLab/CP',CPS_REGION,'_python_boxplot.pdf'])
    plt.savefig(out, dpi=150)



