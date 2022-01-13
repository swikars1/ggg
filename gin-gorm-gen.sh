#!/bin/bash

echo "Enter project name:"
read project_name

echo "Enter resource name(eg: ProductCategory):"
read resource

echo "Enter resource table name(eg: product_category):"
read resource_table

echo "Enter plural resource name(eg: ProductCategories):"
read plural_resource

sed "s/{{ucresource}}/$resource/g" ./route-template.txt > "./${resource_table}.go"
# sed -i "" "s/{{plcresource}}/${plural_resource,}/g" "./${resource_table}.go"
# sed -i "" "s/{{lcresource}}/${resource,}/g" "./${resource_table}.go"
# sed -i "" "s/{{resourcetable}}/$resource_table/g" "./${resource_table}.go"
# sed -i "" "s/{{projectname}}/$project_name/g" "./${resource_table}.go"

