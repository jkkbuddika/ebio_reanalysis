#!/usr/bin/python

'''
A simple program written by Kasun Buddika at Indiana University, Bloomington to automatically
count the total number of matches of a query sequence(s) .fastq file for a pre-defined oligo(s).

Usage Example
______________

On terminal:

    python Counter.py <input_dir> <query_sequences>

Args:
    <input_dir>         Path to the input directory
    <query_sequences>   A .csv file with query sequences (Column header must be "Sequence")

Sample <query_sequences> input:

SeqID       Sequence
1           TTCTTAAAGGTGTCCAGGG
2           GAAGTCAGACATGGACCTG

Example:

>>>Counter.py /Users/jbuddika/Documents/Conter_Trial/ /Users/jbuddika/Documents/Conter_Trial/keys.csv
Counting matching oligos/strings from DATSET1.fastq ...
Counting matching oligos/strings from DATSET2.fastq ...

Contact Kasun Buddika (jkkbuddika@gmail.com) for questions.

'''

from datetime import datetime
import glob
import os
import pandas as pd
import sys


class Counter:

    def __init__(self, file_path, oligo_file):
        self.file_path = file_path
        self.oligo_file = oligo_file

    def list_maker(self, file_extension):
        '''
        Generates a sorted list with files containing a defined file extension.
        Args:
            file_extension: A string specifying the file extension (i.e., .fastq)
        '''

        fileList = sorted(glob.glob(self.file_path + "*" + file_extension))
        return fileList

    def key_counter(self, data_file, key_list):
        '''
        Counts and returns a pandas data frame that contain file name and
        the match count.
        Args:
            data_file: A .fastq file
            key_list: A list of query sequences/strings to match
        '''

        words = dict.fromkeys(key_list,0)

        match_count = []

        file_name = os.path.basename(data_file)

        print("Counting matching oligos/strings from " + file_name + " ...")

        with open(data_file) as file:
            data = file.read()

            for key, val in words.items():
                count = data.count(key)
                match_count.append(count)

            count_df = pd.DataFrame({file_name: match_count})
            return count_df

    def count_cycler(self, col_header, file_extension):
        '''
        Counts and returns a concatenated pandas data frame that contain
        file names and the match counts along with corresponding oligo
        sequences.
        Args:
            col_header: The header of the query sequences/strings column in the .csv file
            file_extension: A string specifying the file extension (i.e., .fastq)
        '''

        file_list = self.list_maker(file_extension)

        key_df = pd.read_csv(self.oligo_file)
        key_list = key_df[col_header].tolist()

        list_of_df = [pd.DataFrame({"Keys": key_list})]

        for file in file_list:
            count_df = self.key_counter(file, key_list)
            list_of_df.append(count_df)

        count_data = pd.concat(list_of_df, axis=1)
        return count_data

    def csv_writer(self, df, output_path):
        '''
        Writes pandas data frames to .csv files with system date and time.
        Args:
            df: A pandas data frame
            output_path: Destination path to save the file
        '''

        date_time = datetime.now().strftime("%Y_%m_%d_%I_%M")
        df.to_csv(output_path + date_time + "_count_data.csv")
        return df


#########################
# Executing the program #
#########################
file_path = None
oligo_file = None
if len(sys.argv) > 2:
    file_path = sys.argv[1]
    oligo_file = sys.argv[2]
else:
    raise Exception("Missing either input directory path or .csv file path with query sequences!")

co = Counter(file_path, oligo_file)
result_df = co.count_cycler("Sequence", ".fastq")
co.csv_writer(result_df, file_path)