#!/bin/bash

echo "Enter project name:"
read project_name

echo "Enter resource name(eg: ProductCategory):"
read uc_resource

echo "Enter resource table name(eg: product_category):"
read resource_table

echo "Enter plural resource name(eg: ProductCategories):"
read plural_resource

lc_resource=`echo $uc_resource | awk '{$1=tolower(substr($1,0,1))substr($1,2)}1'`
plc_resource=`echo $plural_resource | awk '{$1=tolower(substr($1,0,1))substr($1,2)}1'`


# routes gen
sed "s/{{ucresource}}/$uc_resource/g" ./route-template.txt > "./${resource_table}.go"
sed -i "" "s/{{lcresource}}/$lc_resource/g" "./${resource_table}.go"
sed -i "" "s/{{projectname}}/$project_name/g" "./${resource_table}.go"

# controller gen
sed "s/{{ucresource}}/$uc_resource/g" ./controller-template.txt > "./${resource_table}.go"
sed -i "" "s/{{plcresource}}/$plc_resource/g" "./${resource_table}.go"
sed -i "" "s/{{lcresource}}/$lc_resource/g" "./${resource_table}.go"
sed -i "" "s/{{projectname}}/$project_name/g" "./${resource_table}.go"

# service gen
sed "s/{{ucresource}}/$uc_resource/g" ./service-template.txt > "./${resource_table}.go"
sed -i "" "s/{{lcresource}}/$lc_resource/g" "./${resource_table}.go"
sed -i "" "s/{{projectname}}/$project_name/g" "./${resource_table}.go"

# repo gen
sed "s/{{ucresource}}/$uc_resource/g" ./repo-template.txt > "./${resource_table}.go"
sed -i "" "s/{{plcresource}}/$plc_resource/g" "./${resource_table}.go"
sed -i "" "s/{{resourcetable}}/$resource_table/g" "./${resource_table}.go"
sed -i "" "s/{{projectname}}/$project_name/g" "./${resource_table}.go"