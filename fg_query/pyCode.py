# -*- coding: utf-8 -*-
'''
Zewei Song
2/14/2015
songzewei@outlook.com
'''
# ##################################################################################
# ################################ import modules ##################################
import os
import sys
import urllib
from operator import itemgetter

# ##################################################################################
# ########################## import db from funguild.org ###########################
if otu_delims == "TRUE":
    otu_delimiter = "\t"
else:
    print "Please input a tab delimited text file."

# temp file to store database file
function_file = 'temp_db.txt'

temp = 'temp.txt'
url = "http://www.stbates.org/funguild_db.php"
urllib.urlretrieve(url, temp)

f = open(temp, 'r')
data = f.read()
f.close()

os.remove(temp)

new_data = data.split("} , {")

# Fix the first and last record
new_data[0] = new_data[0][3:]
new_data[-1] = new_data[-1][:-3]

# Parse the record
parse_data = []
for line in new_data:
    record = line
    rec = record.split(" , ")
    del rec[0]

    current_rec = []
    for item in rec:
        p = item.find(":")
        current_rec.append(item[p + 2:].replace('"', ''))
    parse_data.append(current_rec)

header = "taxon\ttaxon level\ttrophic mode\tguild\tconfidence ranking\tgrowth morphology\ttrait\tnotes\tcitation/source"

f = open(function_file, 'a')
f.write("%s\n" % (header))
for item in parse_data:
    f.write("%s\n" % ("\t".join(item)))
f.close()

# ########## file sometimes has \r instead of \n a problem for Windows ###########
# ########################### replace all \r with \n #############################
f_database = open(function_file, 'r')
new_line = []
for line in f_database:
    new_line.append(line.replace('\r', '\n'))

f_database.close()

output = open(function_file, 'w')
for item in new_line:
    output.write('%s' % item)
output.close()

# ######################## detect the position of header ##########################
# ############################ open the database file #############################
header_database = []
f_database = open(function_file, 'r')
for line in f_database:
    # ### search for the line that contains the header (if not the first line) ####
    if line.find('taxon') != -1:
        header_database = line.split('\t')
        break
f_database.close()

# ########################## check the database header ############################
if len(header_database) == 1:
    header_database = header_database[0].split(" ")

# #################### set the parameters for progress report #####################
with open(function_file) as f1:
    i = 0
    for line in f1:
        i += 1
# ############################ length of the database #############################
total_length = float(i)

p = range(1, 11)
way_points = [int(total_length * (x / 10.0)) for x in p]

# ##################################################################################
# ##################### open the OTU table and read in the header ##################
# ################################ load the header #################################
with open(otu_file) as otu:
    header = otu.next().rstrip('\n').split(otu_delimiter)

# ####### attach all columns of db file to the header of the new OTU table #########
for item in header_database:
    header.append(item)

# ########### get the positions of the taxonomy column and notes column ############
index_tax = header.index('taxonomy')
index_notes = header.index('notes')

# ################# abort if the column 'taxonomy' is not found ####################
if index_tax == -1:
    print "Unable to find 'taxonomy' column. Please check your OTU table %s." % fNam
    sys.exit(0)

# ##################################################################################
# ########################## search in function database ###########################
# #### read the OTU table into memory, and separate taxonomic levels with '@' ######
with open(otu_file) as otu:
    otu_tab = []
    for record in otu:
        otu_current = record.split(otu_delimiter)
        otu_taxonomy = otu_current[index_tax].rstrip('\n')
        replace_list = ['_', ' ', ';', ',']
        for symbol in replace_list:
            otu_taxonomy = otu_taxonomy.replace(symbol, '@')
            otu_taxonomy = otu_taxonomy + '@'
            otu_current[index_tax] = otu_taxonomy
            otu_tab.append(otu_current)
    # ########################## remove the header line ############################
    otu_tab = otu_tab[1:]

# ##################################################################################

# ######################### start searching the database ###########################
# ###### each record in the FUNGuild DB is searched in the user's OTU table ########

# ################## count of matching records in the OTU table ####################
count = 0
# ########################## line number in the database ###########################
percent = 0

otu_redundant = []
otu_new = []

print "Searching the FUNGuild database..."

