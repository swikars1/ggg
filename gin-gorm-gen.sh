#!/bin/bash -e
first_lower () {
  echo `echo $1 | awk '{$1=tolower(substr($1,0,1))substr($1,2)}1'`
}

printf "\n *** Go Gin GORM Scaffold Generator *** \n\n"
printf "This scaffolder assumes that you are using RTW clean-gin template.\n\n"
echo "Enter project name (eg: ecommerce-api):"; read project_name
echo "Enter resource name(eg: ProductCategory):"; read uc_resource
echo "Enter resource table name(eg: product_category):"; read resource_table
echo "Enter plural resource name(eg: ProductCategories):"; read plural_resource

lc_resource=$(first_lower $uc_resource)
plc_resource=$(first_lower $plural_resource)

printf "\n* Generating Scaffold for ${uc_resource} *\n"

value_replacer_hash=(
  "{{ucresource}}:$uc_resource"
  "{{plcresource}}:$plc_resource"
  "{{lcresource}}:$lc_resource"
  "{{projectname}}:$project_name"
  "{{resourcetable}}:$resource_table"
)
entity_path_hash=(
  "models:../models"
  "routes:../api/routes"
  "controllers:../api/controllers"
  "services:../api/services"
  "repository:../api/repository"
)
for entity in "${entity_path_hash[@]}"; do
  entity_name="${entity%%:*}"
  entity_path="${entity##*:}"
  file_to_write="$entity_path/${resource_table}.go"

  cat "./${entity_name}-template.txt" > $file_to_write
  for item in "${value_replacer_hash[@]}"; do
    from_val="${item%%:*}"
    to_val="${item##*:}"
    sed -i "" "s/$from_val/$to_val/g" $file_to_write
  done
  echo $file_to_write "created."
done

# inject fx deps
fx_path_hash=(
  "Controller:../api/controllers/controllers.go"
  "Service:../api/services/services.go"
  "Repository:../api/repository/repository.go"
)
fx_init_string="var Module = fx.Options("
for deps_value in "${fx_path_hash[@]}"; do
  deps_name="${deps_value%%:*}"
  deps_path="${deps_value##*:}"
  sed -i "" "s/${fx_init_string}/${fx_init_string}\n  fx.Provide(New${uc_resource}${deps_name}),/g" $deps_path
  echo $deps_path "updated."
done

# fx routes
fx_route_path="../api/routes/routes.go"
sed -i "" "s/func NewRoutes(/func NewRoutes(\n  ${lc_resource}Routes ${uc_resource}Routes,/g" $fx_route_path
sed -i "" "s/return Routes{/return Routes{\n    ${lc_resource}Routes,/g" $fx_route_path
sed -i "" "s/fx.Provide(NewRoutes),/fx.Provide(NewRoutes),\n  fx.Provide(New${uc_resource}Routes),/g" $fx_route_path
echo $fx_route_path "updated."


# # migration gen
# cd ..
# migration_name="create_${resource_table}_table"
# make auto-create GGG_NAME=$migration_name

# migration_up_filepath=`find . -name "*${migration_name}.up.sql"`
# migration_down_filepath=`find . -name "*${migration_name}.down.sql"`

# sed "s/{{resourcetable}}/$resource_table/g" ./ggg/up-migration-template.txt > "${migration_up_filepath}"
# echo "DROP TABLE IF EXISTS ${resource_table};" > $migration_down_filepath
# cd ggg/

printf "\n\n*** Scaffolding Completely Successfully ***\n"