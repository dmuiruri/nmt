# This is a shell script used to execute various tools in the
# preprocessing and training of the model.

# set up environment

module purge
module use -a /proj/nlpl/software/modulefiles
module load nlpl-mttools

pre=./pre_europarl  # pre-processed files loc

# Normalize and tokenize  all the data files (.norm and ,tok files)
# for f in train* val* test*
# do
#     echo "normalizing file: $f"
#     lang=$(echo $f | awk -F\. '{print $2}')
#     normalize-punctuation.perl -l $lang < $f > $pre/$f.norm

#     echo "tokenizing file $pre/$f.norm"
#     tokenizer.perl -l $lang < $pre/$f.norm > $pre/$f.tok
# done


# # Create a truecase model (.model files)
# for f in train*
# do
#     echo "creating a true casing model for file $f"
#     train-truecaser.perl --corpus $f --model $pre/$f.model
# done


# Apply the truecasing models to all the tokenized data (.true files)
# for m in $pre/*.model
# do
#     echo ">> applying truecasing models to tokenised data using model: $m"
#     lang=$(echo $m | awk -F\. '{print $3}') # | awk -F\. '{print $1}')
#     for f in $pre/*$lang*.tok
#     do
# 	echo "truecasing file: $f"
# 	truecase.perl --model $m  < $f > $f.true.$lang
#     done
# done

# Clean the files of empty lines

# ToDo: this script expects file pairs are similar in name and only
# differ at the extention which is a language code
for f in $pre/train_europarl-v7.tok.true $pre/val_news2016.tok.true $pre/test_europarl-v7.tok.true
do
    echo ">> Cleaning file $f"
    clean-corpus-n.perl $f en fi $f.clean 1 100
done

# Train a BPE Models
# bpefiles=bpe
# cleanf=./pre/clean
# for f in $cleanf/train*true*
# do
#     echo ">> Training a BPE model on file: $f"
#     l=$(echo $f | awk -F\. '{print $7}') #$(echo $f | awk -F\- '{print$2}' | awk -F\. '{print $1}')
#     for ops in 3000 32000
#     do
# 	echo "Creating file $bpefiles/bpe$ops.$l.codes"
# 	subword-nmt learn-bpe -s $ops < $f > $pre/$bpefiles/bpe$ops.$l.codes
# 	for df in $cleanf/train_europarl.txt.tok.true.clean.$l $cleanf/test_europarl.txt.tok.true.clean.$l $cleanf/val_europarl.txt.tok.true.clean.$l
# 	do
# 	    echo "Applying the model: $bpefiles/bpe$ops.$l.codes to data $df"
# 	    resf=$(echo $df | awk -F\. '{print$2}' | awk -F\/ '{print $4}')
# 	    subword-nmt apply-bpe -c $pre/$bpefiles/bpe$ops.$l.codes < $df > $pre/$bpefiles/$resf.$l.bpe$ops.txt
# 	done
#     done
# done
