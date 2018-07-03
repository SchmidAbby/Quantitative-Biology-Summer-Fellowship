import numpy as np 
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt 
import pandas as pd
import seaborn as sns

for CPS_REGION in ['A','B','C','D','E','F','G','H']:
    data_file = ''.join(['../MerenLab/synteny_plots_and_summary_tables/CP',CPS_REGION,'_NONREDUNDANT_gene_clusters_summary.txt'])
    data = pd.read_table(data_file, index_col = 1)
    plt.figure()
    plot = sns.boxplot(x='gene_callers_id', y='num_genes_in_gene_cluster', data=data)
    plot = sns.stripplot(x='gene_callers_id', y='num_genes_in_gene_cluster', data=data, color="gray", jitter=0.2, size=2.5)
    figure = plot.get_figure()
    path = ''.join(['/mnt/c/Users/jbams/Documents/MerenLab/CP',CPS_REGION,'_python_seaborn_boxplot.png'])
    figure.savefig(path)
 
