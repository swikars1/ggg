package controllers

import (
	"net/http"
	"strconv"
	"{{projectname}}/api/responses"
	"{{projectname}}/api/services"
	"{{projectname}}/infrastructure"
	"{{projectname}}/models"
	"{{projectname}}/utils"

	"github.com/gin-gonic/gin"
)

// {{ucresource}}Controller -> struct
type {{ucresource}}Controller struct {
	logger                  infrastructure.Logger
	{{ucresource}}Service  services.{{ucresource}}Service
}

// New{{ucresource}}Controller -> constructor
func New{{ucresource}}Controller(
	logger infrastructure.Logger,
	{{ucresource}}Service services.{{ucresource}}Service,
) {{ucresource}}Controller {
	return {{ucresource}}Controller{
		logger:                  logger,
		{{ucresource}}Service:  {{ucresource}}Service,
	}
}

// Create{{ucresource}} -> Create {{ucresource}}
func (cc {{ucresource}}Controller) Create{{ucresource}}(c *gin.Context) {
	{{lcresource}} := models.{{ucresource}}{}

	if err := c.ShouldBind(&{{lcresource}}); err != nil {
		cc.logger.Zap.Error("Error [Create{{ucresource}}] (ShouldBindJson) : ", err)
		responses.ErrorJSON(c, http.StatusBadRequest, "Failed To Create {{ucresource}}")
		return
	}

	if _, err := cc.{{ucresource}}Service.Create{{ucresource}}({{lcresource}}); err != nil {
		cc.logger.Zap.Error("Error [Create{{ucresource}}] [db Create{{ucresource}}]: ", err.Error())
		responses.ErrorJSON(c, http.StatusInternalServerError, "Failed To Create {{ucresource}}")
		return
	}

	responses.SuccessJSON(c, http.StatusOK, "{{ucresource}} Created Sucessfully")
}

// GetAll{{ucresource}} -> Get All {{ucresource}}
func (cc {{ucresource}}Controller) GetAll{{ucresource}}(c *gin.Context) {

	pagination := utils.BuildPagination(c)
	pagination.Sort = "created_at desc"
	{{plcresource}}, count, err := cc.{{ucresource}}Service.GetAll{{ucresource}}(pagination)

	if err != nil {
		cc.logger.Zap.Error("Error finding {{ucresource}} records", err.Error())
		responses.ErrorJSON(c, http.StatusBadRequest, "Failed to Find {{ucresource}}")
		return
	}
	responses.JSONCount(c, http.StatusOK, {{plcresource}}, count)

}

// GetOne{{ucresource}} -> Get One {{ucresource}}
func (cc {{ucresource}}Controller) GetOne{{ucresource}}(c *gin.Context) {
	ID, _ := strconv.ParseInt(c.Param("id"), 10, 64)
	{{lcresource}}, err := cc.{{ucresource}}Service.GetOne{{ucresource}}(ID)

	if err != nil {
		cc.logger.Zap.Error("Error [GetOne{{ucresource}}] [db GetOne{{ucresource}}]: ", err.Error())
		responses.ErrorJSON(c, http.StatusBadRequest, "Failed to Find {{ucresource}}")
		return
	}
	responses.JSON(c, http.StatusOK, {{lcresource}})

}

// UpdateOne{{ucresource}} -> Update One {{ucresource}} By Id
func (cc {{ucresource}}Controller) UpdateOne{{ucresource}}(c *gin.Context) {
	ID, _ := strconv.ParseInt(c.Param("id"), 10, 64)
	{{lcresource}} := models.{{ucresource}}{}

	if err := c.ShouldBind(&{{lcresource}}); err != nil {
		cc.logger.Zap.Error("Error [Update{{ucresource}}] (ShouldBindJson) : ", err)
		responses.ErrorJSON(c, http.StatusBadRequest, "failed to update {{lcresource}}")
		return
	}
	{{lcresource}}.ID = ID

	if err := cc.{{ucresource}}Service.UpdateOne{{ucresource}}({{lcresource}}); err != nil {
		cc.logger.Zap.Error("Error [Update{{ucresource}}] [db Update{{ucresource}}]: ", err.Error())
		responses.ErrorJSON(c, http.StatusInternalServerError, "failed to update {{lcresource}}")
		return
	}

	responses.SuccessJSON(c, http.StatusOK, "{{ucresource}} Updated Sucessfully")
}

// DeleteOne{{ucresource}} -> Delete One {{ucresource}} By Id
func (cc {{ucresource}}Controller) DeleteOne{{ucresource}}(c *gin.Context) {
	ID, _ := strconv.ParseInt(c.Param("id"), 10, 64)
	err := cc.{{ucresource}}Service.DeleteOne{{ucresource}}(ID)

	if err != nil {
		cc.logger.Zap.Error("Error [DeleteOne{{ucresource}}] [db DeleteOne{{ucresource}}]: ", err.Error())
		responses.ErrorJSON(c, http.StatusBadRequest, "Failed to Delete {{ucresource}}")
		return
	}

	responses.SuccessJSON(c, http.StatusOK, "{{ucresource}} Deleted Sucessfully")
}
