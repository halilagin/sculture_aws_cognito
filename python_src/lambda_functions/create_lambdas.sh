lambda_fn_dirs=`ls -d *|grep lambda_function_`

for lf in $lambda_fn_dirs; do 
  cd $lf
  zip ${lf}.zip lambda_function.py
  mv ${lf}.zip ../
  cd ..
done
