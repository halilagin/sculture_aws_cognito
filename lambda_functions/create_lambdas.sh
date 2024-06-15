#!/bin/bash
rm -f *.zip
lambda_fn_dirs=`ls -d */|grep lambda_function_|tr -d /`


set -x
for lf in $lambda_fn_dirs; do
  cd $lf
  python_full_ver=`pipenv run python --version|cut -d\  -f 2 |tr -d '\n'`
  python_major=`echo $python_full_ver|cut -d. -f 1`
  python_minor=`echo $python_full_ver|cut -d. -f 2`
  python_version="python$python_major.$python_minor"
  lf_dir=`pwd`
  venv=`pipenv --venv`
  cd $venv/lib/$python_version/site-packages
  zip -r ${lf}.zip *
  mv ${lf}.zip  $lf_dir
  cd $lf_dir
  zip  ${lf}.zip lambda_function.py
  mv ${lf}.zip ../
  cd ..
done
