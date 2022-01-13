#!/bin/bash

echo "Enter resource name(eg: ProductCategory):"
read resource

echo "Enter resource table name(eg: product_category):"
read resource_table

echo "Enter plural resource name(eg: ProductCategories):"
read plural_resource

sed -i `s/{{ucresource}}/new-text/g` input.txt
