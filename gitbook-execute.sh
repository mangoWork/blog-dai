#!/bin/sh

dai_base=/home/dlm/work/blog
flag_path=${dai_base}/blog-dai/version
dai_v_base=/home/dlm/.dai
version_path=${dai_v_base}/v_md5
gitbook_v_path=${dai_v_base}/g_md5
version=$(cat ${flag_path})
cd $dai_base/blog-dai
git fetch --all
git reset --hard origin/gitbook-dai

if [ ! -d $dai_v_base ]; then
    mkdir -p ${version_path}
fi 

if [ -d $version_path ]; then
    rm -rf $version_path
elif [ ! -f $version_path ]; then
    touch $version_path
    flag=1
fi

if [ -d $gitbook_v_path ]; then
    rm -rf $gitbook_v_path
elif [ ! -f $gitbook_v_path ]; then
    touch $gitbook_v_path
fi




# $1 需要监测的文件
# $2 存放文件md5值，用于判断文件是否更改
# $3 可选文件更新后，需要执行的命令（用'service nginx restart' 用单引号包起来）
# $1 标识创建的文件，$2标识md5存放目录
function creatMd5file(){
     md5sum -b $1 > $2
}

function get_change(){    

    if [ ! $2 ]; then
        creatMd5file $1 $2
        return 1
    fi
    
    md5sum -c $2 --status
    # 检测文件是否修改，$?返回1 表示修改, 0表示未修改
    if [ $? -gt 0 ] ; then        
        creatMd5file $1 $2
        return 1
    fi
    return 0
}

get_change ${flag_path} ${version_path}
v_flag=$?
get_change ${dai_base}/blog-dai/book.json ${gitbook_v_path}
g_flag=$?

cd ${dai_base}/blog-dai
 
if [[ $g_flag -gt 0 ]]; then        
    gitbook install
fi

if [[ $v_flag -gt 0 ]]; then    
    gitbook build  --output=${dai_base}/blog-dai
fi


