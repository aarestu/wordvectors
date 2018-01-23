#!/bin/bash

#### Set your hyper-parameters here ####
############## START ###################
lcode="id" # ISO 639-1 code of target language. See `lcodes.txt`.
wiki_dump_version="20180120" # version of wikimedia dumps
max_corpus_size=10000000000 # the maximum size of the corpus. Feel free to adjust it according to your computing power.
vector_size=300 # the size of a word vector
window_size=5 # the maximum distance between the current and predicted word within a sentence.
vocab_size=20000 # the maximum vocabulary size
num_negative=5 # the int for negative specifies how many “noise words” should be drawn
############## END #####################

echo "step 0. Install packages according to requirements.txt"
pip install -r requirements.txt

echo "step 0. Make `data` directory and move there."
mkdir data; cd data

echo "step 1. Download the stored wikipedia file to your disk."
rm -rf ${lcode}wiki-${wiki_dump_version}-pages-articles-multistream*
wget "https://dumps.wikimedia.org/${lcode}wiki/${wiki_dump_version}/${lcode}wiki-${wiki_dump_version}-pages-articles-multistream.xml.bz2"

echo "step 2. Extract the bz2 file."
bzip2 -d "${lcode}wiki-${wiki_dump_version}-pages-articles-multistream.xml.bz2"

cd ..
echo "step 3. Build Corpus."
python build_corpus.py --lcode=${lcode} --max_corpus_size=${max_corpus_size} --wiki_dump_version=${wiki_dump_version}

echo "step 4. make wordvectors"
python make_wordvectors.py --lcode=${lcode} --vector_size=${vector_size} --window_size=${window_size} --vocab_size=${vocab_size} --num_negative=${num_negative}

