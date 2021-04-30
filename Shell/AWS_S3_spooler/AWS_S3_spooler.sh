#!/bin/bash

cmt_root_dir="/home/mike/Desktop/CMT"
workDir="/home/mike/Desktop/CMT/OUTBOUND"

ARG1=${1:-foo}

Download_files()
{
    #Download events
    aws s3 cp "${s3_src_path}" . --recursive --exclude "*" --include "pfz_sparrow_email_events*dat" --exclude "*attributes*"

    #Download events attributes
    aws s3 cp "${s3_src_path}" . --recursive --exclude "*" --include "pfz_sparrow_email_events_attributes*dat"

    #Download campaigns
    aws s3 cp "${s3_src_path}" . --recursive --exclude "*" --include "pfz_sparrow_campaigns*dat" --exclude "*attributes*"

    #Download campaigns attributes
    aws s3 cp "${s3_src_path}" . --recursive --exclude "*" --include "pfz_sparrow_campaigns_attributes*dat"

    #Download external segments
    aws s3 cp "${s3_src_ext_seg_path}" . --recursive --exclude "*" --include "pfz_map_external_segments*dat"
}

Prepare_files()
{
EVENTS_FILE="${cmt_root_dir}/SRC_FILES/EVENTS.txt"
EVENTS_ATTRIBUTES_FILE="${cmt_root_dir}/SRC_FILES/EVENTS_ATTRIBUTES.txt"
CAMPAIGNS_FILE="${cmt_root_dir}/SRC_FILES/CAMPAIGNS.txt"
CAMPAIGNS_ATTRIBUTES_FILE="${cmt_root_dir}/SRC_FILES/CAMPAIGNS_ATTRIBUTES.txt"
CAMPAIGNS_XX_FILE="${cmt_root_dir}/SRC_FILES/CAMPAIGNS_XX.txt"
CAMPAIGNS_ATTRIBUTES_XX_FILE="${cmt_root_dir}/SRC_FILES/CAMPAIGNS_ATTRIBUTES_XX.txt"
EXTERNAL_SEGMENTS_FILE="${cmt_root_dir}/SRC_FILES/EXTERNAL_SEGMENTS.txt"

#---------------------------------------------------#
cmt_events=$(ls | grep events | grep -v attributes)
    if [[ ${#cmt_events} -gt 0 ]]
    then
        if [[ -f "$EVENTS_FILE" ]]; then rm "$EVENTS_FILE"; fi
        for event in $cmt_events
        do
            echo "${workDir}/${event}" >> ${EVENTS_FILE}
        done
    fi
    #---------------------------------------------------#
cmt_events_attributes=$(ls | grep events_attributes)
    if [[ ${#cmt_events_attributes} -gt 0 ]]
    then
        if [[ -f "$EVENTS_ATTRIBUTES_FILE" ]]; then rm "$EVENTS_ATTRIBUTES_FILE"; fi
        for event_attributes in $cmt_events_attributes
        do
            echo "${workDir}/${event_attributes}" >> ${EVENTS_ATTRIBUTES_FILE}
        done
    fi
#---------------------------------------------------#
cmt_campaigns=$(ls | grep campaigns | grep -v attributes)
    if [[ ${#cmt_campaigns} -gt 0 ]]
    then
        if [[ -f "$CAMPAIGNS_FILE" ]]; then rm "$CAMPAIGNS_FILE"; fi
        for campaign in $cmt_campaigns
        do
            echo "${workDir}/${campaign}" >> ${CAMPAIGNS_FILE}
        done
    fi
#---------------------------------------------------#
cmt_campaigns_attributes=$(ls | grep campaigns_attributes)
    if [[ ${#cmt_campaigns_attributes} -gt 0 ]]
    then
        if [[ -f "$CAMPAIGNS_ATTRIBUTES_FILE" ]]; then rm "$CAMPAIGNS_ATTRIBUTES_FILE"; fi
        for campaign_attributes in $cmt_campaigns_attributes
        do
            echo "${workDir}/${campaign_attributes}" >> ${CAMPAIGNS_ATTRIBUTES_FILE}
        done
    fi
#---------------------------------------------------#
cmt_campaigns_xx=$(ls | grep campaigns_xx)
    if [[ ${#cmt_campaigns_xx} -gt 0 ]]
    then
        if [[ -f "$CAMPAIGNS_XX_FILE" ]]; then rm "$CAMPAIGNS_XX_FILE"; fi
        for campaign_xx in $cmt_campaigns_xx
        do
            echo "${workDir}/${campaign_xx}" >> ${CAMPAIGNS_XX_FILE}
        done
    fi
#---------------------------------------------------#
cmt_campaigns_attributes_xx=$(ls | grep campaigns_attributes_xx)
    if [[ ${#cmt_campaigns_attributes_xx} -gt 0 ]]
    then
        if [[ -f "$CAMPAIGNS_ATTRIBUTES_XX_FILE" ]]; then rm "$CAMPAIGNS_ATTRIBUTES_XX_FILE"; fi
        for campaign_attributes_xx in $cmt_campaigns_attributes_xx
        do
            echo "${workDir}/${campaign_attributes_xx}" >> ${CAMPAIGNS_ATTRIBUTES_XX_FILE}
        done
    fi
#---------------------------------------------------#
cmt_external_segments=$(ls | grep external_segments)
    if [[ ${#cmt_external_segments} -gt 0 ]]
    then
        if [[ -f "$EXTERNAL_SEGMENTS_FILE" ]]; then rm "$EXTERNAL_SEGMENTS_FILE"; fi
        for external_segment in $cmt_external_segments
        do
            echo "${workDir}/${external_segment}" >> ${EXTERNAL_SEGMENTS_FILE}
        done
    fi
}

if [ $# -eq 0 ]
then
    cd $workDir && rm -rf *.dat
    s3_src_path="s3://static_s3_path/OUTBOUND/$(date +%Y)/$(date +%m | sed 's/'^0'//g')/$(date +%d | sed 's/'^0'//g')/"
    s3_src_ext_seg_path="s3://static_s3_path/OUTBOUND/$(date +%Y)/$(date +%m)/$(date +%d)/"
    echo "Spooling data from "$(date +%Y)-$(date +%m)-$(date +%d)

    Download_files && Prepare_files

elif [[ $1 =~ ^[0-9]{8}$ ]]
then
    cd $workDir && rm -rf *.dat
    arg_Y=$(echo $1 | cut -c1-4)
    arg_M=$(echo $1 | cut -c5-6)
    arg_D=$(echo $1 | cut -c7-8)

    s3_src_path="s3://static_s3_path/OUTBOUND/${arg_Y}/$(echo $arg_M | sed 's/'^0'//g')/$(echo $arg_D | sed 's/'^0'//g')/"
    s3_src_ext_seg_path="s3://static_s3_path/OUTBOUND/${arg_Y}/${arg_M}/${arg_D}/"
    echo "Spooling data from ${arg_Y}-${arg_M}-${arg_D}"

    Download_files && Prepare_files

else
    echo "Invalid parameter. Should be provided in YYYYMMDD format, or not provided at all in order to spool newest files."
fi