f_database = open(function_file, 'r')
for record in f_database:

    # ##################################################################################
    # ############################# report the progress ################################
    percent += 1
    if percent in way_points:
        progress = (int(round(percent / total_length * 100.0)))
        print '{}%'.format(progress)
    else:
        t = 0

    # ##################################################################################
    # ###################### compare database with the OTU table #######################
    function_tax = record.split('\t')
    # ########### first column of database, contains the name of the species ###########
    search_term = function_tax[0].replace(' ', '@')
    # ########################### add @ to the search term #############################
    search_term = '@' + search_term + '@'

    for otu in otu_tab:
        # ############### get the taxonomy string of current OTU record ################
        otu_tax = otu[index_tax]
        # ################## found the keyword in this OTU's taxonomy ##################
        if otu_tax.find(search_term) >= 0:
            # ####################### count the matching record ########################
            count += 1
            otu_new = otu[:]

            # ##########################################################################
            # #### assign the matching functional information to current OTU record ####
            for item in function_tax:
                otu_new.append(item)
            otu_redundant.append(otu_new)
f_database.close()

# ##################################################################################
# ########### finish searching, delete the temp function database file #############
if os.path.isfile('temp_db.txt') == True:
    os.remove('temp_db.txt')

# ##################################################################################
# ###################### dereplicate and write to output file ######################
# ######### sort by OTU names and taxonomic level, from species to kingdom #########
otu_sort = otu_redundant[:]
# ################ sort the redundant OTU table by taxonomic level #################
otu_sort.sort(key=itemgetter(index_tax), reverse=True)
# ##################### sort the redundant OTU table by OTU ID #####################
otu_sort.sort(key=itemgetter(0))
# #### dereplicate the OTU table, unique OTU ID keeping lowest taxonomic level #####
otu_id_list = []
unique_list = []
count = 0

for item in otu_sort:
    if item[0] not in otu_id_list:
        count += 1
        otu_id_list.append(item[0])
        unique_list.append(item)

# ##################################################################################
# ##### copy the original taxonomy string (without @) to the unique OTU table ######
otu_tax = []
with open(otu_file) as f_otu:
    for otu in f_otu:
        temp = otu.rstrip('\n').split(otu_delimiter)
        otu_tax.append(temp)
    otu_tax = otu_tax[1:]

for new_rec in unique_list:
    for rec in otu_tax:
        if new_rec[0] == rec[0]:
            new_rec[index_tax] = rec[index_tax]

# ##################################################################################
# ######## sort the new otu table by the total sequence number of each OTU #########
unique_list.sort(key=lambda x: int(sum(map(int, x[1:index_tax]))), reverse=True)

# ##################################################################################
# ############################# write to output files ##############################
# ####################### output matched OTUs to a new file ########################
if os.path.isfile(matched_file_name) == True:
    os.remove(matched_file)
output = open(matched_file, 'a')
# ######################### write the matched list header ##########################
output.write('%s' % ('\t'.join(header)))

# ########################## write the matched OTU table ###########################
for item in unique_list:
    rec = '\t'.join(item)
    output.write('%s' % rec)
output.close()

# ##################### output unmatched OTUs to a new file #######################
unmatched_list = []

for rec in otu_tax:
    count2 = 0
    for new_rec in unique_list:
        # ########## check if the current record has been assigned a function #############
        if rec[0] == new_rec[0]:
            count2 += 1
    if count2 == 0:
        unmatched_list.append(rec)

count_unmatched = 0

# ##################### add 'Unassigned' to the 'Notes' column #####################
for item in unmatched_list:
    l = len(header) - len(item)
    for i in range(l):
        item.extend('-')
    item[index_notes] = 'Unassigned'

if os.path.isfile(unmatched_file_name) == True:
    os.remove(unmatched_file)
output_unmatched = open(unmatched_file, 'a')
output_unmatched.write('%s' % ('\t'.join(header)))
for item in unmatched_list:
    rec = '\t'.join(item)
    output_unmatched.write('%s\n' % rec)
    count_unmatched += 1
output_unmatched.close()

# ######### output the combined matched and unmatched OTUs to a new file ###########
if os.path.isfile(total_file_name) == True:
    os.remove(total_file)

# ########################## combine the two OTU tables ############################
total_list = unique_list + unmatched_list
# ######################### sorted the combined OTU table ##########################
total_list.sort(key=lambda x: int(sum(map(int, x[1:index_tax]))), reverse=True)

output_total = open(total_file, 'a')
output_total.write('%s' % ('\t'.join(header)))

count_total = 0
for item in total_list:
    rec = ('\t'.join(item)).strip('\n')
    output_total.write('%s\n' % rec)
    count_total += 1
output_total.close()
# ############################### finish the program ################################
