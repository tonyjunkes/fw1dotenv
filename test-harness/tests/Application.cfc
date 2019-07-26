component {
    this.name = "FW1DotenvTestingSuite" & hash(getCurrentTemplatePath());
    this.mappings = {
        "/tests": getDirectoryFromPath( getCurrentTemplatePath() ),
        "/resources": "./resources",
        "/testbox": "../testbox",
        "/framework": "../framework",
        "/model": "../../model"
    };
}