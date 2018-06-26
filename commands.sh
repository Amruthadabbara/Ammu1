svn co https://genomeinfo.qimrberghofer.edu.au/svn/genomeinfo/production/aws/germline-dna-fastq-to-maf
cd .aws
aws
cd ..
pwd
module load python/3.5.0
module load jq
export EC2KEY=ammu-ec2
inputsrc=$(mktemp -d -p ~ workflow.XXXXXX)
cd $HOME/germline-dna-fastq-to-maf
cp example_data/five-dollar-genome-analysis-pipeline-1.0.0.0/germline_single_sample_workflow_fastq.wdl \
example_data/five-dollar-genome-analysis-pipeline-1.0.0.0/germline_single_sample_workflow_fastq.hg38.inputs.json \
example_data/five-dollar-genome-analysis-pipeline-1.0.0.0/wdl-dependencies.zip $inputsrc/.
cd $HOME/germline-dna-fastq-to-maf
export INPUTSRC=s3://qgha/inputs/`uuidgen`
aws s3 sync $inputsrc $INPUTSRC
aws ec2 run-instances \
        --cli-input-json "$(envsubst '${EC2KEY}' < launch.general-purpose.json)" \
        --user-data "$(envsubst '${INPUTSRC}' < user-data.general-purpose.sh)"
